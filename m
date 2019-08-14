Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7868D8D8DA
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:03:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728859AbfHNRDK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:03:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:51716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728857AbfHNRDK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:03:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C3FFA216F4;
        Wed, 14 Aug 2019 17:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802189;
        bh=F+60tqhuY03iGuu52cR7AYByFohaAhwPrPdcbZan4M4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ukXYq9JekUxpZENSiNB+hfHr6NQ3PHtvqx2IyOht5SuJXdEay2M+jN494yDJ0Moh2
         Q06sEoa0zVDKRFgqTyPtBglx6UpQmrCNRylBeOdTPB7nfjkpPMcSq+8/SPDqyRkQ9I
         B56/N/3mAC6EY/jE/ziNuG7t0fqZqA5nu4QYMEMg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jean-Baptiste Maneyrol <jmaneyrol@invensense.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.2 004/144] iio: imu: mpu6050: add missing available scan masks
Date:   Wed, 14 Aug 2019 18:59:20 +0200
Message-Id: <20190814165759.662568983@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165759.466811854@linuxfoundation.org>
References: <20190814165759.466811854@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jean-Baptiste Maneyrol <JManeyrol@invensense.com>

commit 1244a720572fd1680ac8d6b8a4235f2e8557b810 upstream.

Driver only supports 3-axis gyro and/or 3-axis accel.
For icm20602, temp data is mandatory for all configurations.

Fix all single and double axis configurations (almost never used) and more
importantly fix 3-axis gyro and 6-axis accel+gyro buffer on icm20602 when
temp data is not enabled.

Signed-off-by: Jean-Baptiste Maneyrol <jmaneyrol@invensense.com>
Fixes: 1615fe41a195 ("iio: imu: mpu6050: Fix FIFO layout for ICM20602")
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/imu/inv_mpu6050/inv_mpu_core.c |   43 +++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

--- a/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c
+++ b/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c
@@ -845,6 +845,25 @@ static const struct iio_chan_spec inv_mp
 	INV_MPU6050_CHAN(IIO_ACCEL, IIO_MOD_Z, INV_MPU6050_SCAN_ACCL_Z),
 };
 
+static const unsigned long inv_mpu_scan_masks[] = {
+	/* 3-axis accel */
+	BIT(INV_MPU6050_SCAN_ACCL_X)
+		| BIT(INV_MPU6050_SCAN_ACCL_Y)
+		| BIT(INV_MPU6050_SCAN_ACCL_Z),
+	/* 3-axis gyro */
+	BIT(INV_MPU6050_SCAN_GYRO_X)
+		| BIT(INV_MPU6050_SCAN_GYRO_Y)
+		| BIT(INV_MPU6050_SCAN_GYRO_Z),
+	/* 6-axis accel + gyro */
+	BIT(INV_MPU6050_SCAN_ACCL_X)
+		| BIT(INV_MPU6050_SCAN_ACCL_Y)
+		| BIT(INV_MPU6050_SCAN_ACCL_Z)
+		| BIT(INV_MPU6050_SCAN_GYRO_X)
+		| BIT(INV_MPU6050_SCAN_GYRO_Y)
+		| BIT(INV_MPU6050_SCAN_GYRO_Z),
+	0,
+};
+
 static const struct iio_chan_spec inv_icm20602_channels[] = {
 	IIO_CHAN_SOFT_TIMESTAMP(INV_ICM20602_SCAN_TIMESTAMP),
 	{
@@ -871,6 +890,28 @@ static const struct iio_chan_spec inv_ic
 	INV_MPU6050_CHAN(IIO_ACCEL, IIO_MOD_Z, INV_ICM20602_SCAN_ACCL_Z),
 };
 
+static const unsigned long inv_icm20602_scan_masks[] = {
+	/* 3-axis accel + temp (mandatory) */
+	BIT(INV_ICM20602_SCAN_ACCL_X)
+		| BIT(INV_ICM20602_SCAN_ACCL_Y)
+		| BIT(INV_ICM20602_SCAN_ACCL_Z)
+		| BIT(INV_ICM20602_SCAN_TEMP),
+	/* 3-axis gyro + temp (mandatory) */
+	BIT(INV_ICM20602_SCAN_GYRO_X)
+		| BIT(INV_ICM20602_SCAN_GYRO_Y)
+		| BIT(INV_ICM20602_SCAN_GYRO_Z)
+		| BIT(INV_ICM20602_SCAN_TEMP),
+	/* 6-axis accel + gyro + temp (mandatory) */
+	BIT(INV_ICM20602_SCAN_ACCL_X)
+		| BIT(INV_ICM20602_SCAN_ACCL_Y)
+		| BIT(INV_ICM20602_SCAN_ACCL_Z)
+		| BIT(INV_ICM20602_SCAN_GYRO_X)
+		| BIT(INV_ICM20602_SCAN_GYRO_Y)
+		| BIT(INV_ICM20602_SCAN_GYRO_Z)
+		| BIT(INV_ICM20602_SCAN_TEMP),
+	0,
+};
+
 /*
  * The user can choose any frequency between INV_MPU6050_MIN_FIFO_RATE and
  * INV_MPU6050_MAX_FIFO_RATE, but only these frequencies are matched by the
@@ -1130,9 +1171,11 @@ int inv_mpu_core_probe(struct regmap *re
 	if (chip_type == INV_ICM20602) {
 		indio_dev->channels = inv_icm20602_channels;
 		indio_dev->num_channels = ARRAY_SIZE(inv_icm20602_channels);
+		indio_dev->available_scan_masks = inv_icm20602_scan_masks;
 	} else {
 		indio_dev->channels = inv_mpu_channels;
 		indio_dev->num_channels = ARRAY_SIZE(inv_mpu_channels);
+		indio_dev->available_scan_masks = inv_mpu_scan_masks;
 	}
 
 	indio_dev->info = &mpu_info;


