Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E10C3E662F
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:09:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729504AbfJ0VJ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:09:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:55808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728255AbfJ0VJ0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:09:26 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC66020873;
        Sun, 27 Oct 2019 21:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572210565;
        bh=5rGOHxdHV9ZIQXqg1PPXAB+NumLzZ2ZkyPS4HKwri8I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f1LYp7NxR6NMvt4fuPzr187wJcPGBiHIDOkWMDKBK/fzYLD2MgyqTwNU+m+XU3wTv
         GFUPSjkPM3l5/rb79y3ZBuawin7V07ORsF8ptRLYyY/VSCWZ16mtmTZG1mN6BeiXeS
         sbPJVCx8lnb2is0liENyfu07xvf8vZ9/X05JaUrw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Dave Martin <dave.martin@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 4.14 060/119] arm64: capabilities: Change scope of VHE to Boot CPU feature
Date:   Sun, 27 Oct 2019 22:00:37 +0100
Message-Id: <20191027203326.326345015@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/cpufeature.h |    6 +++++
 arch/arm64/include/asm/virt.h       |    6 -----
 arch/arm64/kernel/cpufeature.c      |    5 ++--
 arch/arm64/kernel/smp.c             |   38 ------------------------------------
 4 files changed, 9 insertions(+), 46 deletions(-)

--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -283,6 +283,12 @@ extern struct arm64_ftr_reg arm64_ftr_re
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
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -982,13 +982,15 @@ static const struct arm64_cpu_capabiliti
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
@@ -1332,7 +1334,6 @@ static bool verify_local_cpu_caps(u16 sc
  */
 static void check_early_cpu_features(void)
 {
-	verify_cpu_run_el();
 	verify_cpu_asid_bits();
 	/*
 	 * Early features are used by the kernel already. If there
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


