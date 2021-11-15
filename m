Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3E3E450E5B
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:12:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239647AbhKOSOh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:14:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:49946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236937AbhKOSHj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:07:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A9B656339A;
        Mon, 15 Nov 2021 17:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998309;
        bh=ODDxvufmhbDWUDwtkTzd/xVggoqwjNP9nMsCS/tUN/4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J4yHJBQjaJflJ2rl+gJQ9JT7ZB5VxyoTQJBrmC9ezQlp9TylrrSABNEC9zYpK7Cs3
         FuqKubwA5mO3zOgLFsGGzBLwzOj0uSPAi7MQC2vn/ILVCSmq06/AMES3z2mxYLZEbZ
         wemiAr3yd0kUE8RDGpUOnvNwlypg2k71+gTwvyAQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Richard Fitzgerald <rf@opensource.cirrus.com>,
        Lucas Tanure <tanureal@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 462/575] ASoC: cs42l42: Use device_property API instead of of_property
Date:   Mon, 15 Nov 2021 18:03:07 +0100
Message-Id: <20211115165359.715274090@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit ab78322a0dc8e5e472ff66ac7e18c94acc17587f ]

Use the device_property APIs so that the code will work on devicetree
and ACPI systems.

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Signed-off-by: Lucas Tanure <tanureal@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20210426155303.853236-2-tanureal@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs42l42.c | 60 +++++++++++++++-----------------------
 1 file changed, 24 insertions(+), 36 deletions(-)

diff --git a/sound/soc/codecs/cs42l42.c b/sound/soc/codecs/cs42l42.c
index eb1fcc5be0573..e56d3c9c39756 100644
--- a/sound/soc/codecs/cs42l42.c
+++ b/sound/soc/codecs/cs42l42.c
@@ -20,10 +20,9 @@
 #include <linux/regmap.h>
 #include <linux/slab.h>
 #include <linux/platform_device.h>
+#include <linux/property.h>
 #include <linux/regulator/consumer.h>
 #include <linux/gpio/consumer.h>
-#include <linux/of.h>
-#include <linux/of_gpio.h>
 #include <linux/of_device.h>
 #include <sound/core.h>
 #include <sound/pcm.h>
@@ -1554,17 +1553,15 @@ static const unsigned int threshold_defaults[] = {
 	CS42L42_HS_DET_LEVEL_1
 };
 
