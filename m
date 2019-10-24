Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B006CE32F1
	for <lists+stable@lfdr.de>; Thu, 24 Oct 2019 14:49:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502135AbfJXMtt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Oct 2019 08:49:49 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:39901 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502116AbfJXMtt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Oct 2019 08:49:49 -0400
Received: by mail-wm1-f66.google.com with SMTP id r141so2476120wme.4
        for <stable@vger.kernel.org>; Thu, 24 Oct 2019 05:49:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fp1j0eEG+2J0tFRMVO601i3+ZfSgSeh9e99I2w9v8FE=;
        b=TJuKDBEQfxNck4R3NCTTJ7EQlXEiTKQU81aK8dYb+VXrIMLSLQp0n1huvddva9z618
         jzDEBZcIf7PBMbpNTBVB1XIqHm0ob2Kv378PtX9Nt+Xrkehra/46PRaNEbkeuBefevgA
         OnlyzQkdFZZfo0keFmhPe3gp135zcs6lVYXCh9hIhtbQwniuoF0GsUWFZg5kzHZvInno
         yvx7ZwG74kLkD8HVPU3lnsQKxKrYCOdGvdfyhqTQCIcnNGWeFFWzrUBp9VPLEUR5XNZe
         ONrroMQdGmhq2DjVslfJvZ7df2VXwGrPUiYlLWmsAI3hZ/SU49ysO8usGz4p4u2fW75C
         /U5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fp1j0eEG+2J0tFRMVO601i3+ZfSgSeh9e99I2w9v8FE=;
        b=Q0w9VrxgTYyCG5z7pM6qnTpda/gsCwEuAam7Ugh1RwyxhwnnbpAGDHRtM1NhSbfKKi
         iRvDpOw2weFdoRc9MnlzSJ3jFR9gwcN/mfrwl9qYZWHma9vFE/lkxTIBIwEsM8KpJr5x
         6VymnccOIN/FzNdYmYNMktY3LJnui6r0bJRQL7hkw2fpnEjKW5E3YDxhY6p0Ow4MCcZi
         bqUCe+6di3FqerNWWvd3UgMacQGwgYbiEkUjPZ/KNxPi0/MfntPwHxYlRccs5StxAllQ
         IC1Gn0HGjEIEBHQnC4MRQkuJ5J08Gb3lMTQdUiPaOH5V89MWdAMBlaLYf7wYotKKzB3K
         N3+w==
X-Gm-Message-State: APjAAAVH0thkvQC2OQHxcPAS/yV9CcF4K1aCvFYn6G2sGGmgAP9MNJ2U
        NjlDgiUU1BOY3iWdW45UnWGCmtxwwAUC3RgO
X-Google-Smtp-Source: APXvYqwuKcGe6prP/aAYAvSOlnjVaULmyg8f9h/QfB3p0neVLjSfZIL8hgS4y2GD2q7igTjvgvlDUw==
X-Received: by 2002:a1c:f20e:: with SMTP id s14mr4581133wmc.118.1571921387022;
        Thu, 24 Oct 2019 05:49:47 -0700 (PDT)
Received: from localhost.localdomain (aaubervilliers-681-1-126-126.w90-88.abo.wanadoo.fr. [90.88.7.126])
        by smtp.gmail.com with ESMTPSA id j22sm29111038wrd.41.2019.10.24.05.49.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 05:49:46 -0700 (PDT)
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
        Stefan Wahren <stefan.wahren@i2se.com>,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH for-stable-4.14 37/48] arm64: add sysfs vulnerability show for meltdown
Date:   Thu, 24 Oct 2019 14:48:22 +0200
Message-Id: <20191024124833.4158-38-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191024124833.4158-1-ard.biesheuvel@linaro.org>
References: <20191024124833.4158-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeremy Linton <jeremy.linton@arm.com>

[ Upstream commit 1b3ccf4be0e7be8c4bd8522066b6cbc92591e912 ]

We implement page table isolation as a mitigation for meltdown.
Report this to userspace via sysfs.

Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Tested-by: Stefan Wahren <stefan.wahren@i2se.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/kernel/cpufeature.c | 58 +++++++++++++++-----
 1 file changed, 44 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index d8e89b5d99ee..b782e98633da 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -824,7 +824,7 @@ static bool has_no_fpsimd(const struct arm64_cpu_capabilities *entry, int __unus
 					ID_AA64PFR0_FP_SHIFT) < 0;
 }
 
