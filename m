Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E32A541305
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:56:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357602AbiFGTzj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:55:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358947AbiFGTxY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:53:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3C5F32EDC;
        Tue,  7 Jun 2022 11:23:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 328A9B8237D;
        Tue,  7 Jun 2022 18:23:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AE4CC385A2;
        Tue,  7 Jun 2022 18:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626186;
        bh=zmVLlQpTiH15ShWxpAuNa8u5VbIpjW9gJqgWwSjyFMk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q4epXaNUwnj9ees8I6JLNrZ3Q4fp87rtMwkDYlmQAzsWIFbDso21G3Tvh6tyrHUs6
         buojrHAnuUo3jeKoZ5fzZ01v9nEdULaDt2DMDJlBmLBs476XJbdWr0qckqMRmGwn7Z
         1fxZHxH3vbAXJA5J3kzU63/GgGLFwqjvgiQFbReM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 286/772] media: i2c: max9286: Use "maxim,gpio-poc" property
Date:   Tue,  7 Jun 2022 18:57:58 +0200
Message-Id: <20220607164957.453846572@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jacopo Mondi <jacopo+renesas@jmondi.org>

[ Upstream commit c9352df7139bc5be6642ebc8a78b40477ab32acd ]

The 'maxim,gpio-poc' property is used when the remote camera
power-over-coax is controlled by one of the MAX9286 gpio lines,
to instruct the driver about which line to use and what the line
polarity is.

Add to the max9286 driver support for parsing the newly introduced
property and use it if available in place of the usual supply, as it is
not possible to establish one as consumer of the max9286 gpio
controller.

If the new property is present, no gpio controller is registered and
'poc-supply' is ignored.

In order to maximize code re-use, break out the max9286 gpio handling
function so that they can be used by the gpio controller through the
gpio-consumer API, or directly by the driver code.

Wrap the power up and power down routines to their own function to
be able to use either the gpio line directly or the supply. This will
make it easier to control the remote camera power at run time.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/max9286.c | 120 +++++++++++++++++++++++++++---------
 1 file changed, 90 insertions(+), 30 deletions(-)

diff --git a/drivers/media/i2c/max9286.c b/drivers/media/i2c/max9286.c
index eb2b8e42335b..c572eec54044 100644
--- a/drivers/media/i2c/max9286.c
+++ b/drivers/media/i2c/max9286.c
@@ -15,6 +15,7 @@
 #include <linux/fwnode.h>
 #include <linux/gpio/consumer.h>
 #include <linux/gpio/driver.h>
+#include <linux/gpio/machine.h>
 #include <linux/i2c.h>
 #include <linux/i2c-mux.h>
 #include <linux/module.h>
@@ -168,6 +169,8 @@ struct max9286_priv {
 	u32 init_rev_chan_mv;
 	u32 rev_chan_mv;
 
+	u32 gpio_poc[2];
+
 	struct v4l2_ctrl_handler ctrls;
 	struct v4l2_ctrl *pixelrate;
 
@@ -1025,20 +1028,27 @@ static int max9286_setup(struct max9286_priv *priv)
 	return 0;
 }
 
-static void max9286_gpio_set(struct gpio_chip *chip,
-			     unsigned int offset, int value)
+static int max9286_gpio_set(struct max9286_priv *priv, unsigned int offset,
+			    int value)
 {
-	struct max9286_priv *priv = gpiochip_get_data(chip);
-
 	if (value)
 		priv->gpio_state |= BIT(offset);
 	else
 		priv->gpio_state &= ~BIT(offset);
 
-	max9286_write(priv, 0x0f, MAX9286_0X0F_RESERVED | priv->gpio_state);
+	return max9286_write(priv, 0x0f,
+			     MAX9286_0X0F_RESERVED | priv->gpio_state);
 }
 
-static int max9286_gpio_get(struct gpio_chip *chip, unsigned int offset)
+static void max9286_gpiochip_set(struct gpio_chip *chip,
+				 unsigned int offset, int value)
+{
+	struct max9286_priv *priv = gpiochip_get_data(chip);
+
+	max9286_gpio_set(priv, offset, value);
+}
+
+static int max9286_gpiochip_get(struct gpio_chip *chip, unsigned int offset)
 {
 	struct max9286_priv *priv = gpiochip_get_data(chip);
 
@@ -1057,13 +1067,10 @@ static int max9286_register_gpio(struct max9286_priv *priv)
 	gpio->owner = THIS_MODULE;
 	gpio->ngpio = 2;
 	gpio->base = -1;
-	gpio->set = max9286_gpio_set;
-	gpio->get = max9286_gpio_get;
+	gpio->set = max9286_gpiochip_set;
+	gpio->get = max9286_gpiochip_get;
 	gpio->can_sleep = true;
 
-	/* GPIO values default to high */
-	priv->gpio_state = BIT(0) | BIT(1);
-
 	ret = devm_gpiochip_add_data(dev, gpio, priv);
 	if (ret)
 		dev_err(dev, "Unable to create gpio_chip\n");
@@ -1071,6 +1078,70 @@ static int max9286_register_gpio(struct max9286_priv *priv)
 	return ret;
 }
 
