Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE8D96130E2
	for <lists+stable@lfdr.de>; Mon, 31 Oct 2022 08:03:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229441AbiJaHC7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Oct 2022 03:02:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229832AbiJaHCj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Oct 2022 03:02:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFDA4BE3A
        for <stable@vger.kernel.org>; Mon, 31 Oct 2022 00:02:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D76D60FEA
        for <stable@vger.kernel.org>; Mon, 31 Oct 2022 07:02:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FE6FC433D6;
        Mon, 31 Oct 2022 07:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667199757;
        bh=GiWIx6DRdFou7Y26ltVzXNmlb2Ilj4Y/889P9KKmh6o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gRixx6e2fiSC0rFFXvBYpo1CQfiRoPwr4RPg/U9fPlmTRmzADTRUoFO+GZeyeMcUh
         WtKmaqQJ2ZAjQe8EV57PXnWlcwI5ENrxRAth2+72svCTOHLAVk/f2QU8dJs3JsLpBH
         VOh4E1/PDD+h1NaC6cHWp/vhA8EJMnbHKE6TtOzI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Suraj Jitindar Singh <surajjs@amazon.com>
Subject: [PATCH 4.14 12/34] x86/entry: Add kernel IBRS implementation
Date:   Mon, 31 Oct 2022 08:02:45 +0100
Message-Id: <20221031070140.401637715@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221031070140.108124105@linuxfoundation.org>
References: <20221031070140.108124105@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>

commit 2dbb887e875b1de3ca8f40ddf26bcfe55798c609 upstream.

Implement Kernel IBRS - currently the only known option to mitigate RSB
underflow speculation issues on Skylake hardware.

Note: since IBRS_ENTER requires fuller context established than
UNTRAIN_RET, it must be placed after it. However, since UNTRAIN_RET
itself implies a RET, it must come after IBRS_ENTER. This means
IBRS_ENTER needs to also move UNTRAIN_RET.

Note 2: KERNEL_IBRS is sub-optimal for XenPV.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
[cascardo: conflict at arch/x86/entry/entry_64_compat.S]
[cascardo: conflict fixups, no ANNOTATE_NOENDBR]
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
[ bp: Adjust context ]
Signed-off-by: Suraj Jitindar Singh <surajjs@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/entry/calling.h           |   58 +++++++++++++++++++++++++++++++++++++
 arch/x86/entry/entry_64.S          |   33 +++++++++++++++++++++
 arch/x86/entry/entry_64_compat.S   |   12 +++++++
 arch/x86/include/asm/cpufeatures.h |    2 -
 4 files changed, 103 insertions(+), 2 deletions(-)

--- a/arch/x86/entry/calling.h
+++ b/arch/x86/entry/calling.h
@@ -6,6 +6,8 @@
 #include <asm/percpu.h>
 #include <asm/asm-offsets.h>
 #include <asm/processor-flags.h>
+#include <asm/msr.h>
+#include <asm/nospec-branch.h>
 
 /*
 
@@ -329,6 +331,62 @@ For 32-bit we have the following convent
 #endif
 
 /*
+ * IBRS kernel mitigation for Spectre_v2.
+ *
+ * Assumes full context is established (PUSH_REGS, CR3 and GS) and it clobbers
+ * the regs it uses (AX, CX, DX). Must be called before the first RET
+ * instruction (NOTE! UNTRAIN_RET includes a RET instruction)
+ *
+ * The optional argument is used to save/restore the current value,
+ * which is used on the paranoid paths.
+ *
+ * Assumes x86_spec_ctrl_{base,current} to have SPEC_CTRL_IBRS set.
+ */
+.macro IBRS_ENTER save_reg
+	ALTERNATIVE "jmp .Lend_\@", "", X86_FEATURE_KERNEL_IBRS
+	movl	$MSR_IA32_SPEC_CTRL, %ecx
+
+.ifnb \save_reg
+	rdmsr
+	shl	$32, %rdx
+	or	%rdx, %rax
+	mov	%rax, \save_reg
+	test	$SPEC_CTRL_IBRS, %eax
+	jz	.Ldo_wrmsr_\@
+	lfence
+	jmp	.Lend_\@
+.Ldo_wrmsr_\@:
+.endif
+
+	movq	PER_CPU_VAR(x86_spec_ctrl_current), %rdx
+	movl	%edx, %eax
+	shr	$32, %rdx
+	wrmsr
+.Lend_\@:
+.endm
+
+/*
+ * Similar to IBRS_ENTER, requires KERNEL GS,CR3 and clobbers (AX, CX, DX)
+ * regs. Must be called after the last RET.
+ */
+.macro IBRS_EXIT save_reg
+	ALTERNATIVE "jmp .Lend_\@", "", X86_FEATURE_KERNEL_IBRS
+	movl	$MSR_IA32_SPEC_CTRL, %ecx
+
+.ifnb \save_reg
+	mov	\save_reg, %rdx
+.else
+	movq	PER_CPU_VAR(x86_spec_ctrl_current), %rdx
+	andl	$(~SPEC_CTRL_IBRS), %edx
+.endif
+
+	movl	%edx, %eax
+	shr	$32, %rdx
+	wrmsr
+.Lend_\@:
+.endm
+
+/*
  * Mitigate Spectre v1 for conditional swapgs code paths.
  *
  * FENCE_SWAPGS_USER_ENTRY is used in the user entry swapgs code path, to
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -230,6 +230,10 @@ GLOBAL(entry_SYSCALL_64_after_hwframe)
 
 	/* IRQs are off. */
 	movq	%rsp, %rdi
