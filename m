Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EFFE27508F
	for <lists+stable@lfdr.de>; Wed, 23 Sep 2020 08:00:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbgIWGAi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Sep 2020 02:00:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:39482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726179AbgIWGAi (ORCPT <rfc822;Stable@vger.kernel.org>);
        Wed, 23 Sep 2020 02:00:38 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7328020639;
        Wed, 23 Sep 2020 06:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600840838;
        bh=YnUyw7Zg38JNecnlnHJ/FSm2JQfF9x82OkWjX+eh8xo=;
        h=Subject:To:From:Date:From;
        b=2uRu3GbU4d/5Up8F0SCH2EUGQBvpEWpp3OySxjWBnzn2Pn3PkGnOU6ATfV+jRpZwc
         cbhPRmq9dPBL76vKdYk+4Obzry9/JCq+1bcoR2WIX9GHqmruli5yd1I7hw4APoZC2k
         0fqSqqor5m9ZdBiFxCzM5f2g7YpZRimttIkRoGKg=
Subject: patch "iio:gyro:itg3200: Fix timestamp alignment and prevent data leak." added to staging-next
To:     Jonathan.Cameron@huawei.com, Stable@vger.kernel.org,
        andy.shevchenko@gmail.com, lars@metafoo.de
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 23 Sep 2020 07:56:35 +0200
Message-ID: <16008405953681@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio:gyro:itg3200: Fix timestamp alignment and prevent data leak.

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 10ab7cfd5522f0041028556dac864a003e158556 Mon Sep 17 00:00:00 2001
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Date: Wed, 22 Jul 2020 16:50:41 +0100
Subject: iio:gyro:itg3200: Fix timestamp alignment and prevent data leak.

One of a class of bugs pointed out by Lars in a recent review.
iio_push_to_buffers_with_timestamp assumes the buffer used is aligned
to the size of the timestamp (8 bytes).  This is not guaranteed in
this driver which uses a 16 byte array of smaller elements on the stack.
This is fixed by using an explicit c structure. As there are no
holes in the structure, there is no possiblity of data leakage
in this case.

The explicit alignment of ts is not strictly necessary but potentially
makes the code slightly less fragile.  It also removes the possibility
of this being cut and paste into another driver where the alignment
isn't already true.

Fixes: 36e0371e7764 ("iio:itg3200: Use iio_push_to_buffers_with_timestamp()")
Reported-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: <Stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200722155103.979802-6-jic23@kernel.org
---
 drivers/iio/gyro/itg3200_buffer.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/iio/gyro/itg3200_buffer.c b/drivers/iio/gyro/itg3200_buffer.c
index d3fbe9d86467..1c3c1bd53374 100644
--- a/drivers/iio/gyro/itg3200_buffer.c
+++ b/drivers/iio/gyro/itg3200_buffer.c
@@ -46,13 +46,20 @@ static irqreturn_t itg3200_trigger_handler(int irq, void *p)
 	struct iio_poll_func *pf = p;
 	struct iio_dev *indio_dev = pf->indio_dev;
 	struct itg3200 *st = iio_priv(indio_dev);
-	__be16 buf[ITG3200_SCAN_ELEMENTS + sizeof(s64)/sizeof(u16)];
-
-	int ret = itg3200_read_all_channels(st->i2c, buf);
+	/*
+	 * Ensure correct alignment and padding including for the
+	 * timestamp that may be inserted.
+	 */
+	struct {
+		__be16 buf[ITG3200_SCAN_ELEMENTS];
+		s64 ts __aligned(8);
+	} scan;
+
+	int ret = itg3200_read_all_channels(st->i2c, scan.buf);
 	if (ret < 0)
 		goto error_ret;
 
-	iio_push_to_buffers_with_timestamp(indio_dev, buf, pf->timestamp);
+	iio_push_to_buffers_with_timestamp(indio_dev, &scan, pf->timestamp);
 
 	iio_trigger_notify_done(indio_dev->trig);
 
-- 
2.28.0


