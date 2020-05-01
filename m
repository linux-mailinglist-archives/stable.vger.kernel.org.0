Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA6341C162F
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 16:08:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731306AbgEANl3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:41:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:41652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730881AbgEANlW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:41:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F83C208DB;
        Fri,  1 May 2020 13:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340482;
        bh=JyuC2SMawCNg6QZoDdmws0T5tZw/DSIWVRs30SIqjm8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g+KcjRGGl0IfVq0n7g+z3uxhevgRrQrKfiXMdkFgGaRR1DtJGugncikllY+tuxlqC
         D3OgmMQIV0Qe5X0wDhCLa/XNsjMkbHLj5q6/HfW2xZnEveblzqfh9KyCuJpx+FAuj3
         VKvRDBRzR5cGPGCsa8Rznc3jjX17rSotJ9uguEx4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.6 012/106] iio: imu: st_lsm6dsx: fix read misalignment on untagged FIFO
Date:   Fri,  1 May 2020 15:22:45 +0200
Message-Id: <20200501131545.903895328@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131543.421333643@linuxfoundation.org>
References: <20200501131543.421333643@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

commit 7762902c89c4c78d32ec562f1ada44d02039104b upstream.

st_lsm6dsx suffers of a read misalignment on untagged FIFO when
all 3 supported sensors (accel, gyro and ext device) are running
at different ODRs (the use-case is reported in the LSM6DSM Application
Note at pag 100).
Fix the issue taking into account decimation factor reading the FIFO
pattern.

Fixes: e485e2a2cfd6 ("iio: imu: st_lsm6dsx: enable sensor-hub support for lsm6dsm")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h        |    2 ++
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c |   23 ++++++++++++++++-------
 2 files changed, 18 insertions(+), 7 deletions(-)

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
 
--- a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c
+++ b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c
@@ -93,6 +93,7 @@ st_lsm6dsx_get_decimator_val(struct st_l
 			break;
 	}
 
+	sensor->decimator = decimator;
 	return i == max_size ? 0 : st_lsm6dsx_decimator_table[i].val;
 }
 
@@ -337,7 +338,7 @@ static inline int st_lsm6dsx_read_block(
 int st_lsm6dsx_read_fifo(struct st_lsm6dsx_hw *hw)
 {
 	struct st_lsm6dsx_sensor *acc_sensor, *gyro_sensor, *ext_sensor = NULL;
-	int err, acc_sip, gyro_sip, ts_sip, ext_sip, read_len, offset;
+	int err, sip, acc_sip, gyro_sip, ts_sip, ext_sip, read_len, offset;
 	u16 fifo_len, pattern_len = hw->sip * ST_LSM6DSX_SAMPLE_SIZE;
 	u16 fifo_diff_mask = hw->settings->fifo_ops.fifo_diff.mask;
 	u8 gyro_buff[ST_LSM6DSX_IIO_BUFF_SIZE];
@@ -399,19 +400,20 @@ int st_lsm6dsx_read_fifo(struct st_lsm6d
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
@@ -441,18 +443,25 @@ int st_lsm6dsx_read_fifo(struct st_lsm6d
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
 


