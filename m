Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFF12275091
	for <lists+stable@lfdr.de>; Wed, 23 Sep 2020 08:00:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726625AbgIWGAo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Sep 2020 02:00:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:39586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726179AbgIWGAo (ORCPT <rfc822;Stable@vger.kernel.org>);
        Wed, 23 Sep 2020 02:00:44 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A919621924;
        Wed, 23 Sep 2020 06:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600840843;
        bh=IJt1ZcZe3+h380BzUSMlkW7c2vMJ56jKHIgP/8KqGHU=;
        h=Subject:To:From:Date:From;
        b=rLxXMKtwTT3Qts+xsJlCwBUEVpGWe1U0lRiE8xhZln1pl9RIRPOqCKfr2zS5P2vWt
         qdDRzbyQ4pp5H8Mbv7dbkHLxN1FpKhihlTy1Sd2V0JSpaA4k3SHSRfbuebxqvplnRC
         oimN0cIvEHgEPgIVuf9VjU/1Ta7QsaM45pBWWGio=
Subject: patch "iio:imu:st_lsm6dsx Fix alignment and data leak issues" added to staging-next
To:     Jonathan.Cameron@huawei.com, Stable@vger.kernel.org,
        andy.shevchenko@gmail.com, lars@metafoo.de,
        lorenzo.bianconi83@gmail.com
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 23 Sep 2020 07:56:37 +0200
Message-ID: <160084059718238@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio:imu:st_lsm6dsx Fix alignment and data leak issues

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From c14edb4d0bdc53f969ea84c7f384472c28b1a9f8 Mon Sep 17 00:00:00 2001
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Date: Wed, 22 Jul 2020 16:50:52 +0100
Subject: iio:imu:st_lsm6dsx Fix alignment and data leak issues

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
---
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h       |  6 +++
 .../iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c    | 42 ++++++++++++-------
 2 files changed, 32 insertions(+), 16 deletions(-)

diff --git a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h
index d80ba2e688ed..9275346a9cc1 100644
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
diff --git a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c
index 7de10bd636ea..12ed0a2e55e4 100644
--- a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c
+++ b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c
@@ -353,9 +353,6 @@ int st_lsm6dsx_read_fifo(struct st_lsm6dsx_hw *hw)
 	int err, sip, acc_sip, gyro_sip, ts_sip, ext_sip, read_len, offset;
 	u16 fifo_len, pattern_len = hw->sip * ST_LSM6DSX_SAMPLE_SIZE;
 	u16 fifo_diff_mask = hw->settings->fifo_ops.fifo_diff.mask;
-	u8 gyro_buff[ST_LSM6DSX_IIO_BUFF_SIZE];
-	u8 acc_buff[ST_LSM6DSX_IIO_BUFF_SIZE];
-	u8 ext_buff[ST_LSM6DSX_IIO_BUFF_SIZE];
 	bool reset_ts = false;
 	__le16 fifo_status;
 	s64 ts = 0;
@@ -416,19 +413,22 @@ int st_lsm6dsx_read_fifo(struct st_lsm6dsx_hw *hw)
 
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
@@ -458,19 +458,22 @@ int st_lsm6dsx_read_fifo(struct st_lsm6dsx_hw *hw)
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
@@ -555,7 +558,14 @@ int st_lsm6dsx_read_tagged_fifo(struct st_lsm6dsx_hw *hw)
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
-- 
2.28.0