+static int max9286_parse_gpios(struct max9286_priv *priv)
+{
+	struct device *dev = &priv->client->dev;
+	int ret;
+
+	/* GPIO values default to high */
+	priv->gpio_state = BIT(0) | BIT(1);
+
+	/*
+	 * Parse the "gpio-poc" vendor property. If the property is not
+	 * specified the camera power is controlled by a regulator.
+	 */
+	ret = of_property_read_u32_array(dev->of_node, "maxim,gpio-poc",
+					 priv->gpio_poc, 2);
+	if (ret == -EINVAL) {
+		/*
+		 * If gpio lines are not used for the camera power, register
+		 * a gpio controller for consumers.
+		 */
+		ret = max9286_register_gpio(priv);
+		if (ret)
+			return ret;
+
+		priv->regulator = devm_regulator_get(dev, "poc");
+		if (IS_ERR(priv->regulator)) {
+			return dev_err_probe(dev, PTR_ERR(priv->regulator),
+					     "Unable to get PoC regulator (%ld)\n",
+					     PTR_ERR(priv->regulator));
+		}
+
+		return 0;
+	}
+
+	/* If the property is specified make sure it is well formed. */
+	if (ret || priv->gpio_poc[0] > 1 ||
+	    (priv->gpio_poc[1] != GPIO_ACTIVE_HIGH &&
+	     priv->gpio_poc[1] != GPIO_ACTIVE_LOW)) {
+		dev_err(dev, "Invalid 'gpio-poc' property\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int max9286_poc_enable(struct max9286_priv *priv, bool enable)
+{
+	int ret;
+
+	/* If the regulator is not available, use gpio to control power. */
+	if (!priv->regulator)
+		ret = max9286_gpio_set(priv, priv->gpio_poc[0],
+				       enable ^ priv->gpio_poc[1]);
+	else if (enable)
+		ret = regulator_enable(priv->regulator);
+	else
+		ret = regulator_disable(priv->regulator);
+
+	if (ret < 0)
+		dev_err(&priv->client->dev, "Unable to turn power %s\n",
+			enable ? "on" : "off");
+
+	return ret;
+}
+
 static int max9286_init(struct device *dev)
 {
 	struct max9286_priv *priv;
@@ -1080,17 +1151,14 @@ static int max9286_init(struct device *dev)
 	client = to_i2c_client(dev);
 	priv = i2c_get_clientdata(client);
 
-	/* Enable the bus power. */
-	ret = regulator_enable(priv->regulator);
-	if (ret < 0) {
-		dev_err(&client->dev, "Unable to turn PoC on\n");
+	ret = max9286_poc_enable(priv, true);
+	if (ret)
 		return ret;
-	}
 
 	ret = max9286_setup(priv);
 	if (ret) {
 		dev_err(dev, "Unable to setup max9286\n");
-		goto err_regulator;
+		goto err_poc_disable;
 	}
 
 	/*
@@ -1100,7 +1168,7 @@ static int max9286_init(struct device *dev)
 	ret = max9286_v4l2_register(priv);
 	if (ret) {
 		dev_err(dev, "Failed to register with V4L2\n");
-		goto err_regulator;
+		goto err_poc_disable;
 	}
 
 	ret = max9286_i2c_mux_init(priv);
@@ -1116,8 +1184,8 @@ static int max9286_init(struct device *dev)
 
 err_v4l2_register:
 	max9286_v4l2_unregister(priv);
-err_regulator:
-	regulator_disable(priv->regulator);
+err_poc_disable:
+	max9286_poc_enable(priv, false);
 
 	return ret;
 }
@@ -1288,18 +1356,10 @@ static int max9286_probe(struct i2c_client *client)
 	 */
 	max9286_configure_i2c(priv, false);
 
-	ret = max9286_register_gpio(priv);
+	ret = max9286_parse_gpios(priv);
 	if (ret)
 		goto err_powerdown;
 
-	priv->regulator = devm_regulator_get(&client->dev, "poc");
-	if (IS_ERR(priv->regulator)) {
-		ret = PTR_ERR(priv->regulator);
-		dev_err_probe(&client->dev, ret,
-			      "Unable to get PoC regulator\n");
-		goto err_powerdown;
-	}
-
 	ret = max9286_parse_dt(priv);
 	if (ret)
 		goto err_powerdown;
@@ -1326,7 +1386,7 @@ static int max9286_remove(struct i2c_client *client)
 
 	max9286_v4l2_unregister(priv);
 
-	regulator_disable(priv->regulator);
+	max9286_poc_enable(priv, false);
 
 	gpiod_set_value_cansleep(priv->gpiod_pwdn, 0);
 
-- 
2.35.1



