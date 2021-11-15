Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50DB1450559
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 14:24:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231571AbhKON1b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 08:27:31 -0500
Received: from mga05.intel.com ([192.55.52.43]:46256 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231627AbhKON12 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 08:27:28 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10168"; a="319647404"
X-IronPort-AV: E=Sophos;i="5.87,236,1631602800"; 
   d="scan'208";a="319647404"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2021 05:23:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,236,1631602800"; 
   d="scan'208";a="734981986"
Received: from spandruv-desk.jf.intel.com ([10.54.75.21])
  by fmsmga005.fm.intel.com with ESMTP; 15 Nov 2021 05:23:08 -0800
From:   Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
To:     rafael@kernel.org, viresh.kumar@linaro.org
Cc:     linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH] cpufreq: intel_pstate: Fix EPP restore after offline/online
Date:   Mon, 15 Nov 2021 05:23:02 -0800
Message-Id: <20211115132302.1257642-1-srinivas.pandruvada@linux.intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When using performance policy, EPP value is restored to non "performance"
mode EPP after offline and online.

For example:
cat /sys/devices/system/cpu/cpu1/cpufreq/energy_performance_preference
performance
echo 0 > /sys/devices/system/cpu/cpu1/online
echo 1 > /sys/devices/system/cpu/cpu1/online
cat /sys/devices/system/cpu/cpu1/cpufreq/energy_performance_preference
balance_performance

The commit 4adcf2e5829f ("cpufreq: intel_pstate: Add ->offline and ->online callbacks")
optimized save restore path of the HWP request MSR, when there is no
change in the policy. Also added special processing for performance mode
EPP. If EPP has been set to "performance" by the active mode "performance"
scaling algorithm, replace that value with the cached EPP. This ends up
replacing with cached EPP during offline, which is restored during online
again.

So add a change which will set cpu_data->epp_policy to zero, when in
performance policy and has non zero epp. In this way EPP is set to zero
again.

Fixes: 4adcf2e5829f ("cpufreq: intel_pstate: Add ->offline and ->online callbacks")
Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: stable@vger.kernel.org # v5.9+
---
 drivers/cpufreq/intel_pstate.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index 815df3daae9d..49ff24d2b0ea 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -930,17 +930,23 @@ static void intel_pstate_hwp_set(unsigned int cpu)
 {
 	struct cpudata *cpu_data = all_cpu_data[cpu];
 	int max, min;
+	s16 epp = 0;
 	u64 value;
-	s16 epp;
 
 	max = cpu_data->max_perf_ratio;
 	min = cpu_data->min_perf_ratio;
 
-	if (cpu_data->policy == CPUFREQ_POLICY_PERFORMANCE)
-		min = max;
-
 	rdmsrl_on_cpu(cpu, MSR_HWP_REQUEST, &value);
 
+	if (boot_cpu_has(X86_FEATURE_HWP_EPP))
+		epp = (value >> 24) & 0xff;
+
+	if (cpu_data->policy == CPUFREQ_POLICY_PERFORMANCE) {
+		min = max;
+		if (epp)
+			cpu_data->epp_policy = 0;
+	}
+
 	value &= ~HWP_MIN_PERF(~0L);
 	value |= HWP_MIN_PERF(min);
 
-- 
2.17.1

