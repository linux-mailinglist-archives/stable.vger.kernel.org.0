Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13FFF4F69D2
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 21:27:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231174AbiDFT3B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 15:29:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiDFT1K (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 15:27:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB5D3B53F4;
        Wed,  6 Apr 2022 11:28:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 81929B8253D;
        Wed,  6 Apr 2022 18:28:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9A24C385A3;
        Wed,  6 Apr 2022 18:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649269690;
        bh=3207PX1bCCiNBnTyir6/vytaoStzuPc8YRYrS1GA3n4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FlGI1FV6ZKsXbFcLVIMX2CvUnii022xUvjAgrWceDCeJ4iXNZ/9taqHCYjk6D+3tI
         KYp/e1OUrFt9ycI1OMmMUfk464082IW3dOOi9ArXB/ss4GdUqxVdjXLjvJQgcQ+TXx
         pu2QhVxnt4I+WF2ABFaq7vAtQdnJ37b6pa6198ao=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Dave Martin <dave.martin@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        James Morse <james.morse@arm.com>
Subject: [PATCH 4.9 08/43] arm64: capabilities: Add flags to handle the conflicts on late CPU
Date:   Wed,  6 Apr 2022 20:26:17 +0200
Message-Id: <20220406182436.925544626@linuxfoundation.org>
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

From: Suzuki K Poulose <suzuki.poulose@arm.com>

[ Upstream commit 5b4747c5dce7a873e1e7fe1608835825f714267a ]

When a CPU is brought up, it is checked against the caps that are
known to be enabled on the system (via verify_local_cpu_capabilities()).
Based on the state of the capability on the CPU vs. that of System we
could have the following combinations of conflict.

	x-----------------------------x
	| Type  | System   | Late CPU |
	|-----------------------------|
	|  a    |   y      |    n     |
	|-----------------------------|
	|  b    |   n      |    y     |
	x-----------------------------x

Case (a) is not permitted for caps which are system features, which the
system expects all the CPUs to have (e.g VHE). While (a) is ignored for
all errata work arounds. However, there could be exceptions to the plain
filtering approach. e.g, KPTI is an optional feature for a late CPU as
long as the system already enables it.

Case (b) is not permitted for errata work arounds that cannot be activated
after the kernel has finished booting.And we ignore (b) for features. Here,
yet again, KPTI is an exception, where if a late CPU needs KPTI we are too
late to enable it (because we change the allocation of ASIDs etc).

Add two different flags to indicate how the conflict should be handled.

 ARM64_CPUCAP_PERMITTED_FOR_LATE_CPU - CPUs may have the capability
 ARM64_CPUCAP_OPTIONAL_FOR_LATE_CPU - CPUs may not have the cappability.

Now that we have the flags to describe the behavior of the errata and
the features, as we treat them, define types for ERRATUM and FEATURE.

Cc: Will Deacon <will.deacon@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Dave Martin <dave.martin@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/cpufeature.h |   68 ++++++++++++++++++++++++++++++++++++
 arch/arm64/kernel/cpu_errata.c      |   10 ++---
 arch/arm64/kernel/cpufeature.c      |   22 +++++------
 3 files changed, 84 insertions(+), 16 deletions(-)

--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -130,6 +130,7 @@ extern struct arm64_ftr_reg arm64_ftr_re
  *    an action, based on the severity (e.g, a CPU could be prevented from
  *    booting or cause a kernel panic). The CPU is allowed to "affect" the
  *    state of the capability, if it has not been finalised already.
+ *    See section 5 for more details on conflicts.
  *
  * 4) Action: As mentioned in (2), the kernel can take an action for each
  *    detected capability, on all CPUs on the system. Appropriate actions
@@ -147,6 +148,34 @@ extern struct arm64_ftr_reg arm64_ftr_re
  *
  *	  check_local_cpu_capabilities() -> verify_local_cpu_capabilities()
  *
+ * 5) Conflicts: Based on the state of the capability on a late CPU vs.
+ *    the system state, we could have the following combinations :
+ *
+ *		x-----------------------------x
+ *		| Type  | System   | Late CPU |
+ *		|-----------------------------|
+ *		|  a    |   y      |    n     |
+ *		|-----------------------------|
+ *		|  b    |   n      |    y     |
+ *		x-----------------------------x
+ *
+ *     Two separate flag bits are defined to indicate whether each kind of
+ *     conflict can be allowed:
+ *		ARM64_CPUCAP_OPTIONAL_FOR_LATE_CPU - Case(a) is allowed
+ *		ARM64_CPUCAP_PERMITTED_FOR_LATE_CPU - Case(b) is allowed
+ *
+ *     Case (a) is not permitted for a capability that the system requires
+ *     all CPUs to have in order for the capability to be enabled. This is
+ *     typical for capabilities that represent enhanced functionality.
+ *
+ *     Case (b) is not permitted for a capability that must be enabled
+ *     during boot if any CPU in the system requires it in order to run
+ *     safely. This is typical for erratum work arounds that cannot be
+ *     enabled after the corresponding capability is finalised.
+ *
+ *     In some non-typical cases either both (a) and (b), or neither,
+ *     should be permitted. This can be described by including neither
+ *     or both flags in the capability's type field.
  */
 
 
