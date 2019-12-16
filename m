Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B35C12165E
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:28:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731228AbfLPSO2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:14:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:33790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731224AbfLPSO1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:14:27 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 74DE921739;
        Mon, 16 Dec 2019 18:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576520066;
        bh=tt6JHLn0Pf8Q4RRvjGtOhCq3o4zsZc4BGLC0TuUDiwc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cjkrs1gLiEerGfC8YpEEOFrtPQOoT/qZ98NI7Hp4SgslZjQTYgGe0Yxrqnpvm8zO5
         r5aoMsnRFFgt1HDoyCkKWd5A/4VbEnYIB6Gl9AlnhUHir3L4JY5FjRb94iu8tTCQTz
         oIlvGAT1fQY+ZKjjfgCGJPhWlnKTxRltpy6/R3U0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Martin Kepplinger <martin.kepplinger@puri.sm>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 162/180] iio: imu: st_lsm6dsx: move odr_table in st_lsm6dsx_sensor_settings
Date:   Mon, 16 Dec 2019 18:50:02 +0100
Message-Id: <20191216174846.382156045@linuxfoundation.org>
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

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 40dd7343897760c4b617faa78d213e25652de9a6 ]

Move sensor odr table in st_lsm6dsx_sensor_settings in order to support
sensors with different odr maps. This is a preliminary patch to add
support for LSM9DS1 sensor to st_lsm6dsx driver

Tested-by: Martin Kepplinger <martin.kepplinger@puri.sm>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h      |   2 +
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c | 196 ++++++++++++++++---
 2 files changed, 166 insertions(+), 32 deletions(-)

