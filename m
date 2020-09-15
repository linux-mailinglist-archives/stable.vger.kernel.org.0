Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 755CD26B653
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 02:03:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726402AbgIPACL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 20:02:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:44122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727006AbgIOOaP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:30:15 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F14D22264;
        Tue, 15 Sep 2020 14:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179711;
        bh=bcFKsogNP1wgX35v8NrQfSoc5bXt+zthu2qPF+D27ds=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L7NpXQtHBvBwRwWBF2WHU3sxyG94JXYyvtdfazEeUEE317snxqo0TknGIk6DErIkk
         iZ34dDB6nqXRqspxrPlVgKdoJJ0JJMNwouzWfdRL4y4YAHvgIj1RxTuYaIJ6ibOAs2
         obiMKwwlMGmL4nAR6A232YTDW+nTHGLtYZhb06eA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Stable@vger.kernel.org, Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCH 5.4 088/132] iio:accel:mma7455: Fix timestamp alignment and prevent data leak.
Date:   Tue, 15 Sep 2020 16:13:10 +0200
Message-Id: <20200915140648.510511543@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140644.037604909@linuxfoundation.org>
References: <20200915140644.037604909@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

commit 7e5ac1f2206eda414f90c698fe1820dee873394d upstream.

One of a class of bugs pointed out by Lars in a recent review.
iio_push_to_buffers_with_timestamp assumes the buffer used is aligned
to the size of the timestamp (8 bytes).  This is not guaranteed in
this driver which uses a 16 byte u8 array on the stack   As Lars also noted
this anti pattern can involve a leak of data to userspace and that
indeed can happen here.  We close both issues by moving to
a suitable structure in the iio_priv() data with alignment
ensured by use of an explicit c structure.  This data is allocated
with kzalloc so no data can leak appart from previous readings.

The force alignment of ts is not strictly necessary in this particularly
case but does make the code less fragile.

Fixes: a84ef0d181d9 ("iio: accel: add Freescale MMA7455L/MMA7456L 3-axis accelerometer driver")
Reported-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: <Stable@vger.kernel.org>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/accel/mma7455_core.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/drivers/iio/accel/mma7455_core.c
+++ b/drivers/iio/accel/mma7455_core.c
@@ -52,6 +52,14 @@
 
 struct mma7455_data {
 	struct regmap *regmap;
+	/*
+	 * Used to reorganize data.  Will ensure correct alignment of
+	 * the timestamp if present
+	 */
+	struct {
+		__le16 channels[3];
+		s64 ts __aligned(8);
+	} scan;
 };
 
 static int mma7455_drdy(struct mma7455_data *mma7455)
@@ -82,19 +90,19 @@ static irqreturn_t mma7455_trigger_handl
 	struct iio_poll_func *pf = p;
 	struct iio_dev *indio_dev = pf->indio_dev;
 	struct mma7455_data *mma7455 = iio_priv(indio_dev);
-	u8 buf[16]; /* 3 x 16-bit channels + padding + ts */
 	int ret;
 
 	ret = mma7455_drdy(mma7455);
 	if (ret)
 		goto done;
 
-	ret = regmap_bulk_read(mma7455->regmap, MMA7455_REG_XOUTL, buf,
-			       sizeof(__le16) * 3);
+	ret = regmap_bulk_read(mma7455->regmap, MMA7455_REG_XOUTL,
+			       mma7455->scan.channels,
+			       sizeof(mma7455->scan.channels));
 	if (ret)
 		goto done;
 
-	iio_push_to_buffers_with_timestamp(indio_dev, buf,
+	iio_push_to_buffers_with_timestamp(indio_dev, &mma7455->scan,
 					   iio_get_time_ns(indio_dev));
 
 done:


