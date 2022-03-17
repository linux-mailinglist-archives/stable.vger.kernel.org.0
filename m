Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A4854DC608
	for <lists+stable@lfdr.de>; Thu, 17 Mar 2022 13:47:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233750AbiCQMsZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Mar 2022 08:48:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233766AbiCQMsY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Mar 2022 08:48:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9C621EE8D9;
        Thu, 17 Mar 2022 05:47:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4503C61228;
        Thu, 17 Mar 2022 12:47:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47D98C340ED;
        Thu, 17 Mar 2022 12:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647521222;
        bh=RK4ERw2Rg/II1b/EByYoqNs/xivZcah1M04OC18GMng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hrfvpZJtP4HGCYRRDFD2lOhcck7LhnTp8Jecgadj5V4xCYuaer17N+a9ag9dtzCLB
         Z6Vz927jIDQonOFD4zTYXUKsXAZWws75oYs2S2TnYUF1acdgAC/8+2H8pVcT2h5p8+
         HNT+5kFAJKy1kS669fNF8GE8u9kP7GlmKpY6757U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 17/43] arm64: entry: Add vectors that have the bhb mitigation sequences
Date:   Thu, 17 Mar 2022 13:45:28 +0100
Message-Id: <20220317124528.153458344@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220317124527.672236844@linuxfoundation.org>
References: <20220317124527.672236844@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Morse <james.morse@arm.com>

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/assembler.h | 24 ++++++++++++++
 arch/arm64/include/asm/vectors.h   | 34 +++++++++++++++++++
 arch/arm64/kernel/entry.S          | 53 +++++++++++++++++++++++++-----
 include/linux/arm-smccc.h          |  5 +++
 4 files changed, 107 insertions(+), 9 deletions(-)
 create mode 100644 arch/arm64/include/asm/vectors.h

diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
index 4a4258f17c86..1279e4f5bd8f 100644
--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -757,4 +757,28 @@ USER(\label, ic	ivau, \tmp2)			// invalidate I line PoU
 .Lyield_out_\@ :
 	.endm
 
+	.macro __mitigate_spectre_bhb_loop      tmp
+#ifdef CONFIG_MITIGATE_SPECTRE_BRANCH_HISTORY
+	mov	\tmp, #32
+.Lspectre_bhb_loop\@:
+	b	. + 4
+	subs	\tmp, \tmp, #1
+	b.ne	.Lspectre_bhb_loop\@
+	sb
+#endif /* CONFIG_MITIGATE_SPECTRE_BRANCH_HISTORY */
+	.endm
+
+	/* Save/restores x0-x3 to the stack */
+	.macro __mitigate_spectre_bhb_fw
+#ifdef CONFIG_MITIGATE_SPECTRE_BRANCH_HISTORY
+	stp	x0, x1, [sp, #-16]!
+	stp	x2, x3, [sp, #-16]!
+	mov	w0, #ARM_SMCCC_ARCH_WORKAROUND_3
+alternative_cb	smccc_patch_fw_mitigation_conduit
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
index 1bc33f506bb1..14351ee5e812 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -1063,13 +1063,26 @@ alternative_else_nop_endif
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
@@ -1097,6 +1110,15 @@ alternative_else_nop_endif
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
@@ -1104,6 +1126,9 @@ alternative_else_nop_endif
 
 	.macro tramp_exit, regsize = 64
 	adr	x30, tramp_vectors
+#ifdef CONFIG_MITIGATE_SPECTRE_BRANCH_HISTORY
+	add	x30, x30, SZ_4K
+#endif
 	msr	vbar_el1, x30
 	ldr	lr, [sp, #S_LR]
 	tramp_unmap_kernel	x29
@@ -1115,26 +1140,32 @@ alternative_else_nop_endif
 	sb
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
@@ -1161,7 +1192,7 @@ __entry_tramp_data_start:
  * Exception vectors for spectre mitigations on entry from EL1 when
  * kpti is not in use.
  */
-	.macro generate_el1_vector
+	.macro generate_el1_vector, bhb
 .Lvector_start\@:
 	kernel_ventry	1, sync_invalid			// Synchronous EL1t
 	kernel_ventry	1, irq_invalid			// IRQ EL1t
@@ -1174,17 +1205,21 @@ __entry_tramp_data_start:
 	kernel_ventry	1, error			// Error EL1h
 
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
 SYM_CODE_START(__bp_harden_el1_vectors)
-	generate_el1_vector
+#ifdef CONFIG_MITIGATE_SPECTRE_BRANCH_HISTORY
+	generate_el1_vector	bhb=BHB_MITIGATION_LOOP
+	generate_el1_vector	bhb=BHB_MITIGATION_FW
+#endif /* CONFIG_MITIGATE_SPECTRE_BRANCH_HISTORY */
 SYM_CODE_END(__bp_harden_el1_vectors)
 	.popsection
 
diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
index 4e97ba64dbb4..3e6ef64e74d3 100644
--- a/include/linux/arm-smccc.h
+++ b/include/linux/arm-smccc.h
@@ -76,6 +76,11 @@
 			   ARM_SMCCC_SMC_32,				\
 			   0, 0x7fff)
 
+#define ARM_SMCCC_ARCH_WORKAROUND_3					\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
+			   ARM_SMCCC_SMC_32,				\
+			   0, 0x3fff)
+
 #define SMCCC_ARCH_WORKAROUND_RET_UNAFFECTED	1
 
 #ifndef __ASSEMBLY__
-- 
2.34.1



