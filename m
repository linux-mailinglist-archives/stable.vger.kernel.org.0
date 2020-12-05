Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2C912CFC28
	for <lists+stable@lfdr.de>; Sat,  5 Dec 2020 17:50:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbgLEQsb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Dec 2020 11:48:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:48360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726038AbgLEQoo (ORCPT <rfc822;Stable@vger.kernel.org>);
        Sat, 5 Dec 2020 11:44:44 -0500
Subject: patch "iio: ad_sigma_delta: Don't put SPI transfer buffer on the stack" added to staging-next
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607183131;
        bh=ZRhr7ebmY4BhKkoVY0mf/+ZpiHMAjSdnGxwUSpLZ8gQ=;
        h=To:From:Date:From;
        b=Eh7d9v3GaOTp6JoOo8hwkWMuOKkbn/nBD3/02OrF60ugsQTbM8puguOtWOGwq2ryO
         DxeuwTzaGfva8QZsAF4nI7NC70w2KFlWNt/A5JvjAH7uHe+8Fs6Tgz9Wyp6t3p0lt1
         f0kFKFB1oA2lhBCffmgT1syOIizhT7kC6c87dDt8=
To:     lars@metafoo.de, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, alexandru.ardelean@analog.com
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 05 Dec 2020 16:45:36 +0100
Message-ID: <160718313616053@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: ad_sigma_delta: Don't put SPI transfer buffer on the stack

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 0fb6ee8d0b5e90b72f870f76debc8bd31a742014 Mon Sep 17 00:00:00 2001
From: Lars-Peter Clausen <lars@metafoo.de>
Date: Tue, 24 Nov 2020 14:38:07 +0200
Subject: iio: ad_sigma_delta: Don't put SPI transfer buffer on the stack

Use a heap allocated memory for the SPI transfer buffer. Using stack memory
can corrupt stack memory when using DMA on some systems.

This change moves the buffer from the stack of the trigger handler call to
the heap of the buffer of the state struct. The size increases takes into
account the alignment for the timestamp, which is 8 bytes.

The 'data' buffer is split into 'tx_buf' and 'rx_buf', to make a clearer
separation of which part of the buffer should be used for TX & RX.

Fixes: af3008485ea03 ("iio:adc: Add common code for ADI Sigma Delta devices")
Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
Link: https://lore.kernel.org/r/20201124123807.19717-1-alexandru.ardelean@analog.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/adc/ad_sigma_delta.c       | 18 ++++++++----------
 include/linux/iio/adc/ad_sigma_delta.h |  6 +++++-
 2 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/iio/adc/ad_sigma_delta.c b/drivers/iio/adc/ad_sigma_delta.c
index 86039e9ecaca..3a6f239d4acc 100644
--- a/drivers/iio/adc/ad_sigma_delta.c
+++ b/drivers/iio/adc/ad_sigma_delta.c
@@ -57,7 +57,7 @@ EXPORT_SYMBOL_GPL(ad_sd_set_comm);
 int ad_sd_write_reg(struct ad_sigma_delta *sigma_delta, unsigned int reg,
 	unsigned int size, unsigned int val)
 {
-	uint8_t *data = sigma_delta->data;
+	uint8_t *data = sigma_delta->tx_buf;
 	struct spi_transfer t = {
 		.tx_buf		= data,
 		.len		= size + 1,
@@ -99,7 +99,7 @@ EXPORT_SYMBOL_GPL(ad_sd_write_reg);
 static int ad_sd_read_reg_raw(struct ad_sigma_delta *sigma_delta,
 	unsigned int reg, unsigned int size, uint8_t *val)
 {
-	uint8_t *data = sigma_delta->data;
+	uint8_t *data = sigma_delta->tx_buf;
 	int ret;
 	struct spi_transfer t[] = {
 		{
@@ -146,22 +146,22 @@ int ad_sd_read_reg(struct ad_sigma_delta *sigma_delta,
 {
 	int ret;
 
-	ret = ad_sd_read_reg_raw(sigma_delta, reg, size, sigma_delta->data);
+	ret = ad_sd_read_reg_raw(sigma_delta, reg, size, sigma_delta->rx_buf);
 	if (ret < 0)
 		goto out;
 
 	switch (size) {
 	case 4:
-		*val = get_unaligned_be32(sigma_delta->data);
+		*val = get_unaligned_be32(sigma_delta->rx_buf);
 		break;
 	case 3:
-		*val = get_unaligned_be24(&sigma_delta->data[0]);
+		*val = get_unaligned_be24(sigma_delta->rx_buf);
 		break;
 	case 2:
-		*val = get_unaligned_be16(sigma_delta->data);
+		*val = get_unaligned_be16(sigma_delta->rx_buf);
 		break;
 	case 1:
-		*val = sigma_delta->data[0];
+		*val = sigma_delta->rx_buf[0];
 		break;
 	default:
 		ret = -EINVAL;
@@ -395,11 +395,9 @@ static irqreturn_t ad_sd_trigger_handler(int irq, void *p)
 	struct iio_poll_func *pf = p;
 	struct iio_dev *indio_dev = pf->indio_dev;
 	struct ad_sigma_delta *sigma_delta = iio_device_get_drvdata(indio_dev);
+	uint8_t *data = sigma_delta->rx_buf;
 	unsigned int reg_size;
 	unsigned int data_reg;
-	uint8_t data[16];
-
-	memset(data, 0x00, 16);
 
 	reg_size = indio_dev->channels[0].scan_type.realbits +
 			indio_dev->channels[0].scan_type.shift;
diff --git a/include/linux/iio/adc/ad_sigma_delta.h b/include/linux/iio/adc/ad_sigma_delta.h
index a3a838dcf8e4..7199280d89ca 100644
--- a/include/linux/iio/adc/ad_sigma_delta.h
+++ b/include/linux/iio/adc/ad_sigma_delta.h
@@ -79,8 +79,12 @@ struct ad_sigma_delta {
 	/*
 	 * DMA (thus cache coherency maintenance) requires the
 	 * transfer buffers to live in their own cache lines.
+	 * 'tx_buf' is up to 32 bits.
+	 * 'rx_buf' is up to 32 bits per sample + 64 bit timestamp,
+	 * rounded to 16 bytes to take into account padding.
 	 */
-	uint8_t				data[4] ____cacheline_aligned;
+	uint8_t				tx_buf[4] ____cacheline_aligned;
+	uint8_t				rx_buf[16] __aligned(8);
 };
 
 static inline int ad_sigma_delta_set_channel(struct ad_sigma_delta *sd,
-- 
2.29.2