diff --git a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h
index c14bf533b66b3..ceee4e1aa5d4e 100644
--- a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h
+++ b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h
@@ -198,6 +198,7 @@ struct st_lsm6dsx_ext_dev_settings {
  * @wai: Sensor WhoAmI default value.
  * @max_fifo_size: Sensor max fifo length in FIFO words.
  * @id: List of hw id/device name supported by the driver configuration.
+ * @odr_table: Hw sensors odr table (Hz + val).
  * @decimator: List of decimator register info (addr + mask).
  * @batch: List of FIFO batching register info (addr + mask).
  * @fifo_ops: Sensor hw FIFO parameters.
@@ -211,6 +212,7 @@ struct st_lsm6dsx_settings {
 		enum st_lsm6dsx_hw_id hw_id;
 		const char *name;
 	} id[ST_LSM6DSX_MAX_ID];
+	struct st_lsm6dsx_odr_table_entry odr_table[2];
 	struct st_lsm6dsx_reg decimator[ST_LSM6DSX_MAX_ID];
 	struct st_lsm6dsx_reg batch[ST_LSM6DSX_MAX_ID];
 	struct st_lsm6dsx_fifo_ops fifo_ops;
diff --git a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
index a6702a74570e2..41341cf2d9821 100644
--- a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
+++ b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
@@ -69,33 +69,6 @@
 #define ST_LSM6DSX_REG_GYRO_OUT_Y_L_ADDR	0x24
 #define ST_LSM6DSX_REG_GYRO_OUT_Z_L_ADDR	0x26
 
-static const struct st_lsm6dsx_odr_table_entry st_lsm6dsx_odr_table[] = {
-	[ST_LSM6DSX_ID_ACC] = {
-		.reg = {
-			.addr = 0x10,
-			.mask = GENMASK(7, 4),
-		},
-		.odr_avl[0] = {  13, 0x01 },
-		.odr_avl[1] = {  26, 0x02 },
-		.odr_avl[2] = {  52, 0x03 },
-		.odr_avl[3] = { 104, 0x04 },
-		.odr_avl[4] = { 208, 0x05 },
-		.odr_avl[5] = { 416, 0x06 },
-	},
-	[ST_LSM6DSX_ID_GYRO] = {
-		.reg = {
-			.addr = 0x11,
-			.mask = GENMASK(7, 4),
-		},
-		.odr_avl[0] = {  13, 0x01 },
-		.odr_avl[1] = {  26, 0x02 },
-		.odr_avl[2] = {  52, 0x03 },
-		.odr_avl[3] = { 104, 0x04 },
-		.odr_avl[4] = { 208, 0x05 },
-		.odr_avl[5] = { 416, 0x06 },
-	}
-};
-
 static const struct st_lsm6dsx_fs_table_entry st_lsm6dsx_fs_table[] = {
 	[ST_LSM6DSX_ID_ACC] = {
 		.reg = {
@@ -129,6 +102,32 @@ static const struct st_lsm6dsx_settings st_lsm6dsx_sensor_settings[] = {
 				.name = ST_LSM6DS3_DEV_NAME,
 			},
 		},
+		.odr_table = {
+			[ST_LSM6DSX_ID_ACC] = {
+				.reg = {
+					.addr = 0x10,
+					.mask = GENMASK(7, 4),
+				},
+				.odr_avl[0] = {  13, 0x01 },
+				.odr_avl[1] = {  26, 0x02 },
+				.odr_avl[2] = {  52, 0x03 },
+				.odr_avl[3] = { 104, 0x04 },
+				.odr_avl[4] = { 208, 0x05 },
+				.odr_avl[5] = { 416, 0x06 },
+			},
+			[ST_LSM6DSX_ID_GYRO] = {
+				.reg = {
+					.addr = 0x11,
+					.mask = GENMASK(7, 4),
+				},
+				.odr_avl[0] = {  13, 0x01 },
+				.odr_avl[1] = {  26, 0x02 },
+				.odr_avl[2] = {  52, 0x03 },
+				.odr_avl[3] = { 104, 0x04 },
+				.odr_avl[4] = { 208, 0x05 },
+				.odr_avl[5] = { 416, 0x06 },
+			},
+		},
 		.decimator = {
 			[ST_LSM6DSX_ID_ACC] = {
 				.addr = 0x08,
@@ -179,6 +178,32 @@ static const struct st_lsm6dsx_settings st_lsm6dsx_sensor_settings[] = {
 				.name = ST_LSM6DS3H_DEV_NAME,
 			},
 		},
+		.odr_table = {
+			[ST_LSM6DSX_ID_ACC] = {
+				.reg = {
+					.addr = 0x10,
+					.mask = GENMASK(7, 4),
+				},
+				.odr_avl[0] = {  13, 0x01 },
+				.odr_avl[1] = {  26, 0x02 },
+				.odr_avl[2] = {  52, 0x03 },
+				.odr_avl[3] = { 104, 0x04 },
+				.odr_avl[4] = { 208, 0x05 },
+				.odr_avl[5] = { 416, 0x06 },
+			},
+			[ST_LSM6DSX_ID_GYRO] = {
+				.reg = {
+					.addr = 0x11,
+					.mask = GENMASK(7, 4),
+				},
+				.odr_avl[0] = {  13, 0x01 },
+				.odr_avl[1] = {  26, 0x02 },
+				.odr_avl[2] = {  52, 0x03 },
+				.odr_avl[3] = { 104, 0x04 },
+				.odr_avl[4] = { 208, 0x05 },
+				.odr_avl[5] = { 416, 0x06 },
+			},
+		},
 		.decimator = {
 			[ST_LSM6DSX_ID_ACC] = {
 				.addr = 0x08,
@@ -235,6 +260,32 @@ static const struct st_lsm6dsx_settings st_lsm6dsx_sensor_settings[] = {
 				.name = ST_ISM330DLC_DEV_NAME,
 			},
 		},
+		.odr_table = {
+			[ST_LSM6DSX_ID_ACC] = {
+				.reg = {
+					.addr = 0x10,
+					.mask = GENMASK(7, 4),
+				},
+				.odr_avl[0] = {  13, 0x01 },
+				.odr_avl[1] = {  26, 0x02 },
+				.odr_avl[2] = {  52, 0x03 },
+				.odr_avl[3] = { 104, 0x04 },
+				.odr_avl[4] = { 208, 0x05 },
+				.odr_avl[5] = { 416, 0x06 },
+			},
+			[ST_LSM6DSX_ID_GYRO] = {
+				.reg = {
+					.addr = 0x11,
+					.mask = GENMASK(7, 4),
+				},
+				.odr_avl[0] = {  13, 0x01 },
+				.odr_avl[1] = {  26, 0x02 },
+				.odr_avl[2] = {  52, 0x03 },
+				.odr_avl[3] = { 104, 0x04 },
+				.odr_avl[4] = { 208, 0x05 },
+				.odr_avl[5] = { 416, 0x06 },
+			},
+		},
 		.decimator = {
 			[ST_LSM6DSX_ID_ACC] = {
 				.addr = 0x08,
@@ -288,6 +339,32 @@ static const struct st_lsm6dsx_settings st_lsm6dsx_sensor_settings[] = {
 				.name = ST_LSM6DSOX_DEV_NAME,
 			},
 		},
+		.odr_table = {
+			[ST_LSM6DSX_ID_ACC] = {
+				.reg = {
+					.addr = 0x10,
+					.mask = GENMASK(7, 4),
+				},
+				.odr_avl[0] = {  13, 0x01 },
+				.odr_avl[1] = {  26, 0x02 },
+				.odr_avl[2] = {  52, 0x03 },
+				.odr_avl[3] = { 104, 0x04 },
+				.odr_avl[4] = { 208, 0x05 },
+				.odr_avl[5] = { 416, 0x06 },
+			},
+			[ST_LSM6DSX_ID_GYRO] = {
+				.reg = {
+					.addr = 0x11,
+					.mask = GENMASK(7, 4),
+				},
+				.odr_avl[0] = {  13, 0x01 },
+				.odr_avl[1] = {  26, 0x02 },
+				.odr_avl[2] = {  52, 0x03 },
+				.odr_avl[3] = { 104, 0x04 },
+				.odr_avl[4] = { 208, 0x05 },
+				.odr_avl[5] = { 416, 0x06 },
+			},
+		},
 		.batch = {
 			[ST_LSM6DSX_ID_ACC] = {
 				.addr = 0x09,
@@ -356,6 +433,32 @@ static const struct st_lsm6dsx_settings st_lsm6dsx_sensor_settings[] = {
 				.name = ST_ASM330LHH_DEV_NAME,
 			},
 		},
+		.odr_table = {
+			[ST_LSM6DSX_ID_ACC] = {
+				.reg = {
+					.addr = 0x10,
+					.mask = GENMASK(7, 4),
+				},
+				.odr_avl[0] = {  13, 0x01 },
+				.odr_avl[1] = {  26, 0x02 },
+				.odr_avl[2] = {  52, 0x03 },
+				.odr_avl[3] = { 104, 0x04 },
+				.odr_avl[4] = { 208, 0x05 },
+				.odr_avl[5] = { 416, 0x06 },
+			},
+			[ST_LSM6DSX_ID_GYRO] = {
+				.reg = {
+					.addr = 0x11,
+					.mask = GENMASK(7, 4),
+				},
+				.odr_avl[0] = {  13, 0x01 },
+				.odr_avl[1] = {  26, 0x02 },
+				.odr_avl[2] = {  52, 0x03 },
+				.odr_avl[3] = { 104, 0x04 },
+				.odr_avl[4] = { 208, 0x05 },
+				.odr_avl[5] = { 416, 0x06 },
+			},
+		},
 		.batch = {
 			[ST_LSM6DSX_ID_ACC] = {
 				.addr = 0x09,
@@ -398,6 +501,32 @@ static const struct st_lsm6dsx_settings st_lsm6dsx_sensor_settings[] = {
 				.name = ST_LSM6DSR_DEV_NAME,
 			},
 		},
+		.odr_table = {
+			[ST_LSM6DSX_ID_ACC] = {
+				.reg = {
+					.addr = 0x10,
+					.mask = GENMASK(7, 4),
+				},
+				.odr_avl[0] = {  13, 0x01 },
+				.odr_avl[1] = {  26, 0x02 },
+				.odr_avl[2] = {  52, 0x03 },
+				.odr_avl[3] = { 104, 0x04 },
+				.odr_avl[4] = { 208, 0x05 },
+				.odr_avl[5] = { 416, 0x06 },
+			},
+			[ST_LSM6DSX_ID_GYRO] = {
+				.reg = {
+					.addr = 0x11,
+					.mask = GENMASK(7, 4),
+				},
+				.odr_avl[0] = {  13, 0x01 },
+				.odr_avl[1] = {  26, 0x02 },
+				.odr_avl[2] = {  52, 0x03 },
+				.odr_avl[3] = { 104, 0x04 },
+				.odr_avl[4] = { 208, 0x05 },
+				.odr_avl[5] = { 416, 0x06 },
+			},
+		},
 		.batch = {
 			[ST_LSM6DSX_ID_ACC] = {
 				.addr = 0x09,
@@ -560,20 +689,22 @@ static int st_lsm6dsx_set_full_scale(struct st_lsm6dsx_sensor *sensor,
 
 int st_lsm6dsx_check_odr(struct st_lsm6dsx_sensor *sensor, u16 odr, u8 *val)
 {
+	const struct st_lsm6dsx_odr_table_entry *odr_table;
 	int i;
 
+	odr_table = &sensor->hw->settings->odr_table[sensor->id];
 	for (i = 0; i < ST_LSM6DSX_ODR_LIST_SIZE; i++)
 		/*
 		 * ext devices can run at different odr respect to
 		 * accel sensor
 		 */
-		if (st_lsm6dsx_odr_table[sensor->id].odr_avl[i].hz >= odr)
+		if (odr_table->odr_avl[i].hz >= odr)
 			break;
 
 	if (i == ST_LSM6DSX_ODR_LIST_SIZE)
 		return -EINVAL;
 
-	*val = st_lsm6dsx_odr_table[sensor->id].odr_avl[i].val;
+	*val = odr_table->odr_avl[i].val;
 
 	return 0;
 }
@@ -638,7 +769,7 @@ static int st_lsm6dsx_set_odr(struct st_lsm6dsx_sensor *sensor, u16 req_odr)
 			return err;
 	}
 
-	reg = &st_lsm6dsx_odr_table[ref_sensor->id].reg;
+	reg = &hw->settings->odr_table[ref_sensor->id].reg;
 	data = ST_LSM6DSX_SHIFT_VAL(val, reg->mask);
 	return st_lsm6dsx_update_bits_locked(hw, reg->addr, reg->mask, data);
 }
@@ -783,11 +914,12 @@ st_lsm6dsx_sysfs_sampling_frequency_avail(struct device *dev,
 {
 	struct st_lsm6dsx_sensor *sensor = iio_priv(dev_get_drvdata(dev));
 	enum st_lsm6dsx_sensor_id id = sensor->id;
+	struct st_lsm6dsx_hw *hw = sensor->hw;
 	int i, len = 0;
 
 	for (i = 0; i < ST_LSM6DSX_ODR_LIST_SIZE; i++)
 		len += scnprintf(buf + len, PAGE_SIZE - len, "%d ",
-				 st_lsm6dsx_odr_table[id].odr_avl[i].hz);
+				 hw->settings->odr_table[id].odr_avl[i].hz);
 	buf[len - 1] = '\n';
 
 	return len;
@@ -1037,7 +1169,7 @@ static struct iio_dev *st_lsm6dsx_alloc_iiodev(struct st_lsm6dsx_hw *hw,
 	sensor = iio_priv(iio_dev);
 	sensor->id = id;
 	sensor->hw = hw;
-	sensor->odr = st_lsm6dsx_odr_table[id].odr_avl[0].hz;
+	sensor->odr = hw->settings->odr_table[id].odr_avl[0].hz;
 	sensor->gain = st_lsm6dsx_fs_table[id].fs_avl[0].gain;
 	sensor->watermark = 1;
 
-- 
2.20.1



