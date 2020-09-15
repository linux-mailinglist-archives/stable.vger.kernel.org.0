Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8846F26A756
	for <lists+stable@lfdr.de>; Tue, 15 Sep 2020 16:41:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727080AbgIOOkt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 10:40:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:49932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727264AbgIOOkd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:40:33 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35E9622240;
        Tue, 15 Sep 2020 14:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179402;
        bh=CE3QUOg42KxiXLvlDiM/XXgY2b+uUBnrBOGwPivyvUI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DKae7+LVOYVTogIKysYlpiGOv6rSOfCFRi9ZtDtiIq8beRJi/Tx0h8lBIVptD4j0m
         foa5vEJeNkCj2kgxLGZoKQN9spwxD1UbC4v/6oREbTPwPHugiYdLtpFkam5cBP5DTB
         mI2RX9T/j3vf71qtI1S/MY1D98ha6p+vtoaNxXTY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Stable@vger.kernel.org
Subject: [PATCH 4.19 46/78] iio:adc:max1118 Fix alignment of timestamp and data leak issues
Date:   Tue, 15 Sep 2020 16:13:11 +0200
Message-Id: <20200915140635.889822953@linuxfoundation.org>
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

commit db8f06d97ec284dc018e2e4890d2e5035fde8630 upstream.

One of a class of bugs pointed out by Lars in a recent review.
iio_push_to_buffers_with_timestamp assumes the buffer used is aligned
to the size of the timestamp (8 bytes).  This is not guaranteed in
this driver which uses an array of smaller elements on the stack.
As Lars also noted this anti pattern can involve a leak of data to
userspace and that indeed can happen here.  We close both issues by
moving to a suitable structure in the iio_priv() data.

This data is allocated with kzalloc so no data can leak apart
from previous readings.

The explicit alignment of ts is necessary to ensure correct padding
on architectures where s64 is only 4 bytes aligned such as x86_32.

Fixes: a9e9c7153e96 ("iio: adc: add max1117/max1118/max1119 ADC driver")
Reported-by: Lars-Peter Clausen <lars@metafoo.de>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/adc/max1118.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/iio/adc/max1118.c
+++ b/drivers/iio/adc/max1118.c
@@ -38,6 +38,11 @@ struct max1118 {
 	struct spi_device *spi;
 	struct mutex lock;
 	struct regulator *reg;
+	/* Ensure natural alignment of buffer elements */
+	struct {
+		u8 channels[2];
+		s64 ts __aligned(8);
+	} scan;
 
 	u8 data ____cacheline_aligned;
 };
@@ -162,7 +167,6 @@ static irqreturn_t max1118_trigger_handl
 	struct iio_poll_func *pf = p;
 	struct iio_dev *indio_dev = pf->indio_dev;
 	struct max1118 *adc = iio_priv(indio_dev);
-	u8 data[16] = { }; /* 2x 8-bit ADC data + padding + 8 bytes timestamp */
 	int scan_index;
 	int i = 0;
 
@@ -180,10 +184,10 @@ static irqreturn_t max1118_trigger_handl
 			goto out;
 		}
 
-		data[i] = ret;
+		adc->scan.channels[i] = ret;
 		i++;
 	}
-	iio_push_to_buffers_with_timestamp(indio_dev, data,
+	iio_push_to_buffers_with_timestamp(indio_dev, &adc->scan,
 					   iio_get_time_ns(indio_dev));
 out:
 	mutex_unlock(&adc->lock);


