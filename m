Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E3CC135D8
	for <lists+stable@lfdr.de>; Sat,  4 May 2019 00:49:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726059AbfECWtY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 May 2019 18:49:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:38486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726041AbfECWtY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 3 May 2019 18:49:24 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94391206DF;
        Fri,  3 May 2019 22:49:20 +0000 (UTC)
Date:   Fri, 3 May 2019 18:49:19 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
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
Message-ID: <20190503184919.2b7ef242@gandalf.local.home>
In-Reply-To: <CAHk-=wiA-WbrFrDs-kOfJZMXy4zMo9-SZfk=7B-GfmBJ866naw@mail.gmail.com>
References: <20190501202830.347656894@goodmis.org>
        <20190501203152.397154664@goodmis.org>
        <20190501232412.1196ef18@oasis.local.home>
        <20190502162133.GX2623@hirez.programming.kicks-ass.net>
        <CAHk-=wijZ-MD4g3zMJ9W2r=h8LUWneiu29OWuxZEoSfAF=0bhQ@mail.gmail.com>
        <20190502181811.GY2623@hirez.programming.kicks-ass.net>
        <CAHk-=wi6A9tgw=kkPh5Ywqt687VvsVEjYXVkAnq0jpt0u0tk6g@mail.gmail.com>
        <20190502202146.GZ2623@hirez.programming.kicks-ass.net>
        <CAHk-=wh8bi5c_GkyjPtDAiaXaZRqtmhWs30usUvs4qK_F+c9tg@mail.gmail.com>
        <20190503152405.2d741af8@gandalf.local.home>
        <CAHk-=wiA-WbrFrDs-kOfJZMXy4zMo9-SZfk=7B-GfmBJ866naw@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 3 May 2019 14:46:11 -0700
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Fri, May 3, 2019 at 12:24 PM Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > The problem with this approach is that it would require doing the same
> > for x86_64, as the int3 C code is the same for both. And that may be a
> > bit more difficult on the x86_64 side because it's all done with a
> > simple flag in the idtentry macro to add the gap.  
> 
> That argument is weakened by the fact that we have to do _other_
> things differently on 32-bit and 64-bit anyway.
> 
> So we might as well have a "on 32-bit, the call emulation needs to
> move the pt_regs to make space" special case in the call emulation
> code. It's very easy to explain why.

So if I understand correctly what you are implying, is to have the int3
code be different for 32 bit and 64 bit? This would require handling
text_poke, ftrace and kprobes differently for the two. Or perhaps we
can build hacks on top.

> 
> And then we'd limit the special case to where it matters (with a big
> comment about what's going on), rather than adding random special case
> handling to random _other_ places.
> 
> Having to add s magic special case to "kernel_stack_pointer() is
> certainly not obvious. Neither is adding magic special cases to system
> call exit paths etc.

Honestly, this sounds more of an argument for doing the buffered space
for all exceptions on 32 bit, because it removes one of the special
cases. If we were to move the frame and give it a full frame like
x86_64, then we can remove kernel_stack_pointer() altogether. I've hated
that function for some time, as I tripped over it in the past too, and
it keeps coming up. It's sad that regs->sp is unreliable as is.

> 
> This has been why I've been arguing against the entry code changes.
> Exactly because they tend to have these kind of odd cascading effects.
> The entry code is fragile not just because it's a complex hardware
> interface, but also because we know about those complex hardware
> interfaces in random other places.

IMO, getting rid of the kernel_stack_pointer() function is a positive
side effect of these changes.

> 
> I'd much rather have the code that does special things be in one
> place, and be the place that *needs* to do the special thing. If we
> copy the pt_regs around when we do the "call" emulation, it's *really*
> easy to explain *exactly* what we're doing and why in *exactly* that
> one context where we are doing it. And it won't affect anything else,
> and our existing code that looks at pt_regs will work both before and
> after.
> 
> Would it need a #ifdef CONFIG_X86_32 around it because it's not needed
> on x86-64? Sure. But that #ifdef would be right there, and the comment
> that explains why the pt_regs need to be moved would also make it very
> obvious why it is only needed for x86-32.
> 
> There's a lot of advantages to keeping your problems localized,
> instead of letting your random hacks escape and become problems for
> other, entirely unrelated, code.

