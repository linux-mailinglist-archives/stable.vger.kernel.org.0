Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08447F7C8C
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:47:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730092AbfKKSrQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:47:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:39982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730088AbfKKSrQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:47:16 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 42851204FD;
        Mon, 11 Nov 2019 18:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498035;
        bh=s4/wBkg+YESr2cSegNSj+TZ8r3jJ7fwVhpD74JPTdKQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WTXbK3uTBrlLdW3kORnFrz7a0UicWve1myHk3ltAXwTk+MLsp5C9h8sWr3/uaEpgW
         H7qpvFgEgdVja6WwWnyia4c0FseACKibzTf2tJbLo2200LMNtRYyxoNtDi8HRpWy5l
         Pu732ontlZd+5ZiybLN4ikuZxJXZxL5Vq2dFjKA8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Randolph=20Maa=C3=9Fen?= <gaireg@gaireg.de>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 122/125] iio: imu: mpu6050: Add support for the ICM 20602 IMU
Date:   Mon, 11 Nov 2019 19:29:21 +0100
Message-Id: <20191111181456.018241247@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181438.945353076@linuxfoundation.org>
References: <20191111181438.945353076@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randolph Maaßen <gaireg@gaireg.de>

[ Upstream commit 22904bdff97839960bd98b3452a583b1daee628b ]

The Invensense ICM-20602 is a 6-axis MotionTracking device that
combines a 3-axis gyroscope and an 3-axis accelerometer. It is very
similar to the ICM-20608 imu which is already supported by the mpu6050
driver. The main difference is that the ICM-20602 has the i2c bus
disable bit in a separate register.

Signed-off-by: Randolph Maaßen <gaireg@gaireg.de>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/imu/inv_mpu6050/Kconfig        |  8 +++---
 drivers/iio/imu/inv_mpu6050/inv_mpu_core.c | 31 ++++++++++++++++++++++
 drivers/iio/imu/inv_mpu6050/inv_mpu_i2c.c  |  6 +++++
 drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h  |  8 ++++++
 drivers/iio/imu/inv_mpu6050/inv_mpu_spi.c  | 12 ++++++---
 5 files changed, 58 insertions(+), 7 deletions(-)

diff --git a/drivers/iio/imu/inv_mpu6050/Kconfig b/drivers/iio/imu/inv_mpu6050/Kconfig
index 5483b2ea754dd..d2fe9dbddda74 100644
--- a/drivers/iio/imu/inv_mpu6050/Kconfig
+++ b/drivers/iio/imu/inv_mpu6050/Kconfig
@@ -13,8 +13,8 @@ config INV_MPU6050_I2C
 	select INV_MPU6050_IIO
 	select REGMAP_I2C
 	help
-	  This driver supports the Invensense MPU6050/6500/9150 and ICM20608
-	  motion tracking devices over I2C.
+	  This driver supports the Invensense MPU6050/6500/9150 and
+	  ICM20608/20602 motion tracking devices over I2C.
 	  This driver can be built as a module. The module will be called
 	  inv-mpu6050-i2c.
 
@@ -24,7 +24,7 @@ config INV_MPU6050_SPI
 	select INV_MPU6050_IIO
 	select REGMAP_SPI
 	help
-	  This driver supports the Invensense MPU6050/6500/9150 and ICM20608
-	  motion tracking devices over SPI.
+	  This driver supports the Invensense MPU6050/6500/9150 and
+	  ICM20608/20602 motion tracking devices over SPI.
 	  This driver can be built as a module. The module will be called
 	  inv-mpu6050-spi.
diff --git a/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c b/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c
index d80ef468508a1..cb80c9e49fc7b 100644
--- a/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c
+++ b/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c
@@ -37,6 +37,29 @@ static const int gyro_scale_6050[] = {133090, 266181, 532362, 1064724};
  */
 static const int accel_scale[] = {598, 1196, 2392, 4785};
 
