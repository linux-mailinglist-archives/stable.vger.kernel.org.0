Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEC352A523D
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:48:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730634AbgKCUsM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:48:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:39128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731429AbgKCUsD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:48:03 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 08285223FD;
        Tue,  3 Nov 2020 20:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436482;
        bh=nqWMGVhHhMXEbtzobguTJH7MLcMFDBI6BlfZOIveW8U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VMlbMPg3hmL3Qs57R4/9ZMO6JXXe0ETqLuAirkMMVSMBszwaXbPUn0jw6fedVBnzq
         ifhD/jvOvzzIgeDsu8U5bxQktOpottRyvVOhIL+CkUyWsh9v01PIzHKe8iUFmkfgqE
         Y1Q/2rIGIV8ogDr0QiRo/XfrZ0t0D8KkOWK3bHvc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Jean-Baptiste Maneyrol <jmaneyrol@invensense.com>,
        Stable@vger.kernel.org
Subject: [PATCH 5.9 270/391] iio:imu:inv_mpu6050 Fix dma and ts alignment and data leak issues.
Date:   Tue,  3 Nov 2020 21:35:21 +0100
Message-Id: <20201103203405.249079624@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

commit 6b0cc5dce0725ae8f1a2883514da731c55eeb35e upstream.

This case is a bit different to the rest of the series.  The driver
was doing a regmap_bulk_read into a buffer that wasn't dma safe
as it was on the stack with no guarantee of it being in a cacheline
on it's own.   Fixing that also dealt with the data leak and
alignment issues that Lars-Peter pointed out.

Also removed some unaligned handling as we are now aligned.

Fixes tag is for the dma safe buffer issue. Potentially we would
need to backport timestamp alignment futher but that is a totally
different patch.

Fixes: fd64df16f40e ("iio: imu: inv_mpu6050: Add SPI support for MPU6000")
Reported-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Reviewed-by: Jean-Baptiste Maneyrol <jmaneyrol@invensense.com>
Cc: <Stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200722155103.979802-18-jic23@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h  |   12 +++++++++---
 drivers/iio/imu/inv_mpu6050/inv_mpu_ring.c |   12 +++++-------
 2 files changed, 14 insertions(+), 10 deletions(-)

--- a/drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h
+++ b/drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h
@@ -122,6 +122,13 @@ struct inv_mpu6050_chip_config {
 	u8 user_ctrl;
 };
 
+/*
+ * Maximum of 6 + 6 + 2 + 7 (for MPU9x50) = 21 round up to 24 and plus 8.
+ * May be less if fewer channels are enabled, as long as the timestamp
+ * remains 8 byte aligned
+ */
+#define INV_MPU6050_OUTPUT_DATA_SIZE         32
+
 /**
  *  struct inv_mpu6050_hw - Other important hardware information.
  *  @whoami:	Self identification byte from WHO_AM_I register
@@ -165,6 +172,7 @@ struct inv_mpu6050_hw {
  *  @magn_raw_to_gauss:	coefficient to convert mag raw value to Gauss.
  *  @magn_orient:       magnetometer sensor chip orientation if available.
  *  @suspended_sensors:	sensors mask of sensors turned off for suspend
+ *  @data:		dma safe buffer used for bulk reads.
  */
 struct inv_mpu6050_state {
 	struct mutex lock;
@@ -190,6 +198,7 @@ struct inv_mpu6050_state {
 	s32 magn_raw_to_gauss[3];
 	struct iio_mount_matrix magn_orient;
 	unsigned int suspended_sensors;
+	u8 data[INV_MPU6050_OUTPUT_DATA_SIZE] ____cacheline_aligned;
 };
 
 /*register and associated bit definition*/
@@ -334,9 +343,6 @@ struct inv_mpu6050_state {
 #define INV_ICM20608_TEMP_OFFSET	     8170
 #define INV_ICM20608_TEMP_SCALE		     3059976
 
-/* 6 + 6 + 2 + 7 (for MPU9x50) = 21 round up to 24 and plus 8 */
-#define INV_MPU6050_OUTPUT_DATA_SIZE         32
-
 #define INV_MPU6050_REG_INT_PIN_CFG	0x37
 #define INV_MPU6050_ACTIVE_HIGH		0x00
 #define INV_MPU6050_ACTIVE_LOW		0x80
--- a/drivers/iio/imu/inv_mpu6050/inv_mpu_ring.c
+++ b/drivers/iio/imu/inv_mpu6050/inv_mpu_ring.c
@@ -13,7 +13,6 @@
 #include <linux/interrupt.h>
 #include <linux/poll.h>
 #include <linux/math64.h>
-#include <asm/unaligned.h>
 #include "inv_mpu_iio.h"
 
 /**
@@ -121,7 +120,6 @@ irqreturn_t inv_mpu6050_read_fifo(int ir
 	struct inv_mpu6050_state *st = iio_priv(indio_dev);
 	size_t bytes_per_datum;
 	int result;
-	u8 data[INV_MPU6050_OUTPUT_DATA_SIZE];
 	u16 fifo_count;
 	s64 timestamp;
 	int int_status;
@@ -160,11 +158,11 @@ irqreturn_t inv_mpu6050_read_fifo(int ir
 	 * read fifo_count register to know how many bytes are inside the FIFO
 	 * right now
 	 */
-	result = regmap_bulk_read(st->map, st->reg->fifo_count_h, data,
-				  INV_MPU6050_FIFO_COUNT_BYTE);
+	result = regmap_bulk_read(st->map, st->reg->fifo_count_h,
+				  st->data, INV_MPU6050_FIFO_COUNT_BYTE);
 	if (result)
 		goto end_session;
-	fifo_count = get_unaligned_be16(&data[0]);
+	fifo_count = be16_to_cpup((__be16 *)&st->data[0]);
 
 	/*
 	 * Handle fifo overflow by resetting fifo.
@@ -182,7 +180,7 @@ irqreturn_t inv_mpu6050_read_fifo(int ir
 	inv_mpu6050_update_period(st, pf->timestamp, nb);
 	for (i = 0; i < nb; ++i) {
 		result = regmap_bulk_read(st->map, st->reg->fifo_r_w,
-					  data, bytes_per_datum);
+					  st->data, bytes_per_datum);
 		if (result)
 			goto flush_fifo;
 		/* skip first samples if needed */
@@ -191,7 +189,7 @@ irqreturn_t inv_mpu6050_read_fifo(int ir
 			continue;
 		}
 		timestamp = inv_mpu6050_get_timestamp(st);
-		iio_push_to_buffers_with_timestamp(indio_dev, data, timestamp);
+		iio_push_to_buffers_with_timestamp(indio_dev, st->data, timestamp);
 	}
 
 end_session:


