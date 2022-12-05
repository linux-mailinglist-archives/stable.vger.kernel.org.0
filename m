Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5393D643460
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:46:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234957AbiLETqE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:46:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234901AbiLETpn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:45:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23F7E2D1F2
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:42:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C5A19B811F3
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:42:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36242C433B5;
        Mon,  5 Dec 2022 19:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670269332;
        bh=64G7UgGdDhmqEbnjNmFv5oKKi3/cbM9d016tjCpoFdc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T0Spj4emyee6uqQ3Y6E7gw4Jh4WJqTmdagHunsWzYGd9E/4L+ugotwMghQC/vpZbG
         nFwI7MeaBog6Jh6Ogg/ljU7i4GC1CdQs9yrTQ5TiVLLYPNtfO7R5iaF/IVqX+cJZQv
         sz7zanSujrfDbiwLPEDg6kOZ0NUhWoGc6qiXa3hA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Lars-Peter Clausen <lars@metafoo.de>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 051/153] iio: ms5611: Simplify IO callback parameters
Date:   Mon,  5 Dec 2022 20:09:35 +0100
Message-Id: <20221205190810.184287665@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.733996403@linuxfoundation.org>
References: <20221205190808.733996403@linuxfoundation.org>
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
index f5db9fa086f3..29dd648a308c 100644
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
index 8089c59adce5..3175816e657f 100644
--- a/drivers/iio/pressure/ms5611_i2c.c
+++ b/drivers/iio/pressure/ms5611_i2c.c
@@ -18,17 +18,15 @@
 
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
@@ -55,11 +53,10 @@ static int ms5611_i2c_read_adc(struct ms5611_state *st, s32 *val)
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
index c3854594cd26..6e9cab61bc32 100644
--- a/drivers/iio/pressure/ms5611_spi.c
+++ b/drivers/iio/pressure/ms5611_spi.c
@@ -13,18 +13,17 @@
 
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
@@ -35,11 +34,10 @@ static int ms5611_spi_read_prom_word(struct device *dev, int index, u16 *word)
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
@@ -50,11 +48,10 @@ static int ms5611_spi_read_adc(struct device *dev, s32 *val)
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
@@ -66,7 +63,7 @@ static int ms5611_spi_read_adc_temp_and_pressure(struct device *dev,
 		return ret;
 
 	usleep_range(osr->conv_usec, osr->conv_usec + (osr->conv_usec / 10UL));
-	ret = ms5611_spi_read_adc(dev, temp);
+	ret = ms5611_spi_read_adc(st, temp);
 	if (ret < 0)
 		return ret;
 
@@ -76,7 +73,7 @@ static int ms5611_spi_read_adc_temp_and_pressure(struct device *dev,
 		return ret;
 
 	usleep_range(osr->conv_usec, osr->conv_usec + (osr->conv_usec / 10UL));
-	return ms5611_spi_read_adc(dev, pressure);
+	return ms5611_spi_read_adc(st, pressure);
 }
 
 static int ms5611_spi_probe(struct spi_device *spi)
-- 
2.35.1



