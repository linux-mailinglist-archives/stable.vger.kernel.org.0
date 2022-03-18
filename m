Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 816FC4DE062
	for <lists+stable@lfdr.de>; Fri, 18 Mar 2022 18:51:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239855AbiCRRv2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Mar 2022 13:51:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239869AbiCRRvM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Mar 2022 13:51:12 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 25B9B18CD24;
        Fri, 18 Mar 2022 10:49:53 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0AF551570;
        Fri, 18 Mar 2022 10:49:53 -0700 (PDT)
Received: from eglon.cambridge.arm.com (eglon.cambridge.arm.com [10.1.196.218])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5F4B53F7B4;
        Fri, 18 Mar 2022 10:49:52 -0700 (PDT)
From:   James Morse <james.morse@arm.com>
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, james.morse@arm.com,
        catalin.marinas@arm.com
Subject: [stable:PATCH v4.19.235 22/22] arm64: Use the clearbhb instruction in mitigations
Date:   Fri, 18 Mar 2022 17:48:42 +0000
Message-Id: <20220318174842.2321061-23-james.morse@arm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220318174842.2321061-1-james.morse@arm.com>
References: <20220318174842.2321061-1-james.morse@arm.com>
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

commit 228a26b912287934789023b4132ba76065d9491c upstream.

Future CPUs may implement a clearbhb instruction that is sufficient
to mitigate SpectreBHB. CPUs that implement this instruction, but
not CSV2.3 must be affected by Spectre-BHB.

Add support to use this instruction as the BHB mitigation on CPUs
that support it. The instruction is in the hint space, so it will
be treated by a NOP as older CPUs.

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
[ modified for stable: Use a KVM vector template instead of alternatives ]
Signed-off-by: James Morse <james.morse@arm.com>
---
 arch/arm64/include/asm/assembler.h  |  7 +++++++
 arch/arm64/include/asm/cpufeature.h | 13 +++++++++++++
 arch/arm64/include/asm/sysreg.h     |  3 +++
 arch/arm64/include/asm/vectors.h    |  7 +++++++
 arch/arm64/kernel/cpu_errata.c      | 14 ++++++++++++++
 arch/arm64/kernel/cpufeature.c      |  1 +
 arch/arm64/kernel/entry.S           |  8 ++++++++
 arch/arm64/kvm/hyp/hyp-entry.S      |  6 ++++++
 8 files changed, 59 insertions(+)

diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
index 3a5336ba745c..fc3d26c954a4 100644
--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -126,6 +126,13 @@
 	hint	#20
 	.endm
 
+/*
+ * Clear Branch History instruction
+ */
+	.macro clearbhb
+	hint	#22
+	.endm
+
 /*
  * Sanitise a 64-bit bounded index wrt speculation, returning zero if out
  * of bounds.
diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 86a7dda74535..05f41d8f7db3 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -497,6 +497,19 @@ static inline bool supports_csv2p3(int scope)
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
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 2afd6f23bef2..e90cf51b87ec 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -527,6 +527,9 @@
 #define ID_AA64ISAR1_JSCVT_SHIFT	12
 #define ID_AA64ISAR1_DPB_SHIFT		0
 
+/* id_aa64isar2 */
+#define ID_AA64ISAR2_CLEARBHB_SHIFT	28
+
 /* id_aa64pfr0 */
 #define ID_AA64PFR0_CSV3_SHIFT		60
 #define ID_AA64PFR0_CSV2_SHIFT		56
