Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA93D37CC44
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:03:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233598AbhELQnq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:43:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:57038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243136AbhELQgw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:36:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E3E761E0B;
        Wed, 12 May 2021 16:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835258;
        bh=iskjLq3stQY6pW14znA3uT5yirChRDox2RZ7J4dGAQU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ug3YRo8tWREHR46jx65ok4bx2CzCjqo+/SSviqb3dLSzfYDtcDjer8wETH+KHJ6Oq
         CN9cD9p3mrVV3JelPn9p7YirMCCfoCvrBilXuiNkZxMgGz67nSIVKUjI8rEkY+SUtT
         P7jHtIhGYkgidoThmxdULdj4OkIWRMyYAc3WXbX8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 272/677] clocksource/drivers/timer-ti-dm: Fix posted mode status check order
Date:   Wed, 12 May 2021 16:45:18 +0200
Message-Id: <20210512144846.261072130@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit 212709926c5493a566ca4086ad4f4b0d4e66b553 ]

When the timer is configured in posted mode, we need to check the write-
posted status register (TWPS) before writing to the register.

We now check TWPS after the write starting with commit 52762fbd1c47
("clocksource/drivers/timer-ti-dm: Add clockevent and clocksource
support").

For example, in the TRM for am571x the following is documented in chapter
"22.2.4.13.1.1 Write Posting Synchronization Mode":

"For each register, a status bit is provided in the timer write-posted
 status (TWPS) register. In this mode, it is mandatory that software check
 this status bit before any write access. If a write is attempted to a
 register with a previous access pending, the previous access is discarded
 without notice."

The regression happened when I updated the code to use standard read/write
accessors for the driver instead of using __omap_dm_timer_load_start().
We have__omap_dm_timer_load_start() check the TWPS status correctly using
__omap_dm_timer_write().

Fixes: 52762fbd1c47 ("clocksource/drivers/timer-ti-dm: Add clockevent and clocksource support")
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20210304072135.52712-2-tony@atomide.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/timer-ti-dm-systimer.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/clocksource/timer-ti-dm-systimer.c b/drivers/clocksource/timer-ti-dm-systimer.c
index 33b3e8aa2cc5..422376680c8a 100644
--- a/drivers/clocksource/timer-ti-dm-systimer.c
+++ b/drivers/clocksource/timer-ti-dm-systimer.c
@@ -449,13 +449,13 @@ static int dmtimer_set_next_event(unsigned long cycles,
 	struct dmtimer_systimer *t = &clkevt->t;
 	void __iomem *pend = t->base + t->pend;
 
-	writel_relaxed(0xffffffff - cycles, t->base + t->counter);
 	while (readl_relaxed(pend) & WP_TCRR)
 		cpu_relax();
+	writel_relaxed(0xffffffff - cycles, t->base + t->counter);
 
-	writel_relaxed(OMAP_TIMER_CTRL_ST, t->base + t->ctrl);
 	while (readl_relaxed(pend) & WP_TCLR)
 		cpu_relax();
+	writel_relaxed(OMAP_TIMER_CTRL_ST, t->base + t->ctrl);
 
 	return 0;
 }
@@ -490,18 +490,18 @@ static int dmtimer_set_periodic(struct clock_event_device *evt)
 	dmtimer_clockevent_shutdown(evt);
 
 	/* Looks like we need to first set the load value separately */
-	writel_relaxed(clkevt->period, t->base + t->load);
 	while (readl_relaxed(pend) & WP_TLDR)
 		cpu_relax();
+	writel_relaxed(clkevt->period, t->base + t->load);
 
-	writel_relaxed(clkevt->period, t->base + t->counter);
 	while (readl_relaxed(pend) & WP_TCRR)
 		cpu_relax();
+	writel_relaxed(clkevt->period, t->base + t->counter);
 
-	writel_relaxed(OMAP_TIMER_CTRL_AR | OMAP_TIMER_CTRL_ST,
-		       t->base + t->ctrl);
 	while (readl_relaxed(pend) & WP_TCLR)
 		cpu_relax();
+	writel_relaxed(OMAP_TIMER_CTRL_AR | OMAP_TIMER_CTRL_ST,
+		       t->base + t->ctrl);
 
 	return 0;
 }
-- 
2.30.2



