Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EDB32E3B34
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:49:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405584AbgL1NrS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:47:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:48108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405577AbgL1NrR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:47:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E9A6520715;
        Mon, 28 Dec 2020 13:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163220;
        bh=7iq1jFOVbu7dF/nXyYGnkDMfJPURiuAwBZkAmU03LIY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AHx+Izs8tcj1C9pd9nsffR9A5R3rchpANhrdd3y3DilWHRzDcxRhUGqzAJxRFUcLi
         PyVaRs0gUgmG9fkZ/ZlOceJXHOXwiwjsWNzUKRsdlzp//CojwKpeeHJJRldKuUh1Ww
         Zczf3GalahB8KZ3zBHmw7Y1rmCIdyRePp+lp5oH8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 212/453] clocksource/drivers/orion: Add missing clk_disable_unprepare() on error path
Date:   Mon, 28 Dec 2020 13:47:28 +0100
Message-Id: <20201228124947.420945137@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
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
index 7d487107e3cd8..32b2563e2ad1b 100644
--- a/drivers/clocksource/timer-orion.c
+++ b/drivers/clocksource/timer-orion.c
@@ -149,7 +149,8 @@ static int __init orion_timer_init(struct device_node *np)
 	irq = irq_of_parse_and_map(np, 1);
 	if (irq <= 0) {
 		pr_err("%pOFn: unable to parse timer1 irq\n", np);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto out_unprep_clk;
 	}
 
 	rate = clk_get_rate(clk);
@@ -166,7 +167,7 @@ static int __init orion_timer_init(struct device_node *np)
 				    clocksource_mmio_readl_down);
 	if (ret) {
 		pr_err("Failed to initialize mmio timer\n");
-		return ret;
+		goto out_unprep_clk;
 	}
 
 	sched_clock_register(orion_read_sched_clock, 32, rate);
@@ -175,7 +176,7 @@ static int __init orion_timer_init(struct device_node *np)
 	ret = setup_irq(irq, &orion_clkevt_irq);
 	if (ret) {
 		pr_err("%pOFn: unable to setup irq\n", np);
-		return ret;
+		goto out_unprep_clk;
 	}
 
 	ticks_per_jiffy = (clk_get_rate(clk) + HZ/2) / HZ;
@@ -188,5 +189,9 @@ static int __init orion_timer_init(struct device_node *np)
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



