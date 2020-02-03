Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CA0D150E0D
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:50:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728637AbgBCQZm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:25:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:36426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728627AbgBCQZl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:25:41 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 217AA2086A;
        Mon,  3 Feb 2020 16:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747140;
        bh=ec1kGG7zpDr102FKDa9SS42NmIToMcZX3w0XRmrtsDY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zua7z6BpFlOqQ0CRDuVEdrOhbiiOk5c1g4PZgMfY46e1901zbOWsg4VGg3mIEKwFw
         mU+Nnd9yR2I0Abx2l91M61X5u4dfIxnQ+K9tQDYxBmMoUKrTSO6sdZkoRF46aBcYCP
         GDQCsufnbaBLQospKWv83tBKNrEGtGuCjzLRzL7A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Jonathan Cameron <jic23@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 28/68] iio: gyro: st_gyro: inline per-sensor data
Date:   Mon,  3 Feb 2020 16:19:24 +0000
Message-Id: <20200203161909.663307230@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161904.705434837@linuxfoundation.org>
References: <20200203161904.705434837@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit d8594fa22a3f7c294639d9aa2959d63e66d9437c ]

We have #defines for all the individual sensor registers and
value/mask pairs #defined at the top of the file and used at
exactly one spot.

This is usually good if the #defines give a meaning to the
opaque magic numbers.

However in this case, the semantic meaning is inherent in the
name of the C99-addressable fields, and that means duplication
of information, and only makes the code hard to maintain since
you every time have to add a new #define AND update the site
where it is to be used.

Get rid of the #defines and just open code the values into the
appropriate struct elements. Make sure to explicitly address
the .hz and .value fields in the st_sensor_odr_avl struct
so that the meaning of all values is clear.

This patch is purely syntactic should have no semantic effect.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/gyro/st_gyro_core.c | 205 ++++++++++----------------------
 1 file changed, 66 insertions(+), 139 deletions(-)

diff --git a/drivers/iio/gyro/st_gyro_core.c b/drivers/iio/gyro/st_gyro_core.c
index aea034d8fe0fb..2a42b3d583e85 100644
--- a/drivers/iio/gyro/st_gyro_core.c
+++ b/drivers/iio/gyro/st_gyro_core.c
@@ -39,79 +39,6 @@
 #define ST_GYRO_FS_AVL_500DPS			500
 #define ST_GYRO_FS_AVL_2000DPS			2000
 
