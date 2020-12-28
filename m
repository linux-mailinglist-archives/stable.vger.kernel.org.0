Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EFD32E3F05
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:38:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504801AbgL1Ocq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:32:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:40238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2504795AbgL1Ocp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:32:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 99AB02063A;
        Mon, 28 Dec 2020 14:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165950;
        bh=B88tFzYB7Wcia0t530oTc625taDcTdsUFlGMrJnGv3A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BqoZdjM6u2Sxws9zvgkdlr5N5YX5pzuNG0nOAfu8Kfyug6zT9mqedDZaG2l+APjdO
         cQSuzSojmkTD4kqpAj10c0jw2jwU9fTftvHidhfQ8vz83i7y2pbeQUREQDHnLsT/NF
         Fbu7rNqSp9bPLlvfIRhmJX1VDsvA36du7/uJ/SFw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Daniel Baluta <daniel.baluta@gmail.com>,
        Daniel Baluta <daniel.baluta@oss.nxp.com>,
        Stable@vger.kernel.org
Subject: [PATCH 5.10 682/717] iio:imu:bmi160: Fix alignment and data leak issues
Date:   Mon, 28 Dec 2020 13:51:20 +0100
Message-Id: <20201228125053.656836534@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

commit 7b6b51234df6cd8b04fe736b0b89c25612d896b8 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/imu/bmi160/bmi160.h      |    7 +++++++
 drivers/iio/imu/bmi160/bmi160_core.c |    6 ++----
 2 files changed, 9 insertions(+), 4 deletions(-)

--- a/drivers/iio/imu/bmi160/bmi160.h
+++ b/drivers/iio/imu/bmi160/bmi160.h
@@ -10,6 +10,13 @@ struct bmi160_data {
 	struct iio_trigger *trig;
 	struct regulator_bulk_data supplies[2];
 	struct iio_mount_matrix orientation;
+	/*
+	 * Ensure natural alignment for timestamp if present.
+	 * Max length needed: 2 * 3 channels + 4 bytes padding + 8 byte ts.
+	 * If fewer channels are enabled, less space may be needed, as
+	 * long as the timestamp is still aligned to 8 bytes.
+	 */
+	__le16 buf[12] __aligned(8);
 };
 
 extern const struct regmap_config bmi160_regmap_config;
--- a/drivers/iio/imu/bmi160/bmi160_core.c
+++ b/drivers/iio/imu/bmi160/bmi160_core.c
@@ -427,8 +427,6 @@ static irqreturn_t bmi160_trigger_handle
 	struct iio_poll_func *pf = p;
 	struct iio_dev *indio_dev = pf->indio_dev;
 	struct bmi160_data *data = iio_priv(indio_dev);
-	__le16 buf[12];
-	/* 2 sens x 3 axis x __le16 + 2 x __le16 pad + 4 x __le16 tstamp */
 	int i, ret, j = 0, base = BMI160_REG_DATA_MAGN_XOUT_L;
 	__le16 sample;
 
@@ -438,10 +436,10 @@ static irqreturn_t bmi160_trigger_handle
 				       &sample, sizeof(sample));
 		if (ret)
 			goto done;
-		buf[j++] = sample;
+		data->buf[j++] = sample;
 	}
 
-	iio_push_to_buffers_with_timestamp(indio_dev, buf, pf->timestamp);
+	iio_push_to_buffers_with_timestamp(indio_dev, data->buf, pf->timestamp);
 done:
 	iio_trigger_notify_done(indio_dev->trig);
 	return IRQ_HANDLED;


