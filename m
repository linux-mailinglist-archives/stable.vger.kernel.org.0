Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E77F1275092
	for <lists+stable@lfdr.de>; Wed, 23 Sep 2020 08:00:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726629AbgIWGAq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Sep 2020 02:00:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:39648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726179AbgIWGAq (ORCPT <rfc822;Stable@vger.kernel.org>);
        Wed, 23 Sep 2020 02:00:46 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 42829221EF;
        Wed, 23 Sep 2020 06:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600840845;
        bh=v0y8b5Qsx/wddV9JM/tJAQhW0JhqVbuOY5Eb46y/Z+4=;
        h=Subject:To:From:Date:From;
        b=sNRL3jf2QWvymx6446fUaDNrp/8mIsQAMSKIBtzGsT1f2oIc/QOUpORI2SPEGR6w+
         uRN5fs+9HGdxuO/jMwGOXE5OYcTsU62dTmHbiwT+BItK0NgvlHXiZOziMgEdlMHM/Z
         VZMaMwDpkJGkgDI6nmgxWoR4jQij2PR2iUEx6T+U=
Subject: patch "iio:adc:ti-adc0832 Fix alignment issue with timestamp" added to staging-next
To:     Jonathan.Cameron@huawei.com, Stable@vger.kernel.org,
        akinobu.mita@gmail.com, andy.shevchenko@gmail.com, lars@metafoo.de
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 23 Sep 2020 07:56:38 +0200
Message-ID: <160084059834242@kroah.com>
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
in the staging-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

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


