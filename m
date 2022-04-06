Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3CD44F691B
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 20:19:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240042AbiDFSIP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 14:08:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240405AbiDFSHw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 14:07:52 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6C6EC1877D0;
        Wed,  6 Apr 2022 09:46:12 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4E5BB12FC;
        Wed,  6 Apr 2022 09:46:12 -0700 (PDT)
Received: from eglon.cambridge.arm.com (eglon.cambridge.arm.com [10.1.196.218])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9AF5F3F73B;
        Wed,  6 Apr 2022 09:46:11 -0700 (PDT)
From:   James Morse <james.morse@arm.com>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [stable:PATCH v4.9.309 11/43] arm64: capabilities: Add support for checks based on a list of MIDRs
Date:   Wed,  6 Apr 2022 17:45:14 +0100
Message-Id: <20220406164546.1888528-11-james.morse@arm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220406164546.1888528-1-james.morse@arm.com>
References: <0220406164217.1888053-1-james.morse@arm.com>
 <20220406164546.1888528-1-james.morse@arm.com>
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

From: Suzuki K Poulose <suzuki.poulose@arm.com>

[ Upstream commit be5b299830c63ed76e0357473c4218c85fb388b3 ]

Add helpers for detecting an errata on list of midr ranges
of affected CPUs, with the same work around.

Cc: Will Deacon <will.deacon@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Reviewed-by: Dave Martin <dave.martin@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
[ardb: add Cortex-A35 to kpti_safe_list[] as well]
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: James Morse <james.morse@arm.com>
---
 arch/arm64/include/asm/cpufeature.h |  1 +
 arch/arm64/include/asm/cputype.h    |  9 +++++
 arch/arm64/kernel/cpu_errata.c      | 62 +++++++++++++++++------------
 arch/arm64/kernel/cpufeature.c      | 21 +++++-----
 4 files changed, 58 insertions(+), 35 deletions(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index f8646d7fae49..45206dd20ffd 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -233,6 +233,7 @@ struct arm64_cpu_capabilities {
 			struct midr_range midr_range;
 		};
 
+		const struct midr_range *midr_range_list;
 		struct {	/* Feature register checking */
 			u32 sys_reg;
 			u8 field_pos;
diff --git a/arch/arm64/include/asm/cputype.h b/arch/arm64/include/asm/cputype.h
index e76245ea6b60..61041e051acb 100644
--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -143,6 +143,15 @@ static inline bool is_midr_in_range(u32 midr, struct midr_range const *range)
 				 range->rv_min, range->rv_max);
 }
 
+static inline bool
+is_midr_in_range_list(u32 midr, struct midr_range const *ranges)
+{
+	while (ranges->model)
+		if (is_midr_in_range(midr, ranges++))
+			return true;
+	return false;
+}
+
 /*
  * The CPU ID never changes at run time, so we might as well tell the
  * compiler that it's constant.  Use this function to read the CPU ID
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index e2630e88e8ad..69c3492cb063 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -33,6 +33,14 @@ is_affected_midr_range(const struct arm64_cpu_capabilities *entry, int scope)
 	return is_midr_in_range(midr, &entry->midr_range);
 }
 
+static bool __maybe_unused
+is_affected_midr_range_list(const struct arm64_cpu_capabilities *entry,
+			    int scope)
+{
+	WARN_ON(scope != SCOPE_LOCAL_CPU || preemptible());
+	return is_midr_in_range_list(read_cpuid_id(), entry->midr_range_list);
+}
+
 static bool
 has_mismatched_cache_type(const struct arm64_cpu_capabilities *entry,
 			  int scope)
@@ -383,6 +391,10 @@ static bool has_ssbd_mitigation(const struct arm64_cpu_capabilities *entry,
 	.type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM,				\
 	CAP_MIDR_RANGE(model, v_min, r_min, v_max, r_max)
 
+#define CAP_MIDR_RANGE_LIST(list)				\
+	.matches = is_affected_midr_range_list,			\
+	.midr_range_list = list
+
 /* Errata affecting a range of revisions of  given model variant */
 #define ERRATA_MIDR_REV_RANGE(m, var, r_min, r_max)	 \
 	ERRATA_MIDR_RANGE(m, var, r_min, var, r_max)
