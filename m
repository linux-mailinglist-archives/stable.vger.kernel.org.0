Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AAE6E32D8
	for <lists+stable@lfdr.de>; Thu, 24 Oct 2019 14:49:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729056AbfJXMtN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Oct 2019 08:49:13 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:36780 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728684AbfJXMtN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Oct 2019 08:49:13 -0400
Received: by mail-wm1-f68.google.com with SMTP id c22so2488839wmd.1
        for <stable@vger.kernel.org>; Thu, 24 Oct 2019 05:49:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=d0ILzzBWyALcCP4vt2sLUyW3Nl11eFJXoTgnITUoFPw=;
        b=r5Z2xIZfiUe34Vk6dTI5psOphrJ5/Hh5o+7FLnZYKYFT9EFD6CjLuxoyrkkpNRrSrW
         rO/Kqad0g1Ce3KM2XrYWgezc1XLR7+WDYOL6twOXg5YULl4Uh2cvGlED2osN6aAni8nS
         4D9GWkckLTyeOqiF69Bbd6bwUrD5hrnSxK9SqVXw90Bz2TK0qE3PDD4MvpuKvpSvG4ja
         s0QY+jJF40NANCI1Bw9Ha90OoFIU4wt+0KKmAq3W35pKuzkVfR6THyYVgqWrNuJVnlOh
         V8xrM6AVzBlPx3P9BZSYO/T2FvQ9HTonRMoDuPNtYJ/gazfM/l5aLwaUOgtoMqrujLew
         wKcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=d0ILzzBWyALcCP4vt2sLUyW3Nl11eFJXoTgnITUoFPw=;
        b=maZaThsvNykzqxdlhMfyXyB4CHsDJy0tUrUVIkxrxl7Xw1ETSFv9GP2hbSKha/MWym
         jYScMKpJOjR830mA3rhvr8GSFhzQoorxZa5z4Z9rqfBADHYBZFEbOm9GaCYEIb+OwFZU
         gEzTbPv1sySpBXvuUiUbc5lzme2RBE6o+TVcphC/YOOIb1Kbgo/mcETMOGle9o+IlnGJ
         uEZn+mRkAayohxgAQ5fWn0vo1dhwHymitpwKf+CZEnImbuXGBvUWXl7+5ePg1ABqNLRY
         56ki6qOarTAtkqprMiifi/Ojccl3QMAGaVvOGvONXQud/0CXnhtHRBk3IjBqGXTi8qER
         oLPw==
X-Gm-Message-State: APjAAAX6NT7rtFd6klO6gu/0jrAUlpZX2CGIjWUs1MCz5D/wp0ORJYjT
        Yo8DpUH+qdTwxBqbghhrrBzfW2rSZzzqTBi8
X-Google-Smtp-Source: APXvYqwZAivBoWSJNQcYaQgWHAFW70rZA4A+tF73bRdeITC/PDegyDOQGimqGFUk9H84i8jZ2DjfIw==
X-Received: by 2002:a1c:b4c1:: with SMTP id d184mr4488092wmf.37.1571921349264;
        Thu, 24 Oct 2019 05:49:09 -0700 (PDT)
Received: from localhost.localdomain (aaubervilliers-681-1-126-126.w90-88.abo.wanadoo.fr. [90.88.7.126])
        by smtp.gmail.com with ESMTPSA id j22sm29111038wrd.41.2019.10.24.05.49.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 05:49:08 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     stable@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Dave Martin <dave.martin@arm.com>
Subject: [PATCH for-stable-4.14 14/48] arm64: capabilities: Add flags to handle the conflicts on late CPU
Date:   Thu, 24 Oct 2019 14:47:59 +0200
Message-Id: <20191024124833.4158-15-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191024124833.4158-1-ard.biesheuvel@linaro.org>
References: <20191024124833.4158-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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
---
 arch/arm64/include/asm/cpufeature.h | 68 ++++++++++++++++++++
 arch/arm64/kernel/cpu_errata.c      | 12 ++--
 arch/arm64/kernel/cpufeature.c      | 26 ++++----
 3 files changed, 87 insertions(+), 19 deletions(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 909e005f9612..89aeeeaf81bb 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -149,6 +149,7 @@ extern struct arm64_ftr_reg arm64_ftr_reg_ctrel0;
  *    an action, based on the severity (e.g, a CPU could be prevented from
  *    booting or cause a kernel panic). The CPU is allowed to "affect" the
  *    state of the capability, if it has not been finalised already.
+ *    See section 5 for more details on conflicts.
  *
  * 4) Action: As mentioned in (2), the kernel can take an action for each
  *    detected capability, on all CPUs on the system. Appropriate actions
