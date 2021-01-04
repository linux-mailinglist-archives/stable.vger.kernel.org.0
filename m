Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68B442E9856
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 16:22:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727458AbhADPWA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 10:22:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:54976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727403AbhADPV7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 10:21:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 12A9722286;
        Mon,  4 Jan 2021 15:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609773679;
        bh=KnCcCfl5Ujo0xeLkI0m9dHw2QY6hrFRxzWMXtqAvrxY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bls+adfd/7XPttxskOXdd0DZvtCeb+LUIOhIrUhnEaaQmJZthY+QbmtdxKkRyJb+I
         fyHgXJHGiLnaZUPKkncqdC+DMIKr/jmP8HGkD3HF2wIXB/mo5GODrv2rQYXNe5uV8U
         BWsoQIyWNpF+zAhdDTz/OGLrSTmEwEG0azq+cNxd8aR4nQ1bhnobwYe51Z+6dIe9bm
         CZsE1zUXnV7YNIq6PlYZuvRKJfHTUUtKACb8XzOh1bcOi8kIo+ldGmCAd42fEscmhq
         PPrlWy/RTstaGbPRHfRLI3oIp+JL2GvrEneCuzUsFGmnYzF+QpkU5KPoXydmXTHKdR
         KzBWkGcjahvsw==
From:   Frederic Weisbecker <frederic@kernel.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
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
Subject: [PATCH 4/4] ACPI: processor: Fix missing need_resched() check after rcu_idle_enter()
Date:   Mon,  4 Jan 2021 16:20:58 +0100
Message-Id: <20210104152058.36642-5-frederic@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210104152058.36642-1-frederic@kernel.org>
References: <20210104152058.36642-1-frederic@kernel.org>
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

Unfortunately within acpi_idle_enter_bm() the call to rcu_idle_enter()
is already beyond the last generic need_resched() check. The cpu idle
implementation happens to be ok because it ends up calling
mwait_idle_with_hints() or acpi_safe_halt() which both perform their own
need_resched() checks. But the suspend to idle implementation doesn't so
it may suspend the CPU with a resched request unhandled, leaving the
task hanging.

Fix this with performing a last minute need_resched() check after
calling rcu_idle_enter().

Reported-by: Paul E. McKenney <paulmck@kernel.org>
Reviewed-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Fixes: 1fecfdbb7acc (ACPI: processor: Take over RCU-idle for C3-BM idle)
Cc: stable@vger.kernel.org
Cc: Len Brown <lenb@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar<mingo@kernel.org>
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
---
 drivers/acpi/processor_idle.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index d93e400940a3..c4939c49d972 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -604,8 +604,14 @@ static int acpi_idle_enter_bm(struct cpuidle_driver *drv,
 	}
 
 	rcu_idle_enter();
-
-	acpi_idle_do_entry(cx);
+	/*
+	 * Last need_resched() check must come after rcu_idle_enter()
+	 * which may wake up RCU internal tasks. mwait_idle_with_hints()
+	 * and acpi_safe_halt() have their own checks but s2idle
+	 * implementation doesn't.
+	 */
+	if (!need_resched())
+		acpi_idle_do_entry(cx);
 
 	rcu_idle_exit();
 
-- 
2.25.1

