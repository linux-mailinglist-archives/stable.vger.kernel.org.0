Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EDD927BA18
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 03:36:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727468AbgI2Ba7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Sep 2020 21:30:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:40028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727454AbgI2Ba6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Sep 2020 21:30:58 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A36721734;
        Tue, 29 Sep 2020 01:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601343057;
        bh=gnFsBKMWFbEWtrezR3gQjFqKb7oCLp1fI/Myh8q4kV8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OWK4TqNu9F/urENUWFW36x5mfLZzIstOI0lfQhZ2ZG8NlCgrHDwXJzB2IAoMHi6Lv
         0w0k4SbEPpgJ+Y8dr+BESS2s5EjBEd/Kwip67lXgap9DL3+Rbmfetl6gc2AJg3PlIR
         Ag0ntZP6D9xwJkY3ytTwm8WZ38O+ze/EfpRmAgVs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ulf Hansson <ulf.hansson@linaro.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.8 23/29] cpuidle: psci: Fix suspicious RCU usage
Date:   Mon, 28 Sep 2020 21:30:20 -0400
Message-Id: <20200929013027.2406344-23-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200929013027.2406344-1-sashal@kernel.org>
References: <20200929013027.2406344-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ulf Hansson <ulf.hansson@linaro.org>

[ Upstream commit 36050d8984ab743f9990a2eb97a0062fdc3d7bbd ]

The commit eb1f00237aca ("lockdep,trace: Expose tracepoints"), started to
expose us for tracepoints. This lead to the following RCU splat on an ARM64
Qcom board.

[    5.529634] WARNING: suspicious RCU usage
[    5.537307] sdhci-pltfm: SDHCI platform and OF driver helper
[    5.541092] 5.9.0-rc3 #86 Not tainted
[    5.541098] -----------------------------
[    5.541105] ../include/trace/events/lock.h:37 suspicious rcu_dereference_check() usage!
[    5.541110]
[    5.541110] other info that might help us debug this:
[    5.541110]
[    5.541116]
[    5.541116] rcu_scheduler_active = 2, debug_locks = 1
[    5.541122] RCU used illegally from extended quiescent state!
[    5.541129] no locks held by swapper/0/0.
[    5.541134]
[    5.541134] stack backtrace:
[    5.541143] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.9.0-rc3 #86
[    5.541149] Hardware name: Qualcomm Technologies, Inc. APQ 8016 SBC (DT)
[    5.541157] Call trace:
[    5.568185] sdhci_msm 7864900.sdhci: Got CD GPIO
[    5.574186]  dump_backtrace+0x0/0x1c8
[    5.574206]  show_stack+0x14/0x20
[    5.574229]  dump_stack+0xe8/0x154
[    5.574250]  lockdep_rcu_suspicious+0xd4/0xf8
[    5.574269]  lock_acquire+0x3f0/0x460
[    5.574292]  _raw_spin_lock_irqsave+0x80/0xb0
[    5.574314]  __pm_runtime_suspend+0x4c/0x188
[    5.574341]  psci_enter_domain_idle_state+0x40/0xa0
[    5.574362]  cpuidle_enter_state+0xc0/0x610
[    5.646487]  cpuidle_enter+0x38/0x50
[    5.650651]  call_cpuidle+0x18/0x40
[    5.654467]  do_idle+0x228/0x278
[    5.657678]  cpu_startup_entry+0x24/0x70
[    5.661153]  rest_init+0x1a4/0x278
[    5.665061]  arch_call_rest_init+0xc/0x14
[    5.668272]  start_kernel+0x508/0x540

Following the path in pm_runtime_put_sync_suspend() from
psci_enter_domain_idle_state(), it seems like we end up using the RCU.
Therefore, let's simply silence the splat by informing the RCU about it
with RCU_NONIDLE.

Note that, this is a temporary solution. Instead we should strive to avoid
using RCU_NONIDLE (and similar), but rather push rcu_idle_enter|exit()
further down, closer to the arch specific code. However, as the CPU PM
notifiers are also using the RCU, additional rework is needed.

Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Acked-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpuidle/cpuidle-psci.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/cpuidle/cpuidle-psci.c b/drivers/cpuidle/cpuidle-psci.c
index 3806f911b61c0..915172e3ec906 100644
--- a/drivers/cpuidle/cpuidle-psci.c
+++ b/drivers/cpuidle/cpuidle-psci.c
@@ -64,7 +64,7 @@ static int psci_enter_domain_idle_state(struct cpuidle_device *dev,
 		return -1;
 
 	/* Do runtime PM to manage a hierarchical CPU toplogy. */
-	pm_runtime_put_sync_suspend(pd_dev);
+	RCU_NONIDLE(pm_runtime_put_sync_suspend(pd_dev));
 
 	state = psci_get_domain_state();
 	if (!state)
@@ -72,7 +72,7 @@ static int psci_enter_domain_idle_state(struct cpuidle_device *dev,
 
 	ret = psci_cpu_suspend_enter(state) ? -1 : idx;
 
-	pm_runtime_get_sync(pd_dev);
+	RCU_NONIDLE(pm_runtime_get_sync(pd_dev));
 
 	cpu_pm_exit();
 
-- 
2.25.1

