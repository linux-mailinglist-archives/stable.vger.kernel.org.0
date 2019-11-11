Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3988F7E22
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 20:02:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729847AbfKKSu2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:50:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:44160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728461AbfKKSu1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:50:27 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2AC90222C1;
        Mon, 11 Nov 2019 18:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498226;
        bh=xgMeimPcvHOIArbrDbWkWWbd5mdHO0gP7skiv0N82S0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yg5Hgu+FrZ6zaSTvDDIwJ6RZtEjuTB/dOHCnp1zR6AE4DWApdWTN7GaA0zTjIQj0i
         AHifWnyhO5SqWi1PPMCW3mEwMKHzUWPk01CHk6kcqTdwLes5B2qj/hzpNWQKTY3LRV
         TK/iMD05gQpicjDQwJDuy5sJttS4JAAqxWzSDuMg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jean-Baptiste Maneyrol <jmaneyrol@invensense.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.3 058/193] iio: imu: inv_mpu6050: fix no data on MPU6050
Date:   Mon, 11 Nov 2019 19:27:20 +0100
Message-Id: <20191111181505.263610846@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181459.850623879@linuxfoundation.org>
References: <20191111181459.850623879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jean-Baptiste Maneyrol <JManeyrol@invensense.com>

commit 6e82ae6b8d11b948b74e71396efd8e074c415f44 upstream.

Some chips have a fifo overflow bit issue where the bit is always
set. The result is that every data is dropped.

Change fifo overflow management by checking fifo count against
a maximum value.

Add fifo size in chip hardware set of values.

Fixes: f5057e7b2dba ("iio: imu: inv_mpu6050: better fifo overflow handling")
Cc: stable@vger.kernel.org
Signed-off-by: Jean-Baptiste Maneyrol <jmaneyrol@invensense.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/imu/inv_mpu6050/inv_mpu_core.c |    9 +++++++++
 drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h  |    2 ++
 drivers/iio/imu/inv_mpu6050/inv_mpu_ring.c |   15 ++++++++++++---
 3 files changed, 23 insertions(+), 3 deletions(-)

--- a/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c
+++ b/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c
@@ -114,54 +114,63 @@ static const struct inv_mpu6050_hw hw_in
 		.name = "MPU6050",
 		.reg = &reg_set_6050,
 		.config = &chip_config_6050,
+		.fifo_size = 1024,
 	},
 	{
 		.whoami = INV_MPU6500_WHOAMI_VALUE,
 		.name = "MPU6500",
 		.reg = &reg_set_6500,
 		.config = &chip_config_6050,
+		.fifo_size = 512,
 	},
 	{
 		.whoami = INV_MPU6515_WHOAMI_VALUE,
 		.name = "MPU6515",
 		.reg = &reg_set_6500,
 		.config = &chip_config_6050,
+		.fifo_size = 512,
 	},
 	{
 		.whoami = INV_MPU6000_WHOAMI_VALUE,
 		.name = "MPU6000",
 		.reg = &reg_set_6050,
 		.config = &chip_config_6050,
+		.fifo_size = 1024,
 	},
 	{
 		.whoami = INV_MPU9150_WHOAMI_VALUE,
 		.name = "MPU9150",
 		.reg = &reg_set_6050,
 		.config = &chip_config_6050,
+		.fifo_size = 1024,
 	},
 	{
 		.whoami = INV_MPU9250_WHOAMI_VALUE,
 		.name = "MPU9250",
 		.reg = &reg_set_6500,
 		.config = &chip_config_6050,
+		.fifo_size = 512,
 	},
 	{
 		.whoami = INV_MPU9255_WHOAMI_VALUE,
 		.name = "MPU9255",
 		.reg = &reg_set_6500,
 		.config = &chip_config_6050,
+		.fifo_size = 512,
 	},
 	{
 		.whoami = INV_ICM20608_WHOAMI_VALUE,
 		.name = "ICM20608",
 		.reg = &reg_set_6500,
 		.config = &chip_config_6050,
+		.fifo_size = 512,
 	},
 	{
 		.whoami = INV_ICM20602_WHOAMI_VALUE,
 		.name = "ICM20602",
 		.reg = &reg_set_icm20602,
 		.config = &chip_config_6050,
+		.fifo_size = 1008,
 	},
 };
 
--- a/drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h
+++ b/drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h
@@ -100,12 +100,14 @@ struct inv_mpu6050_chip_config {
  *  @name:      name of the chip.
  *  @reg:   register map of the chip.
  *  @config:    configuration of the chip.
+ *  @fifo_size:	size of the FIFO in bytes.
  */
 struct inv_mpu6050_hw {
 	u8 whoami;
 	u8 *name;
 	const struct inv_mpu6050_reg_map *reg;
 	const struct inv_mpu6050_chip_config *config;
+	size_t fifo_size;
 };
 
 /*
--- a/drivers/iio/imu/inv_mpu6050/inv_mpu_ring.c
+++ b/drivers/iio/imu/inv_mpu6050/inv_mpu_ring.c
@@ -180,9 +180,6 @@ irqreturn_t inv_mpu6050_read_fifo(int ir
 			"failed to ack interrupt\n");
 		goto flush_fifo;
 	}
-	/* handle fifo overflow by reseting fifo */
-	if (int_status & INV_MPU6050_BIT_FIFO_OVERFLOW_INT)
-		goto flush_fifo;
 	if (!(int_status & INV_MPU6050_BIT_RAW_DATA_RDY_INT)) {
 		dev_warn(regmap_get_device(st->map),
 			"spurious interrupt with status 0x%x\n", int_status);
@@ -211,6 +208,18 @@ irqreturn_t inv_mpu6050_read_fifo(int ir
 	if (result)
 		goto end_session;
 	fifo_count = get_unaligned_be16(&data[0]);
+
+	/*
+	 * Handle fifo overflow by resetting fifo.
+	 * Reset if there is only 3 data set free remaining to mitigate
+	 * possible delay between reading fifo count and fifo data.
+	 */
+	nb = 3 * bytes_per_datum;
+	if (fifo_count >= st->hw->fifo_size - nb) {
+		dev_warn(regmap_get_device(st->map), "fifo overflow reset\n");
+		goto flush_fifo;
+	}
+
 	/* compute and process all complete datum */
 	nb = fifo_count / bytes_per_datum;
 	inv_mpu6050_update_period(st, pf->timestamp, nb);


