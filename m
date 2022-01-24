Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0896049A408
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:08:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2369356AbiAYABf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:01:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1848335AbiAXXWP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:22:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B897C01D7CF;
        Mon, 24 Jan 2022 13:29:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1801461500;
        Mon, 24 Jan 2022 21:29:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB4ACC33E60;
        Mon, 24 Jan 2022 21:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059742;
        bh=XEBpaPbYCRhgT9ik4uDmR4UvypnIw4Bm8lNnbHJKlNk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T1Y8RKxcCcU0iivQgxXqKysMbS+DPvCgV4WCWzPZuHJ3gGyjZIHbJOHETjrYsd7OH
         Yv+9DzkFmaSU5fWnKOVaFPFEa4dJ+aEDQy3PXkdQt26/i3B1hepF2juYTRif0/6Tdx
         LlmaxZHbpwIoc1T837cN4JMSqPSRK8YCmpLggHtE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0691/1039] cpufreq: intel_pstate: Update cpuinfo.max_freq on HWP_CAP changes
Date:   Mon, 24 Jan 2022 19:41:20 +0100
Message-Id: <20220124184148.573035013@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit dfeeedc1bf5772226bddf51ed3f853e5a6707bf1 ]

With HWP enabled, when the turbo range of performance levels is
disabled by the platform firmware, the CPU capacity is given by
the "guaranteed performance" field in MSR_HWP_CAPABILITIES which
is generally dynamic.  When it changes, the kernel receives an HWP
notification interrupt handled by notify_hwp_interrupt().

When the "guaranteed performance" value changes in the above
configuration, the CPU performance scaling needs to be adjusted so
as to use the new CPU capacity in computations, which means that
the cpuinfo.max_freq value needs to be updated for that CPU.

Accordingly, modify intel_pstate_notify_work() to read
MSR_HWP_CAPABILITIES and update cpuinfo.max_freq to reflect the
new configuration (this update can be carried out even if the
configuration doesn't actually change, because it simply doesn't
matter then and it takes less time to update it than to do extra
checks to decide whether or not a change has really occurred).

Reported-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Tested-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/intel_pstate.c | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index dec2a5649ac1a..676edc580fd4f 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -1124,19 +1124,22 @@ static void intel_pstate_update_policies(void)
 		cpufreq_update_policy(cpu);
 }
 
+static void __intel_pstate_update_max_freq(struct cpudata *cpudata,
+					   struct cpufreq_policy *policy)
+{
+	policy->cpuinfo.max_freq = global.turbo_disabled_mf ?
+			cpudata->pstate.max_freq : cpudata->pstate.turbo_freq;
+	refresh_frequency_limits(policy);
+}
+
 static void intel_pstate_update_max_freq(unsigned int cpu)
 {
 	struct cpufreq_policy *policy = cpufreq_cpu_acquire(cpu);
-	struct cpudata *cpudata;
 
 	if (!policy)
 		return;
 
-	cpudata = all_cpu_data[cpu];
-	policy->cpuinfo.max_freq = global.turbo_disabled_mf ?
-			cpudata->pstate.max_freq : cpudata->pstate.turbo_freq;
-
-	refresh_frequency_limits(policy);
+	__intel_pstate_update_max_freq(all_cpu_data[cpu], policy);
 
 	cpufreq_cpu_release(policy);
 }
@@ -1584,8 +1587,15 @@ static void intel_pstate_notify_work(struct work_struct *work)
 {
 	struct cpudata *cpudata =
 		container_of(to_delayed_work(work), struct cpudata, hwp_notify_work);
+	struct cpufreq_policy *policy = cpufreq_cpu_acquire(cpudata->cpu);
+
+	if (policy) {
+		intel_pstate_get_hwp_cap(cpudata);
+		__intel_pstate_update_max_freq(cpudata, policy);
+
+		cpufreq_cpu_release(policy);
+	}
 
-	cpufreq_update_policy(cpudata->cpu);
 	wrmsrl_on_cpu(cpudata->cpu, MSR_HWP_STATUS, 0);
 }
 
-- 
2.34.1



