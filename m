Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B74F26B3DB
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:11:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727284AbgIOXLg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:11:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:48770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727261AbgIOOki (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:40:38 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 26BDA2223E;
        Tue, 15 Sep 2020 14:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600180216;
        bh=o4yFUxW44yI+1ijAx7NWlyNJO2q9xKAmGAsYVSSShjk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hFzyg+XfPNGbWp2xLSzFB3OX+CgJ7YNOp5/2unuZaYQ6b1ojJpYx/2FKfCGSXXXpR
         4/ONI+T42bDnxKaKv8aewBep2Yv9Iy7OGHrXISEvrgOiKHt51plGIt3oPSbSugDT9k
         h6pT9CIz0kLJqUgazDDAgtdVzIGR40/Y/RNffeuE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Stable@vger.kernel.org
Subject: [PATCH 5.8 124/177] iio:accel:mma8452: Fix timestamp alignment and prevent data leak.
Date:   Tue, 15 Sep 2020 16:13:15 +0200
Message-Id: <20200915140659.588568464@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140653.610388773@linuxfoundation.org>
References: <20200915140653.610388773@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

commit 89226a296d816727405d3fea684ef69e7d388bd8 upstream.

One of a class of bugs pointed out by Lars in a recent review.
iio_push_to_buffers_with_timestamp assumes the buffer used is aligned
to the size of the timestamp (8 bytes).  This is not guaranteed in
this driver which uses a 16 byte u8 array on the stack.  As Lars also noted
this anti pattern can involve a leak of data to userspace and that
indeed can happen here.  We close both issues by moving to
a suitable structure in the iio_priv() data with alignment
ensured by use of an explicit c structure.  This data is allocated
with kzalloc so no data can leak appart from previous readings.

The additional forcing of the 8 byte alignment of the timestamp
is not strictly necessary but makes the code less fragile by
making this explicit.

Fixes: c7eeea93ac60 ("iio: Add Freescale MMA8452Q 3-axis accelerometer driver")
Reported-by: Lars-Peter Clausen <lars@metafoo.de>
Cc: Peter Meerwald <pmeerw@pmeerw.net>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/accel/mma8452.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/iio/accel/mma8452.c
+++ b/drivers/iio/accel/mma8452.c
@@ -110,6 +110,12 @@ struct mma8452_data {
 	int sleep_val;
 	struct regulator *vdd_reg;
 	struct regulator *vddio_reg;
+
+	/* Ensure correct alignment of time stamp when present */
+	struct {
+		__be16 channels[3];
+		s64 ts __aligned(8);
+	} buffer;
 };
 
  /**
@@ -1091,14 +1097,13 @@ static irqreturn_t mma8452_trigger_handl
 	struct iio_poll_func *pf = p;
 	struct iio_dev *indio_dev = pf->indio_dev;
 	struct mma8452_data *data = iio_priv(indio_dev);
-	u8 buffer[16]; /* 3 16-bit channels + padding + ts */
 	int ret;
 
-	ret = mma8452_read(data, (__be16 *)buffer);
+	ret = mma8452_read(data, data->buffer.channels);
 	if (ret < 0)
 		goto done;
 
-	iio_push_to_buffers_with_timestamp(indio_dev, buffer,
+	iio_push_to_buffers_with_timestamp(indio_dev, &data->buffer,
 					   iio_get_time_ns(indio_dev));
 
 done:


