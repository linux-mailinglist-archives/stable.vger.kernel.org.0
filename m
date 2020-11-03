Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C8222A5286
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:50:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731857AbgKCUun (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:50:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:45006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731851AbgKCUum (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:50:42 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F7C622404;
        Tue,  3 Nov 2020 20:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436642;
        bh=74KF8pX5Ws56tLv45is/0QJDtB5rGm0h+2J+LFmRumM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AS0kW0iaTbAYSt5ecvAMHbbhN6Ip4XzGGuKUWx2WXD1rG71pOFsvc8pLLjVZj0afH
         XThHHLf7W/66XLcOZvbEDcbwbtoxDmAwu5D5SdbRAGeHe5Kg5r2e5KlkNINt6ktUpV
         Hxph9oIuNk8pDNoP20qvBLMIqKh8z+KWg7zWb9pw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 5.9 338/391] cpufreq: intel_pstate: Avoid missing HWP max updates in passive mode
Date:   Tue,  3 Nov 2020 21:36:29 +0100
Message-Id: <20201103203409.939835927@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit e0be38ed4ab413ddd492118cf146369b86ee0ab5 upstream.

If the cpufreq policy max limit is changed when intel_pstate operates
in the passive mode with HWP enabled and the "powersave" governor is
used on top of it, the HWP max limit is not updated as appropriate.

Namely, in the "powersave" governor case, the target P-state
is always equal to the policy min limit, so if the latter does
not change, intel_cpufreq_adjust_hwp() is not invoked to update
the HWP Request MSR due to the "target_pstate != old_pstate" check
in intel_cpufreq_update_pstate(), so the HWP max limit is not
updated as a result.

Also, if the CPUFREQ_NEED_UPDATE_LIMITS flag is not set for the
driver and the target frequency does not change along with the
policy max limit, the "target_freq == policy->cur" check in
__cpufreq_driver_target() prevents the driver's ->target() callback
from being invoked at all, so the HWP max limit is not updated.

To prevent that occurring, set the CPUFREQ_NEED_UPDATE_LIMITS flag
in the intel_cpufreq driver structure if HWP is enabled and modify
intel_cpufreq_update_pstate() to do the "target_pstate != old_pstate"
check only in the non-HWP case and let intel_cpufreq_adjust_hwp()
always run in the HWP case (it will update HWP Request only if the
cached value of the register is different from the new one including
the limits, so if neither the target P-state value nor the max limit
changes, the register write will still be avoided).

Fixes: f6ebbcf08f37 ("cpufreq: intel_pstate: Implement passive mode with HWP enabled")
Reported-by: Zhang Rui <rui.zhang@intel.com>
Cc: 5.9+ <stable@vger.kernel.org> # 5.9+: 1c534352f47f cpufreq: Introduce CPUFREQ_NEED_UPDATE_LIMITS ...
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Tested-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/cpufreq/intel_pstate.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -2550,14 +2550,12 @@ static int intel_cpufreq_update_pstate(s
 	int old_pstate = cpu->pstate.current_pstate;
 
 	target_pstate = intel_pstate_prepare_request(cpu, target_pstate);
-	if (target_pstate != old_pstate) {
+	if (hwp_active) {
+		intel_cpufreq_adjust_hwp(cpu, target_pstate, fast_switch);
+		cpu->pstate.current_pstate = target_pstate;
+	} else if (target_pstate != old_pstate) {
+		intel_cpufreq_adjust_perf_ctl(cpu, target_pstate, fast_switch);
 		cpu->pstate.current_pstate = target_pstate;
-		if (hwp_active)
-			intel_cpufreq_adjust_hwp(cpu, target_pstate,
-						 fast_switch);
-		else
-			intel_cpufreq_adjust_perf_ctl(cpu, target_pstate,
-						      fast_switch);
 	}
 
 	intel_cpufreq_trace(cpu, fast_switch ? INTEL_PSTATE_TRACE_FAST_SWITCH :
@@ -3014,6 +3012,7 @@ static int __init intel_pstate_init(void
 			hwp_mode_bdw = id->driver_data;
 			intel_pstate.attr = hwp_cpufreq_attrs;
 			intel_cpufreq.attr = hwp_cpufreq_attrs;
+			intel_cpufreq.flags |= CPUFREQ_NEED_UPDATE_LIMITS;
 			if (!default_driver)
 				default_driver = &intel_pstate;
 


