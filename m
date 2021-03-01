Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 694B63291FF
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:39:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243400AbhCAUhq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:37:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:49798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241780AbhCAUbP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:31:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C48D64E6F;
        Mon,  1 Mar 2021 18:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614622107;
        bh=jpxoymHzxme65LSRlssx6P1wIZOtog/76A1FPh7PpQI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ydtrz21E3WSHPVABGT2aFnVvPP4TBnA2+eVAhsNTfhYpnfnuZw4xbkIkLM05iBA/u
         F/FnPG4O2oyYr4mNuljGjY3FGgo3LkDwQWx2UeLLv8uJKDfJc2ZcYOrA9vL0TZl1OO
         bAYzQNre0VmY6j+GUh3OGJajAyez649pUuslFXZQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Chen Yu <yu.c.chen@intel.com>
Subject: [PATCH 5.11 729/775] cpufreq: intel_pstate: Change intel_pstate_get_hwp_max() argument
Date:   Mon,  1 Mar 2021 17:14:57 +0100
Message-Id: <20210301161237.360847676@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit a45ee4d4e13b0e35a8ec7ea0bf9267243d57b302 upstream.

All of the callers of intel_pstate_get_hwp_max() access the struct
cpudata object that corresponds to the given CPU already and the
function itself needs to access that object (in order to update
hwp_cap_cached), so modify the code to pass a struct cpudata pointer
to it instead of the CPU number.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Tested-by: Chen Yu <yu.c.chen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/intel_pstate.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -819,13 +819,13 @@ static struct freq_attr *hwp_cpufreq_att
 	NULL,
 };
 
-static void intel_pstate_get_hwp_max(unsigned int cpu, int *phy_max,
+static void intel_pstate_get_hwp_max(struct cpudata *cpu, int *phy_max,
 				     int *current_max)
 {
 	u64 cap;
 
-	rdmsrl_on_cpu(cpu, MSR_HWP_CAPABILITIES, &cap);
-	WRITE_ONCE(all_cpu_data[cpu]->hwp_cap_cached, cap);
+	rdmsrl_on_cpu(cpu->cpu, MSR_HWP_CAPABILITIES, &cap);
+	WRITE_ONCE(cpu->hwp_cap_cached, cap);
 	if (global.no_turbo || global.turbo_disabled)
 		*current_max = HWP_GUARANTEED_PERF(cap);
 	else
@@ -1213,7 +1213,7 @@ static void update_qos_request(enum freq
 			continue;
 
 		if (hwp_active)
-			intel_pstate_get_hwp_max(i, &turbo_max, &max_state);
+			intel_pstate_get_hwp_max(cpu, &turbo_max, &max_state);
 		else
 			turbo_max = cpu->pstate.turbo_pstate;
 
@@ -1723,7 +1723,7 @@ static void intel_pstate_get_cpu_pstates
 	if (hwp_active && !hwp_mode_bdw) {
 		unsigned int phy_max, current_max;
 
-		intel_pstate_get_hwp_max(cpu->cpu, &phy_max, &current_max);
+		intel_pstate_get_hwp_max(cpu, &phy_max, &current_max);
 		cpu->pstate.turbo_freq = phy_max * cpu->pstate.scaling;
 		cpu->pstate.turbo_pstate = phy_max;
 	} else {
@@ -2207,7 +2207,7 @@ static void intel_pstate_update_perf_lim
 	 * rather than pure ratios.
 	 */
 	if (hwp_active) {
-		intel_pstate_get_hwp_max(cpu->cpu, &turbo_max, &max_state);
+		intel_pstate_get_hwp_max(cpu, &turbo_max, &max_state);
 	} else {
 		max_state = global.no_turbo || global.turbo_disabled ?
 			cpu->pstate.max_pstate : cpu->pstate.turbo_pstate;
@@ -2322,7 +2322,7 @@ static void intel_pstate_verify_cpu_poli
 	if (hwp_active) {
 		int max_state, turbo_max;
 
-		intel_pstate_get_hwp_max(cpu->cpu, &turbo_max, &max_state);
+		intel_pstate_get_hwp_max(cpu, &turbo_max, &max_state);
 		max_freq = max_state * cpu->pstate.scaling;
 	} else {
 		max_freq = intel_pstate_get_max_freq(cpu);
@@ -2709,7 +2709,7 @@ static int intel_cpufreq_cpu_init(struct
 	if (hwp_active) {
 		u64 value;
 
-		intel_pstate_get_hwp_max(policy->cpu, &turbo_max, &max_state);
+		intel_pstate_get_hwp_max(cpu, &turbo_max, &max_state);
 		policy->transition_delay_us = INTEL_CPUFREQ_TRANSITION_DELAY_HWP;
 		rdmsrl_on_cpu(cpu->cpu, MSR_HWP_REQUEST, &value);
 		WRITE_ONCE(cpu->hwp_req_cached, value);


