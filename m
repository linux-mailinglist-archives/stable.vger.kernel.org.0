Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E462C26B76F
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 02:23:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727489AbgIPAXi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 20:23:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:60788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726749AbgIOOUY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:20:24 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C4C52223D;
        Tue, 15 Sep 2020 14:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179397;
        bh=xWfbtvQi6jRbi8I/P0rqnE1igmz3Uiqjn4b6VweDl4k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oaqBHQqGU6DgtZ1KLo/OhSLmycfFfgKWfZhIVsAQ0ejTy98zlzHL0nPjtJfsu49bN
         sXt6E+myrKLOXIqZPY3pTgoJuhIVuPPIOT1sfnc/BgKSzmNTzKXjpvQahP8x23PuNt
         efFeLXWMSSNNHkmMhD0FmuUBszsVLxQBArHtG4ko=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        =?UTF-8?q?M=C3=A5rten=20Lindahl?= <martenli@axis.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Stable@vger.kernel.org
Subject: [PATCH 4.19 44/78] iio:adc:ti-adc084s021 Fix alignment and data leak issues.
Date:   Tue, 15 Sep 2020 16:13:09 +0200
Message-Id: <20200915140635.789360798@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140633.552502750@linuxfoundation.org>
References: <20200915140633.552502750@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

commit a661b571e3682705cb402a5cd1e970586a3ec00f upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/adc/ti-adc084s021.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/iio/adc/ti-adc084s021.c
+++ b/drivers/iio/adc/ti-adc084s021.c
@@ -28,6 +28,11 @@ struct adc084s021 {
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
@@ -143,14 +148,13 @@ static irqreturn_t adc084s021_buffer_tri
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


