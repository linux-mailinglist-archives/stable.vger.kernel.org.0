Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A80E4D4B20
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 15:56:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244872AbiCJOeD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 09:34:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245121AbiCJOaI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 09:30:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A28B167F9C;
        Thu, 10 Mar 2022 06:25:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 193A6B82544;
        Thu, 10 Mar 2022 14:25:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88066C36AE5;
        Thu, 10 Mar 2022 14:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646922323;
        bh=dUq87xpJ+d6NqExqnKaLDlps4HA8AtfE6Mg9Q3ce9NY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X8eMDNculFE2qXXPYBnRhRKAPdD83IWKEg+IQnQ0qDnnrW6wu7lL3C+A0Vw+WTDBd
         jV8efaeYjwcKA3aICiuBvG4IYWAM0ZeAs5UF3zKf0/rGVksB7Kq5JkZiVFkT2Svs6h
         phJ9HATLEx75dZuw2zO27Vh93M/TCGO/K+EFAx3Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>
Subject: [PATCH 5.10 41/58] arm64: Use the clearbhb instruction in mitigations
Date:   Thu, 10 Mar 2022 15:19:01 +0100
Message-Id: <20220310140814.040787017@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220310140812.869208747@linuxfoundation.org>
References: <20220310140812.869208747@linuxfoundation.org>
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
[ modified for stable: Use a KVM vector template instead of alternatives,
  removed bitmap of mitigations ]
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/assembler.h  |    7 +++++++
 arch/arm64/include/asm/cpufeature.h |   13 +++++++++++++
 arch/arm64/include/asm/insn.h       |    1 +
 arch/arm64/include/asm/kvm_asm.h    |    2 ++
 arch/arm64/include/asm/sysreg.h     |    1 +
 arch/arm64/include/asm/vectors.h    |    7 +++++++
 arch/arm64/kernel/cpufeature.c      |    1 +
 arch/arm64/kernel/entry.S           |    8 ++++++++
 arch/arm64/kernel/proton-pack.c     |   12 ++++++++++++
 arch/arm64/kvm/hyp/smccc_wa.S       |    9 +++++++++
 10 files changed, 61 insertions(+)

