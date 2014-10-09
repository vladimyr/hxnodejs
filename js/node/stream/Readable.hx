package js.node.stream;

import js.node.Buffer;
import js.node.events.EventEmitter;
import js.node.stream.Writable;

/**
	Enumeration for Readable class events.
**/
@:enum abstract ReadableEvent(String) to String {
	/**
		When a chunk of data can be read from the stream, it will emit a `readable` event.
		In some cases, listening for a `readable` event will cause some data to be read into
		the internal buffer from the underlying system, if it hadn't already.
	**/
	var Readable = "readable";

	/**
		Listener argument:
			- chunk (Buffer or String) - The chunk of data.

		If you attach a `data` event listener, then it will switch the stream into flowing mode,
		and data will be passed to your handler as soon as it is available.
	**/
	var Data = "data";

	/**
		This event fires when there will be no more data to read.

		Note that the end event will not fire unless the data is completely consumed.
		This can be done by switching into flowing mode, or by calling read() repeatedly until you get to the end.
	**/
	var End = "end";

	/**
		Emitted when the underlying resource (for example, the backing file descriptor) has been closed. Not all streams will emit this.
	**/
	var Close = "close";

	/**
		Emitted if there was an error receiving data.
	**/
	var Error = "error";
}

/**
	The Readable stream interface is the abstraction for a source of data that you are reading from. In other words, data comes out of a Readable stream.
	A Readable stream will not start emitting data until you indicate that you are ready to receive it.
	Readable streams have two "modes": a flowing mode and a non-flowing mode. When in flowing mode, data is read from the underlying system
	and provided to your program as fast as possible. In non-flowing mode, you must explicitly call stream.read() to get chunks of data out.
	Examples of readable streams include:
		- http responses, on the client
		- http requests, on the server
		- fs read streams
		- zlib streams
		- crypto streams
		- tcp sockets
		- child process stdout and stderr
		- process.stdin
**/
@:jsRequire("stream", "Readable")
extern class Readable extends EventEmitter implements IReadable {

	/**
		The read() method pulls some data out of the internal buffer and returns it.
		If there is no data available, then it will return null.

		If you pass in a `size` argument, then it will return that many bytes.
		If `size` bytes are not available, then it will return null.

		If you do not specify a `size` argument, then it will return all the data in the internal buffer.

		This method should only be called in non-flowing mode.
		In flowing-mode, this method is called automatically until the internal buffer is drained.
	**/
	@:overload(function(?size:Int):Null<Buffer> {})
	function read(?size:Int):Null<String>;

	/**
		Call this function to cause the stream to return strings of the specified encoding instead of `Buffer` objects.
		For example, if you do readable.setEncoding('utf8'), then the output data will be interpreted as UTF-8 data,
		and returned as strings. If you do readable.setEncoding('hex'), then the data will be encoded in hexadecimal string format.

		This properly handles multi-byte characters that would otherwise be potentially mangled if you simply pulled
		the Buffers directly and called buf.toString(encoding) on them.

		If you want to read the data as strings, always use this method.
	**/
	function setEncoding(encoding:String):Void;

	/**
		This method will cause the readable stream to resume emitting `data` events.
		This method will switch the stream into flowing-mode.
		If you do not want to consume the data from a stream, but you do want to get to its `end` event,
		you can call readable.resume() to open the flow of data.
	**/
	function resume():Void;

	/**
		This method will cause a stream in flowing-mode to stop emitting `data` events.
		Any data that becomes available will remain in the internal buffer.
		This method is only relevant in flowing mode. When called on a non-flowing stream,
		it will switch into flowing mode, but remain paused.
	**/
	function pause():Void;

	/**
		This method pulls all the data out of a readable stream, and writes it to the supplied destination,
		automatically managing the flow so that the destination is not overwhelmed by a fast readable stream.

		This function returns the destination stream, so you can set up pipe chains.

		By default `end()` is called on the destination when the source stream emits `end`,
		so that destination is no longer writable. Pass `{ end: false }` as `options` to keep the destination stream open.
	**/
	function pipe<T:IWritable>(destination:T, ?options:{end:Bool}):T;

	/**
		This method will remove the hooks set up for a previous pipe() call.
		If the destination is not specified, then all pipes are removed.
		If the destination is specified, but no pipe is set up for it, then this is a no-op.
	**/
	function unpipe(?destination:IWritable):Void;

	/**
		This is useful in certain cases where a stream is being consumed by a parser,
		which needs to "un-consume" some data that it has optimistically pulled out of the source,
		so that the stream can be passed on to some other party.

		If you find that you must often call `stream.unshift(chunk)` in your programs,
		consider implementing a `Transform` stream instead.
	**/
	@:overload(function(chunk:Buffer):Void {})
	function unshift(chunk:String):Void;

	/**
		If you are using an older Node library that emits `data` events and has a `pause()` method that is advisory only,
		then you can use the `wrap()` method to create a `Readable` stream that uses the old stream as its data source.
	**/
	function wrap(stream:Dynamic):Readable;
}


/**
    Readable interface used for type parameter constraints.
    See `Readable` for actual class documentation.
**/
@:remove
extern interface IReadable extends IEventEmitter {
    @:overload(function(?size:Int):Null<Buffer> {})
    function read(?size:Int):Null<String>;
    function setEncoding(encoding:String):Void;
    function resume():Void;
    function pause():Void;
    function pipe<T:IWritable>(destination:T, ?options:{end:Bool}):T;
    function unpipe(?destination:IWritable):Void;
    @:overload(function(chunk:Buffer):Void {})
    function unshift(chunk:String):Void;
    function wrap(stream:Dynamic):IReadable;
}
