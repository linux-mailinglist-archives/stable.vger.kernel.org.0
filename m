Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B535738D44E
	for <lists+stable@lfdr.de>; Sat, 22 May 2021 09:50:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230128AbhEVHv5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 May 2021 03:51:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:35140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230114AbhEVHv4 (ORCPT <rfc822;Stable@vger.kernel.org>);
        Sat, 22 May 2021 03:51:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1D6756120D;
        Sat, 22 May 2021 07:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621669832;
        bh=VgXTx4PzElnsLgeSyhPK1AM4VZsj2R5pVN/oz3Ct768=;
        h=Subject:To:From:Date:From;
        b=Jc8X+LAlFXGCNsz7ytwUgqsuGSE5K5vwOKe4C5wBAbQ7h3oqLl2vzs/U50v1mRDQP
         lHPEaBKm+q2jYU4DLLA0iOaOLZA4lLN5xZlR2FxjrB5Wo3X0yKS1jfMiDRHnIX4mc3
         /WUbSZu4f7Ace+K7DwA9r/b6O+APS2ow3L7/FTXM=
Subject: patch "iio: adc: ad7768-1: Fix too small buffer passed to" added to staging-linus
To:     Jonathan.Cameron@huawei.com, Stable@vger.kernel.org,
        andy.shevchenko@gmail.com
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 22 May 2021 09:50:20 +0200
Message-ID: <1621669820100154@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: adc: ad7768-1: Fix too small buffer passed to

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From a1caeebab07e9d72eec534489f47964782b93ba9 Mon Sep 17 00:00:00 2001
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Date: Sat, 1 May 2021 17:53:13 +0100
Subject: iio: adc: ad7768-1: Fix too small buffer passed to
 iio_push_to_buffers_with_timestamp()

Add space for the timestamp to be inserted.  Also ensure correct
alignment for passing to iio_push_to_buffers_with_timestamp()

Fixes: a5f8c7da3dbe ("iio: adc: Add AD7768-1 ADC basic support")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20210501165314.511954-2-jic23@kernel.org
Cc: <Stable@vger.kernel.org>
---
 drivers/iio/adc/ad7768-1.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/adc/ad7768-1.c b/drivers/iio/adc/ad7768-1.c
index c945f1349623..60f21fed6dcb 100644
--- a/drivers/iio/adc/ad7768-1.c
+++ b/drivers/iio/adc/ad7768-1.c
@@ -167,6 +167,10 @@ struct ad7768_state {
 	 * transfer buffers to live in their own cache lines.
 	 */
 	union {
+		struct {
+			__be32 chan;
+			s64 timestamp;
+		} scan;
 		__be32 d32;
 		u8 d8[2];
 	} data ____cacheline_aligned;
@@ -469,11 +473,11 @@ static irqreturn_t ad7768_trigger_handler(int irq, void *p)
 
 	mutex_lock(&st->lock);
 
-	ret = spi_read(st->spi, &st->data.d32, 3);
+	ret = spi_read(st->spi, &st->data.scan.chan, 3);
 	if (ret < 0)
 		goto err_unlock;
 
-	iio_push_to_buffers_with_timestamp(indio_dev, &st->data.d32,
+	iio_push_to_buffers_with_timestamp(indio_dev, &st->data.scan,
 					   iio_get_time_ns(indio_dev));
 
 	iio_trigger_notify_done(indio_dev->trig);
-- 
2.31.1


