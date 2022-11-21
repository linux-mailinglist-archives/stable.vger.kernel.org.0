Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DE75632123
	for <lists+stable@lfdr.de>; Mon, 21 Nov 2022 12:47:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231297AbiKULrr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Nov 2022 06:47:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231458AbiKULrl (ORCPT
        <rfc822;Stable@vger.kernel.org>); Mon, 21 Nov 2022 06:47:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E35DCAE4C
        for <Stable@vger.kernel.org>; Mon, 21 Nov 2022 03:47:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 82925610FB
        for <Stable@vger.kernel.org>; Mon, 21 Nov 2022 11:47:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 796ECC433D6;
        Mon, 21 Nov 2022 11:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669031257;
        bh=n3jyX2Lg7savs1wBGz4v1GZC2Gyr0t2HkdMYOsEtLh8=;
        h=Subject:To:Cc:From:Date:From;
        b=zMVnyScwQH+3NL0vLYZ6sZcGEIherUgMXJ7gP3LONfccmiMUbcIUB17zpO50fnaqr
         yjt7DB1QzvCNuhosMG1DNAh2g+bplIL+zGfio+aMVm274O+jrZJecI4ge9db67jdbJ
         gYDspDL5VMITIWDQh6GOMqR5eF1Fbi/BXzhM4UjI=
Subject: FAILED: patch "[PATCH] iio: pressure: ms5611: fixed value compensation bug" failed to apply to 5.4-stable tree
To:     mitja@lxnav.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 21 Nov 2022 12:47:25 +0100
Message-ID: <1669031245205223@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

17f442e7e475 ("iio: pressure: ms5611: fixed value compensation bug")
dc19fa63ad80 ("iio: ms5611: Simplify IO callback parameters")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 17f442e7e47579d3881fc4d47354eaef09302e6f Mon Sep 17 00:00:00 2001
From: Mitja Spes <mitja@lxnav.com>
Date: Fri, 21 Oct 2022 15:58:20 +0200
Subject: [PATCH] iio: pressure: ms5611: fixed value compensation bug

When using multiple instances of this driver the compensation PROM was
overwritten by the last initialized sensor. Now each sensor has own PROM
storage.

Signed-off-by: Mitja Spes <mitja@lxnav.com>
Fixes: 9690d81a02dc ("iio: pressure: ms5611: add support for MS5607 temperature and pressure sensor")
Link: https://lore.kernel.org/r/20221021135827.1444793-2-mitja@lxnav.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

diff --git a/drivers/iio/pressure/ms5611.h b/drivers/iio/pressure/ms5611.h
index cbc9349c342a..550b75b7186f 100644
--- a/drivers/iio/pressure/ms5611.h
+++ b/drivers/iio/pressure/ms5611.h
@@ -25,13 +25,6 @@ enum {
 	MS5607,
 };
 
