Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AAD112EEA
	for <lists+stable@lfdr.de>; Fri,  3 May 2019 15:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727501AbfECNWw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 May 2019 09:22:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:60828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726289AbfECNWw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 3 May 2019 09:22:52 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A51BC2075E;
        Fri,  3 May 2019 13:22:48 +0000 (UTC)
Date:   Fri, 3 May 2019 09:22:47 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@kernel.org>,
        Nicolai Stange <nstange@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>,
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
Message-ID: <20190503092247.20cc1ff0@gandalf.local.home>
In-Reply-To: <20190503092959.GB2623@hirez.programming.kicks-ass.net>
References: <20190501203152.397154664@goodmis.org>
        <20190501232412.1196ef18@oasis.local.home>
        <20190502162133.GX2623@hirez.programming.kicks-ass.net>
        <CAHk-=wijZ-MD4g3zMJ9W2r=h8LUWneiu29OWuxZEoSfAF=0bhQ@mail.gmail.com>
        <20190502181811.GY2623@hirez.programming.kicks-ass.net>
        <CAHk-=wi6A9tgw=kkPh5Ywqt687VvsVEjYXVkAnq0jpt0u0tk6g@mail.gmail.com>
        <20190502202146.GZ2623@hirez.programming.kicks-ass.net>
        <20190502185225.0cdfc8bc@gandalf.local.home>
        <20190502193129.664c5b2e@gandalf.local.home>
        <20190502195052.0af473cf@gandalf.local.home>
        <20190503092959.GB2623@hirez.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 3 May 2019 11:29:59 +0200
Peter Zijlstra <peterz@infradead.org> wrote:


> OMG, WTF, ARGH... That code is fsck'ing horrible. I'd almost argue to
> always do the INT3 thing, just to avoid games like that.

Hehe, that's almost the exact same thoughts I had when seeing this
code ;-)

> 
> That said; for normal traps &regs->sp is indeed the previous context --
> if it doesn't fall off the stack. Your hack detects the regular INT3
> frame. Howver if regs->sp has been modified (int3_emulate_push, for
> example) your detectoring comes unstuck.

Yep. I realized the issue as well. But wanted to make sure this did
work when sp wasn't changed.

> 
> Now, it is rather unlikely these two code paths interact, but just to be
> safe, something like so might be more reliable:
> 
> 
> diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
> index 4b8ee05dd6ad..aceaad0cc9a9 100644
> --- a/arch/x86/kernel/ptrace.c
> +++ b/arch/x86/kernel/ptrace.c
> @@ -163,6 +163,9 @@ static inline bool invalid_selector(u16 value)
>   * stack pointer we fall back to regs as stack if no previous stack
>   * exists.
>   *
> + * There is a special case for INT3, there we construct a full pt_regs
> + * environment. We can detect this case by a high bit in regs->cs
> + *
>   * This is valid only for kernel mode traps.
>   */
>  unsigned long kernel_stack_pointer(struct pt_regs *regs)
> @@ -171,6 +174,9 @@ unsigned long kernel_stack_pointer(struct pt_regs *regs)
>  	unsigned long sp = (unsigned long)&regs->sp;
>  	u32 *prev_esp;
>  
> +	if (regs->__csh & (1 << 13)) /* test CS_FROM_INT3 */
> +		return regs->sp;
> +

Thanks, I was looking into doing something like this (setting a flag in
the int3 code), but didn't have the time to see the best way to do this.

I'll add this version of the code and run it through my tests.

-- Steve

>  	if (context == (sp & ~(THREAD_SIZE - 1)))
>  		return sp;
>  
> --- a/arch/x86/entry/entry_32.S
> +++ b/arch/x86/entry/entry_32.S
> @@ -388,6 +388,7 @@
>  
>  #define CS_FROM_ENTRY_STACK	(1 << 31)
>  #define CS_FROM_USER_CR3	(1 << 30)
> +#define CS_FROM_INT3		(1 << 29)
>  
>  .macro SWITCH_TO_KERNEL_STACK
>  
> @@ -1515,6 +1516,9 @@ ENTRY(int3)
>  
>  	add	$16, 12(%esp) # point sp back at the previous context
>  
> +	andl	$0x0000ffff, 4(%esp)
> +	orl	$CS_FROM_INT3, 4(%esp)
> +
>  	pushl	$-1				# orig_eax; mark as interrupt
>  
>  	SAVE_ALL