+
+	/* clobbers %rax, make sure it is after saving the syscall nr */
+	IBRS_ENTER
+
 	call	do_syscall_64		/* returns with IRQs disabled */
 
 	TRACE_IRQS_IRETQ		/* we're about to change IF */
@@ -301,6 +305,7 @@ GLOBAL(entry_SYSCALL_64_after_hwframe)
 	 * perf profiles. Nothing jumps here.
 	 */
 syscall_return_via_sysret:
+	IBRS_EXIT
 	POP_REGS pop_rdi=0
 
 	/*
@@ -590,6 +595,7 @@ GLOBAL(retint_user)
 	TRACE_IRQS_IRETQ
 
 GLOBAL(swapgs_restore_regs_and_return_to_usermode)
+	IBRS_EXIT
 #ifdef CONFIG_DEBUG_ENTRY
 	/* Assert that pt_regs indicates user mode. */
 	testb	$3, CS(%rsp)
@@ -1133,6 +1139,9 @@ idtentry machine_check		do_mce			has_err
  * Save all registers in pt_regs, and switch gs if needed.
  * Use slow, but surefire "are we in kernel?" check.
  * Return: ebx=0: need swapgs on exit, ebx=1: otherwise
+ *
+ * R14 - old CR3
+ * R15 - old SPEC_CTRL
  */
 ENTRY(paranoid_entry)
 	UNWIND_HINT_FUNC
@@ -1156,6 +1165,12 @@ ENTRY(paranoid_entry)
 	 */
 	FENCE_SWAPGS_KERNEL_ENTRY
 
+	/*
+	 * Once we have CR3 and %GS setup save and set SPEC_CTRL. Just like
+	 * CR3 above, keep the old value in a callee saved register.
+	 */
+	IBRS_ENTER save_reg=%r15
+
 	ret
 END(paranoid_entry)
 
@@ -1170,9 +1185,19 @@ END(paranoid_entry)
  * to try to handle preemption here.
  *
  * On entry, ebx is "no swapgs" flag (1: don't need swapgs, 0: need it)
+ *
+ * R14 - old CR3
+ * R15 - old SPEC_CTRL
  */
 ENTRY(paranoid_exit)
 	UNWIND_HINT_REGS
+
+	/*
+	 * Must restore IBRS state before both CR3 and %GS since we need access
+	 * to the per-CPU x86_spec_ctrl_shadow variable.
+	 */
+	IBRS_EXIT save_reg=%r15
+
 	DISABLE_INTERRUPTS(CLBR_ANY)
 	TRACE_IRQS_OFF_DEBUG
 	testl	%ebx, %ebx			/* swapgs needed? */
@@ -1207,8 +1232,10 @@ ENTRY(error_entry)
 	FENCE_SWAPGS_USER_ENTRY
 	/* We have user CR3.  Change to kernel CR3. */
 	SWITCH_TO_KERNEL_CR3 scratch_reg=%rax
+	IBRS_ENTER
 
 .Lerror_entry_from_usermode_after_swapgs:
+
 	/* Put us onto the real thread stack. */
 	popq	%r12				/* save return addr in %12 */
 	movq	%rsp, %rdi			/* arg0 = pt_regs pointer */
@@ -1271,6 +1298,7 @@ ENTRY(error_entry)
 	SWAPGS
 	FENCE_SWAPGS_USER_ENTRY
 	SWITCH_TO_KERNEL_CR3 scratch_reg=%rax
+	IBRS_ENTER
 
 	/*
 	 * Pretend that the exception came from user mode: set up pt_regs
@@ -1376,6 +1404,8 @@ ENTRY(nmi)
 	PUSH_AND_CLEAR_REGS rdx=(%rdx)
 	ENCODE_FRAME_POINTER
 
+	IBRS_ENTER
+
 	/*
 	 * At this point we no longer need to worry about stack damage
 	 * due to nesting -- we're on the normal thread stack and we're
@@ -1599,6 +1629,9 @@ end_repeat_nmi:
 	movq	$-1, %rsi
 	call	do_nmi
 
+	/* Always restore stashed SPEC_CTRL value (see paranoid_entry) */
+	IBRS_EXIT save_reg=%r15
+
 	RESTORE_CR3 scratch_reg=%r15 save_reg=%r14
 
 	testl	%ebx, %ebx			/* swapgs needed? */
--- a/arch/x86/entry/entry_64_compat.S
+++ b/arch/x86/entry/entry_64_compat.S
@@ -4,7 +4,6 @@
  *
  * Copyright 2000-2002 Andi Kleen, SuSE Labs.
  */
-#include "calling.h"
 #include <asm/asm-offsets.h>
 #include <asm/current.h>
 #include <asm/errno.h>
@@ -17,6 +16,8 @@
 #include <linux/linkage.h>
 #include <linux/err.h>
 
+#include "calling.h"
+
 	.section .entry.text, "ax"
 
 /*
@@ -106,6 +107,8 @@ ENTRY(entry_SYSENTER_compat)
 	xorl	%r15d, %r15d		/* nospec   r15 */
 	cld
 
+	IBRS_ENTER
+
 	/*
 	 * SYSENTER doesn't filter flags, so we need to clear NT and AC
 	 * ourselves.  To save a few cycles, we can check whether
@@ -250,6 +253,8 @@ GLOBAL(entry_SYSCALL_compat_after_hwfram
 	 */
 	TRACE_IRQS_OFF
 
+	IBRS_ENTER
+
 	movq	%rsp, %rdi
 	call	do_fast_syscall_32
 	/* XEN PV guests always use IRET path */
@@ -259,6 +264,9 @@ GLOBAL(entry_SYSCALL_compat_after_hwfram
 	/* Opportunistic SYSRET */
 sysret32_from_system_call:
 	TRACE_IRQS_ON			/* User mode traces as IRQs on. */
+
+	IBRS_EXIT
+
 	movq	RBX(%rsp), %rbx		/* pt_regs->rbx */
 	movq	RBP(%rsp), %rbp		/* pt_regs->rbp */
 	movq	EFLAGS(%rsp), %r11	/* pt_regs->flags (in r11) */
@@ -385,6 +393,8 @@ ENTRY(entry_INT80_compat)
 	 */
 	TRACE_IRQS_OFF
 
+	IBRS_ENTER
+
 	movq	%rsp, %rdi
 	call	do_int80_syscall_32
 .Lsyscall_32_done:
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -202,7 +202,7 @@
 #define X86_FEATURE_PROC_FEEDBACK	( 7*32+ 9) /* AMD ProcFeedbackInterface */
 #define X86_FEATURE_SME			( 7*32+10) /* AMD Secure Memory Encryption */
 #define X86_FEATURE_PTI			( 7*32+11) /* Kernel Page Table Isolation enabled */
-/* FREE!				( 7*32+12) */
+#define X86_FEATURE_KERNEL_IBRS		( 7*32+12) /* "" Set/clear IBRS on kernel entry/exit */
 /* FREE!				( 7*32+13) */
 #define X86_FEATURE_INTEL_PPIN		( 7*32+14) /* Intel Processor Inventory Number */
 #define X86_FEATURE_CDP_L2		( 7*32+15) /* Code and Data Prioritization L2 */


