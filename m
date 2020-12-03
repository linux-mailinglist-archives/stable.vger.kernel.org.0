Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FD522CE088
	for <lists+stable@lfdr.de>; Thu,  3 Dec 2020 22:21:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727460AbgLCVUr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Dec 2020 16:20:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:35292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726290AbgLCVUq (ORCPT <rfc822;Stable@vger.kernel.org>);
        Thu, 3 Dec 2020 16:20:46 -0500
Subject: patch "iio:light:rpr0521: Fix timestamp alignment and prevent data leak." added to staging-testing
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607030405;
        bh=jbNFAZXLhddlDrJd0VqAGb14n2nXaiXGO+jIH5CunL8=;
        h=To:From:Date:From;
        b=0zEHTYpexjxCsofkDDq/yJVsx64rUUq3NPc8GA50wQQ7PMC2+5zDLB4Anuy28cxIr
         /USPXKnpGssKGtzGapifGQcxuhJP3y7scJicQ36o/O7k7DL3IpcvpclEXwLaevnLe/
         AYNgt3+T6WOwP34FQv7rSHKgf+CiZHKEQbrjWrqc=
To:     Jonathan.Cameron@huawei.com, Stable@vger.kernel.org,
        alexandru.ardelean@analog.com, mikko.koivunen@fi.rohmeurope.com
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 03 Dec 2020 22:19:08 +0100
Message-ID: <1607030348138189@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio:light:rpr0521: Fix timestamp alignment and prevent data leak.

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the staging-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From a61817216bcc755eabbcb1cf281d84ccad267ed1 Mon Sep 17 00:00:00 2001
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Date: Sun, 20 Sep 2020 12:27:35 +0100
Subject: iio:light:rpr0521: Fix timestamp alignment and prevent data leak.

One of a class of bugs pointed out by Lars in a recent review.
iio_push_to_buffers_with_timestamp() assumes the buffer used is aligned
to the size of the timestamp (8 bytes).  This is not guaranteed in
this driver which uses an array of smaller elements on the stack.
As Lars also noted this anti pattern can involve a leak of data to
userspace and that indeed can happen here.  We close both issues by
moving to a suitable structure in the iio_priv().
This data is allocated with kzalloc() so no data can leak apart
from previous readings and in this case the status byte from the device.

The forced alignment of ts is not necessary in this case but it
potentially makes the code less fragile.

>From personal communications with Mikko:

We could probably split the reading of the int register, but it
would mean a significant performance cost of 20 i2c clock cycles.

Fixes: e12ffd241c00 ("iio: light: rpr0521 triggered buffer")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
Cc: Mikko Koivunen <mikko.koivunen@fi.rohmeurope.com>
Cc: <Stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200920112742.170751-2-jic23@kernel.org
---
 drivers/iio/light/rpr0521.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/iio/light/rpr0521.c b/drivers/iio/light/rpr0521.c
index aa2972b04833..31224a33bade 100644
--- a/drivers/iio/light/rpr0521.c
+++ b/drivers/iio/light/rpr0521.c
@@ -194,6 +194,17 @@ struct rpr0521_data {
 	bool pxs_need_dis;
 
 	struct regmap *regmap;
+
+	/*
+	 * Ensure correct naturally aligned timestamp.
+	 * Note that the read will put garbage data into
+	 * the padding but this should not be a problem
+	 */
+	struct {
+		__le16 channels[3];
+		u8 garbage;
+		s64 ts __aligned(8);
+	} scan;
 };
 
 static IIO_CONST_ATTR(in_intensity_scale_available, RPR0521_ALS_SCALE_AVAIL);
@@ -449,8 +460,6 @@ static irqreturn_t rpr0521_trigger_consumer_handler(int irq, void *p)
 	struct rpr0521_data *data = iio_priv(indio_dev);
 	int err;
 
-	u8 buffer[16]; /* 3 16-bit channels + padding + ts */
-
 	/* Use irq timestamp when reasonable. */
 	if (iio_trigger_using_own(indio_dev) && data->irq_timestamp) {
 		pf->timestamp = data->irq_timestamp;
@@ -461,11 +470,11 @@ static irqreturn_t rpr0521_trigger_consumer_handler(int irq, void *p)
 		pf->timestamp = iio_get_time_ns(indio_dev);
 
 	err = regmap_bulk_read(data->regmap, RPR0521_REG_PXS_DATA,
-		&buffer,
+		data->scan.channels,
 		(3 * 2) + 1);	/* 3 * 16-bit + (discarded) int clear reg. */
 	if (!err)
 		iio_push_to_buffers_with_timestamp(indio_dev,
-						   buffer, pf->timestamp);
+						   &data->scan, pf->timestamp);
 	else
 		dev_err(&data->client->dev,
 			"Trigger consumer can't read from sensor.\n");
-- 
2.29.2


