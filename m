Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4531D3C8E4A
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:45:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235270AbhGNTrG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:47:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:38106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235197AbhGNTqN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:46:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 47FAE613E3;
        Wed, 14 Jul 2021 19:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291759;
        bh=MhlHhY1agYYtzBqt09Hw4336F4Nu3+PK1eJjW4GESKE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=naYaRA1jhEsiwtlX/WOl7xtHbKZyKuxt8tQ5cq+hot8+nus+CnwqJRL5osPcK5BnU
         2X2AZTcw6GCiMewLrdFRgPwAD5n9oYCAJiEVrfUZ8exfH1aKeBj4jjWvStvMRjWeBk
         FfbgeTBI5aIWCxcgQNJPNCMqWJEFGU66vNx2x0DEylTiPTmYK7Eq890aFXoJTENAKK
         d1GPVWiUfmdH5eHMsNOoVA0e4m1wEecT61iOR4Cq0rqMnhjpL0KcIKkpeHLoBBV1Ze
         UG+67ID9Wt6IS2AETQfpMYECh4OuG5tEU4ANr/1ljpUEJL/CZpM90kA8O8L3F5S7mX
         zjW0kwMU55K9g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Chunyan Zhang <zhang.lyra@gmail.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 086/102] thermal/drivers/sprd: Add missing of_node_put for loop iteration
Date:   Wed, 14 Jul 2021 15:40:19 -0400
Message-Id: <20210714194036.53141-86-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194036.53141-1-sashal@kernel.org>
References: <20210714194036.53141-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>

[ Upstream commit d8ac5bb4ae653e092d7429a7587b73f1662d6ad7 ]

Early exits from for_each_available_child_of_node() should decrement the
node reference counter.  Reported by Coccinelle:

  drivers/thermal/sprd_thermal.c:387:1-23: WARNING:
    Function "for_each_child_of_node" should have of_node_put() before goto around lines 391.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Acked-by: Chunyan Zhang <zhang.lyra@gmail.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20210614192230.19248-2-krzysztof.kozlowski@canonical.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/sprd_thermal.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/thermal/sprd_thermal.c b/drivers/thermal/sprd_thermal.c
index 3682edb2f466..76a2caa9c265 100644
--- a/drivers/thermal/sprd_thermal.c
+++ b/drivers/thermal/sprd_thermal.c
@@ -388,7 +388,7 @@ static int sprd_thm_probe(struct platform_device *pdev)
 		sen = devm_kzalloc(&pdev->dev, sizeof(*sen), GFP_KERNEL);
 		if (!sen) {
 			ret = -ENOMEM;
-			goto disable_clk;
+			goto of_put;
 		}
 
 		sen->data = thm;
@@ -397,13 +397,13 @@ static int sprd_thm_probe(struct platform_device *pdev)
 		ret = of_property_read_u32(sen_child, "reg", &sen->id);
 		if (ret) {
 			dev_err(&pdev->dev, "get sensor reg failed");
-			goto disable_clk;
+			goto of_put;
 		}
 
 		ret = sprd_thm_sensor_calibration(sen_child, thm, sen);
 		if (ret) {
 			dev_err(&pdev->dev, "efuse cal analysis failed");
-			goto disable_clk;
+			goto of_put;
 		}
 
 		sprd_thm_sensor_init(thm, sen);
@@ -416,19 +416,20 @@ static int sprd_thm_probe(struct platform_device *pdev)
 			dev_err(&pdev->dev, "register thermal zone failed %d\n",
 				sen->id);
 			ret = PTR_ERR(sen->tzd);
-			goto disable_clk;
+			goto of_put;
 		}
 
 		thm->sensor[sen->id] = sen;
 	}
+	/* sen_child set to NULL at this point */
 
 	ret = sprd_thm_set_ready(thm);
 	if (ret)
-		goto disable_clk;
+		goto of_put;
 
 	ret = sprd_thm_wait_temp_ready(thm);
 	if (ret)
-		goto disable_clk;
+		goto of_put;
 
 	for (i = 0; i < thm->nr_sensors; i++)
 		sprd_thm_toggle_sensor(thm->sensor[i], true);
@@ -436,6 +437,8 @@ static int sprd_thm_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, thm);
 	return 0;
 
+of_put:
+	of_node_put(sen_child);
 disable_clk:
 	clk_disable_unprepare(thm->clk);
 	return ret;
-- 
2.30.2

