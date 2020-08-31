Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34B95257743
	for <lists+stable@lfdr.de>; Mon, 31 Aug 2020 12:26:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726503AbgHaK0e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Aug 2020 06:26:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:56068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726472AbgHaK0d (ORCPT <rfc822;Stable@vger.kernel.org>);
        Mon, 31 Aug 2020 06:26:33 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 47DDD2072D;
        Mon, 31 Aug 2020 10:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598869592;
        bh=X5uz5DAbaUingsClXj9MgKSMa7KtrNLRHDwhEKHYErM=;
        h=Subject:To:From:Date:From;
        b=TrZlvjqZ/pr3f6itiKXOdYy9cEyYPa6WAKcXSFtoab6CgchleKnAyZWeP8BTLWYHO
         nCsUDJRdxM0HnDdhD+5lZ5xrqs2veHXr2bMPaJ4HdXeKnZwZcQMNJF/2w3wlOAG3a6
         ZdL+HBlwxXqH8LCRMOGGSs1x56cq3Nq9cL8lngQo=
Subject: patch "iio:magnetometer:ak8975 Fix alignment and data leak issues." added to staging-linus
To:     Jonathan.Cameron@huawei.com, Stable@vger.kernel.org,
        andy.shevchenko@gmail.com, gregor.boirie@parrot.com,
        lars@metafoo.de, linus.walleij@linaro.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 31 Aug 2020 12:26:22 +0200
Message-ID: <15988695822097@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio:magnetometer:ak8975 Fix alignment and data leak issues.

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 02ad21cefbac4d89ac443866f25b90449527737b Mon Sep 17 00:00:00 2001
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Date: Wed, 22 Jul 2020 16:50:49 +0100
Subject: iio:magnetometer:ak8975 Fix alignment and data leak issues.

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
---
 drivers/iio/magnetometer/ak8975.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/iio/magnetometer/ak8975.c b/drivers/iio/magnetometer/ak8975.c
index 03d71f796177..623766ff800b 100644
--- a/drivers/iio/magnetometer/ak8975.c
+++ b/drivers/iio/magnetometer/ak8975.c
@@ -366,6 +366,12 @@ struct ak8975_data {
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
@@ -793,7 +799,6 @@ static void ak8975_fill_buffer(struct iio_dev *indio_dev)
 	const struct i2c_client *client = data->client;
 	const struct ak_def *def = data->def;
 	int ret;
-	s16 buff[8]; /* 3 x 16 bits axis values + 1 aligned 64 bits timestamp */
 	__le16 fval[3];
 
 	mutex_lock(&data->lock);
@@ -816,12 +821,13 @@ static void ak8975_fill_buffer(struct iio_dev *indio_dev)
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
-- 
2.28.0


