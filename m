Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B19D57EE2F
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 12:08:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238670AbiGWKHz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 06:07:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238465AbiGWKHH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 06:07:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C918C47E5;
        Sat, 23 Jul 2022 03:01:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E5FF7B82C1D;
        Sat, 23 Jul 2022 10:01:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53224C341C0;
        Sat, 23 Jul 2022 10:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658570478;
        bh=AlwIaBZ2g8sMPWPN0Jz1aONq8AbTKSIosVdoN6z6qbo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EhWGfyncJTRknglMvfTl9IpKjg7lYKMk7asW11g4OzZ0EGkrEnNr0fvDUXmYlczb3
         DrRXO0gUEu/+rYJr04yLhQM1QIpDdvqUNbB0ZtGHVppeHiLP1aneHsCt6kEeQVE4JR
         sMIIKhMB2fk9757rR79BB66neDpH6s1EvQvZ2HBM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 100/148] x86/entry: Add kernel IBRS implementation
Date:   Sat, 23 Jul 2022 11:55:12 +0200
Message-Id: <20220723095252.429231691@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220723095224.302504400@linuxfoundation.org>
References: <20220723095224.302504400@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

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
[cascardo: conflict at arch/x86/entry/entry_64.S, skip_r11rcx]
[cascardo: conflict at arch/x86/entry/entry_64_compat.S]
[cascardo: conflict fixups, no ANNOTATE_NOENDBR]
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
[bwh: Backported to 5.10: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/entry/calling.h           |   58 +++++++++++++++++++++++++++++++++++++
 arch/x86/entry/entry_64.S          |   44 ++++++++++++++++++++++++----
 arch/x86/entry/entry_64_compat.S   |   17 ++++++++--
 arch/x86/include/asm/cpufeatures.h |    2 -
 4 files changed, 111 insertions(+), 10 deletions(-)

--- a/arch/x86/entry/calling.h
+++ b/arch/x86/entry/calling.h
@@ -6,6 +6,8 @@
 #include <asm/percpu.h>
 #include <asm/asm-offsets.h>
 #include <asm/processor-flags.h>
+#include <asm/msr.h>
+#include <asm/nospec-branch.h>
 
 /*
 
@@ -309,6 +311,62 @@ For 32-bit we have the following convent
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
@@ -102,7 +102,6 @@ SYM_CODE_START(entry_SYSCALL_64)
 	movq	PER_CPU_VAR(cpu_current_top_of_stack), %rsp
 
 SYM_INNER_LABEL(entry_SYSCALL_64_safe_stack, SYM_L_GLOBAL)
-	UNTRAIN_RET
 
 	/* Construct struct pt_regs on stack */
 	pushq	$__USER_DS				/* pt_regs->ss */
@@ -118,6 +117,11 @@ SYM_INNER_LABEL(entry_SYSCALL_64_after_h
 	/* IRQs are off. */
 	movq	%rax, %rdi
 	movq	%rsp, %rsi
+
+	/* clobbers %rax, make sure it is after saving the syscall nr */
+	IBRS_ENTER
+	UNTRAIN_RET
+
 	call	do_syscall_64		/* returns with IRQs disabled */
 
 	/*
@@ -192,6 +196,7 @@ SYM_INNER_LABEL(entry_SYSCALL_64_after_h
 	 * perf profiles. Nothing jumps here.
 	 */
 syscall_return_via_sysret:
+	IBRS_EXIT
 	POP_REGS pop_rdi=0
 
 	/*
@@ -569,6 +574,7 @@ __irqentry_text_end:
 
 SYM_CODE_START_LOCAL(common_interrupt_return)
 SYM_INNER_LABEL(swapgs_restore_regs_and_return_to_usermode, SYM_L_GLOBAL)
+	IBRS_EXIT
 #ifdef CONFIG_DEBUG_ENTRY
 	/* Assert that pt_regs indicates user mode. */
 	testb	$3, CS(%rsp)
@@ -889,6 +895,9 @@ SYM_CODE_END(xen_failsafe_callback)
  *              1 -> no SWAPGS on exit
  *
  *     Y        GSBASE value at entry, must be restored in paranoid_exit
+ *
+ * R14 - old CR3
+ * R15 - old SPEC_CTRL
  */
 SYM_CODE_START_LOCAL(paranoid_entry)
 	UNWIND_HINT_FUNC
@@ -912,7 +921,6 @@ SYM_CODE_START_LOCAL(paranoid_entry)
 	 * be retrieved from a kernel internal table.
 	 */
 	SAVE_AND_SWITCH_TO_KERNEL_CR3 scratch_reg=%rax save_reg=%r14
-	UNTRAIN_RET
 
 	/*
 	 * Handling GSBASE depends on the availability of FSGSBASE.
@@ -934,7 +942,7 @@ SYM_CODE_START_LOCAL(paranoid_entry)
 	 * is needed here.
 	 */
 	SAVE_AND_SET_GSBASE scratch_reg=%rax save_reg=%rbx
-	RET
+	jmp .Lparanoid_gsbase_done
 
 .Lparanoid_entry_checkgs:
 	/* EBX = 1 -> kernel GSBASE active, no restore required */
@@ -953,8 +961,16 @@ SYM_CODE_START_LOCAL(paranoid_entry)
 	xorl	%ebx, %ebx
 	swapgs
 .Lparanoid_kernel_gsbase:
-
 	FENCE_SWAPGS_KERNEL_ENTRY
+.Lparanoid_gsbase_done:
+
+	/*
+	 * Once we have CR3 and %GS setup save and set SPEC_CTRL. Just like
+	 * CR3 above, keep the old value in a callee saved register.
+	 */
+	IBRS_ENTER save_reg=%r15
+	UNTRAIN_RET
+
 	RET
 SYM_CODE_END(paranoid_entry)
 
@@ -976,9 +992,19 @@ SYM_CODE_END(paranoid_entry)
  *              1 -> no SWAPGS on exit
  *
  *     Y        User space GSBASE, must be restored unconditionally
+ *
+ * R14 - old CR3
+ * R15 - old SPEC_CTRL
  */
 SYM_CODE_START_LOCAL(paranoid_exit)
 	UNWIND_HINT_REGS
+
+	/*
+	 * Must restore IBRS state before both CR3 and %GS since we need access
+	 * to the per-CPU x86_spec_ctrl_shadow variable.
+	 */
+	IBRS_EXIT save_reg=%r15
+
 	/*
 	 * The order of operations is important. RESTORE_CR3 requires
 	 * kernel GSBASE.
@@ -1025,9 +1051,11 @@ SYM_CODE_START_LOCAL(error_entry)
 	FENCE_SWAPGS_USER_ENTRY
 	/* We have user CR3.  Change to kernel CR3. */
 	SWITCH_TO_KERNEL_CR3 scratch_reg=%rax
+	IBRS_ENTER
 	UNTRAIN_RET
 
 .Lerror_entry_from_usermode_after_swapgs:
+
 	/* Put us onto the real thread stack. */
 	popq	%r12				/* save return addr in %12 */
 	movq	%rsp, %rdi			/* arg0 = pt_regs pointer */
@@ -1081,6 +1109,7 @@ SYM_CODE_START_LOCAL(error_entry)
 	SWAPGS
 	FENCE_SWAPGS_USER_ENTRY
 	SWITCH_TO_KERNEL_CR3 scratch_reg=%rax
+	IBRS_ENTER
 	UNTRAIN_RET
 
 	/*
@@ -1176,7 +1205,6 @@ SYM_CODE_START(asm_exc_nmi)
 	movq	%rsp, %rdx
 	movq	PER_CPU_VAR(cpu_current_top_of_stack), %rsp
 	UNWIND_HINT_IRET_REGS base=%rdx offset=8
-	UNTRAIN_RET
 	pushq	5*8(%rdx)	/* pt_regs->ss */
 	pushq	4*8(%rdx)	/* pt_regs->rsp */
 	pushq	3*8(%rdx)	/* pt_regs->flags */
@@ -1187,6 +1215,9 @@ SYM_CODE_START(asm_exc_nmi)
 	PUSH_AND_CLEAR_REGS rdx=(%rdx)
 	ENCODE_FRAME_POINTER
 
+	IBRS_ENTER
+	UNTRAIN_RET
+
 	/*
 	 * At this point we no longer need to worry about stack damage
 	 * due to nesting -- we're on the normal thread stack and we're
@@ -1409,6 +1440,9 @@ end_repeat_nmi:
 	movq	$-1, %rsi
 	call	exc_nmi
 
+	/* Always restore stashed SPEC_CTRL value (see paranoid_entry) */
+	IBRS_EXIT save_reg=%r15
+
 	/* Always restore stashed CR3 value (see paranoid_entry) */
 	RESTORE_CR3 scratch_reg=%r15 save_reg=%r14
 
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
@@ -18,6 +17,8 @@
 #include <linux/linkage.h>
 #include <linux/err.h>
 
+#include "calling.h"
+
 	.section .entry.text, "ax"
 
 /*
@@ -72,7 +73,6 @@ SYM_CODE_START(entry_SYSENTER_compat)
 	pushq	$__USER32_CS		/* pt_regs->cs */
 	pushq	$0			/* pt_regs->ip = 0 (placeholder) */
 SYM_INNER_LABEL(entry_SYSENTER_compat_after_hwframe, SYM_L_GLOBAL)
-	UNTRAIN_RET
 
 	/*
 	 * User tracing code (ptrace or signal handlers) might assume that
@@ -114,6 +114,9 @@ SYM_INNER_LABEL(entry_SYSENTER_compat_af
 
 	cld
 
+	IBRS_ENTER
+	UNTRAIN_RET
+
 	/*
 	 * SYSENTER doesn't filter flags, so we need to clear NT and AC
 	 * ourselves.  To save a few cycles, we can check whether
@@ -213,7 +216,6 @@ SYM_CODE_START(entry_SYSCALL_compat)
 	movq	PER_CPU_VAR(cpu_current_top_of_stack), %rsp
 
 SYM_INNER_LABEL(entry_SYSCALL_compat_safe_stack, SYM_L_GLOBAL)
-	UNTRAIN_RET
 
 	/* Construct struct pt_regs on stack */
 	pushq	$__USER32_DS		/* pt_regs->ss */
@@ -255,6 +257,9 @@ SYM_INNER_LABEL(entry_SYSCALL_compat_aft
 
 	UNWIND_HINT_REGS
 
+	IBRS_ENTER
+	UNTRAIN_RET
+
 	movq	%rsp, %rdi
 	call	do_fast_syscall_32
 	/* XEN PV guests always use IRET path */
@@ -269,6 +274,8 @@ sysret32_from_system_call:
 	 */
 	STACKLEAK_ERASE
 
+	IBRS_EXIT
+
 	movq	RBX(%rsp), %rbx		/* pt_regs->rbx */
 	movq	RBP(%rsp), %rbp		/* pt_regs->rbp */
 	movq	EFLAGS(%rsp), %r11	/* pt_regs->flags (in r11) */
@@ -380,7 +387,6 @@ SYM_CODE_START(entry_INT80_compat)
 	pushq	(%rdi)			/* pt_regs->di */
 .Lint80_keep_stack:
 
-	UNTRAIN_RET
 	pushq	%rsi			/* pt_regs->si */
 	xorl	%esi, %esi		/* nospec   si */
 	pushq	%rdx			/* pt_regs->dx */
@@ -413,6 +419,9 @@ SYM_CODE_START(entry_INT80_compat)
 
 	cld
 
+	IBRS_ENTER
+	UNTRAIN_RET
+
 	movq	%rsp, %rdi
 	call	do_int80_syscall_32
 	jmp	swapgs_restore_regs_and_return_to_usermode
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -203,7 +203,7 @@
 #define X86_FEATURE_PROC_FEEDBACK	( 7*32+ 9) /* AMD ProcFeedbackInterface */
 #define X86_FEATURE_SME			( 7*32+10) /* AMD Secure Memory Encryption */
 #define X86_FEATURE_PTI			( 7*32+11) /* Kernel Page Table Isolation enabled */
-/* FREE!				( 7*32+12) */
+#define X86_FEATURE_KERNEL_IBRS		( 7*32+12) /* "" Set/clear IBRS on kernel entry/exit */
 /* FREE!				( 7*32+13) */
 #define X86_FEATURE_INTEL_PPIN		( 7*32+14) /* Intel Processor Inventory Number */
 #define X86_FEATURE_CDP_L2		( 7*32+15) /* Code and Data Prioritization L2 */


