Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 131B1156D4
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 02:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726095AbfEGAKU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 20:10:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:34440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726046AbfEGAKU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 20:10:20 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3309E206BF;
        Tue,  7 May 2019 00:10:16 +0000 (UTC)
Date:   Mon, 6 May 2019 20:10:14 -0400
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
Message-ID: <20190506201014.484e7b65@oasis.local.home>
In-Reply-To: <CAHk-=wje38dbYFGNw0y==zd7Zo_4s2WOQjWaBDyr24RCdK2EPQ@mail.gmail.com>
References: <20190502181811.GY2623@hirez.programming.kicks-ass.net>
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
        <CAHk-=wje38dbYFGNw0y==zd7Zo_4s2WOQjWaBDyr24RCdK2EPQ@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 6 May 2019 15:31:57 -0700
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Mon, May 6, 2019 at 3:06 PM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > Why are you emulating something different than what you are rewriting?  
> 
> Side note: I'm also finding another bug on the ftrace side, which is a
> simple race condition.
> 
> In particular, the logic with 'modifying_ftrace_code' is fundamentally racy.
> 
> What can happen is that on one CPU we rewrite one instruction:
> 
>         ftrace_update_func = ip;
>         /* Make sure the breakpoints see the ftrace_update_func update */
>         smp_wmb();
> 
>         /* See comment above by declaration of modifying_ftrace_code */
>         atomic_inc(&modifying_ftrace_code);
> 
>         ret = ftrace_modify_code(ip, old, new);
> 
>         atomic_dec(&modifying_ftrace_code);
> 
>    but then another CPU hits the 'int3' while the modification is
> going on, and takes the fault.
> 
> The fault handler does that
> 
>         if (unlikely(atomic_read(&modifying_ftrace_code))..
> 
> and sees that "yes, it's in the middle of modifying the ftrace code",
> and calls ftrace_int3_handler().  All good and "obviously correct" so
> far, no?
> 
> HOWEVER. It's actually buggy. Because in the meantime, the CPU that
> was rewriting instructions has finished, and decrements the
> modifying_ftrace_code, which doesn't hurt us (because we already saw
> that the int3 was due to the modification.

But the CPU that was rewriting instructions does a run_sync() after
removing the int3:

static void run_sync(void)
{
	int enable_irqs;

	/* No need to sync if there's only one CPU */
	if (num_online_cpus() == 1)
		return;

	enable_irqs = irqs_disabled();

	/* We may be called with interrupts disabled (on bootup). */
	if (enable_irqs)
		local_irq_enable();
	on_each_cpu(do_sync_core, NULL, 1);
	if (enable_irqs)
		local_irq_disable();
}

Which sends an IPI to all CPUs to make sure they no longer see the int3.

> 
> BUT! There are two different races here:
> 
>  (a) maybe the fault handling was slow, and we saw the 'int3' and took
> the fault, but the modifying CPU had already finished, so that
> atomic_read(&modifying_ftrace_code) didn't actually trigger at all.
> 
>  (b) maybe the int3-faulting CPU *did* see the proper value of
> modifying_ftrace_code, but the modifying CPU went on and started
> *another* modification, and has changed ftrace_update_func in the
> meantime, so now the int3 handling is looking at the wrong values!
> 
> In the case of (a), we'll die with an oops due to the inexplicable
> 'int3' we hit. And in the case of (b) we'll be fixing up using the
> wrong address.
> 
> Things like this is why I'm wondering how much of the problems are due
> to the entry code, and how much of it is due to simply races and
> timing differences?
> 
> Again, I don't actually know the ftrace code, and maybe I'm missing
> something, but this really looks like _another_ fundamental bug.
> 
> The way to handle that modifying_ftrace_code thing is most likely by
> using a sequence counter. For example, one way to actually do some
> thing like this might be
> 
>         ftrace_update_func = ip;
>         ftrace_update_target = func;
>         smp_wmb();
>         atomic_inc(&modifying_ftrace_head);
> 
>         ret = ftrace_modify_code(ip, old, new);
> 
>         atomic_inc(&modifying_ftrace_tail);
>         smp_wmb();
> 
> and now the int3 code could do something like
> 
>         int head, tail;
> 
>         head = atomic_read(&modifying_ftrace_head);
>         smp_rmb();
>         tail = atomic_read(&modifying_ftrace_tail);
> 
>         /* Are we still in the process of modification? */
>         if (unlikely(head != tail+1))
>                 return 0;
> 
>         ip = ftrace_update_func;
>         func = ftrace_update_target;
>         smp_rmb();
>         /* Need to re-check that the above two values are consistent
> and we didn't exit */
>         if (atomic_read(&modifying_ftrace_tail) != tail)
>                 return 0;
> 
>         *pregs int3_emulate_call(regs, ip, func);
>         return 1;
> 
> although it probably really would be better to use a seqcount instead
> of writing it out like the above.
> 
> NOTE! The above only fixes the (b) race. The (a) race is probably best
> handled by actually checking if the 'int3' instruction is still there
> before dying.
> 
> Again, maybe there's something I'm missing, but having looked at that
> patch now what feels like a million times, I'm finding more worrisome
> things in the ftrace code than in the kernel entry code..

I think you are missing the run_sync() which is the heavy hammer to
make sure all CPUs are in sync. And this is done at each stage:

	add int3
	run_sync();
	update call cite outside of int3
	run_sync()
	remove int3
	run_sync()

HPA said that the last run_sync() isn't needed, but I kept it because I
wanted to make sure. Looks like your analysis shows that it is needed.

-- Steve