@@ -166,6 +167,34 @@ extern struct arm64_ftr_reg arm64_ftr_reg_ctrel0;
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
 
 
@@ -179,6 +208,33 @@ extern struct arm64_ftr_reg arm64_ftr_reg_ctrel0;
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
@@ -212,6 +268,18 @@ static inline int cpucap_default_scope(const struct arm64_cpu_capabilities *cap)
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
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 72f701da24c9..588b994b7120 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -406,14 +406,14 @@ static bool has_ssbd_mitigation(const struct arm64_cpu_capabilities *entry,
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
@@ -517,14 +517,14 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
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
 #ifdef CONFIG_QCOM_FALKOR_ERRATUM_1003
@@ -538,7 +538,7 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 	{
 		.desc = "Qualcomm Technologies Kryo erratum 1003",
 		.capability = ARM64_WORKAROUND_QCOM_FALKOR_E1003,
-		.type = ARM64_CPUCAP_SCOPE_LOCAL_CPU,
+		.type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM,
 		.midr_model = MIDR_QCOM_KRYO,
 		.matches = is_kryo_midr,
 	},
@@ -613,7 +613,7 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 #ifdef CONFIG_ARM64_SSBD
 	{
 		.desc = "Speculative Store Bypass Disable",
-		.type = ARM64_CPUCAP_SCOPE_LOCAL_CPU,
+		.type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM,
 		.capability = ARM64_SSBD,
 		.matches = has_ssbd_mitigation,
 	},
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 5a3becce5a3e..70b504d84683 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -924,7 +924,7 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 	{
 		.desc = "GIC system register CPU interface",
 		.capability = ARM64_HAS_SYSREG_GIC_CPUIF,
-		.type = ARM64_CPUCAP_SCOPE_SYSTEM,
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
 		.matches = has_useable_gicv3_cpuif,
 		.sys_reg = SYS_ID_AA64PFR0_EL1,
 		.field_pos = ID_AA64PFR0_GIC_SHIFT,
@@ -935,7 +935,7 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 	{
 		.desc = "Privileged Access Never",
 		.capability = ARM64_HAS_PAN,
-		.type = ARM64_CPUCAP_SCOPE_SYSTEM,
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
 		.matches = has_cpuid_feature,
 		.sys_reg = SYS_ID_AA64MMFR1_EL1,
 		.field_pos = ID_AA64MMFR1_PAN_SHIFT,
@@ -948,7 +948,7 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 	{
 		.desc = "LSE atomic instructions",
 		.capability = ARM64_HAS_LSE_ATOMICS,
-		.type = ARM64_CPUCAP_SCOPE_SYSTEM,
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
 		.matches = has_cpuid_feature,
 		.sys_reg = SYS_ID_AA64ISAR0_EL1,
 		.field_pos = ID_AA64ISAR0_ATOMICS_SHIFT,
@@ -959,14 +959,14 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
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
@@ -980,21 +980,21 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
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
@@ -1004,14 +1004,14 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
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
@@ -1019,7 +1019,7 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 	{
 		/* FP/SIMD is not implemented */
 		.capability = ARM64_HAS_NO_FPSIMD,
-		.type = ARM64_CPUCAP_SCOPE_SYSTEM,
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
 		.min_field_value = 0,
 		.matches = has_no_fpsimd,
 	},
@@ -1027,7 +1027,7 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 	{
 		.desc = "Data cache clean to Point of Persistence",
 		.capability = ARM64_HAS_DCPOP,
-		.type = ARM64_CPUCAP_SCOPE_SYSTEM,
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
 		.matches = has_cpuid_feature,
 		.sys_reg = SYS_ID_AA64ISAR1_EL1,
 		.field_pos = ID_AA64ISAR1_DPB_SHIFT,
@@ -1040,7 +1040,7 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 #define HWCAP_CAP(reg, field, s, min_value, cap_type, cap)	\
 	{							\
 		.desc = #cap,					\
-		.type = ARM64_CPUCAP_SCOPE_SYSTEM,		\
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,		\
 		.matches = has_cpuid_feature,			\
 		.sys_reg = reg,					\
 		.field_pos = field,				\
-- 
2.20.1

