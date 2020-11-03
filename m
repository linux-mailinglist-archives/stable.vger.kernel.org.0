Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94E4E2A5858
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:52:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730113AbgKCUsV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:48:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:39700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731426AbgKCUsT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:48:19 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 439E82242A;
        Tue,  3 Nov 2020 20:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436498;
        bh=8bS/YCPfViTUhtehosqlWPwh5v+6Izm+dFT1xx6+wrs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lzf4lPv9xZ+V06IxBkHgW1kpqaL8ujJODnx0HhK/1MlaqMrHhXM4SM0IOTUVXnT1I
         +uLr7zcp3r2w6b+rhjMR4xMJ8g1MLV+PeWJbVyRj/hs6pDx5afgrzsizveG3ctdsA3
         cjEbgOk/Po8rYkGo/rC5/cN0UkGKEQDet6zHJ3FY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Stable@vger.kernel.org
Subject: [PATCH 5.9 277/391] iio:imu:st_lsm6dsx Fix alignment and data leak issues
Date:   Tue,  3 Nov 2020 21:35:28 +0100
Message-Id: <20201103203405.724231636@linuxfoundation.org>
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

commit c14edb4d0bdc53f969ea84c7f384472c28b1a9f8 upstream.

One of a class of bugs pointed out by Lars in a recent review.
iio_push_to_buffers_with_timestamp assumes the buffer used is aligned
to the size of the timestamp (8 bytes).  This is not guaranteed in
this driver which uses an array of smaller elements on the stack.
As Lars also noted this anti pattern can involve a leak of data to
userspace and that indeed can happen here.  We close both issues by
moving to an array of suitable structures in the iio_priv() data.

This data is allocated with kzalloc so no data can leak apart from
previous readings.

For the tagged path the data is aligned by using __aligned(8) for
the buffer on the stack.

There has been a lot of churn in this driver, so likely backports
may be needed for stable.

Fixes: 290a6ce11d93 ("iio: imu: add support to lsm6dsx driver")
Reported-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Cc: <Stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200722155103.979802-17-jic23@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h        |    6 +++
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c |   42 +++++++++++++++----------
 2 files changed, 32 insertions(+), 16 deletions(-)

