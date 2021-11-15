Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0768451E44
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:32:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349593AbhKPAfc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:35:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:45404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344780AbhKOTZ3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1A720632BD;
        Mon, 15 Nov 2021 19:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637003048;
        bh=NC+wzlybJex9g/OS/RAGvYLTo3qb8dDyOL7roQ1BsOU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XVcLim0Ttz/A2prG9+q5aUOet+DIkwR516SC/GyfXWt+Vg7A5mxLDDu29z7Rr3d9j
         +w6jPrOsuQ0Ra+XlynP9JTxHTPFTv7w5Nv0tklvaTHZB7Pj15VGC9UZi+S//YjF4BY
         zFFe82yIV3LKqdtQhD/b2HQoenst4qfGs/FQeKAw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julia Lawall <julia.lawall@inria.fr>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 791/917] cpufreq: intel_pstate: Clear HWP desired on suspend/shutdown and offline
Date:   Mon, 15 Nov 2021 18:04:46 +0100
Message-Id: <20211115165455.783621784@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit dbea75fe18f60e364de6d994fc938a24ba249d81 ]

Commit a365ab6b9dfb ("cpufreq: intel_pstate: Implement the
->adjust_perf() callback") caused intel_pstate to use nonzero HWP
desired values in certain usage scenarios, but it did not prevent
them from being leaked into the confugirations in which HWP desired
is expected to be 0.

The failing scenarios are switching the driver from the passive
mode to the active mode and starting a new kernel via kexec() while
intel_pstate is running in the passive mode.

To address this issue, ensure that HWP desired will be cleared on
offline and suspend/shutdown.

Fixes: a365ab6b9dfb ("cpufreq: intel_pstate: Implement the ->adjust_perf() callback")
Reported-by: Julia Lawall <julia.lawall@inria.fr>
Tested-by: Julia Lawall <julia.lawall@inria.fr>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/intel_pstate.c | 32 ++++++++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index fc7a429f22d33..dafa631582bac 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -999,9 +999,16 @@ static void intel_pstate_hwp_offline(struct cpudata *cpu)
 		 */
 		value &= ~GENMASK_ULL(31, 24);
 		value |= HWP_ENERGY_PERF_PREFERENCE(cpu->epp_cached);
-		WRITE_ONCE(cpu->hwp_req_cached, value);
 	}
 
+	/*
+	 * Clear the desired perf field in the cached HWP request value to
+	 * prevent nonzero desired values from being leaked into the active
+	 * mode.
+	 */
+	value &= ~HWP_DESIRED_PERF(~0L);
+	WRITE_ONCE(cpu->hwp_req_cached, value);
+
 	value &= ~GENMASK_ULL(31, 0);
 	min_perf = HWP_LOWEST_PERF(READ_ONCE(cpu->hwp_cap_cached));
 
@@ -2903,6 +2910,27 @@ static int intel_cpufreq_cpu_exit(struct cpufreq_policy *policy)
 	return intel_pstate_cpu_exit(policy);
 }
 
+static int intel_cpufreq_suspend(struct cpufreq_policy *policy)
+{
+	intel_pstate_suspend(policy);
+
+	if (hwp_active) {
+		struct cpudata *cpu = all_cpu_data[policy->cpu];
+		u64 value = READ_ONCE(cpu->hwp_req_cached);
+
+		/*
+		 * Clear the desired perf field in MSR_HWP_REQUEST in case
+		 * intel_cpufreq_adjust_perf() is in use and the last value
+		 * written by it may not be suitable.
+		 */
+		value &= ~HWP_DESIRED_PERF(~0L);
+		wrmsrl_on_cpu(cpu->cpu, MSR_HWP_REQUEST, value);
+		WRITE_ONCE(cpu->hwp_req_cached, value);
+	}
+
+	return 0;
+}
+
 static struct cpufreq_driver intel_cpufreq = {
 	.flags		= CPUFREQ_CONST_LOOPS,
 	.verify		= intel_cpufreq_verify_policy,
@@ -2912,7 +2940,7 @@ static struct cpufreq_driver intel_cpufreq = {
 	.exit		= intel_cpufreq_cpu_exit,
 	.offline	= intel_cpufreq_cpu_offline,
 	.online		= intel_pstate_cpu_online,
-	.suspend	= intel_pstate_suspend,
+	.suspend	= intel_cpufreq_suspend,
 	.resume		= intel_pstate_resume,
 	.update_limits	= intel_pstate_update_limits,
 	.name		= "intel_cpufreq",
-- 
2.33.0



