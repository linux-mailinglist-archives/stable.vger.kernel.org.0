Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C955925773C
	for <lists+stable@lfdr.de>; Mon, 31 Aug 2020 12:26:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726468AbgHaK0R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Aug 2020 06:26:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:54970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726106AbgHaK0Q (ORCPT <rfc822;Stable@vger.kernel.org>);
        Mon, 31 Aug 2020 06:26:16 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A34E62137B;
        Mon, 31 Aug 2020 10:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598869576;
        bh=GH0CAA+uNxiC0E0Ml46TUYSydiC3I7ZliRo5gemvqig=;
        h=Subject:To:From:Date:From;
        b=Q4F+AjM81qLncAWXRT+PWlpM0twnHIUe4J92T5+6jjf2X6okNJyFuuIlkXkWpEJMb
         C8gagAEU9gaFReqyf1dAUlL9QfIhHuJ7BjgrWz7lqZSP5nJKIQ4dJAhgQF/susufe3
         9TQ1yoqvw6xmexMxdR5o8yTr72YQwlqM/Quea6Mk=
Subject: patch "iio:accel:mma8452: Fix timestamp alignment and prevent data leak." added to staging-linus
To:     Jonathan.Cameron@huawei.com, Stable@vger.kernel.org,
        andy.shevchenko@gmail.com, lars@metafoo.de, pmeerw@pmeerw.net
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 31 Aug 2020 12:26:15 +0200
Message-ID: <1598869575199238@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio:accel:mma8452: Fix timestamp alignment and prevent data leak.

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 89226a296d816727405d3fea684ef69e7d388bd8 Mon Sep 17 00:00:00 2001
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Date: Wed, 22 Jul 2020 16:50:38 +0100
Subject: iio:accel:mma8452: Fix timestamp alignment and prevent data leak.

One of a class of bugs pointed out by Lars in a recent review.
iio_push_to_buffers_with_timestamp assumes the buffer used is aligned
to the size of the timestamp (8 bytes).  This is not guaranteed in
this driver which uses a 16 byte u8 array on the stack.  As Lars also noted
this anti pattern can involve a leak of data to userspace and that
indeed can happen here.  We close both issues by moving to
a suitable structure in the iio_priv() data with alignment
ensured by use of an explicit c structure.  This data is allocated
with kzalloc so no data can leak appart from previous readings.

The additional forcing of the 8 byte alignment of the timestamp
is not strictly necessary but makes the code less fragile by
making this explicit.

Fixes: c7eeea93ac60 ("iio: Add Freescale MMA8452Q 3-axis accelerometer driver")
Reported-by: Lars-Peter Clausen <lars@metafoo.de>
Cc: Peter Meerwald <pmeerw@pmeerw.net>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: <Stable@vger.kernel.org>
---
 drivers/iio/accel/mma8452.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/iio/accel/mma8452.c b/drivers/iio/accel/mma8452.c
index ba27f8673131..1cf2b5db26ca 100644
--- a/drivers/iio/accel/mma8452.c
+++ b/drivers/iio/accel/mma8452.c
@@ -110,6 +110,12 @@ struct mma8452_data {
 	int sleep_val;
 	struct regulator *vdd_reg;
 	struct regulator *vddio_reg;
+
+	/* Ensure correct alignment of time stamp when present */
+	struct {
+		__be16 channels[3];
+		s64 ts __aligned(8);
+	} buffer;
 };
 
  /**
@@ -1091,14 +1097,13 @@ static irqreturn_t mma8452_trigger_handler(int irq, void *p)
 	struct iio_poll_func *pf = p;
 	struct iio_dev *indio_dev = pf->indio_dev;
 	struct mma8452_data *data = iio_priv(indio_dev);
-	u8 buffer[16]; /* 3 16-bit channels + padding + ts */
 	int ret;
 
-	ret = mma8452_read(data, (__be16 *)buffer);
+	ret = mma8452_read(data, data->buffer.channels);
 	if (ret < 0)
 		goto done;
 
-	iio_push_to_buffers_with_timestamp(indio_dev, buffer,
+	iio_push_to_buffers_with_timestamp(indio_dev, &data->buffer,
 					   iio_get_time_ns(indio_dev));
 
 done:
-- 
2.28.0


