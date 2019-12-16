Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA4C3121724
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:34:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729901AbfLPSJX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:09:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:51690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730421AbfLPSJX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:09:23 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C286020700;
        Mon, 16 Dec 2019 18:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519762;
        bh=/bBkpj/F3ZwXWjQY5nUxoKATenydqRn2h2TIb9D/wI0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Po88gL3Go2H68ATpUc0jjm0/f8bdNeznBvXnpHYVx/yAk3WE0ncnHjjSkkpyGI/LN
         NP8FzWWjiqNQ2CdDI9WEQ4iJqsDyScCPJ/xIXaeMDyQakpwSOI8C7zGXbXobm851x5
         wpUb+pqJnyYZEHBZPrQHqelHKz+oYQ6g3u2OI7/c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jean-Baptiste Maneyrol <jmaneyrol@invensense.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.3 031/180] iio: imu: inv_mpu6050: fix temperature reporting using bad unit
Date:   Mon, 16 Dec 2019 18:47:51 +0100
Message-Id: <20191216174813.414503149@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174806.018988360@linuxfoundation.org>
References: <20191216174806.018988360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jean-Baptiste Maneyrol <jmaneyrol@invensense.com>

commit 53eaa9c27fdc01b4f4d885223e29f97393409e7e upstream.

Temperature should be reported in milli-degrees, not degrees. Fix
scale and offset values to use the correct unit.

This is a fix for an issue that has been present for a long time.
The fixes tag reflects the point at which the code last changed in a
fashion that would make this fix patch no longer apply.  Backports
will be necessary to fix those elements that predate that patch.

Fixes: 1615fe41a195 ("iio: imu: mpu6050: Fix FIFO layout for ICM20602")
Cc: stable@vger.kernel.org
Signed-off-by: Jean-Baptiste Maneyrol <jmaneyrol@invensense.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/imu/inv_mpu6050/inv_mpu_core.c |   23 ++++++++++++-----------
 drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h  |   16 ++++++++++++----
 2 files changed, 24 insertions(+), 15 deletions(-)

--- a/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c
+++ b/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c
@@ -115,6 +115,7 @@ static const struct inv_mpu6050_hw hw_in
 		.reg = &reg_set_6050,
 		.config = &chip_config_6050,
 		.fifo_size = 1024,
+		.temp = {INV_MPU6050_TEMP_OFFSET, INV_MPU6050_TEMP_SCALE},
 	},
 	{
 		.whoami = INV_MPU6500_WHOAMI_VALUE,
@@ -122,6 +123,7 @@ static const struct inv_mpu6050_hw hw_in
 		.reg = &reg_set_6500,
 		.config = &chip_config_6050,
 		.fifo_size = 512,
+		.temp = {INV_MPU6500_TEMP_OFFSET, INV_MPU6500_TEMP_SCALE},
 	},
 	{
 		.whoami = INV_MPU6515_WHOAMI_VALUE,
@@ -129,6 +131,7 @@ static const struct inv_mpu6050_hw hw_in
 		.reg = &reg_set_6500,
 		.config = &chip_config_6050,
 		.fifo_size = 512,
+		.temp = {INV_MPU6500_TEMP_OFFSET, INV_MPU6500_TEMP_SCALE},
 	},
 	{
 		.whoami = INV_MPU6000_WHOAMI_VALUE,
@@ -136,6 +139,7 @@ static const struct inv_mpu6050_hw hw_in
 		.reg = &reg_set_6050,
 		.config = &chip_config_6050,
 		.fifo_size = 1024,
+		.temp = {INV_MPU6050_TEMP_OFFSET, INV_MPU6050_TEMP_SCALE},
 	},
 	{
 		.whoami = INV_MPU9150_WHOAMI_VALUE,
@@ -143,6 +147,7 @@ static const struct inv_mpu6050_hw hw_in
 		.reg = &reg_set_6050,
 		.config = &chip_config_6050,
 		.fifo_size = 1024,
+		.temp = {INV_MPU6050_TEMP_OFFSET, INV_MPU6050_TEMP_SCALE},
 	},
 	{
 		.whoami = INV_MPU9250_WHOAMI_VALUE,
@@ -150,6 +155,7 @@ static const struct inv_mpu6050_hw hw_in
 		.reg = &reg_set_6500,
 		.config = &chip_config_6050,
 		.fifo_size = 512,
+		.temp = {INV_MPU6500_TEMP_OFFSET, INV_MPU6500_TEMP_SCALE},
 	},
 	{
 		.whoami = INV_MPU9255_WHOAMI_VALUE,
@@ -157,6 +163,7 @@ static const struct inv_mpu6050_hw hw_in
 		.reg = &reg_set_6500,
 		.config = &chip_config_6050,
 		.fifo_size = 512,
+		.temp = {INV_MPU6500_TEMP_OFFSET, INV_MPU6500_TEMP_SCALE},
 	},
 	{
 		.whoami = INV_ICM20608_WHOAMI_VALUE,
@@ -164,6 +171,7 @@ static const struct inv_mpu6050_hw hw_in
 		.reg = &reg_set_6500,
 		.config = &chip_config_6050,
 		.fifo_size = 512,
+		.temp = {INV_ICM20608_TEMP_OFFSET, INV_ICM20608_TEMP_SCALE},
 	},
 	{
 		.whoami = INV_ICM20602_WHOAMI_VALUE,
@@ -171,6 +179,7 @@ static const struct inv_mpu6050_hw hw_in
 		.reg = &reg_set_icm20602,
 		.config = &chip_config_6050,
 		.fifo_size = 1008,
+		.temp = {INV_ICM20608_TEMP_OFFSET, INV_ICM20608_TEMP_SCALE},
 	},
 };
 
