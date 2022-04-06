Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33AE64F69CF
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 21:27:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230214AbiDFT3A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 15:29:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231532AbiDFT1y (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 15:27:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED9A928A038;
        Wed,  6 Apr 2022 11:28:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7D20661B89;
        Wed,  6 Apr 2022 18:28:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 884A5C385A5;
        Wed,  6 Apr 2022 18:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649269703;
        bh=J+WkzQ++NrTw1a/nbEuKJg4PZHjf4EJ4YpWvoa2dvTU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y8zcNJZj0ULalQ3pe8VrCJF5dcpS7OeMXYKoU+JCXKJ8Td/DIqc8t68uXWL0NgrAq
         brx/0E054KeNXZDXUDRbax1I1mqoc2n0e3LBEzUoD2kfFsDgTkRjr1tbuaPFVb0Dim
         rT8YmRz20FkEAditF2rlJW3ZY85Q+WgJOSGjAxO4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>, stable@kernel.org
Subject: [PATCH 4.9 40/43] arm64: Mitigate spectre style branch history side channels
Date:   Wed,  6 Apr 2022 20:26:49 +0200
Message-Id: <20220406182437.843673496@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220406182436.675069715@linuxfoundation.org>
References: <20220406182436.675069715@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Morse <james.morse@arm.com>

commit 558c303c9734af5a813739cd284879227f7297d2 upstream.

Speculation attacks against some high-performance processors can
make use of branch history to influence future speculation.
When taking an exception from user-space, a sequence of branches
or a firmware call overwrites or invalidates the branch history.

The sequence of branches is added to the vectors, and should appear
before the first indirect branch. For systems using KPTI the sequence
is added to the kpti trampoline where it has a free register as the exit
from the trampoline is via a 'ret'. For systems not using KPTI, the same
register tricks are used to free up a register in the vectors.

For the firmware call, arch-workaround-3 clobbers 4 registers, so
there is no choice but to save them to the EL1 stack. This only happens
for entry from EL0, so if we take an exception due to the stack access,
it will not become re-entrant.

For KVM, the existing branch-predictor-hardening vectors are used.
When a spectre version of these vectors is in use, the firmware call
is sufficient to mitigate against Spectre-BHB. For the non-spectre
versions, the sequence of branches is added to the indirect vector.

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: <stable@kernel.org> # <v5.17.x 72bb9dcb6c33c arm64: Add Cortex-X2 CPU part definition
Cc: <stable@kernel.org> # <v5.16.x 2d0d656700d67 arm64: Add Neoverse-N2, Cortex-A710 CPU part definition
Cc: <stable@kernel.org> # <v5.10.x 8a6b88e66233f arm64: Add part number for Arm Cortex-A77
[ modified for stable, moved code to cpu_errata.c removed bitmap of
  mitigations, use kvm template infrastructure, added is_spectrev2_safe()
  helper ]
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/Kconfig                  |   10 +
 arch/arm64/include/asm/assembler.h  |    4 
 arch/arm64/include/asm/cpufeature.h |   27 +++
 arch/arm64/include/asm/cputype.h    |    8 +
 arch/arm64/include/asm/sysreg.h     |    1 
 arch/arm64/include/asm/vectors.h    |    6 
 arch/arm64/kernel/cpu_errata.c      |  284 +++++++++++++++++++++++++++++++++++-
 arch/arm64/kvm/hyp/hyp-entry.S      |    4 
 8 files changed, 341 insertions(+), 3 deletions(-)

--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -799,6 +799,16 @@ config ARM64_SSBD
 
 	  If unsure, say Y.
 
+config MITIGATE_SPECTRE_BRANCH_HISTORY
+	bool "Mitigate Spectre style attacks against branch history" if EXPERT
+	default y
+	depends on HARDEN_BRANCH_PREDICTOR || !KVM
+	help
+	  Speculation attacks against some high-performance processors can
+	  make use of branch history to influence future speculation.
+	  When taking an exception from user-space, a sequence of branches
+	  or a firmware call overwrites the branch history.
+
 menuconfig ARMV8_DEPRECATED
 	bool "Emulate deprecated/obsolete ARMv8 instructions"
 	depends on COMPAT
--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -496,7 +496,9 @@ alternative_endif
 
 	.macro __mitigate_spectre_bhb_loop      tmp
 #ifdef CONFIG_MITIGATE_SPECTRE_BRANCH_HISTORY
-	mov	\tmp, #32
+alternative_cb  spectre_bhb_patch_loop_iter
+	mov	\tmp, #32		// Patched to correct the immediate
+alternative_cb_end
 .Lspectre_bhb_loop\@:
 	b	. + 4
 	subs	\tmp, \tmp, #1
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -372,6 +372,21 @@ static inline bool cpu_supports_mixed_en
 	return id_aa64mmfr0_mixed_endian_el0(read_cpuid(ID_AA64MMFR0_EL1));
 }
 
