Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56124CA9DE
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:21:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389286AbfJCRAq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 13:00:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:58038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392807AbfJCQpa (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:45:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CAD86215EA;
        Thu,  3 Oct 2019 16:45:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570121130;
        bh=aRnDWCac5Rp2zw7MueiQHhEBPV+CE2W1Bm3OSFT9eFw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UedKR3l6Y91uVjqxLjyWV2H9tiRm346q+Zyzj9J2kyLK3jNzuvsqf0THf8YSGwX2P
         yw2R62S5KB2jyx/WRdneoBHoDv5RuloSmFAhIfkZGSeTRWFfJlMFX+b7+9dYVmGdr9
         zsSSYENfAXueMIZ0C2i8EKNtRo+AAJB6ijC58MJ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        Dan Murphy <dmurphy@ti.com>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 165/344] leds: lm3532: Fixes for the driver for stability
Date:   Thu,  3 Oct 2019 17:52:10 +0200
Message-Id: <20191003154556.527192344@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
References: <20191003154540.062170222@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



