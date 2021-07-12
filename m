Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F9EC3C4F31
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:43:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243081AbhGLHXc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:23:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:60258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240794AbhGLHV6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:21:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5AB1B6147E;
        Mon, 12 Jul 2021 07:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074349;
        bh=+lfO5Mra7CXAT9kFyiufjx760HDX/3j3Uo37TVVnrak=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D/eVjM9niAJRWbJxVLUxRotmxW+66ujLE7oBrcvadTXKtff5t/jfh3nJ50GhxqlQT
         ndCDR9ppMxlOWr8NEZidbftPiMp7BWK/9hLwTwzkH5Z/kDxQ3xdAVDoj8bnAWAtL4C
         /4awANomvaEpDOywruqRC7av5LQHvLjIoSxc/M4g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 533/700] iio: accel: bma220: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
Date:   Mon, 12 Jul 2021 08:10:16 +0200
Message-Id: <20210712061033.164608831@linuxfoundation.org>
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
index 3c9b0c6954e6..e8a9db1a82ad 100644
--- a/drivers/iio/accel/bma220_spi.c
+++ b/drivers/iio/accel/bma220_spi.c
@@ -63,7 +63,11 @@ static const int bma220_scale_table[][2] = {
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
 
@@ -94,12 +98,12 @@ static irqreturn_t bma220_trigger_handler(int irq, void *p)
 
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



