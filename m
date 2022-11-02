Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55F376157CD
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:39:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230228AbiKBCjQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:39:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230202AbiKBCjO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:39:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFC19DFDD
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:39:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7DFF5601C6
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:39:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 235E0C433D6;
        Wed,  2 Nov 2022 02:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667356752;
        bh=84YLYv7EqAONd+qMS/1J+TzeUm4CCBfPsiK5dT3oido=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DVxFoVIfPcGX39Vx0+WD/pKsVRdFWqrEiCQ84vZx1iKjvPcxqxcfD8mi7mKLWSxEq
         POHmeQiO9yUDeE1ZjBsxDWM9TcfR2JrZplR1hP7CHGYPNICfhknKm9GOI4zR/iGfLm
         KcJlVuMditDUxGvEzEOCqwboBWuEvu07R6RdjDGg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.0 053/240] cpufreq: intel_pstate: hybrid: Use known scaling factor for P-cores
Date:   Wed,  2 Nov 2022 03:30:28 +0100
Message-Id: <20221102022112.600179456@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit f5c8cf2a4992dd929fa0c2f25c09ee69b8dcbce1 upstream.

Commit 46573fd6369f ("cpufreq: intel_pstate: hybrid: Rework HWP
calibration") attempted to use the information from CPPC (the nominal
performance in particular) to obtain the scaling factor allowing the
frequency to be computed if the HWP performance level of the given CPU
is known or vice versa.

However, it turns out that on some platforms this doesn't work, because
the CPPC information on them does not align with the contents of the
MSR_HWP_CAPABILITIES registers.

This basically means that the only way to make intel_pstate work on all
of the hybrid platforms to date is to use the observation that on all
of them the scaling factor between the HWP performance levels and
frequency for P-cores is 78741 (approximately 100000/1.27).  For
E-cores it is 100000, which is the same as for all of the non-hybrid
"core" platforms and does not require any changes.

Accordingly, make intel_pstate use 78741 as the scaling factor between
HWP performance levels and frequency for P-cores on all hybrid platforms
and drop the dependency of the HWP calibration code on CPPC.

Fixes: 46573fd6369f ("cpufreq: intel_pstate: hybrid: Rework HWP calibration")
Reported-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Tested-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: 5.15+ <stable@vger.kernel.org> # 5.15+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/intel_pstate.c |   69 ++++++++---------------------------------
 1 file changed, 15 insertions(+), 54 deletions(-)

--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -27,6 +27,7 @@
 #include <linux/pm_qos.h>
 #include <trace/events/power.h>
 
+#include <asm/cpu.h>
 #include <asm/div64.h>
 #include <asm/msr.h>
 #include <asm/cpu_device_id.h>
@@ -398,16 +399,6 @@ static int intel_pstate_get_cppc_guarant
 
 	return cppc_perf.nominal_perf;
 }
