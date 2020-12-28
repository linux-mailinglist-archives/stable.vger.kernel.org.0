Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68D052E3F6A
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:40:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505759AbgL1Ojw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:39:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:36226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2503587AbgL1O3Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:29:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3E9AB206D4;
        Mon, 28 Dec 2020 14:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165749;
        bh=Pm31Go5VQ99lxSIseW0XmyID5TuYxNjyEIb1Y1j1Bbc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EeOubMit7U4QMTPBRhTavGFS1XzatHjY6HWiGv8AXvoR3sw2oR8gSeF9ZpiswnwZs
         bCv8+XYhqQBvd27ID6ZpU1MYeQ9hhw5/DEiRoZheddbWwQwNj8KC2diwcBIo1BPynM
         5itK5M53sH9wkMYp5iM94ZnOvvO6tw3WFQO/sccQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.10 640/717] iio: ad_sigma_delta: Dont put SPI transfer buffer on the stack
Date:   Mon, 28 Dec 2020 13:50:38 +0100
Message-Id: <20201228125051.594041708@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lars-Peter Clausen <lars@metafoo.de>

commit 0fb6ee8d0b5e90b72f870f76debc8bd31a742014 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/adc/ad_sigma_delta.c       |   18 ++++++++----------
 include/linux/iio/adc/ad_sigma_delta.h |    6 +++++-
 2 files changed, 13 insertions(+), 11 deletions(-)

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
@@ -146,22 +146,22 @@ int ad_sd_read_reg(struct ad_sigma_delta
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
@@ -395,11 +395,9 @@ static irqreturn_t ad_sd_trigger_handler
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


