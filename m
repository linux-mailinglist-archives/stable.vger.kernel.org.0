Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9507726B767
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 02:23:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727021AbgIPAXR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 20:23:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:60770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726709AbgIOOU7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:20:59 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2240D22246;
        Tue, 15 Sep 2020 14:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179412;
        bh=0eCDlAtE3oWH7png9qpI/kBROX/HBd7Ke+pF6aZ36mc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FCop60zdFBC0ofLzs68t0JJE4px5oPH9ISxLHmcmZQFuZlrAMDYN0x6J/+cQmDtxL
         C3tplq8Q9miM4rhEwY9u7qS1/NlrMo/CwITsGAxzGBTIN4ll0FK7uU1vkIaYBOi6e+
         2eCob9JrUuF6o1XLOGg+2Zlby5PCgp4ieHNT1rBY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Stable@vger.kernel.org
Subject: [PATCH 4.19 49/78] iio:light:max44000 Fix timestamp alignment and prevent data leak.
Date:   Tue, 15 Sep 2020 16:13:14 +0200
Message-Id: <20200915140636.030855247@linuxfoundation.org>
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

commit 523628852a5f5f34a15252b2634d0498d3cfb347 upstream.

One of a class of bugs pointed out by Lars in a recent review.
iio_push_to_buffers_with_timestamp assumes the buffer used is aligned
to the size of the timestamp (8 bytes).  This is not guaranteed in
this driver which uses a 16 byte array of smaller elements on the stack.
As Lars also noted this anti pattern can involve a leak of data to
userspace and that indeed can happen here.  We close both issues by
moving to a suitable structure in the iio_priv().
This data is allocated with kzalloc so no data can leak appart
from previous readings.

It is necessary to force the alignment of ts to avoid the padding
on x86_32 being different from 64 bit platorms (it alows for
4 bytes aligned 8 byte types.

Fixes: 06ad7ea10e2b ("max44000: Initial triggered buffer support")
Reported-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/light/max44000.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/iio/light/max44000.c
+++ b/drivers/iio/light/max44000.c
@@ -78,6 +78,11 @@
 struct max44000_data {
 	struct mutex lock;
 	struct regmap *regmap;
+	/* Ensure naturally aligned timestamp */
+	struct {
+		u16 channels[2];
+		s64 ts __aligned(8);
+	} scan;
 };
 
 /* Default scale is set to the minimum of 0.03125 or 1 / (1 << 5) lux */
@@ -491,7 +496,6 @@ static irqreturn_t max44000_trigger_hand
 	struct iio_poll_func *pf = p;
 	struct iio_dev *indio_dev = pf->indio_dev;
 	struct max44000_data *data = iio_priv(indio_dev);
-	u16 buf[8]; /* 2x u16 + padding + 8 bytes timestamp */
 	int index = 0;
 	unsigned int regval;
 	int ret;
@@ -501,17 +505,17 @@ static irqreturn_t max44000_trigger_hand
 		ret = max44000_read_alsval(data);
 		if (ret < 0)
 			goto out_unlock;
-		buf[index++] = ret;
+		data->scan.channels[index++] = ret;
 	}
 	if (test_bit(MAX44000_SCAN_INDEX_PRX, indio_dev->active_scan_mask)) {
 		ret = regmap_read(data->regmap, MAX44000_REG_PRX_DATA, &regval);
 		if (ret < 0)
 			goto out_unlock;
-		buf[index] = regval;
+		data->scan.channels[index] = regval;
 	}
 	mutex_unlock(&data->lock);
 
-	iio_push_to_buffers_with_timestamp(indio_dev, buf,
+	iio_push_to_buffers_with_timestamp(indio_dev, &data->scan,
 					   iio_get_time_ns(indio_dev));
 	iio_trigger_notify_done(indio_dev->trig);
 	return IRQ_HANDLED;


