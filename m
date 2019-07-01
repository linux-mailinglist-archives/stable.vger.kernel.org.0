Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B49439F4F
	for <lists+stable@lfdr.de>; Sat,  8 Jun 2019 13:56:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727165AbfFHLjz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Jun 2019 07:39:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:56856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727100AbfFHLjz (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 Jun 2019 07:39:55 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F0457214C6;
        Sat,  8 Jun 2019 11:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559993993;
        bh=h7t8/ltbAT0wpu7V6QMF+P+XSXpzPaEQisAxUGleCvI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oPFZMmWuWaOqGUMsSweABEhZeCQ7uz4md+R0RSbc+M5az7SSfl1a398G/ZCozojIK
         s8DUtjehtVmA5qQnOieft6snCkhhA180ngltseuvugmHBFTgRUSm2PIZy7YkUKI3Gv
         vBkZ/PdyC5KQIzJyJJvRhr8WDnwqM4LkZteCecEQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Steve Moskovchenko <stevemo@skydio.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>, linux-iio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 02/70] iio: imu: mpu6050: Fix FIFO layout for ICM20602
Date:   Sat,  8 Jun 2019 07:38:41 -0400
Message-Id: <20190608113950.8033-2-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190608113950.8033-1-sashal@kernel.org>
References: <20190608113950.8033-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steve Moskovchenko <stevemo@skydio.com>

[ Upstream commit 1615fe41a1959a2ee2814ba62736b2bb54e9802a ]

The MPU6050 driver has recently gained support for the
ICM20602 IMU, which is very similar to MPU6xxx. However,
the ICM20602's FIFO data specifically includes temperature
readings, which were not present on MPU6xxx parts. As a
result, the driver will under-read the ICM20602's FIFO
register, causing the same (partial) sample to be returned
for all reads, until the FIFO overflows.

Fix this by adding a table of scan elements specifically
for the ICM20602, which takes the extra temperature data
into consideration.

While we're at it, fix the temperature offset and scaling
on ICM20602, since it uses different scale/offset constants
than the rest of the MPU6xxx devices.

Signed-off-by: Steve Moskovchenko <stevemo@skydio.com>
Fixes: 22904bdff978 ("iio: imu: mpu6050: Add support for the ICM 20602 IMU")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/imu/inv_mpu6050/inv_mpu_core.c | 46 ++++++++++++++++++++--
 drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h  | 20 +++++++++-
 drivers/iio/imu/inv_mpu6050/inv_mpu_ring.c |  3 ++
 3 files changed, 64 insertions(+), 5 deletions(-)

diff --git a/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c b/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c
index 650de0fefb7b..385f14a4d5a7 100644
--- a/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c
+++ b/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c
@@ -471,7 +471,10 @@ inv_mpu6050_read_raw(struct iio_dev *indio_dev,
 			return IIO_VAL_INT_PLUS_MICRO;
 		case IIO_TEMP:
 			*val = 0;
-			*val2 = INV_MPU6050_TEMP_SCALE;
+			if (st->chip_type == INV_ICM20602)
+				*val2 = INV_ICM20602_TEMP_SCALE;
+			else
+				*val2 = INV_MPU6050_TEMP_SCALE;
 
 			return IIO_VAL_INT_PLUS_MICRO;
 		default:
@@ -480,7 +483,10 @@ inv_mpu6050_read_raw(struct iio_dev *indio_dev,
 	case IIO_CHAN_INFO_OFFSET:
 		switch (chan->type) {
 		case IIO_TEMP:
-			*val = INV_MPU6050_TEMP_OFFSET;
+			if (st->chip_type == INV_ICM20602)
+				*val = INV_ICM20602_TEMP_OFFSET;
+			else
+				*val = INV_MPU6050_TEMP_OFFSET;
 
 			return IIO_VAL_INT;
 		default:
@@ -845,6 +851,32 @@ static const struct iio_chan_spec inv_mpu_channels[] = {
 	INV_MPU6050_CHAN(IIO_ACCEL, IIO_MOD_Z, INV_MPU6050_SCAN_ACCL_Z),
 };
 
+static const struct iio_chan_spec inv_icm20602_channels[] = {
+	IIO_CHAN_SOFT_TIMESTAMP(INV_ICM20602_SCAN_TIMESTAMP),
+	{
+		.type = IIO_TEMP,
+		.info_mask_separate = BIT(IIO_CHAN_INFO_RAW)
+				| BIT(IIO_CHAN_INFO_OFFSET)
+				| BIT(IIO_CHAN_INFO_SCALE),
+		.scan_index = INV_ICM20602_SCAN_TEMP,
+		.scan_type = {
+				.sign = 's',
+				.realbits = 16,
+				.storagebits = 16,
+				.shift = 0,
+				.endianness = IIO_BE,
+			     },
+	},
+
+	INV_MPU6050_CHAN(IIO_ANGL_VEL, IIO_MOD_X, INV_ICM20602_SCAN_GYRO_X),
+	INV_MPU6050_CHAN(IIO_ANGL_VEL, IIO_MOD_Y, INV_ICM20602_SCAN_GYRO_Y),
+	INV_MPU6050_CHAN(IIO_ANGL_VEL, IIO_MOD_Z, INV_ICM20602_SCAN_GYRO_Z),
+
+	INV_MPU6050_CHAN(IIO_ACCEL, IIO_MOD_Y, INV_ICM20602_SCAN_ACCL_Y),
+	INV_MPU6050_CHAN(IIO_ACCEL, IIO_MOD_X, INV_ICM20602_SCAN_ACCL_X),
+	INV_MPU6050_CHAN(IIO_ACCEL, IIO_MOD_Z, INV_ICM20602_SCAN_ACCL_Z),
+};
+
 /*
  * The user can choose any frequency between INV_MPU6050_MIN_FIFO_RATE and
  * INV_MPU6050_MAX_FIFO_RATE, but only these frequencies are matched by the
@@ -1100,8 +1132,14 @@ int inv_mpu_core_probe(struct regmap *regmap, int irq, const char *name,
 		indio_dev->name = name;
 	else
 		indio_dev->name = dev_name(dev);
-	indio_dev->channels = inv_mpu_channels;
-	indio_dev->num_channels = ARRAY_SIZE(inv_mpu_channels);
+
+	if (chip_type == INV_ICM20602) {
+		indio_dev->channels = inv_icm20602_channels;
+		indio_dev->num_channels = ARRAY_SIZE(inv_icm20602_channels);
+	} else {
+		indio_dev->channels = inv_mpu_channels;
+		indio_dev->num_channels = ARRAY_SIZE(inv_mpu_channels);
+	}
 
 	indio_dev->info = &mpu_info;
 	indio_dev->modes = INDIO_BUFFER_TRIGGERED;
diff --git a/drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h b/drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h
index 325afd9f5f61..3d5fe4474378 100644
--- a/drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h
+++ b/drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h
@@ -208,6 +208,9 @@ struct inv_mpu6050_state {
 #define INV_MPU6050_BYTES_PER_3AXIS_SENSOR   6
 #define INV_MPU6050_FIFO_COUNT_BYTE          2
 
+/* ICM20602 FIFO samples include temperature readings */
+#define INV_ICM20602_BYTES_PER_TEMP_SENSOR   2
+
 /* mpu6500 registers */
 #define INV_MPU6500_REG_ACCEL_CONFIG_2      0x1D
 #define INV_MPU6500_REG_ACCEL_OFFSET        0x77
@@ -229,6 +232,9 @@ struct inv_mpu6050_state {
 #define INV_MPU6050_GYRO_CONFIG_FSR_SHIFT    3
 #define INV_MPU6050_ACCL_CONFIG_FSR_SHIFT    3
 
+#define INV_ICM20602_TEMP_OFFSET	     8170
+#define INV_ICM20602_TEMP_SCALE		     3060
+
 /* 6 + 6 round up and plus 8 */
 #define INV_MPU6050_OUTPUT_DATA_SIZE         24
 
@@ -270,7 +276,7 @@ struct inv_mpu6050_state {
 #define INV_ICM20608_WHOAMI_VALUE		0xAF
 #define INV_ICM20602_WHOAMI_VALUE		0x12
 
-/* scan element definition */
+/* scan element definition for generic MPU6xxx devices */
 enum inv_mpu6050_scan {
 	INV_MPU6050_SCAN_ACCL_X,
 	INV_MPU6050_SCAN_ACCL_Y,
@@ -281,6 +287,18 @@ enum inv_mpu6050_scan {
 	INV_MPU6050_SCAN_TIMESTAMP,
 };
 
+/* scan element definition for ICM20602, which includes temperature */
+enum inv_icm20602_scan {
+	INV_ICM20602_SCAN_ACCL_X,
+	INV_ICM20602_SCAN_ACCL_Y,
+	INV_ICM20602_SCAN_ACCL_Z,
+	INV_ICM20602_SCAN_TEMP,
+	INV_ICM20602_SCAN_GYRO_X,
+	INV_ICM20602_SCAN_GYRO_Y,
+	INV_ICM20602_SCAN_GYRO_Z,
+	INV_ICM20602_SCAN_TIMESTAMP,
+};
+
 enum inv_mpu6050_filter_e {
 	INV_MPU6050_FILTER_256HZ_NOLPF2 = 0,
 	INV_MPU6050_FILTER_188HZ,
diff --git a/drivers/iio/imu/inv_mpu6050/inv_mpu_ring.c b/drivers/iio/imu/inv_mpu6050/inv_mpu_ring.c
index 548e042f7b5b..57bd11bde56b 100644
--- a/drivers/iio/imu/inv_mpu6050/inv_mpu_ring.c
+++ b/drivers/iio/imu/inv_mpu6050/inv_mpu_ring.c
@@ -207,6 +207,9 @@ irqreturn_t inv_mpu6050_read_fifo(int irq, void *p)
 	if (st->chip_config.gyro_fifo_enable)
 		bytes_per_datum += INV_MPU6050_BYTES_PER_3AXIS_SENSOR;
 
+	if (st->chip_type == INV_ICM20602)
+		bytes_per_datum += INV_ICM20602_BYTES_PER_TEMP_SENSOR;
+
 	/*
 	 * read fifo_count register to know how many bytes are inside the FIFO
 	 * right now
-- 
2.20.1

