Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C5ED1BFD83
	for <lists+stable@lfdr.de>; Thu, 30 Apr 2020 16:13:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727801AbgD3Nuy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 09:50:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:58462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727086AbgD3Nuv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Apr 2020 09:50:51 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F194420873;
        Thu, 30 Apr 2020 13:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588254650;
        bh=zh48Mwux3jwlRb4nRNfRVX7V+9O0mJOiLa7xukcJ8qw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aM2CA3/ZyqgR1ZnvGR2nyqxRn/ktVd3a8pfUTp/gKQxm8rt3hYG9/OLQJuaAHkOKa
         w1nGIDwQT+TX/lB3ygMngFtr/VHJ9kmMgSv6w/jG2TLd8vaRIXl47C6PzQ4H8jcGYN
         D5+FchyrFwAPbr6two9Kt+wrSGpVrTcVYT3UPHPQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>, linux-iio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 05/79] iio: imu: st_lsm6dsx: fix read misalignment on untagged FIFO
Date:   Thu, 30 Apr 2020 09:49:29 -0400
Message-Id: <20200430135043.19851-5-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200430135043.19851-1-sashal@kernel.org>
References: <20200430135043.19851-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 7762902c89c4c78d32ec562f1ada44d02039104b ]

st_lsm6dsx suffers of a read misalignment on untagged FIFO when
all 3 supported sensors (accel, gyro and ext device) are running
at different ODRs (the use-case is reported in the LSM6DSM Application
Note at pag 100).
Fix the issue taking into account decimation factor reading the FIFO
pattern.

Fixes: e485e2a2cfd6 ("iio: imu: st_lsm6dsx: enable sensor-hub support for lsm6dsm")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h       |  2 ++
 .../iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c    | 23 +++++++++++++------
 2 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h
index 9c3486a8134fd..b8ed6c900c457 100644
--- a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h
+++ b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h
@@ -337,6 +337,7 @@ enum st_lsm6dsx_fifo_mode {
  * @gain: Configured sensor sensitivity.
  * @odr: Output data rate of the sensor [Hz].
  * @watermark: Sensor watermark level.
+ * @decimator: Sensor decimation factor.
  * @sip: Number of samples in a given pattern.
  * @ts_ref: Sensor timestamp reference for hw one.
  * @ext_info: Sensor settings if it is connected to i2c controller
@@ -350,6 +351,7 @@ struct st_lsm6dsx_sensor {
 	u32 odr;
 
 	u16 watermark;
+	u8 decimator;
 	u8 sip;
 	s64 ts_ref;
 
diff --git a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c
index bb899345f2bba..afd00daeefb2d 100644
--- a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c
+++ b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c
@@ -93,6 +93,7 @@ st_lsm6dsx_get_decimator_val(struct st_lsm6dsx_sensor *sensor, u32 max_odr)
 			break;
 	}
 
+	sensor->decimator = decimator;
 	return i == max_size ? 0 : st_lsm6dsx_decimator_table[i].val;
 }
 
@@ -337,7 +338,7 @@ static inline int st_lsm6dsx_read_block(struct st_lsm6dsx_hw *hw, u8 addr,
 int st_lsm6dsx_read_fifo(struct st_lsm6dsx_hw *hw)
 {
 	struct st_lsm6dsx_sensor *acc_sensor, *gyro_sensor, *ext_sensor = NULL;
-	int err, acc_sip, gyro_sip, ts_sip, ext_sip, read_len, offset;
+	int err, sip, acc_sip, gyro_sip, ts_sip, ext_sip, read_len, offset;
 	u16 fifo_len, pattern_len = hw->sip * ST_LSM6DSX_SAMPLE_SIZE;
 	u16 fifo_diff_mask = hw->settings->fifo_ops.fifo_diff.mask;
 	u8 gyro_buff[ST_LSM6DSX_IIO_BUFF_SIZE];
@@ -399,19 +400,20 @@ int st_lsm6dsx_read_fifo(struct st_lsm6dsx_hw *hw)
 		acc_sip = acc_sensor->sip;
 		ts_sip = hw->ts_sip;
 		offset = 0;
+		sip = 0;
 
 		while (acc_sip > 0 || gyro_sip > 0 || ext_sip > 0) {
-			if (gyro_sip > 0) {
+			if (gyro_sip > 0 && !(sip % gyro_sensor->decimator)) {
 				memcpy(gyro_buff, &hw->buff[offset],
 				       ST_LSM6DSX_SAMPLE_SIZE);
 				offset += ST_LSM6DSX_SAMPLE_SIZE;
 			}
-			if (acc_sip > 0) {
+			if (acc_sip > 0 && !(sip % acc_sensor->decimator)) {
 				memcpy(acc_buff, &hw->buff[offset],
 				       ST_LSM6DSX_SAMPLE_SIZE);
 				offset += ST_LSM6DSX_SAMPLE_SIZE;
 			}
-			if (ext_sip > 0) {
+			if (ext_sip > 0 && !(sip % ext_sensor->decimator)) {
 				memcpy(ext_buff, &hw->buff[offset],
 				       ST_LSM6DSX_SAMPLE_SIZE);
 				offset += ST_LSM6DSX_SAMPLE_SIZE;
@@ -441,18 +443,25 @@ int st_lsm6dsx_read_fifo(struct st_lsm6dsx_hw *hw)
 				offset += ST_LSM6DSX_SAMPLE_SIZE;
 			}
 
-			if (gyro_sip-- > 0)
+			if (gyro_sip > 0 && !(sip % gyro_sensor->decimator)) {
 				iio_push_to_buffers_with_timestamp(
 					hw->iio_devs[ST_LSM6DSX_ID_GYRO],
 					gyro_buff, gyro_sensor->ts_ref + ts);
-			if (acc_sip-- > 0)
+				gyro_sip--;
+			}
+			if (acc_sip > 0 && !(sip % acc_sensor->decimator)) {
 				iio_push_to_buffers_with_timestamp(
 					hw->iio_devs[ST_LSM6DSX_ID_ACC],
 					acc_buff, acc_sensor->ts_ref + ts);
-			if (ext_sip-- > 0)
+				acc_sip--;
+			}
+			if (ext_sip > 0 && !(sip % ext_sensor->decimator)) {
 				iio_push_to_buffers_with_timestamp(
 					hw->iio_devs[ST_LSM6DSX_ID_EXT0],
 					ext_buff, ext_sensor->ts_ref + ts);
+				ext_sip--;
+			}
+			sip++;
 		}
 	}
 
-- 
2.20.1

