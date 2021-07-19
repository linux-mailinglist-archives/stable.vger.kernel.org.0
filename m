Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F00BC3CD9B3
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:13:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242108AbhGSObR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:31:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:40508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242199AbhGSO2E (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:28:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD07C610D2;
        Mon, 19 Jul 2021 15:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626707281;
        bh=2aeO2OEW6Q48RL6xvdkJ+CUiTcH+mq4a+HfUmlOIEjM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=buE9Dw/N1z4/cdsr1bCs4P3daC3edAosuipaZQFOCE9LPbiVLpfHJNHalTpZxT/zS
         6r2h8F2uvb/hqNIckj3HDJukKvAQa92rRAmpRuOtJYvSFJhTMBjhONy+MAllK2Lac9
         RLltwSfPSr8/aPdZCtFwpYWHhavyQ9pOtWxPwOqo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 096/245] iio: accel: kxcjk-1013: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
Date:   Mon, 19 Jul 2021 16:50:38 +0200
Message-Id: <20210719144943.518372801@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.288257948@linuxfoundation.org>
References: <20210719144940.288257948@linuxfoundation.org>
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
index 261fbdb88fe1..626a605a0c0e 100644
--- a/drivers/iio/accel/kxcjk-1013.c
+++ b/drivers/iio/accel/kxcjk-1013.c
@@ -96,12 +96,23 @@ enum kx_acpi_type {
 	ACPI_SMO8500,
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
@@ -115,13 +126,6 @@ struct kxcjk1013_data {
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
@@ -971,12 +975,12 @@ static irqreturn_t kxcjk1013_trigger_handler(int irq, void *p)
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



