Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28E712E4122
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:03:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732612AbgL1PDF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:03:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:46920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439929AbgL1OMn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:12:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA9F8206D8;
        Mon, 28 Dec 2020 14:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164748;
        bh=VMKm0JXwNMdwRjR3s4cacDpShKhF+LKcGss1VscGCQ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V3zWYl7u8oC6SSkRUah97Dr9V58rudkslH2oDnxEle0ur8NWKxc64gtkCs3HI6PIH
         lkSasq4ukRPS1Z6Xk1xaJWrbB4BftXWxpvhk7I26d0LsASnbcgzIRGYwh5/qiZ3AMa
         1hVU4nMZ/e6oV7nWjQOWN9WCbAe3W7A1tY4xqZw0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 285/717] clocksource/drivers/orion: Add missing clk_disable_unprepare() on error path
Date:   Mon, 28 Dec 2020 13:44:43 +0100
Message-Id: <20201228125034.682228688@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit c1e6cad00aa2f17845e7270e38ff3cc82c7b022a ]

After calling clk_prepare_enable(), clk_disable_unprepare() need
be called on error path.

Fixes: fbe4b3566ddc ("clocksource/drivers/orion: Convert init function...")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20201111064706.3397156-1-yangyingliang@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/timer-orion.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/clocksource/timer-orion.c b/drivers/clocksource/timer-orion.c
index d01ff41818676..5101e834d78ff 100644
--- a/drivers/clocksource/timer-orion.c
+++ b/drivers/clocksource/timer-orion.c
@@ -143,7 +143,8 @@ static int __init orion_timer_init(struct device_node *np)
 	irq = irq_of_parse_and_map(np, 1);
 	if (irq <= 0) {
 		pr_err("%pOFn: unable to parse timer1 irq\n", np);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto out_unprep_clk;
 	}
 
 	rate = clk_get_rate(clk);
@@ -160,7 +161,7 @@ static int __init orion_timer_init(struct device_node *np)
 				    clocksource_mmio_readl_down);
 	if (ret) {
 		pr_err("Failed to initialize mmio timer\n");
-		return ret;
+		goto out_unprep_clk;
 	}
 
 	sched_clock_register(orion_read_sched_clock, 32, rate);
@@ -170,7 +171,7 @@ static int __init orion_timer_init(struct device_node *np)
 			  "orion_event", NULL);
 	if (ret) {
 		pr_err("%pOFn: unable to setup irq\n", np);
-		return ret;
+		goto out_unprep_clk;
 	}
 
 	ticks_per_jiffy = (clk_get_rate(clk) + HZ/2) / HZ;
@@ -183,5 +184,9 @@ static int __init orion_timer_init(struct device_node *np)
 	orion_delay_timer_init(rate);
 
 	return 0;
+
+out_unprep_clk:
+	clk_disable_unprepare(clk);
+	return ret;
 }
 TIMER_OF_DECLARE(orion_timer, "marvell,orion-timer", orion_timer_init);
-- 
2.27.0



