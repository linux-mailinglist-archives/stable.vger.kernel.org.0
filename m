Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1E5B63DD52
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:26:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbiK3S01 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:26:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbiK3S00 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:26:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94FFEA45D
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:26:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3E977B81CA1
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:26:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94F00C433C1;
        Wed, 30 Nov 2022 18:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669832781;
        bh=VT+ufyxzhoyzgS1pec8+6SCEwZPpcuChxGenKlO/9/k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O7rwxxkBMbZrG0zlRJB+YUIZgAgo3cMNHwDnjh7mcG1gMMJBf707XNQ/OWhtswha6
         YAvMiWVTwHtcNQgqX3DX5x9n3mejDRNm1aBj5egLFkzBt/K1SZnQt0ldgKvJmyu4cK
         T85sMh5dVjKrTAAxG/0FOn0rhJ6FtksEn+Wa5VuI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Lars-Peter Clausen <lars@metafoo.de>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 011/162] iio: ms5611: Simplify IO callback parameters
Date:   Wed, 30 Nov 2022 19:21:32 +0100
Message-Id: <20221130180528.802270950@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180528.466039523@linuxfoundation.org>
References: <20221130180528.466039523@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lars-Peter Clausen <lars@metafoo.de>

[ Upstream commit dc19fa63ad80a636fdbc1a02153d1ab140cb901f ]

The ms5611 passes &indio_dev->dev as a parameter to all its IO callbacks
only to directly cast the struct device back to struct iio_dev. And the
struct iio_dev is then only used to get the drivers state struct.

Simplify this a bit by passing the state struct directly. This makes it a
bit easier to follow what the code is doing.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Link: https://lore.kernel.org/r/20211020142110.7060-1-lars@metafoo.de
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Stable-dep-of: 17f442e7e475 ("iio: pressure: ms5611: fixed value compensation bug")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/pressure/ms5611.h      |  6 +++---
 drivers/iio/pressure/ms5611_core.c |  7 +++----
 drivers/iio/pressure/ms5611_i2c.c  | 11 ++++-------
 drivers/iio/pressure/ms5611_spi.c  | 17 +++++++----------
 4 files changed, 17 insertions(+), 24 deletions(-)

