Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EEFA2FA911
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 19:43:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393588AbhARSmC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 13:42:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:36026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390697AbhARLlK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:41:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7544A22573;
        Mon, 18 Jan 2021 11:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970047;
        bh=ANFPsh9nq4m0jihrfOPb0AzrfdnqQNgcbbCx0tRVjvo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PeLano2KKYzHlbxBQS0DikqPc+TcBBUjqCDO/Lvpd7D19DIUG7zpVBKm9pGoPtpG4
         CzazdJ+AC/v3ULU7p8kTC3Gj6637UZ8JkZ3R1TRT7xP+OBLpkla5nl9SB7CfpledBE
         cyMTN5iu5RGdK9o/MDD/bHml0kIolkW9e3oHB4cE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexandru Gagniuc <mr.nuke.me@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 5.10 015/152] drm/bridge: sii902x: Refactor init code into separate function
Date:   Mon, 18 Jan 2021 12:33:10 +0100
Message-Id: <20210118113353.502783054@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandru Gagniuc <mr.nuke.me@gmail.com>

commit 91b5e26731c5d409d6134603afc061617639933e upstream.

Separate the hardware initialization code from setting up the data
structures and parsing the device tree. The purpose of this change is
to provide a single exit point and avoid a waterfall of 'goto's in
the subsequent patch.

Signed-off-by: Alexandru Gagniuc <mr.nuke.me@gmail.com>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20201020221501.260025-1-mr.nuke.me@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/bridge/sii902x.c |   77 +++++++++++++++++++++------------------
 1 file changed, 43 insertions(+), 34 deletions(-)

--- a/drivers/gpu/drm/bridge/sii902x.c
+++ b/drivers/gpu/drm/bridge/sii902x.c
@@ -954,41 +954,13 @@ static const struct drm_bridge_timings d
 		 | DRM_BUS_FLAG_DE_HIGH,
 };
 
-static int sii902x_probe(struct i2c_client *client,
-			 const struct i2c_device_id *id)
+static int sii902x_init(struct sii902x *sii902x)
 {
-	struct device *dev = &client->dev;
+	struct device *dev = &sii902x->i2c->dev;
 	unsigned int status = 0;
-	struct sii902x *sii902x;
 	u8 chipid[4];
 	int ret;
 
-	ret = i2c_check_functionality(client->adapter,
-				      I2C_FUNC_SMBUS_BYTE_DATA);
-	if (!ret) {
-		dev_err(dev, "I2C adapter not suitable\n");
-		return -EIO;
-	}
-
-	sii902x = devm_kzalloc(dev, sizeof(*sii902x), GFP_KERNEL);
-	if (!sii902x)
-		return -ENOMEM;
-
-	sii902x->i2c = client;
-	sii902x->regmap = devm_regmap_init_i2c(client, &sii902x_regmap_config);
-	if (IS_ERR(sii902x->regmap))
-		return PTR_ERR(sii902x->regmap);
-
-	sii902x->reset_gpio = devm_gpiod_get_optional(dev, "reset",
-						      GPIOD_OUT_LOW);
-	if (IS_ERR(sii902x->reset_gpio)) {
-		dev_err(dev, "Failed to retrieve/request reset gpio: %ld\n",
-			PTR_ERR(sii902x->reset_gpio));
-		return PTR_ERR(sii902x->reset_gpio);
-	}
-
-	mutex_init(&sii902x->mutex);
-
 	sii902x_reset(sii902x);
 
 	ret = regmap_write(sii902x->regmap, SII902X_REG_TPI_RQB, 0x0);
@@ -1012,11 +984,11 @@ static int sii902x_probe(struct i2c_clie
 	regmap_read(sii902x->regmap, SII902X_INT_STATUS, &status);
 	regmap_write(sii902x->regmap, SII902X_INT_STATUS, status);
 
-	if (client->irq > 0) {
+	if (sii902x->i2c->irq > 0) {
 		regmap_write(sii902x->regmap, SII902X_INT_ENABLE,
 			     SII902X_HOTPLUG_EVENT);
 
-		ret = devm_request_threaded_irq(dev, client->irq, NULL,
+		ret = devm_request_threaded_irq(dev, sii902x->i2c->irq, NULL,
 						sii902x_interrupt,
 						IRQF_ONESHOT, dev_name(dev),
 						sii902x);
@@ -1031,9 +1003,9 @@ static int sii902x_probe(struct i2c_clie
 
 	sii902x_audio_codec_init(sii902x, dev);
 
-	i2c_set_clientdata(client, sii902x);
+	i2c_set_clientdata(sii902x->i2c, sii902x);
 
-	sii902x->i2cmux = i2c_mux_alloc(client->adapter, dev,
+	sii902x->i2cmux = i2c_mux_alloc(sii902x->i2c->adapter, dev,
 					1, 0, I2C_MUX_GATE,
 					sii902x_i2c_bypass_select,
 					sii902x_i2c_bypass_deselect);
@@ -1044,6 +1016,43 @@ static int sii902x_probe(struct i2c_clie
 	return i2c_mux_add_adapter(sii902x->i2cmux, 0, 0, 0);
 }
 
+static int sii902x_probe(struct i2c_client *client,
+			 const struct i2c_device_id *id)
+{
+	struct device *dev = &client->dev;
+	struct sii902x *sii902x;
+	int ret;
+
+	ret = i2c_check_functionality(client->adapter,
+				      I2C_FUNC_SMBUS_BYTE_DATA);
+	if (!ret) {
+		dev_err(dev, "I2C adapter not suitable\n");
+		return -EIO;
+	}
+
+	sii902x = devm_kzalloc(dev, sizeof(*sii902x), GFP_KERNEL);
+	if (!sii902x)
+		return -ENOMEM;
+
+	sii902x->i2c = client;
+	sii902x->regmap = devm_regmap_init_i2c(client, &sii902x_regmap_config);
+	if (IS_ERR(sii902x->regmap))
+		return PTR_ERR(sii902x->regmap);
+
+	sii902x->reset_gpio = devm_gpiod_get_optional(dev, "reset",
+						      GPIOD_OUT_LOW);
+	if (IS_ERR(sii902x->reset_gpio)) {
+		dev_err(dev, "Failed to retrieve/request reset gpio: %ld\n",
+			PTR_ERR(sii902x->reset_gpio));
+		return PTR_ERR(sii902x->reset_gpio);
+	}
+
+	mutex_init(&sii902x->mutex);
+
+	ret = sii902x_init(sii902x);
+	return ret;
+}
+
 static int sii902x_remove(struct i2c_client *client)
 
 {


