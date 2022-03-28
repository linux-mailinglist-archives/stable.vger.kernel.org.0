Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE5D14E9327
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 13:18:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240566AbiC1LUT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 07:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230475AbiC1LUR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 07:20:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA6DF5548F;
        Mon, 28 Mar 2022 04:18:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 822F06114A;
        Mon, 28 Mar 2022 11:18:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27C4AC340F3;
        Mon, 28 Mar 2022 11:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648466312;
        bh=PaGBNH3IO+vHhfj5CQrJJiXJVdx0NKXBLXt6WjCBSr8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oz/gj6NMs9h/r5C77B9vRRNH+hKUBXqDVJBrAZizW8fq1IMxo1qex42AwBgcxs0pD
         Ny/Z1ngJv1XRWw02/Z+LFVQTLmU2tDMHojbLniUnOSEY6Qj3ZHXwPsmx+K4534N/fW
         3aKkXC4WrehmDO1vfGkq5+ToOZ9Tyc10J3lLHKGD2xpKjPk5sFUuoJnIVpKPuewmj5
         7/IRwxNajlmB/oambdEkXLcV0ePjoMek3BRHrbcKt/Urc5o0aIMgpoagvDoMulCIDn
         AbRQwnGuo/NV8ncePf9TAb+fGlCySD82NVyJRW5DSbtHdPczqOk+ahIi2uwpiTYVob
         O3tL/tIFzJdUw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dave Stevenson <dave.stevenson@raspberrypi.com>,
        Detlev Casanova <detlev.casanova@collabora.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com
Subject: [PATCH AUTOSEL 5.17 02/43] regulator: rpi-panel: Handle I2C errors/timing to the Atmel
Date:   Mon, 28 Mar 2022 07:17:46 -0400
Message-Id: <20220328111828.1554086-2-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220328111828.1554086-1-sashal@kernel.org>
References: <20220328111828.1554086-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Stevenson <dave.stevenson@raspberrypi.com>

[ Upstream commit 5665eee7a3800430e7dc3ef6f25722476b603186 ]

The Atmel is doing some things in the I2C ISR, during which
period it will not respond to further commands. This is
particularly true of the POWERON command.

Increase delays appropriately, and retry should I2C errors be
reported.

Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Signed-off-by: Detlev Casanova <detlev.casanova@collabora.com>
Link: https://lore.kernel.org/r/20220124220129.158891-3-detlev.casanova@collabora.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../regulator/rpi-panel-attiny-regulator.c    | 56 +++++++++++++++----
 1 file changed, 46 insertions(+), 10 deletions(-)

diff --git a/drivers/regulator/rpi-panel-attiny-regulator.c b/drivers/regulator/rpi-panel-attiny-regulator.c
index ee46bfbf5eee..991b4730d768 100644
--- a/drivers/regulator/rpi-panel-attiny-regulator.c
+++ b/drivers/regulator/rpi-panel-attiny-regulator.c
@@ -37,11 +37,24 @@ static const struct regmap_config attiny_regmap_config = {
 static int attiny_lcd_power_enable(struct regulator_dev *rdev)
 {
 	unsigned int data;
+	int ret, i;
 
 	regmap_write(rdev->regmap, REG_POWERON, 1);
+	msleep(80);
+
 	/* Wait for nPWRDWN to go low to indicate poweron is done. */
-	regmap_read_poll_timeout(rdev->regmap, REG_PORTB, data,
-					data & BIT(0), 10, 1000000);
+	for (i = 0; i < 20; i++) {
+		ret = regmap_read(rdev->regmap, REG_PORTB, &data);
+		if (!ret) {
+			if (data & BIT(0))
+				break;
+		}
+		usleep_range(10000, 12000);
+	}
+	usleep_range(10000, 12000);
+
+	if (ret)
+		pr_err("%s: regmap_read_poll_timeout failed %d\n", __func__, ret);
 
 	/* Default to the same orientation as the closed source
 	 * firmware used for the panel.  Runtime rotation
@@ -57,23 +70,34 @@ static int attiny_lcd_power_disable(struct regulator_dev *rdev)
 {
 	regmap_write(rdev->regmap, REG_PWM, 0);
 	regmap_write(rdev->regmap, REG_POWERON, 0);
-	udelay(1);
+	msleep(30);
 	return 0;
 }
 
 static int attiny_lcd_power_is_enabled(struct regulator_dev *rdev)
 {
 	unsigned int data;
-	int ret;
+	int ret, i;
 
-	ret = regmap_read(rdev->regmap, REG_POWERON, &data);
+	for (i = 0; i < 10; i++) {
+		ret = regmap_read(rdev->regmap, REG_POWERON, &data);
+		if (!ret)
+			break;
+		usleep_range(10000, 12000);
+	}
 	if (ret < 0)
 		return ret;
 
 	if (!(data & BIT(0)))
 		return 0;
 
-	ret = regmap_read(rdev->regmap, REG_PORTB, &data);
+	for (i = 0; i < 10; i++) {
+		ret = regmap_read(rdev->regmap, REG_PORTB, &data);
+		if (!ret)
+			break;
+		usleep_range(10000, 12000);
+	}
+
 	if (ret < 0)
 		return ret;
 
@@ -103,20 +127,32 @@ static int attiny_update_status(struct backlight_device *bl)
 {
 	struct regmap *regmap = bl_get_data(bl);
 	int brightness = bl->props.brightness;
+	int ret, i;
 
 	if (bl->props.power != FB_BLANK_UNBLANK ||
 	    bl->props.fb_blank != FB_BLANK_UNBLANK)
 		brightness = 0;
 
-	return regmap_write(regmap, REG_PWM, brightness);
+	for (i = 0; i < 10; i++) {
+		ret = regmap_write(regmap, REG_PWM, brightness);
+		if (!ret)
+			break;
+	}
+
+	return ret;
 }
 
 static int attiny_get_brightness(struct backlight_device *bl)
 {
 	struct regmap *regmap = bl_get_data(bl);
-	int ret, brightness;
+	int ret, brightness, i;
+
+	for (i = 0; i < 10; i++) {
+		ret = regmap_read(regmap, REG_PWM, &brightness);
+		if (!ret)
+			break;
+	}
 
-	ret = regmap_read(regmap, REG_PWM, &brightness);
 	if (ret)
 		return ret;
 
@@ -166,7 +202,7 @@ static int attiny_i2c_probe(struct i2c_client *i2c,
 	}
 
 	regmap_write(regmap, REG_POWERON, 0);
-	mdelay(1);
+	msleep(30);
 
 	config.dev = &i2c->dev;
 	config.regmap = regmap;
-- 
2.34.1

