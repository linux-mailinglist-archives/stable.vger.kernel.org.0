Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A5AC77EC9
	for <lists+stable@lfdr.de>; Sun, 28 Jul 2019 11:28:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725977AbfG1J23 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Jul 2019 05:28:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:40930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725937AbfG1J23 (ORCPT <rfc822;Stable@vger.kernel.org>);
        Sun, 28 Jul 2019 05:28:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF12E214C6;
        Sun, 28 Jul 2019 09:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564306108;
        bh=/WjVstEIPSB6QKQQ/lvXwSBldUWfA/J1o8rESDxJh8g=;
        h=Subject:To:From:Date:From;
        b=ZAzDQWHdk/bvDJMr4+IQb1K9jQ2eGEmPfmC6swEACGVG/7ZUAgucRbUmfBW9Tn3gP
         PqPYGf4GuiPLVG5McsoKciu3MDP4Hg+kvp+/CQGvso/jbHbwgxuqb5sZ++I8z+7/Ja
         gYrSZC3nvHBTYuhliO4RxL0KfwQtv5W52YY0twB0=
Subject: patch "iio: imu: mpu6050: add missing available scan masks" added to staging-linus
To:     JManeyrol@invensense.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, jmaneyrol@invensense.com
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 28 Jul 2019 11:28:21 +0200
Message-ID: <1564306101211158@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: imu: mpu6050: add missing available scan masks

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 1244a720572fd1680ac8d6b8a4235f2e8557b810 Mon Sep 17 00:00:00 2001
From: Jean-Baptiste Maneyrol <JManeyrol@invensense.com>
Date: Thu, 27 Jun 2019 13:19:53 +0000
Subject: iio: imu: mpu6050: add missing available scan masks

Driver only supports 3-axis gyro and/or 3-axis accel.
For icm20602, temp data is mandatory for all configurations.

Fix all single and double axis configurations (almost never used) and more
importantly fix 3-axis gyro and 6-axis accel+gyro buffer on icm20602 when
temp data is not enabled.

Signed-off-by: Jean-Baptiste Maneyrol <jmaneyrol@invensense.com>
Fixes: 1615fe41a195 ("iio: imu: mpu6050: Fix FIFO layout for ICM20602")
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/imu/inv_mpu6050/inv_mpu_core.c | 43 ++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c b/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c
index 53a59957cc54..8a704cd5bddb 100644
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
2.22.0


