Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16DC1491782
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:42:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240249AbiARCmG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:42:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345445AbiARCbd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:31:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51F8FC08C5FE;
        Mon, 17 Jan 2022 18:29:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E3D4E611E1;
        Tue, 18 Jan 2022 02:29:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72B2FC36AE3;
        Tue, 18 Jan 2022 02:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472953;
        bh=f+dbat/CJSJVFyT6hmh4BxcsvT3LVH/CfNKQCr+Nvgg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d4nnVjMdm8Wf5XtFBX478voeqxv3e4yeXWmZwjSGRIVuSSVUkdWi8M6PJKszoyj57
         UK3cBJ8O5O6XvYjOG0sk22fdcLItk8csT+sAOpmhJvCy7yQnQTl8POLTi/sXsl31CZ
         9yg2/6AyVLMan4+GfrzKi7QHn9IqDjxJbWEaGrTVAT0KqAxFctFyz1hS/g1ZQYB9Vf
         hNNshFck4LiA/qLMP59L/zXdKTF+lidx+T7Y3nd2QwesWMl97lLszoXTWJ83TE5ISg
         Fx6ZoPBD99QwQDcby0rFuE3fmHHNP7iwgWG1WUBeRVL8NDzrUem+hsZKwUG2hFxh+o
         weYy8Uv7SK8wQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>, lenb@kernel.org,
        rafael@kernel.org, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 174/217] cpufreq: intel_pstate: Update cpuinfo.max_freq on HWP_CAP changes
Date:   Mon, 17 Jan 2022 21:18:57 -0500
Message-Id: <20220118021940.1942199-174-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

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

