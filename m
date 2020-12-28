Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C93972E42A7
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:27:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405352AbgL1N56 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:57:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:59100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405112AbgL1N55 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:57:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A960722B49;
        Mon, 28 Dec 2020 13:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163862;
        bh=98X/jcCRH0yQuqv6py0Piexc/IZcMKBVJxzrDjazN7E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mQUMSdnh10fcSFmdXvW5NF1hX/fNGW1g5hvd9G0GuXzf6Kfa7UMVS6xR7DIUjF9rt
         0acQh6yMGTOnLdjY6wOrXEjzn3vIoMztvGogIpGiGzwdvT53isMe5vBWCj/PhKZnwe
         cvS6UnBtViD/eKO8EI+LQBywHjyQ6NN5tlTdwWK4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Dan Murphy <dmurphy@ti.com>, Stable@vger.kernel.org
Subject: [PATCH 5.4 433/453] iio:adc:ti-ads124s08: Fix alignment and data leak issues.
Date:   Mon, 28 Dec 2020 13:51:09 +0100
Message-Id: <20201228124958.063703304@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

commit 1e405bc2512f80a903ddd6ba8740cee885238d7f upstream.

One of a class of bugs pointed out by Lars in a recent review.
iio_push_to_buffers_with_timestamp() assumes the buffer used is aligned
to the size of the timestamp (8 bytes).  This is not guaranteed in
this driver which uses an array of smaller elements on the stack.
As Lars also noted this anti pattern can involve a leak of data to
userspace and that indeed can happen here.  We close both issues by
moving to a suitable structure in the iio_priv() data with alignment
explicitly requested.  This data is allocated with kzalloc() so no
data can leak apart from previous readings.

In this driver the timestamp can end up in various different locations
depending on what other channels are enabled.  As a result, we don't
use a structure to specify it's position as that would be misleading.

Fixes: e717f8c6dfec ("iio: adc: Add the TI ads124s08 ADC code")
Reported-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
Cc: Dan Murphy <dmurphy@ti.com>
Cc: <Stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200920112742.170751-9-jic23@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/adc/ti-ads124s08.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/drivers/iio/adc/ti-ads124s08.c
+++ b/drivers/iio/adc/ti-ads124s08.c
@@ -97,6 +97,14 @@ struct ads124s_private {
 	struct gpio_desc *reset_gpio;
 	struct spi_device *spi;
 	struct mutex lock;
+	/*
+	 * Used to correctly align data.
+	 * Ensure timestamp is naturally aligned.
+	 * Note that the full buffer length may not be needed if not
+	 * all channels are enabled, as long as the alignment of the
+	 * timestamp is maintained.
+	 */
+	u32 buffer[ADS124S08_MAX_CHANNELS + sizeof(s64)/sizeof(u32)] __aligned(8);
 	u8 data[5] ____cacheline_aligned;
 };
 
@@ -270,7 +278,6 @@ static irqreturn_t ads124s_trigger_handl
 	struct iio_poll_func *pf = p;
 	struct iio_dev *indio_dev = pf->indio_dev;
 	struct ads124s_private *priv = iio_priv(indio_dev);
-	u32 buffer[ADS124S08_MAX_CHANNELS + sizeof(s64)/sizeof(u32)];
 	int scan_index, j = 0;
 	int ret;
 
@@ -285,7 +292,7 @@ static irqreturn_t ads124s_trigger_handl
 		if (ret)
 			dev_err(&priv->spi->dev, "Start ADC conversions failed\n");
 
-		buffer[j] = ads124s_read(indio_dev, scan_index);
+		priv->buffer[j] = ads124s_read(indio_dev, scan_index);
 		ret = ads124s_write_cmd(indio_dev, ADS124S08_STOP_CONV);
 		if (ret)
 			dev_err(&priv->spi->dev, "Stop ADC conversions failed\n");
@@ -293,7 +300,7 @@ static irqreturn_t ads124s_trigger_handl
 		j++;
 	}
 
-	iio_push_to_buffers_with_timestamp(indio_dev, buffer,
+	iio_push_to_buffers_with_timestamp(indio_dev, priv->buffer,
 			pf->timestamp);
 
 	iio_trigger_notify_done(indio_dev->trig);


