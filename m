Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0751C2A56A8
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:30:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730265AbgKCV3x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:29:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:33232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732239AbgKCU6j (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:58:39 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 70FE92053B;
        Tue,  3 Nov 2020 20:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437118;
        bh=V6YAqLlPazLFt0SqEKR9ID7rLQepHXZAToxSoBQElGU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S4RetmfZVo4LvXt8rgXxWQDZBQxQQpzwLlrrW5Iot1MUiwRlyv3A2n8Ry0T9Hhjo4
         CYaeAvO3+Pv0BDk5HYpg1YloUU/4BlM6q6coUWIsKiCdr6jqjLVHWpG8NdBxDH79X4
         kUkzE0TUhXJGdY90tjmBpbtfcmIqNOHE3/4lN4Gg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Akinobu Mita <akinobu.mita@gmail.com>, Stable@vger.kernel.org
Subject: [PATCH 5.4 152/214] iio:adc:ti-adc0832 Fix alignment issue with timestamp
Date:   Tue,  3 Nov 2020 21:36:40 +0100
Message-Id: <20201103203305.031549466@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203249.448706377@linuxfoundation.org>
References: <20201103203249.448706377@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

commit 39e91f3be4cba51c1560bcda3a343ed1f64dc916 upstream.

One of a class of bugs pointed out by Lars in a recent review.
iio_push_to_buffers_with_timestamp assumes the buffer used is aligned
to the size of the timestamp (8 bytes).  This is not guaranteed in
this driver which uses an array of smaller elements on the stack.

We fix this issues by moving to a suitable structure in the iio_priv()
data with alignment explicitly requested.  This data is allocated
with kzalloc so no data can leak apart from previous readings.
Note that previously no data could leak 'including' previous readings
but I don't think it is an issue to potentially leak them like
this now does.

In this case the postioning of the timestamp is depends on what
other channels are enabled. As such we cannot use a structure to
make the alignment explicit as it would be missleading by suggesting
only one possible location for the timestamp.

Fixes: 815bbc87462a ("iio: ti-adc0832: add triggered buffer support")
Reported-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Cc: <Stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200722155103.979802-25-jic23@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/adc/ti-adc0832.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/iio/adc/ti-adc0832.c
+++ b/drivers/iio/adc/ti-adc0832.c
@@ -28,6 +28,12 @@ struct adc0832 {
 	struct regulator *reg;
 	struct mutex lock;
 	u8 mux_bits;
+	/*
+	 * Max size needed: 16x 1 byte ADC data + 8 bytes timestamp
+	 * May be shorter if not all channels are enabled subject
+	 * to the timestamp remaining 8 byte aligned.
+	 */
+	u8 data[24] __aligned(8);
 
 	u8 tx_buf[2] ____cacheline_aligned;
 	u8 rx_buf[2];
@@ -199,7 +205,6 @@ static irqreturn_t adc0832_trigger_handl
 	struct iio_poll_func *pf = p;
 	struct iio_dev *indio_dev = pf->indio_dev;
 	struct adc0832 *adc = iio_priv(indio_dev);
-	u8 data[24] = { }; /* 16x 1 byte ADC data + 8 bytes timestamp */
 	int scan_index;
 	int i = 0;
 
@@ -217,10 +222,10 @@ static irqreturn_t adc0832_trigger_handl
 			goto out;
 		}
 
-		data[i] = ret;
+		adc->data[i] = ret;
 		i++;
 	}
-	iio_push_to_buffers_with_timestamp(indio_dev, data,
+	iio_push_to_buffers_with_timestamp(indio_dev, adc->data,
 					   iio_get_time_ns(indio_dev));
 out:
 	mutex_unlock(&adc->lock);


