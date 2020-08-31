Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF71925773E
	for <lists+stable@lfdr.de>; Mon, 31 Aug 2020 12:26:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726106AbgHaK0W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Aug 2020 06:26:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:55276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726472AbgHaK0V (ORCPT <rfc822;Stable@vger.kernel.org>);
        Mon, 31 Aug 2020 06:26:21 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 332FD2098B;
        Mon, 31 Aug 2020 10:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598869580;
        bh=oN0MPWoJ7JCGhgFzZRbLIg0R5m6JGY24zMckJ47pW2E=;
        h=Subject:To:From:Date:From;
        b=j01jXnNsOuGpzokBmFRq+j5614xAmgoPIkkdA+i43xGLEk7jXRgD6+BCMBRVzN5Ax
         swmuF1xMoR84r3MUh1kZURZ1BfJ9ZFlW/laYytG896mOSZvwAMX5DBTE+se80F4yic
         KGh2xXCHwg3rCW8PtqoNK2NYaIM9ZxxLYWozhcqE=
Subject: patch "iio:accel:mma7455: Fix timestamp alignment and prevent data leak." added to staging-linus
To:     Jonathan.Cameron@huawei.com, Stable@vger.kernel.org,
        andy.shevchenko@gmail.com, lars@metafoo.de
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 31 Aug 2020 12:26:17 +0200
Message-ID: <159886957725356@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio:accel:mma7455: Fix timestamp alignment and prevent data leak.

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 7e5ac1f2206eda414f90c698fe1820dee873394d Mon Sep 17 00:00:00 2001
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Date: Wed, 22 Jul 2020 16:50:40 +0100
Subject: iio:accel:mma7455: Fix timestamp alignment and prevent data leak.

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
---
 drivers/iio/accel/mma7455_core.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/iio/accel/mma7455_core.c b/drivers/iio/accel/mma7455_core.c
index 7e99bcb3398d..922bd38ff6ea 100644
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
@@ -82,19 +90,19 @@ static irqreturn_t mma7455_trigger_handler(int irq, void *p)
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
-- 
2.28.0


