Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 355083CD9B1
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:13:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243024AbhGSObQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:31:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:40420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243028AbhGSO2A (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:28:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 108456008E;
        Mon, 19 Jul 2021 15:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626707278;
        bh=wv0LDD+qxEZBezU6yT5sICcU8IDI9B89j4+nuL1tHMw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0BiJ1WLEFpeqAku0tg8FI/nB8dZMTqPNZ1+aHZO/5POjtuiFhvnvddTRXsK+bwPlB
         jXRFFPTZSuCjAio37Xn5t6C8noULR0D69ABXOXcGQeuQvCmRCyHzQs8IwzlI2hjEJc
         0SP3k/lqgJH/KJNWoUbOxSDsDzSVO6RjEGJil8Bc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 095/245] iio: accel: bma220: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
Date:   Mon, 19 Jul 2021 16:50:37 +0200
Message-Id: <20210719144943.482414851@linuxfoundation.org>
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
index 5099f295dd37..a96f2d530ae3 100644
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



