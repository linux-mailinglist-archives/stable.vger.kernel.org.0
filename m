Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF580CFDDC
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 17:40:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728139AbfJHPk1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 11:40:27 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45764 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726291AbfJHPk0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Oct 2019 11:40:26 -0400
Received: by mail-wr1-f67.google.com with SMTP id r5so19898152wrm.12
        for <stable@vger.kernel.org>; Tue, 08 Oct 2019 08:40:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XTafCg6zUIIurbOW7vaJn/pn9iFWviVt4VHpbP6m92o=;
        b=HBOSUmC+Uh1sKlxj2qHRBPEkwt9Li+urF+V2wAYgjbeF71B15tqDl1t7XFVLRRDjDq
         7WHPHvli8WaQpgfD0J8abnPpv1jdI04FA7UCB+iLaMQhqlwPyGOFxjdZTK8Ipvi33KOW
         civEL4anHTjkF6ndDAcWVChWHs7LulH6vQnGGRTsQRuXy6JBPDoMqhwqxjloUPtwNczi
         dFXiOGzd32FMFU3/y22nqsUW1UEV04tz11L9/j++c/JIwWc+MU0B0HG5YLTNM0GCENKk
         Y0GTSKR4Rl0xA0m3xFyMI9ueQ/t0/RhhhkcBnGMvu2SBps/sauPaPJBJVa56woz7SoiS
         vEdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XTafCg6zUIIurbOW7vaJn/pn9iFWviVt4VHpbP6m92o=;
        b=jp6yJPnWzn0xBuQeBfvSlJcfSbZUw3ndYKZye2SVfMMBdkOpfiQHnvpm51PHKl0Q+F
         MgKV2+ZM7L1fezIDkKB1fIakF0OA8bWJVr3UJnYe66AvU2WYi1VqKbNWkXZJwTY8cWJS
         LMdSDXxWM8Qf6Tfvy9M6Rrv72zX3MKggbYAAQ1SzwQ6VPIZF6evHI0RR6K9UzmXdCa0A
         PEsunRUxgqDVQSxhqDExo4pGN8+ho6d/3y0bvrW6ehTkzmZkzyCmaVzu71KBDA0LMRaB
         pMWjkEh6krepwomX085AD1eXQcUaV0nHkLQ/oGUmB7AooOtv7Krmsy4AuXob0z3/Gfsc
         2epA==
X-Gm-Message-State: APjAAAUgKHLZKTri10hdtSChPEQRfk1LGpzsGuxxu9ziHPwPJbdoEHyj
        3iADI5vgD9oDm7lLhbvKA/v4PQ==
X-Google-Smtp-Source: APXvYqz/yoeDCA+D3L/Ajrlf7YmVBXbvN/LoMcPDs1ue/NIjtpvV4PCuv9j7lTCsF5378HVv6IWIkQ==
X-Received: by 2002:adf:fcc9:: with SMTP id f9mr29766929wrs.382.1570549223635;
        Tue, 08 Oct 2019 08:40:23 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id x16sm16784723wrl.32.2019.10.08.08.40.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Oct 2019 08:40:22 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-arm-kernel@lists.infradead.org
Cc:     stable@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Will Deacon <will.deacon@arm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH for-stable-v4.19 11/16] arm64: Advertise mitigation of Spectre-v2, or lack thereof
Date:   Tue,  8 Oct 2019 17:39:25 +0200
Message-Id: <20191008153930.15386-12-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191008153930.15386-1-ard.biesheuvel@linaro.org>
References: <20191008153930.15386-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <marc.zyngier@arm.com>

[ Upstream commit 73f38166095947f3b86b02fbed6bd592223a7ac8 ]

We currently have a list of CPUs affected by Spectre-v2, for which
we check that the firmware implements ARCH_WORKAROUND_1. It turns
out that not all firmwares do implement the required mitigation,
and that we fail to let the user know about it.

Instead, let's slightly revamp our checks, and rely on a whitelist
of cores that are known to be non-vulnerable, and let the user know
the status of the mitigation in the kernel log.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Tested-by: Stefan Wahren <stefan.wahren@i2se.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/kernel/cpu_errata.c | 109 ++++++++++----------
 1 file changed, 56 insertions(+), 53 deletions(-)

diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 2394a105ebf4..ffb1b8ff7d82 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -109,9 +109,9 @@ static void __copy_hyp_vect_bpi(int slot, const char *hyp_vecs_start,
 	__flush_icache_range((uintptr_t)dst, (uintptr_t)dst + SZ_2K);
 }
 
-static void __install_bp_hardening_cb(bp_hardening_cb_t fn,
-				      const char *hyp_vecs_start,
-				      const char *hyp_vecs_end)
+static void install_bp_hardening_cb(bp_hardening_cb_t fn,
+				    const char *hyp_vecs_start,
+				    const char *hyp_vecs_end)
 {
 	static DEFINE_SPINLOCK(bp_lock);
 	int cpu, slot = -1;
@@ -138,7 +138,7 @@ static void __install_bp_hardening_cb(bp_hardening_cb_t fn,
 #define __smccc_workaround_1_smc_start		NULL
 #define __smccc_workaround_1_smc_end		NULL
 
-static void __install_bp_hardening_cb(bp_hardening_cb_t fn,
+static void install_bp_hardening_cb(bp_hardening_cb_t fn,
 				      const char *hyp_vecs_start,
 				      const char *hyp_vecs_end)
 {
@@ -146,23 +146,6 @@ static void __install_bp_hardening_cb(bp_hardening_cb_t fn,
 }
 #endif	/* CONFIG_KVM_INDIRECT_VECTORS */
 
-static void  install_bp_hardening_cb(const struct arm64_cpu_capabilities *entry,
-				     bp_hardening_cb_t fn,
-				     const char *hyp_vecs_start,
-				     const char *hyp_vecs_end)
-{
-	u64 pfr0;
-
-	if (!entry->matches(entry, SCOPE_LOCAL_CPU))
-		return;
-
-	pfr0 = read_cpuid(ID_AA64PFR0_EL1);
-	if (cpuid_feature_extract_unsigned_field(pfr0, ID_AA64PFR0_CSV2_SHIFT))
-		return;
-
-	__install_bp_hardening_cb(fn, hyp_vecs_start, hyp_vecs_end);
-}
-
 #include <uapi/linux/psci.h>
 #include <linux/arm-smccc.h>
 #include <linux/psci.h>
@@ -197,31 +180,27 @@ static int __init parse_nospectre_v2(char *str)
 }
 early_param("nospectre_v2", parse_nospectre_v2);
 
-static void
-enable_smccc_arch_workaround_1(const struct arm64_cpu_capabilities *entry)
+/*
+ * -1: No workaround
+ *  0: No workaround required
+ *  1: Workaround installed
+ */
+static int detect_harden_bp_fw(void)
 {
 	bp_hardening_cb_t cb;
 	void *smccc_start, *smccc_end;
 	struct arm_smccc_res res;
 	u32 midr = read_cpuid_id();
 
-	if (!entry->matches(entry, SCOPE_LOCAL_CPU))
-		return;
-
-	if (__nospectre_v2) {
-		pr_info_once("spectrev2 mitigation disabled by command line option\n");
-		return;
-	}
-
 	if (psci_ops.smccc_version == SMCCC_VERSION_1_0)
-		return;
+		return -1;
 
 	switch (psci_ops.conduit) {
 	case PSCI_CONDUIT_HVC:
 		arm_smccc_1_1_hvc(ARM_SMCCC_ARCH_FEATURES_FUNC_ID,
 				  ARM_SMCCC_ARCH_WORKAROUND_1, &res);
 		if ((int)res.a0 < 0)
-			return;
+			return -1;
 		cb = call_hvc_arch_workaround_1;
 		/* This is a guest, no need to patch KVM vectors */
 		smccc_start = NULL;
@@ -232,23 +211,23 @@ enable_smccc_arch_workaround_1(const struct arm64_cpu_capabilities *entry)
 		arm_smccc_1_1_smc(ARM_SMCCC_ARCH_FEATURES_FUNC_ID,
 				  ARM_SMCCC_ARCH_WORKAROUND_1, &res);
 		if ((int)res.a0 < 0)
-			return;
+			return -1;
 		cb = call_smc_arch_workaround_1;
 		smccc_start = __smccc_workaround_1_smc_start;
 		smccc_end = __smccc_workaround_1_smc_end;
 		break;
 
 	default:
-		return;
+		return -1;
 	}
 
 	if (((midr & MIDR_CPU_MODEL_MASK) == MIDR_QCOM_FALKOR) ||
 	    ((midr & MIDR_CPU_MODEL_MASK) == MIDR_QCOM_FALKOR_V1))
 		cb = qcom_link_stack_sanitization;
 
-	install_bp_hardening_cb(entry, cb, smccc_start, smccc_end);
+	install_bp_hardening_cb(cb, smccc_start, smccc_end);
 
-	return;
+	return 1;
 }
 #endif	/* CONFIG_HARDEN_BRANCH_PREDICTOR */
 
@@ -535,24 +514,48 @@ multi_entry_cap_cpu_enable(const struct arm64_cpu_capabilities *entry)
 }
 
 #ifdef CONFIG_HARDEN_BRANCH_PREDICTOR
-
 /*
- * List of CPUs where we need to issue a psci call to
- * harden the branch predictor.
+ * List of CPUs that do not need any Spectre-v2 mitigation at all.
  */
-static const struct midr_range arm64_bp_harden_smccc_cpus[] = {
-	MIDR_ALL_VERSIONS(MIDR_CORTEX_A57),
-	MIDR_ALL_VERSIONS(MIDR_CORTEX_A72),
-	MIDR_ALL_VERSIONS(MIDR_CORTEX_A73),
-	MIDR_ALL_VERSIONS(MIDR_CORTEX_A75),
-	MIDR_ALL_VERSIONS(MIDR_BRCM_VULCAN),
-	MIDR_ALL_VERSIONS(MIDR_CAVIUM_THUNDERX2),
-	MIDR_ALL_VERSIONS(MIDR_QCOM_FALKOR_V1),
-	MIDR_ALL_VERSIONS(MIDR_QCOM_FALKOR),
-	MIDR_ALL_VERSIONS(MIDR_NVIDIA_DENVER),
-	{},
+static const struct midr_range spectre_v2_safe_list[] = {
+	MIDR_ALL_VERSIONS(MIDR_CORTEX_A35),
+	MIDR_ALL_VERSIONS(MIDR_CORTEX_A53),
+	MIDR_ALL_VERSIONS(MIDR_CORTEX_A55),
+	{ /* sentinel */ }
 };
 
+static bool __maybe_unused
+check_branch_predictor(const struct arm64_cpu_capabilities *entry, int scope)
+{
+	int need_wa;
+
+	WARN_ON(scope != SCOPE_LOCAL_CPU || preemptible());
+
+	/* If the CPU has CSV2 set, we're safe */
+	if (cpuid_feature_extract_unsigned_field(read_cpuid(ID_AA64PFR0_EL1),
+						 ID_AA64PFR0_CSV2_SHIFT))
+		return false;
+
+	/* Alternatively, we have a list of unaffected CPUs */
+	if (is_midr_in_range_list(read_cpuid_id(), spectre_v2_safe_list))
+		return false;
+
+	/* Fallback to firmware detection */
+	need_wa = detect_harden_bp_fw();
+	if (!need_wa)
+		return false;
+
+	/* forced off */
+	if (__nospectre_v2) {
+		pr_info_once("spectrev2 mitigation disabled by command line option\n");
+		return false;
+	}
+
+	if (need_wa < 0)
+		pr_warn_once("ARM_SMCCC_ARCH_WORKAROUND_1 missing from firmware\n");
+
+	return (need_wa > 0);
+}
 #endif
 
 #ifdef CONFIG_HARDEN_EL2_VECTORS
@@ -715,8 +718,8 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 #ifdef CONFIG_HARDEN_BRANCH_PREDICTOR
 	{
 		.capability = ARM64_HARDEN_BRANCH_PREDICTOR,
-		.cpu_enable = enable_smccc_arch_workaround_1,
-		ERRATA_MIDR_RANGE_LIST(arm64_bp_harden_smccc_cpus),
+		.type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM,
+		.matches = check_branch_predictor,
 	},
 #endif
 #ifdef CONFIG_HARDEN_EL2_VECTORS
-- 
2.20.1

