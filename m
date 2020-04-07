Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 030C81A0F2B
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 16:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728776AbgDGOaP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 10:30:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:48164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728573AbgDGOaP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Apr 2020 10:30:15 -0400
Received: from localhost (fw-tnat.cambridge.arm.com [217.140.96.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 100222072A;
        Tue,  7 Apr 2020 14:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586269814;
        bh=Tx9CueQXpBVTXsQmYUbS+aYZBCgVaoUhPLdZITIsLAA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=h74DLMKaidICIDKOCu0tJOcXlVME551nP0fMH7amwcC6aTefy8XacOFS6Zq9ySsKK
         P1welWyHaE7pxW6f13bqSDZI9v0ytKNjGJragEC/YDE1IxyReH+RBq2OsTN6TNe83m
         bbQQUJbxJ+9KgD9nUYo5Fh4qOmjYH3csY/QRjZ2c=
Date:   Tue, 07 Apr 2020 15:30:11 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Mike Willard <mwillard@izotope.com>
Cc:     alsa-devel@alsa-project.org,
        Brian Austin <brian.austin@cirrus.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        mwillard@izotope.com, Paul Handrigan <Paul.Handrigan@cirrus.com>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.com>
Subject: Applied "ASoC: cs4270: pull reset GPIO low then high" to the asoc tree
In-Reply-To:  <20200401205454.79792-1-mwillard@izotope.com>
Message-Id:  <applied-20200401205454.79792-1-mwillard@izotope.com>
X-Patchwork-Hint: ignore
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The patch

   ASoC: cs4270: pull reset GPIO low then high

has been applied to the asoc tree at

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound.git 

All being well this means that it will be integrated into the linux-next
tree (usually sometime in the next 24 hours) and sent to Linus during
the next merge window (or sooner if it is a bug fix), however if
problems are discovered then the patch may be dropped or reverted.  

You may get further e-mails resulting from automated or manual testing
and review of the tree, please engage with people reporting problems and
send followup patches addressing any issues that are reported if needed.

If any updates are required or you are submitting further changes they
should be sent as incremental updates against current git, existing
patches will not be replaced.

Please add any relevant lists and maintainers to the CCs when replying
to this mail.

Thanks,
Mark

From ccfc531695f3a4aada042f6bdb33ac6be24e1aec Mon Sep 17 00:00:00 2001
From: Mike Willard <mwillard@izotope.com>
Date: Wed, 1 Apr 2020 20:54:54 +0000
Subject: [PATCH] ASoC: cs4270: pull reset GPIO low then high

Pull the RST line low then high when initializing the driver,
in order to force a reset of the chip.
Previously, the line was not pulled low, which could result in
the chip registers not resetting to their default values on boot.

Signed-off-by: Mike Willard <mwillard@izotope.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200401205454.79792-1-mwillard@izotope.com
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 sound/soc/codecs/cs4270.c | 40 ++++++++++++++++++++++++++++++++++-----
 1 file changed, 35 insertions(+), 5 deletions(-)

diff --git a/sound/soc/codecs/cs4270.c b/sound/soc/codecs/cs4270.c
index 5f25b9f872bd..8a02791e44ad 100644
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
@@ -648,6 +651,22 @@ static const struct regmap_config cs4270_regmap = {
 	.volatile_reg =		cs4270_reg_is_volatile,
 };
 
+/**
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
 /**
  * cs4270_i2c_probe - initialize the I2C interface of the CS4270
  * @i2c_client: the I2C client object
@@ -660,7 +679,6 @@ static int cs4270_i2c_probe(struct i2c_client *i2c_client,
 	const struct i2c_device_id *id)
 {
 	struct cs4270_private *cs4270;
-	struct gpio_desc *reset_gpiod;
 	unsigned int val;
 	int ret, i;
 
@@ -679,10 +697,21 @@ static int cs4270_i2c_probe(struct i2c_client *i2c_client,
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
@@ -735,6 +764,7 @@ static struct i2c_driver cs4270_i2c_driver = {
 	},
 	.id_table = cs4270_id,
 	.probe = cs4270_i2c_probe,
+	.remove = cs4270_i2c_remove,
 };
 
 module_i2c_driver(cs4270_i2c_driver);
-- 
2.20.1

