Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F190C14BBB
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 16:23:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726094AbfEFOX1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:23:27 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:55660 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725994AbfEFOX1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 May 2019 10:23:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=GxKuXy1+s+PeeiwubdliM/pp8/xYTCCy3OKd2YpFtsI=; b=UmZd8Do3/TQldA46xNq9LjC5o
        ujqe1cGw3Kwuj67vT+ByS393Qd2O2pXTtZ1B4I26kZ6yV09UpFzfMEym3ETWoPvYl3TVGcyFOk5N4
        hK9n2++qFXLdLa5cOTAUwTsSLPqbs5TX6WrYUNpH+naBZ82mAF1U8bJL8O7LXVuxLo7aru+o3jWYK
        bFQ3YL526U2l6zTU0A6mwlX+e1Gu9OZyH80MquAzo2GtJW53iokh2Otg2gf0O3tD/g6hB4EExmiWK
        nIgAQZLottZR3RvnuZLeW+L3Rs8ndg5qHLggBa3yxKoYxOZa51yf746AoYXylzcRuh8aCvd6AT7UH
        IBiqAoBXw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hNeW8-0005Ye-1s; Mon, 06 May 2019 14:22:56 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 096412029F884; Mon,  6 May 2019 16:22:54 +0200 (CEST)
Date:   Mon, 6 May 2019 16:22:54 +0200
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
Message-ID: <20190506142254.GG2650@hirez.programming.kicks-ass.net>
References: <CAHk-=wi6A9tgw=kkPh5Ywqt687VvsVEjYXVkAnq0jpt0u0tk6g@mail.gmail.com>
 <20190502202146.GZ2623@hirez.programming.kicks-ass.net>
 <20190502185225.0cdfc8bc@gandalf.local.home>
 <20190502193129.664c5b2e@gandalf.local.home>
 <20190502195052.0af473cf@gandalf.local.home>
 <20190503092959.GB2623@hirez.programming.kicks-ass.net>
 <20190503092247.20cc1ff0@gandalf.local.home>
 <2045370D-38D8-406C-9E94-C1D483E232C9@amacapital.net>
 <CAHk-=wjrOLqBG1qe9C3T=fLN0m=78FgNOGOEL22gU=+Pw6Mu9Q@mail.gmail.com>
 <20190506081951.GJ2606@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190506081951.GJ2606@hirez.programming.kicks-ass.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 06, 2019 at 10:19:51AM +0200, Peter Zijlstra wrote:
> +.Lfrom_usermode_no_fixup_\@:
> +.endm
> +
> +.macro IRET_FRAME
> +
> +	/* orig_eax is already POP'ed when we're here */
> +
> +	testl $CS_FROM_KERNEL, 1*4(%esp)
> +	jz .Lfinished_frame_\@
> +
> +	pushl %eax
> +

From there..

> +	lea 10*4(%esp), %eax	# address of <previous context>
> +	cmpl %eax, 4*4(%esp)	# if ->sp is unmodified
> +	jnz .Lmodified_sp_do_fixup_\@
> +
> +	/*
> +	 * Fast path; regs->sp wasn't modified, reuse the original IRET frame.
> +	 */
> +	pop %eax
> +	add $6*4, %esp
> +	jmp .Lfinished_frame_\@;
> +
> +.Lmodified_sp_do_fixup_\@:

... until here, needs to go, it is buggy. While a clever idea, it looses
updates to regs->ip and ->flags.

> +
> +	/*
> +	 * Reconstruct the 3 entry IRET frame right after the (modified)
> +	 * regs->sp without lowering %esp in between, such that an NMI in the
> +	 * middle doesn't scribble our stack.
> +	 */
> +	pushl	%ecx
> +	movl	5*4(%esp), %eax		# (modified) regs->sp
> +
> +	movl	4*4(%esp), %ecx		# flags
> +	movl	%ecx, -4(%eax)
> +
> +	movl	3*4(%esp), %ecx		# cs
> +	andl	$0x0000ffff, %ecx
> +	movl	%ecx, -8(%eax)
> +
> +	movl	2*4(%esp), %ecx		# ip
> +	movl	%ecx, -12(%eax)
> +
> +	movl	1*4(%esp), %ecx		# eax
> +	movl	%ecx, -16(%eax)
> +
> +	popl	%ecx
> +	lea	-16(%eax), %esp
> +	popl	%eax
> +
> +.Lfinished_frame_\@:
> +.endm