But is it localize? It would definitely affect do_int3().

You are saying that we have a do_int3() for user space int3, and
do_kernel_int3() for kernel space. That would need to be done in asm
for both, because having x86_64 call do_int3() for kernel and
user would be interesting. Looking at the do_int3() code, I'm not sure
how to safely separate kernel and user int3 handlers if 64bit doesn't
call do_kernel_int3() directly. It may end up looking something like
this:

dotraplinkage void notrace do_int3(struct pt_regs *regs, long error_code)
{
#ifdef CONFIG_X86_64
	do_kernel_int3(&regs);
#endif
	/*
	 * Use ist_enter despite the fact that we don't use an IST stack.
	 * We can be called from a kprobe in non-CONTEXT_KERNEL kernel
	 * mode or even during context tracking state changes.
	 *
	 * This means that we can't schedule.  That's okay.
	 */
	ist_enter(regs);
	RCU_LOCKDEP_WARN(!rcu_is_watching(), "entry code didn't wake RCU");

#ifdef CONFIG_X86_64
#ifdef CONFIG_KGDB_LOW_LEVEL_TRAP
	if (kgdb_ll_trap(DIE_INT3, "int3", regs, error_code, X86_TRAP_BP,
				SIGTRAP) == NOTIFY_STOP)
		goto exit;
#endif /* CONFIG_KGDB_LOW_LEVEL_TRAP */

#ifdef CONFIG_KPROBES
	if (kprobe_int3_handler(&regs))
		goto exit;
#endif
#endif

	if (notify_die(DIE_INT3, "int3", regs, error_code, X86_TRAP_BP,
			SIGTRAP) == NOTIFY_STOP)
		goto exit;

	cond_local_irq_enable(regs);
	do_trap(X86_TRAP_BP, SIGTRAP, "int3", regs, error_code, 0, NULL);
	cond_local_irq_disable(regs);

exit:
	ist_exit(regs);
}

dotraplinkage void notrace do_kernel_int3(struct pt_regs **regs)
{
#ifdef CONFIG_DYNAMIC_FTRACE
	/*
	 * ftrace must be first, everything else may cause a recursive crash.
	 * See note by declaration of modifying_ftrace_code in ftrace.c
	 */
	if (unlikely(atomic_read(&modifying_ftrace_code)) &&
	    ftrace_int3_handler(regs))
		return;
#endif
	if (poke_int3_handler(regs))
		return;

#ifdef CONFIG_X86_64
	return;
#endif

	/*
	 * Use ist_enter despite the fact that we don't use an IST stack.
	 * We can be called from a kprobe in non-CONTEXT_KERNEL kernel
	 * mode or even during context tracking state changes.
	 *
	 * This means that we can't schedule.  That's okay.
	 */
	ist_enter(*regs);
	RCU_LOCKDEP_WARN(!rcu_is_watching(), "entry code didn't wake RCU");

#ifdef CONFIG_KGDB_LOW_LEVEL_TRAP
	if (kgdb_ll_trap(DIE_INT3, "int3", *regs, error_code, X86_TRAP_BP,
				SIGTRAP) == NOTIFY_STOP)
		goto exit;
#endif /* CONFIG_KGDB_LOW_LEVEL_TRAP */

#ifdef CONFIG_KPROBES
	if (kprobe_int3_handler(regs))
		goto exit;
#endif

	notify_die(DIE_INT3, "int3", *regs, error_code, X86_TRAP_BP,
			SIGTRAP);
	ist_exit(*regs);
}

Or maybe I misunderstood what you envision :-/

-- Steve
