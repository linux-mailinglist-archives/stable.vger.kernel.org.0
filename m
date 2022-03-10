Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3D2B4D4B89
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 16:00:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245237AbiCJOei (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 09:34:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344074AbiCJObl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 09:31:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D276220FC;
        Thu, 10 Mar 2022 06:30:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 41345B81E9E;
        Thu, 10 Mar 2022 14:30:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6670C340E8;
        Thu, 10 Mar 2022 14:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646922636;
        bh=BKQwgcsUHNPDyTyOPQOPIY54RBKLpWsvqRqfJyqoGZc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vU5m+6QjBEUyaKkld9D9Ns1Eyp6J5sXtqeNTeGCYZGvaqoxh/5avuDkdkDTDkPEMu
         xz2cnS2ArPJy4xy7jsXHTwja+kUyI5HNMnqRRn+e+jCT3vyyn0Y/21aIfaiSGchTEa
         Hv2fqcEeQHzSSjU2xI/H3qF9txodMlDx4E7GFNi4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>
Subject: [PATCH 5.15 40/58] arm64: Use the clearbhb instruction in mitigations
Date:   Thu, 10 Mar 2022 15:19:29 +0100
Message-Id: <20220310140814.124248005@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220310140812.983088611@linuxfoundation.org>
References: <20220310140812.983088611@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Morse <james.morse@arm.com>

commit 228a26b912287934789023b4132ba76065d9491c upstream.

Future CPUs may implement a clearbhb instruction that is sufficient
to mitigate SpectreBHB. CPUs that implement this instruction, but
not CSV2.3 must be affected by Spectre-BHB.

Add support to use this instruction as the BHB mitigation on CPUs
that support it. The instruction is in the hint space, so it will
be treated by a NOP as older CPUs.

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/assembler.h  |   17 +++++++++++++++++
 arch/arm64/include/asm/cpufeature.h |   13 +++++++++++++
 arch/arm64/include/asm/insn.h       |    1 +
 arch/arm64/include/asm/sysreg.h     |    1 +
 arch/arm64/include/asm/vectors.h    |    7 +++++++
 arch/arm64/kernel/cpufeature.c      |    1 +
 arch/arm64/kernel/entry.S           |    8 ++++++++
 arch/arm64/kernel/image-vars.h      |    1 +
 arch/arm64/kernel/proton-pack.c     |   29 +++++++++++++++++++++++++++++
 arch/arm64/kvm/hyp/hyp-entry.S      |    1 +
 10 files changed, 79 insertions(+)

--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -108,6 +108,13 @@
 	.endm
 
 /*
+ * Clear Branch History instruction
+ */
+	.macro clearbhb
+	hint	#22
+	.endm
+
+/*
  * Speculation barrier
  */
 	.macro	sb
@@ -866,4 +873,14 @@ alternative_cb_end
 	ldp	x0, x1, [sp], #16
 #endif /* CONFIG_MITIGATE_SPECTRE_BRANCH_HISTORY */
 	.endm
+
+	.macro mitigate_spectre_bhb_clear_insn
+#ifdef CONFIG_MITIGATE_SPECTRE_BRANCH_HISTORY
+alternative_cb	spectre_bhb_patch_clearbhb
+	/* Patched to NOP when not supported */
+	clearbhb
+	isb
+alternative_cb_end
+#endif /* CONFIG_MITIGATE_SPECTRE_BRANCH_HISTORY */
+	.endm
 #endif	/* __ASM_ASSEMBLER_H */
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -653,6 +653,19 @@ static inline bool supports_csv2p3(int s
 	return csv2_val == 3;
 }
 
+static inline bool supports_clearbhb(int scope)
+{
+	u64 isar2;
+
+	if (scope == SCOPE_LOCAL_CPU)
+		isar2 = read_sysreg_s(SYS_ID_AA64ISAR2_EL1);
+	else
+		isar2 = read_sanitised_ftr_reg(SYS_ID_AA64ISAR2_EL1);
+
+	return cpuid_feature_extract_unsigned_field(isar2,
+						    ID_AA64ISAR2_CLEARBHB_SHIFT);
+}
+
 const struct cpumask *system_32bit_el0_cpumask(void);
 DECLARE_STATIC_KEY_FALSE(arm64_mismatched_32bit_el0);
 
--- a/arch/arm64/include/asm/insn.h
+++ b/arch/arm64/include/asm/insn.h
@@ -65,6 +65,7 @@ enum aarch64_insn_hint_cr_op {
 	AARCH64_INSN_HINT_PSB  = 0x11 << 5,
 	AARCH64_INSN_HINT_TSB  = 0x12 << 5,
 	AARCH64_INSN_HINT_CSDB = 0x14 << 5,
+	AARCH64_INSN_HINT_CLEARBHB = 0x16 << 5,
 
 	AARCH64_INSN_HINT_BTI   = 0x20 << 5,
 	AARCH64_INSN_HINT_BTIC  = 0x22 << 5,
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -766,6 +766,7 @@
 #define ID_AA64ISAR1_GPI_IMP_DEF		0x1
 
 /* id_aa64isar2 */
+#define ID_AA64ISAR2_CLEARBHB_SHIFT	28
 #define ID_AA64ISAR2_RPRES_SHIFT	4
 #define ID_AA64ISAR2_WFXT_SHIFT		0
 
--- a/arch/arm64/include/asm/vectors.h
+++ b/arch/arm64/include/asm/vectors.h
@@ -32,6 +32,12 @@ enum arm64_bp_harden_el1_vectors {
 	 * canonical vectors.
 	 */
 	EL1_VECTOR_BHB_FW,
+
+	/*
+	 * Use the ClearBHB instruction, before branching to the canonical
+	 * vectors.
+	 */
+	EL1_VECTOR_BHB_CLEAR_INSN,
 #endif /* CONFIG_MITIGATE_SPECTRE_BRANCH_HISTORY */
 
 	/*
@@ -43,6 +49,7 @@ enum arm64_bp_harden_el1_vectors {
 #ifndef CONFIG_MITIGATE_SPECTRE_BRANCH_HISTORY
 #define EL1_VECTOR_BHB_LOOP		-1
 #define EL1_VECTOR_BHB_FW		-1
+#define EL1_VECTOR_BHB_CLEAR_INSN	-1
 #endif /* !CONFIG_MITIGATE_SPECTRE_BRANCH_HISTORY */
 
 /* The vectors to use on return from EL0. e.g. to remap the kernel */
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -231,6 +231,7 @@ static const struct arm64_ftr_bits ftr_i
 };
 
 static const struct arm64_ftr_bits ftr_id_aa64isar2[] = {
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_HIGHER_SAFE, ID_AA64ISAR2_CLEARBHB_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64ISAR2_RPRES_SHIFT, 4, 0),
 	ARM64_FTR_END,
 };
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -657,6 +657,7 @@ alternative_else_nop_endif
 #define BHB_MITIGATION_NONE	0
 #define BHB_MITIGATION_LOOP	1
 #define BHB_MITIGATION_FW	2
+#define BHB_MITIGATION_INSN	3
 
 	.macro tramp_ventry, vector_start, regsize, kpti, bhb
 	.align	7
@@ -673,6 +674,11 @@ alternative_else_nop_endif
 	__mitigate_spectre_bhb_loop	x30
 	.endif // \bhb == BHB_MITIGATION_LOOP
 
+	.if	\bhb == BHB_MITIGATION_INSN
+	clearbhb
+	isb
+	.endif // \bhb == BHB_MITIGATION_INSN
+
 	.if	\kpti == 1
 	/*
 	 * Defend against branch aliasing attacks by pushing a dummy
@@ -749,6 +755,7 @@ SYM_CODE_START_NOALIGN(tramp_vectors)
 #ifdef CONFIG_MITIGATE_SPECTRE_BRANCH_HISTORY
 	generate_tramp_vector	kpti=1, bhb=BHB_MITIGATION_LOOP
 	generate_tramp_vector	kpti=1, bhb=BHB_MITIGATION_FW
+	generate_tramp_vector	kpti=1, bhb=BHB_MITIGATION_INSN
 #endif /* CONFIG_MITIGATE_SPECTRE_BRANCH_HISTORY */
 	generate_tramp_vector	kpti=1, bhb=BHB_MITIGATION_NONE
 SYM_CODE_END(tramp_vectors)
@@ -811,6 +818,7 @@ SYM_CODE_START(__bp_harden_el1_vectors)
 #ifdef CONFIG_MITIGATE_SPECTRE_BRANCH_HISTORY
 	generate_el1_vector	bhb=BHB_MITIGATION_LOOP
 	generate_el1_vector	bhb=BHB_MITIGATION_FW
+	generate_el1_vector	bhb=BHB_MITIGATION_INSN
 #endif /* CONFIG_MITIGATE_SPECTRE_BRANCH_HISTORY */
 SYM_CODE_END(__bp_harden_el1_vectors)
 	.popsection
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -69,6 +69,7 @@ KVM_NVHE_ALIAS(kvm_compute_final_ctr_el0
 KVM_NVHE_ALIAS(spectre_bhb_patch_loop_iter);
 KVM_NVHE_ALIAS(spectre_bhb_patch_loop_mitigation_enable);
 KVM_NVHE_ALIAS(spectre_bhb_patch_wa3);
+KVM_NVHE_ALIAS(spectre_bhb_patch_clearbhb);
 
 /* Global kernel state accessed by nVHE hyp code. */
 KVM_NVHE_ALIAS(kvm_vgic_global_state);
--- a/arch/arm64/kernel/proton-pack.c
+++ b/arch/arm64/kernel/proton-pack.c
@@ -805,6 +805,7 @@ int arch_prctl_spec_ctrl_get(struct task
  * - Mitigated by a branchy loop a CPU specific number of times, and listed
  *   in our "loop mitigated list".
  * - Mitigated in software by the firmware Spectre v2 call.
+ * - Has the ClearBHB instruction to perform the mitigation.
  * - Has the 'Exception Clears Branch History Buffer' (ECBHB) feature, so no
  *   software mitigation in the vectors is needed.
  * - Has CSV2.3, so is unaffected.
@@ -820,6 +821,7 @@ enum bhb_mitigation_bits {
 	BHB_LOOP,
 	BHB_FW,
 	BHB_HW,
+	BHB_INSN,
 };
 static unsigned long system_bhb_mitigations;
 
@@ -937,6 +939,9 @@ bool is_spectre_bhb_affected(const struc
 	if (supports_csv2p3(scope))
 		return false;
 
+	if (supports_clearbhb(scope))
+		return true;
+
 	if (spectre_bhb_loop_affected(scope))
 		return true;
 
@@ -984,6 +989,17 @@ void spectre_bhb_enable_mitigation(const
 	} else if (supports_ecbhb(SCOPE_LOCAL_CPU)) {
 		state = SPECTRE_MITIGATED;
 		set_bit(BHB_HW, &system_bhb_mitigations);
+	} else if (supports_clearbhb(SCOPE_LOCAL_CPU)) {
+		/*
+		 * Ensure KVM uses the indirect vector which will have ClearBHB
+		 * added.
+		 */
+		if (!data->slot)
+			data->slot = HYP_VECTOR_INDIRECT;
+
+		this_cpu_set_vectors(EL1_VECTOR_BHB_CLEAR_INSN);
+		state = SPECTRE_MITIGATED;
+		set_bit(BHB_INSN, &system_bhb_mitigations);
 	} else if (spectre_bhb_loop_affected(SCOPE_LOCAL_CPU)) {
 		/*
 		 * Ensure KVM uses the indirect vector which will have the
@@ -1096,3 +1112,16 @@ void noinstr spectre_bhb_patch_wa3(struc
 
 	*updptr++ = cpu_to_le32(insn);
 }
+
+/* Patched to NOP when not supported */
+void __init spectre_bhb_patch_clearbhb(struct alt_instr *alt,
+				   __le32 *origptr, __le32 *updptr, int nr_inst)
+{
+	BUG_ON(nr_inst != 2);
+
+	if (test_bit(BHB_INSN, &system_bhb_mitigations))
+		return;
+
+	*updptr++ = cpu_to_le32(aarch64_insn_gen_nop());
+	*updptr++ = cpu_to_le32(aarch64_insn_gen_nop());
+}
--- a/arch/arm64/kvm/hyp/hyp-entry.S
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -213,6 +213,7 @@ SYM_CODE_END(__kvm_hyp_vector)
 	.else
 	stp	x0, x1, [sp, #-16]!
 	mitigate_spectre_bhb_loop	x0
+	mitigate_spectre_bhb_clear_insn
 	.endif
 	.if \indirect != 0
 	alternative_cb  kvm_patch_vector_branch


