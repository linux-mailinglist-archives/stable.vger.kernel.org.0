Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99AFB119D5B
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 23:37:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730024AbfLJWdw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 17:33:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:54890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730012AbfLJWdv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 17:33:51 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB551207FF;
        Tue, 10 Dec 2019 22:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576017230;
        bh=26sIAPxWOxDTt0sfmsLSrbEC8BEZn+0RTlIRcTTz9hw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XKQ5NrOQ2IqRObfdRSLkGttOt0WWeXhqhwkw80MN+cmrxriq/OUFM3zQdj+Lu8oek
         q6vbLIYu9cFY5+ezfAwL6AUDVMOvjEwL7pElu20KrRmXHrX8jCgUlXNZUU2H4FvA45
         1Wu+Aykl0LT6lE3v3y29zB6js6n033VkBh4wun3M=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>, linux-iio@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 28/71] iio: dac: ad7303: replace mlock with own lock
Date:   Tue, 10 Dec 2019 17:32:33 -0500
Message-Id: <20191210223316.14988-28-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210223316.14988-1-sashal@kernel.org>
References: <20191210223316.14988-1-sashal@kernel.org>
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
index 4b0f942b89145..2e5e753ab7066 100644
--- a/drivers/iio/dac/ad7303.c
+++ b/drivers/iio/dac/ad7303.c
@@ -42,6 +42,7 @@ struct ad7303_state {
 	struct regulator *vdd_reg;
 	struct regulator *vref_reg;
 
+	struct mutex lock;
 	/*
 	 * DMA (thus cache coherency maintenance) requires the
 	 * transfer buffers to live in their own cache lines.
@@ -80,7 +81,7 @@ static ssize_t ad7303_write_dac_powerdown(struct iio_dev *indio_dev,
 	if (ret)
 		return ret;
 
-	mutex_lock(&indio_dev->mlock);
+	mutex_lock(&st->lock);
 
 	if (pwr_down)
 		st->config |= AD7303_CFG_POWER_DOWN(chan->channel);
@@ -91,7 +92,7 @@ static ssize_t ad7303_write_dac_powerdown(struct iio_dev *indio_dev,
 	 * mode, so just write one of the DAC channels again */
 	ad7303_write(st, chan->channel, st->dac_cache[chan->channel]);
 
-	mutex_unlock(&indio_dev->mlock);
+	mutex_unlock(&st->lock);
 	return len;
 }
 
@@ -117,7 +118,9 @@ static int ad7303_read_raw(struct iio_dev *indio_dev,
 
 	switch (info) {
 	case IIO_CHAN_INFO_RAW:
+		mutex_lock(&st->lock);
 		*val = st->dac_cache[chan->channel];
+		mutex_unlock(&st->lock);
 		return IIO_VAL_INT;
 	case IIO_CHAN_INFO_SCALE:
 		vref_uv = ad7303_get_vref(st, chan);
@@ -145,11 +148,11 @@ static int ad7303_write_raw(struct iio_dev *indio_dev,
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
@@ -213,6 +216,8 @@ static int ad7303_probe(struct spi_device *spi)
 
 	st->spi = spi;
 
+	mutex_init(&st->lock);
+
 	st->vdd_reg = devm_regulator_get(&spi->dev, "Vdd");
 	if (IS_ERR(st->vdd_reg))
 		return PTR_ERR(st->vdd_reg);
-- 
2.20.1

