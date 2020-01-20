Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F139514277E
	for <lists+stable@lfdr.de>; Mon, 20 Jan 2020 10:42:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726421AbgATJml (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jan 2020 04:42:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:55286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726130AbgATJml (ORCPT <rfc822;Stable@vger.kernel.org>);
        Mon, 20 Jan 2020 04:42:41 -0500
Received: from localhost (unknown [89.205.136.67])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E2951207E0;
        Mon, 20 Jan 2020 09:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579513360;
        bh=ds+b1mTQi9cNmnqa7BFS4/i4W6vfYkV3fr5ELCtipJI=;
        h=Subject:To:From:Date:From;
        b=s9l/e4rshfsKBURuYhEszONWJPug9yMbLtVFgS+qqqaKC042ysRgzApu30C/Tbl4K
         mqoaSaJ3SP2+9CoYCBiXbiQ9wJyNUqVpkyOUK2Pa5cHl16+fLtPDCUi+jbdZvlOHiD
         KW2mes17MJCrvmHcqZxAlFF1DVBUO+cCUvWggP3k=
Subject: patch "iio: st_gyro: Correct data for LSM9DS0 gyro" added to staging-next
To:     andriy.shevchenko@linux.intel.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, leonard.crestez@nxp.com,
        lorenzo.bianconi83@gmail.com
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Jan 2020 10:42:07 +0100
Message-ID: <157951332720498@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: st_gyro: Correct data for LSM9DS0 gyro

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From e825070f697abddf3b9b0a675ed0ff1884114818 Mon Sep 17 00:00:00 2001
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Date: Tue, 17 Dec 2019 19:10:38 +0200
Subject: iio: st_gyro: Correct data for LSM9DS0 gyro

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
---
 drivers/iio/gyro/st_gyro_core.c | 75 ++++++++++++++++++++++++++++++++-
 1 file changed, 74 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/gyro/st_gyro_core.c b/drivers/iio/gyro/st_gyro_core.c
index 57be68b291fa..26c50b24bc08 100644
--- a/drivers/iio/gyro/st_gyro_core.c
+++ b/drivers/iio/gyro/st_gyro_core.c
@@ -138,7 +138,6 @@ static const struct st_sensor_settings st_gyro_sensors_settings[] = {
 			[2] = LSM330DLC_GYRO_DEV_NAME,
 			[3] = L3G4IS_GYRO_DEV_NAME,
 			[4] = LSM330_GYRO_DEV_NAME,
-			[5] = LSM9DS0_GYRO_DEV_NAME,
 		},
 		.ch = (struct iio_chan_spec *)st_gyro_16bit_channels,
 		.odr = {
@@ -208,6 +207,80 @@ static const struct st_sensor_settings st_gyro_sensors_settings[] = {
 		.multi_read_bit = true,
 		.bootime = 2,
 	},
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
+			.addr = 0x23,
+			.value = BIT(0),
+		},
+		.multi_read_bit = true,
+		.bootime = 2,
+	},
 	{
 		.wai = 0xd7,
 		.wai_addr = ST_SENSORS_DEFAULT_WAI_ADDRESS,
-- 
2.25.0


