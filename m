Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 550BF1AC6A0
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 16:42:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394502AbgDPOma (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 10:42:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:47914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392656AbgDPOAs (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 10:00:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4031A2078B;
        Thu, 16 Apr 2020 14:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587045647;
        bh=I0O0ffcTQDLvbIA9cqZLny6cy4vZJ+L0A/xovm88QmI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LIFTSmK2LK30HH3Ev1Ek39UboBrgNtAAUgWjhtbY3nY/uJNF65yW9eS4qqAe47GZy
         x7mhPsmtwxPiL0UFOaSbhGhPA4vFUUuyfwnf1eSrSezzApY3U+qJYKDfmlFReWLlAC
         b0XbonVXxI++mG97FGHr04K+mJTs2rNfr1Zl1A1w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Willard <mwillard@izotope.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.6 219/254] ASoC: cs4270: pull reset GPIO low then high
Date:   Thu, 16 Apr 2020 15:25:08 +0200
Message-Id: <20200416131353.339943848@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.804095985@linuxfoundation.org>
References: <20200416131325.804095985@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Willard <mwillard@izotope.com>

commit ccfc531695f3a4aada042f6bdb33ac6be24e1aec upstream.

Pull the RST line low then high when initializing the driver,
in order to force a reset of the chip.
Previously, the line was not pulled low, which could result in
the chip registers not resetting to their default values on boot.

Signed-off-by: Mike Willard <mwillard@izotope.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200401205454.79792-1-mwillard@izotope.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/cs4270.c |   40 +++++++++++++++++++++++++++++++++++-----
 1 file changed, 35 insertions(+), 5 deletions(-)

--- a/sound/soc/codecs/cs4270.c
+++ b/sound/soc/codecs/cs4270.c
@@ -137,6 +137,9 @@ struct cs4270_private {
 
 	/* power domain regulators */
 	struct regulator_bulk_data supplies[ARRAY_SIZE(supply_names)];
+
+	/* reset gpio */
+	struct gpio_desc *reset_gpio;
 };
 
 static const struct snd_soc_dapm_widget cs4270_dapm_widgets[] = {
@@ -649,6 +652,22 @@ static const struct regmap_config cs4270
 };
 
 /**
+ * cs4270_i2c_remove - deinitialize the I2C interface of the CS4270
+ * @i2c_client: the I2C client object
+ *
+ * This function puts the chip into low power mode when the i2c device
+ * is removed.
+ */
+static int cs4270_i2c_remove(struct i2c_client *i2c_client)
+{
+	struct cs4270_private *cs4270 = i2c_get_clientdata(i2c_client);
+
+	gpiod_set_value_cansleep(cs4270->reset_gpio, 0);
+
+	return 0;
+}
+
+/**
  * cs4270_i2c_probe - initialize the I2C interface of the CS4270
  * @i2c_client: the I2C client object
  * @id: the I2C device ID (ignored)
@@ -660,7 +679,6 @@ static int cs4270_i2c_probe(struct i2c_c
 	const struct i2c_device_id *id)
 {
 	struct cs4270_private *cs4270;
-	struct gpio_desc *reset_gpiod;
 	unsigned int val;
 	int ret, i;
 
@@ -679,10 +697,21 @@ static int cs4270_i2c_probe(struct i2c_c
 	if (ret < 0)
 		return ret;
 
-	reset_gpiod = devm_gpiod_get_optional(&i2c_client->dev, "reset",
-					      GPIOD_OUT_HIGH);
-	if (PTR_ERR(reset_gpiod) == -EPROBE_DEFER)
-		return -EPROBE_DEFER;
+	/* reset the device */
+	cs4270->reset_gpio = devm_gpiod_get_optional(&i2c_client->dev, "reset",
+						     GPIOD_OUT_LOW);
+	if (IS_ERR(cs4270->reset_gpio)) {
+		dev_dbg(&i2c_client->dev, "Error getting CS4270 reset GPIO\n");
+		return PTR_ERR(cs4270->reset_gpio);
+	}
+
+	if (cs4270->reset_gpio) {
+		dev_dbg(&i2c_client->dev, "Found reset GPIO\n");
+		gpiod_set_value_cansleep(cs4270->reset_gpio, 1);
+	}
+
+	/* Sleep 500ns before i2c communications */
+	ndelay(500);
 
 	cs4270->regmap = devm_regmap_init_i2c(i2c_client, &cs4270_regmap);
 	if (IS_ERR(cs4270->regmap))
@@ -735,6 +764,7 @@ static struct i2c_driver cs4270_i2c_driv
 	},
 	.id_table = cs4270_id,
 	.probe = cs4270_i2c_probe,
+	.remove = cs4270_i2c_remove,
 };
 
 module_i2c_driver(cs4270_i2c_driver);