-static int cs42l42_handle_device_data(struct i2c_client *i2c_client,
+static int cs42l42_handle_device_data(struct device *dev,
 					struct cs42l42_private *cs42l42)
 {
-	struct device_node *np = i2c_client->dev.of_node;
 	unsigned int val;
-	unsigned int thresholds[CS42L42_NUM_BIASES];
+	u32 thresholds[CS42L42_NUM_BIASES];
 	int ret;
 	int i;
 
-	ret = of_property_read_u32(np, "cirrus,ts-inv", &val);
-
+	ret = device_property_read_u32(dev, "cirrus,ts-inv", &val);
 	if (!ret) {
 		switch (val) {
 		case CS42L42_TS_INV_EN:
@@ -1572,7 +1569,7 @@ static int cs42l42_handle_device_data(struct i2c_client *i2c_client,
 			cs42l42->ts_inv = val;
 			break;
 		default:
-			dev_err(&i2c_client->dev,
+			dev_err(dev,
 				"Wrong cirrus,ts-inv DT value %d\n",
 				val);
 			cs42l42->ts_inv = CS42L42_TS_INV_DIS;
@@ -1585,8 +1582,7 @@ static int cs42l42_handle_device_data(struct i2c_client *i2c_client,
 			CS42L42_TS_INV_MASK,
 			(cs42l42->ts_inv << CS42L42_TS_INV_SHIFT));
 
-	ret = of_property_read_u32(np, "cirrus,ts-dbnc-rise", &val);
-
+	ret = device_property_read_u32(dev, "cirrus,ts-dbnc-rise", &val);
 	if (!ret) {
 		switch (val) {
 		case CS42L42_TS_DBNCE_0:
@@ -1600,7 +1596,7 @@ static int cs42l42_handle_device_data(struct i2c_client *i2c_client,
 			cs42l42->ts_dbnc_rise = val;
 			break;
 		default:
-			dev_err(&i2c_client->dev,
+			dev_err(dev,
 				"Wrong cirrus,ts-dbnc-rise DT value %d\n",
 				val);
 			cs42l42->ts_dbnc_rise = CS42L42_TS_DBNCE_1000;
@@ -1614,8 +1610,7 @@ static int cs42l42_handle_device_data(struct i2c_client *i2c_client,
 			(cs42l42->ts_dbnc_rise <<
 			CS42L42_TS_RISE_DBNCE_TIME_SHIFT));
 
-	ret = of_property_read_u32(np, "cirrus,ts-dbnc-fall", &val);
-
+	ret = device_property_read_u32(dev, "cirrus,ts-dbnc-fall", &val);
 	if (!ret) {
 		switch (val) {
 		case CS42L42_TS_DBNCE_0:
@@ -1629,7 +1624,7 @@ static int cs42l42_handle_device_data(struct i2c_client *i2c_client,
 			cs42l42->ts_dbnc_fall = val;
 			break;
 		default:
-			dev_err(&i2c_client->dev,
+			dev_err(dev,
 				"Wrong cirrus,ts-dbnc-fall DT value %d\n",
 				val);
 			cs42l42->ts_dbnc_fall = CS42L42_TS_DBNCE_0;
@@ -1643,13 +1638,12 @@ static int cs42l42_handle_device_data(struct i2c_client *i2c_client,
 			(cs42l42->ts_dbnc_fall <<
 			CS42L42_TS_FALL_DBNCE_TIME_SHIFT));
 
-	ret = of_property_read_u32(np, "cirrus,btn-det-init-dbnce", &val);
-
+	ret = device_property_read_u32(dev, "cirrus,btn-det-init-dbnce", &val);
 	if (!ret) {
 		if (val <= CS42L42_BTN_DET_INIT_DBNCE_MAX)
 			cs42l42->btn_det_init_dbnce = val;
 		else {
-			dev_err(&i2c_client->dev,
+			dev_err(dev,
 				"Wrong cirrus,btn-det-init-dbnce DT value %d\n",
 				val);
 			cs42l42->btn_det_init_dbnce =
@@ -1660,14 +1654,13 @@ static int cs42l42_handle_device_data(struct i2c_client *i2c_client,
 			CS42L42_BTN_DET_INIT_DBNCE_DEFAULT;
 	}
 
-	ret = of_property_read_u32(np, "cirrus,btn-det-event-dbnce", &val);
-
+	ret = device_property_read_u32(dev, "cirrus,btn-det-event-dbnce", &val);
 	if (!ret) {
 		if (val <= CS42L42_BTN_DET_EVENT_DBNCE_MAX)
 			cs42l42->btn_det_event_dbnce = val;
 		else {
-			dev_err(&i2c_client->dev,
-			"Wrong cirrus,btn-det-event-dbnce DT value %d\n", val);
+			dev_err(dev,
+				"Wrong cirrus,btn-det-event-dbnce DT value %d\n", val);
 			cs42l42->btn_det_event_dbnce =
 				CS42L42_BTN_DET_EVENT_DBNCE_DEFAULT;
 		}
@@ -1676,19 +1669,17 @@ static int cs42l42_handle_device_data(struct i2c_client *i2c_client,
 			CS42L42_BTN_DET_EVENT_DBNCE_DEFAULT;
 	}
 
-	ret = of_property_read_u32_array(np, "cirrus,bias-lvls",
-				   (u32 *)thresholds, CS42L42_NUM_BIASES);
-
+	ret = device_property_read_u32_array(dev, "cirrus,bias-lvls",
+					     thresholds, ARRAY_SIZE(thresholds));
 	if (!ret) {
 		for (i = 0; i < CS42L42_NUM_BIASES; i++) {
 			if (thresholds[i] <= CS42L42_HS_DET_LEVEL_MAX)
 				cs42l42->bias_thresholds[i] = thresholds[i];
 			else {
-				dev_err(&i2c_client->dev,
-				"Wrong cirrus,bias-lvls[%d] DT value %d\n", i,
+				dev_err(dev,
+					"Wrong cirrus,bias-lvls[%d] DT value %d\n", i,
 					thresholds[i]);
-				cs42l42->bias_thresholds[i] =
-					threshold_defaults[i];
+				cs42l42->bias_thresholds[i] = threshold_defaults[i];
 			}
 		}
 	} else {
@@ -1696,8 +1687,7 @@ static int cs42l42_handle_device_data(struct i2c_client *i2c_client,
 			cs42l42->bias_thresholds[i] = threshold_defaults[i];
 	}
 
-	ret = of_property_read_u32(np, "cirrus,hs-bias-ramp-rate", &val);
-
+	ret = device_property_read_u32(dev, "cirrus,hs-bias-ramp-rate", &val);
 	if (!ret) {
 		switch (val) {
 		case CS42L42_HSBIAS_RAMP_FAST_RISE_SLOW_FALL:
@@ -1717,7 +1707,7 @@ static int cs42l42_handle_device_data(struct i2c_client *i2c_client,
 			cs42l42->hs_bias_ramp_time = CS42L42_HSBIAS_RAMP_TIME3;
 			break;
 		default:
-			dev_err(&i2c_client->dev,
+			dev_err(dev,
 				"Wrong cirrus,hs-bias-ramp-rate DT value %d\n",
 				val);
 			cs42l42->hs_bias_ramp_rate = CS42L42_HSBIAS_RAMP_SLOW;
@@ -1848,11 +1838,9 @@ static int cs42l42_i2c_probe(struct i2c_client *i2c_client,
 			(1 << CS42L42_ADC_PDN_SHIFT) |
 			(0 << CS42L42_PDN_ALL_SHIFT));
 
-	if (i2c_client->dev.of_node) {
-		ret = cs42l42_handle_device_data(i2c_client, cs42l42);
-		if (ret != 0)
-			goto err_disable;
-	}
+	ret = cs42l42_handle_device_data(&i2c_client->dev, cs42l42);
+	if (ret != 0)
+		goto err_disable;
 
 	/* Setup headset detection */
 	cs42l42_setup_hs_type_detect(cs42l42);
-- 
2.33.0