+static inline bool supports_csv2p3(int scope)
+{
+	u64 pfr0;
+	u8 csv2_val;
+
+	if (scope == SCOPE_LOCAL_CPU)
+		pfr0 = read_sysreg_s(SYS_ID_AA64PFR0_EL1);
+	else
+		pfr0 = read_system_reg(SYS_ID_AA64PFR0_EL1);
+
+	csv2_val = cpuid_feature_extract_unsigned_field(pfr0,
+							ID_AA64PFR0_CSV2_SHIFT);
+	return csv2_val == 3;
+}
+
 static inline bool system_supports_32bit_el0(void)
 {
 	return cpus_have_const_cap(ARM64_HAS_32BIT_EL0);
@@ -404,6 +419,18 @@ void arm64_set_ssbd_mitigation(bool stat
 static inline void arm64_set_ssbd_mitigation(bool state) {}
 #endif
 
+/* Watch out, ordering is important here. */
+enum mitigation_state {
+	SPECTRE_UNAFFECTED,
+	SPECTRE_MITIGATED,
+	SPECTRE_VULNERABLE,
+};
+
+enum mitigation_state arm64_get_spectre_bhb_state(void);
+bool is_spectre_bhb_affected(const struct arm64_cpu_capabilities *entry, int scope);
+u8 spectre_bhb_loop_affected(int scope);
+void spectre_bhb_enable_mitigation(const struct arm64_cpu_capabilities *entry);
+
 #endif /* __ASSEMBLY__ */
 
 #endif
--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -88,9 +88,13 @@
 #define ARM_CPU_PART_CORTEX_A76		0xD0B
 #define ARM_CPU_PART_NEOVERSE_N1	0xD0C
 #define ARM_CPU_PART_CORTEX_A77		0xD0D
+#define ARM_CPU_PART_NEOVERSE_V1	0xD40
+#define ARM_CPU_PART_CORTEX_A78		0xD41
+#define ARM_CPU_PART_CORTEX_X1		0xD44
 #define ARM_CPU_PART_CORTEX_A710	0xD47
 #define ARM_CPU_PART_CORTEX_X2		0xD48
 #define ARM_CPU_PART_NEOVERSE_N2	0xD49
+#define ARM_CPU_PART_CORTEX_A78C	0xD4B
 
 #define APM_CPU_PART_POTENZA		0x000
 
@@ -111,9 +115,13 @@
 #define MIDR_CORTEX_A76	MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A76)
 #define MIDR_NEOVERSE_N1 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_NEOVERSE_N1)
 #define MIDR_CORTEX_A77	MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A77)
+#define MIDR_NEOVERSE_V1	MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_NEOVERSE_V1)
+#define MIDR_CORTEX_A78	MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A78)
+#define MIDR_CORTEX_X1	MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_X1)
 #define MIDR_CORTEX_A710 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A710)
 #define MIDR_CORTEX_X2 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_X2)
 #define MIDR_NEOVERSE_N2 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_NEOVERSE_N2)
+#define MIDR_CORTEX_A78C	MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A78C)
 #define MIDR_THUNDERX	MIDR_CPU_MODEL(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX)
 #define MIDR_THUNDERX_81XX MIDR_CPU_MODEL(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX_81XX)
 #define MIDR_CAVIUM_THUNDERX2 MIDR_CPU_MODEL(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX2)
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -211,6 +211,7 @@
 #define ID_AA64MMFR0_TGRAN16_SUPPORTED	0x1
 
 /* id_aa64mmfr1 */
+#define ID_AA64MMFR1_ECBHB_SHIFT	60
 #define ID_AA64MMFR1_PAN_SHIFT		20
 #define ID_AA64MMFR1_LOR_SHIFT		16
 #define ID_AA64MMFR1_HPD_SHIFT		12
--- a/arch/arm64/include/asm/vectors.h
+++ b/arch/arm64/include/asm/vectors.h
@@ -9,6 +9,7 @@
 #include <linux/percpu.h>
 
 #include <asm/fixmap.h>
+#include <asm/mmu.h>
 
 extern char vectors[];
 extern char tramp_vectors[];
@@ -40,6 +41,11 @@ enum arm64_bp_harden_el1_vectors {
 	EL1_VECTOR_KPTI,
 };
 
+#ifndef CONFIG_MITIGATE_SPECTRE_BRANCH_HISTORY
+#define EL1_VECTOR_BHB_LOOP		-1
+#define EL1_VECTOR_BHB_FW		-1
+#endif /* !CONFIG_MITIGATE_SPECTRE_BRANCH_HISTORY */
+
 /* The vectors to use on return from EL0. e.g. to remap the kernel */
 DECLARE_PER_CPU_READ_MOSTLY(const char *, this_cpu_vector);
 
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -23,6 +23,7 @@
 #include <asm/cpu.h>
 #include <asm/cputype.h>
 #include <asm/cpufeature.h>
+#include <asm/vectors.h>
 
 static bool __maybe_unused
 is_affected_midr_range(const struct arm64_cpu_capabilities *entry, int scope)
@@ -67,6 +68,7 @@ cpu_enable_trap_ctr_access(const struct
 #include <asm/mmu_context.h>
 #include <asm/cacheflush.h>
 
+static bool __hardenbp_enab;
 DEFINE_PER_CPU_READ_MOSTLY(struct bp_hardening_data, bp_hardening_data);
 
 #ifdef CONFIG_KVM
@@ -124,6 +126,7 @@ static void __install_bp_hardening_cb(bp
 	__this_cpu_write(bp_hardening_data.hyp_vectors_slot, slot);
 	__this_cpu_write(bp_hardening_data.fn, fn);
 	__this_cpu_write(bp_hardening_data.template_start, hyp_vecs_start);
+	__hardenbp_enab = true;
 	spin_unlock(&bp_lock);
 }
 #else
@@ -137,6 +140,7 @@ static void __install_bp_hardening_cb(bp
 				      const char *hyp_vecs_end)
 {
 	__this_cpu_write(bp_hardening_data.fn, fn);
+	__hardenbp_enab = true;
 }
 #endif	/* CONFIG_KVM */
 
@@ -553,9 +557,207 @@ const struct arm64_cpu_capabilities arm6
 	},
 #endif
 	{
+		.desc = "Spectre-BHB",
+		.type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM,
+		.capability = ARM64_SPECTRE_BHB,
+		.matches = is_spectre_bhb_affected,
+		.cpu_enable = spectre_bhb_enable_mitigation,
+	},
+	{
 	}
 };
 
+/*
+ * We try to ensure that the mitigation state can never change as the result of
+ * onlining a late CPU.
+ */
+static void update_mitigation_state(enum mitigation_state *oldp,
+				    enum mitigation_state new)
+{
+	enum mitigation_state state;
+
+	do {
+		state = READ_ONCE(*oldp);
+		if (new <= state)
+			break;
+	} while (cmpxchg_relaxed(oldp, state, new) != state);
+}
+
+/*
+ * Spectre BHB.
+ *
+ * A CPU is either:
+ * - Mitigated by a branchy loop a CPU specific number of times, and listed
+ *   in our "loop mitigated list".
+ * - Mitigated in software by the firmware Spectre v2 call.
+ * - Has the 'Exception Clears Branch History Buffer' (ECBHB) feature, so no
+ *   software mitigation in the vectors is needed.
+ * - Has CSV2.3, so is unaffected.
+ */
+static enum mitigation_state spectre_bhb_state;
+
+enum mitigation_state arm64_get_spectre_bhb_state(void)
+{
+	return spectre_bhb_state;
+}
+
+/*
+ * This must be called with SCOPE_LOCAL_CPU for each type of CPU, before any
+ * SCOPE_SYSTEM call will give the right answer.
+ */
+u8 spectre_bhb_loop_affected(int scope)
+{
+	u8 k = 0;
+	static u8 max_bhb_k;
+
+	if (scope == SCOPE_LOCAL_CPU) {
+		static const struct midr_range spectre_bhb_k32_list[] = {
+			MIDR_ALL_VERSIONS(MIDR_CORTEX_A78),
+			MIDR_ALL_VERSIONS(MIDR_CORTEX_A78C),
+			MIDR_ALL_VERSIONS(MIDR_CORTEX_X1),
+			MIDR_ALL_VERSIONS(MIDR_CORTEX_A710),
+			MIDR_ALL_VERSIONS(MIDR_CORTEX_X2),
+			MIDR_ALL_VERSIONS(MIDR_NEOVERSE_N2),
+			MIDR_ALL_VERSIONS(MIDR_NEOVERSE_V1),
+			{},
+		};
+		static const struct midr_range spectre_bhb_k24_list[] = {
+			MIDR_ALL_VERSIONS(MIDR_CORTEX_A77),
+			MIDR_ALL_VERSIONS(MIDR_CORTEX_A76),
+			MIDR_ALL_VERSIONS(MIDR_NEOVERSE_N1),
+			{},
+		};
+		static const struct midr_range spectre_bhb_k8_list[] = {
+			MIDR_ALL_VERSIONS(MIDR_CORTEX_A72),
+			MIDR_ALL_VERSIONS(MIDR_CORTEX_A57),
+			{},
+		};
+
+		if (is_midr_in_range_list(read_cpuid_id(), spectre_bhb_k32_list))
+			k = 32;
+		else if (is_midr_in_range_list(read_cpuid_id(), spectre_bhb_k24_list))
+			k = 24;
+		else if (is_midr_in_range_list(read_cpuid_id(), spectre_bhb_k8_list))
+			k =  8;
+
+		max_bhb_k = max(max_bhb_k, k);
+	} else {
+		k = max_bhb_k;
+	}
+
+	return k;
+}
+
+static enum mitigation_state spectre_bhb_get_cpu_fw_mitigation_state(void)
+{
+	int ret;
+	struct arm_smccc_res res;
+
+	if (psci_ops.smccc_version == SMCCC_VERSION_1_0)
+		return SPECTRE_VULNERABLE;
+
+	switch (psci_ops.conduit) {
+	case PSCI_CONDUIT_HVC:
+		arm_smccc_1_1_hvc(ARM_SMCCC_ARCH_FEATURES_FUNC_ID,
+				  ARM_SMCCC_ARCH_WORKAROUND_3, &res);
+		break;
+
+	case PSCI_CONDUIT_SMC:
+		arm_smccc_1_1_smc(ARM_SMCCC_ARCH_FEATURES_FUNC_ID,
+				  ARM_SMCCC_ARCH_WORKAROUND_3, &res);
+		break;
+
+	default:
+		return SPECTRE_VULNERABLE;
+	}
+
+	ret = res.a0;
+	switch (ret) {
+	case SMCCC_RET_SUCCESS:
+		return SPECTRE_MITIGATED;
+	case SMCCC_ARCH_WORKAROUND_RET_UNAFFECTED:
+		return SPECTRE_UNAFFECTED;
+	default:
+	case SMCCC_RET_NOT_SUPPORTED:
+		return SPECTRE_VULNERABLE;
+	}
+}
+
+static bool is_spectre_bhb_fw_affected(int scope)
+{
+	static bool system_affected;
+	enum mitigation_state fw_state;
+	bool has_smccc = (psci_ops.smccc_version >= SMCCC_VERSION_1_1);
+	static const struct midr_range spectre_bhb_firmware_mitigated_list[] = {
+		MIDR_ALL_VERSIONS(MIDR_CORTEX_A73),
+		MIDR_ALL_VERSIONS(MIDR_CORTEX_A75),
+		{},
+	};
+	bool cpu_in_list = is_midr_in_range_list(read_cpuid_id(),
+					 spectre_bhb_firmware_mitigated_list);
+
+	if (scope != SCOPE_LOCAL_CPU)
+		return system_affected;
+
+	fw_state = spectre_bhb_get_cpu_fw_mitigation_state();
+	if (cpu_in_list || (has_smccc && fw_state == SPECTRE_MITIGATED)) {
+		system_affected = true;
+		return true;
+	}
+
+	return false;
+}
+
+static bool supports_ecbhb(int scope)
+{
+	u64 mmfr1;
+
+	if (scope == SCOPE_LOCAL_CPU)
+		mmfr1 = read_sysreg_s(SYS_ID_AA64MMFR1_EL1);
+	else
+		mmfr1 = read_system_reg(SYS_ID_AA64MMFR1_EL1);
+
+	return cpuid_feature_extract_unsigned_field(mmfr1,
+						    ID_AA64MMFR1_ECBHB_SHIFT);
+}
+
+bool is_spectre_bhb_affected(const struct arm64_cpu_capabilities *entry,
+			     int scope)
+{
+	WARN_ON(scope != SCOPE_LOCAL_CPU || preemptible());
+
+	if (supports_csv2p3(scope))
+		return false;
+
+	if (spectre_bhb_loop_affected(scope))
+		return true;
+
+	if (is_spectre_bhb_fw_affected(scope))
+		return true;
+
+	return false;
+}
+
+static void this_cpu_set_vectors(enum arm64_bp_harden_el1_vectors slot)
+{
+	const char *v = arm64_get_bp_hardening_vector(slot);
+
+	if (slot < 0)
+		return;
+
+	__this_cpu_write(this_cpu_vector, v);
+
+	/*
+	 * When KPTI is in use, the vectors are switched when exiting to
+	 * user-space.
+	 */
+	if (arm64_kernel_unmapped_at_el0())
+		return;
+
+	write_sysreg(v, vbar_el1);
+	isb();
+}
+
 #ifdef CONFIG_KVM
 static const char *kvm_bhb_get_vecs_end(const char *start)
 {
@@ -571,7 +773,7 @@ static const char *kvm_bhb_get_vecs_end(
 	return NULL;
 }
 
-void kvm_setup_bhb_slot(const char *hyp_vecs_start)
+static void kvm_setup_bhb_slot(const char *hyp_vecs_start)
 {
 	int cpu, slot = -1;
 	const char *hyp_vecs_end;
@@ -609,5 +811,83 @@ void kvm_setup_bhb_slot(const char *hyp_
 #define __spectre_bhb_loop_k24_start NULL
 #define __spectre_bhb_loop_k32_start NULL
 
-void kvm_setup_bhb_slot(const char *hyp_vecs_start) { };
+static void kvm_setup_bhb_slot(const char *hyp_vecs_start) { };
 #endif
+
+static bool is_spectrev2_safe(void)
+{
+	return !is_midr_in_range_list(read_cpuid_id(),
+				      arm64_bp_harden_smccc_cpus);
+}
+
+void spectre_bhb_enable_mitigation(const struct arm64_cpu_capabilities *entry)
+{
+	enum mitigation_state fw_state, state = SPECTRE_VULNERABLE;
+
+	if (!is_spectre_bhb_affected(entry, SCOPE_LOCAL_CPU))
+		return;
+
+	if (!is_spectrev2_safe() &&  !__hardenbp_enab) {
+		/* No point mitigating Spectre-BHB alone. */
+	} else if (!IS_ENABLED(CONFIG_MITIGATE_SPECTRE_BRANCH_HISTORY)) {
+		pr_info_once("spectre-bhb mitigation disabled by compile time option\n");
+	} else if (cpu_mitigations_off()) {
+		pr_info_once("spectre-bhb mitigation disabled by command line option\n");
+	} else if (supports_ecbhb(SCOPE_LOCAL_CPU)) {
+		state = SPECTRE_MITIGATED;
+	} else if (spectre_bhb_loop_affected(SCOPE_LOCAL_CPU)) {
+		switch (spectre_bhb_loop_affected(SCOPE_SYSTEM)) {
+		case 8:
+			kvm_setup_bhb_slot(__spectre_bhb_loop_k8_start);
+			break;
+		case 24:
+			kvm_setup_bhb_slot(__spectre_bhb_loop_k24_start);
+			break;
+		case 32:
+			kvm_setup_bhb_slot(__spectre_bhb_loop_k32_start);
+			break;
+		default:
+			WARN_ON_ONCE(1);
+		}
+		this_cpu_set_vectors(EL1_VECTOR_BHB_LOOP);
+
+		state = SPECTRE_MITIGATED;
+	} else if (is_spectre_bhb_fw_affected(SCOPE_LOCAL_CPU)) {
+		fw_state = spectre_bhb_get_cpu_fw_mitigation_state();
+		if (fw_state == SPECTRE_MITIGATED) {
+			kvm_setup_bhb_slot(__smccc_workaround_3_smc_start);
+			this_cpu_set_vectors(EL1_VECTOR_BHB_FW);
+
+			/*
+			 * With WA3 in the vectors, the WA1 calls can be
+			 * removed.
+			 */
+			__this_cpu_write(bp_hardening_data.fn, NULL);
+
+			state = SPECTRE_MITIGATED;
+		}
+	}
+
+	update_mitigation_state(&spectre_bhb_state, state);
+}
+
+/* Patched to correct the immediate */
+void __init spectre_bhb_patch_loop_iter(struct alt_instr *alt,
+					__le32 *origptr, __le32 *updptr, int nr_inst)
+{
+	u8 rd;
+	u32 insn;
+	u16 loop_count = spectre_bhb_loop_affected(SCOPE_SYSTEM);
+
+	BUG_ON(nr_inst != 1); /* MOV -> MOV */
+
+	if (!IS_ENABLED(CONFIG_MITIGATE_SPECTRE_BRANCH_HISTORY))
+		return;
+
+	insn = le32_to_cpu(*origptr);
+	rd = aarch64_insn_decode_register(AARCH64_INSN_REGTYPE_RD, insn);
+	insn = aarch64_insn_gen_movewide(rd, loop_count, 0,
+					 AARCH64_INSN_VARIANT_64BIT,
+					 AARCH64_INSN_MOVEWIDE_ZERO);
+	*updptr++ = cpu_to_le32(insn);
+}
--- a/arch/arm64/kvm/hyp/hyp-entry.S
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -136,6 +136,10 @@ el1_hvc_guest:
 	/* ARM_SMCCC_ARCH_WORKAROUND_2 handling */
 	eor	w1, w1, #(ARM_SMCCC_ARCH_WORKAROUND_1 ^ \
 			  ARM_SMCCC_ARCH_WORKAROUND_2)
+	cbz	w1, wa_epilogue
+
+	eor	w1, w1, #(ARM_SMCCC_ARCH_WORKAROUND_2 ^ \
+			  ARM_SMCCC_ARCH_WORKAROUND_3)
 	cbnz	w1, el1_trap
 
 #ifdef CONFIG_ARM64_SSBD


