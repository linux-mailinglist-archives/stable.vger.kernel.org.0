Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2882B273CB1
	for <lists+stable@lfdr.de>; Tue, 22 Sep 2020 09:55:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbgIVHzC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Sep 2020 03:55:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:53154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726749AbgIVHzB (ORCPT <rfc822;Stable@vger.kernel.org>);
        Tue, 22 Sep 2020 03:55:01 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9BA6623A9C;
        Tue, 22 Sep 2020 07:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600761300;
        bh=931xmijdxf0DahwYrS4OxBX5h6f89KGIYZtZ91PTTIA=;
        h=Subject:To:From:Date:From;
        b=JHDhll44k+xgx+CrU4lZURXjTPX3U26FF+ewqFKhSOnQXAPaJBPhDxsWoolkJ3MFR
         6NQ/GaRXc2bWd9DxhuF4sse8hNtoDNZHmyMXd4/tzludhASnG0JARc7RM0M6aWlIRT
         jGPDhBmk7JFHlgAqgep9g+5sr3ciOlXcFM24tXE8=
Subject: patch "iio:adc:ti-adc0832 Fix alignment issue with timestamp" added to staging-testing
To:     Jonathan.Cameron@huawei.com, Stable@vger.kernel.org,
        akinobu.mita@gmail.com, andy.shevchenko@gmail.com, lars@metafoo.de
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 22 Sep 2020 09:47:50 +0200
Message-ID: <16007608706630@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio:adc:ti-adc0832 Fix alignment issue with timestamp

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the staging-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 39e91f3be4cba51c1560bcda3a343ed1f64dc916 Mon Sep 17 00:00:00 2001
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Date: Wed, 22 Jul 2020 16:51:00 +0100
Subject: iio:adc:ti-adc0832 Fix alignment issue with timestamp

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
---
 drivers/iio/adc/ti-adc0832.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/iio/adc/ti-adc0832.c b/drivers/iio/adc/ti-adc0832.c
index c7a085dce1f4..0261b3cfc92b 100644
--- a/drivers/iio/adc/ti-adc0832.c
+++ b/drivers/iio/adc/ti-adc0832.c
@@ -29,6 +29,12 @@ struct adc0832 {
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
@@ -200,7 +206,6 @@ static irqreturn_t adc0832_trigger_handler(int irq, void *p)
 	struct iio_poll_func *pf = p;
 	struct iio_dev *indio_dev = pf->indio_dev;
 	struct adc0832 *adc = iio_priv(indio_dev);
-	u8 data[24] = { }; /* 16x 1 byte ADC data + 8 bytes timestamp */
 	int scan_index;
 	int i = 0;
 
@@ -218,10 +223,10 @@ static irqreturn_t adc0832_trigger_handler(int irq, void *p)
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
-- 
2.28.0


