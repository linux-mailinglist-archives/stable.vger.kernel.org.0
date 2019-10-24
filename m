Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 580EAE32E3
	for <lists+stable@lfdr.de>; Thu, 24 Oct 2019 14:49:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502110AbfJXMta (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Oct 2019 08:49:30 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46766 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502106AbfJXMta (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Oct 2019 08:49:30 -0400
Received: by mail-wr1-f65.google.com with SMTP id n15so15145433wrw.13
        for <stable@vger.kernel.org>; Thu, 24 Oct 2019 05:49:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Eimc9IKe9BJb7hwSO4hQ9EC/8mUFFrY2wMn6tEaIHE8=;
        b=Wgv/cUSI8ahA+ndenjUxmPj8ZsEYCnWRpSE33v/iqFTV3cBe7VG6N0yue8n6rOno91
         jrlL89ruvUulV6UzOuYMzZWQiwKwkyKpGBS4GIwMYZi16nmRAtiXlAwoXjXzV+HRjWYk
         HqEpyNIKHrlEA272/oyKhpm53Q2h1tD3wWnHj2Du34qkMMF4wKWBf5/0KFoqsoPQlPDv
         0xaEUmbLl0+qJi7Aw6Sdj3jRlbOU9AUOoYdUF8qobgwDTe+HXLXXJk5w4uCPXeOSLhw1
         nSL9DQU5QluaT19wLN9viDRNrNddvnssmbNpw+Nrfu0+EHmVeWMsjuOKz0N03m8OB0XN
         M/HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Eimc9IKe9BJb7hwSO4hQ9EC/8mUFFrY2wMn6tEaIHE8=;
        b=phr0Gi9PaJIumtL/8UX0AbFQkNg5zygPAyr9iLqElWzNgF9dg9gjSrra6dOHIh2tZj
         AUYIFpemARIch3pDD4rYJijgE+RI4DrmOfd5KSPma922lkfCl+qC/zstfyXzmTDK9vXQ
         79shCGPJ9Y0v80WO9iP1+zQd1Ze+1kixEN2rgDq2hmxHyzZkyh9Qtuqyz0iSiHopAnvk
         dXfRxjcnR27hqpM0DE3FPWUB7CW8PUAO5PY3PCLNEaN53OHsxvHhPE4Dziw4pSB34wzr
         VxuIe8OiSDLToU8Nn134KAhlCpXu83KgHR4FTMsi3Vmg6dH8CWa731EuJrG0oquxR9b2
         Is5g==
X-Gm-Message-State: APjAAAXe+LZUX3PgejTaDsQXP1WBWlN8e0Q7SzLJkdLrhyM5PHnwHcQZ
        y8QlQW+aU55WvGKVogbZLJLBM5+4zaCsfn9Z
X-Google-Smtp-Source: APXvYqy99Owdbmi+JpWUVqvuKBt4mcBbS3u9v0oF5uI9GLQaUS0dnf8I2zfldZFZKiW1r9DM+VK5ZA==
X-Received: by 2002:adf:d846:: with SMTP id k6mr3804381wrl.178.1571921366516;
        Thu, 24 Oct 2019 05:49:26 -0700 (PDT)
Received: from localhost.localdomain (aaubervilliers-681-1-126-126.w90-88.abo.wanadoo.fr. [90.88.7.126])
        by smtp.gmail.com with ESMTPSA id j22sm29111038wrd.41.2019.10.24.05.49.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 05:49:25 -0700 (PDT)
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
        Marc Zyngier <marc.zyngier@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Dave Martin <dave.martin@arm.com>
Subject: [PATCH for-stable-4.14 24/48] arm64: capabilities: Change scope of VHE to Boot CPU feature
Date:   Thu, 24 Oct 2019 14:48:09 +0200
Message-Id: <20191024124833.4158-25-ard.biesheuvel@linaro.org>
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

[ Upstream commit 830dcc9f9a7cd26a812522a26efaacf7df6fc365 ]

We expect all CPUs to be running at the same EL inside the kernel
with or without VHE enabled and we have strict checks to ensure
that any mismatch triggers a kernel panic. If VHE is enabled,
we use the feature based on the boot CPU and all other CPUs
should follow. This makes it a perfect candidate for a capability
based on the boot CPU,  which should be matched by all the CPUs
(both when is ON and OFF). This saves us some not-so-pretty
hooks and special code, just for verifying the conflict.

The patch also makes the VHE capability entry depend on
CONFIG_ARM64_VHE.

Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Reviewed-by: Dave Martin <dave.martin@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/include/asm/cpufeature.h |  6 ++++
 arch/arm64/include/asm/virt.h       |  6 ----
 arch/arm64/kernel/cpufeature.c      |  5 +--
 arch/arm64/kernel/smp.c             | 38 --------------------
 4 files changed, 9 insertions(+), 46 deletions(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 793e5fd4c583..839aaa1505a3 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -283,6 +283,12 @@ extern struct arm64_ftr_reg arm64_ftr_reg_ctrel0;
 	(ARM64_CPUCAP_SCOPE_LOCAL_CPU		|	\
 	 ARM64_CPUCAP_OPTIONAL_FOR_LATE_CPU)
 
+/*
+ * CPU feature used early in the boot based on the boot CPU. All secondary
+ * CPUs must match the state of the capability as detected by the boot CPU.
+ */
+#define ARM64_CPUCAP_STRICT_BOOT_CPU_FEATURE ARM64_CPUCAP_SCOPE_BOOT_CPU
+
 struct arm64_cpu_capabilities {
 	const char *desc;
 	u16 capability;
diff --git a/arch/arm64/include/asm/virt.h b/arch/arm64/include/asm/virt.h
index c5f89442785c..9d1e24e030b3 100644
--- a/arch/arm64/include/asm/virt.h
+++ b/arch/arm64/include/asm/virt.h
@@ -102,12 +102,6 @@ static inline bool has_vhe(void)
 	return false;
 }
 
-#ifdef CONFIG_ARM64_VHE
-extern void verify_cpu_run_el(void);
-#else
-static inline void verify_cpu_run_el(void) {}
-#endif
-
 #endif /* __ASSEMBLY__ */
 
 #endif /* ! __ASM__VIRT_H */
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 1a1eb3b85e82..d1897d8f40a2 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -982,13 +982,15 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.matches = cpufeature_pan_not_uao,
 	},
 #endif /* CONFIG_ARM64_PAN */
+#ifdef CONFIG_ARM64_VHE
 	{
 		.desc = "Virtualization Host Extensions",
 		.capability = ARM64_HAS_VIRT_HOST_EXTN,
-		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.type = ARM64_CPUCAP_STRICT_BOOT_CPU_FEATURE,
 		.matches = runs_at_el2,
 		.cpu_enable = cpu_copy_el2regs,
 	},
+#endif	/* CONFIG_ARM64_VHE */
 	{
 		.desc = "32-bit EL0 Support",
 		.capability = ARM64_HAS_32BIT_EL0,
@@ -1332,7 +1334,6 @@ static bool verify_local_cpu_caps(u16 scope_mask)
  */
 static void check_early_cpu_features(void)
 {
-	verify_cpu_run_el();
 	verify_cpu_asid_bits();
 	/*
 	 * Early features are used by the kernel already. If there
diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
index e9b8395e24a7..a683cd499515 100644
--- a/arch/arm64/kernel/smp.c
+++ b/arch/arm64/kernel/smp.c
@@ -83,43 +83,6 @@ enum ipi_msg_type {
 	IPI_WAKEUP
 };
 
-#ifdef CONFIG_ARM64_VHE
-
-/* Whether the boot CPU is running in HYP mode or not*/
-static bool boot_cpu_hyp_mode;
-
-static inline void save_boot_cpu_run_el(void)
-{
-	boot_cpu_hyp_mode = is_kernel_in_hyp_mode();
-}
-
-static inline bool is_boot_cpu_in_hyp_mode(void)
-{
-	return boot_cpu_hyp_mode;
-}
-
-/*
- * Verify that a secondary CPU is running the kernel at the same
- * EL as that of the boot CPU.
- */
-void verify_cpu_run_el(void)
-{
-	bool in_el2 = is_kernel_in_hyp_mode();
-	bool boot_cpu_el2 = is_boot_cpu_in_hyp_mode();
-
-	if (in_el2 ^ boot_cpu_el2) {
-		pr_crit("CPU%d: mismatched Exception Level(EL%d) with boot CPU(EL%d)\n",
-					smp_processor_id(),
-					in_el2 ? 2 : 1,
-					boot_cpu_el2 ? 2 : 1);
-		cpu_panic_kernel();
-	}
-}
-
-#else
-static inline void save_boot_cpu_run_el(void) {}
-#endif
-
 #ifdef CONFIG_HOTPLUG_CPU
 static int op_cpu_kill(unsigned int cpu);
 #else
@@ -448,7 +411,6 @@ void __init smp_prepare_boot_cpu(void)
 	 */
 	jump_label_init();
 	cpuinfo_store_boot_cpu();
-	save_boot_cpu_run_el();
 }
 
 static u64 __init of_get_cpu_mpidr(struct device_node *dn)
-- 
2.20.1