-struct ms5611_chip_info {
-	u16 prom[MS5611_PROM_WORDS_NB];
-
-	int (*temp_and_pressure_compensate)(struct ms5611_chip_info *chip_info,
-					    s32 *temp, s32 *pressure);
-};
-
 /*
  * OverSampling Rate descriptor.
  * Warning: cmd MUST be kept aligned on a word boundary (see
@@ -50,12 +43,15 @@ struct ms5611_state {
 	const struct ms5611_osr *pressure_osr;
 	const struct ms5611_osr *temp_osr;
 
+	u16 prom[MS5611_PROM_WORDS_NB];
+
 	int (*reset)(struct ms5611_state *st);
 	int (*read_prom_word)(struct ms5611_state *st, int index, u16 *word);
 	int (*read_adc_temp_and_pressure)(struct ms5611_state *st,
 					  s32 *temp, s32 *pressure);
 
-	struct ms5611_chip_info *chip_info;
+	int (*compensate_temp_and_pressure)(struct ms5611_state *st, s32 *temp,
+					  s32 *pressure);
 	struct regulator *vdd;
 };
 
diff --git a/drivers/iio/pressure/ms5611_core.c b/drivers/iio/pressure/ms5611_core.c
index 717521de66c4..c564a1d6cafe 100644
--- a/drivers/iio/pressure/ms5611_core.c
+++ b/drivers/iio/pressure/ms5611_core.c
@@ -85,7 +85,7 @@ static int ms5611_read_prom(struct iio_dev *indio_dev)
 	struct ms5611_state *st = iio_priv(indio_dev);
 
 	for (i = 0; i < MS5611_PROM_WORDS_NB; i++) {
-		ret = st->read_prom_word(st, i, &st->chip_info->prom[i]);
+		ret = st->read_prom_word(st, i, &st->prom[i]);
 		if (ret < 0) {
 			dev_err(&indio_dev->dev,
 				"failed to read prom at %d\n", i);
@@ -93,7 +93,7 @@ static int ms5611_read_prom(struct iio_dev *indio_dev)
 		}
 	}
 
-	if (!ms5611_prom_is_valid(st->chip_info->prom, MS5611_PROM_WORDS_NB)) {
+	if (!ms5611_prom_is_valid(st->prom, MS5611_PROM_WORDS_NB)) {
 		dev_err(&indio_dev->dev, "PROM integrity check failed\n");
 		return -ENODEV;
 	}
@@ -114,21 +114,20 @@ static int ms5611_read_temp_and_pressure(struct iio_dev *indio_dev,
 		return ret;
 	}
 
-	return st->chip_info->temp_and_pressure_compensate(st->chip_info,
-							   temp, pressure);
+	return st->compensate_temp_and_pressure(st, temp, pressure);
 }
 
-static int ms5611_temp_and_pressure_compensate(struct ms5611_chip_info *chip_info,
+static int ms5611_temp_and_pressure_compensate(struct ms5611_state *st,
 					       s32 *temp, s32 *pressure)
 {
 	s32 t = *temp, p = *pressure;
 	s64 off, sens, dt;
 
-	dt = t - (chip_info->prom[5] << 8);
-	off = ((s64)chip_info->prom[2] << 16) + ((chip_info->prom[4] * dt) >> 7);
-	sens = ((s64)chip_info->prom[1] << 15) + ((chip_info->prom[3] * dt) >> 8);
+	dt = t - (st->prom[5] << 8);
+	off = ((s64)st->prom[2] << 16) + ((st->prom[4] * dt) >> 7);
+	sens = ((s64)st->prom[1] << 15) + ((st->prom[3] * dt) >> 8);
 
-	t = 2000 + ((chip_info->prom[6] * dt) >> 23);
+	t = 2000 + ((st->prom[6] * dt) >> 23);
 	if (t < 2000) {
 		s64 off2, sens2, t2;
 
@@ -154,17 +153,17 @@ static int ms5611_temp_and_pressure_compensate(struct ms5611_chip_info *chip_inf
 	return 0;
 }
 
-static int ms5607_temp_and_pressure_compensate(struct ms5611_chip_info *chip_info,
+static int ms5607_temp_and_pressure_compensate(struct ms5611_state *st,
 					       s32 *temp, s32 *pressure)
 {
 	s32 t = *temp, p = *pressure;
 	s64 off, sens, dt;
 
-	dt = t - (chip_info->prom[5] << 8);
-	off = ((s64)chip_info->prom[2] << 17) + ((chip_info->prom[4] * dt) >> 6);
-	sens = ((s64)chip_info->prom[1] << 16) + ((chip_info->prom[3] * dt) >> 7);
+	dt = t - (st->prom[5] << 8);
+	off = ((s64)st->prom[2] << 17) + ((st->prom[4] * dt) >> 6);
+	sens = ((s64)st->prom[1] << 16) + ((st->prom[3] * dt) >> 7);
 
-	t = 2000 + ((chip_info->prom[6] * dt) >> 23);
+	t = 2000 + ((st->prom[6] * dt) >> 23);
 	if (t < 2000) {
 		s64 off2, sens2, t2, tmp;
 
@@ -342,15 +341,6 @@ static int ms5611_write_raw(struct iio_dev *indio_dev,
 
 static const unsigned long ms5611_scan_masks[] = {0x3, 0};
 
-static struct ms5611_chip_info chip_info_tbl[] = {
-	[MS5611] = {
-		.temp_and_pressure_compensate = ms5611_temp_and_pressure_compensate,
-	},
-	[MS5607] = {
-		.temp_and_pressure_compensate = ms5607_temp_and_pressure_compensate,
-	}
-};
-
 static const struct iio_chan_spec ms5611_channels[] = {
 	{
 		.type = IIO_PRESSURE,
@@ -433,7 +423,20 @@ int ms5611_probe(struct iio_dev *indio_dev, struct device *dev,
 	struct ms5611_state *st = iio_priv(indio_dev);
 
 	mutex_init(&st->lock);
-	st->chip_info = &chip_info_tbl[type];
+
+	switch (type) {
+	case MS5611:
+		st->compensate_temp_and_pressure =
+			ms5611_temp_and_pressure_compensate;
+		break;
+	case MS5607:
+		st->compensate_temp_and_pressure =
+			ms5607_temp_and_pressure_compensate;
+		break;
+	default:
+		return -EINVAL;
+	}
+
 	st->temp_osr =
 		&ms5611_avail_temp_osr[ARRAY_SIZE(ms5611_avail_temp_osr) - 1];
 	st->pressure_osr =

