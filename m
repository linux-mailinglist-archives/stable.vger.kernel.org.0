Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1159D14E142
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 19:43:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730461AbgA3Smt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 13:42:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:51234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730456AbgA3Smr (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 13:42:47 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 30F80205F4;
        Thu, 30 Jan 2020 18:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580409766;
        bh=LB/jhMm8iYGqv+XZf8uTtmFGIWRKm6uVsonSPnVWzv4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FvHTDQ2Ebt9dsQ9UyjM/it7bxC6jkiwiA7GEunn+g5dKTMF82493nYS76PhJ/qvtM
         C9jKqEOfVIdcqVx9iSCyq2ZkbR9+XlvPxZPj5t3PLDwjii4UhwYFk4BHNekIm0n4rr
         zC6YJETarZVn1tP/jSqac7R1/sbUcZio+7ZnMYPY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leonard Crestez <leonard.crestez@nxp.com>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.4 025/110] iio: st_gyro: Correct data for LSM9DS0 gyro
Date:   Thu, 30 Jan 2020 19:38:01 +0100
Message-Id: <20200130183618.066414861@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200130183613.810054545@linuxfoundation.org>
References: <20200130183613.810054545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit e825070f697abddf3b9b0a675ed0ff1884114818 upstream.

The commit 41c128cb25ce ("iio: st_gyro: Add lsm9ds0-gyro support")
assumes that gyro in LSM9DS0 is the same as others with 0xd4 WAI ID,
but datasheet tells slight different story, i.e. the first scale factor
for the chip is 245 dps, and not 250 dps.

Correct this by introducing a separate settings for LSM9DS0.

Fixes: 41c128cb25ce ("iio: st_gyro: Add lsm9ds0-gyro support")
Depends-on: 45a4e4220bf4 ("iio: gyro: st_gyro: fix L3GD20H support")
Cc: Leonard Crestez <leonard.crestez@nxp.com>
Cc: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/gyro/st_gyro_core.c |   75 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 74 insertions(+), 1 deletion(-)

--- a/drivers/iio/gyro/st_gyro_core.c
+++ b/drivers/iio/gyro/st_gyro_core.c
@@ -139,7 +139,6 @@ static const struct st_sensor_settings s
 			[2] = LSM330DLC_GYRO_DEV_NAME,
 			[3] = L3G4IS_GYRO_DEV_NAME,
 			[4] = LSM330_GYRO_DEV_NAME,
-			[5] = LSM9DS0_GYRO_DEV_NAME,
 		},
 		.ch = (struct iio_chan_spec *)st_gyro_16bit_channels,
 		.odr = {
@@ -203,6 +202,80 @@ static const struct st_sensor_settings s
 			},
 		},
 		.sim = {
+			.addr = 0x23,
+			.value = BIT(0),
+		},
+		.multi_read_bit = true,
+		.bootime = 2,
+	},
+	{
+		.wai = 0xd4,
+		.wai_addr = ST_SENSORS_DEFAULT_WAI_ADDRESS,
+		.sensors_supported = {
+			[0] = LSM9DS0_GYRO_DEV_NAME,
+		},
+		.ch = (struct iio_chan_spec *)st_gyro_16bit_channels,
+		.odr = {
+			.addr = 0x20,
+			.mask = GENMASK(7, 6),
+			.odr_avl = {
+				{ .hz = 95, .value = 0x00, },
+				{ .hz = 190, .value = 0x01, },
+				{ .hz = 380, .value = 0x02, },
+				{ .hz = 760, .value = 0x03, },
+			},
+		},
+		.pw = {
+			.addr = 0x20,
+			.mask = BIT(3),
+			.value_on = ST_SENSORS_DEFAULT_POWER_ON_VALUE,
+			.value_off = ST_SENSORS_DEFAULT_POWER_OFF_VALUE,
+		},
+		.enable_axis = {
+			.addr = ST_SENSORS_DEFAULT_AXIS_ADDR,
+			.mask = ST_SENSORS_DEFAULT_AXIS_MASK,
+		},
+		.fs = {
+			.addr = 0x23,
+			.mask = GENMASK(5, 4),
+			.fs_avl = {
+				[0] = {
+					.num = ST_GYRO_FS_AVL_245DPS,
+					.value = 0x00,
+					.gain = IIO_DEGREE_TO_RAD(8750),
+				},
+				[1] = {
+					.num = ST_GYRO_FS_AVL_500DPS,
+					.value = 0x01,
+					.gain = IIO_DEGREE_TO_RAD(17500),
+				},
+				[2] = {
+					.num = ST_GYRO_FS_AVL_2000DPS,
+					.value = 0x02,
+					.gain = IIO_DEGREE_TO_RAD(70000),
+				},
+			},
+		},
+		.bdu = {
+			.addr = 0x23,
+			.mask = BIT(7),
+		},
+		.drdy_irq = {
+			.int2 = {
+				.addr = 0x22,
+				.mask = BIT(3),
+			},
+			/*
+			 * The sensor has IHL (active low) and open
+			 * drain settings, but only for INT1 and not
+			 * for the DRDY line on INT2.
+			 */
+			.stat_drdy = {
+				.addr = ST_SENSORS_DEFAULT_STAT_ADDR,
+				.mask = GENMASK(2, 0),
+			},
+		},
+		.sim = {
 			.addr = 0x23,
 			.value = BIT(0),
 		},


