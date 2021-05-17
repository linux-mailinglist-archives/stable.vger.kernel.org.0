Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 135D838386C
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:52:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344063AbhEQPwp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:52:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:46278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242882AbhEQPun (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:50:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D3AB61440;
        Mon, 17 May 2021 14:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262756;
        bh=nr3DIadgRhyKZCDLi1pOFobQNv/FUqmsYyPOqkzvbgY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pjO0G9ffw6HTICxyTs2fAhFawBGjAi6VoSFXQbtEKjNmdsDgWYhMG9SKyitVOdnjy
         5mNg/39lNZfj7y3mKwlxnnVtdgvwpi7pgnZQz/3XHRHaEnbR6D9LjvLQeL2dFWpSQS
         UujB+6IYyuNYyPAhhl56207nxBEwDhkkFOvYibAM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: [PATCH 5.10 269/289] clocksource/drivers/timer-ti-dm: Prepare to handle dra7 timer wrap issue
Date:   Mon, 17 May 2021 16:03:14 +0200
Message-Id: <20210517140314.202256252@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140305.140529752@linuxfoundation.org>
References: <20210517140305.140529752@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

commit 3efe7a878a11c13b5297057bfc1e5639ce1241ce upstream.

There is a timer wrap issue on dra7 for the ARM architected timer.
In a typical clock configuration the timer fails to wrap after 388 days.

To work around the issue, we need to use timer-ti-dm timers instead.

Let's prepare for adding support for percpu timers by adding a common
dmtimer_clkevt_init_common() and call it from dmtimer_clockevent_init().
This patch makes no intentional functional changes.

Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20210323074326.28302-2-tony@atomide.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clocksource/timer-ti-dm-systimer.c |   68 ++++++++++++++++++-----------
 1 file changed, 44 insertions(+), 24 deletions(-)

--- a/drivers/clocksource/timer-ti-dm-systimer.c
+++ b/drivers/clocksource/timer-ti-dm-systimer.c
@@ -530,17 +530,17 @@ static void omap_clockevent_unidle(struc
 	writel_relaxed(OMAP_TIMER_INT_OVERFLOW, t->base + t->wakeup);
 }
 
-static int __init dmtimer_clockevent_init(struct device_node *np)
+static int __init dmtimer_clkevt_init_common(struct dmtimer_clockevent *clkevt,
+					     struct device_node *np,
+					     unsigned int features,
+					     const struct cpumask *cpumask,
+					     const char *name,
+					     int rating)
 {
-	struct dmtimer_clockevent *clkevt;
 	struct clock_event_device *dev;
 	struct dmtimer_systimer *t;
 	int error;
 
-	clkevt = kzalloc(sizeof(*clkevt), GFP_KERNEL);
-	if (!clkevt)
-		return -ENOMEM;
-
 	t = &clkevt->t;
 	dev = &clkevt->dev;
 
@@ -548,25 +548,23 @@ static int __init dmtimer_clockevent_ini
 	 * We mostly use cpuidle_coupled with ARM local timers for runtime,
 	 * so there's probably no use for CLOCK_EVT_FEAT_DYNIRQ here.
 	 */
-	dev->features = CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT;
-	dev->rating = 300;
+	dev->features = features;
+	dev->rating = rating;
 	dev->set_next_event = dmtimer_set_next_event;
 	dev->set_state_shutdown = dmtimer_clockevent_shutdown;
 	dev->set_state_periodic = dmtimer_set_periodic;
 	dev->set_state_oneshot = dmtimer_clockevent_shutdown;
 	dev->set_state_oneshot_stopped = dmtimer_clockevent_shutdown;
 	dev->tick_resume = dmtimer_clockevent_shutdown;
-	dev->cpumask = cpu_possible_mask;
+	dev->cpumask = cpumask;
 
 	dev->irq = irq_of_parse_and_map(np, 0);
-	if (!dev->irq) {
-		error = -ENXIO;
-		goto err_out_free;
-	}
+	if (!dev->irq)
+		return -ENXIO;
 
 	error = dmtimer_systimer_setup(np, &clkevt->t);
 	if (error)
-		goto err_out_free;
+		return error;
 
 	clkevt->period = 0xffffffff - DIV_ROUND_CLOSEST(t->rate, HZ);
 
@@ -578,32 +576,54 @@ static int __init dmtimer_clockevent_ini
 	writel_relaxed(OMAP_TIMER_CTRL_POSTED, t->base + t->ifctrl);
 
 	error = request_irq(dev->irq, dmtimer_clockevent_interrupt,
-			    IRQF_TIMER, "clockevent", clkevt);
+			    IRQF_TIMER, name, clkevt);
 	if (error)
 		goto err_out_unmap;
 
 	writel_relaxed(OMAP_TIMER_INT_OVERFLOW, t->base + t->irq_ena);
 	writel_relaxed(OMAP_TIMER_INT_OVERFLOW, t->base + t->wakeup);
 
-	pr_info("TI gptimer clockevent: %s%lu Hz at %pOF\n",
-		of_find_property(np, "ti,timer-alwon", NULL) ?
+	pr_info("TI gptimer %s: %s%lu Hz at %pOF\n",
+		name, of_find_property(np, "ti,timer-alwon", NULL) ?
 		"always-on " : "", t->rate, np->parent);
 
-	clockevents_config_and_register(dev, t->rate,
-					3, /* Timer internal resynch latency */
+	return 0;
+
+err_out_unmap:
+	iounmap(t->base);
+
+	return error;
+}
+
+static int __init dmtimer_clockevent_init(struct device_node *np)
+{
+	struct dmtimer_clockevent *clkevt;
+	int error;
+
+	clkevt = kzalloc(sizeof(*clkevt), GFP_KERNEL);
+	if (!clkevt)
+		return -ENOMEM;
+
+	error = dmtimer_clkevt_init_common(clkevt, np,
+					   CLOCK_EVT_FEAT_PERIODIC |
+					   CLOCK_EVT_FEAT_ONESHOT,
+					   cpu_possible_mask, "clockevent",
+					   300);
+	if (error)
+		goto err_out_free;
+
+	clockevents_config_and_register(&clkevt->dev, clkevt->t.rate,
+					3, /* Timer internal resync latency */
 					0xffffffff);
 
 	if (of_machine_is_compatible("ti,am33xx") ||
 	    of_machine_is_compatible("ti,am43")) {
-		dev->suspend = omap_clockevent_idle;
-		dev->resume = omap_clockevent_unidle;
+		clkevt->dev.suspend = omap_clockevent_idle;
+		clkevt->dev.resume = omap_clockevent_unidle;
 	}
 
 	return 0;
 
-err_out_unmap:
-	iounmap(t->base);
-
 err_out_free:
 	kfree(clkevt);
 


