Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 104554EE096
	for <lists+stable@lfdr.de>; Thu, 31 Mar 2022 20:34:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234573AbiCaSgi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Mar 2022 14:36:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235407AbiCaSge (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Mar 2022 14:36:34 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2C02F1F0CB8;
        Thu, 31 Mar 2022 11:34:46 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0F9EC139F;
        Thu, 31 Mar 2022 11:34:46 -0700 (PDT)
Received: from eglon.cambridge.arm.com (eglon.cambridge.arm.com [10.1.196.218])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4BD683F718;
        Thu, 31 Mar 2022 11:34:45 -0700 (PDT)
From:   James Morse <james.morse@arm.com>
To:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     james.morse@arm.com, catalin.marinas@arm.com
Subject: [stable:PATCH v4.14.274 19/27] arm64: entry: Add vectors that have the bhb mitigation sequences
Date:   Thu, 31 Mar 2022 19:33:52 +0100
Message-Id: <20220331183400.73183-20-james.morse@arm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220331183400.73183-1-james.morse@arm.com>
References: <20220331183400.73183-1-james.morse@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit ba2689234be92024e5635d30fe744f4853ad97db upstream.

Some CPUs affected by Spectre-BHB need a sequence of branches, or a
firmware call to be run before any indirect branch. This needs to go
in the vectors. No CPU needs both.

While this can be patched in, it would run on all CPUs as there is a
single set of vectors. If only one part of a big/little combination is
affected, the unaffected CPUs have to run the mitigation too.

Create extra vectors that include the sequence. Subsequent patches will
allow affected CPUs to select this set of vectors. Later patches will
modify the loop count to match what the CPU requires.

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: James Morse <james.morse@arm.com>
---
 arch/arm64/include/asm/assembler.h | 25 ++++++++++++++
 arch/arm64/include/asm/vectors.h   | 34 +++++++++++++++++++
 arch/arm64/kernel/entry.S          | 53 +++++++++++++++++++++++++-----
 include/linux/arm-smccc.h          |  7 ++++
 4 files changed, 110 insertions(+), 9 deletions(-)
 create mode 100644 arch/arm64/include/asm/vectors.h

diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
index 02d73d83f0de..93316937f9ce 100644
--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -549,4 +549,29 @@ alternative_endif
 .Ldone\@:
 	.endm
 
+	.macro __mitigate_spectre_bhb_loop      tmp
+#ifdef CONFIG_MITIGATE_SPECTRE_BRANCH_HISTORY
+	mov	\tmp, #32
+.Lspectre_bhb_loop\@:
+	b	. + 4
+	subs	\tmp, \tmp, #1
+	b.ne	.Lspectre_bhb_loop\@
+	dsb	nsh
+	isb
+#endif /* CONFIG_MITIGATE_SPECTRE_BRANCH_HISTORY */
+	.endm
+
+	/* Save/restores x0-x3 to the stack */
+	.macro __mitigate_spectre_bhb_fw
+#ifdef CONFIG_MITIGATE_SPECTRE_BRANCH_HISTORY
+	stp	x0, x1, [sp, #-16]!
+	stp	x2, x3, [sp, #-16]!
+	mov	w0, #ARM_SMCCC_ARCH_WORKAROUND_3
+alternative_cb	arm64_update_smccc_conduit
+	nop					// Patched to SMC/HVC #0
+alternative_cb_end
+	ldp	x2, x3, [sp], #16
+	ldp	x0, x1, [sp], #16
+#endif /* CONFIG_MITIGATE_SPECTRE_BRANCH_HISTORY */
+	.endm
 #endif	/* __ASM_ASSEMBLER_H */
diff --git a/arch/arm64/include/asm/vectors.h b/arch/arm64/include/asm/vectors.h
new file mode 100644
index 000000000000..16ca74260375
--- /dev/null
+++ b/arch/arm64/include/asm/vectors.h
@@ -0,0 +1,34 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2022 ARM Ltd.
+ */
+#ifndef __ASM_VECTORS_H
+#define __ASM_VECTORS_H
+
+/*
+ * Note: the order of this enum corresponds to two arrays in entry.S:
+ * tramp_vecs and __bp_harden_el1_vectors. By default the canonical
+ * 'full fat' vectors are used directly.
+ */
+enum arm64_bp_harden_el1_vectors {
+#ifdef CONFIG_MITIGATE_SPECTRE_BRANCH_HISTORY
+	/*
+	 * Perform the BHB loop mitigation, before branching to the canonical
+	 * vectors.
+	 */
+	EL1_VECTOR_BHB_LOOP,
+
+	/*
+	 * Make the SMC call for firmware mitigation, before branching to the
+	 * canonical vectors.
+	 */
+	EL1_VECTOR_BHB_FW,
+#endif /* CONFIG_MITIGATE_SPECTRE_BRANCH_HISTORY */
+
+	/*
+	 * Remap the kernel before branching to the canonical vectors.
+	 */
+	EL1_VECTOR_KPTI,
+};
+
+#endif /* __ASM_VECTORS_H */
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index bf6f4513c81f..caf6f9cb8fd6 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -1022,13 +1022,26 @@ alternative_else_nop_endif
 	sub	\dst, \dst, PAGE_SIZE
 	.endm
 
-	.macro tramp_ventry, vector_start, regsize, kpti
+
+#define BHB_MITIGATION_NONE	0
+#define BHB_MITIGATION_LOOP	1
+#define BHB_MITIGATION_FW	2
+
+	.macro tramp_ventry, vector_start, regsize, kpti, bhb
 	.align	7
 1:
 	.if	\regsize == 64
 	msr	tpidrro_el0, x30	// Restored in kernel_ventry
 	.endif
 
+	.if	\bhb == BHB_MITIGATION_LOOP
+	/*
+	 * This sequence must appear before the first indirect branch. i.e. the
+	 * ret out of tramp_ventry. It appears here because x30 is free.
+	 */
+	__mitigate_spectre_bhb_loop	x30
+	.endif // \bhb == BHB_MITIGATION_LOOP
+
 	.if	\kpti == 1
 	/*
 	 * Defend against branch aliasing attacks by pushing a dummy
@@ -1053,6 +1066,15 @@ alternative_insn isb, nop, ARM64_WORKAROUND_QCOM_FALKOR_E1003
 	ldr	x30, =vectors
 	.endif // \kpti == 1
 
+	.if	\bhb == BHB_MITIGATION_FW
+	/*
+	 * The firmware sequence must appear before the first indirect branch.
+	 * i.e. the ret out of tramp_ventry. But it also needs the stack to be
+	 * mapped to save/restore the registers the SMC clobbers.
+	 */
+	__mitigate_spectre_bhb_fw
+	.endif // \bhb == BHB_MITIGATION_FW
+
 	add	x30, x30, #(1b - \vector_start + 4)
 	ret
 .org 1b + 128	// Did we overflow the ventry slot?
@@ -1060,6 +1082,9 @@ alternative_insn isb, nop, ARM64_WORKAROUND_QCOM_FALKOR_E1003
 
 	.macro tramp_exit, regsize = 64
 	adr	x30, tramp_vectors
+#ifdef CONFIG_MITIGATE_SPECTRE_BRANCH_HISTORY
+	add	x30, x30, SZ_4K
+#endif
 	msr	vbar_el1, x30
 	ldr	lr, [sp, #S_LR]
 	tramp_unmap_kernel	x29
@@ -1070,26 +1095,32 @@ alternative_insn isb, nop, ARM64_WORKAROUND_QCOM_FALKOR_E1003
 	eret
 	.endm
 
-	.macro	generate_tramp_vector,	kpti
+	.macro	generate_tramp_vector,	kpti, bhb
 .Lvector_start\@:
 	.space	0x400
 
 	.rept	4
-	tramp_ventry	.Lvector_start\@, 64, \kpti
+	tramp_ventry	.Lvector_start\@, 64, \kpti, \bhb
 	.endr
 	.rept	4
-	tramp_ventry	.Lvector_start\@, 32, \kpti
+	tramp_ventry	.Lvector_start\@, 32, \kpti, \bhb
 	.endr
 	.endm
 
 #ifdef CONFIG_UNMAP_KERNEL_AT_EL0
 /*
  * Exception vectors trampoline.
+ * The order must match __bp_harden_el1_vectors and the
+ * arm64_bp_harden_el1_vectors enum.
  */
 	.pushsection ".entry.tramp.text", "ax"
 	.align	11
 ENTRY(tramp_vectors)
-	generate_tramp_vector	kpti=1
+#ifdef CONFIG_MITIGATE_SPECTRE_BRANCH_HISTORY
+	generate_tramp_vector	kpti=1, bhb=BHB_MITIGATION_LOOP
+	generate_tramp_vector	kpti=1, bhb=BHB_MITIGATION_FW
+#endif /* CONFIG_MITIGATE_SPECTRE_BRANCH_HISTORY */
+	generate_tramp_vector	kpti=1, bhb=BHB_MITIGATION_NONE
 END(tramp_vectors)
 
 ENTRY(tramp_exit_native)
@@ -1116,7 +1147,7 @@ __entry_tramp_data_start:
  * Exception vectors for spectre mitigations on entry from EL1 when
  * kpti is not in use.
  */
-	.macro generate_el1_vector
+	.macro generate_el1_vector, bhb
 .Lvector_start\@:
 	kernel_ventry	1, sync_invalid			// Synchronous EL1t
 	kernel_ventry	1, irq_invalid			// IRQ EL1t
@@ -1129,17 +1160,21 @@ __entry_tramp_data_start:
 	kernel_ventry	1, error_invalid		// Error EL1h
 
 	.rept	4
-	tramp_ventry	.Lvector_start\@, 64, kpti=0
+	tramp_ventry	.Lvector_start\@, 64, 0, \bhb
 	.endr
 	.rept 4
-	tramp_ventry	.Lvector_start\@, 32, kpti=0
+	tramp_ventry	.Lvector_start\@, 32, 0, \bhb
 	.endr
 	.endm
 
+/* The order must match tramp_vecs and the arm64_bp_harden_el1_vectors enum. */
 	.pushsection ".entry.text", "ax"
 	.align	11
 ENTRY(__bp_harden_el1_vectors)
-	generate_el1_vector
+#ifdef CONFIG_MITIGATE_SPECTRE_BRANCH_HISTORY
+	generate_el1_vector	bhb=BHB_MITIGATION_LOOP
+	generate_el1_vector	bhb=BHB_MITIGATION_FW
+#endif /* CONFIG_MITIGATE_SPECTRE_BRANCH_HISTORY */
 END(__bp_harden_el1_vectors)
 	.popsection
 
diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
index 6366b04c7d5f..040266891414 100644
--- a/include/linux/arm-smccc.h
+++ b/include/linux/arm-smccc.h
@@ -85,6 +85,13 @@
 			   ARM_SMCCC_SMC_32,				\
 			   0, 0x7fff)
 
+#define ARM_SMCCC_ARCH_WORKAROUND_3					\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
+			   ARM_SMCCC_SMC_32,				\
+			   0, 0x3fff)
+
+#define SMCCC_ARCH_WORKAROUND_RET_UNAFFECTED	1
+
 #ifndef __ASSEMBLY__
 
 #include <linux/linkage.h>
-- 
2.30.2

