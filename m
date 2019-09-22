Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF32ABA61F
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391043AbfIVSrh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 14:47:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:44058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391028AbfIVSrg (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:47:36 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1196221A4A;
        Sun, 22 Sep 2019 18:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178055;
        bh=aRnDWCac5Rp2zw7MueiQHhEBPV+CE2W1Bm3OSFT9eFw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gb7J6871mN5HRtmpzgBV4vIpBdRF/Si1mraek+wji2wr7MoHD5n7EtsilFJHHvfJt
         1IbtzuXH3WOYCsRqZznuqto5XeW/mxpqfvys4a9B4sC89t1rYcfFImwwXAYzEycPL+
         b1DeACUScqLwuXN0cX0kwOMtUrXtGTEX4oOOkXDw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Murphy <dmurphy@ti.com>, Pavel Machek <pavel@ucw.cz>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-leds@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 132/203] leds: lm3532: Fixes for the driver for stability
Date:   Sun, 22 Sep 2019 14:42:38 -0400
Message-Id: <20190922184350.30563-132-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922184350.30563-1-sashal@kernel.org>
References: <20190922184350.30563-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Murphy <dmurphy@ti.com>

[ Upstream commit 6559ac32998248182572e1ccae79dc2eb40ac7c6 ]

Fixed misspelled words, added error check during probe
on the init of the registers, and fixed ALS/I2C control
mode.

Fixes: bc1b8492c764 ("leds: lm3532: Introduce the lm3532 LED driver")
Reported-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Dan Murphy <dmurphy@ti.com>
Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Jacek Anaszewski <jacek.anaszewski@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/leds-lm3532.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/leds/leds-lm3532.c b/drivers/leds/leds-lm3532.c
index 180895b83b888..e55a64847fe2f 100644
--- a/drivers/leds/leds-lm3532.c
+++ b/drivers/leds/leds-lm3532.c
@@ -40,7 +40,7 @@
 #define LM3532_REG_ZN_3_LO	0x67
 #define LM3532_REG_MAX		0x7e
 
-/* Contorl Enable */
+/* Control Enable */
 #define LM3532_CTRL_A_ENABLE	BIT(0)
 #define LM3532_CTRL_B_ENABLE	BIT(1)
 #define LM3532_CTRL_C_ENABLE	BIT(2)
@@ -302,7 +302,7 @@ static int lm3532_led_disable(struct lm3532_led *led_data)
 	int ret;
 
 	ret = regmap_update_bits(led_data->priv->regmap, LM3532_REG_ENABLE,
-					 ctrl_en_val, ~ctrl_en_val);
+					 ctrl_en_val, 0);
 	if (ret) {
 		dev_err(led_data->priv->dev, "Failed to set ctrl:%d\n", ret);
 		return ret;
@@ -321,7 +321,7 @@ static int lm3532_brightness_set(struct led_classdev *led_cdev,
 
 	mutex_lock(&led->priv->lock);
 
-	if (led->mode == LM3532_BL_MODE_ALS) {
+	if (led->mode == LM3532_ALS_CTRL) {
 		if (brt_val > LED_OFF)
 			ret = lm3532_led_enable(led);
 		else
@@ -542,11 +542,14 @@ static int lm3532_parse_node(struct lm3532_data *priv)
 		}
 
 		if (led->mode == LM3532_BL_MODE_ALS) {
+			led->mode = LM3532_ALS_CTRL;
 			ret = lm3532_parse_als(priv);
 			if (ret)
 				dev_err(&priv->client->dev, "Failed to parse als\n");
 			else
 				lm3532_als_configure(priv, led);
+		} else {
+			led->mode = LM3532_I2C_CTRL;
 		}
 
 		led->num_leds = fwnode_property_read_u32_array(child,
@@ -590,7 +593,13 @@ static int lm3532_parse_node(struct lm3532_data *priv)
 			goto child_out;
 		}
 
-		lm3532_init_registers(led);
+		ret = lm3532_init_registers(led);
+		if (ret) {
+			dev_err(&priv->client->dev, "register init err: %d\n",
+				ret);
+			fwnode_handle_put(child);
+			goto child_out;
+		}
 
 		i++;
 	}
-- 
2.20.1