-#ifdef CONFIG_UNMAP_KERNEL_AT_EL0
+static bool __meltdown_safe = true;
 static int __kpti_forced; /* 0: not forced, >0: forced on, <0: forced off */
 
 static bool unmap_kernel_at_el0(const struct arm64_cpu_capabilities *entry,
@@ -842,6 +842,16 @@ static bool unmap_kernel_at_el0(const struct arm64_cpu_capabilities *entry,
 		MIDR_ALL_VERSIONS(MIDR_CORTEX_A73),
 	};
 	char const *str = "command line option";
+	bool meltdown_safe;
+
+	meltdown_safe = is_midr_in_range_list(read_cpuid_id(), kpti_safe_list);
+
+	/* Defer to CPU feature registers */
+	if (has_cpuid_feature(entry, scope))
+		meltdown_safe = true;
+
+	if (!meltdown_safe)
+		__meltdown_safe = false;
 
 	/*
 	 * For reasons that aren't entirely clear, enabling KPTI on Cavium
@@ -853,6 +863,19 @@ static bool unmap_kernel_at_el0(const struct arm64_cpu_capabilities *entry,
 		__kpti_forced = -1;
 	}
 
+	/* Useful for KASLR robustness */
+	if (IS_ENABLED(CONFIG_RANDOMIZE_BASE) && kaslr_offset() > 0) {
+		if (!__kpti_forced) {
+			str = "KASLR";
+			__kpti_forced = 1;
+		}
+	}
+
+	if (!IS_ENABLED(CONFIG_UNMAP_KERNEL_AT_EL0)) {
+		pr_info_once("kernel page table isolation disabled by kernel configuration\n");
+		return false;
+	}
+
 	/* Forced? */
 	if (__kpti_forced) {
 		pr_info_once("kernel page table isolation forced %s by %s\n",
@@ -860,18 +883,10 @@ static bool unmap_kernel_at_el0(const struct arm64_cpu_capabilities *entry,
 		return __kpti_forced > 0;
 	}
 
-	/* Useful for KASLR robustness */
-	if (IS_ENABLED(CONFIG_RANDOMIZE_BASE))
-		return true;
-
-	/* Don't force KPTI for CPUs that are not vulnerable */
-	if (is_midr_in_range_list(read_cpuid_id(), kpti_safe_list))
-		return false;
-
-	/* Defer to CPU feature registers */
-	return !has_cpuid_feature(entry, scope);
+	return !meltdown_safe;
 }
 
+#ifdef CONFIG_UNMAP_KERNEL_AT_EL0
 static void
 kpti_install_ng_mappings(const struct arm64_cpu_capabilities *__unused)
 {
@@ -896,6 +911,12 @@ kpti_install_ng_mappings(const struct arm64_cpu_capabilities *__unused)
 
 	return;
 }
+#else
+static void
+kpti_install_ng_mappings(const struct arm64_cpu_capabilities *__unused)
+{
+}
+#endif	/* CONFIG_UNMAP_KERNEL_AT_EL0 */
 
 static int __init parse_kpti(char *str)
 {
@@ -909,7 +930,6 @@ static int __init parse_kpti(char *str)
 	return 0;
 }
 early_param("kpti", parse_kpti);
-#endif	/* CONFIG_UNMAP_KERNEL_AT_EL0 */
 
 static void cpu_copy_el2regs(const struct arm64_cpu_capabilities *__unused)
 {
@@ -1056,7 +1076,6 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
 		.matches = hyp_offset_low,
 	},
-#ifdef CONFIG_UNMAP_KERNEL_AT_EL0
 	{
 		.desc = "Kernel page table isolation (KPTI)",
 		.capability = ARM64_UNMAP_KERNEL_AT_EL0,
@@ -1072,7 +1091,6 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.matches = unmap_kernel_at_el0,
 		.cpu_enable = kpti_install_ng_mappings,
 	},
-#endif
 	{
 		/* FP/SIMD is not implemented */
 		.capability = ARM64_HAS_NO_FPSIMD,
@@ -1629,3 +1647,15 @@ static int __init enable_mrs_emulation(void)
 }
 
 core_initcall(enable_mrs_emulation);
+
+ssize_t cpu_show_meltdown(struct device *dev, struct device_attribute *attr,
+			  char *buf)
+{
+	if (__meltdown_safe)
+		return sprintf(buf, "Not affected\n");
+
+	if (arm64_kernel_unmapped_at_el0())
+		return sprintf(buf, "Mitigation: PTI\n");
+
+	return sprintf(buf, "Vulnerable\n");
+}
-- 
2.20.1