--- a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h
+++ b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h
@@ -383,6 +383,7 @@ struct st_lsm6dsx_sensor {
  * @iio_devs: Pointers to acc/gyro iio_dev instances.
  * @settings: Pointer to the specific sensor settings in use.
  * @orientation: sensor chip orientation relative to main hardware.
+ * @scan: Temporary buffers used to align data before iio_push_to_buffers()
  */
 struct st_lsm6dsx_hw {
 	struct device *dev;
@@ -411,6 +412,11 @@ struct st_lsm6dsx_hw {
 	const struct st_lsm6dsx_settings *settings;
 
 	struct iio_mount_matrix orientation;
+	/* Ensure natural alignment of buffer elements */
+	struct {
+		__le16 channels[3];
+		s64 ts __aligned(8);
+	} scan[3];
 };
 
 static __maybe_unused const struct iio_event_spec st_lsm6dsx_event = {
--- a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c
+++ b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c
@@ -353,9 +353,6 @@ int st_lsm6dsx_read_fifo(struct st_lsm6d
 	int err, sip, acc_sip, gyro_sip, ts_sip, ext_sip, read_len, offset;
 	u16 fifo_len, pattern_len = hw->sip * ST_LSM6DSX_SAMPLE_SIZE;
 	u16 fifo_diff_mask = hw->settings->fifo_ops.fifo_diff.mask;
-	u8 gyro_buff[ST_LSM6DSX_IIO_BUFF_SIZE];
-	u8 acc_buff[ST_LSM6DSX_IIO_BUFF_SIZE];
-	u8 ext_buff[ST_LSM6DSX_IIO_BUFF_SIZE];
 	bool reset_ts = false;
 	__le16 fifo_status;
 	s64 ts = 0;
@@ -416,19 +413,22 @@ int st_lsm6dsx_read_fifo(struct st_lsm6d
 
 		while (acc_sip > 0 || gyro_sip > 0 || ext_sip > 0) {
 			if (gyro_sip > 0 && !(sip % gyro_sensor->decimator)) {
-				memcpy(gyro_buff, &hw->buff[offset],
-				       ST_LSM6DSX_SAMPLE_SIZE);
-				offset += ST_LSM6DSX_SAMPLE_SIZE;
+				memcpy(hw->scan[ST_LSM6DSX_ID_GYRO].channels,
+				       &hw->buff[offset],
+				       sizeof(hw->scan[ST_LSM6DSX_ID_GYRO].channels));
+				offset += sizeof(hw->scan[ST_LSM6DSX_ID_GYRO].channels);
 			}
 			if (acc_sip > 0 && !(sip % acc_sensor->decimator)) {
-				memcpy(acc_buff, &hw->buff[offset],
-				       ST_LSM6DSX_SAMPLE_SIZE);
-				offset += ST_LSM6DSX_SAMPLE_SIZE;
+				memcpy(hw->scan[ST_LSM6DSX_ID_ACC].channels,
+				       &hw->buff[offset],
+				       sizeof(hw->scan[ST_LSM6DSX_ID_ACC].channels));
+				offset += sizeof(hw->scan[ST_LSM6DSX_ID_ACC].channels);
 			}
 			if (ext_sip > 0 && !(sip % ext_sensor->decimator)) {
-				memcpy(ext_buff, &hw->buff[offset],
-				       ST_LSM6DSX_SAMPLE_SIZE);
-				offset += ST_LSM6DSX_SAMPLE_SIZE;
+				memcpy(hw->scan[ST_LSM6DSX_ID_EXT0].channels,
+				       &hw->buff[offset],
+				       sizeof(hw->scan[ST_LSM6DSX_ID_EXT0].channels));
+				offset += sizeof(hw->scan[ST_LSM6DSX_ID_EXT0].channels);
 			}
 
 			if (ts_sip-- > 0) {
@@ -458,19 +458,22 @@ int st_lsm6dsx_read_fifo(struct st_lsm6d
 			if (gyro_sip > 0 && !(sip % gyro_sensor->decimator)) {
 				iio_push_to_buffers_with_timestamp(
 					hw->iio_devs[ST_LSM6DSX_ID_GYRO],
-					gyro_buff, gyro_sensor->ts_ref + ts);
+					&hw->scan[ST_LSM6DSX_ID_GYRO],
+					gyro_sensor->ts_ref + ts);
 				gyro_sip--;
 			}
 			if (acc_sip > 0 && !(sip % acc_sensor->decimator)) {
 				iio_push_to_buffers_with_timestamp(
 					hw->iio_devs[ST_LSM6DSX_ID_ACC],
-					acc_buff, acc_sensor->ts_ref + ts);
+					&hw->scan[ST_LSM6DSX_ID_ACC],
+					acc_sensor->ts_ref + ts);
 				acc_sip--;
 			}
 			if (ext_sip > 0 && !(sip % ext_sensor->decimator)) {
 				iio_push_to_buffers_with_timestamp(
 					hw->iio_devs[ST_LSM6DSX_ID_EXT0],
-					ext_buff, ext_sensor->ts_ref + ts);
+					&hw->scan[ST_LSM6DSX_ID_EXT0],
+					ext_sensor->ts_ref + ts);
 				ext_sip--;
 			}
 			sip++;
@@ -555,7 +558,14 @@ int st_lsm6dsx_read_tagged_fifo(struct s
 {
 	u16 pattern_len = hw->sip * ST_LSM6DSX_TAGGED_SAMPLE_SIZE;
 	u16 fifo_len, fifo_diff_mask;
-	u8 iio_buff[ST_LSM6DSX_IIO_BUFF_SIZE], tag;
+	/*
+	 * Alignment needed as this can ultimately be passed to a
+	 * call to iio_push_to_buffers_with_timestamp() which
+	 * must be passed a buffer that is aligned to 8 bytes so
+	 * as to allow insertion of a naturally aligned timestamp.
+	 */
+	u8 iio_buff[ST_LSM6DSX_IIO_BUFF_SIZE] __aligned(8);
+	u8 tag;
 	bool reset_ts = false;
 	int i, err, read_len;
 	__le16 fifo_status;


