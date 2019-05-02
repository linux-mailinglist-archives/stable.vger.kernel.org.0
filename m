Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52508111D6
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 05:24:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726205AbfEBDYR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 May 2019 23:24:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:51034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726197AbfEBDYR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 May 2019 23:24:17 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 578FE20675;
        Thu,  2 May 2019 03:24:14 +0000 (UTC)
Date:   Wed, 1 May 2019 23:24:12 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
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
        <linux-kselftest@vger.kernel.org>, stable@vger.kernel.org
Subject: Re: [RFC][PATCH 1/2] x86: Allow breakpoints to emulate call
 functions
Message-ID: <20190501232412.1196ef18@oasis.local.home>
In-Reply-To: <20190501203152.397154664@goodmis.org>
References: <20190501202830.347656894@goodmis.org>
        <20190501203152.397154664@goodmis.org>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 01 May 2019 16:28:31 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> diff --git a/arch/x86/entry/entry_32.S b/arch/x86/entry/entry_32.S
> index d309f30cf7af..50bbf4035baf 100644
> --- a/arch/x86/entry/entry_32.S
> +++ b/arch/x86/entry/entry_32.S
> @@ -1478,6 +1478,17 @@ ENTRY(int3)
>  	ASM_CLAC
>  	pushl	$-1				# mark this as an int
>  
> +#ifdef CONFIG_VM86
> +	testl	$X86_EFLAGS_VM, PT_EFLAGS(%esp)
> +	jnz	.Lfrom_usermode_no_gap
> +#endif
> +	testl	$SEGMENT_RPL_MASK, PT_CS(%esp)
> +	jnz	.Lfrom_usermode_no_gap
> +	.rept 6
> +	pushl	5*4(%esp)
> +	.endr
> +.Lfrom_usermode_no_gap:
> +
>  	SAVE_ALL switch_stacks=1
>  	ENCODE_FRAME_POINTER
>  	TRACE_IRQS_OFF

This failed to work on 32 bit at all (crashed and burned badly - triple
fault!). Looking at it I found one issue. This code is done before the
regs are saved, and PT_EFLAGS(%esp) and PT_CS(%esp) expect %esp to
contain them. I applied this patch against this but it didn't totally
fix the problems. It still constantly crashes (although, with this
update I can put in some printks to get some ideas). I haven't spent
too much time on it, but it looks like there's an issue with the
entry-stack that int3 switches to. I'm not sure its handling the copy
well.

-- Steve

diff --git a/arch/x86/entry/entry_32.S b/arch/x86/entry/entry_32.S
index 50bbf4035baf..4f427285e421 100644
--- a/arch/x86/entry/entry_32.S
+++ b/arch/x86/entry/entry_32.S
@@ -1479,10 +1479,10 @@ ENTRY(int3)
 	pushl	$-1				# mark this as an int
 
 #ifdef CONFIG_VM86
-	testl	$X86_EFLAGS_VM, PT_EFLAGS(%esp)
+	testl	$X86_EFLAGS_VM, PT_EFLAGS-PT_ORIG_EAX(%esp)
 	jnz	.Lfrom_usermode_no_gap
 #endif
-	testl	$SEGMENT_RPL_MASK, PT_CS(%esp)
+	testl	$SEGMENT_RPL_MASK, PT_CS-PT_ORIG_EAX(%esp)
 	jnz	.Lfrom_usermode_no_gap
 	.rept 6
 	pushl	5*4(%esp)
