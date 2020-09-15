Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DBA426B76B
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 02:23:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727253AbgIPAXS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 20:23:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:34582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726528AbgIOOU7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:20:59 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 44F3C22243;
        Tue, 15 Sep 2020 14:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179407;
        bh=P7jqaOAApyzqqrUZrsopvtD81Sgcku1U3iZX28GTxMU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cltSkuJhXP4A04I5MK3QWzCV12oKXbXtKV7awMY1uscPi3uvpWZpYyDqKHeMLyIcj
         +M03alyYwiFyshU6cIwCEDV2g9LhdCiDoSoVYXskWiOSQCOZ0I2ouDuGyVzs53XmpJ
         jH7b8omxSY0Gq0t/kib48xyJSqIGRGdKnJ+E53ak=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Gregor Boirie <gregor.boirie@parrot.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Stable@vger.kernel.org
Subject: [PATCH 4.19 48/78] iio:magnetometer:ak8975 Fix alignment and data leak issues.
Date:   Tue, 15 Sep 2020 16:13:13 +0200
Message-Id: <20200915140635.983651965@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140633.552502750@linuxfoundation.org>
References: <20200915140633.552502750@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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
@@ -815,7 +821,6 @@ static void ak8975_fill_buffer(struct ii
 	const struct i2c_client *client = data->client;
 	const struct ak_def *def = data->def;
 	int ret;
-	s16 buff[8]; /* 3 x 16 bits axis values + 1 aligned 64 bits timestamp */
 	__le16 fval[3];
 
 	mutex_lock(&data->lock);
@@ -838,12 +843,13 @@ static void ak8975_fill_buffer(struct ii
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


