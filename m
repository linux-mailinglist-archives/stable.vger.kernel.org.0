Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2C75155CA
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 23:45:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726046AbfEFVpQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 17:45:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:42972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725994AbfEFVpQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 17:45:16 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A0F90206BF;
        Mon,  6 May 2019 21:45:12 +0000 (UTC)
Date:   Mon, 6 May 2019 17:45:11 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@kernel.org>,
        Nicolai Stange <nstange@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Shuah Khan <shuah@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Juergen Gross <jgross@suse.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nayna Jain <nayna@linux.ibm.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Joerg Roedel <jroedel@suse.de>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, stable <stable@vger.kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>
Subject: Re: [RFC][PATCH 1/2] x86: Allow breakpoints to emulate call
 functions
Message-ID: <20190506174511.2f8b696b@gandalf.local.home>
In-Reply-To: <CAHk-=wi5KBWUOvM94aTOPnoJ5L_aQG=vgLQ4SxxZDeQD0pF2tQ@mail.gmail.com>
References: <20190502181811.GY2623@hirez.programming.kicks-ass.net>
        <20190502185225.0cdfc8bc@gandalf.local.home>
        <20190502193129.664c5b2e@gandalf.local.home>
        <20190502195052.0af473cf@gandalf.local.home>
        <20190503092959.GB2623@hirez.programming.kicks-ass.net>
        <20190503092247.20cc1ff0@gandalf.local.home>
        <2045370D-38D8-406C-9E94-C1D483E232C9@amacapital.net>
        <CAHk-=wjrOLqBG1qe9C3T=fLN0m=78FgNOGOEL22gU=+Pw6Mu9Q@mail.gmail.com>
        <20190506081951.GJ2606@hirez.programming.kicks-ass.net>
        <20190506095631.6f71ad7c@gandalf.local.home>
        <CAHk-=wgw_Jmn1iJWanoSFb1QZn3mbTD_JEoMsWcWj5QPeyHZHA@mail.gmail.com>
        <20190506130643.62c35eeb@gandalf.local.home>
        <CAHk-=whesas+GDtHZks62wqXWXe4d_g3XJ359GX81qj=Fgs6qQ@mail.gmail.com>
        <20190506145745.17c59596@gandalf.local.home>
        <CAHk-=witfFBW2O5v6g--FmqnAFsMkKNLosTFfWyaoJ7euQF8kQ@mail.gmail.com>
        <20190506162915.380993f9@gandalf.local.home>
        <CAHk-=wi5KBWUOvM94aTOPnoJ5L_aQG=vgLQ4SxxZDeQD0pF2tQ@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 6 May 2019 13:42:12 -0700
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Mon, May 6, 2019 at 1:29 PM Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > Because that call to ftrace_stub is also dynamic.  
> 
> You're missing the point.
> 
> We are rewriting a single "cal" instruction to point to something.
> 
> The "int3" emulation should call THE SAME THING.
> 
> Right now it doesn't.

To do that we would need to rewrite the logic to update each of those
40,000 calls one at a time, or group them together to what gets
changed. As each function can call a different trampoline. One of the
custom trampolines associated with a ftrace_ops, or the list one when a
function has more than one ftrace_ops attached to it.

The ftrace code does this in batches:

 1) Add int3 to all functions being affected (could be 40,000 of
    them) (sync the cores)

 (Now all those functions are going through the int3 handler)

 2) Modify the address of those call sites (sync the cores)

 (Still going through the int3 handlers)

 3) Remove the int3

Now each of those functions are calling something, and they may not all
be the same thing they are calling.

> 
> > Part of the code will change it to call the function needed directly.
> >
> > struct ftrace_ops my_ops {
> >         .func = my_handler
> > };
> >
> >         register_ftrace_function(&my_ops);
> >
> > Will change "call ftrace_stub" into "call my_handler"  
> 
> But that's not what you're actually *doing*.
> 
> Instead, you're now _emulating_ calling ftrace_regs_caller, which will
> call that ftrace_stub, which in turn will try to update the call site.

