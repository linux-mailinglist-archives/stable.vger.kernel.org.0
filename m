Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B7D65B7222
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231535AbiIMOo5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:44:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231600AbiIMOn0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:43:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04FB66E883;
        Tue, 13 Sep 2022 07:23:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4DD17B80FAC;
        Tue, 13 Sep 2022 14:21:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB192C4314B;
        Tue, 13 Sep 2022 14:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078881;
        bh=5Ac6h/yAdlkrk31PwU418awnqFyqpgZ6RqQIz3z6cgs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B01snsd+46u+wBFSFV4vCxdbjIuNpTOTU9E2YzKedqmEYr5c8AHRXfP6FYS7p7i6Q
         +mcogtgDKfx2esq2ddWyxxrqCLamXBgAwn03mmRmFzSK0HGUj0/sC3r3Pqo2GFjJ3s
         nGLiUtRX2RVpNaAEDCbegEbbtH07tz42aZuDrA4U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ionela Voinescu <ionela.voinescu@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>
Subject: [PATCH 5.15 118/121] arm64: errata: add detection for AMEVCNTR01 incrementing incorrectly
Date:   Tue, 13 Sep 2022 16:05:09 +0200
Message-Id: <20220913140402.435841961@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140357.323297659@linuxfoundation.org>
References: <20220913140357.323297659@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

commit e89d120c4b720e232cc6a94f0fcbd59c15d41489 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/arm64/silicon-errata.rst |    2 ++
 arch/arm64/Kconfig                     |   17 +++++++++++++++++
 arch/arm64/kernel/cpu_errata.c         |    9 +++++++++
 arch/arm64/kernel/cpufeature.c         |    5 ++++-
 arch/arm64/kernel/topology.c           |   32 ++++++++++++++++++++++++++++++--
 arch/arm64/tools/cpucaps               |    1 +
 6 files changed, 63 insertions(+), 3 deletions(-)

--- a/Documentation/arm64/silicon-errata.rst
+++ b/Documentation/arm64/silicon-errata.rst
@@ -94,6 +94,8 @@ stable kernels.
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A510     | #2441009        | ARM64_ERRATUM_2441009       |
 +----------------+-----------------+-----------------+-----------------------------+
+| ARM            | Cortex-A510     | #2457168        | ARM64_ERRATUM_2457168       |
++----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Neoverse-N1     | #1188873,1418040| ARM64_ERRATUM_1418040       |
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Neoverse-N1     | #1349291        | N/A                         |
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -683,6 +683,23 @@ config ARM64_ERRATUM_2441009
 
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
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -551,6 +551,15 @@ const struct arm64_cpu_capabilities arm6
 		ERRATA_MIDR_ALL_VERSIONS(MIDR_NVIDIA_CARMEL),
 	},
 #endif
+#ifdef CONFIG_ARM64_ERRATUM_2457168
+	{
+		.desc = "ARM erratum 2457168",
+		.capability = ARM64_WORKAROUND_2457168,
+		.type = ARM64_CPUCAP_WEAK_LOCAL_CPU_FEATURE,
+		/* Cortex-A510 r0p0-r1p1 */
+		CAP_MIDR_RANGE(MIDR_CORTEX_A510, 0, 0, 1, 1)
+	},
+#endif
 	{
 	}
 };
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1736,7 +1736,10 @@ static void cpu_amu_enable(struct arm64_
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
 
--- a/arch/arm64/kernel/topology.c
+++ b/arch/arm64/kernel/topology.c
@@ -308,12 +308,25 @@ core_initcall(init_amu_fie);
 
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
@@ -340,7 +353,22 @@ int counters_read_on_cpu(int cpu, smp_ca
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
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -54,6 +54,7 @@ WORKAROUND_1418040
 WORKAROUND_1463225
 WORKAROUND_1508412
 WORKAROUND_1542419
+WORKAROUND_2457168
 WORKAROUND_CAVIUM_23154
 WORKAROUND_CAVIUM_27456
 WORKAROUND_CAVIUM_30115