-
-static u32 intel_pstate_cppc_nominal(int cpu)
-{
-	u64 nominal_perf;
-
-	if (cppc_get_nominal_perf(cpu, &nominal_perf))
-		return 0;
-
-	return nominal_perf;
-}
 #else /* CONFIG_ACPI_CPPC_LIB */
 static inline void intel_pstate_set_itmt_prio(int cpu)
 {
@@ -532,34 +523,17 @@ static void intel_pstate_hybrid_hwp_adju
 	int perf_ctl_max_phys = cpu->pstate.max_pstate_physical;
 	int perf_ctl_scaling = cpu->pstate.perf_ctl_scaling;
 	int perf_ctl_turbo = pstate_funcs.get_turbo(cpu->cpu);
-	int turbo_freq = perf_ctl_turbo * perf_ctl_scaling;
 	int scaling = cpu->pstate.scaling;
 
 	pr_debug("CPU%d: perf_ctl_max_phys = %d\n", cpu->cpu, perf_ctl_max_phys);
-	pr_debug("CPU%d: perf_ctl_max = %d\n", cpu->cpu, pstate_funcs.get_max(cpu->cpu));
 	pr_debug("CPU%d: perf_ctl_turbo = %d\n", cpu->cpu, perf_ctl_turbo);
 	pr_debug("CPU%d: perf_ctl_scaling = %d\n", cpu->cpu, perf_ctl_scaling);
 	pr_debug("CPU%d: HWP_CAP guaranteed = %d\n", cpu->cpu, cpu->pstate.max_pstate);
 	pr_debug("CPU%d: HWP_CAP highest = %d\n", cpu->cpu, cpu->pstate.turbo_pstate);
 	pr_debug("CPU%d: HWP-to-frequency scaling factor: %d\n", cpu->cpu, scaling);
 
-	/*
-	 * If the product of the HWP performance scaling factor and the HWP_CAP
-	 * highest performance is greater than the maximum turbo frequency
-	 * corresponding to the pstate_funcs.get_turbo() return value, the
-	 * scaling factor is too high, so recompute it to make the HWP_CAP
-	 * highest performance correspond to the maximum turbo frequency.
-	 */
-	cpu->pstate.turbo_freq = cpu->pstate.turbo_pstate * scaling;
-	if (turbo_freq < cpu->pstate.turbo_freq) {
-		cpu->pstate.turbo_freq = turbo_freq;
-		scaling = DIV_ROUND_UP(turbo_freq, cpu->pstate.turbo_pstate);
-		cpu->pstate.scaling = scaling;
-
-		pr_debug("CPU%d: refined HWP-to-frequency scaling factor: %d\n",
-			 cpu->cpu, scaling);
-	}
-
+	cpu->pstate.turbo_freq = rounddown(cpu->pstate.turbo_pstate * scaling,
+					   perf_ctl_scaling);
 	cpu->pstate.max_freq = rounddown(cpu->pstate.max_pstate * scaling,
 					 perf_ctl_scaling);
 
@@ -1965,37 +1939,24 @@ static int knl_get_turbo_pstate(int cpu)
 	return ret;
 }
 
-#ifdef CONFIG_ACPI_CPPC_LIB
-static u32 hybrid_ref_perf;
-
-static int hybrid_get_cpu_scaling(int cpu)
+static void hybrid_get_type(void *data)
 {
-	return DIV_ROUND_UP(core_get_scaling() * hybrid_ref_perf,
-			    intel_pstate_cppc_nominal(cpu));
+	u8 *cpu_type = data;
+
+	*cpu_type = get_this_hybrid_cpu_type();
 }
 
-static void intel_pstate_cppc_set_cpu_scaling(void)
+static int hybrid_get_cpu_scaling(int cpu)
 {
-	u32 min_nominal_perf = U32_MAX;
-	int cpu;
+	u8 cpu_type = 0;
 
-	for_each_present_cpu(cpu) {
-		u32 nominal_perf = intel_pstate_cppc_nominal(cpu);
+	smp_call_function_single(cpu, hybrid_get_type, &cpu_type, 1);
+	/* P-cores have a smaller perf level-to-freqency scaling factor. */
+	if (cpu_type == 0x40)
+		return 78741;
 
-		if (nominal_perf && nominal_perf < min_nominal_perf)
-			min_nominal_perf = nominal_perf;
-	}
-
-	if (min_nominal_perf < U32_MAX) {
-		hybrid_ref_perf = min_nominal_perf;
-		pstate_funcs.get_cpu_scaling = hybrid_get_cpu_scaling;
-	}
+	return core_get_scaling();
 }
-#else
-static inline void intel_pstate_cppc_set_cpu_scaling(void)
-{
-}
-#endif /* CONFIG_ACPI_CPPC_LIB */
 
 static void intel_pstate_set_pstate(struct cpudata *cpu, int pstate)
 {
@@ -3450,7 +3411,7 @@ static int __init intel_pstate_init(void
 				default_driver = &intel_pstate;
 
 			if (boot_cpu_has(X86_FEATURE_HYBRID_CPU))
-				intel_pstate_cppc_set_cpu_scaling();
+				pstate_funcs.get_cpu_scaling = hybrid_get_cpu_scaling;
 
 			goto hwp_cpu_matched;
 		}


