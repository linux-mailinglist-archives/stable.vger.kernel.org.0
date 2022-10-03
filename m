Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93BA35F30CB
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 15:12:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230028AbiJCNMH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 09:12:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbiJCNMF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 09:12:05 -0400
Received: from smtp-relay-canonical-1.canonical.com (smtp-relay-canonical-1.canonical.com [185.125.188.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAE9B4D836;
        Mon,  3 Oct 2022 06:11:44 -0700 (PDT)
Received: from quatroqueijos.. (unknown [179.93.174.77])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id F003242FB8;
        Mon,  3 Oct 2022 13:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1664802698;
        bh=p9/M7RpWVrpZ6Rjh0QoEkyPQVxRKS0GPBaHn2GNr05Q=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=DtZtqkzGFNsiN3fTjkYndo61NJ8iEwTzDGqumaaIz/E+zj2q5mqY6Nnhy0ss7xFsT
         E+y9W8QnqurP3tJVuSoZyRcQJ/1NNPClFxdS67H030gI56WtRYZNpv89x5c5VaP7aQ
         JvE83638W32f37imWWW6Cr/C7VzXdzqAY7+mcLPZVElAGHQSjJd2IUQAufwoZr+ErA
         P+PBdmYEA+4EvuYITnb2NGXAjhi41nHdoJ7krzb3vOU5fRqOx6AN40Yens2S8cIXn+
         lE6N/RkhoeEReEShWSxoZRGBQoGiIpZiC72CGA0hXNmWbiHQ5F1JP0uglrdmYuI+yy
         77QTlS8O7CvAQ==
From:   Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
To:     stable@vger.kernel.org
Cc:     x86@kernel.org, kvm@vger.kernel.org, bp@alien8.de,
        pbonzini@redhat.com, peterz@infradead.org, jpoimboe@kernel.org
Subject: [PATCH 5.4 12/37] x86/entry: Add kernel IBRS implementation
Date:   Mon,  3 Oct 2022 10:10:13 -0300
Message-Id: <20221003131038.12645-13-cascardo@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221003131038.12645-1-cascardo@canonical.com>
References: <20221003131038.12645-1-cascardo@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
[cascardo: entry fixups because of missing UNTRAIN_RET]
[cascardo: conflicts on fsgsbase]
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
---
 arch/x86/entry/calling.h           | 58 ++++++++++++++++++++++++++++++
 arch/x86/entry/entry_64.S          | 29 ++++++++++++++-
 arch/x86/entry/entry_64_compat.S   | 11 +++++-
 arch/x86/include/asm/cpufeatures.h |  2 +-
 4 files changed, 97 insertions(+), 3 deletions(-)

diff --git a/arch/x86/entry/calling.h b/arch/x86/entry/calling.h
index 7950219aa2fa..29e5675c6d4f 100644
--- a/arch/x86/entry/calling.h
+++ b/arch/x86/entry/calling.h
@@ -6,6 +6,8 @@
 #include <asm/percpu.h>
 #include <asm/asm-offsets.h>
 #include <asm/processor-flags.h>
+#include <asm/msr.h>
+#include <asm/nospec-branch.h>
 
 /*
 
@@ -308,6 +310,62 @@ For 32-bit we have the following conventions - kernel is built with
 
 #endif
 
+/*
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
 /*
  * Mitigate Spectre v1 for conditional swapgs code paths.
  *
diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index 6be2e2952b83..4a45808a27c2 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -172,6 +172,10 @@ GLOBAL(entry_SYSCALL_64_after_hwframe)
 	/* IRQs are off. */
 	movq	%rax, %rdi
 	movq	%rsp, %rsi
+
+	/* clobbers %rax, make sure it is after saving the syscall nr */
+	IBRS_ENTER
+
 	call	do_syscall_64		/* returns with IRQs disabled */
 
 	TRACE_IRQS_IRETQ		/* we're about to change IF */
@@ -248,6 +252,7 @@ GLOBAL(entry_SYSCALL_64_after_hwframe)
 	 * perf profiles. Nothing jumps here.
 	 */
 syscall_return_via_sysret:
+	IBRS_EXIT
 	POP_REGS pop_rdi=0
 
 	/*
@@ -621,6 +626,7 @@ GLOBAL(retint_user)
 	TRACE_IRQS_IRETQ
 
 GLOBAL(swapgs_restore_regs_and_return_to_usermode)
+	IBRS_EXIT
 #ifdef CONFIG_DEBUG_ENTRY
 	/* Assert that pt_regs indicates user mode. */
 	testb	$3, CS(%rsp)
@@ -1247,7 +1253,13 @@ ENTRY(paranoid_entry)
 	 */
 	FENCE_SWAPGS_KERNEL_ENTRY
 
-	ret
+	/*
+	 * Once we have CR3 and %GS setup save and set SPEC_CTRL. Just like
+	 * CR3 above, keep the old value in a callee saved register.
+	 */
+	IBRS_ENTER save_reg=%r15
+
+	RET
 END(paranoid_entry)
 
 /*
@@ -1275,12 +1287,20 @@ ENTRY(paranoid_exit)
 	jmp	.Lparanoid_exit_restore
 .Lparanoid_exit_no_swapgs:
 	TRACE_IRQS_IRETQ_DEBUG
+
+	/*
+	 * Must restore IBRS state before both CR3 and %GS since we need access
+	 * to the per-CPU x86_spec_ctrl_shadow variable.
+	 */
+	IBRS_EXIT save_reg=%r15
+
 	/* Always restore stashed CR3 value (see paranoid_entry) */
 	RESTORE_CR3	scratch_reg=%rbx save_reg=%r14
 .Lparanoid_exit_restore:
 	jmp restore_regs_and_return_to_kernel
 END(paranoid_exit)
 
+
 /*
  * Save all registers in pt_regs, and switch GS if needed.
  */
@@ -1300,6 +1320,7 @@ ENTRY(error_entry)
 	FENCE_SWAPGS_USER_ENTRY
 	/* We have user CR3.  Change to kernel CR3. */
 	SWITCH_TO_KERNEL_CR3 scratch_reg=%rax
+	IBRS_ENTER
 
 .Lerror_entry_from_usermode_after_swapgs:
 	/* Put us onto the real thread stack. */
@@ -1355,6 +1376,7 @@ ENTRY(error_entry)
 	SWAPGS
 	FENCE_SWAPGS_USER_ENTRY
 	SWITCH_TO_KERNEL_CR3 scratch_reg=%rax
+	IBRS_ENTER
 
 	/*
 	 * Pretend that the exception came from user mode: set up pt_regs
@@ -1460,6 +1482,8 @@ ENTRY(nmi)
 	PUSH_AND_CLEAR_REGS rdx=(%rdx)
 	ENCODE_FRAME_POINTER
 
+	IBRS_ENTER
+
 	/*
 	 * At this point we no longer need to worry about stack damage
 	 * due to nesting -- we're on the normal thread stack and we're
@@ -1683,6 +1707,9 @@ end_repeat_nmi:
 	movq	$-1, %rsi
 	call	do_nmi
 
+	/* Always restore stashed SPEC_CTRL value (see paranoid_entry) */
+	IBRS_EXIT save_reg=%r15
+
 	/* Always restore stashed CR3 value (see paranoid_entry) */
 	RESTORE_CR3 scratch_reg=%r15 save_reg=%r14
 
diff --git a/arch/x86/entry/entry_64_compat.S b/arch/x86/entry/entry_64_compat.S
index 39913770a44d..c3c4ea4a6711 100644
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
@@ -253,6 +256,8 @@ GLOBAL(entry_SYSCALL_compat_after_hwframe)
 	 */
 	TRACE_IRQS_OFF
 
+	IBRS_ENTER
+
 	movq	%rsp, %rdi
 	call	do_fast_syscall_32
 	/* XEN PV guests always use IRET path */
@@ -267,6 +272,9 @@ sysret32_from_system_call:
 	 */
 	STACKLEAK_ERASE
 	TRACE_IRQS_ON			/* User mode traces as IRQs on. */
+
+	IBRS_EXIT
+
 	movq	RBX(%rsp), %rbx		/* pt_regs->rbx */
 	movq	RBP(%rsp), %rbp		/* pt_regs->rbp */
 	movq	EFLAGS(%rsp), %r11	/* pt_regs->flags (in r11) */
@@ -408,6 +416,7 @@ ENTRY(entry_INT80_compat)
 	 * gate turned them off.
 	 */
 	TRACE_IRQS_OFF
+	IBRS_ENTER
 
 	movq	%rsp, %rdi
 	call	do_int80_syscall_32
diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 501e37e29bc8..0c0afb91c7c2 100644
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
-- 
2.34.1

