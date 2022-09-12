Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5BD55B5BA7
	for <lists+stable@lfdr.de>; Mon, 12 Sep 2022 15:52:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbiILNwz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Sep 2022 09:52:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbiILNwv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Sep 2022 09:52:51 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A8A473122D;
        Mon, 12 Sep 2022 06:52:46 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D272B113E;
        Mon, 12 Sep 2022 06:52:52 -0700 (PDT)
Received: from e108754-lin.cambridge.arm.com (unknown [10.1.195.34])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 5F28B3F73B;
        Mon, 12 Sep 2022 06:52:45 -0700 (PDT)
From:   Ionela Voinescu <ionela.voinescu@arm.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>, stable@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ionela Voinescu <ionela.voinescu@arm.com>
Subject: [PATCH stable-5.10] arm64: errata: add detection for AMEVCNTR01 incrementing incorrectly
Date:   Mon, 12 Sep 2022 14:52:26 +0100
Message-Id: <20220912135226.31027-1-ionela.voinescu@arm.com>
X-Mailer: git-send-email 2.29.2.dirty
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit e89d120c4b720e232cc6a94f0fcbd59c15d41489 upstream.

The AMU counter AMEVCNTR01 (constant counter) should increment at the same
rate as the system counter. On affected Cortex-A510 cores, AMEVCNTR01
increments incorrectly giving a significantly higher output value. This
results in inaccurate task scheduler utilization tracking.

Work around this problem by keeping the reference values of affected
counters to 0. This results in disabling the single user of this
counter: Frequency Invariance Engine (FIE).
This effect is the same to firmware disabling affected counters, in
which case 0 will be returned when reading the disabled counters.

Therefore, AMU counters will not be used for frequency invariance for
affected CPUs and CPUs in the same cpufreq policy. AMUs can still be used
for frequency invariance for unaffected CPUs in the system.

The above is achieved through adding a new erratum: ARM64_ERRATUM_2457168.

Signed-off-by: Ionela Voinescu <ionela.voinescu@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: James Morse <james.morse@arm.com>
Link: https://lore.kernel.org/r/20220819103050.24211-1-ionela.voinescu@arm.com
---

Hi,

This is a backport to stable 5.10.142 of the upstream commit
e89d120c4b72  arm64: errata: add detection for AMEVCNTR01 incrementing incorrectly

This is sent separately as there were conflicts that needed resolving
when applying the mainline patch. Compared to the upstream version this
no longer handles the FFH usecase, as FFH support is not present in 5.10.
Therefore the commit message and Kconfig description are modified to
only describe the effect on FIE caused by this erratum.

Thanks,
Ionela.

 Documentation/arm64/silicon-errata.rst |  2 ++
 arch/arm64/Kconfig                     | 18 ++++++++++++++++++
 arch/arm64/include/asm/cpucaps.h       |  3 ++-
 arch/arm64/kernel/cpu_errata.c         |  9 +++++++++
 arch/arm64/kernel/cpufeature.c         |  5 ++++-
 5 files changed, 35 insertions(+), 2 deletions(-)

diff --git a/Documentation/arm64/silicon-errata.rst b/Documentation/arm64/silicon-errata.rst
index f01eed0ee23a..22a07c208fee 100644
--- a/Documentation/arm64/silicon-errata.rst
+++ b/Documentation/arm64/silicon-errata.rst
@@ -92,6 +92,8 @@ stable kernels.
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A77      | #1508412        | ARM64_ERRATUM_1508412       |
 +----------------+-----------------+-----------------+-----------------------------+
+| ARM            | Cortex-A510     | #2457168        | ARM64_ERRATUM_2457168       |
++----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Neoverse-N1     | #1188873,1418040| ARM64_ERRATUM_1418040       |
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Neoverse-N1     | #1349291        | N/A                         |
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 7c7906e9dafd..1116a8d092c0 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -657,6 +657,24 @@ config ARM64_ERRATUM_1508412
 
 	  If unsure, say Y.
 
+config ARM64_ERRATUM_2457168
+	bool "Cortex-A510: 2457168: workaround for AMEVCNTR01 incrementing incorrectly"
+	depends on ARM64_AMU_EXTN
+	default y
+	help
+	  This option adds the workaround for ARM Cortex-A510 erratum 2457168.
+
+	  The AMU counter AMEVCNTR01 (constant counter) should increment at the same rate
+	  as the system counter. On affected Cortex-A510 cores AMEVCNTR01 increments
+	  incorrectly giving a significantly higher output value.
+
+	  Work around this problem by keeping the reference values of affected counters
+	  to 0 thus signaling an error case. This effect is the same to firmware disabling
+	  affected counters, in which case 0 will be returned when reading the disabled
+	  counters.
+
+	  If unsure, say Y.
+
 config CAVIUM_ERRATUM_22375
 	bool "Cavium erratum 22375, 24313"
 	default y
diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
index f42fd0a2e81c..53030d3c03a2 100644
--- a/arch/arm64/include/asm/cpucaps.h
+++ b/arch/arm64/include/asm/cpucaps.h
@@ -67,7 +67,8 @@
 #define ARM64_MTE				57
 #define ARM64_WORKAROUND_1508412		58
 #define ARM64_SPECTRE_BHB			59
+#define ARM64_WORKAROUND_2457168		60
 
-#define ARM64_NCAPS				60
+#define ARM64_NCAPS				61
 
 #endif /* __ASM_CPUCAPS_H */
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 78263dadd00d..aaacca6fd52f 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -545,6 +545,15 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 				  0, 0,
 				  1, 0),
 	},
+#endif
+#ifdef CONFIG_ARM64_ERRATUM_2457168
+	{
+		.desc = "ARM erratum 2457168",
+		.capability = ARM64_WORKAROUND_2457168,
+		.type = ARM64_CPUCAP_WEAK_LOCAL_CPU_FEATURE,
+		/* Cortex-A510 r0p0-r1p1 */
+		CAP_MIDR_RANGE(MIDR_CORTEX_A510, 0, 0, 1, 1)
+	},
 #endif
 	{
 	}
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 4087e2d1f39e..e72c90b82656 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1559,7 +1559,10 @@ static void cpu_amu_enable(struct arm64_cpu_capabilities const *cap)
 		pr_info("detected CPU%d: Activity Monitors Unit (AMU)\n",
 			smp_processor_id());
 		cpumask_set_cpu(smp_processor_id(), &amu_cpus);
-		init_cpu_freq_invariance_counters();
+
+		/* 0 reference values signal broken/disabled counters */
+		if (!this_cpu_has_cap(ARM64_WORKAROUND_2457168))
+			init_cpu_freq_invariance_counters();
 	}
 }
 
-- 
2.25.1

