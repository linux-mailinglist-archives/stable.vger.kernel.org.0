Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD6336157CC
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:39:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230219AbiKBCjN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:39:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230228AbiKBCjM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:39:12 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CC8E10FD8
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:39:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E8C31CE1F13
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:39:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ACF4C433D6;
        Wed,  2 Nov 2022 02:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667356747;
        bh=rmLklisJKeR0rX5mocF+4OLJOFc1c3wPB2sRlOAxbrQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wHDPRpfOvPyRF/CeUwnOMEIHl09xetX+o+DTUWyqPQnoN/57QtIqOfbR128IWuYrw
         Z7QrZ1GBUjPIbMGXpIz7c1g7RoQ2PuzDvQcntdYLCj4lrx7PqLnNGgl57JnPfYLc6l
         C+cEBMU4f5PTPclF9PXnnb78OzdvamDSEVqVQqFo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.0 052/240] cpufreq: intel_pstate: Read all MSRs on the target CPU
Date:   Wed,  2 Nov 2022 03:30:27 +0100
Message-Id: <20221102022112.576744814@linuxfoundation.org>
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

commit 8dbab94d45fb1094cefac7956b7fb987a36e2b12 upstream.

Some of the MSR accesses in intel_pstate are carried out on the CPU
that is running the code, but the values coming from them are used
for the performance scaling of the other CPUs.

This is problematic, for example, on hybrid platforms where
MSR_TURBO_RATIO_LIMIT for P-cores and E-cores is different, so the
values read from it on a P-core are generally not applicable to E-cores
and the other way around.

For this reason, make the driver access all MSRs on the target CPU on
platforms using the "core" pstate_funcs callbacks which is the case for
all of the hybrid platforms released to date.  For this purpose, pass
a CPU argument to the ->get_max(), ->get_max_physical(), ->get_min()
and ->get_turbo() pstate_funcs callbacks and from there pass it to
rdmsrl_on_cpu() or rdmsrl_safe_on_cpu() to access the MSR on the target
CPU.

Fixes: 46573fd6369f ("cpufreq: intel_pstate: hybrid: Rework HWP calibration")
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Tested-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: 5.15+ <stable@vger.kernel.org> # 5.15+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/intel_pstate.c |   66 ++++++++++++++++++++---------------------
 1 file changed, 33 insertions(+), 33 deletions(-)

