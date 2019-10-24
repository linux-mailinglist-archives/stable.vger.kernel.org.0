Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5C30E32E7
	for <lists+stable@lfdr.de>; Thu, 24 Oct 2019 14:49:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502115AbfJXMth (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Oct 2019 08:49:37 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:33180 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502109AbfJXMth (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Oct 2019 08:49:37 -0400
Received: by mail-wr1-f67.google.com with SMTP id s1so17175483wro.0
        for <stable@vger.kernel.org>; Thu, 24 Oct 2019 05:49:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1aSOGN2Zpj+ScymCmFOtkHeBX0vBdLGKuaJaJtB2eOU=;
        b=gKW0tCZaTgamdByU46v8+65BXOF4auBO+1Nr/EJIRIafCP7U8cxD3Ii2uj1sm1VryK
         YSYWJTm6B5q5xjgqlOTCPhdaKTf2z3OfFvRKmH7bpnvfxnt8ZxDseM8C+zE7LsefQbeR
         LI6zP9pY27dkW1coxUUg8v0Ur1wMAgJlqHDgqx4zZJ2zC98ZF4bt0saPKZ1lnLGtbnuO
         SdvN/Jw9RCcY3/jPtdeDqIdpgOaD7rwsmTdUl98DPab3HOJPvBDAES6TSk6joEt82bgr
         iVPBvucV/UhfFpdS3DV5NDk7gw8fBFiSKZViTn9766+0lDEYJHSJD0WGK/4BmpQJaAXQ
         zTMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1aSOGN2Zpj+ScymCmFOtkHeBX0vBdLGKuaJaJtB2eOU=;
        b=XaBx07GzferAf1vI1ObXxTwLqDIf8KH6jk81QR1y4CetrWIGAIwY4lxvg7yheULOLG
         7bU6E9N6BE5Nnz6ILO//ARa8bptqMLPwVMhLJPPTafJyzM1mpUmkB7EYmYw0PvkwvyZO
         0VWkzi4LMewrSrLK0M1QjygW6Q5IoJrn7htdlSVNCOkow1XfknOFwe2oErc3cZ3hUYwD
         AElK15gmF/bwA+KW1/SbWtjA7oEpAtQGoE6kdSpfU4vNrCv9RHGYCKSXUhT2udOkxZWH
         KlPI/nLxsz5Yo/L96HfGJ2CXgjMsBol85U8WYt7YI2cJqWbjo/OkZPDTvq2kTEcbAc+V
         SLLw==
X-Gm-Message-State: APjAAAXKwwUp4HvMMAwGK6wp1hq+YMLgyRLzv300Ud7c8jqMCAYI34rW
        bkHVVJz0UAto/XreZ9tm0KAa5xcMgMmeOpTf
X-Google-Smtp-Source: APXvYqyBHRs+rLt5ulLMu2hprhsq1MqdUZE2NveQngwWLQZn/3bhNqSFWWJTX0ICH5fH0B0BI/YfPA==
X-Received: by 2002:adf:828c:: with SMTP id 12mr3711088wrc.40.1571921373847;
        Thu, 24 Oct 2019 05:49:33 -0700 (PDT)
Received: from localhost.localdomain (aaubervilliers-681-1-126-126.w90-88.abo.wanadoo.fr. [90.88.7.126])
        by smtp.gmail.com with ESMTPSA id j22sm29111038wrd.41.2019.10.24.05.49.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 05:49:33 -0700 (PDT)
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
Subject: [PATCH for-stable-4.14 28/48] arm64: capabilities: Add support for checks based on a list of MIDRs
Date:   Thu, 24 Oct 2019 14:48:13 +0200
Message-Id: <20191024124833.4158-29-ard.biesheuvel@linaro.org>
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
---
 arch/arm64/include/asm/cpufeature.h |  1 +
 arch/arm64/include/asm/cputype.h    |  9 +++
 arch/arm64/kernel/cpu_errata.c      | 81 +++++++++++---------
 arch/arm64/kernel/cpufeature.c      | 21 ++---
 4 files changed, 66 insertions(+), 46 deletions(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index ade058ada2b0..9776c19d03d4 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -306,6 +306,7 @@ struct arm64_cpu_capabilities {
 			struct midr_range midr_range;
 		};
 
+		const struct midr_range *midr_range_list;
 		struct {	/* Feature register checking */
 			u32 sys_reg;
 			u8 field_pos;
diff --git a/arch/arm64/include/asm/cputype.h b/arch/arm64/include/asm/cputype.h
index ef03243beaae..b23456035eac 100644
--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -159,6 +159,15 @@ static inline bool is_midr_in_range(u32 midr, struct midr_range const *range)
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
index a3675d279b90..096a679510ad 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -32,6 +32,14 @@ is_affected_midr_range(const struct arm64_cpu_capabilities *entry, int scope)
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
 static bool __maybe_unused
 is_kryo_midr(const struct arm64_cpu_capabilities *entry, int scope)
 {
@@ -420,6 +428,10 @@ static bool has_ssbd_mitigation(const struct arm64_cpu_capabilities *entry,
 	.type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM,				\
 	CAP_MIDR_RANGE(model, v_min, r_min, v_max, r_max)
 
+#define CAP_MIDR_RANGE_LIST(list)				\
+	.matches = is_affected_midr_range_list,			\
+	.midr_range_list = list
+
 /* Errata affecting a range of revisions of  given model variant */
 #define ERRATA_MIDR_REV_RANGE(m, var, r_min, r_max)	 \
 	ERRATA_MIDR_RANGE(m, var, r_min, var, r_max)
@@ -433,6 +445,35 @@ static bool has_ssbd_mitigation(const struct arm64_cpu_capabilities *entry,
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
+static const struct midr_range qcom_bp_harden_cpus[] = {
+	MIDR_ALL_VERSIONS(MIDR_QCOM_FALKOR_V1),
+	MIDR_ALL_VERSIONS(MIDR_QCOM_FALKOR),
+	{},
+};
+
+#endif
+
 const struct arm64_cpu_capabilities arm64_errata[] = {
 #if	defined(CONFIG_ARM64_ERRATUM_826319) || \
 	defined(CONFIG_ARM64_ERRATUM_827319) || \
@@ -574,51 +615,17 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
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
+		ERRATA_MIDR_RANGE_LIST(arm64_bp_harden_smccc_cpus),
 		.cpu_enable = enable_smccc_arch_workaround_1,
 	},
 	{
 		.capability = ARM64_HARDEN_BRANCH_PREDICTOR,
-		ERRATA_MIDR_ALL_VERSIONS(MIDR_QCOM_FALKOR_V1),
+		ERRATA_MIDR_RANGE_LIST(qcom_bp_harden_cpus),
 		.cpu_enable = qcom_enable_link_stack_sanitization,
 	},
 	{
 		.capability = ARM64_HARDEN_BP_POST_GUEST_EXIT,
-		ERRATA_MIDR_ALL_VERSIONS(MIDR_QCOM_FALKOR_V1),
-	},
-	{
-		.capability = ARM64_HARDEN_BRANCH_PREDICTOR,
-		ERRATA_MIDR_ALL_VERSIONS(MIDR_QCOM_FALKOR),
-		.cpu_enable = qcom_enable_link_stack_sanitization,
-	},
-	{
-		.capability = ARM64_HARDEN_BP_POST_GUEST_EXIT,
-		ERRATA_MIDR_ALL_VERSIONS(MIDR_QCOM_FALKOR),
-	},
-	{
-		.capability = ARM64_HARDEN_BRANCH_PREDICTOR,
-		ERRATA_MIDR_ALL_VERSIONS(MIDR_BRCM_VULCAN),
-		.cpu_enable = enable_smccc_arch_workaround_1,
-	},
-	{
-		.capability = ARM64_HARDEN_BRANCH_PREDICTOR,
-		ERRATA_MIDR_ALL_VERSIONS(MIDR_CAVIUM_THUNDERX2),
-		.cpu_enable = enable_smccc_arch_workaround_1,
+		ERRATA_MIDR_RANGE_LIST(qcom_bp_harden_cpus),
 	},
 #endif
 #ifdef CONFIG_ARM64_SSBD
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index d1897d8f40a2..ebc9fd869577 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -826,6 +826,17 @@ static int __kpti_forced; /* 0: not forced, >0: forced on, <0: forced off */
 static bool unmap_kernel_at_el0(const struct arm64_cpu_capabilities *entry,
 				int scope)
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
 
 	/*
@@ -850,16 +861,8 @@ static bool unmap_kernel_at_el0(const struct arm64_cpu_capabilities *entry,
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
 	return !has_cpuid_feature(entry, scope);
-- 
2.20.1