+static const struct inv_mpu6050_reg_map reg_set_icm20602 = {
+	.sample_rate_div	= INV_MPU6050_REG_SAMPLE_RATE_DIV,
+	.lpf                    = INV_MPU6050_REG_CONFIG,
+	.accel_lpf              = INV_MPU6500_REG_ACCEL_CONFIG_2,
+	.user_ctrl              = INV_MPU6050_REG_USER_CTRL,
+	.fifo_en                = INV_MPU6050_REG_FIFO_EN,
+	.gyro_config            = INV_MPU6050_REG_GYRO_CONFIG,
+	.accl_config            = INV_MPU6050_REG_ACCEL_CONFIG,
+	.fifo_count_h           = INV_MPU6050_REG_FIFO_COUNT_H,
+	.fifo_r_w               = INV_MPU6050_REG_FIFO_R_W,
+	.raw_gyro               = INV_MPU6050_REG_RAW_GYRO,
+	.raw_accl               = INV_MPU6050_REG_RAW_ACCEL,
+	.temperature            = INV_MPU6050_REG_TEMPERATURE,
+	.int_enable             = INV_MPU6050_REG_INT_ENABLE,
+	.int_status             = INV_MPU6050_REG_INT_STATUS,
+	.pwr_mgmt_1             = INV_MPU6050_REG_PWR_MGMT_1,
+	.pwr_mgmt_2             = INV_MPU6050_REG_PWR_MGMT_2,
+	.int_pin_cfg            = INV_MPU6050_REG_INT_PIN_CFG,
+	.accl_offset            = INV_MPU6500_REG_ACCEL_OFFSET,
+	.gyro_offset            = INV_MPU6050_REG_GYRO_OFFSET,
+	.i2c_if                 = INV_ICM20602_REG_I2C_IF,
+};
+
 static const struct inv_mpu6050_reg_map reg_set_6500 = {
 	.sample_rate_div	= INV_MPU6050_REG_SAMPLE_RATE_DIV,
 	.lpf                    = INV_MPU6050_REG_CONFIG,
@@ -57,6 +80,7 @@ static const struct inv_mpu6050_reg_map reg_set_6500 = {
 	.int_pin_cfg		= INV_MPU6050_REG_INT_PIN_CFG,
 	.accl_offset		= INV_MPU6500_REG_ACCEL_OFFSET,
 	.gyro_offset		= INV_MPU6050_REG_GYRO_OFFSET,
+	.i2c_if                 = 0,
 };
 
 static const struct inv_mpu6050_reg_map reg_set_6050 = {
@@ -77,6 +101,7 @@ static const struct inv_mpu6050_reg_map reg_set_6050 = {
 	.int_pin_cfg		= INV_MPU6050_REG_INT_PIN_CFG,
 	.accl_offset		= INV_MPU6050_REG_ACCEL_OFFSET,
 	.gyro_offset		= INV_MPU6050_REG_GYRO_OFFSET,
+	.i2c_if                 = 0,
 };
 
 static const struct inv_mpu6050_chip_config chip_config_6050 = {
@@ -139,6 +164,12 @@ static const struct inv_mpu6050_hw hw_info[] = {
 		.reg = &reg_set_6500,
 		.config = &chip_config_6050,
 	},
+	{
+		.whoami = INV_ICM20602_WHOAMI_VALUE,
+		.name = "ICM20602",
+		.reg = &reg_set_icm20602,
+		.config = &chip_config_6050,
+	},
 };
 
 int inv_mpu6050_switch_engine(struct inv_mpu6050_state *st, bool en, u32 mask)
diff --git a/drivers/iio/imu/inv_mpu6050/inv_mpu_i2c.c b/drivers/iio/imu/inv_mpu6050/inv_mpu_i2c.c
index dd758e3d403da..e46eb4ddea210 100644
--- a/drivers/iio/imu/inv_mpu6050/inv_mpu_i2c.c
+++ b/drivers/iio/imu/inv_mpu6050/inv_mpu_i2c.c
@@ -127,6 +127,7 @@ static int inv_mpu_probe(struct i2c_client *client,
 	st = iio_priv(dev_get_drvdata(&client->dev));
 	switch (st->chip_type) {
 	case INV_ICM20608:
+	case INV_ICM20602:
 		/* no i2c auxiliary bus on the chip */
 		break;
 	default:
@@ -179,6 +180,7 @@ static const struct i2c_device_id inv_mpu_id[] = {
 	{"mpu9250", INV_MPU9250},
 	{"mpu9255", INV_MPU9255},
 	{"icm20608", INV_ICM20608},
+	{"icm20602", INV_ICM20602},
 	{}
 };
 
@@ -213,6 +215,10 @@ static const struct of_device_id inv_of_match[] = {
 		.compatible = "invensense,icm20608",
 		.data = (void *)INV_ICM20608
 	},
+	{
+		.compatible = "invensense,icm20602",
+		.data = (void *)INV_ICM20602
+	},
 	{ }
 };
 MODULE_DEVICE_TABLE(of, inv_of_match);
diff --git a/drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h b/drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h
index e69a59659dbcf..bdbaf6e01ce3e 100644
--- a/drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h
+++ b/drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h
@@ -44,6 +44,7 @@
  *  @int_pin_cfg;	Controls interrupt pin configuration.
  *  @accl_offset:	Controls the accelerometer calibration offset.
  *  @gyro_offset:	Controls the gyroscope calibration offset.
+ *  @i2c_if:		Controls the i2c interface
  */
 struct inv_mpu6050_reg_map {
 	u8 sample_rate_div;
@@ -65,6 +66,7 @@ struct inv_mpu6050_reg_map {
 	u8 int_pin_cfg;
 	u8 accl_offset;
 	u8 gyro_offset;
+	u8 i2c_if;
 };
 
 /*device enum */
@@ -77,6 +79,7 @@ enum inv_devices {
 	INV_MPU9250,
 	INV_MPU9255,
 	INV_ICM20608,
+	INV_ICM20602,
 	INV_NUM_PARTS
 };
 
@@ -193,6 +196,10 @@ struct inv_mpu6050_state {
 #define INV_MPU6050_BIT_PWR_ACCL_STBY       0x38
 #define INV_MPU6050_BIT_PWR_GYRO_STBY       0x07
 
+/* ICM20602 register */
+#define INV_ICM20602_REG_I2C_IF             0x70
+#define INV_ICM20602_BIT_I2C_IF_DIS         0x40
+
 #define INV_MPU6050_REG_FIFO_COUNT_H        0x72
 #define INV_MPU6050_REG_FIFO_R_W            0x74
 
@@ -259,6 +266,7 @@ struct inv_mpu6050_state {
 #define INV_MPU9255_WHOAMI_VALUE		0x73
 #define INV_MPU6515_WHOAMI_VALUE		0x74
 #define INV_ICM20608_WHOAMI_VALUE		0xAF
+#define INV_ICM20602_WHOAMI_VALUE		0x12
 
 /* scan element definition */
 enum inv_mpu6050_scan {
diff --git a/drivers/iio/imu/inv_mpu6050/inv_mpu_spi.c b/drivers/iio/imu/inv_mpu6050/inv_mpu_spi.c
index 227f50afff22f..a112c3f45f748 100644
--- a/drivers/iio/imu/inv_mpu6050/inv_mpu_spi.c
+++ b/drivers/iio/imu/inv_mpu6050/inv_mpu_spi.c
@@ -31,9 +31,14 @@ static int inv_mpu_i2c_disable(struct iio_dev *indio_dev)
 	if (ret)
 		return ret;
 
-	st->chip_config.user_ctrl |= INV_MPU6050_BIT_I2C_IF_DIS;
-	ret = regmap_write(st->map, st->reg->user_ctrl,
-			   st->chip_config.user_ctrl);
+	if (st->reg->i2c_if) {
+		ret = regmap_write(st->map, st->reg->i2c_if,
+				   INV_ICM20602_BIT_I2C_IF_DIS);
+	} else {
+		st->chip_config.user_ctrl |= INV_MPU6050_BIT_I2C_IF_DIS;
+		ret = regmap_write(st->map, st->reg->user_ctrl,
+				   st->chip_config.user_ctrl);
+	}
 	if (ret) {
 		inv_mpu6050_set_power_itg(st, false);
 		return ret;
@@ -81,6 +86,7 @@ static const struct spi_device_id inv_mpu_id[] = {
 	{"mpu9250", INV_MPU9250},
 	{"mpu9255", INV_MPU9255},
 	{"icm20608", INV_ICM20608},
+	{"icm20602", INV_ICM20602},
 	{}
 };
 
-- 
2.20.1



