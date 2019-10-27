Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04C0DE663E
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:10:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729627AbfJ0VKG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:10:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:56492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729606AbfJ0VKF (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:10:05 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E2732064A;
        Sun, 27 Oct 2019 21:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572210605;
        bh=1oMNMrK0NmsSeFiB3o1cyKQqEZTPEu/Oc6jImObE9eI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ieDndb3KckUAVpViXEHWp9PwkPUutUmzoAf6wfSC/Gdr0p8Qg3+LIDL0wo8jzEKvp
         lwhc7ZU5qcc3Cwjpk8gRdKYywL+JpvXopYJKglCJW08Mgtv3vMy9sNCLfnto5fYIKU
         Ds0JS89nMiRhOQUhdsBZjspVYiTICtX8pe7OZh2Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Will Deacon <will.deacon@arm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 4.14 073/119] arm64: add sysfs vulnerability show for meltdown
Date:   Sun, 27 Oct 2019 22:00:50 +0100
Message-Id: <20191027203339.394733907@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203259.948006506@linuxfoundation.org>
References: <20191027203259.948006506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/cpufeature.c |   58 +++++++++++++++++++++++++++++++----------
 1 file changed, 44 insertions(+), 14 deletions(-)

--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -824,7 +824,7 @@ static bool has_no_fpsimd(const struct a
 					ID_AA64PFR0_FP_SHIFT) < 0;
 }
 
-#ifdef CONFIG_UNMAP_KERNEL_AT_EL0
+static bool __meltdown_safe = true;
 static int __kpti_forced; /* 0: not forced, >0: forced on, <0: forced off */
 
 static bool unmap_kernel_at_el0(const struct arm64_cpu_capabilities *entry,
@@ -842,6 +842,16 @@ static bool unmap_kernel_at_el0(const st
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
@@ -853,6 +863,19 @@ static bool unmap_kernel_at_el0(const st
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
@@ -860,18 +883,10 @@ static bool unmap_kernel_at_el0(const st
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
@@ -896,6 +911,12 @@ kpti_install_ng_mappings(const struct ar
 
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
@@ -1056,7 +1076,6 @@ static const struct arm64_cpu_capabiliti
 		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
 		.matches = hyp_offset_low,
 	},
-#ifdef CONFIG_UNMAP_KERNEL_AT_EL0
 	{
 		.desc = "Kernel page table isolation (KPTI)",
 		.capability = ARM64_UNMAP_KERNEL_AT_EL0,
@@ -1072,7 +1091,6 @@ static const struct arm64_cpu_capabiliti
 		.matches = unmap_kernel_at_el0,
 		.cpu_enable = kpti_install_ng_mappings,
 	},
-#endif
 	{
 		/* FP/SIMD is not implemented */
 		.capability = ARM64_HAS_NO_FPSIMD,
@@ -1629,3 +1647,15 @@ static int __init enable_mrs_emulation(v
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


