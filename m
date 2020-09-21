Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15836272CBE
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:35:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728756AbgIUQea (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:34:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:60970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728662AbgIUQeU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:34:20 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A55C523998;
        Mon, 21 Sep 2020 16:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706059;
        bh=Nl8wQCwDqfxCyNfdQhq52dD1AmHKgD8eoD3tX4UdaaQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wUIQsDkmZ1ehklm+AU/Sr2Ypaq081XImjOc5T2639/EW+YMGNjTu0YRNmRxge8eq5
         WibL8NzkW/Y0ZkEOMsLRTIHUqVlRcaqf/KF9acYC5W8HF3++cHC659QCWzOAMybrVA
         SThXo49hStzI4Dlhwhe1Gy+KnKYsihuIzrd3yCaw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Gregor Boirie <gregor.boirie@parrot.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Stable@vger.kernel.org
Subject: [PATCH 4.9 23/70] iio:magnetometer:ak8975 Fix alignment and data leak issues.
Date:   Mon, 21 Sep 2020 18:27:23 +0200
Message-Id: <20200921162036.182912400@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162035.136047591@linuxfoundation.org>
References: <20200921162035.136047591@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

commit 02ad21cefbac4d89ac443866f25b90449527737b upstream.

One of a class of bugs pointed out by Lars in a recent review.
iio_push_to_buffers_with_timestamp assumes the buffer used is aligned
to the size of the timestamp (8 bytes).  This is not guaranteed in
this driver which uses an array of smaller elements on the stack.
As Lars also noted this anti pattern can involve a leak of data to
userspace and that indeed can happen here.  We close both issues by
moving to a suitable structure in the iio_priv() data.

This data is allocated with kzalloc so no data can leak apart from
previous readings.

The explicit alignment of ts is not necessary in this case as by
coincidence the padding will end up the same, however I consider
it to make the code less fragile and have included it.

Fixes: bc11ca4a0b84 ("iio:magnetometer:ak8975: triggered buffer support")
Reported-by: Lars-Peter Clausen <lars@metafoo.de>
Cc: Gregor Boirie <gregor.boirie@parrot.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/magnetometer/ak8975.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/drivers/iio/magnetometer/ak8975.c
+++ b/drivers/iio/magnetometer/ak8975.c
@@ -381,6 +381,12 @@ struct ak8975_data {
 	struct iio_mount_matrix orientation;
 	struct regulator	*vdd;
 	struct regulator	*vid;
+
+	/* Ensure natural alignment of timestamp */
+	struct {
+		s16 channels[3];
+		s64 ts __aligned(8);
+	} scan;
 };
 
 /* Enable attached power regulator if any. */
@@ -813,7 +819,6 @@ static void ak8975_fill_buffer(struct ii
 	const struct i2c_client *client = data->client;
 	const struct ak_def *def = data->def;
 	int ret;
-	s16 buff[8]; /* 3 x 16 bits axis values + 1 aligned 64 bits timestamp */
 	__le16 fval[3];
 
 	mutex_lock(&data->lock);
@@ -836,12 +841,13 @@ static void ak8975_fill_buffer(struct ii
 	mutex_unlock(&data->lock);
 
 	/* Clamp to valid range. */
-	buff[0] = clamp_t(s16, le16_to_cpu(fval[0]), -def->range, def->range);
-	buff[1] = clamp_t(s16, le16_to_cpu(fval[1]), -def->range, def->range);
-	buff[2] = clamp_t(s16, le16_to_cpu(fval[2]), -def->range, def->range);
+	data->scan.channels[0] = clamp_t(s16, le16_to_cpu(fval[0]), -def->range, def->range);
+	data->scan.channels[1] = clamp_t(s16, le16_to_cpu(fval[1]), -def->range, def->range);
+	data->scan.channels[2] = clamp_t(s16, le16_to_cpu(fval[2]), -def->range, def->range);
 
-	iio_push_to_buffers_with_timestamp(indio_dev, buff,
+	iio_push_to_buffers_with_timestamp(indio_dev, &data->scan,
 					   iio_get_time_ns(indio_dev));
+
 	return;
 
 unlock:


