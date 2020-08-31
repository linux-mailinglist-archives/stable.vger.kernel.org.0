Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51E5F257745
	for <lists+stable@lfdr.de>; Mon, 31 Aug 2020 12:26:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbgHaK0i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Aug 2020 06:26:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:56402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726472AbgHaK0i (ORCPT <rfc822;Stable@vger.kernel.org>);
        Mon, 31 Aug 2020 06:26:38 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A5A420DD4;
        Mon, 31 Aug 2020 10:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598869597;
        bh=kEkjp4+ErGVNxpJ1hO7V4ewqacRryuOsfHhAyrcTOEU=;
        h=Subject:To:From:Date:From;
        b=FbYQDWRweI6gUBBBZK8qSAvaf8aFr/ft8fEDzLORYVXCLWQ7XPWLDgc2hBmzIIIml
         KmmgTxh69orzs6TrF/o1e7dST3Hxj3+QVbqm0JHql9jahU2S5EtPJ5YtCSYAK+z108
         qFD17feasjSqpghcqUag9NB4pcfPDtMl3bJkJBDQ=
Subject: patch "iio:adc:ti-adc084s021 Fix alignment and data leak issues." added to staging-linus
To:     Jonathan.Cameron@huawei.com, Stable@vger.kernel.org,
        andy.shevchenko@gmail.com, lars@metafoo.de, martenli@axis.com
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 31 Aug 2020 12:26:24 +0200
Message-ID: <159886958462116@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio:adc:ti-adc084s021 Fix alignment and data leak issues.

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From a661b571e3682705cb402a5cd1e970586a3ec00f Mon Sep 17 00:00:00 2001
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Date: Wed, 22 Jul 2020 16:50:57 +0100
Subject: iio:adc:ti-adc084s021 Fix alignment and data leak issues.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

One of a class of bugs pointed out by Lars in a recent review.
iio_push_to_buffers_with_timestamp assumes the buffer used is aligned
to the size of the timestamp (8 bytes).  This is not guaranteed in
this driver which uses an array of smaller elements on the stack.
As Lars also noted this anti pattern can involve a leak of data to
userspace and that indeed can happen here.  We close both issues by
moving to a suitable structure in the iio_priv().

This data is allocated with kzalloc so no data can leak apart from
previous readings.

The force alignment of ts is not strictly necessary in this case
but reduces the fragility of the code.

Fixes: 3691e5a69449 ("iio: adc: add driver for the ti-adc084s021 chip")
Reported-by: Lars-Peter Clausen <lars@metafoo.de>
Cc: Mårten Lindahl <martenli@axis.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: <Stable@vger.kernel.org>
---
 drivers/iio/adc/ti-adc084s021.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/iio/adc/ti-adc084s021.c b/drivers/iio/adc/ti-adc084s021.c
index 9017e1e24273..dfba34834a57 100644
--- a/drivers/iio/adc/ti-adc084s021.c
+++ b/drivers/iio/adc/ti-adc084s021.c
@@ -26,6 +26,11 @@ struct adc084s021 {
 	struct spi_transfer spi_trans;
 	struct regulator *reg;
 	struct mutex lock;
+	/* Buffer used to align data */
+	struct {
+		__be16 channels[4];
+		s64 ts __aligned(8);
+	} scan;
 	/*
 	 * DMA (thus cache coherency maintenance) requires the
 	 * transfer buffers to live in their own cache line.
@@ -141,14 +146,13 @@ static irqreturn_t adc084s021_buffer_trigger_handler(int irq, void *pollfunc)
 	struct iio_poll_func *pf = pollfunc;
 	struct iio_dev *indio_dev = pf->indio_dev;
 	struct adc084s021 *adc = iio_priv(indio_dev);
-	__be16 data[8] = {0}; /* 4 * 16-bit words of data + 8 bytes timestamp */
 
 	mutex_lock(&adc->lock);
 
-	if (adc084s021_adc_conversion(adc, &data) < 0)
+	if (adc084s021_adc_conversion(adc, adc->scan.channels) < 0)
 		dev_err(&adc->spi->dev, "Failed to read data\n");
 
-	iio_push_to_buffers_with_timestamp(indio_dev, data,
+	iio_push_to_buffers_with_timestamp(indio_dev, &adc->scan,
 					   iio_get_time_ns(indio_dev));
 	mutex_unlock(&adc->lock);
 	iio_trigger_notify_done(indio_dev->trig);
-- 
2.28.0


