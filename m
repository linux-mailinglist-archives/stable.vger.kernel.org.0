Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 594DD2E1632
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:59:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728943AbgLWCUU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:20:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:45492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728937AbgLWCUU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:20:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 721C222285;
        Wed, 23 Dec 2020 02:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690005;
        bh=9qIZ7qEwWZrzmjNnKLhTBmkGweEftqFRXHnyrccTVI0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gl1NKBarhbL+sbCDiyplJQUNi5h+FpufPC5PvSQLm5Bd6cyitXvNC1zinWtBLQspS
         H7RKdxUZeRqh4qhsRHAdrMswFwpcD5F4lyPsrf/+MnZpvFjDqw5Wqc8GIFMGsaJs3J
         Wxb6IsuueY1uBlsB/0kRoKGOI93Ofd3LsAXY8xdGtip8rEVG2pDd5D9TqUE4w9DF8W
         mEBU1ylXRCQ9EdzkDlamFWNWTMRcgYyx5Z+4RUz3rD6uKouzXtAlz/QgoHlt+s6e/Q
         o7cUa7SX5/1pzfVMrVmpFR4XYpCkLnbfmUN5TZY9cv4RqTHAkhxklCWt78DmclNoT/
         1zfLgiWn4q0BQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dinh Nguyen <dinguyen@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 086/130] clocksource/drivers/dw_apb_timer_of: Add error handling if no clock available
Date:   Tue, 22 Dec 2020 21:17:29 -0500
Message-Id: <20201223021813.2791612-86-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021813.2791612-1-sashal@kernel.org>
References: <20201223021813.2791612-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinh Nguyen <dinguyen@kernel.org>

[ Upstream commit 5d9814df0aec56a638bbf20795abb4cfaf3cd331 ]

commit ("b0fc70ce1f02 arm64: berlin: Select DW_APB_TIMER_OF") added the
support for the dw_apb_timer into the arm64 defconfig. However, for some
platforms like the Intel Stratix10 and Agilex, the clock manager doesn't
get loaded until after the timer driver get loaded. Thus, the driver hits
the panic "No clock nor clock-frequency property for" because it cannot
properly get the clock.

This patch adds the error handling needed for the timer driver so that
the kernel can continue booting instead of just hitting the panic.

Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20201205105223.208604-1-dinguyen@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/dw_apb_timer_of.c | 57 ++++++++++++++++++---------
 1 file changed, 39 insertions(+), 18 deletions(-)

diff --git a/drivers/clocksource/dw_apb_timer_of.c b/drivers/clocksource/dw_apb_timer_of.c
index 6921b91b61ef3..3e8ad6818ff3d 100644
--- a/drivers/clocksource/dw_apb_timer_of.c
+++ b/drivers/clocksource/dw_apb_timer_of.c
@@ -14,12 +14,13 @@
 #include <linux/reset.h>
 #include <linux/sched_clock.h>
 
-static void __init timer_get_base_and_rate(struct device_node *np,
+static int __init timer_get_base_and_rate(struct device_node *np,
 				    void __iomem **base, u32 *rate)
 {
 	struct clk *timer_clk;
 	struct clk *pclk;
 	struct reset_control *rstc;
+	int ret;
 
 	*base = of_iomap(np, 0);
 
@@ -46,55 +47,67 @@ static void __init timer_get_base_and_rate(struct device_node *np,
 			pr_warn("pclk for %pOFn is present, but could not be activated\n",
 				np);
 
+	if (!of_property_read_u32(np, "clock-freq", rate) &&
+	    !of_property_read_u32(np, "clock-frequency", rate))
+		return 0;
+
 	timer_clk = of_clk_get_by_name(np, "timer");
 	if (IS_ERR(timer_clk))
-		goto try_clock_freq;
+		return PTR_ERR(timer_clk);
 
-	if (!clk_prepare_enable(timer_clk)) {
-		*rate = clk_get_rate(timer_clk);
-		return;
-	}
+	ret = clk_prepare_enable(timer_clk);
+	if (ret)
+		return ret;
+
+	*rate = clk_get_rate(timer_clk);
+	if (!(*rate))
+		return -EINVAL;
 
-try_clock_freq:
-	if (of_property_read_u32(np, "clock-freq", rate) &&
-	    of_property_read_u32(np, "clock-frequency", rate))
-		panic("No clock nor clock-frequency property for %pOFn", np);
+	return 0;
 }
 
-static void __init add_clockevent(struct device_node *event_timer)
+static int __init add_clockevent(struct device_node *event_timer)
 {
 	void __iomem *iobase;
 	struct dw_apb_clock_event_device *ced;
 	u32 irq, rate;
+	int ret = 0;
 
 	irq = irq_of_parse_and_map(event_timer, 0);
 	if (irq == 0)
 		panic("No IRQ for clock event timer");
 
-	timer_get_base_and_rate(event_timer, &iobase, &rate);
+	ret = timer_get_base_and_rate(event_timer, &iobase, &rate);
+	if (ret)
+		return ret;
 
 	ced = dw_apb_clockevent_init(0, event_timer->name, 300, iobase, irq,
 				     rate);
 	if (!ced)
-		panic("Unable to initialise clockevent device");
+		return -EINVAL;
 
 	dw_apb_clockevent_register(ced);
+
+	return 0;
 }
 
 static void __iomem *sched_io_base;
 static u32 sched_rate;
 
-static void __init add_clocksource(struct device_node *source_timer)
+static int __init add_clocksource(struct device_node *source_timer)
 {
 	void __iomem *iobase;
 	struct dw_apb_clocksource *cs;
 	u32 rate;
+	int ret;
 
-	timer_get_base_and_rate(source_timer, &iobase, &rate);
+	ret = timer_get_base_and_rate(source_timer, &iobase, &rate);
+	if (ret)
+		return ret;
 
 	cs = dw_apb_clocksource_init(300, source_timer->name, iobase, rate);
 	if (!cs)
-		panic("Unable to initialise clocksource device");
+		return -EINVAL;
 
 	dw_apb_clocksource_start(cs);
 	dw_apb_clocksource_register(cs);
@@ -106,6 +119,8 @@ static void __init add_clocksource(struct device_node *source_timer)
 	 */
 	sched_io_base = iobase + 0x04;
 	sched_rate = rate;
+
+	return 0;
 }
 
 static u64 notrace read_sched_clock(void)
@@ -146,10 +161,14 @@ static struct delay_timer dw_apb_delay_timer = {
 static int num_called;
 static int __init dw_apb_timer_init(struct device_node *timer)
 {
+	int ret = 0;
+
 	switch (num_called) {
 	case 1:
 		pr_debug("%s: found clocksource timer\n", __func__);
-		add_clocksource(timer);
+		ret = add_clocksource(timer);
+		if (ret)
+			return ret;
 		init_sched_clock();
 #ifdef CONFIG_ARM
 		dw_apb_delay_timer.freq = sched_rate;
@@ -158,7 +177,9 @@ static int __init dw_apb_timer_init(struct device_node *timer)
 		break;
 	default:
 		pr_debug("%s: found clockevent timer\n", __func__);
-		add_clockevent(timer);
+		ret = add_clockevent(timer);
+		if (ret)
+			return ret;
 		break;
 	}
 
-- 
2.27.0