@@ -471,12 +480,8 @@ inv_mpu6050_read_raw(struct iio_dev *ind
 
 			return IIO_VAL_INT_PLUS_MICRO;
 		case IIO_TEMP:
-			*val = 0;
-			if (st->chip_type == INV_ICM20602)
-				*val2 = INV_ICM20602_TEMP_SCALE;
-			else
-				*val2 = INV_MPU6050_TEMP_SCALE;
-
+			*val = st->hw->temp.scale / 1000000;
+			*val2 = st->hw->temp.scale % 1000000;
 			return IIO_VAL_INT_PLUS_MICRO;
 		default:
 			return -EINVAL;
@@ -484,11 +489,7 @@ inv_mpu6050_read_raw(struct iio_dev *ind
 	case IIO_CHAN_INFO_OFFSET:
 		switch (chan->type) {
 		case IIO_TEMP:
-			if (st->chip_type == INV_ICM20602)
-				*val = INV_ICM20602_TEMP_OFFSET;
-			else
-				*val = INV_MPU6050_TEMP_OFFSET;
-
+			*val = st->hw->temp.offset;
 			return IIO_VAL_INT;
 		default:
 			return -EINVAL;
--- a/drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h
+++ b/drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h
@@ -101,6 +101,7 @@ struct inv_mpu6050_chip_config {
  *  @reg:   register map of the chip.
  *  @config:    configuration of the chip.
  *  @fifo_size:	size of the FIFO in bytes.
+ *  @temp:	offset and scale to apply to raw temperature.
  */
 struct inv_mpu6050_hw {
 	u8 whoami;
@@ -108,6 +109,10 @@ struct inv_mpu6050_hw {
 	const struct inv_mpu6050_reg_map *reg;
 	const struct inv_mpu6050_chip_config *config;
 	size_t fifo_size;
+	struct {
+		int offset;
+		int scale;
+	} temp;
 };
 
 /*
@@ -218,16 +223,19 @@ struct inv_mpu6050_state {
 #define INV_MPU6050_REG_UP_TIME_MIN          5000
 #define INV_MPU6050_REG_UP_TIME_MAX          10000
 
-#define INV_MPU6050_TEMP_OFFSET	             12421
-#define INV_MPU6050_TEMP_SCALE               2941
+#define INV_MPU6050_TEMP_OFFSET	             12420
+#define INV_MPU6050_TEMP_SCALE               2941176
 #define INV_MPU6050_MAX_GYRO_FS_PARAM        3
 #define INV_MPU6050_MAX_ACCL_FS_PARAM        3
 #define INV_MPU6050_THREE_AXIS               3
 #define INV_MPU6050_GYRO_CONFIG_FSR_SHIFT    3
 #define INV_MPU6050_ACCL_CONFIG_FSR_SHIFT    3
 
-#define INV_ICM20602_TEMP_OFFSET	     8170
-#define INV_ICM20602_TEMP_SCALE		     3060
+#define INV_MPU6500_TEMP_OFFSET              7011
+#define INV_MPU6500_TEMP_SCALE               2995178
+
+#define INV_ICM20608_TEMP_OFFSET	     8170
+#define INV_ICM20608_TEMP_SCALE		     3059976
 
 /* 6 + 6 round up and plus 8 */
 #define INV_MPU6050_OUTPUT_DATA_SIZE         24


