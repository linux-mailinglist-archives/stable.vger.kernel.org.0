Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2635A31BCDE
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 16:38:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230503AbhBOPgy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 10:36:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:46856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231196AbhBOPed (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 10:34:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A75661490;
        Mon, 15 Feb 2021 15:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613403082;
        bh=efafAd6WaDg8SGnlqP87Caf8A64qt4Co/sdcXkCnQTM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fw6Jaw7pMDXHh4ayHDH2vED1MzN0YV8mfrBYdX2Fur9hVkcANrGYmLcY+xsTx6Ma1
         rmi6H43PRNuGOCLk3rd3llzkkAPcdeVxH5xEkGCKMd0OiZwfl/h4GCCziugFuyw38d
         pzq0vpWov1yubuYDWMKcxYFRVnhgri00UY1Cmpxk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 020/104] ARM: OMAP2+: Fix suspcious RCU usage splats for omap_enter_idle_coupled
Date:   Mon, 15 Feb 2021 16:26:33 +0100
Message-Id: <20210215152720.133238537@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210215152719.459796636@linuxfoundation.org>
References: <20210215152719.459796636@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit 06862d789ddde8a99c1e579e934ca17c15a84755 ]

We get suspcious RCU usage splats with cpuidle in several places in
omap_enter_idle_coupled() with the kernel debug options enabled:

RCU used illegally from extended quiescent state!
...
(_raw_spin_lock_irqsave)
(omap_enter_idle_coupled+0x17c/0x2d8)
(omap_enter_idle_coupled)
(cpuidle_enter_state)
(cpuidle_enter_state_coupled)
(cpuidle_enter)

Let's use RCU_NONIDLE to suppress these splats. Things got changed around
with commit 1098582a0f6c ("sched,idle,rcu: Push rcu_idle deeper into the
idle path") that started triggering these warnings.

For the tick_broadcast related calls, ideally we'd just switch over to
using CPUIDLE_FLAG_TIMER_STOP for omap_enter_idle_coupled() to have the
generic cpuidle code handle the tick_broadcast related calls for us and
then just drop the tick_broadcast calls here.

But we're currently missing the call in the common cpuidle code for
tick_broadcast_enable() that CPU1 hotplug needs as described in earlier
commit 50d6b3cf9403 ("ARM: OMAP2+: fix lack of timer interrupts on CPU1
after hotplug").

Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Russell King <rmk+kernel@armlinux.org.uk>
Acked-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-omap2/cpuidle44xx.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm/mach-omap2/cpuidle44xx.c b/arch/arm/mach-omap2/cpuidle44xx.c
index c8d317fafe2ea..de37027ad7587 100644
--- a/arch/arm/mach-omap2/cpuidle44xx.c
+++ b/arch/arm/mach-omap2/cpuidle44xx.c
@@ -151,10 +151,10 @@ static int omap_enter_idle_coupled(struct cpuidle_device *dev,
 				 (cx->mpu_logic_state == PWRDM_POWER_OFF);
 
 	/* Enter broadcast mode for periodic timers */
-	tick_broadcast_enable();
+	RCU_NONIDLE(tick_broadcast_enable());
 
 	/* Enter broadcast mode for one-shot timers */
-	tick_broadcast_enter();
+	RCU_NONIDLE(tick_broadcast_enter());
 
 	/*
 	 * Call idle CPU PM enter notifier chain so that
@@ -166,7 +166,7 @@ static int omap_enter_idle_coupled(struct cpuidle_device *dev,
 
 	if (dev->cpu == 0) {
 		pwrdm_set_logic_retst(mpu_pd, cx->mpu_logic_state);
-		omap_set_pwrdm_state(mpu_pd, cx->mpu_state);
+		RCU_NONIDLE(omap_set_pwrdm_state(mpu_pd, cx->mpu_state));
 
 		/*
 		 * Call idle CPU cluster PM enter notifier chain
@@ -178,7 +178,7 @@ static int omap_enter_idle_coupled(struct cpuidle_device *dev,
 				index = 0;
 				cx = state_ptr + index;
 				pwrdm_set_logic_retst(mpu_pd, cx->mpu_logic_state);
-				omap_set_pwrdm_state(mpu_pd, cx->mpu_state);
+				RCU_NONIDLE(omap_set_pwrdm_state(mpu_pd, cx->mpu_state));
 				mpuss_can_lose_context = 0;
 			}
 		}
@@ -194,9 +194,9 @@ static int omap_enter_idle_coupled(struct cpuidle_device *dev,
 		    mpuss_can_lose_context)
 			gic_dist_disable();
 
-		clkdm_deny_idle(cpu_clkdm[1]);
-		omap_set_pwrdm_state(cpu_pd[1], PWRDM_POWER_ON);
-		clkdm_allow_idle(cpu_clkdm[1]);
+		RCU_NONIDLE(clkdm_deny_idle(cpu_clkdm[1]));
+		RCU_NONIDLE(omap_set_pwrdm_state(cpu_pd[1], PWRDM_POWER_ON));
+		RCU_NONIDLE(clkdm_allow_idle(cpu_clkdm[1]));
 
 		if (IS_PM44XX_ERRATUM(PM_OMAP4_ROM_SMP_BOOT_ERRATUM_GICD) &&
 		    mpuss_can_lose_context) {
@@ -222,7 +222,7 @@ static int omap_enter_idle_coupled(struct cpuidle_device *dev,
 	cpu_pm_exit();
 
 cpu_pm_out:
-	tick_broadcast_exit();
+	RCU_NONIDLE(tick_broadcast_exit());
 
 fail:
 	cpuidle_coupled_parallel_barrier(dev, &abort_barrier);
-- 
2.27.0



