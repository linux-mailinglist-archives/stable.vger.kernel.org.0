Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 645633C4F2A
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:43:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241537AbhGLHXY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:23:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:59578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344921AbhGLHVg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:21:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF76A611ED;
        Mon, 12 Jul 2021 07:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074328;
        bh=I5p2o2CF+1CWKnG1I811kITf9YGmJq55t3a7Rr4VvdM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x04LR6AEUdEIEvuJ8RiE/r08tJ5shKB1SOJm1rIrVRAfWgrLMd1Vt5ttV379kGsPX
         bLU8mSi25DSnsPgx+MqeD0z/yHOZi6/pS8QrVMDuV0S1T6NFK48e9rqZa5ibTccHGc
         lQ5rnw6dDaV9l09ZdMQnP8ZVuexO8onumpOS3pG8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Matt Ranostay <matt.ranostay@konsulko.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 544/700] iio: prox: pulsed-light: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
Date:   Mon, 12 Jul 2021 08:10:27 +0200
Message-Id: <20210712061034.217581019@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
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
index cc206bfa09c7..d854b8d5fbba 100644
--- a/drivers/iio/proximity/pulsedlight-lidar-lite-v2.c
+++ b/drivers/iio/proximity/pulsedlight-lidar-lite-v2.c
@@ -44,7 +44,11 @@ struct lidar_data {
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
@@ -230,9 +234,9 @@ static irqreturn_t lidar_trigger_handler(int irq, void *private)
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



