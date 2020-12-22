Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A48132E03EA
	for <lists+stable@lfdr.de>; Tue, 22 Dec 2020 02:38:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725899AbgLVBib (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Dec 2020 20:38:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:51782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725782AbgLVBib (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Dec 2020 20:38:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5678C22D2A;
        Tue, 22 Dec 2020 01:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608601070;
        bh=MeYXpqcMTMTSxXo9myNzlaCJWYUZpYsgfWatXDD+ovg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ThaPZomNGCHrdE37arzcq8ZPvosdLLUMzbe25QxLPIlNUhpymz7LdSBOGO1QTPb1D
         6O6oqs5hKQ5h+P+3VLAJQaI/t+G4twIrYcs7Qpjsn/qiA8TF3rLpHDBa6B6La2Eprb
         DDdk1r1AJDI8vmzJQDR9X47VHtzTYyKJFVzk7CEf12tSp+6Iu56Ow1c5Z5cIH7/ic6
         YuIq66cqmO5TnaunxbN18o8XCaf2tqcGP+GSJ06Kartxlu6kZyPgljgvtftKL0MOWW
         HlEEreOf0yiKqGMhO+p0YjQ/1Y0Qvmo3IhrAA575SlazMBChVG/Ek5NXztO1ERv4TF
         ghX+MZG3giDIw==
From:   Frederic Weisbecker <frederic@kernel.org>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Frederic Weisbecker <frederic@kernel.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Fabio Estevam <festevam@gmail.com>, stable@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Len Brown <lenb@kernel.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 3/4] ARM: imx6q: Fix missing need_resched() check after rcu_idle_enter()
Date:   Tue, 22 Dec 2020 02:37:11 +0100
Message-Id: <20201222013712.15056-4-frederic@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201222013712.15056-1-frederic@kernel.org>
References: <20201222013712.15056-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Entering RCU idle mode may cause a deferred wake up of an RCU NOCB_GP
kthread (rcuog) to be serviced.

Usually a wake up happening while running the idle task is spotted in
one of the need_resched() checks carefully placed within the idle loop
that can break to the scheduler.

Unfortunately imx6q_enter_wait() is beyond the last generic
need_resched() check and it performs a wfi right away after the call to
rcu_idle_enter(). We may halt the CPU with a resched request unhandled,
leaving the task hanging.

Fix this with performing a last minute need_resched() check after
calling rcu_idle_enter().

Reported-by: Paul E. McKenney <paulmck@kernel.org>
Fixes: 1a67b9263e06 (ARM: imx6q: Fixup RCU usage for cpuidle)
Cc: stable@vger.kernel.org
Cc: Shawn Guo <shawnguo@kernel.org>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Pengutronix Kernel Team <kernel@pengutronix.de>
Cc: Fabio Estevam <festevam@gmail.com>
Cc: NXP Linux Team <linux-imx@nxp.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
---
 arch/arm/mach-imx/cpuidle-imx6q.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-imx/cpuidle-imx6q.c b/arch/arm/mach-imx/cpuidle-imx6q.c
index 094337dc1bc7..31a60d257d3d 100644
--- a/arch/arm/mach-imx/cpuidle-imx6q.c
+++ b/arch/arm/mach-imx/cpuidle-imx6q.c
@@ -25,7 +25,12 @@ static int imx6q_enter_wait(struct cpuidle_device *dev,
 	raw_spin_unlock(&cpuidle_lock);
 
 	rcu_idle_enter();
-	cpu_do_idle();
+	/*
+	 * Last need_resched() check must come after rcu_idle_enter()
+	 * which may wake up RCU internal tasks.
+	 */
+	if (!need_resched())
+		cpu_do_idle();
 	rcu_idle_exit();
 
 	raw_spin_lock(&cpuidle_lock);
-- 
2.25.1