@@ -396,6 +408,29 @@ static bool has_ssbd_mitigation(const struct arm64_cpu_capabilities *entry,
 	.type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM,			\
 	CAP_MIDR_ALL_VERSIONS(model)
 
+/* Errata affecting a list of midr ranges, with same work around */
+#define ERRATA_MIDR_RANGE_LIST(midr_list)			\
+	.type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM,			\
+	CAP_MIDR_RANGE_LIST(midr_list)
+
+#ifdef CONFIG_HARDEN_BRANCH_PREDICTOR
+
+/*
+ * List of CPUs where we need to issue a psci call to
+ * harden the branch predictor.
+ */
+static const struct midr_range arm64_bp_harden_smccc_cpus[] = {
+	MIDR_ALL_VERSIONS(MIDR_CORTEX_A57),
+	MIDR_ALL_VERSIONS(MIDR_CORTEX_A72),
+	MIDR_ALL_VERSIONS(MIDR_CORTEX_A73),
+	MIDR_ALL_VERSIONS(MIDR_CORTEX_A75),
+	MIDR_ALL_VERSIONS(MIDR_BRCM_VULCAN),
+	MIDR_ALL_VERSIONS(MIDR_CAVIUM_THUNDERX2),
+	{},
+};
+
+#endif
+
 const struct arm64_cpu_capabilities arm64_errata[] = {
 #if	defined(CONFIG_ARM64_ERRATUM_826319) || \
 	defined(CONFIG_ARM64_ERRATUM_827319) || \
@@ -486,32 +521,7 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 #ifdef CONFIG_HARDEN_BRANCH_PREDICTOR
 	{
 		.capability = ARM64_HARDEN_BRANCH_PREDICTOR,
-		ERRATA_MIDR_ALL_VERSIONS(MIDR_CORTEX_A57),
-		.cpu_enable = enable_smccc_arch_workaround_1,
-	},
-	{
-		.capability = ARM64_HARDEN_BRANCH_PREDICTOR,
-		ERRATA_MIDR_ALL_VERSIONS(MIDR_CORTEX_A72),
-		.cpu_enable = enable_smccc_arch_workaround_1,
-	},
-	{
-		.capability = ARM64_HARDEN_BRANCH_PREDICTOR,
-		ERRATA_MIDR_ALL_VERSIONS(MIDR_CORTEX_A73),
-		.cpu_enable = enable_smccc_arch_workaround_1,
-	},
-	{
-		.capability = ARM64_HARDEN_BRANCH_PREDICTOR,
-		ERRATA_MIDR_ALL_VERSIONS(MIDR_CORTEX_A75),
-		.cpu_enable = enable_smccc_arch_workaround_1,
-	},
-	{
-		.capability = ARM64_HARDEN_BRANCH_PREDICTOR,
-		ERRATA_MIDR_ALL_VERSIONS(MIDR_BRCM_VULCAN),
-		.cpu_enable = enable_smccc_arch_workaround_1,
-	},
-	{
-		.capability = ARM64_HARDEN_BRANCH_PREDICTOR,
-		ERRATA_MIDR_ALL_VERSIONS(MIDR_CAVIUM_THUNDERX2),
+		ERRATA_MIDR_RANGE_LIST(arm64_bp_harden_smccc_cpus),
 		.cpu_enable = enable_smccc_arch_workaround_1,
 	},
 #endif
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 51567cd83099..1b5afb80247d 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -767,6 +767,17 @@ static int __kpti_forced; /* 0: not forced, >0: forced on, <0: forced off */
 static bool unmap_kernel_at_el0(const struct arm64_cpu_capabilities *entry,
 				int __unused)
 {
+	/* List of CPUs that are not vulnerable and don't need KPTI */
+	static const struct midr_range kpti_safe_list[] = {
+		MIDR_ALL_VERSIONS(MIDR_CAVIUM_THUNDERX2),
+		MIDR_ALL_VERSIONS(MIDR_BRCM_VULCAN),
+		MIDR_ALL_VERSIONS(MIDR_CORTEX_A35),
+		MIDR_ALL_VERSIONS(MIDR_CORTEX_A53),
+		MIDR_ALL_VERSIONS(MIDR_CORTEX_A55),
+		MIDR_ALL_VERSIONS(MIDR_CORTEX_A57),
+		MIDR_ALL_VERSIONS(MIDR_CORTEX_A72),
+		MIDR_ALL_VERSIONS(MIDR_CORTEX_A73),
+	};
 	char const *str = "command line option";
 	u64 pfr0 = read_system_reg(SYS_ID_AA64PFR0_EL1);
 
@@ -792,16 +803,8 @@ static bool unmap_kernel_at_el0(const struct arm64_cpu_capabilities *entry,
 		return true;
 
 	/* Don't force KPTI for CPUs that are not vulnerable */
-	switch (read_cpuid_id() & MIDR_CPU_MODEL_MASK) {
-	case MIDR_CAVIUM_THUNDERX2:
-	case MIDR_BRCM_VULCAN:
-	case MIDR_CORTEX_A53:
-	case MIDR_CORTEX_A55:
-	case MIDR_CORTEX_A57:
-	case MIDR_CORTEX_A72:
-	case MIDR_CORTEX_A73:
+	if (is_midr_in_range_list(read_cpuid_id(), kpti_safe_list))
 		return false;
-	}
 
 	/* Defer to CPU feature registers */
 	return !cpuid_feature_extract_unsigned_field(pfr0,
-- 
2.30.2

