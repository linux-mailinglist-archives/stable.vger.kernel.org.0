Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 393DB3CDD74
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244551AbhGSO6B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:58:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:53370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238175AbhGSO5O (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:57:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9FBB161222;
        Mon, 19 Jul 2021 15:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626708886;
        bh=L/eOLx1f0cvUOU3lPbj6WptKC8wBqBsSkGM+LzvpIvc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dZPtdC4k685d/IZzSca2Ko2WMTtn1H8np94FGyeAd/2TX3CVPwXj+TR4y7BR703Oo
         15Y3HfFZK30PebDJx8FYJfGWoywsPcYZGR7V3lrLb6KkkEJFKv41cLRR+RU2NhbYxl
         3z/VuTDvjNd7sn3rulKHmwLOTGn4XA4y+P4rOUFQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 169/421] iio: accel: bma220: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
Date:   Mon, 19 Jul 2021 16:49:40 +0200
Message-Id: <20210719144952.287361298@linuxfoundation.org>
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

[ Upstream commit 151dbf0078da98206817ee0b87d499035479ef11 ]

To make code more readable, use a structure to express the channel
layout and ensure the timestamp is 8 byte aligned.

Found during an audit of all calls of this function.

Fixes: 194dc4c71413 ("iio: accel: Add triggered buffer support for BMA220")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20210501170121.512209-3-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/accel/bma220_spi.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/iio/accel/bma220_spi.c b/drivers/iio/accel/bma220_spi.c
index e25d91c017ed..a548dc11e7c7 100644
--- a/drivers/iio/accel/bma220_spi.c
+++ b/drivers/iio/accel/bma220_spi.c
@@ -76,7 +76,11 @@ static const int bma220_scale_table[][4] = {
 struct bma220_data {
 	struct spi_device *spi_device;
 	struct mutex lock;
-	s8 buffer[16]; /* 3x8-bit channels + 5x8 padding + 8x8 timestamp */
+	struct {
+		s8 chans[3];
+		/* Ensure timestamp is naturally aligned. */
+		s64 timestamp __aligned(8);
+	} scan;
 	u8 tx_buf[2] ____cacheline_aligned;
 };
 
@@ -107,12 +111,12 @@ static irqreturn_t bma220_trigger_handler(int irq, void *p)
 
 	mutex_lock(&data->lock);
 	data->tx_buf[0] = BMA220_REG_ACCEL_X | BMA220_READ_MASK;
-	ret = spi_write_then_read(spi, data->tx_buf, 1, data->buffer,
+	ret = spi_write_then_read(spi, data->tx_buf, 1, &data->scan.chans,
 				  ARRAY_SIZE(bma220_channels) - 1);
 	if (ret < 0)
 		goto err;
 
-	iio_push_to_buffers_with_timestamp(indio_dev, data->buffer,
+	iio_push_to_buffers_with_timestamp(indio_dev, &data->scan,
 					   pf->timestamp);
 err:
 	mutex_unlock(&data->lock);
-- 
2.30.2