--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -280,10 +280,10 @@ static struct cpudata **all_cpu_data;
  * structure is used to store those callbacks.
  */
 struct pstate_funcs {
-	int (*get_max)(void);
-	int (*get_max_physical)(void);
-	int (*get_min)(void);
-	int (*get_turbo)(void);
+	int (*get_max)(int cpu);
+	int (*get_max_physical)(int cpu);
+	int (*get_min)(int cpu);
+	int (*get_turbo)(int cpu);
 	int (*get_scaling)(void);
 	int (*get_cpu_scaling)(int cpu);
 	int (*get_aperf_mperf_shift)(void);
@@ -531,12 +531,12 @@ static void intel_pstate_hybrid_hwp_adju
 {
 	int perf_ctl_max_phys = cpu->pstate.max_pstate_physical;
 	int perf_ctl_scaling = cpu->pstate.perf_ctl_scaling;
-	int perf_ctl_turbo = pstate_funcs.get_turbo();
+	int perf_ctl_turbo = pstate_funcs.get_turbo(cpu->cpu);
 	int turbo_freq = perf_ctl_turbo * perf_ctl_scaling;
 	int scaling = cpu->pstate.scaling;
 
 	pr_debug("CPU%d: perf_ctl_max_phys = %d\n", cpu->cpu, perf_ctl_max_phys);
-	pr_debug("CPU%d: perf_ctl_max = %d\n", cpu->cpu, pstate_funcs.get_max());
+	pr_debug("CPU%d: perf_ctl_max = %d\n", cpu->cpu, pstate_funcs.get_max(cpu->cpu));
 	pr_debug("CPU%d: perf_ctl_turbo = %d\n", cpu->cpu, perf_ctl_turbo);
 	pr_debug("CPU%d: perf_ctl_scaling = %d\n", cpu->cpu, perf_ctl_scaling);
 	pr_debug("CPU%d: HWP_CAP guaranteed = %d\n", cpu->cpu, cpu->pstate.max_pstate);
@@ -1740,7 +1740,7 @@ static void intel_pstate_hwp_enable(stru
 	intel_pstate_update_epp_defaults(cpudata);
 }
 
-static int atom_get_min_pstate(void)
+static int atom_get_min_pstate(int not_used)
 {
 	u64 value;
 
@@ -1748,7 +1748,7 @@ static int atom_get_min_pstate(void)
 	return (value >> 8) & 0x7F;
 }
 
-static int atom_get_max_pstate(void)
+static int atom_get_max_pstate(int not_used)
 {
 	u64 value;
 
@@ -1756,7 +1756,7 @@ static int atom_get_max_pstate(void)
 	return (value >> 16) & 0x7F;
 }
 
-static int atom_get_turbo_pstate(void)
+static int atom_get_turbo_pstate(int not_used)
 {
 	u64 value;
 
@@ -1834,23 +1834,23 @@ static void atom_get_vid(struct cpudata
 	cpudata->vid.turbo = value & 0x7f;
 }
 
-static int core_get_min_pstate(void)
+static int core_get_min_pstate(int cpu)
 {
 	u64 value;
 
-	rdmsrl(MSR_PLATFORM_INFO, value);
+	rdmsrl_on_cpu(cpu, MSR_PLATFORM_INFO, &value);
 	return (value >> 40) & 0xFF;
 }
 
-static int core_get_max_pstate_physical(void)
+static int core_get_max_pstate_physical(int cpu)
 {
 	u64 value;
 
-	rdmsrl(MSR_PLATFORM_INFO, value);
+	rdmsrl_on_cpu(cpu, MSR_PLATFORM_INFO, &value);
 	return (value >> 8) & 0xFF;
 }
 
-static int core_get_tdp_ratio(u64 plat_info)
+static int core_get_tdp_ratio(int cpu, u64 plat_info)
 {
 	/* Check how many TDP levels present */
 	if (plat_info & 0x600000000) {
@@ -1860,13 +1860,13 @@ static int core_get_tdp_ratio(u64 plat_i
 		int err;
 
 		/* Get the TDP level (0, 1, 2) to get ratios */
-		err = rdmsrl_safe(MSR_CONFIG_TDP_CONTROL, &tdp_ctrl);
+		err = rdmsrl_safe_on_cpu(cpu, MSR_CONFIG_TDP_CONTROL, &tdp_ctrl);
 		if (err)
 			return err;
 
 		/* TDP MSR are continuous starting at 0x648 */
 		tdp_msr = MSR_CONFIG_TDP_NOMINAL + (tdp_ctrl & 0x03);
-		err = rdmsrl_safe(tdp_msr, &tdp_ratio);
+		err = rdmsrl_safe_on_cpu(cpu, tdp_msr, &tdp_ratio);
 		if (err)
 			return err;
 
@@ -1883,7 +1883,7 @@ static int core_get_tdp_ratio(u64 plat_i
 	return -ENXIO;
 }
 
-static int core_get_max_pstate(void)
+static int core_get_max_pstate(int cpu)
 {
 	u64 tar;
 	u64 plat_info;
@@ -1891,10 +1891,10 @@ static int core_get_max_pstate(void)
 	int tdp_ratio;
 	int err;
 
-	rdmsrl(MSR_PLATFORM_INFO, plat_info);
+	rdmsrl_on_cpu(cpu, MSR_PLATFORM_INFO, &plat_info);
 	max_pstate = (plat_info >> 8) & 0xFF;
 
-	tdp_ratio = core_get_tdp_ratio(plat_info);
+	tdp_ratio = core_get_tdp_ratio(cpu, plat_info);
 	if (tdp_ratio <= 0)
 		return max_pstate;
 
@@ -1903,7 +1903,7 @@ static int core_get_max_pstate(void)
 		return tdp_ratio;
 	}
 
-	err = rdmsrl_safe(MSR_TURBO_ACTIVATION_RATIO, &tar);
+	err = rdmsrl_safe_on_cpu(cpu, MSR_TURBO_ACTIVATION_RATIO, &tar);
 	if (!err) {
 		int tar_levels;
 
@@ -1918,13 +1918,13 @@ static int core_get_max_pstate(void)
 	return max_pstate;
 }
 
-static int core_get_turbo_pstate(void)
+static int core_get_turbo_pstate(int cpu)
 {
 	u64 value;
 	int nont, ret;
 
-	rdmsrl(MSR_TURBO_RATIO_LIMIT, value);
-	nont = core_get_max_pstate();
+	rdmsrl_on_cpu(cpu, MSR_TURBO_RATIO_LIMIT, &value);
+	nont = core_get_max_pstate(cpu);
 	ret = (value) & 255;
 	if (ret <= nont)
 		ret = nont;
@@ -1952,13 +1952,13 @@ static int knl_get_aperf_mperf_shift(voi
 	return 10;
 }
 
-static int knl_get_turbo_pstate(void)
+static int knl_get_turbo_pstate(int cpu)
 {
 	u64 value;
 	int nont, ret;
 
-	rdmsrl(MSR_TURBO_RATIO_LIMIT, value);
-	nont = core_get_max_pstate();
+	rdmsrl_on_cpu(cpu, MSR_TURBO_RATIO_LIMIT, &value);
+	nont = core_get_max_pstate(cpu);
 	ret = (((value) >> 8) & 0xFF);
 	if (ret <= nont)
 		ret = nont;
@@ -2025,10 +2025,10 @@ static void intel_pstate_max_within_limi
 
 static void intel_pstate_get_cpu_pstates(struct cpudata *cpu)
 {
-	int perf_ctl_max_phys = pstate_funcs.get_max_physical();
+	int perf_ctl_max_phys = pstate_funcs.get_max_physical(cpu->cpu);
 	int perf_ctl_scaling = pstate_funcs.get_scaling();
 
-	cpu->pstate.min_pstate = pstate_funcs.get_min();
+	cpu->pstate.min_pstate = pstate_funcs.get_min(cpu->cpu);
 	cpu->pstate.max_pstate_physical = perf_ctl_max_phys;
 	cpu->pstate.perf_ctl_scaling = perf_ctl_scaling;
 
@@ -2044,8 +2044,8 @@ static void intel_pstate_get_cpu_pstates
 		}
 	} else {
 		cpu->pstate.scaling = perf_ctl_scaling;
-		cpu->pstate.max_pstate = pstate_funcs.get_max();
-		cpu->pstate.turbo_pstate = pstate_funcs.get_turbo();
+		cpu->pstate.max_pstate = pstate_funcs.get_max(cpu->cpu);
+		cpu->pstate.turbo_pstate = pstate_funcs.get_turbo(cpu->cpu);
 	}
 
 	if (cpu->pstate.scaling == perf_ctl_scaling) {
@@ -3221,9 +3221,9 @@ static unsigned int force_load __initdat
 
 static int __init intel_pstate_msrs_not_valid(void)
 {
-	if (!pstate_funcs.get_max() ||
-	    !pstate_funcs.get_min() ||
-	    !pstate_funcs.get_turbo())
+	if (!pstate_funcs.get_max(0) ||
+	    !pstate_funcs.get_min(0) ||
+	    !pstate_funcs.get_turbo(0))
 		return -ENODEV;
 
 	return 0;