--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -98,6 +98,13 @@
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
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -621,6 +621,19 @@ static inline bool supports_csv2p3(int s
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
 static inline bool system_supports_32bit_el0(void)
 {
 	return cpus_have_const_cap(ARM64_HAS_32BIT_EL0);
--- a/arch/arm64/include/asm/insn.h
+++ b/arch/arm64/include/asm/insn.h
@@ -65,6 +65,7 @@ enum aarch64_insn_hint_cr_op {
 	AARCH64_INSN_HINT_PSB  = 0x11 << 5,
 	AARCH64_INSN_HINT_TSB  = 0x12 << 5,
 	AARCH64_INSN_HINT_CSDB = 0x14 << 5,
+	AARCH64_INSN_HINT_CLEARBHB = 0x16 << 5,
 
 	AARCH64_INSN_HINT_BTI   = 0x20 << 5,
 	AARCH64_INSN_HINT_BTIC  = 0x22 << 5,
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -37,6 +37,7 @@
 #define __SMCCC_WORKAROUND_1_SMC_SZ 36
 #define __SMCCC_WORKAROUND_3_SMC_SZ 36
 #define __SPECTRE_BHB_LOOP_SZ       44
+#define __SPECTRE_BHB_CLEARBHB_SZ   12
 
 #define KVM_HOST_SMCCC_ID(id)						\
 	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
@@ -205,6 +206,7 @@ extern char __smccc_workaround_3_smc[__S
 extern char __spectre_bhb_loop_k8[__SPECTRE_BHB_LOOP_SZ];
 extern char __spectre_bhb_loop_k24[__SPECTRE_BHB_LOOP_SZ];
 extern char __spectre_bhb_loop_k32[__SPECTRE_BHB_LOOP_SZ];
+extern char __spectre_bhb_clearbhb[__SPECTRE_BHB_LOOP_SZ];
 
 /*
  * Obtain the PC-relative address of a kernel symbol
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -689,6 +689,7 @@
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
@@ -211,6 +211,7 @@ static const struct arm64_ftr_bits ftr_i
 };
 
 static const struct arm64_ftr_bits ftr_id_aa64isar2[] = {
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_HIGHER_SAFE, ID_AA64ISAR2_CLEARBHB_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64ISAR2_RPRES_SHIFT, 4, 0),
 	ARM64_FTR_END,
 };
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -827,6 +827,7 @@ alternative_else_nop_endif
 #define BHB_MITIGATION_NONE	0
 #define BHB_MITIGATION_LOOP	1
 #define BHB_MITIGATION_FW	2
+#define BHB_MITIGATION_INSN	3
 
 	.macro tramp_ventry, vector_start, regsize, kpti, bhb
 	.align	7
@@ -843,6 +844,11 @@ alternative_else_nop_endif
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
@@ -919,6 +925,7 @@ SYM_CODE_START_NOALIGN(tramp_vectors)
 #ifdef CONFIG_MITIGATE_SPECTRE_BRANCH_HISTORY
 	generate_tramp_vector	kpti=1, bhb=BHB_MITIGATION_LOOP
 	generate_tramp_vector	kpti=1, bhb=BHB_MITIGATION_FW
+	generate_tramp_vector	kpti=1, bhb=BHB_MITIGATION_INSN
 #endif /* CONFIG_MITIGATE_SPECTRE_BRANCH_HISTORY */
 	generate_tramp_vector	kpti=1, bhb=BHB_MITIGATION_NONE
 SYM_CODE_END(tramp_vectors)
@@ -981,6 +988,7 @@ SYM_CODE_START(__bp_harden_el1_vectors)
 #ifdef CONFIG_MITIGATE_SPECTRE_BRANCH_HISTORY
 	generate_el1_vector	bhb=BHB_MITIGATION_LOOP
 	generate_el1_vector	bhb=BHB_MITIGATION_FW
+	generate_el1_vector	bhb=BHB_MITIGATION_INSN
 #endif /* CONFIG_MITIGATE_SPECTRE_BRANCH_HISTORY */
 SYM_CODE_END(__bp_harden_el1_vectors)
 	.popsection
--- a/arch/arm64/kernel/proton-pack.c
+++ b/arch/arm64/kernel/proton-pack.c
@@ -824,6 +824,7 @@ int arch_prctl_spec_ctrl_get(struct task
  * - Mitigated by a branchy loop a CPU specific number of times, and listed
  *   in our "loop mitigated list".
  * - Mitigated in software by the firmware Spectre v2 call.
+ * - Has the ClearBHB instruction to perform the mitigation.
  * - Has the 'Exception Clears Branch History Buffer' (ECBHB) feature, so no
  *   software mitigation in the vectors is needed.
  * - Has CSV2.3, so is unaffected.
@@ -949,6 +950,9 @@ bool is_spectre_bhb_affected(const struc
 	if (supports_csv2p3(scope))
 		return false;
 
+	if (supports_clearbhb(scope))
+		return true;
+
 	if (spectre_bhb_loop_affected(scope))
 		return true;
 
@@ -987,6 +991,8 @@ static int kvm_bhb_get_vecs_size(const c
 		 start == __spectre_bhb_loop_k24 ||
 		 start == __spectre_bhb_loop_k32)
 		return __SPECTRE_BHB_LOOP_SZ;
+	else if (start == __spectre_bhb_clearbhb)
+		return __SPECTRE_BHB_CLEARBHB_SZ;
 
 	return 0;
 }
@@ -1027,6 +1033,7 @@ static void kvm_setup_bhb_slot(const cha
 #define __spectre_bhb_loop_k8 NULL
 #define __spectre_bhb_loop_k24 NULL
 #define __spectre_bhb_loop_k32 NULL
+#define __spectre_bhb_clearbhb NULL
 
 static void kvm_setup_bhb_slot(const char *hyp_vecs_start) { }
 #endif /* CONFIG_KVM */
@@ -1046,6 +1053,11 @@ void spectre_bhb_enable_mitigation(const
 		pr_info_once("spectre-bhb mitigation disabled by command line option\n");
 	} else if (supports_ecbhb(SCOPE_LOCAL_CPU)) {
 		state = SPECTRE_MITIGATED;
+	} else if (supports_clearbhb(SCOPE_LOCAL_CPU)) {
+		kvm_setup_bhb_slot(__spectre_bhb_clearbhb);
+		this_cpu_set_vectors(EL1_VECTOR_BHB_CLEAR_INSN);
+
+		state = SPECTRE_MITIGATED;
 	} else if (spectre_bhb_loop_affected(SCOPE_LOCAL_CPU)) {
 		switch (spectre_bhb_loop_affected(SCOPE_SYSTEM)) {
 		case 8:
--- a/arch/arm64/kvm/hyp/smccc_wa.S
+++ b/arch/arm64/kvm/hyp/smccc_wa.S
@@ -96,3 +96,12 @@ SYM_DATA_START(__spectre_bhb_loop_k32)
 1:	.org __spectre_bhb_loop_k32 + __SPECTRE_BHB_LOOP_SZ
 	.org 1b
 SYM_DATA_END(__spectre_bhb_loop_k32)
+
+	.global	__spectre_bhb_clearbhb
+SYM_DATA_START(__spectre_bhb_clearbhb)
+	esb
+	clearbhb
+	isb
+1:	.org __spectre_bhb_clearbhb + __SPECTRE_BHB_CLEARBHB_SZ
+	.org 1b
+SYM_DATA_END(__spectre_bhb_clearbhb)


