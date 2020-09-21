Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5ADD27300C
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 19:02:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729130AbgIUQiF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:38:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:38650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729114AbgIUQhw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:37:52 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C272238E6;
        Mon, 21 Sep 2020 16:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706271;
        bh=+6EL+ChW+KRaepAzFdel0niAkrGCKwWtTHIkImbjSt4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rzCROzHRTepDUhgivnrnuBFQRogjXew1qltxXmoTa16HsAuui9DvUw40muo1vOMia
         d5kOhbIZLTwXvbiByZEBUcKYS8whCXfBqOke00XmJYj2rbmliDwL1IRN5D6Lo64pYw
         PeILLLOnenoljzRvlv3RCCP0m8NS0Nou2mkCfv24=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Narcisa Ana Maria Vasile <narcisaanamaria12@gmail.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Stable@vger.kernel.org
Subject: [PATCH 4.14 34/94] iio:chemical:ccs811: Fix timestamp alignment and prevent data leak.
Date:   Mon, 21 Sep 2020 18:27:21 +0200
Message-Id: <20200921162037.114034032@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162035.541285330@linuxfoundation.org>
References: <20200921162035.541285330@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

commit eb1a148ef41d8ae8d9201efc3f1b145976290331 upstream.

One of a class of bugs pointed out by Lars in a recent review.
iio_push_to_buffers_with_timestamp assumes the buffer used is aligned
to the size of the timestamp (8 bytes).  This is not guaranteed in
this driver which uses an array of smaller elements on the stack.
As Lars also noted this anti pattern can involve a leak of data to
userspace and that indeed can happen here.  We close both issues by
moving to a suitable structure in the iio_priv() data with alignment
explicitly requested.  This data is allocated with kzalloc so no
data can leak appart from previous readings.

The explicit alignment of ts is necessary to ensure consistent
padding for x86_32 in which the ts would otherwise be 4 byte aligned.

Fixes: 283d26917ad6 ("iio: chemical: ccs811: Add triggered buffer support")
Reported-by: Lars-Peter Clausen <lars@metafoo.de>
Cc: Narcisa Ana Maria Vasile <narcisaanamaria12@gmail.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/chemical/ccs811.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/drivers/iio/chemical/ccs811.c
+++ b/drivers/iio/chemical/ccs811.c
@@ -73,6 +73,11 @@ struct ccs811_data {
 	struct i2c_client *client;
 	struct mutex lock; /* Protect readings */
 	struct ccs811_reading buffer;
+	/* Ensures correct alignment of timestamp if present */
+	struct {
+		s16 channels[2];
+		s64 ts __aligned(8);
+	} scan;
 };
 
 static const struct iio_chan_spec ccs811_channels[] = {
@@ -275,17 +280,17 @@ static irqreturn_t ccs811_trigger_handle
 	struct iio_dev *indio_dev = pf->indio_dev;
 	struct ccs811_data *data = iio_priv(indio_dev);
 	struct i2c_client *client = data->client;
-	s16 buf[8]; /* s16 eCO2 + s16 TVOC + padding + 8 byte timestamp */
 	int ret;
 
-	ret = i2c_smbus_read_i2c_block_data(client, CCS811_ALG_RESULT_DATA, 4,
-					    (u8 *)&buf);
+	ret = i2c_smbus_read_i2c_block_data(client, CCS811_ALG_RESULT_DATA,
+					    sizeof(data->scan.channels),
+					    (u8 *)data->scan.channels);
 	if (ret != 4) {
 		dev_err(&client->dev, "cannot read sensor data\n");
 		goto err;
 	}
 
-	iio_push_to_buffers_with_timestamp(indio_dev, buf,
+	iio_push_to_buffers_with_timestamp(indio_dev, &data->scan,
 					   iio_get_time_ns(indio_dev));
 
 err:


