Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E34E58C9A2
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 04:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727254AbfHNCkH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Aug 2019 22:40:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:43372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727206AbfHNCLK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Aug 2019 22:11:10 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4567420842;
        Wed, 14 Aug 2019 02:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565748669;
        bh=v8JNMx8s3Mg4rx4naATw4/h6FoQvpnPlHvb9F9IPm6Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KQnvMBRG8uJYZEIFM1N6JEaGouD1SBiPVQjo5nNsjvaAm5MwIezut+KmlzlnOlBI9
         sIWcgkwPuO9OoXkbpaFW5qjCKgTM6RSVdZpJKy7CWnvmb1gYH9thR8P38p9AEDwg7b
         83sPZDGoaY1heFBIVyZbWGUbvZC317dpWNk47bIM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jean-Baptiste Maneyrol <JManeyrol@invensense.com>,
        Jean-Baptiste Maneyrol <jmaneyrol@invensense.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>, linux-iio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 010/123] iio: imu: mpu6050: add missing available scan masks
Date:   Tue, 13 Aug 2019 22:08:54 -0400
Message-Id: <20190814021047.14828-10-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190814021047.14828-1-sashal@kernel.org>
References: <20190814021047.14828-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jean-Baptiste Maneyrol <JManeyrol@invensense.com>

[ Upstream commit 1244a720572fd1680ac8d6b8a4235f2e8557b810 ]

Driver only supports 3-axis gyro and/or 3-axis accel.
For icm20602, temp data is mandatory for all configurations.

Fix all single and double axis configurations (almost never used) and more
importantly fix 3-axis gyro and 6-axis accel+gyro buffer on icm20602 when
temp data is not enabled.

Signed-off-by: Jean-Baptiste Maneyrol <jmaneyrol@invensense.com>
Fixes: 1615fe41a195 ("iio: imu: mpu6050: Fix FIFO layout for ICM20602")
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/imu/inv_mpu6050/inv_mpu_core.c | 43 ++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c b/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c
index 53a59957cc542..8a704cd5bddb7 100644
--- a/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c
+++ b/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c
@@ -845,6 +845,25 @@ static const struct iio_chan_spec inv_mpu_channels[] = {
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
@@ -871,6 +890,28 @@ static const struct iio_chan_spec inv_icm20602_channels[] = {
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
@@ -1130,9 +1171,11 @@ int inv_mpu_core_probe(struct regmap *regmap, int irq, const char *name,
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
-- 
2.20.1

