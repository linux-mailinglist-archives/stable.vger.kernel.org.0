Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 343BCCFDD6
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 17:40:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728116AbfJHPkU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 11:40:20 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43776 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726839AbfJHPkU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Oct 2019 11:40:20 -0400
Received: by mail-wr1-f67.google.com with SMTP id j18so19167697wrq.10
        for <stable@vger.kernel.org>; Tue, 08 Oct 2019 08:40:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kbzBcWnld/N54945YghT0NSVpVg+3HASkkBRpykqA4g=;
        b=AOjgSQ5UM5dZI8mnyvs1Buj1mSIR4IiEF5MT3WaNMNGDjKY/zDzdcXs6wzbvvEGyqa
         tc9ul4fdH/d3vR4vMFj+CEK7p2Tu6WXu3wjQ/pxPxnfz0rzczFgJKe55673RTq8VF0aV
         Ad5xKj/ZUJ2ISNX02vCdwCq83flR5ZtloCrrH6LDksK1TK+H9lV/pyHAMpBlyYtANC3w
         mIGZH7llT4Pz98QM0E9yZwlF6kg6Z31iQtkR/QSldpfSISpFcuaHRNtV+67qDeEiKKC/
         U54qqrfjkPPBt/2loB9AEDBpveQQyFEew6vahtJppXmJ16ugzT4XzXOQ9h+Lj5SY6NDA
         pcdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kbzBcWnld/N54945YghT0NSVpVg+3HASkkBRpykqA4g=;
        b=ZQqu+vitoa6U+GTBa/DgBCvyYG4m4WNIAbCtxvyOI6DSM2yYN2UNi5UOWkmL6HInf3
         zKczwcRoZeNKPWnLCfx6X2bF/eQXSksH7QJ4v0C5bomx6FLlcVIJkKuCmDhbDPu5Iejo
         tKhQoU6cxm0sJnUQmLtUUhGFFB2WHzx0Hstn9FZSsr096NO7qImno5pZw0EA8zYYBGpX
         AbI5AJONPwIWicC4/PQzw3B4NWKYRAna8EU4TLJFCwrAwW1jpEjM44Px4BNSix7kYU2L
         TQ+YO8i130I5a5gOu4hv2seWYCdrUGyMwtt2eqnqI2bAJPinQjfX3aAfVdgQ+9qPNA5D
         Istg==
X-Gm-Message-State: APjAAAWUksGW0Yl3w/tAuVp2df49bMSydLtDJ2ZWdDiotm25MyKwcxHp
        65Wv8EAOntLiahLaZEoJ+TGn/w==
X-Google-Smtp-Source: APXvYqw8A5aVYGVWA2WGBoHoKxRbamgkLIL62HlIFOoM0hRhqAgDqHKKp6Du8OXl1x4E2JpEc/8ulg==
X-Received: by 2002:a5d:45cb:: with SMTP id b11mr28845784wrs.109.1570549216953;
        Tue, 08 Oct 2019 08:40:16 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id x16sm16784723wrl.32.2019.10.08.08.40.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Oct 2019 08:40:16 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-arm-kernel@lists.infradead.org
Cc:     stable@vger.kernel.org, Jeremy Linton <jeremy.linton@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Will Deacon <will.deacon@arm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH for-stable-v4.19 07/16] arm64: add sysfs vulnerability show for meltdown
Date:   Tue,  8 Oct 2019 17:39:21 +0200
Message-Id: <20191008153930.15386-8-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191008153930.15386-1-ard.biesheuvel@linaro.org>
References: <20191008153930.15386-1-ard.biesheuvel@linaro.org>
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
index 9c756a1657aa..e636d37d7087 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -889,7 +889,7 @@ static bool has_cache_dic(const struct arm64_cpu_capabilities *entry,
 	return ctr & BIT(CTR_DIC_SHIFT);
 }
 
-#ifdef CONFIG_UNMAP_KERNEL_AT_EL0
+static bool __meltdown_safe = true;
 static int __kpti_forced; /* 0: not forced, >0: forced on, <0: forced off */
 
 static bool unmap_kernel_at_el0(const struct arm64_cpu_capabilities *entry,
@@ -908,6 +908,16 @@ static bool unmap_kernel_at_el0(const struct arm64_cpu_capabilities *entry,
 		{ /* sentinel */ }
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
@@ -919,6 +929,19 @@ static bool unmap_kernel_at_el0(const struct arm64_cpu_capabilities *entry,
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
@@ -926,18 +949,10 @@ static bool unmap_kernel_at_el0(const struct arm64_cpu_capabilities *entry,
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
@@ -962,6 +977,12 @@ kpti_install_ng_mappings(const struct arm64_cpu_capabilities *__unused)
 
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
@@ -975,7 +996,6 @@ static int __init parse_kpti(char *str)
 	return 0;
 }
 early_param("kpti", parse_kpti);
-#endif	/* CONFIG_UNMAP_KERNEL_AT_EL0 */
 
 #ifdef CONFIG_ARM64_HW_AFDBM
 static inline void __cpu_enable_hw_dbm(void)
@@ -1196,7 +1216,6 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.field_pos = ID_AA64PFR0_EL0_SHIFT,
 		.min_field_value = ID_AA64PFR0_EL0_32BIT_64BIT,
 	},
-#ifdef CONFIG_UNMAP_KERNEL_AT_EL0
 	{
 		.desc = "Kernel page table isolation (KPTI)",
 		.capability = ARM64_UNMAP_KERNEL_AT_EL0,
@@ -1212,7 +1231,6 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.matches = unmap_kernel_at_el0,
 		.cpu_enable = kpti_install_ng_mappings,
 	},
-#endif
 	{
 		/* FP/SIMD is not implemented */
 		.capability = ARM64_HAS_NO_FPSIMD,
@@ -1853,3 +1871,15 @@ void cpu_clear_disr(const struct arm64_cpu_capabilities *__unused)
 	/* Firmware may have left a deferred SError in this register. */
 	write_sysreg_s(0, SYS_DISR_EL1);
 }
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

