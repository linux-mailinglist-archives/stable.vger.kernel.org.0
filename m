Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B15B5275093
	for <lists+stable@lfdr.de>; Wed, 23 Sep 2020 08:00:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbgIWGAt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Sep 2020 02:00:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:39708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726179AbgIWGAt (ORCPT <rfc822;Stable@vger.kernel.org>);
        Wed, 23 Sep 2020 02:00:49 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1CF1E235F7;
        Wed, 23 Sep 2020 06:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600840848;
        bh=pd1A26SaeT5WDk3MRDOA5rqghETWxMLja4okWKqEfbU=;
        h=Subject:To:From:Date:From;
        b=Vl7CD5yrgCZEPg+ZMwaCEfx9QQp/PCecdSJGob1QKmDPJCLXo3srug4HiL4rvTg0F
         eSxc/pFeXyJl6hzk/anC0hJPO/4fx4BQpcGoFVPi2LVMYkKlJ4Ud3DpzdFexCYqyYt
         zeZfMOcbuWhrQeybuNq4358WnPtq7nGZtMZxsvRA=
Subject: patch "iio:adc:ti-adc12138 Fix alignment issue with timestamp" added to staging-next
To:     Jonathan.Cameron@huawei.com, Stable@vger.kernel.org,
        akinobu.mita@gmail.com, andy.shevchenko@gmail.com, lars@metafoo.de
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 23 Sep 2020 07:56:39 +0200
Message-ID: <160084059910816@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio:adc:ti-adc12138 Fix alignment issue with timestamp

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 293e809b2e8e608b65a949101aaf7c0bd1224247 Mon Sep 17 00:00:00 2001
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Date: Wed, 22 Jul 2020 16:51:01 +0100
Subject: iio:adc:ti-adc12138 Fix alignment issue with timestamp

One of a class of bugs pointed out by Lars in a recent review.
iio_push_to_buffers_with_timestamp assumes the buffer used is aligned
to the size of the timestamp (8 bytes).  This is not guaranteed in
this driver which uses an array of smaller elements on the stack.

We move to a suitable structure in the iio_priv() data with alignment
explicitly requested.  This data is allocated with kzalloc so no
data can leak apart from previous readings. Note that previously
no leak at all could occur, but previous readings should never
be a problem.

In this case the timestamp location depends on what other channels
are enabled. As such we can't use a structure without misleading
by suggesting only one possible timestamp location.

Fixes: 50a6edb1b6e0 ("iio: adc: add ADC12130/ADC12132/ADC12138 ADC driver")
Reported-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Cc: <Stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200722155103.979802-26-jic23@kernel.org
---
 drivers/iio/adc/ti-adc12138.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/iio/adc/ti-adc12138.c b/drivers/iio/adc/ti-adc12138.c
index e485719cd2c4..fcd5d39dd03e 100644
--- a/drivers/iio/adc/ti-adc12138.c
+++ b/drivers/iio/adc/ti-adc12138.c
@@ -47,6 +47,12 @@ struct adc12138 {
 	struct completion complete;
 	/* The number of cclk periods for the S/H's acquisition time */
 	unsigned int acquisition_time;
+	/*
+	 * Maximum size needed: 16x 2 bytes ADC data + 8 bytes timestamp.
+	 * Less may be need if not all channels are enabled, as long as
+	 * the 8 byte alignment of the timestamp is maintained.
+	 */
+	__be16 data[20] __aligned(8);
 
 	u8 tx_buf[2] ____cacheline_aligned;
 	u8 rx_buf[2];
@@ -329,7 +335,6 @@ static irqreturn_t adc12138_trigger_handler(int irq, void *p)
 	struct iio_poll_func *pf = p;
 	struct iio_dev *indio_dev = pf->indio_dev;
 	struct adc12138 *adc = iio_priv(indio_dev);
-	__be16 data[20] = { }; /* 16x 2 bytes ADC data + 8 bytes timestamp */
 	__be16 trash;
 	int ret;
 	int scan_index;
@@ -345,7 +350,7 @@ static irqreturn_t adc12138_trigger_handler(int irq, void *p)
 		reinit_completion(&adc->complete);
 
 		ret = adc12138_start_and_read_conv(adc, scan_chan,
-						   i ? &data[i - 1] : &trash);
+					i ? &adc->data[i - 1] : &trash);
 		if (ret) {
 			dev_warn(&adc->spi->dev,
 				 "failed to start conversion\n");
@@ -362,7 +367,7 @@ static irqreturn_t adc12138_trigger_handler(int irq, void *p)
 	}
 
 	if (i) {
-		ret = adc12138_read_conv_data(adc, &data[i - 1]);
+		ret = adc12138_read_conv_data(adc, &adc->data[i - 1]);
 		if (ret) {
 			dev_warn(&adc->spi->dev,
 				 "failed to get conversion data\n");
@@ -370,7 +375,7 @@ static irqreturn_t adc12138_trigger_handler(int irq, void *p)
 		}
 	}
 
-	iio_push_to_buffers_with_timestamp(indio_dev, data,
+	iio_push_to_buffers_with_timestamp(indio_dev, adc->data,
 					   iio_get_time_ns(indio_dev));
 out:
 	mutex_unlock(&adc->lock);
-- 
2.28.0