diff --git a/arch/arm64/include/asm/vectors.h b/arch/arm64/include/asm/vectors.h
index f222d8e033b3..695583b9a145 100644
--- a/arch/arm64/include/asm/vectors.h
+++ b/arch/arm64/include/asm/vectors.h
@@ -33,6 +33,12 @@ enum arm64_bp_harden_el1_vectors {
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
@@ -44,6 +50,7 @@ enum arm64_bp_harden_el1_vectors {
 #ifndef CONFIG_MITIGATE_SPECTRE_BRANCH_HISTORY
 #define EL1_VECTOR_BHB_LOOP		-1
 #define EL1_VECTOR_BHB_FW		-1
+#define EL1_VECTOR_BHB_CLEAR_INSN	-1
 #endif /* !CONFIG_MITIGATE_SPECTRE_BRANCH_HISTORY */
 
 /* The vectors to use on return from EL0. e.g. to remap the kernel */
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index f96ab92545d7..d0b7dd60861b 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -106,6 +106,8 @@ extern char __spectre_bhb_loop_k24_start[];
 extern char __spectre_bhb_loop_k24_end[];
 extern char __spectre_bhb_loop_k32_start[];
 extern char __spectre_bhb_loop_k32_end[];
+extern char __spectre_bhb_clearbhb_start[];
+extern char __spectre_bhb_clearbhb_end[];
 
 static void __copy_hyp_vect_bpi(int slot, const char *hyp_vecs_start,
 				const char *hyp_vecs_end)
@@ -969,6 +971,7 @@ static void update_mitigation_state(enum mitigation_state *oldp,
  * - Mitigated by a branchy loop a CPU specific number of times, and listed
  *   in our "loop mitigated list".
  * - Mitigated in software by the firmware Spectre v2 call.
+ * - Has the ClearBHB instruction to perform the mitigation.
  * - Has the 'Exception Clears Branch History Buffer' (ECBHB) feature, so no
  *   software mitigation in the vectors is needed.
  * - Has CSV2.3, so is unaffected.
@@ -1108,6 +1111,9 @@ bool is_spectre_bhb_affected(const struct arm64_cpu_capabilities *entry,
 	if (supports_csv2p3(scope))
 		return false;
 
+	if (supports_clearbhb(scope))
+		return true;
+
 	if (spectre_bhb_loop_affected(scope))
 		return true;
 
@@ -1148,6 +1154,8 @@ static const char *kvm_bhb_get_vecs_end(const char *start)
 		return __spectre_bhb_loop_k24_end;
 	else if (start == __spectre_bhb_loop_k32_start)
 		return __spectre_bhb_loop_k32_end;
+	else if (start == __spectre_bhb_clearbhb_start)
+		return __spectre_bhb_clearbhb_end;
 
 	return NULL;
 }
@@ -1187,6 +1195,7 @@ static void kvm_setup_bhb_slot(const char *hyp_vecs_start)
 #define __spectre_bhb_loop_k8_start NULL
 #define __spectre_bhb_loop_k24_start NULL
 #define __spectre_bhb_loop_k32_start NULL
+#define __spectre_bhb_clearbhb_start NULL
 
 static void kvm_setup_bhb_slot(const char *hyp_vecs_start) { };
 #endif
@@ -1205,6 +1214,11 @@ void spectre_bhb_enable_mitigation(const struct arm64_cpu_capabilities *entry)
 	} else if (cpu_mitigations_off()) {
 		pr_info_once("spectre-bhb mitigation disabled by command line option\n");
 	} else if (supports_ecbhb(SCOPE_LOCAL_CPU)) {
+		state = SPECTRE_MITIGATED;
+	} else if (supports_clearbhb(SCOPE_LOCAL_CPU)) {
+		kvm_setup_bhb_slot(__spectre_bhb_clearbhb_start);
+		this_cpu_set_vectors(EL1_VECTOR_BHB_CLEAR_INSN);
+
 		state = SPECTRE_MITIGATED;
 	} else if (spectre_bhb_loop_affected(SCOPE_LOCAL_CPU)) {
 		switch (spectre_bhb_loop_affected(SCOPE_SYSTEM)) {
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 24ce5f5242c9..03b0fdccaf05 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -151,6 +151,7 @@ static const struct arm64_ftr_bits ftr_id_aa64isar1[] = {
 };
 
 static const struct arm64_ftr_bits ftr_id_aa64isar2[] = {
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_HIGHER_SAFE, ID_AA64ISAR2_CLEARBHB_SHIFT, 4, 0),
 	ARM64_FTR_END,
 };
 
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index e64fcb9ead83..85433a84783b 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -981,6 +981,7 @@ alternative_else_nop_endif
 #define BHB_MITIGATION_NONE	0
 #define BHB_MITIGATION_LOOP	1
 #define BHB_MITIGATION_FW	2
+#define BHB_MITIGATION_INSN	3
 
 	.macro tramp_ventry, vector_start, regsize, kpti, bhb
 	.align	7
@@ -997,6 +998,11 @@ alternative_else_nop_endif
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
@@ -1073,6 +1079,7 @@ ENTRY(tramp_vectors)
 #ifdef CONFIG_MITIGATE_SPECTRE_BRANCH_HISTORY
 	generate_tramp_vector	kpti=1, bhb=BHB_MITIGATION_LOOP
 	generate_tramp_vector	kpti=1, bhb=BHB_MITIGATION_FW
+	generate_tramp_vector	kpti=1, bhb=BHB_MITIGATION_INSN
 #endif /* CONFIG_MITIGATE_SPECTRE_BRANCH_HISTORY */
 	generate_tramp_vector	kpti=1, bhb=BHB_MITIGATION_NONE
 END(tramp_vectors)
@@ -1135,6 +1142,7 @@ ENTRY(__bp_harden_el1_vectors)
 #ifdef CONFIG_MITIGATE_SPECTRE_BRANCH_HISTORY
 	generate_el1_vector	bhb=BHB_MITIGATION_LOOP
 	generate_el1_vector	bhb=BHB_MITIGATION_FW
+	generate_el1_vector	bhb=BHB_MITIGATION_INSN
 #endif /* CONFIG_MITIGATE_SPECTRE_BRANCH_HISTORY */
 END(__bp_harden_el1_vectors)
 	.popsection
diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
index 55ed2cb81dc6..01e518b82c49 100644
--- a/arch/arm64/kvm/hyp/hyp-entry.S
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -392,4 +392,10 @@ ENTRY(__spectre_bhb_loop_k32_start)
 	ldp	x0, x1, [sp, #(8 * 0)]
 	add	sp, sp, #(8 * 2)
 ENTRY(__spectre_bhb_loop_k32_end)
+
+ENTRY(__spectre_bhb_clearbhb_start)
+	esb
+	clearbhb
+	isb
+ENTRY(__spectre_bhb_clearbhb_end)
 #endif
-- 
2.30.2

