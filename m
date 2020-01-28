Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25A9214BB49
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:46:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727517AbgA1OJS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:09:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:57604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728684AbgA1OJR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:09:17 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A9D6724688;
        Tue, 28 Jan 2020 14:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220557;
        bh=O0BSSeKX/FRBdoZ5lblsi6TBdbSq7oNrpxeePRu9H4o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JmXDYOSeyrDSx0cUHrcgige14jRXXcU5jzRF74Pf/EUKk00IxuQvdw/YkrbKTg3HU
         4EHTQC1TCYXt3QdrCLp05DwGIlkXDQaA582ODQZu0D0Vdm5tUZw9w8QX4JG+A8kqMa
         28F7wU5AM4jrE4YpvxQoUDwCKCcsyDwM8vckbnSs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen-Yu Tsai <wens@csie.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 054/183] clocksource/drivers/sun5i: Fail gracefully when clock rate is unavailable
Date:   Tue, 28 Jan 2020 15:04:33 +0100
Message-Id: <20200128135835.285064027@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135829.486060649@linuxfoundation.org>
References: <20200128135829.486060649@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen-Yu Tsai <wens@csie.org>

[ Upstream commit e7e7e0d7beafebd11b0c065cd5fbc1e5759c5aab ]

If the clock tree is not fully populated when the timer-sun5i init code
is called, attempts to get the clock rate for the timer would fail and
return 0.

Make the init code for both clock events and clocksource check the
returned clock rate and fail gracefully if the result is 0, instead of
causing a divide by 0 exception later on.

Fixes: 4a59058f0b09 ("clocksource/drivers/sun5i: Refactor the current code")
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Acked-by: Maxime Ripard <maxime.ripard@bootlin.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/timer-sun5i.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/clocksource/timer-sun5i.c b/drivers/clocksource/timer-sun5i.c
index bca9573e036a7..32b2dab69fd71 100644
--- a/drivers/clocksource/timer-sun5i.c
+++ b/drivers/clocksource/timer-sun5i.c
@@ -201,6 +201,11 @@ static int __init sun5i_setup_clocksource(struct device_node *node,
 	}
 
 	rate = clk_get_rate(clk);
+	if (!rate) {
+		pr_err("Couldn't get parent clock rate\n");
+		ret = -EINVAL;
+		goto err_disable_clk;
+	}
 
 	cs->timer.base = base;
 	cs->timer.clk = clk;
@@ -274,6 +279,11 @@ static int __init sun5i_setup_clockevent(struct device_node *node, void __iomem
 	}
 
 	rate = clk_get_rate(clk);
+	if (!rate) {
+		pr_err("Couldn't get parent clock rate\n");
+		ret = -EINVAL;
+		goto err_disable_clk;
+	}
 
 	ce->timer.base = base;
 	ce->timer.ticks_per_jiffy = DIV_ROUND_UP(rate, HZ);
-- 
2.20.1



