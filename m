Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA1E33C477A
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:27:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235891AbhGLGc4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:32:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:47906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235885AbhGLG3h (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:29:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6539B61208;
        Mon, 12 Jul 2021 06:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071167;
        bh=uQxXNe8zyfpCo3M8r3W8p9L9exvdzsf2qfp6+bd/E8U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mdhiKI5t0KI3NcjCtTfuLoAIZgZu1mz2QCzDfLfvPkb9COOreW88sK9GS4pHYJwbg
         rFI/9SHaaOGo+CMazcYlqsaB59XQGa9psXHev5f/9oxHY5BmgBQx2/HiaCpDjudIbW
         2aV7LIdjcQcqfmqyXuy4uQJE/HHXJ+SDXQwODZjU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 261/348] iio: accel: bma220: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
Date:   Mon, 12 Jul 2021 08:10:45 +0200
Message-Id: <20210712060737.765341167@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
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
index cae905039cb6..71ee42b0266d 100644
--- a/drivers/iio/accel/bma220_spi.c
+++ b/drivers/iio/accel/bma220_spi.c
@@ -73,7 +73,11 @@ static const int bma220_scale_table[][4] = {
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
 
@@ -104,12 +108,12 @@ static irqreturn_t bma220_trigger_handler(int irq, void *p)
 
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



