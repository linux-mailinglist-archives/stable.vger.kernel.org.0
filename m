Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B61B27C6E5
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:49:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731086AbgI2Ltn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:49:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:52938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730290AbgI2Ltb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:49:31 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 363BE206E5;
        Tue, 29 Sep 2020 11:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601380170;
        bh=4/cPjszd6PXUS8KnSkQ7qbtwnVoczKYCPgoQ1nJZGUQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q6VZ29gc97xBWVfKGrEvjTZHHZqnNmc8nJxK2tgAzJE5vmiY6qqm3+LSbq+bk5Tv4
         91jPQM+DmhcAY7E5OpgzbN1VgVwYMYvsuxvF4g+1GVqa1j779BZ6w5CE+IK3W9t6lq
         Ynly3KFlLw+If4MuptVID+csGnHJE26hYFQ2wbz4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "H. Nikolaus Schaller" <hns@goldelico.com>,
        Tony Lindgren <tony@atomide.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 99/99] clocksource/drivers/timer-ti-dm: Do reset before enable
Date:   Tue, 29 Sep 2020 13:02:22 +0200
Message-Id: <20200929105934.608275659@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105929.719230296@linuxfoundation.org>
References: <20200929105929.719230296@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

commit 164805157f3c6834670afbaff563353c773131f1 upstream.

Commit 6cfcd5563b4f ("clocksource/drivers/timer-ti-dm: Fix suspend and
resume for am3 and am4") exposed a new issue for type2 dual mode timers
on at least omap5 where the clockevent will stop when the SoC starts
entering idle states during the boot.

Turns out we are wrongly first enabling the system timer and then
resetting it, while we must also re-enable it after reset. The current
sequence leaves the timer module in a partially initialized state. This
issue went unnoticed earlier with ti-sysc driver reconfiguring the timer
module until we fixed the issue of ti-sysc reconfiguring system timers.

Let's fix the issue by calling dmtimer_systimer_enable() from reset for
both type1 and type2 timers, and switch the order of reset and enable in
dmtimer_systimer_setup(). Let's also move dmtimer_systimer_enable() and
dmtimer_systimer_disable() to do this without adding forward declarations.

Fixes: 6cfcd5563b4f ("clocksource/drivers/timer-ti-dm: Fix suspend and resume for am3 and am4")
Reported-by: H. Nikolaus Schaller <hns@goldelico.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20200817092428.6176-1-tony@atomide.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clocksource/timer-ti-dm-systimer.c |   44 +++++++++++++++--------------
 1 file changed, 23 insertions(+), 21 deletions(-)

--- a/drivers/clocksource/timer-ti-dm-systimer.c
+++ b/drivers/clocksource/timer-ti-dm-systimer.c
@@ -69,12 +69,33 @@ static bool dmtimer_systimer_revision1(s
 	return !(tidr >> 16);
 }
 
+static void dmtimer_systimer_enable(struct dmtimer_systimer *t)
+{
+	u32 val;
+
+	if (dmtimer_systimer_revision1(t))
+		val = DMTIMER_TYPE1_ENABLE;
+	else
+		val = DMTIMER_TYPE2_ENABLE;
+
+	writel_relaxed(val, t->base + t->sysc);
+}
+
+static void dmtimer_systimer_disable(struct dmtimer_systimer *t)
+{
+	if (!dmtimer_systimer_revision1(t))
+		return;
+
+	writel_relaxed(DMTIMER_TYPE1_DISABLE, t->base + t->sysc);
+}
+
 static int __init dmtimer_systimer_type1_reset(struct dmtimer_systimer *t)
 {
 	void __iomem *syss = t->base + OMAP_TIMER_V1_SYS_STAT_OFFSET;
 	int ret;
 	u32 l;
 
+	dmtimer_systimer_enable(t);
 	writel_relaxed(BIT(1) | BIT(2), t->base + t->ifctrl);
 	ret = readl_poll_timeout_atomic(syss, l, l & BIT(0), 100,
 					DMTIMER_RESET_WAIT);
@@ -88,6 +109,7 @@ static int __init dmtimer_systimer_type2
 	void __iomem *sysc = t->base + t->sysc;
 	u32 l;
 
+	dmtimer_systimer_enable(t);
 	l = readl_relaxed(sysc);
 	l |= BIT(0);
 	writel_relaxed(l, sysc);
@@ -336,26 +358,6 @@ static int __init dmtimer_systimer_init_
 	return 0;
 }
 
-static void dmtimer_systimer_enable(struct dmtimer_systimer *t)
-{
-	u32 val;
-
-	if (dmtimer_systimer_revision1(t))
-		val = DMTIMER_TYPE1_ENABLE;
-	else
-		val = DMTIMER_TYPE2_ENABLE;
-
-	writel_relaxed(val, t->base + t->sysc);
-}
-
-static void dmtimer_systimer_disable(struct dmtimer_systimer *t)
-{
-	if (!dmtimer_systimer_revision1(t))
-		return;
-
-	writel_relaxed(DMTIMER_TYPE1_DISABLE, t->base + t->sysc);
-}
-
 static int __init dmtimer_systimer_setup(struct device_node *np,
 					 struct dmtimer_systimer *t)
 {
@@ -409,8 +411,8 @@ static int __init dmtimer_systimer_setup
 	t->wakeup = regbase + _OMAP_TIMER_WAKEUP_EN_OFFSET;
 	t->ifctrl = regbase + _OMAP_TIMER_IF_CTRL_OFFSET;
 
-	dmtimer_systimer_enable(t);
 	dmtimer_systimer_reset(t);
+	dmtimer_systimer_enable(t);
 	pr_debug("dmtimer rev %08x sysc %08x\n", readl_relaxed(t->base),
 		 readl_relaxed(t->base + t->sysc));
 


