Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AB162E3E48
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:27:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503812AbgL1O03 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:26:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:34350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2503736AbgL1O02 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:26:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD20220791;
        Mon, 28 Dec 2020 14:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165548;
        bh=x1C+sd9U7BcgZbl7VcaA0VS0rV5JSsThmUO33qAU6JU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z7FxhCZY2T5upVGKxy5iiafIpIy7cLitEv0haGK+NhaB0wK0nrpE7ANauWhQx1Xqe
         ck6dUT33BJAXPBHmhcScJEOGbntFXRfdz5fAVuoCH1G2issngS0uQmezN0jpHyvTym
         1mKsMurk9Ei7ZARBLR9MylH26vqnjgSXIiM34RUk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.10 570/717] cpufreq: intel_pstate: Use most recent guaranteed performance values
Date:   Mon, 28 Dec 2020 13:49:28 +0100
Message-Id: <20201228125048.223015610@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit e40ad84c26b4deeee46666492ec66b9a534b8e59 upstream.

When turbo has been disabled by the BIOS, but HWP_CAP.GUARANTEED is
changed later, user space may want to take advantage of this increased
guaranteed performance.

HWP_CAP.GUARANTEED is not a static value.  It can be adjusted by an
out-of-band agent or during an Intel Speed Select performance level
change.  The HWP_CAP.MAX is still the maximum achievable performance
with turbo disabled by the BIOS, so HWP_CAP.GUARANTEED can still
change as long as it remains less than or equal to HWP_CAP.MAX.

When HWP_CAP.GUARANTEED is changed, the sysfs base_frequency
attribute shows the most recent guaranteed frequency value. This
attribute can be used by user space software to update the scaling
min/max limits of the CPU.

Currently, the ->setpolicy() callback already uses the latest
HWP_CAP values when setting HWP_REQ, but the ->verify() callback will
restrict the user settings to the to old guaranteed performance value
which prevents user space from making use of the extra CPU capacity
theoretically available to it after increasing HWP_CAP.GUARANTEED.

To address this, read HWP_CAP in intel_pstate_verify_cpu_policy()
to obtain the maximum P-state that can be used and use that to
confine the policy max limit instead of using the cached and
possibly stale pstate.max_freq value for this purpose.

For consistency, update intel_pstate_update_perf_limits() to use the
maximum available P-state returned by intel_pstate_get_hwp_max() to
compute the maximum frequency instead of using the return value of
intel_pstate_get_max_freq() which, again, may be stale.

This issue is a side-effect of fixing the scaling frequency limits in
commit eacc9c5a927e ("cpufreq: intel_pstate: Fix intel_pstate_get_hwp_max()
for turbo disabled") which corrected the setting of the reduced scaling
frequency values, but caused stale HWP_CAP.GUARANTEED to be used in
the case at hand.

Fixes: eacc9c5a927e ("cpufreq: intel_pstate: Fix intel_pstate_get_hwp_max() for turbo disabled")
Reported-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Tested-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: 5.8+ <stable@vger.kernel.org> # 5.8+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/cpufreq/intel_pstate.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -2207,9 +2207,9 @@ static void intel_pstate_update_perf_lim
 					    unsigned int policy_min,
 					    unsigned int policy_max)
 {
-	int max_freq = intel_pstate_get_max_freq(cpu);
 	int32_t max_policy_perf, min_policy_perf;
 	int max_state, turbo_max;
+	int max_freq;
 
 	/*
 	 * HWP needs some special consideration, because on BDX the
@@ -2223,6 +2223,7 @@ static void intel_pstate_update_perf_lim
 			cpu->pstate.max_pstate : cpu->pstate.turbo_pstate;
 		turbo_max = cpu->pstate.turbo_pstate;
 	}
+	max_freq = max_state * cpu->pstate.scaling;
 
 	max_policy_perf = max_state * policy_max / max_freq;
 	if (policy_max == policy_min) {
@@ -2325,9 +2326,18 @@ static void intel_pstate_adjust_policy_m
 static void intel_pstate_verify_cpu_policy(struct cpudata *cpu,
 					   struct cpufreq_policy_data *policy)
 {
+	int max_freq;
+
 	update_turbo_state();
-	cpufreq_verify_within_limits(policy, policy->cpuinfo.min_freq,
-				     intel_pstate_get_max_freq(cpu));
+	if (hwp_active) {
+		int max_state, turbo_max;
+
+		intel_pstate_get_hwp_max(cpu->cpu, &turbo_max, &max_state);
+		max_freq = max_state * cpu->pstate.scaling;
+	} else {
+		max_freq = intel_pstate_get_max_freq(cpu);
+	}
+	cpufreq_verify_within_limits(policy, policy->cpuinfo.min_freq, max_freq);
 
 	intel_pstate_adjust_policy_max(cpu, policy);
 }


