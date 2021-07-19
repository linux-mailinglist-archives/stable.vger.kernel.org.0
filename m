Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A7763CD995
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:12:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242822AbhGSOay (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:30:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:38396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244329AbhGSO3g (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:29:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C64C461165;
        Mon, 19 Jul 2021 15:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626707358;
        bh=+mPVfOcxAxvOn4g1UTVHi39fRgRmaymEHJL+MrSZeuE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tBOwiWBodg/ShZQ2Z5ttz4mL3D9zL4JFjEKjcuRzw83Oemcprwwy8Vg+98fyP13qD
         wf8xiM3guenZiczocvt3/m3n+BHcHh1uu4LkX3YQBh7n6j28MEzx0W1Ss9Vs+STusD
         bWuWVxbg8028t/3FSB5IYNPcUPLwQX+M4PSGBKZ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 102/245] iio: humidity: am2315: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
Date:   Mon, 19 Jul 2021 16:50:44 +0200
Message-Id: <20210719144943.722446760@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.288257948@linuxfoundation.org>
References: <20210719144940.288257948@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

[ Upstream commit f4ca2e2595d9fee65d5ce0d218b22ce00e5b2915 ]

To make code more readable, use a structure to express the channel
layout and ensure the timestamp is 8 byte aligned.

Found during an audit of all calls of uses of
iio_push_to_buffers_with_timestamp()

Fixes: 0d96d5ead3f7 ("iio: humidity: Add triggered buffer support for AM2315")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20210501170121.512209-12-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/humidity/am2315.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/iio/humidity/am2315.c b/drivers/iio/humidity/am2315.c
index ff96b6d0fdae..77513fd84b99 100644
--- a/drivers/iio/humidity/am2315.c
+++ b/drivers/iio/humidity/am2315.c
@@ -36,7 +36,11 @@
 struct am2315_data {
 	struct i2c_client *client;
 	struct mutex lock;
-	s16 buffer[8]; /* 2x16-bit channels + 2x16 padding + 4x16 timestamp */
+	/* Ensure timestamp is naturally aligned */
+	struct {
+		s16 chans[2];
+		s64 timestamp __aligned(8);
+	} scan;
 };
 
 struct am2315_sensor_data {
@@ -170,20 +174,20 @@ static irqreturn_t am2315_trigger_handler(int irq, void *p)
 
 	mutex_lock(&data->lock);
 	if (*(indio_dev->active_scan_mask) == AM2315_ALL_CHANNEL_MASK) {
-		data->buffer[0] = sensor_data.hum_data;
-		data->buffer[1] = sensor_data.temp_data;
+		data->scan.chans[0] = sensor_data.hum_data;
+		data->scan.chans[1] = sensor_data.temp_data;
 	} else {
 		i = 0;
 		for_each_set_bit(bit, indio_dev->active_scan_mask,
 				 indio_dev->masklength) {
-			data->buffer[i] = (bit ? sensor_data.temp_data :
-						 sensor_data.hum_data);
+			data->scan.chans[i] = (bit ? sensor_data.temp_data :
+					       sensor_data.hum_data);
 			i++;
 		}
 	}
 	mutex_unlock(&data->lock);
 
-	iio_push_to_buffers_with_timestamp(indio_dev, data->buffer,
+	iio_push_to_buffers_with_timestamp(indio_dev, &data->scan,
 					   pf->timestamp);
 err:
 	iio_trigger_notify_done(indio_dev->trig);
-- 
2.30.2



