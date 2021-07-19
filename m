Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB9783CD814
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:02:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242467AbhGSOUf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:20:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:56252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241627AbhGSOTl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:19:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D2EA16113E;
        Mon, 19 Jul 2021 15:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626706820;
        bh=sP1SRJLephM8UWKWGiuyiLAygRoAuUUq5ITtVR1wUso=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YxIQyePV+3gLmA1nQdHufjclm/Wbmz1tgwEc7nQSXIhr8Q/WMz2x+vDVfqXLJyt84
         lbMTa1zNTbWTVPWKgZh/w9cl35Wxhuywaw8tN7s+QKhHca8RYCye4O8rnidkLFHjpS
         1CWEV2qZMaIqd8VzEyUqZOKOrwWRj034A/dmjKUs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 079/188] iio: accel: stk8312: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
Date:   Mon, 19 Jul 2021 16:51:03 +0200
Message-Id: <20210719144931.436634648@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144913.076563739@linuxfoundation.org>
References: <20210719144913.076563739@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

[ Upstream commit f40a71ffec808e7e51848f63f0c0d3c32d65081b ]

To make code more readable, use a structure to express the channel
layout and ensure the timestamp is 8 byte aligned.

Found during an audit of all calls of this function.

Fixes: 95c12bba51c3 ("iio: accel: Add buffer mode for Sensortek STK8312")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20210501170121.512209-7-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/accel/stk8312.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/iio/accel/stk8312.c b/drivers/iio/accel/stk8312.c
index 85fe7f7247c1..945c80183f35 100644
--- a/drivers/iio/accel/stk8312.c
+++ b/drivers/iio/accel/stk8312.c
@@ -107,7 +107,11 @@ struct stk8312_data {
 	u8 mode;
 	struct iio_trigger *dready_trig;
 	bool dready_trigger_on;
-	s8 buffer[16]; /* 3x8-bit channels + 5x8 padding + 64-bit timestamp */
+	/* Ensure timestamp is naturally aligned */
+	struct {
+		s8 chans[3];
+		s64 timestamp __aligned(8);
+	} scan;
 };
 
 static IIO_CONST_ATTR(in_accel_scale_available, STK8312_SCALE_AVAIL);
@@ -444,7 +448,7 @@ static irqreturn_t stk8312_trigger_handler(int irq, void *p)
 		ret = i2c_smbus_read_i2c_block_data(data->client,
 						    STK8312_REG_XOUT,
 						    STK8312_ALL_CHANNEL_SIZE,
-						    data->buffer);
+						    data->scan.chans);
 		if (ret < STK8312_ALL_CHANNEL_SIZE) {
 			dev_err(&data->client->dev, "register read failed\n");
 			mutex_unlock(&data->lock);
@@ -458,12 +462,12 @@ static irqreturn_t stk8312_trigger_handler(int irq, void *p)
 				mutex_unlock(&data->lock);
 				goto err;
 			}
-			data->buffer[i++] = ret;
+			data->scan.chans[i++] = ret;
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