diff --git a/drivers/iio/pressure/ms5611.h b/drivers/iio/pressure/ms5611.h
index bc06271fa38b..345f3902e3e3 100644
--- a/drivers/iio/pressure/ms5611.h
+++ b/drivers/iio/pressure/ms5611.h
@@ -50,9 +50,9 @@ struct ms5611_state {
 	const struct ms5611_osr *pressure_osr;
 	const struct ms5611_osr *temp_osr;
 
-	int (*reset)(struct device *dev);
-	int (*read_prom_word)(struct device *dev, int index, u16 *word);
-	int (*read_adc_temp_and_pressure)(struct device *dev,
+	int (*reset)(struct ms5611_state *st);
+	int (*read_prom_word)(struct ms5611_state *st, int index, u16 *word);
+	int (*read_adc_temp_and_pressure)(struct ms5611_state *st,
 					  s32 *temp, s32 *pressure);
 
 	struct ms5611_chip_info *chip_info;
diff --git a/drivers/iio/pressure/ms5611_core.c b/drivers/iio/pressure/ms5611_core.c
index 214b0d25f598..885ccb7914dc 100644
--- a/drivers/iio/pressure/ms5611_core.c
+++ b/drivers/iio/pressure/ms5611_core.c
@@ -85,8 +85,7 @@ static int ms5611_read_prom(struct iio_dev *indio_dev)
 	struct ms5611_state *st = iio_priv(indio_dev);
 
 	for (i = 0; i < MS5611_PROM_WORDS_NB; i++) {
-		ret = st->read_prom_word(&indio_dev->dev,
-					 i, &st->chip_info->prom[i]);
+		ret = st->read_prom_word(st, i, &st->chip_info->prom[i]);
 		if (ret < 0) {
 			dev_err(&indio_dev->dev,
 				"failed to read prom at %d\n", i);
@@ -108,7 +107,7 @@ static int ms5611_read_temp_and_pressure(struct iio_dev *indio_dev,
 	int ret;
 	struct ms5611_state *st = iio_priv(indio_dev);
 
-	ret = st->read_adc_temp_and_pressure(&indio_dev->dev, temp, pressure);
+	ret = st->read_adc_temp_and_pressure(st, temp, pressure);
 	if (ret < 0) {
 		dev_err(&indio_dev->dev,
 			"failed to read temperature and pressure\n");
@@ -196,7 +195,7 @@ static int ms5611_reset(struct iio_dev *indio_dev)
 	int ret;
 	struct ms5611_state *st = iio_priv(indio_dev);
 
-	ret = st->reset(&indio_dev->dev);
+	ret = st->reset(st);
 	if (ret < 0) {
 		dev_err(&indio_dev->dev, "failed to reset device\n");
 		return ret;
diff --git a/drivers/iio/pressure/ms5611_i2c.c b/drivers/iio/pressure/ms5611_i2c.c
index 7c04f730430c..cccc40f7df0b 100644
--- a/drivers/iio/pressure/ms5611_i2c.c
+++ b/drivers/iio/pressure/ms5611_i2c.c
@@ -20,17 +20,15 @@
 
 #include "ms5611.h"
 
-static int ms5611_i2c_reset(struct device *dev)
+static int ms5611_i2c_reset(struct ms5611_state *st)
 {
-	struct ms5611_state *st = iio_priv(dev_to_iio_dev(dev));
-
 	return i2c_smbus_write_byte(st->client, MS5611_RESET);
 }
 
-static int ms5611_i2c_read_prom_word(struct device *dev, int index, u16 *word)
+static int ms5611_i2c_read_prom_word(struct ms5611_state *st, int index,
+				     u16 *word)
 {
 	int ret;
-	struct ms5611_state *st = iio_priv(dev_to_iio_dev(dev));
 
 	ret = i2c_smbus_read_word_swapped(st->client,
 			MS5611_READ_PROM_WORD + (index << 1));
@@ -57,11 +55,10 @@ static int ms5611_i2c_read_adc(struct ms5611_state *st, s32 *val)
 	return 0;
 }
 
-static int ms5611_i2c_read_adc_temp_and_pressure(struct device *dev,
+static int ms5611_i2c_read_adc_temp_and_pressure(struct ms5611_state *st,
 						 s32 *temp, s32 *pressure)
 {
 	int ret;
-	struct ms5611_state *st = iio_priv(dev_to_iio_dev(dev));
 	const struct ms5611_osr *osr = st->temp_osr;
 
 	ret = i2c_smbus_write_byte(st->client, osr->cmd);
diff --git a/drivers/iio/pressure/ms5611_spi.c b/drivers/iio/pressure/ms5611_spi.c
index f7743ee3318f..3039fe8aa2a2 100644
--- a/drivers/iio/pressure/ms5611_spi.c
+++ b/drivers/iio/pressure/ms5611_spi.c
@@ -15,18 +15,17 @@
 
 #include "ms5611.h"
 
-static int ms5611_spi_reset(struct device *dev)
+static int ms5611_spi_reset(struct ms5611_state *st)
 {
 	u8 cmd = MS5611_RESET;
-	struct ms5611_state *st = iio_priv(dev_to_iio_dev(dev));
 
 	return spi_write_then_read(st->client, &cmd, 1, NULL, 0);
 }
 
-static int ms5611_spi_read_prom_word(struct device *dev, int index, u16 *word)
+static int ms5611_spi_read_prom_word(struct ms5611_state *st, int index,
+				     u16 *word)
 {
 	int ret;
-	struct ms5611_state *st = iio_priv(dev_to_iio_dev(dev));
 
 	ret = spi_w8r16be(st->client, MS5611_READ_PROM_WORD + (index << 1));
 	if (ret < 0)
@@ -37,11 +36,10 @@ static int ms5611_spi_read_prom_word(struct device *dev, int index, u16 *word)
 	return 0;
 }
 
-static int ms5611_spi_read_adc(struct device *dev, s32 *val)
+static int ms5611_spi_read_adc(struct ms5611_state *st, s32 *val)
 {
 	int ret;
 	u8 buf[3] = { MS5611_READ_ADC };
-	struct ms5611_state *st = iio_priv(dev_to_iio_dev(dev));
 
 	ret = spi_write_then_read(st->client, buf, 1, buf, 3);
 	if (ret < 0)
@@ -52,11 +50,10 @@ static int ms5611_spi_read_adc(struct device *dev, s32 *val)
 	return 0;
 }
 
-static int ms5611_spi_read_adc_temp_and_pressure(struct device *dev,
+static int ms5611_spi_read_adc_temp_and_pressure(struct ms5611_state *st,
 						 s32 *temp, s32 *pressure)
 {
 	int ret;
-	struct ms5611_state *st = iio_priv(dev_to_iio_dev(dev));
 	const struct ms5611_osr *osr = st->temp_osr;
 
 	/*
@@ -68,7 +65,7 @@ static int ms5611_spi_read_adc_temp_and_pressure(struct device *dev,
 		return ret;
 
 	usleep_range(osr->conv_usec, osr->conv_usec + (osr->conv_usec / 10UL));
-	ret = ms5611_spi_read_adc(dev, temp);
+	ret = ms5611_spi_read_adc(st, temp);
 	if (ret < 0)
 		return ret;
 
@@ -78,7 +75,7 @@ static int ms5611_spi_read_adc_temp_and_pressure(struct device *dev,
 		return ret;
 
 	usleep_range(osr->conv_usec, osr->conv_usec + (osr->conv_usec / 10UL));
-	return ms5611_spi_read_adc(dev, pressure);
+	return ms5611_spi_read_adc(st, pressure);
 }
 
 static int ms5611_spi_probe(struct spi_device *spi)
-- 
2.35.1



