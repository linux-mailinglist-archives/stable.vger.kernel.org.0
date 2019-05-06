Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DB64154E5
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 22:29:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbfEFU3V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 16:29:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:49452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726190AbfEFU3V (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 16:29:21 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C47F20830;
        Mon,  6 May 2019 20:29:17 +0000 (UTC)
Date:   Mon, 6 May 2019 16:29:15 -0400
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
        <linux-kselftest@vger.kernel.org>, stable <stable@vger.kernel.org>
Subject: Re: [RFC][PATCH 1/2] x86: Allow breakpoints to emulate call
 functions
Message-ID: <20190506162915.380993f9@gandalf.local.home>
In-Reply-To: <CAHk-=witfFBW2O5v6g--FmqnAFsMkKNLosTFfWyaoJ7euQF8kQ@mail.gmail.com>
References: <20190502181811.GY2623@hirez.programming.kicks-ass.net>
        <CAHk-=wi6A9tgw=kkPh5Ywqt687VvsVEjYXVkAnq0jpt0u0tk6g@mail.gmail.com>
        <20190502202146.GZ2623@hirez.programming.kicks-ass.net>
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
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 6 May 2019 12:46:11 -0700
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Mon, May 6, 2019 at 11:57 AM Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > You should have waited another week to open that merge window ;-)  
> 
> Hmm. I'm looking at it while the test builds happen, and since I don't
> see what's wrong in the low-level entry code, I'm looking at the
> ftrace code instead.
> 
> What's going on here?
> 
>                *pregs = int3_emulate_call(regs, (unsigned
> long)ftrace_regs_caller);
> 
> that line makes no sense. Why would we emulate a call to
> ftrace_regs_caller()? That function sets up a pt_regs, and then calls
> ftrace_stub().

Because that call to ftrace_stub is also dynamic.

In entry_32.S

.globl ftrace_call
ftrace_call:
	call	ftrace_stub


update_ftrace_func()
{
  [..]
	} else if (is_ftrace_caller(ip)) {
		if (!ftrace_update_func_call) {
			int3_emulate_jmp(regs, ip + CALL_INSN_SIZE);
			return 1;
		}
		*pregs = int3_emulate_call(regs, ftrace_update_func_call);
		return 1;
	}

Part of the code will change it to call the function needed directly.

struct ftrace_ops my_ops {
	.func = my_handler
};

	register_ftrace_function(&my_ops);

Will change "call ftrace_stub" into "call my_handler"

If you register another ftrace_ops, it will change that to

	call ftrace_ops_list_func

Which will iterate over all registered ftrace_ops, and depending on the
hashs in ftrace_ops, will call the registered handler for them.


> 
> But we *have* pt_regs here already with the right values. Why isn't
> this just a direct call to ftrace_stub() from within the int3 handler?
> 
> And the thing is, calling ftrace_regs_caller() looks wrong, because
> that's not what happens for *real* mcount handling, which uses that
> "create_trampoline()" to create the thing we're supposed to really
> use?

The ftrace_regs_caller() is what is called if there's two or more
callbacks registered to a single function. For example, you have a
function that is being lived patch (it uses the ftrace_regs_caller copy
of the trampoline). But if you enable function tracing (which doesn't
need a copy of regs), it will call the ftrace_regs_caller, which will
call a ftrace_ops_list_func() which will look at the ftrace_ops (which
is the descriptor representing registered callbacks to ftrace), and
based on the hash value in them, will call their handler if the
ftrace_ops hashes match the function being called.


> 
> Anyway, I simply don't understand the code, so I'm confused. But why
> is the int3 emulation creating a call that doesn't seem to match what
> the instruction that we're actually rewriting is supposed to do?
> 
> IOW, it looks to me like ftrace_int3_handler() is actually emulating
> something different than what ftrace_modify_code() is actually
> modifying the code to do!
> 
> Since the only caller of ftrace_modify_code() is update_ftrace_func(),
> why is that function not just saving the target and we'd emulate the
> call to that? Using anything else looks crazy?
> 
> But as mentioned, I just don't understand the ftrace logic. It looks
> insane to me, and much more likely to be buggy than the very simple
> entry code.


Let's go an example. Let's say we live patched do_IRQ() and
__migrate_task(). We would have this:

live_patch_trampoline:
   (which is a modified copy of the ftrace_regs_caller)
	pushl	$__KERNEL_CS
	pushl	4(%esp)
	pushl	$0
	pushl	%gs
	pushl	%fs
	pushl	%es
	pushl	%ds
	pushl	%eax
	pushf
	popl	%eax
	movl	%eax, 8*4(%esp)
	pushl	%ebp
	pushl	%edi
	pushl	%esi
	pushl	%edx
	pushl	%ecx
	pushl	%ebx
	movl	12*4(%esp), %eax
	subl	$MCOUNT_INSN_SIZE, %eax
	movl	15*4(%esp), %edx		/* Load parent ip (2nd parameter) */
	movl	function_trace_op, %ecx		/* Save ftrace_pos in 3rd parameter */
	pushl	%esp				/* Save pt_regs as 4th parameter */

	call	live_kernel_patch_func

	addl	$4, %esp			/* Skip pt_regs */
	push	14*4(%esp)
	popf
	movl	12*4(%esp), %eax
	movl	%eax, 14*4(%esp)
	popl	%ebx
	popl	%ecx
	popl	%edx
	popl	%esi
	popl	%edi
	popl	%ebp
	popl	%eax
	popl	%ds
	popl	%es
	popl	%fs
	popl	%gs
	lea	3*4(%esp), %esp			/* Skip orig_ax, ip and cs */
	jmp	.Lftrace_ret


<do_IRQ>:
	call live_patch_trampoline
	[..]

<__migrate_task>:
	call_live_patch_trampoline


Now we enable function tracing on all functions that can be traced, and
this includes do_IRQ() and __migrate_task(). Thus, we first modify that
call to ftrace_stub in the ftrace_regs_caller to point to the
ftrace_ops_list_func() as that will iterate over the ftrace_ops for
live kernel patching, and the ftrace_ops for the function tracer. That
iterator will check the hashes against the called functions, and for
live kernel patching, it will it will call its handler if the passed in
ip matches either do_IRQ() or __migrate_task(). It will see that the
ftrace_ops for function tracing is set to trace all functions and just
call its handler in that loop too.

Today, when we place an int3 on those functions, we basically turn them
into nops.

<do_IRQ>:
	<int3>(convert from call live_patch_trampoline
	                 to call ftrace_regs_caller)
	[..]

But that int3 handler, doesn't call either the live_patch_trampoline or
ftrace_regs_caller, which means, the live kernel patching doesn't get
to make that function call something different. We basically, just
disabled tracing completely for those functions during that transition.

Remember that ftrace_regs_caller gets updated to not call ftrace_stub,
but to the list iterator if there's more than one handler registered
with ftrace (and so does ftrace_caller). By making the int3 handler
call it, will do the iteration over all registered ftrace_ops and
nothing will be missed.

Does that help explain what's going on?

-- Steve
