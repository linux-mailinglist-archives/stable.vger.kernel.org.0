Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 768F85A69A6
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 19:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231340AbiH3RVp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Aug 2022 13:21:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231297AbiH3RVR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Aug 2022 13:21:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FE6619C12;
        Tue, 30 Aug 2022 10:20:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4A8956172E;
        Tue, 30 Aug 2022 17:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38FB3C433D6;
        Tue, 30 Aug 2022 17:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661880011;
        bh=f66oQmEUDi5jyeaVm8jdub++cvX9VjPwNqQpeCKKxp8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UyS8WoI31EiDAio0Q0Ru6u1aksV/zi3PpoNb/MEZFKk0FAmz9lDYbtuAx4B5lYbUq
         I7cJcdYpMuPqjdnElTfB7af/yx8Wb9G1nsn9HqvYRTArtSxGX9+Om16xIsP3bqRTfk
         J3ce5t8SADt6A3h5QoPFvmz/sGT0gSTKU2xtWkBAChpBO61BEcFaIM6kKb4JwHgEIa
         2N1xZvoqjs4sVGuI3wIO0IzwpOrPQEVzOfHmKmL+vtYADuWmB9lvsMQuVqBGZFdwOi
         CXBNKp3NbfJGdkgZsoP1SiuabjuCiUUDjHm/VWSU8zb7icGO3uBl/GIwUXSlSh74LL
         C9RXfdOqQGhwA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ionela Voinescu <ionela.voinescu@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Sasha Levin <sashal@kernel.org>, corbet@lwn.net,
        anshuman.khandual@arm.com, suzuki.poulose@arm.com,
        mathieu.poirier@linaro.org, lcherian@marvell.com,
        broonie@kernel.org, arnd@arndb.de, maz@kernel.org,
        vladimir.murzin@arm.com, joey.gouly@arm.com, ardb@kernel.org,
        gshan@redhat.com, song.bao.hua@hisilicon.com, peterz@infradead.org,
        sudeep.holla@arm.com, Jonathan.Cameron@huawei.com,
        linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 18/33] arm64: errata: add detection for AMEVCNTR01 incrementing incorrectly
Date:   Tue, 30 Aug 2022 13:18:09 -0400
Message-Id: <20220830171825.580603-18-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220830171825.580603-1-sashal@kernel.org>
References: <20220830171825.580603-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ionela Voinescu <ionela.voinescu@arm.com>

[ Upstream commit e89d120c4b720e232cc6a94f0fcbd59c15d41489 ]

The AMU counter AMEVCNTR01 (constant counter) should increment at the same
rate as the system counter. On affected Cortex-A510 cores, AMEVCNTR01
increments incorrectly giving a significantly higher output value. This
results in inaccurate task scheduler utilization tracking and incorrect
feedback on CPU frequency.

Work around this problem by returning 0 when reading the affected counter
in key locations that results in disabling all users of this counter from
using it either for frequency invariance or as FFH reference counter. This
effect is the same to firmware disabling affected counters.

Details on how the two features are affected by this erratum:

 - AMU counters will not be used for frequency invariance for affected
   CPUs and CPUs in the same cpufreq policy. AMUs can still be used for
   frequency invariance for unaffected CPUs in the system. Although
   unlikely, if no alternative method can be found to support frequency
   invariance for affected CPUs (cpufreq based or solution based on
   platform counters) frequency invariance will be disabled. Please check
   the chapter on frequency invariance at
   Documentation/scheduler/sched-capacity.rst for details of its effect.

 - Given that FFH can be used to fetch either the core or constant counter
   values, restrictions are lifted regarding any of these counters
   returning a valid (!0) value. Therefore FFH is considered supported
   if there is a least one CPU that support AMUs, independent of any
   counters being disabled or affected by this erratum. Clarifying
   comments are now added to the cpc_ffh_supported(), cpu_read_constcnt()
   and cpu_read_corecnt() functions.

The above is achieved through adding a new erratum: ARM64_ERRATUM_2457168.

Signed-off-by: Ionela Voinescu <ionela.voinescu@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: James Morse <james.morse@arm.com>
Link: https://lore.kernel.org/r/20220819103050.24211-1-ionela.voinescu@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/arm64/silicon-errata.rst |  2 ++
 arch/arm64/Kconfig                     | 17 ++++++++++++++
 arch/arm64/kernel/cpu_errata.c         | 10 ++++++++
 arch/arm64/kernel/cpufeature.c         |  5 +++-
 arch/arm64/kernel/topology.c           | 32 ++++++++++++++++++++++++--
 arch/arm64/tools/cpucaps               |  1 +
 6 files changed, 64 insertions(+), 3 deletions(-)

diff --git a/Documentation/arm64/silicon-errata.rst b/Documentation/arm64/silicon-errata.rst
index 0b4235b1f8c46..d174df4f0377e 100644
--- a/Documentation/arm64/silicon-errata.rst
+++ b/Documentation/arm64/silicon-errata.rst
@@ -52,6 +52,8 @@ stable kernels.
 | Allwinner      | A64/R18         | UNKNOWN1        | SUN50I_ERRATUM_UNKNOWN1     |
 +----------------+-----------------+-----------------+-----------------------------+
 +----------------+-----------------+-----------------+-----------------------------+
