Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F360F13E36E
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:02:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388242AbgAPRCC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:02:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:54086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388236AbgAPRCC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:02:02 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 16A0E2081E;
        Thu, 16 Jan 2020 17:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194121;
        bh=vtBZ2hk/fPtWls1UlfVKCCeAAevYCxSfx9KqQnSNZBg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g8VeV2DeBrc6AM50d5bdzvUsFKWt1rlaRH4fdtZPzQQs9GEyexi62U1GiTqtJIFE7
         aCS3MQcQCHN04Y6L3N9wbxn8PaLBYv1mzWPzM4ddiTnu3TJV0u8U0S488tJ6ke7ynK
         oG9NnVGbTJFkZnbMzEPaT7y4614SRMqKZJwVtTag=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chen-Yu Tsai <wens@csie.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 214/671] clocksource/drivers/sun5i: Fail gracefully when clock rate is unavailable
Date:   Thu, 16 Jan 2020 11:52:03 -0500
Message-Id: <20200116165940.10720-97-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165940.10720-1-sashal@kernel.org>
References: <20200116165940.10720-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 3b56ea3f52af..552c5254390c 100644
--- a/drivers/clocksource/timer-sun5i.c
+++ b/drivers/clocksource/timer-sun5i.c
@@ -202,6 +202,11 @@ static int __init sun5i_setup_clocksource(struct device_node *node,
 	}
 
 	rate = clk_get_rate(clk);
+	if (!rate) {
+		pr_err("Couldn't get parent clock rate\n");
+		ret = -EINVAL;
+		goto err_disable_clk;
+	}
 
 	cs->timer.base = base;
 	cs->timer.clk = clk;
@@ -275,6 +280,11 @@ static int __init sun5i_setup_clockevent(struct device_node *node, void __iomem
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

