Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8DAF1199A6
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:47:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727385AbfLJVcW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:32:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:57498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728087AbfLJVJP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:09:15 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2DDA224687;
        Tue, 10 Dec 2019 21:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012154;
        bh=pghwgZMd4SWZs3qtgTbo4IgWuTXCjN4jCn4pl/oZLUY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mijmnRVQfcWQ5wRhAg8l2lIhLGdDo1g6HBQNWPlNfEy+NqXOaE45n6rpYKGjVARR+
         IHNTJnrLEEMNOvwbAmT6Qx0VJ9OHb1xOedPEPxuHAbhAgQnQOsjbw4TZ6YxAScUbhf
         JPWYCQqV+16L/Rwxab3B8ffa8MEmg9YmZ5+F+OOw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>, linux-iio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 117/350] iio: dac: ad7303: replace mlock with own lock
Date:   Tue, 10 Dec 2019 16:03:42 -0500
Message-Id: <20191210210735.9077-78-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandru Ardelean <alexandru.ardelean@analog.com>

[ Upstream commit c991bf9b650f39481cf3c1137092d4754a2c75de ]

This change replaces indio_dev's mlock with the driver's own lock. The lock
is mostly needed to protect state when changing the `dac_cache` info.
The lock has been extended to `ad7303_read_raw()`, to make sure that the
cache is updated if an SPI-write is already in progress.

Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/dac/ad7303.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/iio/dac/ad7303.c b/drivers/iio/dac/ad7303.c
index 8de9f40226e62..14bbac6bee982 100644
--- a/drivers/iio/dac/ad7303.c
+++ b/drivers/iio/dac/ad7303.c
@@ -41,6 +41,7 @@ struct ad7303_state {
 	struct regulator *vdd_reg;
 	struct regulator *vref_reg;
 
+	struct mutex lock;
 	/*
 	 * DMA (thus cache coherency maintenance) requires the
 	 * transfer buffers to live in their own cache lines.
@@ -79,7 +80,7 @@ static ssize_t ad7303_write_dac_powerdown(struct iio_dev *indio_dev,
 	if (ret)
 		return ret;
 
-	mutex_lock(&indio_dev->mlock);
+	mutex_lock(&st->lock);
 
 	if (pwr_down)
 		st->config |= AD7303_CFG_POWER_DOWN(chan->channel);
@@ -90,7 +91,7 @@ static ssize_t ad7303_write_dac_powerdown(struct iio_dev *indio_dev,
 	 * mode, so just write one of the DAC channels again */
 	ad7303_write(st, chan->channel, st->dac_cache[chan->channel]);
 
-	mutex_unlock(&indio_dev->mlock);
+	mutex_unlock(&st->lock);
 	return len;
 }
 
@@ -116,7 +117,9 @@ static int ad7303_read_raw(struct iio_dev *indio_dev,
 
 	switch (info) {
 	case IIO_CHAN_INFO_RAW:
+		mutex_lock(&st->lock);
 		*val = st->dac_cache[chan->channel];
+		mutex_unlock(&st->lock);
 		return IIO_VAL_INT;
 	case IIO_CHAN_INFO_SCALE:
 		vref_uv = ad7303_get_vref(st, chan);
@@ -144,11 +147,11 @@ static int ad7303_write_raw(struct iio_dev *indio_dev,
 		if (val >= (1 << chan->scan_type.realbits) || val < 0)
 			return -EINVAL;
 
-		mutex_lock(&indio_dev->mlock);
+		mutex_lock(&st->lock);
 		ret = ad7303_write(st, chan->address, val);
 		if (ret == 0)
 			st->dac_cache[chan->channel] = val;
-		mutex_unlock(&indio_dev->mlock);
+		mutex_unlock(&st->lock);
 		break;
 	default:
 		ret = -EINVAL;
@@ -211,6 +214,8 @@ static int ad7303_probe(struct spi_device *spi)
 
 	st->spi = spi;
 
+	mutex_init(&st->lock);
+
 	st->vdd_reg = devm_regulator_get(&spi->dev, "Vdd");
 	if (IS_ERR(st->vdd_reg))
 		return PTR_ERR(st->vdd_reg);
-- 
2.20.1

