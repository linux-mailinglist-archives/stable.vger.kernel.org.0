Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D13F34F693F
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 20:19:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240097AbiDFSIy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 14:08:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240449AbiDFSHy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 14:07:54 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C00E818D98A;
        Wed,  6 Apr 2022 09:46:16 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A738123A;
        Wed,  6 Apr 2022 09:46:16 -0700 (PDT)
Received: from eglon.cambridge.arm.com (eglon.cambridge.arm.com [10.1.196.218])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 05D433F73B;
        Wed,  6 Apr 2022 09:46:15 -0700 (PDT)
From:   James Morse <james.morse@arm.com>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [stable:PATCH v4.9.309 16/43] arm64: arch_timer: Add workaround for ARM erratum 1188873
Date:   Wed,  6 Apr 2022 17:45:19 +0100
Message-Id: <20220406164546.1888528-16-james.morse@arm.com>
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

From: Marc Zyngier <marc.zyngier@arm.com>

commit 95b861a4a6d94f64d5242605569218160ebacdbe upstream.

When running on Cortex-A76, a timer access from an AArch32 EL0
task may end up with a corrupted value or register. The workaround for
this is to trap these accesses at EL1/EL2 and execute them there.

This only affects versions r0p0, r1p0 and r2p0 of the CPU.

Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: James Morse <james.morse@arm.com>
---
 arch/arm64/Kconfig                   | 12 ++++++++++++
 arch/arm64/include/asm/cpucaps.h     |  3 ++-
 arch/arm64/include/asm/cputype.h     |  2 ++
 arch/arm64/kernel/cpu_errata.c       |  8 ++++++++
 drivers/clocksource/arm_arch_timer.c | 15 +++++++++++++++
 5 files changed, 39 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index b12275be0e13..a36595c1557b 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -441,6 +441,18 @@ config ARM64_ERRATUM_1024718
 
 	  If unsure, say Y.
 
+config ARM64_ERRATUM_1188873
+	bool "Cortex-A76: MRC read following MRRC read of specific Generic Timer in AArch32 might give incorrect result"
+	default y
+	help
+	  This option adds work arounds for ARM Cortex-A76 erratum 1188873
+
+	  Affected Cortex-A76 cores (r0p0, r1p0, r2p0) could cause
+	  register corruption when accessing the timer registers from
+	  AArch32 userspace.
+
+	  If unsure, say Y.
+
 config CAVIUM_ERRATUM_22375
 	bool "Cavium erratum 22375, 24313"
 	default y
diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
index 8c7c4b23a8b1..d4a46764c1ad 100644
--- a/arch/arm64/include/asm/cpucaps.h
+++ b/arch/arm64/include/asm/cpucaps.h
@@ -38,7 +38,8 @@
 #define ARM64_HARDEN_BRANCH_PREDICTOR		17
 #define ARM64_SSBD				18
 #define ARM64_MISMATCHED_CACHE_TYPE		19
+#define ARM64_WORKAROUND_1188873		20
 
-#define ARM64_NCAPS				20
+#define ARM64_NCAPS				21
 
 #endif /* __ASM_CPUCAPS_H */
diff --git a/arch/arm64/include/asm/cputype.h b/arch/arm64/include/asm/cputype.h
index 61041e051acb..76b551e83f2d 100644
--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -85,6 +85,7 @@
 #define ARM_CPU_PART_CORTEX_A75		0xD0A
 #define ARM_CPU_PART_CORTEX_A35		0xD04
 #define ARM_CPU_PART_CORTEX_A55		0xD05
+#define ARM_CPU_PART_CORTEX_A76		0xD0B
 
 #define APM_CPU_PART_POTENZA		0x000
 
@@ -102,6 +103,7 @@
 #define MIDR_CORTEX_A75 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A75)
 #define MIDR_CORTEX_A35 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A35)
 #define MIDR_CORTEX_A55 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A55)
+#define MIDR_CORTEX_A76	MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A76)
 #define MIDR_THUNDERX	MIDR_CPU_MODEL(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX)
 #define MIDR_THUNDERX_81XX MIDR_CPU_MODEL(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX_81XX)
 #define MIDR_CAVIUM_THUNDERX2 MIDR_CPU_MODEL(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX2)
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 69c3492cb063..37cb8c23ccc6 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -532,6 +532,14 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		.capability = ARM64_SSBD,
 		.matches = has_ssbd_mitigation,
 	},
+#endif
+#ifdef CONFIG_ARM64_ERRATUM_1188873
+	{
+		/* Cortex-A76 r0p0 to r2p0 */
+		.desc = "ARM erratum 1188873",
+		.capability = ARM64_WORKAROUND_1188873,
+		ERRATA_MIDR_RANGE(MIDR_CORTEX_A76, 0, 0, 2, 0),
+	},
 #endif
 	{
 	}
diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index 138dbfdfb413..e70d0974470c 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -130,6 +130,13 @@ static u64 notrace fsl_a008585_read_cntvct_el0(void)
 }
 #endif
 
+#ifdef CONFIG_ARM64_ERRATUM_1188873
+static u64 notrace arm64_1188873_read_cntvct_el0(void)
+{
+	return read_sysreg(cntvct_el0);
+}
+#endif
+
 #ifdef CONFIG_ARM_ARCH_TIMER_OOL_WORKAROUND
 const struct arch_timer_erratum_workaround *timer_unstable_counter_workaround = NULL;
 EXPORT_SYMBOL_GPL(timer_unstable_counter_workaround);
@@ -148,6 +155,14 @@ static const struct arch_timer_erratum_workaround ool_workarounds[] = {
 		.read_cntvct_el0 = fsl_a008585_read_cntvct_el0,
 	},
 #endif
+#ifdef CONFIG_ARM64_ERRATUM_1188873
+	{
+		.match_type = ate_match_local_cap_id,
+		.id = (void *)ARM64_WORKAROUND_1188873,
+		.desc = "ARM erratum 1188873",
+		.read_cntvct_el0 = arm64_1188873_read_cntvct_el0,
+	},
+#endif
 };
 
 typedef bool (*ate_match_fn_t)(const struct arch_timer_erratum_workaround *,
-- 
2.30.2

