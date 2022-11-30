Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8FC163DD57
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:26:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbiK3S0j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:26:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229764AbiK3S0g (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:26:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C8E6DEA4
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:26:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 05725B81C9D
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:26:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31620C433C1;
        Wed, 30 Nov 2022 18:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669832790;
        bh=OByJ1g1fR5CWqeLeZ6ni0Q4SURrBNXSzkliDVQC89Ys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f3/ce1v66xn5TMWq91QhOm85qNuvJYVMy6vATT5Nnh6m6cM9HBHhDnp+9KLwytn5z
         u+8NymQl4YYrNoMfFUbiGsDnz+/FFhGNr+t8ibhma/yPBTuRYvASky4z5ghVieDvcY
         WyzWBN+49M0/Z0Bm2xlmvsHNRUweePfNMm9gTZQk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Mitja Spes <mitja@lxnav.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 012/162] iio: pressure: ms5611: fixed value compensation bug
Date:   Wed, 30 Nov 2022 19:21:33 +0100
Message-Id: <20221130180528.827834246@linuxfoundation.org>
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

From: Mitja Spes <mitja@lxnav.com>

[ Upstream commit 17f442e7e47579d3881fc4d47354eaef09302e6f ]

When using multiple instances of this driver the compensation PROM was
overwritten by the last initialized sensor. Now each sensor has own PROM
storage.

Signed-off-by: Mitja Spes <mitja@lxnav.com>
Fixes: 9690d81a02dc ("iio: pressure: ms5611: add support for MS5607 temperature and pressure sensor")
Link: https://lore.kernel.org/r/20221021135827.1444793-2-mitja@lxnav.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/pressure/ms5611.h      | 12 +++----
 drivers/iio/pressure/ms5611_core.c | 51 ++++++++++++++++--------------
 2 files changed, 31 insertions(+), 32 deletions(-)

diff --git a/drivers/iio/pressure/ms5611.h b/drivers/iio/pressure/ms5611.h
index 345f3902e3e3..5e2d2d4d87b5 100644
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
index 885ccb7914dc..874a73b3ea9d 100644
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
-- 
2.35.1



