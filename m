Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09ED715727
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 03:04:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726403AbfEGBEW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 21:04:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:43376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726073AbfEGBEW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 21:04:22 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 09DBE206BF;
        Tue,  7 May 2019 01:04:17 +0000 (UTC)
Date:   Mon, 6 May 2019 21:04:16 -0400
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
Message-ID: <20190506210416.2489a659@oasis.local.home>
In-Reply-To: <CAHk-=wj3R_s0RTJOmTBNaUPhu4fz2shNBUr4M6Ej65UYSNCs-g@mail.gmail.com>
References: <20190502181811.GY2623@hirez.programming.kicks-ass.net>
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
        <20190506174511.2f8b696b@gandalf.local.home>
        <CAHk-=wj3R_s0RTJOmTBNaUPhu4fz2shNBUr4M6Ej65UYSNCs-g@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 6 May 2019 15:06:57 -0700
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Mon, May 6, 2019 at 2:45 PM Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > To do that we would need to rewrite the logic to update each of those
> > 40,000 calls one at a time, or group them together to what gets
> > changed.  
> 
> Stephen, YOU ARE NOT LISTENING.

 (note, it's Steven ;-)

I'm listening, I'm just trying to understand.

> 
> You are already fixing the value of the call in the instruction as
> part of the instruction rewriting.
> 
> When you do things like this:
> 
>         unsigned long ip = (unsigned long)(&ftrace_call);
>         unsigned char *new;
>         int ret;
> 
>         new = ftrace_call_replace(ip, (unsigned long)func);
>         ret = update_ftrace_func(ip, new);
> 
> you have already decided to rewrite the instruction with one single
> fixed call target: "func".
> 
> I'm just saying that you should ALWAYS use the same call target in the
> int3 emulation.
> 
> Instead, you hardcode something else than what you are AT THE SAME
> TIME rewriting the instruction with.
> 
> See what I'm saying?

Yes, but that's not the code I'm worried about.

ftrace_replace_code() is, which does:

	for_ftrace_rec_iter(iter) {
		rec = ftrace_rec_iter_record(iter);

		ret = add_breakpoints(rec, enable);
		if (ret)
			goto remove_breakpoints;
		count++;
	}

	run_sync();


And there's two more iterator loops that will do the modification of
the call site, and then the third loop will remove the breakpoint.

That iterator does something special for each individual record. All
40,000 of them.

That add_breakpoint() does:

static int add_breakpoints(struct dyn_ftrace *rec, int enable)
{
	unsigned long ftrace_addr;
	int ret;

	ftrace_addr = ftrace_get_addr_curr(rec);

	ret = ftrace_test_record(rec, enable);

	switch (ret) {
	case FTRACE_UPDATE_IGNORE:
		return 0;

	case FTRACE_UPDATE_MAKE_CALL:
		/* converting nop to call */
		return add_brk_on_nop(rec);

	case FTRACE_UPDATE_MODIFY_CALL:
	case FTRACE_UPDATE_MAKE_NOP:
		/* converting a call to a nop */
		return add_brk_on_call(rec, ftrace_addr);
	}
	return 0;
}

And to get what the target is, we call ftrace_get_addr_curr(), which
will return a function based on the flags in the record. Which can be
anything from a call to a customized trampoline, to either
ftrace_caller, or to ftrace_regs_caller, or it can turn the record into
a nop.

This is what I'm talking about. We are adding thousands of int3s
through out the kernel, and we have a single handler to handle each one
of them.

The reason I picked ftrace_regs_caller() is because that one does
anything that any of the callers can do (albeit slower). If it does
not, then ftrace will be broken, because it handles the case that all
types of trampolines are attached to a single function, and that code
had better do the exact same thing for each of those trampolines as if
the trampolines were called directly, because the handlers that those
trampolines call, shouldn't care who else is using that function.

Note, the only exception to that rule, is that we only allow one
function attached to the function to modify the return address (and the
record has a flag for that). If a record already modifies the ip
address on return, the registering of another ftrace_ops that modifies
the ip address will fail to register.


> 
> Stop with the "there could be thousands of targets" arguyment. The
> "call" instruction THAT YOU ARE REWRITING has exactly one target.
> There aren't 40,000 of them. x86 does not have that kind of "call"
> instruction that randomly calls 40k different functions. You are
> replacing FIVE BYTES of memory, and the emulation you do should
> emulate those FIVE BYTES.
> 
> See?
> 
> Why are you emulating something different than what you are rewriting?

I'm not having one call site call 40,000 different functions. You are
right about that. But I have 40,000 different call sites that could be
calling different functions and all of them are being processed by a
single int3 handler.

That's my point.

-- Steve
