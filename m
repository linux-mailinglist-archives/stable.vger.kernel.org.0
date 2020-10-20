Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87E97283A64
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 17:34:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727293AbgJEPd6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 11:33:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:34208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728210AbgJEPdx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 11:33:53 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D107207BC;
        Mon,  5 Oct 2020 15:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601912033;
        bh=gnFsBKMWFbEWtrezR3gQjFqKb7oCLp1fI/Myh8q4kV8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yGhfidbldlG5ytfoBFPx06SsH/JPTqexrt3v0LtTaVtmv4xKUVuKwexeg8crZId9B
         w296axZFlZ5i5gvxlmei0hi7K3Gjv4TeqHyKnLiooJF4JxR9AF1QO9hSeoUNeazy4C
         9vJL0F3Pp9gf1k9JVffLUuakbo0qlWEG4fgM3d+I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Naresh Kamboju <naresh.kamboju@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 44/85] cpuidle: psci: Fix suspicious RCU usage
Date:   Mon,  5 Oct 2020 17:26:40 +0200
Message-Id: <20201005142116.844451153@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201005142114.732094228@linuxfoundation.org>
References: <20201005142114.732094228@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