-/* CUSTOM VALUES FOR SENSOR 1 */
-#define ST_GYRO_1_WAI_EXP			0xd3
-#define ST_GYRO_1_ODR_ADDR			0x20
-#define ST_GYRO_1_ODR_MASK			0xc0
-#define ST_GYRO_1_ODR_AVL_100HZ_VAL		0x00
-#define ST_GYRO_1_ODR_AVL_200HZ_VAL		0x01
-#define ST_GYRO_1_ODR_AVL_400HZ_VAL		0x02
-#define ST_GYRO_1_ODR_AVL_800HZ_VAL		0x03
-#define ST_GYRO_1_PW_ADDR			0x20
-#define ST_GYRO_1_PW_MASK			0x08
-#define ST_GYRO_1_FS_ADDR			0x23
-#define ST_GYRO_1_FS_MASK			0x30
-#define ST_GYRO_1_FS_AVL_250_VAL		0x00
-#define ST_GYRO_1_FS_AVL_500_VAL		0x01
-#define ST_GYRO_1_FS_AVL_2000_VAL		0x02
-#define ST_GYRO_1_FS_AVL_250_GAIN		IIO_DEGREE_TO_RAD(8750)
-#define ST_GYRO_1_FS_AVL_500_GAIN		IIO_DEGREE_TO_RAD(17500)
-#define ST_GYRO_1_FS_AVL_2000_GAIN		IIO_DEGREE_TO_RAD(70000)
-#define ST_GYRO_1_BDU_ADDR			0x23
-#define ST_GYRO_1_BDU_MASK			0x80
-#define ST_GYRO_1_DRDY_IRQ_ADDR			0x22
-#define ST_GYRO_1_DRDY_IRQ_INT2_MASK		0x08
-#define ST_GYRO_1_MULTIREAD_BIT			true
-
-/* CUSTOM VALUES FOR SENSOR 2 */
-#define ST_GYRO_2_WAI_EXP			0xd4
-#define ST_GYRO_2_ODR_ADDR			0x20
-#define ST_GYRO_2_ODR_MASK			0xc0
-#define ST_GYRO_2_ODR_AVL_95HZ_VAL		0x00
-#define ST_GYRO_2_ODR_AVL_190HZ_VAL		0x01
-#define ST_GYRO_2_ODR_AVL_380HZ_VAL		0x02
-#define ST_GYRO_2_ODR_AVL_760HZ_VAL		0x03
-#define ST_GYRO_2_PW_ADDR			0x20
-#define ST_GYRO_2_PW_MASK			0x08
-#define ST_GYRO_2_FS_ADDR			0x23
-#define ST_GYRO_2_FS_MASK			0x30
-#define ST_GYRO_2_FS_AVL_250_VAL		0x00
-#define ST_GYRO_2_FS_AVL_500_VAL		0x01
-#define ST_GYRO_2_FS_AVL_2000_VAL		0x02
-#define ST_GYRO_2_FS_AVL_250_GAIN		IIO_DEGREE_TO_RAD(8750)
-#define ST_GYRO_2_FS_AVL_500_GAIN		IIO_DEGREE_TO_RAD(17500)
-#define ST_GYRO_2_FS_AVL_2000_GAIN		IIO_DEGREE_TO_RAD(70000)
-#define ST_GYRO_2_BDU_ADDR			0x23
-#define ST_GYRO_2_BDU_MASK			0x80
-#define ST_GYRO_2_DRDY_IRQ_ADDR			0x22
-#define ST_GYRO_2_DRDY_IRQ_INT2_MASK		0x08
-#define ST_GYRO_2_MULTIREAD_BIT			true
-
-/* CUSTOM VALUES FOR SENSOR 3 */
-#define ST_GYRO_3_WAI_EXP			0xd7
-#define ST_GYRO_3_ODR_ADDR			0x20
-#define ST_GYRO_3_ODR_MASK			0xc0
-#define ST_GYRO_3_ODR_AVL_95HZ_VAL		0x00
-#define ST_GYRO_3_ODR_AVL_190HZ_VAL		0x01
-#define ST_GYRO_3_ODR_AVL_380HZ_VAL		0x02
-#define ST_GYRO_3_ODR_AVL_760HZ_VAL		0x03
-#define ST_GYRO_3_PW_ADDR			0x20
-#define ST_GYRO_3_PW_MASK			0x08
-#define ST_GYRO_3_FS_ADDR			0x23
-#define ST_GYRO_3_FS_MASK			0x30
-#define ST_GYRO_3_FS_AVL_250_VAL		0x00
-#define ST_GYRO_3_FS_AVL_500_VAL		0x01
-#define ST_GYRO_3_FS_AVL_2000_VAL		0x02
-#define ST_GYRO_3_FS_AVL_250_GAIN		IIO_DEGREE_TO_RAD(8750)
-#define ST_GYRO_3_FS_AVL_500_GAIN		IIO_DEGREE_TO_RAD(17500)
-#define ST_GYRO_3_FS_AVL_2000_GAIN		IIO_DEGREE_TO_RAD(70000)
-#define ST_GYRO_3_BDU_ADDR			0x23
-#define ST_GYRO_3_BDU_MASK			0x80
-#define ST_GYRO_3_DRDY_IRQ_ADDR			0x22
-#define ST_GYRO_3_DRDY_IRQ_INT2_MASK		0x08
-#define ST_GYRO_3_MULTIREAD_BIT			true
-
-
 static const struct iio_chan_spec st_gyro_16bit_channels[] = {
 	ST_SENSORS_LSM_CHANNELS(IIO_ANGL_VEL,
 			BIT(IIO_CHAN_INFO_RAW) | BIT(IIO_CHAN_INFO_SCALE),
@@ -130,7 +57,7 @@ static const struct iio_chan_spec st_gyro_16bit_channels[] = {
 
 static const struct st_sensor_settings st_gyro_sensors_settings[] = {
 	{
-		.wai = ST_GYRO_1_WAI_EXP,
+		.wai = 0xd3,
 		.wai_addr = ST_SENSORS_DEFAULT_WAI_ADDRESS,
 		.sensors_supported = {
 			[0] = L3G4200D_GYRO_DEV_NAME,
@@ -138,18 +65,18 @@ static const struct st_sensor_settings st_gyro_sensors_settings[] = {
 		},
 		.ch = (struct iio_chan_spec *)st_gyro_16bit_channels,
 		.odr = {
-			.addr = ST_GYRO_1_ODR_ADDR,
-			.mask = ST_GYRO_1_ODR_MASK,
+			.addr = 0x20,
+			.mask = 0xc0,
 			.odr_avl = {
-				{ 100, ST_GYRO_1_ODR_AVL_100HZ_VAL, },
-				{ 200, ST_GYRO_1_ODR_AVL_200HZ_VAL, },
-				{ 400, ST_GYRO_1_ODR_AVL_400HZ_VAL, },
-				{ 800, ST_GYRO_1_ODR_AVL_800HZ_VAL, },
+				{ .hz = 100, .value = 0x00, },
+				{ .hz = 200, .value = 0x01, },
+				{ .hz = 400, .value = 0x02, },
+				{ .hz = 800, .value = 0x03, },
 			},
 		},
 		.pw = {
-			.addr = ST_GYRO_1_PW_ADDR,
-			.mask = ST_GYRO_1_PW_MASK,
+			.addr = 0x20,
+			.mask = 0x08,
 			.value_on = ST_SENSORS_DEFAULT_POWER_ON_VALUE,
 			.value_off = ST_SENSORS_DEFAULT_POWER_OFF_VALUE,
 		},
@@ -158,33 +85,33 @@ static const struct st_sensor_settings st_gyro_sensors_settings[] = {
 			.mask = ST_SENSORS_DEFAULT_AXIS_MASK,
 		},
 		.fs = {
-			.addr = ST_GYRO_1_FS_ADDR,
-			.mask = ST_GYRO_1_FS_MASK,
+			.addr = 0x23,
+			.mask = 0x30,
 			.fs_avl = {
 				[0] = {
 					.num = ST_GYRO_FS_AVL_250DPS,
-					.value = ST_GYRO_1_FS_AVL_250_VAL,
-					.gain = ST_GYRO_1_FS_AVL_250_GAIN,
+					.value = 0x00,
+					.gain = IIO_DEGREE_TO_RAD(8750),
 				},
 				[1] = {
 					.num = ST_GYRO_FS_AVL_500DPS,
-					.value = ST_GYRO_1_FS_AVL_500_VAL,
-					.gain = ST_GYRO_1_FS_AVL_500_GAIN,
+					.value = 0x01,
+					.gain = IIO_DEGREE_TO_RAD(17500),
 				},
 				[2] = {
 					.num = ST_GYRO_FS_AVL_2000DPS,
-					.value = ST_GYRO_1_FS_AVL_2000_VAL,
-					.gain = ST_GYRO_1_FS_AVL_2000_GAIN,
+					.value = 0x02,
+					.gain = IIO_DEGREE_TO_RAD(70000),
 				},
 			},
 		},
 		.bdu = {
-			.addr = ST_GYRO_1_BDU_ADDR,
-			.mask = ST_GYRO_1_BDU_MASK,
+			.addr = 0x23,
+			.mask = 0x80,
 		},
 		.drdy_irq = {
-			.addr = ST_GYRO_1_DRDY_IRQ_ADDR,
-			.mask_int2 = ST_GYRO_1_DRDY_IRQ_INT2_MASK,
+			.addr = 0x22,
+			.mask_int2 = 0x08,
 			/*
 			 * The sensor has IHL (active low) and open
 			 * drain settings, but only for INT1 and not
@@ -192,11 +119,11 @@ static const struct st_sensor_settings st_gyro_sensors_settings[] = {
 			 */
 			.addr_stat_drdy = ST_SENSORS_DEFAULT_STAT_ADDR,
 		},
-		.multi_read_bit = ST_GYRO_1_MULTIREAD_BIT,
+		.multi_read_bit = true,
 		.bootime = 2,
 	},
 	{
-		.wai = ST_GYRO_2_WAI_EXP,
+		.wai = 0xd4,
 		.wai_addr = ST_SENSORS_DEFAULT_WAI_ADDRESS,
 		.sensors_supported = {
 			[0] = L3GD20_GYRO_DEV_NAME,
@@ -208,18 +135,18 @@ static const struct st_sensor_settings st_gyro_sensors_settings[] = {
 		},
 		.ch = (struct iio_chan_spec *)st_gyro_16bit_channels,
 		.odr = {
-			.addr = ST_GYRO_2_ODR_ADDR,
-			.mask = ST_GYRO_2_ODR_MASK,
+			.addr = 0x20,
+			.mask = 0xc0,
 			.odr_avl = {
-				{ 95, ST_GYRO_2_ODR_AVL_95HZ_VAL, },
-				{ 190, ST_GYRO_2_ODR_AVL_190HZ_VAL, },
-				{ 380, ST_GYRO_2_ODR_AVL_380HZ_VAL, },
-				{ 760, ST_GYRO_2_ODR_AVL_760HZ_VAL, },
+				{ .hz = 95, .value = 0x00, },
+				{ .hz = 190, .value = 0x01, },
+				{ .hz = 380, .value = 0x02, },
+				{ .hz = 760, .value = 0x03, },
 			},
 		},
 		.pw = {
-			.addr = ST_GYRO_2_PW_ADDR,
-			.mask = ST_GYRO_2_PW_MASK,
+			.addr = 0x20,
+			.mask = 0x08,
 			.value_on = ST_SENSORS_DEFAULT_POWER_ON_VALUE,
 			.value_off = ST_SENSORS_DEFAULT_POWER_OFF_VALUE,
 		},
@@ -228,33 +155,33 @@ static const struct st_sensor_settings st_gyro_sensors_settings[] = {
 			.mask = ST_SENSORS_DEFAULT_AXIS_MASK,
 		},
 		.fs = {
-			.addr = ST_GYRO_2_FS_ADDR,
-			.mask = ST_GYRO_2_FS_MASK,
+			.addr = 0x23,
+			.mask = 0x30,
 			.fs_avl = {
 				[0] = {
 					.num = ST_GYRO_FS_AVL_250DPS,
-					.value = ST_GYRO_2_FS_AVL_250_VAL,
-					.gain = ST_GYRO_2_FS_AVL_250_GAIN,
+					.value = 0x00,
+					.gain = IIO_DEGREE_TO_RAD(8750),
 				},
 				[1] = {
 					.num = ST_GYRO_FS_AVL_500DPS,
-					.value = ST_GYRO_2_FS_AVL_500_VAL,
-					.gain = ST_GYRO_2_FS_AVL_500_GAIN,
+					.value = 0x01,
+					.gain = IIO_DEGREE_TO_RAD(17500),
 				},
 				[2] = {
 					.num = ST_GYRO_FS_AVL_2000DPS,
-					.value = ST_GYRO_2_FS_AVL_2000_VAL,
-					.gain = ST_GYRO_2_FS_AVL_2000_GAIN,
+					.value = 0x02,
+					.gain = IIO_DEGREE_TO_RAD(70000),
 				},
 			},
 		},
 		.bdu = {
-			.addr = ST_GYRO_2_BDU_ADDR,
-			.mask = ST_GYRO_2_BDU_MASK,
+			.addr = 0x23,
+			.mask = 0x80,
 		},
 		.drdy_irq = {
-			.addr = ST_GYRO_2_DRDY_IRQ_ADDR,
-			.mask_int2 = ST_GYRO_2_DRDY_IRQ_INT2_MASK,
+			.addr = 0x22,
+			.mask_int2 = 0x08,
 			/*
 			 * The sensor has IHL (active low) and open
 			 * drain settings, but only for INT1 and not
@@ -262,29 +189,29 @@ static const struct st_sensor_settings st_gyro_sensors_settings[] = {
 			 */
 			.addr_stat_drdy = ST_SENSORS_DEFAULT_STAT_ADDR,
 		},
-		.multi_read_bit = ST_GYRO_2_MULTIREAD_BIT,
+		.multi_read_bit = true,
 		.bootime = 2,
 	},
 	{
-		.wai = ST_GYRO_3_WAI_EXP,
+		.wai = 0xd7,
 		.wai_addr = ST_SENSORS_DEFAULT_WAI_ADDRESS,
 		.sensors_supported = {
 			[0] = L3GD20_GYRO_DEV_NAME,
 		},
 		.ch = (struct iio_chan_spec *)st_gyro_16bit_channels,
 		.odr = {
-			.addr = ST_GYRO_3_ODR_ADDR,
-			.mask = ST_GYRO_3_ODR_MASK,
+			.addr = 0x20,
+			.mask = 0xc0,
 			.odr_avl = {
-				{ 95, ST_GYRO_3_ODR_AVL_95HZ_VAL, },
-				{ 190, ST_GYRO_3_ODR_AVL_190HZ_VAL, },
-				{ 380, ST_GYRO_3_ODR_AVL_380HZ_VAL, },
-				{ 760, ST_GYRO_3_ODR_AVL_760HZ_VAL, },
+				{ .hz = 95, .value = 0x00, },
+				{ .hz = 190, .value = 0x01, },
+				{ .hz = 380, .value = 0x02, },
+				{ .hz = 760, .value = 0x03, },
 			},
 		},
 		.pw = {
-			.addr = ST_GYRO_3_PW_ADDR,
-			.mask = ST_GYRO_3_PW_MASK,
+			.addr = 0x20,
+			.mask = 0x08,
 			.value_on = ST_SENSORS_DEFAULT_POWER_ON_VALUE,
 			.value_off = ST_SENSORS_DEFAULT_POWER_OFF_VALUE,
 		},
@@ -293,33 +220,33 @@ static const struct st_sensor_settings st_gyro_sensors_settings[] = {
 			.mask = ST_SENSORS_DEFAULT_AXIS_MASK,
 		},
 		.fs = {
-			.addr = ST_GYRO_3_FS_ADDR,
-			.mask = ST_GYRO_3_FS_MASK,
+			.addr = 0x23,
+			.mask = 0x30,
 			.fs_avl = {
 				[0] = {
 					.num = ST_GYRO_FS_AVL_250DPS,
-					.value = ST_GYRO_3_FS_AVL_250_VAL,
-					.gain = ST_GYRO_3_FS_AVL_250_GAIN,
+					.value = 0x00,
+					.gain = IIO_DEGREE_TO_RAD(8750),
 				},
 				[1] = {
 					.num = ST_GYRO_FS_AVL_500DPS,
-					.value = ST_GYRO_3_FS_AVL_500_VAL,
-					.gain = ST_GYRO_3_FS_AVL_500_GAIN,
+					.value = 0x01,
+					.gain = IIO_DEGREE_TO_RAD(17500),
 				},
 				[2] = {
 					.num = ST_GYRO_FS_AVL_2000DPS,
-					.value = ST_GYRO_3_FS_AVL_2000_VAL,
-					.gain = ST_GYRO_3_FS_AVL_2000_GAIN,
+					.value = 0x02,
+					.gain = IIO_DEGREE_TO_RAD(70000),
 				},
 			},
 		},
 		.bdu = {
-			.addr = ST_GYRO_3_BDU_ADDR,
-			.mask = ST_GYRO_3_BDU_MASK,
+			.addr = 0x23,
+			.mask = 0x80,
 		},
 		.drdy_irq = {
-			.addr = ST_GYRO_3_DRDY_IRQ_ADDR,
-			.mask_int2 = ST_GYRO_3_DRDY_IRQ_INT2_MASK,
+			.addr = 0x22,
+			.mask_int2 = 0x08,
 			/*
 			 * The sensor has IHL (active low) and open
 			 * drain settings, but only for INT1 and not
@@ -327,7 +254,7 @@ static const struct st_sensor_settings st_gyro_sensors_settings[] = {
 			 */
 			.addr_stat_drdy = ST_SENSORS_DEFAULT_STAT_ADDR,
 		},
-		.multi_read_bit = ST_GYRO_3_MULTIREAD_BIT,
+		.multi_read_bit = true,
 		.bootime = 2,
 	},
 };
-- 
2.20.1



