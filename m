Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F22B226898
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:23:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733226AbgGTQII (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:08:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:45380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732527AbgGTQIH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:08:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F5962065E;
        Mon, 20 Jul 2020 16:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261286;
        bh=6A7pUNuFUs6rSN73jvhbreK2J1VkrLL4f5bZyC7umC0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gCdrFOETEPGRavoXX0UmLlRigGCoLJtMkEs9ASJdjcD+NsMpHZAmf3F0heZzMEm74
         WaRQ2pElI3UrEJ3OUywU++/nvFITb95R/g3D9R4se5uuIOTXReIPDmOWN8KJZlVE6S
         APEwO7af24HVudKPQAPVLRhqT/UbH9rQEpp4whkU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Matt Ranostay <matt.ranostay@konsulko.com>,
        Alison Schofield <amsfield22@gmail.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Stable@vger.kernel.org
Subject: [PATCH 5.7 061/244] iio:humidity:hdc100x Fix alignment and data leak issues
Date:   Mon, 20 Jul 2020 17:35:32 +0200
Message-Id: <20200720152828.757780064@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152825.863040590@linuxfoundation.org>
References: <20200720152825.863040590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

commit ea5e7a7bb6205d24371373cd80325db1bc15eded upstream.

One of a class of bugs pointed out by Lars in a recent review.
iio_push_to_buffers_with_timestamp assumes the buffer used is aligned
to the size of the timestamp (8 bytes).  This is not guaranteed in
this driver which uses an array of smaller elements on the stack.
As Lars also noted this anti pattern can involve a leak of data to
userspace and that indeed can happen here.  We close both issues by
moving to a suitable structure in the iio_priv() data.
This data is allocated with kzalloc so no data can leak apart
from previous readings.

Fixes: 16bf793f86b2 ("iio: humidity: hdc100x: add triggered buffer support for HDC100X")
Reported-by: Lars-Peter Clausen <lars@metafoo.de>
Acked-by: Matt Ranostay <matt.ranostay@konsulko.com>
Cc: Alison Schofield <amsfield22@gmail.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/humidity/hdc100x.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/iio/humidity/hdc100x.c
+++ b/drivers/iio/humidity/hdc100x.c
@@ -38,6 +38,11 @@ struct hdc100x_data {
 
 	/* integration time of the sensor */
 	int adc_int_us[2];
+	/* Ensure natural alignment of timestamp */
+	struct {
+		__be16 channels[2];
+		s64 ts __aligned(8);
+	} scan;
 };
 
 /* integration time in us */
@@ -322,7 +327,6 @@ static irqreturn_t hdc100x_trigger_handl
 	struct i2c_client *client = data->client;
 	int delay = data->adc_int_us[0] + data->adc_int_us[1];
 	int ret;
-	s16 buf[8];  /* 2x s16 + padding + 8 byte timestamp */
 
 	/* dual read starts at temp register */
 	mutex_lock(&data->lock);
@@ -333,13 +337,13 @@ static irqreturn_t hdc100x_trigger_handl
 	}
 	usleep_range(delay, delay + 1000);
 
-	ret = i2c_master_recv(client, (u8 *)buf, 4);
+	ret = i2c_master_recv(client, (u8 *)data->scan.channels, 4);
 	if (ret < 0) {
 		dev_err(&client->dev, "cannot read sensor data\n");
 		goto err;
 	}
 
-	iio_push_to_buffers_with_timestamp(indio_dev, buf,
+	iio_push_to_buffers_with_timestamp(indio_dev, &data->scan,
 					   iio_get_time_ns(indio_dev));
 err:
 	mutex_unlock(&data->lock);


