Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F70F3C4786
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:27:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236483AbhGLGdP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:33:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:46964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235730AbhGLG3a (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:29:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3EAEC61106;
        Mon, 12 Jul 2021 06:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071144;
        bh=0XJpd/lT5IcPhXi1761fwtQtP6M3XAB+ne9OuA0ULrE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z9EP3OMwJkkWBX2/8b/N1g9v6LXroNnnr6wjcW9BlPJYiQsZ8FPtC3gdwtEf4FGlS
         rGDWZ36+e0ksqczL/mHm1DFCbjy14yl/cv6dySIws4R21PHP/fwWFD08yIqr5caBLW
         2s1jz6l9v+FtNUpwSwHgGxI83QYFpVX4CYhLHwBY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>,
        Dan Murphy <dmurphy@ti.com>, Pavel Machek <pavel@ucw.cz>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 292/348] leds: lm36274: cosmetic: rename lm36274_data to chip
Date:   Mon, 12 Jul 2021 08:11:16 +0200
Message-Id: <20210712060742.404730057@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Behún <marek.behun@nic.cz>

[ Upstream commit d3ab963cf980151f5f0ba16d842ddc80b232d9c0 ]

Rename this variable so that it is easier to read and easier to write in
80 columns. Also rename variable of this type in lm36274_brightness_set
from led to chip, to be consistent.

Signed-off-by: Marek Behún <marek.behun@nic.cz>
Tested-by: Dan Murphy <dmurphy@ti.com>
Signed-off-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/leds-lm36274.c | 82 ++++++++++++++++++-------------------
 1 file changed, 40 insertions(+), 42 deletions(-)

diff --git a/drivers/leds/leds-lm36274.c b/drivers/leds/leds-lm36274.c
index db842eeb7ca2..6c143551f10a 100644
--- a/drivers/leds/leds-lm36274.c
+++ b/drivers/leds/leds-lm36274.c
@@ -41,37 +41,36 @@ struct lm36274 {
 };
 
 static int lm36274_brightness_set(struct led_classdev *led_cdev,
-				enum led_brightness brt_val)
+				  enum led_brightness brt_val)
 {
-	struct lm36274 *led = container_of(led_cdev, struct lm36274, led_dev);
+	struct lm36274 *chip = container_of(led_cdev, struct lm36274, led_dev);
 
-	return ti_lmu_common_set_brightness(&led->lmu_data, brt_val);
+	return ti_lmu_common_set_brightness(&chip->lmu_data, brt_val);
 }
 
-static int lm36274_init(struct lm36274 *lm36274_data)
+static int lm36274_init(struct lm36274 *chip)
 {
 	int enable_val = 0;
 	int i;
 
-	for (i = 0; i < lm36274_data->num_leds; i++)
-		enable_val |= (1 << lm36274_data->led_sources[i]);
+	for (i = 0; i < chip->num_leds; i++)
+		enable_val |= (1 << chip->led_sources[i]);
 
 	if (!enable_val) {
-		dev_err(lm36274_data->dev, "No LEDs were enabled\n");
+		dev_err(chip->dev, "No LEDs were enabled\n");
 		return -EINVAL;
 	}
 
 	enable_val |= LM36274_BL_EN;
 
-	return regmap_write(lm36274_data->regmap, LM36274_REG_BL_EN,
-			    enable_val);
+	return regmap_write(chip->regmap, LM36274_REG_BL_EN, enable_val);
 }
 
-static int lm36274_parse_dt(struct lm36274 *lm36274_data)
+static int lm36274_parse_dt(struct lm36274 *chip)
 {
 	struct fwnode_handle *child = NULL;
 	char label[LED_MAX_NAME_SIZE];
-	struct device *dev = &lm36274_data->pdev->dev;
+	struct device *dev = &chip->pdev->dev;
 	const char *name;
 	int child_cnt;
 	int ret = -EINVAL;
@@ -84,37 +83,37 @@ static int lm36274_parse_dt(struct lm36274 *lm36274_data)
 	device_for_each_child_node(dev, child) {
 		ret = fwnode_property_read_string(child, "label", &name);
 		if (ret)
-			snprintf(label, sizeof(label),
-				"%s::", lm36274_data->pdev->name);
+			snprintf(label, sizeof(label), "%s::",
+				 chip->pdev->name);
 		else
-			snprintf(label, sizeof(label),
-				 "%s:%s", lm36274_data->pdev->name, name);
+			snprintf(label, sizeof(label), "%s:%s",
+				 chip->pdev->name, name);
 
-		lm36274_data->num_leds = fwnode_property_count_u32(child, "led-sources");
-		if (lm36274_data->num_leds <= 0)
+		chip->num_leds = fwnode_property_count_u32(child, "led-sources");
+		if (chip->num_leds <= 0)
 			return -ENODEV;
 
 		ret = fwnode_property_read_u32_array(child, "led-sources",
-						     lm36274_data->led_sources,
-						     lm36274_data->num_leds);
+						     chip->led_sources,
+						     chip->num_leds);
 		if (ret) {
 			dev_err(dev, "led-sources property missing\n");
 			return ret;
 		}
 
 		fwnode_property_read_string(child, "linux,default-trigger",
-					&lm36274_data->led_dev.default_trigger);
+					    &chip->led_dev.default_trigger);
 
 	}
 
-	lm36274_data->lmu_data.regmap = lm36274_data->regmap;
-	lm36274_data->lmu_data.max_brightness = MAX_BRIGHTNESS_11BIT;
-	lm36274_data->lmu_data.msb_brightness_reg = LM36274_REG_BRT_MSB;
-	lm36274_data->lmu_data.lsb_brightness_reg = LM36274_REG_BRT_LSB;
+	chip->lmu_data.regmap = chip->regmap;
+	chip->lmu_data.max_brightness = MAX_BRIGHTNESS_11BIT;
+	chip->lmu_data.msb_brightness_reg = LM36274_REG_BRT_MSB;
+	chip->lmu_data.lsb_brightness_reg = LM36274_REG_BRT_LSB;
 
-	lm36274_data->led_dev.name = label;
-	lm36274_data->led_dev.max_brightness = MAX_BRIGHTNESS_11BIT;
-	lm36274_data->led_dev.brightness_set_blocking = lm36274_brightness_set;
+	chip->led_dev.name = label;
+	chip->led_dev.max_brightness = MAX_BRIGHTNESS_11BIT;
+	chip->led_dev.brightness_set_blocking = lm36274_brightness_set;
 
 	return 0;
 }
@@ -122,39 +121,38 @@ static int lm36274_parse_dt(struct lm36274 *lm36274_data)
 static int lm36274_probe(struct platform_device *pdev)
 {
 	struct ti_lmu *lmu = dev_get_drvdata(pdev->dev.parent);
-	struct lm36274 *lm36274_data;
+	struct lm36274 *chip;
 	int ret;
 
-	lm36274_data = devm_kzalloc(&pdev->dev, sizeof(*lm36274_data),
-				    GFP_KERNEL);
-	if (!lm36274_data)
+	chip = devm_kzalloc(&pdev->dev, sizeof(*chip), GFP_KERNEL);
+	if (!chip)
 		return -ENOMEM;
 
-	lm36274_data->pdev = pdev;
-	lm36274_data->dev = lmu->dev;
-	lm36274_data->regmap = lmu->regmap;
-	platform_set_drvdata(pdev, lm36274_data);
+	chip->pdev = pdev;
+	chip->dev = lmu->dev;
+	chip->regmap = lmu->regmap;
+	platform_set_drvdata(pdev, chip);
 
-	ret = lm36274_parse_dt(lm36274_data);
+	ret = lm36274_parse_dt(chip);
 	if (ret) {
-		dev_err(lm36274_data->dev, "Failed to parse DT node\n");
+		dev_err(chip->dev, "Failed to parse DT node\n");
 		return ret;
 	}
 
-	ret = lm36274_init(lm36274_data);
+	ret = lm36274_init(chip);
 	if (ret) {
-		dev_err(lm36274_data->dev, "Failed to init the device\n");
+		dev_err(chip->dev, "Failed to init the device\n");
 		return ret;
 	}
 
-	return led_classdev_register(lm36274_data->dev, &lm36274_data->led_dev);
+	return led_classdev_register(chip->dev, &chip->led_dev);
 }
 
 static int lm36274_remove(struct platform_device *pdev)
 {
-	struct lm36274 *lm36274_data = platform_get_drvdata(pdev);
+	struct lm36274 *chip = platform_get_drvdata(pdev);
 
-	led_classdev_unregister(&lm36274_data->led_dev);
+	led_classdev_unregister(&chip->led_dev);
 
 	return 0;
 }
-- 
2.30.2



