Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B5463CDD84
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:39:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245561AbhGSO63 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:58:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:52468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244947AbhGSO50 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:57:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BE80C613C0;
        Mon, 19 Jul 2021 15:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626708914;
        bh=I6uD/zlwTea7JWHWedfC3b4Q9Pi/wr274i0zLaQlVwk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cv5t0/p7GY6srLXWiJu5kcHTygBXxch3AG85+xH34mnEeKWhl6jGdlefH5o+TXAxt
         P5FOGRMlHDcLNKSswYCB0B1spcD4DIEfQG7eCAtUs1PPzMv16VjkQDy0bn6d8IoWsh
         xZL85IrArcrFcJj1CIPGXFJXfvH11io6lvp3wTeo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Matt Ranostay <matt.ranostay@konsulko.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 179/421] iio: prox: pulsed-light: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
Date:   Mon, 19 Jul 2021 16:49:50 +0200
Message-Id: <20210719144952.637367881@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

[ Upstream commit 679cc377a03ff1944491eafc7355c1eb1fad4109 ]

To make code more readable, use a structure to express the channel
layout and ensure the timestamp is 8 byte aligned.

Found during an audit of all calls of uses of
iio_push_to_buffers_with_timestamp()

Fixes: cb119d535083 ("iio: proximity: add support for PulsedLight LIDAR")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Matt Ranostay <matt.ranostay@konsulko.com>
Acked-by: Matt Ranostay <matt.ranostay@konsulko.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20210501170121.512209-14-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/proximity/pulsedlight-lidar-lite-v2.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/iio/proximity/pulsedlight-lidar-lite-v2.c b/drivers/iio/proximity/pulsedlight-lidar-lite-v2.c
index 67f85268b63d..0c7617022407 100644
--- a/drivers/iio/proximity/pulsedlight-lidar-lite-v2.c
+++ b/drivers/iio/proximity/pulsedlight-lidar-lite-v2.c
@@ -43,7 +43,11 @@ struct lidar_data {
 	int (*xfer)(struct lidar_data *data, u8 reg, u8 *val, int len);
 	int i2c_enabled;
 
-	u16 buffer[8]; /* 2 byte distance + 8 byte timestamp */
+	/* Ensure timestamp is naturally aligned */
+	struct {
+		u16 chan;
+		s64 timestamp __aligned(8);
+	} scan;
 };
 
 static const struct iio_chan_spec lidar_channels[] = {
@@ -228,9 +232,9 @@ static irqreturn_t lidar_trigger_handler(int irq, void *private)
 	struct lidar_data *data = iio_priv(indio_dev);
 	int ret;
 
-	ret = lidar_get_measurement(data, data->buffer);
+	ret = lidar_get_measurement(data, &data->scan.chan);
 	if (!ret) {
-		iio_push_to_buffers_with_timestamp(indio_dev, data->buffer,
+		iio_push_to_buffers_with_timestamp(indio_dev, &data->scan,
 						   iio_get_time_ns(indio_dev));
 	} else if (ret != -EINVAL) {
 		dev_err(&data->client->dev, "cannot read LIDAR measurement");
-- 
2.30.2



