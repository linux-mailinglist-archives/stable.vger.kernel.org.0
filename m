Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F4032E7921
	for <lists+stable@lfdr.de>; Wed, 30 Dec 2020 14:08:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727775AbgL3NGr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Dec 2020 08:06:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:53734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727454AbgL3NF3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Dec 2020 08:05:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DBFF4225AB;
        Wed, 30 Dec 2020 13:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609333478;
        bh=pzRhHs59aiMH3Yt9MNi2DX7MUHYsbgwMmFKqAuHKQ34=;
        h=From:To:Cc:Subject:Date:From;
        b=Fu/f2YlI9K87nEAHK6rTUrGsp813jIlzGz8uf/2guzzncWOZzMrvnmDTZ1I3y0Lv+
         kqO8VAMGwyuBGb2Ynrsw8V7Wt5qsRgmwChODcwpknSfEnNBXmZuRuSSfRaOEcmIYRK
         1ntM6KkvITyYsZJ7Sh/E+lZjBA34Qnh3gs7esQJGl1ZUzhsFbPaQf8XtQjKrBXNokS
         xIo9tnvd+eYs9EQgoVb+syiq+cLikokA6J3nDZO9AD84F9mTXLN+GiSW0LzWaNP0cj
         m+18YEBIIHly2aHPApUYSaPVJtAMwA7xluJKt2Oo1J2p5PpeE54D/kl0JfxyEV+Vii
         xJu/gKCWSy/XA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>, linux-rtc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.14 1/8] rtc: sun6i: Fix memleak in sun6i_rtc_clk_init
Date:   Wed, 30 Dec 2020 08:04:29 -0500
Message-Id: <20201230130436.3637579-1-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit 28d211919e422f58c1e6c900e5810eee4f1ce4c8 ]

When clk_hw_register_fixed_rate_with_accuracy() fails,
clk_data should be freed. It's the same for the subsequent
two error paths, but we should also unregister the already
registered clocks in them.

Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20201020061226.6572-1-dinghao.liu@zju.edu.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-sun6i.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-sun6i.c b/drivers/rtc/rtc-sun6i.c
index 8eb2b6dd36fea..1d0d9c8d0085d 100644
--- a/drivers/rtc/rtc-sun6i.c
+++ b/drivers/rtc/rtc-sun6i.c
@@ -230,7 +230,7 @@ static void __init sun6i_rtc_clk_init(struct device_node *node)
 								300000000);
 	if (IS_ERR(rtc->int_osc)) {
 		pr_crit("Couldn't register the internal oscillator\n");
-		return;
+		goto err;
 	}
 
 	parents[0] = clk_hw_get_name(rtc->int_osc);
@@ -246,7 +246,7 @@ static void __init sun6i_rtc_clk_init(struct device_node *node)
 	rtc->losc = clk_register(NULL, &rtc->hw);
 	if (IS_ERR(rtc->losc)) {
 		pr_crit("Couldn't register the LOSC clock\n");
-		return;
+		goto err_register;
 	}
 
 	of_property_read_string_index(node, "clock-output-names", 1,
@@ -257,7 +257,7 @@ static void __init sun6i_rtc_clk_init(struct device_node *node)
 					  &rtc->lock);
 	if (IS_ERR(rtc->ext_losc)) {
 		pr_crit("Couldn't register the LOSC external gate\n");
-		return;
+		goto err_register;
 	}
 
 	clk_data->num = 2;
@@ -266,6 +266,8 @@ static void __init sun6i_rtc_clk_init(struct device_node *node)
 	of_clk_add_hw_provider(node, of_clk_hw_onecell_get, clk_data);
 	return;
 
+err_register:
+	clk_hw_unregister_fixed_rate(rtc->int_osc);
 err:
 	kfree(clk_data);
 }
-- 
2.27.0