+| ARM            | Cortex-A510     | #2457168        | ARM64_ERRATUM_2457168       |
++----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A510     | #2064142        | ARM64_ERRATUM_2064142       |
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A510     | #2038923        | ARM64_ERRATUM_2038923       |
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index a5d1b561ed53f..7bc2fd28dc6ef 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -897,6 +897,23 @@ config ARM64_ERRATUM_1902691
 
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
+	  Work around this problem by returning 0 when reading the affected counter in
+	  key locations that results in disabling all users of this counter. This effect
+	  is the same to firmware disabling affected counters.
+
+	  If unsure, say Y.
+
 config CAVIUM_ERRATUM_22375
 	bool "Cavium erratum 22375, 24313"
 	default y
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 6b92989f4cc27..dcffcd43c17f8 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -648,6 +648,16 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		ERRATA_MIDR_REV_RANGE(MIDR_CORTEX_A510, 0, 0, 2)
 	},
 #endif
+#ifdef CONFIG_ARM64_ERRATUM_2457168
+	{
+		.desc = "ARM erratum 2457168",
+		.capability = ARM64_WORKAROUND_2457168,
+		.type = ARM64_CPUCAP_WEAK_LOCAL_CPU_FEATURE,
+
+		/* Cortex-A510 r0p0-r1p1 */
+		CAP_MIDR_RANGE(MIDR_CORTEX_A510, 0, 0, 1, 1)
+	},
+#endif
 #ifdef CONFIG_ARM64_ERRATUM_2038923
 	{
 		.desc = "ARM erratum 2038923",
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index ebdfbd1cf207b..f34c9f8b9ee0a 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1798,7 +1798,10 @@ static void cpu_amu_enable(struct arm64_cpu_capabilities const *cap)
 		pr_info("detected CPU%d: Activity Monitors Unit (AMU)\n",
 			smp_processor_id());
 		cpumask_set_cpu(smp_processor_id(), &amu_cpus);
-		update_freq_counters_refs();
+
+		/* 0 reference values signal broken/disabled counters */
+		if (!this_cpu_has_cap(ARM64_WORKAROUND_2457168))
+			update_freq_counters_refs();
 	}
 }
 
diff --git a/arch/arm64/kernel/topology.c b/arch/arm64/kernel/topology.c
index 9ab78ad826e2a..707b5451929d4 100644
--- a/arch/arm64/kernel/topology.c
+++ b/arch/arm64/kernel/topology.c
@@ -310,12 +310,25 @@ core_initcall(init_amu_fie);
 
 static void cpu_read_corecnt(void *val)
 {
+	/*
+	 * A value of 0 can be returned if the current CPU does not support AMUs
+	 * or if the counter is disabled for this CPU. A return value of 0 at
+	 * counter read is properly handled as an error case by the users of the
+	 * counter.
+	 */
 	*(u64 *)val = read_corecnt();
 }
 
 static void cpu_read_constcnt(void *val)
 {
-	*(u64 *)val = read_constcnt();
+	/*
+	 * Return 0 if the current CPU is affected by erratum 2457168. A value
+	 * of 0 is also returned if the current CPU does not support AMUs or if
+	 * the counter is disabled. A return value of 0 at counter read is
+	 * properly handled as an error case by the users of the counter.
+	 */
+	*(u64 *)val = this_cpu_has_cap(ARM64_WORKAROUND_2457168) ?
+		      0UL : read_constcnt();
 }
 
 static inline
@@ -342,7 +355,22 @@ int counters_read_on_cpu(int cpu, smp_call_func_t func, u64 *val)
  */
 bool cpc_ffh_supported(void)
 {
-	return freq_counters_valid(get_cpu_with_amu_feat());
+	int cpu = get_cpu_with_amu_feat();
+
+	/*
+	 * FFH is considered supported if there is at least one present CPU that
+	 * supports AMUs. Using FFH to read core and reference counters for CPUs
+	 * that do not support AMUs, have counters disabled or that are affected
+	 * by errata, will result in a return value of 0.
+	 *
+	 * This is done to allow any enabled and valid counters to be read
+	 * through FFH, knowing that potentially returning 0 as counter value is
+	 * properly handled by the users of these counters.
+	 */
+	if ((cpu >= nr_cpu_ids) || !cpumask_test_cpu(cpu, cpu_present_mask))
+		return false;
+
+	return true;
 }
 
 int cpc_read_ffh(int cpu, struct cpc_reg *reg, u64 *val)
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index 8809e14cf86a2..18999f46df19f 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -66,6 +66,7 @@ WORKAROUND_1902691
 WORKAROUND_2038923
 WORKAROUND_2064142
 WORKAROUND_2077057
+WORKAROUND_2457168
 WORKAROUND_TRBE_OVERWRITE_FILL_MODE
 WORKAROUND_TSB_FLUSH_FAILURE
 WORKAROUND_TRBE_WRITE_OUT_OF_RANGE
-- 
2.35.1

