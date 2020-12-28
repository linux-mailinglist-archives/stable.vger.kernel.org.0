Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1C712E4117
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:03:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439307AbgL1PBx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:01:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:47866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440087AbgL1ONL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:13:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5EB2F20731;
        Mon, 28 Dec 2020 14:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164750;
        bh=2absCxdBc9lJty/YezEDc/n0soFzIq7TEMfSH+GwguM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RY7KiiAR+es7yq2TC4/S09i7E7engqzWZpFw6VsA/5RKwAX67b1sB1vQs8GUyer42
         nohnNS6qofLzMqWpyXJByLBooSVjzaLn5sa5JWdYAGFMHcTEP0iSFjlFBBl+/57BGu
         h7mj5wZCfVyolsnHAGbDPyDApsdgQLDlHTdHZgUA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yu Kuai <yukuai3@huawei.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 286/717] clocksource/drivers/cadence_ttc: Fix memory leak in ttc_setup_clockevent()
Date:   Mon, 28 Dec 2020 13:44:44 +0100
Message-Id: <20201228125034.731697892@linuxfoundation.org>
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

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit eee422c46e6840a81c9db18a497b74387a557b29 ]

If clk_notifier_register() failed, ttc_setup_clockevent() will return
without freeing 'ttcce', which will leak memory.

Fixes: 70504f311d4b ("clocksource/drivers/cadence_ttc: Convert init function to return error")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20201116135123.2164033-1-yukuai3@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/timer-cadence-ttc.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/clocksource/timer-cadence-ttc.c b/drivers/clocksource/timer-cadence-ttc.c
index 80e9606020307..4efd0cf3b602d 100644
--- a/drivers/clocksource/timer-cadence-ttc.c
+++ b/drivers/clocksource/timer-cadence-ttc.c
@@ -413,10 +413,8 @@ static int __init ttc_setup_clockevent(struct clk *clk,
 	ttcce->ttc.clk = clk;
 
 	err = clk_prepare_enable(ttcce->ttc.clk);
-	if (err) {
-		kfree(ttcce);
-		return err;
-	}
+	if (err)
+		goto out_kfree;
 
 	ttcce->ttc.clk_rate_change_nb.notifier_call =
 		ttc_rate_change_clockevent_cb;
@@ -426,7 +424,7 @@ static int __init ttc_setup_clockevent(struct clk *clk,
 				    &ttcce->ttc.clk_rate_change_nb);
 	if (err) {
 		pr_warn("Unable to register clock notifier.\n");
-		return err;
+		goto out_kfree;
 	}
 
 	ttcce->ttc.freq = clk_get_rate(ttcce->ttc.clk);
@@ -455,15 +453,17 @@ static int __init ttc_setup_clockevent(struct clk *clk,
 
 	err = request_irq(irq, ttc_clock_event_interrupt,
 			  IRQF_TIMER, ttcce->ce.name, ttcce);
-	if (err) {
-		kfree(ttcce);
-		return err;
-	}
+	if (err)
+		goto out_kfree;
 
 	clockevents_config_and_register(&ttcce->ce,
 			ttcce->ttc.freq / PRESCALE, 1, 0xfffe);
 
 	return 0;
+
+out_kfree:
+	kfree(ttcce);
+	return err;
 }
 
 static int __init ttc_timer_probe(struct platform_device *pdev)
-- 
2.27.0



