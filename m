Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E99B25773F
	for <lists+stable@lfdr.de>; Mon, 31 Aug 2020 12:26:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726485AbgHaK0Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Aug 2020 06:26:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:55452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726472AbgHaK0X (ORCPT <rfc822;Stable@vger.kernel.org>);
        Mon, 31 Aug 2020 06:26:23 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9986420EDD;
        Mon, 31 Aug 2020 10:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598869583;
        bh=+6pr4hO1FSPCf6uP57t/2XukUjiJpyoQLlHnUvdsgRU=;
        h=Subject:To:From:Date:From;
        b=I7IUj6AbmP4iiq/EaVFM1mIKwSrQQLBi6dc+9E4T4hqx2uFQdv5p+hObp4pSvw0Ad
         LmjXqCtVhLtXvyl/AbJEOLWBXNCHFRnN8m7kuJYXiHZPJVpaNA379/wFEikd/MtgqR
         eT4aiX9WFfz1ZNxGQBVHdXCY9j06lpEAP3r1BE8c=
Subject: patch "iio:proximity:mb1232: Fix timestamp alignment and prevent data leak." added to staging-linus
To:     Jonathan.Cameron@huawei.com, Stable@vger.kernel.org,
        ak@it-klinger.de, andy.shevchenko@gmail.com, lars@metafoo.de
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 31 Aug 2020 12:26:18 +0200
Message-ID: <159886957817498@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio:proximity:mb1232: Fix timestamp alignment and prevent data leak.

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From f60e8bb84282b8e633956cfe74b4f0d64ca73cec Mon Sep 17 00:00:00 2001
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Date: Wed, 22 Jul 2020 16:50:42 +0100
Subject: iio:proximity:mb1232: Fix timestamp alignment and prevent data leak.

One of a class of bugs pointed out by Lars in a recent review.
iio_push_to_buffers_with_timestamp assumes the buffer used is aligned
to the size of the timestamp (8 bytes).  This is not guaranteed in
this driver which uses a 16 byte s16 array on the stack   As Lars also noted
this anti pattern can involve a leak of data to userspace and that
indeed can happen here.  We close both issues by moving to
a suitable structure in the iio_priv() data with alignment
ensured by use of an explicit c structure.  This data is allocated
with kzalloc so no data can leak appart from previous readings.

In this case the forced alignment of the ts is necessary to ensure
correct padding on x86_32 where the s64 would only be 4 byte aligned.

Fixes: 16b05261537e ("mb1232.c: add distance iio sensor with i2c")
Reported-by: Lars-Peter Clausen <lars@metafoo.de>
Cc: Andreas Klinger <ak@it-klinger.de>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: <Stable@vger.kernel.org>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
---
 drivers/iio/proximity/mb1232.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/iio/proximity/mb1232.c b/drivers/iio/proximity/mb1232.c
index 654564c45248..ad4b1fb2607a 100644
--- a/drivers/iio/proximity/mb1232.c
+++ b/drivers/iio/proximity/mb1232.c
@@ -40,6 +40,11 @@ struct mb1232_data {
 	 */
 	struct completion	ranging;
 	int			irqnr;
+	/* Ensure correct alignment of data to push to IIO buffer */
+	struct {
+		s16 distance;
+		s64 ts __aligned(8);
+	} scan;
 };
 
 static irqreturn_t mb1232_handle_irq(int irq, void *dev_id)
@@ -113,17 +118,13 @@ static irqreturn_t mb1232_trigger_handler(int irq, void *p)
 	struct iio_poll_func *pf = p;
 	struct iio_dev *indio_dev = pf->indio_dev;
 	struct mb1232_data *data = iio_priv(indio_dev);
-	/*
-	 * triggered buffer
-	 * 16-bit channel + 48-bit padding + 64-bit timestamp
-	 */
-	s16 buffer[8] = { 0 };
 
-	buffer[0] = mb1232_read_distance(data);
-	if (buffer[0] < 0)
+	data->scan.distance = mb1232_read_distance(data);
+	if (data->scan.distance < 0)
 		goto err;
 
-	iio_push_to_buffers_with_timestamp(indio_dev, buffer, pf->timestamp);
+	iio_push_to_buffers_with_timestamp(indio_dev, &data->scan,
+					   pf->timestamp);
 
 err:
 	iio_trigger_notify_done(indio_dev->trig);
-- 
2.28.0