The call site gets updated before the loop gets called (at least it
should, I have to go and look at the code, but I'm 99% that it does).
There should not be a breakpoint on the call to ftrace_stub when we add
breakpoints to the functions that call the ftrace_regs_caller.

> 
> But that's insane. It's insane because
> 
>  - it's not even what your call rewriting is doing Why aren't you just
> doing the emulation using the *SAME* target that you're rewriting the
> actual call instruction with?
> 
>  - even if ftrace_regs_caller ends up being that same function, you'd
> be better off just passing the "struct pt_regs" that you *ALREADY
> HAVE* directly to ftrace_stub in the int3 handler, rather than create
> *another* pt_regs stack

Are you saying to call the ftrace_ops handlers from int3 directly?


> 
> See? In that second case, why don't you just use "int3_emulate_call()"
> to do the reguired 'struct pt_regs' updates, and then call
> ftrace_stub() *with* that fixed-up pt_regs thing?
> 
> In other words, I think you should always do "int3_emulate_call()"
> with the *exact* same address that the instruction you are rewriting
> is using. There's no "three different cases". The only possible cases
> are "am I rewriting a jump" or "am I rewriting a call".
> 
> There is no "am I rewriting a call to one address, and then emulating
> it with a call to another address" case that makes sense.
> 
> What *can* make sense is "Oh, I'm emulating a call, but I know that
> call will be rewritten, so let me emulate the call and then
> short-circuit the emulation immediately".
> 
> But that is not what the ftrace code is doing. The ftrace code is
> doing something odd and insane.
> 
> And no, your "explanation" makes no sense. Because it doesn't actually
> touch on the fundamental insanity.

Also, talking with Peter about the ftrace_32.S version of
ftrace_regs_caller, makes Peter's patch sound even better.

The "ftrace_regs_caller" was created to allow kprobes to use the
function tracer when a probe was added to the start of a function
(which is a common occurrence). That is, kprobes uses int3 to inject a
handler pretty much anywhere in the code. kprobes can even be used for
dynamic trace events.

Now we found that if we use function tracing, it's faster to do the
call then to take the int3 hit. So kprobes knows of ftrace, and will
register a callback if it happens to be placed on a fentry call site.

Thus, Masami asked me to create a way to have ftrace be able to
simulate an int3. As kprobe handlers can do pretty much anything (bpf
uses them), I had to make that call from ftrace look like a real int3
just happened.

As ftrace_caller, is optimized for fast function tracing, I needed to
make another trampoline for the slower "emulate int3" operation, and
that was the birth of ftrace_regs_caller. For x86_64, it was really
straight forward and I had that done rather quickly. For i386, it was
much more difficult, and that was because of not having regs->sp on the
stack. I had to play this game to be able to pass in a pt_regs that
would be the same regardless if it was called by ftrace or an int3.

The problem was the call to ftrace_regs_caller would place the return
code on the stack, but I had to move it, because the kprobes handlers,
expected &regs->sp to point to the location of the stack just before
the call was hit!  This means, regs->flags was were the return code
was.

When we enter ftrace_regs_caller from the function being traced, the
top of the stack has the return code. But then we needed to do this:

	pushl	$__KERNEL_CS
	pushl	4(%esp)				/* Save the return ip */
	pushl	$0				/* Load 0 into orig_ax */
	pushl	%gs
	pushl	%fs
	pushl	%es
	pushl	%ds
	pushl	%eax

The above push regs->cs, regs->ip (the return code), then regs->gs...
to regs->ax, where now I finally have saved a scratch register to use.


	/* Get flags and place them into the return ip slot */
	pushf
	popl	%eax
	movl	%eax, 8*4(%esp)

I would then save flags into %eax and move it to where the return
address was placed by the call to this trampoline.

At the end, I had to undo this song and dance as well:

	/* restore flags */
	push	14*4(%esp)
	popf

	/* Move return ip back to its original location */
	movl	12*4(%esp), %eax
	movl	%eax, 14*4(%esp)


If we go with Peter's patch, I can make this code much more sane, and
not have to worry about having &regs->sp be at the top of the stack. I
could simply, just push everything in the order of pt_regs and call the
handler.

-- Steve
