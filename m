Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 042132B63E2
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:42:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387444AbgKQNmd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:42:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:54074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733139AbgKQNlg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:41:36 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF2CD206A5;
        Tue, 17 Nov 2020 13:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620495;
        bh=GgtGBmRD5zRsvFAKCzipREymjz7B4MTRTPo/jOgAYCo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gd2OLuLAumj3QrEEqu4PoZt9sJwiEwZAsQ3vEJAeDffbKOaGIWcAgrJ4p7a4/zOh/
         i6A2Hf+pLhzThwo2QEuWtI1Zu3ip33+F6Fcufn8wzu3pieoCBtEQ6ifZ3VJyE3YJL+
         bxO3UqmrNbJ90ebj4QJjhdn9IUNEOLv2gIh2x4s8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 5.9 238/255] cpufreq: intel_pstate: Take CPUFREQ_GOV_STRICT_TARGET into account
Date:   Tue, 17 Nov 2020 14:06:18 +0100
Message-Id: <20201117122150.520014835@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit fcb3a1ab79904d54499db77017793ccca665eb7e upstream.

Make intel_pstate take the new CPUFREQ_GOV_STRICT_TARGET governor
flag into account when it operates in the passive mode with HWP
enabled, so as to fix the "powersave" governor behavior in that
case (currently, HWP is allowed to scale the performance all the
way up to the policy max limit when the "powersave" governor is
used, but it should be constrained to the policy min limit then).

Fixes: f6ebbcf08f37 ("cpufreq: intel_pstate: Implement passive mode with HWP enabled")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Cc: 5.9+ <stable@vger.kernel.org> # 5.9+: 9a2a9ebc0a75 cpufreq: Introduce governor flags
Cc: 5.9+ <stable@vger.kernel.org> # 5.9+: 218f66870181 cpufreq: Introduce CPUFREQ_GOV_STRICT_TARGET
Cc: 5.9+ <stable@vger.kernel.org> # 5.9+: ea9364bbadf1 cpufreq: Add strict_target to struct cpufreq_policy
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/cpufreq/intel_pstate.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -2509,7 +2509,7 @@ static void intel_cpufreq_trace(struct c
 }
 
 static void intel_cpufreq_adjust_hwp(struct cpudata *cpu, u32 target_pstate,
-				     bool fast_switch)
+				     bool strict, bool fast_switch)
 {
 	u64 prev = READ_ONCE(cpu->hwp_req_cached), value = prev;
 
@@ -2521,7 +2521,7 @@ static void intel_cpufreq_adjust_hwp(str
 	 * field in it, so opportunistically update the max too if needed.
 	 */
 	value &= ~HWP_MAX_PERF(~0L);
-	value |= HWP_MAX_PERF(cpu->max_perf_ratio);
+	value |= HWP_MAX_PERF(strict ? target_pstate : cpu->max_perf_ratio);
 
 	if (value == prev)
 		return;
@@ -2544,14 +2544,16 @@ static void intel_cpufreq_adjust_perf_ct
 			      pstate_funcs.get_val(cpu, target_pstate));
 }
 
-static int intel_cpufreq_update_pstate(struct cpudata *cpu, int target_pstate,
-				       bool fast_switch)
+static int intel_cpufreq_update_pstate(struct cpufreq_policy *policy,
+				       int target_pstate, bool fast_switch)
 {
+	struct cpudata *cpu = all_cpu_data[policy->cpu];
 	int old_pstate = cpu->pstate.current_pstate;
 
 	target_pstate = intel_pstate_prepare_request(cpu, target_pstate);
 	if (hwp_active) {
-		intel_cpufreq_adjust_hwp(cpu, target_pstate, fast_switch);
+		intel_cpufreq_adjust_hwp(cpu, target_pstate,
+					 policy->strict_target, fast_switch);
 		cpu->pstate.current_pstate = target_pstate;
 	} else if (target_pstate != old_pstate) {
 		intel_cpufreq_adjust_perf_ctl(cpu, target_pstate, fast_switch);
@@ -2591,7 +2593,7 @@ static int intel_cpufreq_target(struct c
 		break;
 	}
 
-	target_pstate = intel_cpufreq_update_pstate(cpu, target_pstate, false);
+	target_pstate = intel_cpufreq_update_pstate(policy, target_pstate, false);
 
 	freqs.new = target_pstate * cpu->pstate.scaling;
 
@@ -2610,7 +2612,7 @@ static unsigned int intel_cpufreq_fast_s
 
 	target_pstate = DIV_ROUND_UP(target_freq, cpu->pstate.scaling);
 
-	target_pstate = intel_cpufreq_update_pstate(cpu, target_pstate, true);
+	target_pstate = intel_cpufreq_update_pstate(policy, target_pstate, true);
 
 	return target_pstate * cpu->pstate.scaling;
 }


