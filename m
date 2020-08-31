Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2D83257741
	for <lists+stable@lfdr.de>; Mon, 31 Aug 2020 12:26:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbgHaK03 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Aug 2020 06:26:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:55772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726472AbgHaK02 (ORCPT <rfc822;Stable@vger.kernel.org>);
        Mon, 31 Aug 2020 06:26:28 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9906421473;
        Mon, 31 Aug 2020 10:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598869588;
        bh=fO9wIfRLVmXWdguQlKlAhsQEIkbzhsIfr42Ye34YwZ0=;
        h=Subject:To:From:Date:From;
        b=tsYX1M/JQgLmTlf+N6jxbuP/RSI1Rs/bu6uY1GvjQ9vFydLtgfYCO2f6sUh2q0SBH
         /pM8wnO2FBNsNaITZtuGjxFV0cInYDyDtqkRe+ya2whuwlxf9jx27kRY+Q3UHOmQa3
         ekaarLMgqrJN7mOSIAdneMw1C7PmH9F9IqARhZGM=
Subject: patch "iio:light:max44000 Fix timestamp alignment and prevent data leak." added to staging-linus
To:     Jonathan.Cameron@huawei.com, Stable@vger.kernel.org,
        andy.shevchenko@gmail.com, lars@metafoo.de
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 31 Aug 2020 12:26:20 +0200
Message-ID: <1598869580100208@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio:light:max44000 Fix timestamp alignment and prevent data leak.

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 523628852a5f5f34a15252b2634d0498d3cfb347 Mon Sep 17 00:00:00 2001
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Date: Wed, 22 Jul 2020 16:50:45 +0100
Subject: iio:light:max44000 Fix timestamp alignment and prevent data leak.

One of a class of bugs pointed out by Lars in a recent review.
iio_push_to_buffers_with_timestamp assumes the buffer used is aligned
to the size of the timestamp (8 bytes).  This is not guaranteed in
this driver which uses a 16 byte array of smaller elements on the stack.
As Lars also noted this anti pattern can involve a leak of data to
userspace and that indeed can happen here.  We close both issues by
moving to a suitable structure in the iio_priv().
This data is allocated with kzalloc so no data can leak appart
from previous readings.

It is necessary to force the alignment of ts to avoid the padding
on x86_32 being different from 64 bit platorms (it alows for
4 bytes aligned 8 byte types.

Fixes: 06ad7ea10e2b ("max44000: Initial triggered buffer support")
Reported-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: <Stable@vger.kernel.org>
---
 drivers/iio/light/max44000.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/iio/light/max44000.c b/drivers/iio/light/max44000.c
index aa8ed1e3e89a..b8e721bced5b 100644
--- a/drivers/iio/light/max44000.c
+++ b/drivers/iio/light/max44000.c
@@ -75,6 +75,11 @@
 struct max44000_data {
 	struct mutex lock;
 	struct regmap *regmap;
+	/* Ensure naturally aligned timestamp */
+	struct {
+		u16 channels[2];
+		s64 ts __aligned(8);
+	} scan;
 };
 
 /* Default scale is set to the minimum of 0.03125 or 1 / (1 << 5) lux */
@@ -488,7 +493,6 @@ static irqreturn_t max44000_trigger_handler(int irq, void *p)
 	struct iio_poll_func *pf = p;
 	struct iio_dev *indio_dev = pf->indio_dev;
 	struct max44000_data *data = iio_priv(indio_dev);
-	u16 buf[8]; /* 2x u16 + padding + 8 bytes timestamp */
 	int index = 0;
 	unsigned int regval;
 	int ret;
@@ -498,17 +502,17 @@ static irqreturn_t max44000_trigger_handler(int irq, void *p)
 		ret = max44000_read_alsval(data);
 		if (ret < 0)
 			goto out_unlock;
-		buf[index++] = ret;
+		data->scan.channels[index++] = ret;
 	}
 	if (test_bit(MAX44000_SCAN_INDEX_PRX, indio_dev->active_scan_mask)) {
 		ret = regmap_read(data->regmap, MAX44000_REG_PRX_DATA, &regval);
 		if (ret < 0)
 			goto out_unlock;
-		buf[index] = regval;
+		data->scan.channels[index] = regval;
 	}
 	mutex_unlock(&data->lock);
 
-	iio_push_to_buffers_with_timestamp(indio_dev, buf,
+	iio_push_to_buffers_with_timestamp(indio_dev, &data->scan,
 					   iio_get_time_ns(indio_dev));
 	iio_trigger_notify_done(indio_dev->trig);
 	return IRQ_HANDLED;
-- 
2.28.0


