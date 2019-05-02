Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 740B8121E9
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 20:32:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbfEBScQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 14:32:16 -0400
Received: from merlin.infradead.org ([205.233.59.134]:58300 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726244AbfEBScQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 May 2019 14:32:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=OlMWSzvvuWVM+bMJ90y7miF3ovjNqjeLOMeQybDfWCY=; b=LLL8nE+IMEm4e5NbX296wcIJy
        72ObaVzXBxCiGFsDho7vK/7twOopAQQvm8Fwd9kxcwwybNXa5QUg9cGtwathsMIqjtGeXBB1XigOA
        4Kb9vCVGVgS9rprRCjuVVlf6yFJcha6+7ECRSl+esDCRqkIG1ZhIdUJJ2CXEVEh6wozpyKfACmN4T
        SdMTbl+t6Cii05UxH+DurhyM7cGUXMI8Px5yszA4GGLmrV1r6Biymo5WBg77pd1lCEgyAxsh0cgDR
        PNRzSOHQD0f8ZhcbZ/M5vGNwnOroKraBrpQ4jxMfcqKILPtpZTB/6FyoMrl94psHHbgyYS0gRdU9O
        jTJnG2dsQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hMGU0-0002LM-0f; Thu, 02 May 2019 18:31:00 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id B87382066BB8B; Thu,  2 May 2019 20:30:58 +0200 (CEST)
Date:   Thu, 2 May 2019 20:30:58 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
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
Message-ID: <20190502183058.GD2650@hirez.programming.kicks-ass.net>
References: <20190501202830.347656894@goodmis.org>
 <20190501203152.397154664@goodmis.org>
 <20190501232412.1196ef18@oasis.local.home>
 <20190502162133.GX2623@hirez.programming.kicks-ass.net>
 <CAHk-=wijZ-MD4g3zMJ9W2r=h8LUWneiu29OWuxZEoSfAF=0bhQ@mail.gmail.com>
 <20190502181811.GY2623@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190502181811.GY2623@hirez.programming.kicks-ass.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 02, 2019 at 08:18:11PM +0200, Peter Zijlstra wrote:

> ARGH; I knew it was too pretty :/ Yes, something like what you suggest
> will be needed, I'll go look at that once my brain recovers a bit from
> staring at entry code all day.

I forgot I can just run the thing, and it works!


---
diff --git a/arch/x86/entry/entry_32.S b/arch/x86/entry/entry_32.S
index 7b23431be5cb..73b7bca8712f 100644
--- a/arch/x86/entry/entry_32.S
+++ b/arch/x86/entry/entry_32.S
@@ -203,7 +203,7 @@
 .Lend_\@:
 .endm
 
-.macro SAVE_ALL pt_regs_ax=%eax switch_stacks=0
+.macro SAVE_ALL pt_regs_ax=%eax switch_stacks=0 clear_csh=1
 	cld
 	PUSH_GS
 	pushl	%fs
@@ -225,7 +225,7 @@
 
 	/* Switch to kernel stack if necessary */
 .if \switch_stacks > 0
-	SWITCH_TO_KERNEL_STACK
+	SWITCH_TO_KERNEL_STACK \clear_csh
 .endif
 
 .endm
@@ -377,8 +377,9 @@
 
 #define CS_FROM_ENTRY_STACK	(1 << 31)
 #define CS_FROM_USER_CR3	(1 << 30)
+#define CS_FROM_INT3		(1 << 29)
 
-.macro SWITCH_TO_KERNEL_STACK
+.macro SWITCH_TO_KERNEL_STACK clear_csh=1
 
 	ALTERNATIVE     "", "jmp .Lend_\@", X86_FEATURE_XENPV
 
@@ -391,12 +392,13 @@
 	 * that register for the time this macro runs
 	 */
 
+	.if \clear_csh
 	/*
-	 * The high bits of the CS dword (__csh) are used for
-	 * CS_FROM_ENTRY_STACK and CS_FROM_USER_CR3. Clear them in case
-	 * hardware didn't do this for us.
+	 * The high bits of the CS dword (__csh) are used for CS_FROM_*. Clear
+	 * them in case hardware didn't do this for us.
 	 */
 	andl	$(0x0000ffff), PT_CS(%esp)
+	.endif
 
 	/* Are we on the entry stack? Bail out if not! */
 	movl	PER_CPU_VAR(cpu_entry_area), %ecx
@@ -1019,6 +1021,40 @@ ENTRY(entry_INT80_32)
 	/* Restore user state */
 	RESTORE_REGS pop=4			# skip orig_eax/error_code
 .Lirq_return:
+	testl $CS_FROM_INT3, 4(%esp)
+	jz .Lno_iret_fixup
+
+	/*
+	 * Undo the magic from ENTRY(int3), in particular consider the case
+	 * where regs->sp has been modified.
+	 *
+	 * Reconstruct the 3 entry IRET frame right after the (modified)
+	 * regs->sp without lowering %esp in between, such that an NMI in the
+	 * middle doesn't scribble our stack.
+	 */
+
+	pushl	%eax
+	pushl	%ecx
+	movl	5*4(%esp), %eax		# (modified) regs->sp
+
+	movl	4*4(%esp), %ecx		# flags
+	movl	%ecx, -4(%eax)
+
+	movl	3*4(%esp), %ecx		# cs
+	andl	$0x0000ffff, %ecx
+	movl	%ecx, -8(%eax)
+
+	movl	2*4(%esp), %ecx		# ip
+	movl	%ecx, -12(%eax)
+
+	movl	1*4(%esp), %ecx		# eax
+	movl	%ecx, -16(%eax)
+
+	popl	%ecx
+	lea	-16(%eax), %esp
+	popl	%eax
+
+.Lno_iret_fixup:
 	/*
 	 * ARCH_HAS_MEMBARRIER_SYNC_CORE rely on IRET core serialization
 	 * when returning from IPI handler and when returning from
@@ -1477,9 +1513,57 @@ END(nmi)
 
 ENTRY(int3)
 	ASM_CLAC
+
+	/*
+	 * The high bits of the CS dword (__csh) are used for CS_FROM_*. Clear
+	 * them in case hardware didn't do this for us.
+	 */
+	andl	$0x0000ffff, 4(%esp)
+
+#ifdef CONFIG_VM86
+	testl	$X86_EFLAGS_VM, 8(%esp)
+	jnz	.Lfrom_usermode_no_gap
+#endif
+	testl	$SEGMENT_RPL_MASK, 4(%esp)
+	jnz	.Lfrom_usermode_no_gap
+
+	/*
+	 * Here from kernel mode; so the (exception) stack looks like:
+	 *
+	 * 12(esp) - <previous context>
+	 *  8(esp) - flags
+	 *  4(esp) - cs
+	 *  0(esp) - ip
+	 *
+	 * Lets build a 5 entry IRET frame after that, such that struct pt_regs
+	 * is complete and in particular regs->sp is correct. This gives us
+	 * the original 3 enties as gap:
+	 *
+	 * 32(esp) - <previous context>
+	 * 28(esp) - orig_flags / gap
+	 * 24(esp) - orig_cs	/ gap
+	 * 20(esp) - orig_ip	/ gap
+	 * 16(esp) - ss
+	 * 12(esp) - sp
+	 *  8(esp) - flags
+	 *  4(esp) - cs
+	 *  0(esp) - ip
+	 */
+	pushl	%ss	  # ss
+	pushl	%esp      # sp (points at ss)
+	pushl	4*4(%esp) # flags
+	pushl	4*4(%esp) # cs
+	pushl	4*4(%esp) # ip
+
+	add	$16, 12(%esp) # point sp back at the previous context
+
+	orl	$CS_FROM_INT3, 4(%esp) # mark magic IRET
+
+.Lfrom_usermode_no_gap:
+
 	pushl	$-1				# mark this as an int
 
-	SAVE_ALL switch_stacks=1
+	SAVE_ALL switch_stacks=1 clear_csh=0
 	ENCODE_FRAME_POINTER
 	TRACE_IRQS_OFF
 	xorl	%edx, %edx			# zero error code

