Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B203160DD
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 11:28:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726582AbfEGJ2D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 05:28:03 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:50762 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726394AbfEGJ2D (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 May 2019 05:28:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=K74zIJWVTADuSIeC0XGT8F72POWkdJPeuuL+utrmqlI=; b=X+FkTbzUvH17w4p9cdF0zY8Lj
        z6mvwSURsgoU9jZNM7JsIZkBBkQG+d+bLW17Dp4Yp9sQg+zPplRVE8UIxiC1ILSqiEGILP19Hx7M8
        P+0mCwuZ7ldUxusHH2FqbBQ1crOSmnAteH6lVo+sMIdAbCS9N+QhsNjuWxRXM5Vi4mT31Fxbgk3G2
        7+HWX/nyUSdgFlIdYdwc6c84w7qsgHu8aFyj/mTQws57Wn52FNW6WZ0JdacRQ+jGxPyY3nZxQcERn
        ysnUZztpngc6ZTNpHwFbHjVCxUvuYok1HGJ2n1qNas+WlKwXJyb8qZ0LA4CT2FAzJ5ZghGYrgnRix
        nMIDyk9hA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hNwNo-00016k-Li; Tue, 07 May 2019 09:27:32 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 1BF2A2023ADB7; Tue,  7 May 2019 11:27:31 +0200 (CEST)
Date:   Tue, 7 May 2019 11:27:31 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Andy Lutomirski <luto@amacapital.net>,
        Steven Rostedt <rostedt@goodmis.org>,
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
Subject: Re: [RFC][PATCH 1/2] x86: Allow breakpoints to emulate call functions
Message-ID: <20190507092731.GH2650@hirez.programming.kicks-ass.net>
References: <20190502202146.GZ2623@hirez.programming.kicks-ass.net>
 <20190502185225.0cdfc8bc@gandalf.local.home>
 <20190502193129.664c5b2e@gandalf.local.home>
 <20190502195052.0af473cf@gandalf.local.home>
 <20190503092959.GB2623@hirez.programming.kicks-ass.net>
 <20190503092247.20cc1ff0@gandalf.local.home>
 <2045370D-38D8-406C-9E94-C1D483E232C9@amacapital.net>
 <CAHk-=wjrOLqBG1qe9C3T=fLN0m=78FgNOGOEL22gU=+Pw6Mu9Q@mail.gmail.com>
 <20190506081951.GJ2606@hirez.programming.kicks-ass.net>
 <20190507085753.GO2606@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190507085753.GO2606@hirez.programming.kicks-ass.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 07, 2019 at 10:57:53AM +0200, Peter Zijlstra wrote:
> diff --git a/arch/x86/kernel/kprobes/core.c b/arch/x86/kernel/kprobes/core.c
> index 9e4fa2484d10..28d8ba3b9add 100644
> --- a/arch/x86/kernel/kprobes/core.c
> +++ b/arch/x86/kernel/kprobes/core.c
> @@ -731,29 +731,27 @@ asm(
>  	".global kretprobe_trampoline\n"
>  	".type kretprobe_trampoline, @function\n"
>  	"kretprobe_trampoline:\n"
> -#ifdef CONFIG_X86_64
>  	/* We don't bother saving the ss register */
> +#ifdef CONFIG_X86_64
>  	"	pushq %rsp\n"
>  	"	pushfq\n"
>  	SAVE_REGS_STRING
>  	"	movq %rsp, %rdi\n"
>  	"	call trampoline_handler\n"
>  	/* Replace saved sp with true return address. */
> -	"	movq %rax, 152(%rsp)\n"
> +	"	movq %rax, 19*8(%rsp)\n"
>  	RESTORE_REGS_STRING
>  	"	popfq\n"
>  #else
> -	"	pushf\n"
> +	"	pushl %esp\n"
> +	"	pushfl\n"
>  	SAVE_REGS_STRING
>  	"	movl %esp, %eax\n"
>  	"	call trampoline_handler\n"
> -	/* Move flags to cs */
> -	"	movl 56(%esp), %edx\n"
> -	"	movl %edx, 52(%esp)\n"
> -	/* Replace saved flags with true return address. */
> -	"	movl %eax, 56(%esp)\n"
> +	/* Replace saved sp with true return address. */
> +	"	movl %eax, 15*4(%esp)\n"
>  	RESTORE_REGS_STRING
> -	"	popf\n"
> +	"	popfl\n"
>  #endif
>  	"	ret\n"
>  	".size kretprobe_trampoline, .-kretprobe_trampoline\n"

> diff --git a/arch/x86/kernel/kprobes/opt.c b/arch/x86/kernel/kprobes/opt.c
> index f14262952015..c1010207d036 100644
> --- a/arch/x86/kernel/kprobes/opt.c
> +++ b/arch/x86/kernel/kprobes/opt.c
> @@ -115,14 +115,15 @@ asm (
>  			"optprobe_template_call:\n"
>  			ASM_NOP5
>  			/* Move flags to rsp */
> -			"	movq 144(%rsp), %rdx\n"
> -			"	movq %rdx, 152(%rsp)\n"
> +			"	movq 18*8(%rsp), %rdx\n"
> +			"	movq %rdx, 19*8(%rsp)\n"
>  			RESTORE_REGS_STRING
>  			/* Skip flags entry */
>  			"	addq $8, %rsp\n"
>  			"	popfq\n"
>  #else /* CONFIG_X86_32 */
> -			"	pushf\n"
> +			"	pushl %esp\n"
> +			"	pushfl\n"
>  			SAVE_REGS_STRING
>  			"	movl %esp, %edx\n"
>  			".global optprobe_template_val\n"
> @@ -131,9 +132,13 @@ asm (
>  			".global optprobe_template_call\n"
>  			"optprobe_template_call:\n"
>  			ASM_NOP5
> +			/* Move flags into esp */
> +			"	movl 14*4(%esp), %edx\n"
> +			"	movl %edx, 15*4(%esp)\n"
>  			RESTORE_REGS_STRING
> -			"	addl $4, %esp\n"	/* skip cs */
> -			"	popf\n"
> +			/* Skip flags entry */
> +			"	addl $4, %esp\n"
> +			"	popfl\n"
>  #endif
>  			".global optprobe_template_end\n"
>  			"optprobe_template_end:\n"

FWIW, both these trampolines assume a kprobe will not
int3_emulate_{push/call}(), for both bitnesses.

But then; I'm thinking kprobes should be inspection only and not modify
things. So that might just be good enough.

