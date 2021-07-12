Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93A573C4B5A
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:36:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240466AbhGLG4s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:56:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:44284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238905AbhGLGtU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:49:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1740061242;
        Mon, 12 Jul 2021 06:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072321;
        bh=Of2jWWwpNrAgTAlfdFvgH+Su9iOFGIuGMDgprAdCeR0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Loq9DymoyyRyxdLzfoHxiEpDCroK35hZNDVJl52wy6mQ5Qy4nJaVq2Z1Km6Ilr6mf
         WRJ7AtZO3WyhcR1QvwzPfZpRStnA26koh1JSP5AHhfLvrDrT1B/rVLKRPYa7s5+lVa
         3B1qxJqx8bn3NSnW6EOWjqBGVl1mLqmqTy+nh+dM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 448/593] iio: accel: kxcjk-1013: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
Date:   Mon, 12 Jul 2021 08:10:08 +0200
Message-Id: <20210712060938.436558762@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

[ Upstream commit 3ab3aa2e7bd57497f9a7c6275c00dce237d2c9ba ]

To make code more readable, use a structure to express the channel
layout and ensure the timestamp is 8 byte aligned.

Found during an audit of all calls of this function.

Fixes: 1a4fbf6a9286 ("iio: accel: kxcjk1013 3-axis accelerometer driver")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20210501170121.512209-5-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/accel/kxcjk-1013.c | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/iio/accel/kxcjk-1013.c b/drivers/iio/accel/kxcjk-1013.c
index 560a3373ff20..c99e90469a24 100644
--- a/drivers/iio/accel/kxcjk-1013.c
+++ b/drivers/iio/accel/kxcjk-1013.c
@@ -132,13 +132,24 @@ enum kx_acpi_type {
 	ACPI_KIOX010A,
 };
 
+enum kxcjk1013_axis {
+	AXIS_X,
+	AXIS_Y,
+	AXIS_Z,
+	AXIS_MAX
+};
+
 struct kxcjk1013_data {
 	struct i2c_client *client;
 	struct iio_trigger *dready_trig;
 	struct iio_trigger *motion_trig;
 	struct iio_mount_matrix orientation;
 	struct mutex mutex;
-	s16 buffer[8];
+	/* Ensure timestamp naturally aligned */
+	struct {
+		s16 chans[AXIS_MAX];
+		s64 timestamp __aligned(8);
+	} scan;
 	u8 odr_bits;
 	u8 range;
 	int wake_thres;
@@ -152,13 +163,6 @@ struct kxcjk1013_data {
 	enum kx_acpi_type acpi_type;
 };
 
-enum kxcjk1013_axis {
-	AXIS_X,
-	AXIS_Y,
-	AXIS_Z,
-	AXIS_MAX,
-};
-
 enum kxcjk1013_mode {
 	STANDBY,
 	OPERATION,
@@ -1092,12 +1096,12 @@ static irqreturn_t kxcjk1013_trigger_handler(int irq, void *p)
 	ret = i2c_smbus_read_i2c_block_data_or_emulated(data->client,
 							KXCJK1013_REG_XOUT_L,
 							AXIS_MAX * 2,
-							(u8 *)data->buffer);
+							(u8 *)data->scan.chans);
 	mutex_unlock(&data->mutex);
 	if (ret < 0)
 		goto err;
 
-	iio_push_to_buffers_with_timestamp(indio_dev, data->buffer,
+	iio_push_to_buffers_with_timestamp(indio_dev, &data->scan,
 					   data->timestamp);
 err:
 	iio_trigger_notify_done(indio_dev->trig);
-- 
2.30.2