@@ -160,6 +189,33 @@ extern struct arm64_ftr_reg arm64_ftr_re
 #define SCOPE_SYSTEM				ARM64_CPUCAP_SCOPE_SYSTEM
 #define SCOPE_LOCAL_CPU				ARM64_CPUCAP_SCOPE_LOCAL_CPU
 
+/*
+ * Is it permitted for a late CPU to have this capability when system
+ * hasn't already enabled it ?
+ */
+#define ARM64_CPUCAP_PERMITTED_FOR_LATE_CPU	((u16)BIT(4))
+/* Is it safe for a late CPU to miss this capability when system has it */
+#define ARM64_CPUCAP_OPTIONAL_FOR_LATE_CPU	((u16)BIT(5))
+
+/*
+ * CPU errata workarounds that need to be enabled at boot time if one or
+ * more CPUs in the system requires it. When one of these capabilities
+ * has been enabled, it is safe to allow any CPU to boot that doesn't
+ * require the workaround. However, it is not safe if a "late" CPU
+ * requires a workaround and the system hasn't enabled it already.
+ */
+#define ARM64_CPUCAP_LOCAL_CPU_ERRATUM		\
+	(ARM64_CPUCAP_SCOPE_LOCAL_CPU | ARM64_CPUCAP_OPTIONAL_FOR_LATE_CPU)
+/*
+ * CPU feature detected at boot time based on system-wide value of a
+ * feature. It is safe for a late CPU to have this feature even though
+ * the system hasn't enabled it, although the featuer will not be used
+ * by Linux in this case. If the system has enabled this feature already,
+ * then every late CPU must have it.
+ */
+#define ARM64_CPUCAP_SYSTEM_FEATURE	\
+	(ARM64_CPUCAP_SCOPE_SYSTEM | ARM64_CPUCAP_PERMITTED_FOR_LATE_CPU)
+
 struct arm64_cpu_capabilities {
 	const char *desc;
 	u16 capability;
@@ -193,6 +249,18 @@ static inline int cpucap_default_scope(c
 	return cap->type & ARM64_CPUCAP_SCOPE_MASK;
 }
 
+static inline bool
+cpucap_late_cpu_optional(const struct arm64_cpu_capabilities *cap)
+{
+	return !!(cap->type & ARM64_CPUCAP_OPTIONAL_FOR_LATE_CPU);
+}
+
+static inline bool
+cpucap_late_cpu_permitted(const struct arm64_cpu_capabilities *cap)
+{
+	return !!(cap->type & ARM64_CPUCAP_PERMITTED_FOR_LATE_CPU);
+}
+
 extern DECLARE_BITMAP(cpu_hwcaps, ARM64_NCAPS);
 extern struct static_key_false cpu_hwcap_keys[ARM64_NCAPS];
 extern struct static_key_false arm64_const_caps_ready;
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -369,14 +369,14 @@ static bool has_ssbd_mitigation(const st
 #endif	/* CONFIG_ARM64_SSBD */
 
 #define MIDR_RANGE(model, min, max) \
-	.type = ARM64_CPUCAP_SCOPE_LOCAL_CPU, \
+	.type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM, \
 	.matches = is_affected_midr_range, \
 	.midr_model = model, \
 	.midr_range_min = min, \
 	.midr_range_max = max
 
 #define MIDR_ALL_VERSIONS(model) \
-	.type = ARM64_CPUCAP_SCOPE_LOCAL_CPU, \
+	.type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM, \
 	.matches = is_affected_midr_range, \
 	.midr_model = model, \
 	.midr_range_min = 0, \
@@ -459,14 +459,14 @@ const struct arm64_cpu_capabilities arm6
 		.desc = "Mismatched cache line size",
 		.capability = ARM64_MISMATCHED_CACHE_LINE_SIZE,
 		.matches = has_mismatched_cache_type,
-		.type = ARM64_CPUCAP_SCOPE_LOCAL_CPU,
+		.type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM,
 		.cpu_enable = cpu_enable_trap_ctr_access,
 	},
 	{
 		.desc = "Mismatched cache type",
 		.capability = ARM64_MISMATCHED_CACHE_TYPE,
 		.matches = has_mismatched_cache_type,
-		.type = ARM64_CPUCAP_SCOPE_LOCAL_CPU,
+		.type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM,
 		.cpu_enable = cpu_enable_trap_ctr_access,
 	},
 #ifdef CONFIG_HARDEN_BRANCH_PREDICTOR
@@ -504,7 +504,7 @@ const struct arm64_cpu_capabilities arm6
 #ifdef CONFIG_ARM64_SSBD
 	{
 		.desc = "Speculative Store Bypass Disable",
-		.type = ARM64_CPUCAP_SCOPE_LOCAL_CPU,
+		.type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM,
 		.capability = ARM64_SSBD,
 		.matches = has_ssbd_mitigation,
 	},
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -865,7 +865,7 @@ static const struct arm64_cpu_capabiliti
 	{
 		.desc = "GIC system register CPU interface",
 		.capability = ARM64_HAS_SYSREG_GIC_CPUIF,
-		.type = ARM64_CPUCAP_SCOPE_SYSTEM,
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
 		.matches = has_useable_gicv3_cpuif,
 		.sys_reg = SYS_ID_AA64PFR0_EL1,
 		.field_pos = ID_AA64PFR0_GIC_SHIFT,
@@ -876,7 +876,7 @@ static const struct arm64_cpu_capabiliti
 	{
 		.desc = "Privileged Access Never",
 		.capability = ARM64_HAS_PAN,
-		.type = ARM64_CPUCAP_SCOPE_SYSTEM,
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
 		.matches = has_cpuid_feature,
 		.sys_reg = SYS_ID_AA64MMFR1_EL1,
 		.field_pos = ID_AA64MMFR1_PAN_SHIFT,
@@ -889,7 +889,7 @@ static const struct arm64_cpu_capabiliti
 	{
 		.desc = "LSE atomic instructions",
 		.capability = ARM64_HAS_LSE_ATOMICS,
-		.type = ARM64_CPUCAP_SCOPE_SYSTEM,
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
 		.matches = has_cpuid_feature,
 		.sys_reg = SYS_ID_AA64ISAR0_EL1,
 		.field_pos = ID_AA64ISAR0_ATOMICS_SHIFT,
@@ -900,14 +900,14 @@ static const struct arm64_cpu_capabiliti
 	{
 		.desc = "Software prefetching using PRFM",
 		.capability = ARM64_HAS_NO_HW_PREFETCH,
-		.type = ARM64_CPUCAP_SCOPE_SYSTEM,
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
 		.matches = has_no_hw_prefetch,
 	},
 #ifdef CONFIG_ARM64_UAO
 	{
 		.desc = "User Access Override",
 		.capability = ARM64_HAS_UAO,
-		.type = ARM64_CPUCAP_SCOPE_SYSTEM,
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
 		.matches = has_cpuid_feature,
 		.sys_reg = SYS_ID_AA64MMFR2_EL1,
 		.field_pos = ID_AA64MMFR2_UAO_SHIFT,
@@ -921,21 +921,21 @@ static const struct arm64_cpu_capabiliti
 #ifdef CONFIG_ARM64_PAN
 	{
 		.capability = ARM64_ALT_PAN_NOT_UAO,
-		.type = ARM64_CPUCAP_SCOPE_SYSTEM,
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
 		.matches = cpufeature_pan_not_uao,
 	},
 #endif /* CONFIG_ARM64_PAN */
 	{
 		.desc = "Virtualization Host Extensions",
 		.capability = ARM64_HAS_VIRT_HOST_EXTN,
-		.type = ARM64_CPUCAP_SCOPE_SYSTEM,
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
 		.matches = runs_at_el2,
 		.cpu_enable = cpu_copy_el2regs,
 	},
 	{
 		.desc = "32-bit EL0 Support",
 		.capability = ARM64_HAS_32BIT_EL0,
-		.type = ARM64_CPUCAP_SCOPE_SYSTEM,
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
 		.matches = has_cpuid_feature,
 		.sys_reg = SYS_ID_AA64PFR0_EL1,
 		.sign = FTR_UNSIGNED,
@@ -945,14 +945,14 @@ static const struct arm64_cpu_capabiliti
 	{
 		.desc = "Reduced HYP mapping offset",
 		.capability = ARM64_HYP_OFFSET_LOW,
-		.type = ARM64_CPUCAP_SCOPE_SYSTEM,
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
 		.matches = hyp_offset_low,
 	},
 #ifdef CONFIG_UNMAP_KERNEL_AT_EL0
 	{
 		.desc = "Kernel page table isolation (KPTI)",
 		.capability = ARM64_UNMAP_KERNEL_AT_EL0,
-		.type = ARM64_CPUCAP_SCOPE_SYSTEM,
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
 		.matches = unmap_kernel_at_el0,
 		.cpu_enable = kpti_install_ng_mappings,
 	},
@@ -963,7 +963,7 @@ static const struct arm64_cpu_capabiliti
 #define HWCAP_CAP(reg, field, s, min_value, cap_type, cap)	\
 	{							\
 		.desc = #cap,					\
-		.type = ARM64_CPUCAP_SCOPE_SYSTEM,		\
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,		\
 		.matches = has_cpuid_feature,			\
 		.sys_reg = reg,					\
 		.field_pos = field,				\


