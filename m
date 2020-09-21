Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E8C8272CB4
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:35:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728739AbgIUQeY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:34:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:60894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728720AbgIUQeO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:34:14 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ADBB023976;
        Mon, 21 Sep 2020 16:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706054;
        bh=p7jydHRi2UcpgGqpxPC294TEpk0O700BEyFJFD72Stg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FnkTuMZrTAsKalrb3gpPd/dnFTJSHEOke7r7tVYlyAi+to8PIPDUvfUTDdg7P+0nN
         dX8yluJ1CxonVs6jCeVyll0S0rQm8PmxUx69f6uzO9wLbiH+mUrQ9BuQzhrj26ilyI
         /QsZWdgf31/fKFAjoYHcGtqm2I0kTkvhkqfAZoWI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Stable@vger.kernel.org
Subject: [PATCH 4.9 21/70] iio:adc:ti-adc081c Fix alignment and data leak issues
Date:   Mon, 21 Sep 2020 18:27:21 +0200
Message-Id: <20200921162036.086090915@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162035.136047591@linuxfoundation.org>
References: <20200921162035.136047591@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

commit 54f82df2ba86e2a8e9cbf4036d192366e3905c89 upstream.

One of a class of bugs pointed out by Lars in a recent review.
iio_push_to_buffers_with_timestamp assumes the buffer used is aligned
to the size of the timestamp (8 bytes).  This is not guaranteed in
this driver which uses an array of smaller elements on the stack.
As Lars also noted this anti pattern can involve a leak of data to
userspace and that indeed can happen here.  We close both issues by
moving to a suitable structure in the iio_priv().

This data is allocated with kzalloc so no data can leak apart
from previous readings.

The eplicit alignment of ts is necessary to ensure correct padding
on x86_32 where s64 is only aligned to 4 bytes.

Fixes: 08e05d1fce5c ("ti-adc081c: Initial triggered buffer support")
Reported-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/adc/ti-adc081c.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/iio/adc/ti-adc081c.c
+++ b/drivers/iio/adc/ti-adc081c.c
@@ -36,6 +36,12 @@ struct adc081c {
 
 	/* 8, 10 or 12 */
 	int bits;
+
+	/* Ensure natural alignment of buffer elements */
+	struct {
+		u16 channel;
+		s64 ts __aligned(8);
+	} scan;
 };
 
 #define REG_CONV_RES 0x00
@@ -132,14 +138,13 @@ static irqreturn_t adc081c_trigger_handl
 	struct iio_poll_func *pf = p;
 	struct iio_dev *indio_dev = pf->indio_dev;
 	struct adc081c *data = iio_priv(indio_dev);
-	u16 buf[8]; /* 2 bytes data + 6 bytes padding + 8 bytes timestamp */
 	int ret;
 
 	ret = i2c_smbus_read_word_swapped(data->i2c, REG_CONV_RES);
 	if (ret < 0)
 		goto out;
-	buf[0] = ret;
-	iio_push_to_buffers_with_timestamp(indio_dev, buf,
+	data->scan.channel = ret;
+	iio_push_to_buffers_with_timestamp(indio_dev, &data->scan,
 					   iio_get_time_ns(indio_dev));
 out:
 	iio_trigger_notify_done(indio_dev->trig);


