Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B1992ED2BA
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 15:38:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729117AbhAGOhC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 09:37:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:45346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729228AbhAGOcK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Jan 2021 09:32:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 18C3E23370;
        Thu,  7 Jan 2021 14:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610029909;
        bh=RFw+n++0ZHliEK3pgZhexrztSDm+0bCdgrR26y+fNP4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YWC8F9g+Y+0mw60shu+PhhDJ59fPRC6wOoYzeazAcmOOS6NdZbWH5PtftGv/IKEWU
         YemjG1cwzrGKLnX3ufPMtHwkOAOgoGo4L1OHJVxAdiYNJMJ1hYCaw9Pbs0KLA4gEBm
         aM9HTK7m7ZYfvnwhvBF9ib8HbAo6bSRqchG5zxnc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Daniel Baluta <daniel.baluta@gmail.com>,
        Daniel Baluta <daniel.baluta@oss.nxp.com>,
        Stable@vger.kernel.org,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 4.19 6/8] iio:imu:bmi160: Fix alignment and data leak issues
Date:   Thu,  7 Jan 2021 15:32:06 +0100
Message-Id: <20210107143048.450324345@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210107143047.586006010@linuxfoundation.org>
References: <20210107143047.586006010@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

commit 7b6b51234df6cd8b04fe736b0b89c25612d896b8 upstream

One of a class of bugs pointed out by Lars in a recent review.
iio_push_to_buffers_with_timestamp assumes the buffer used is aligned
to the size of the timestamp (8 bytes).  This is not guaranteed in
this driver which uses an array of smaller elements on the stack.
As Lars also noted this anti pattern can involve a leak of data to
userspace and that indeed can happen here.  We close both issues by
moving to a suitable array in the iio_priv() data with alignment
explicitly requested.  This data is allocated with kzalloc() so no
data can leak apart from previous readings.

In this driver, depending on which channels are enabled, the timestamp
can be in a number of locations.  Hence we cannot use a structure
to specify the data layout without it being misleading.

Fixes: 77c4ad2d6a9b ("iio: imu: Add initial support for Bosch BMI160")
Reported-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
Cc: Daniel Baluta  <daniel.baluta@gmail.com>
Cc: Daniel Baluta <daniel.baluta@oss.nxp.com>
Cc: <Stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200920112742.170751-6-jic23@kernel.org
[sudip: adjust context and use bmi160_data in old location]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/bmi160/bmi160_core.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/drivers/iio/imu/bmi160/bmi160_core.c
+++ b/drivers/iio/imu/bmi160/bmi160_core.c
@@ -110,6 +110,13 @@ enum bmi160_sensor_type {
 
 struct bmi160_data {
 	struct regmap *regmap;
+	/*
+	 * Ensure natural alignment for timestamp if present.
+	 * Max length needed: 2 * 3 channels + 4 bytes padding + 8 byte ts.
+	 * If fewer channels are enabled, less space may be needed, as
+	 * long as the timestamp is still aligned to 8 bytes.
+	 */
+	__le16 buf[12] __aligned(8);
 };
 
 const struct regmap_config bmi160_regmap_config = {
@@ -385,8 +392,6 @@ static irqreturn_t bmi160_trigger_handle
 	struct iio_poll_func *pf = p;
 	struct iio_dev *indio_dev = pf->indio_dev;
 	struct bmi160_data *data = iio_priv(indio_dev);
-	__le16 buf[12];
-	/* 2 sens x 3 axis x __le16 + 2 x __le16 pad + 4 x __le16 tstamp */
 	int i, ret, j = 0, base = BMI160_REG_DATA_MAGN_XOUT_L;
 	__le16 sample;
 
@@ -396,10 +401,10 @@ static irqreturn_t bmi160_trigger_handle
 				       &sample, sizeof(sample));
 		if (ret < 0)
 			goto done;
-		buf[j++] = sample;
+		data->buf[j++] = sample;
 	}
 
-	iio_push_to_buffers_with_timestamp(indio_dev, buf,
+	iio_push_to_buffers_with_timestamp(indio_dev, data->buf,
 					   iio_get_time_ns(indio_dev));
 done:
 	iio_trigger_notify_done(indio_dev->trig);


