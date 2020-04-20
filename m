Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEDD91B08E0
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 14:09:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726815AbgDTMJV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 08:09:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:47706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726813AbgDTMJV (ORCPT <rfc822;Stable@vger.kernel.org>);
        Mon, 20 Apr 2020 08:09:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 68F7720679;
        Mon, 20 Apr 2020 12:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587384560;
        bh=6naM11teqj/HrsZLodNzZ/0yqgGDb6OCLJ0H0KdWACU=;
        h=Subject:To:From:Date:From;
        b=VH6HpzA4jm2D5SSIrw84OzPiTa6DZYCwVtxFy+4ljgApunWSVXomeq6VIQQywUwNd
         U+FILVHGxJLoAj+nWiytuJoepH4yJkiY6JxGYWhN+h7XpUjK8DihHYlSc8vS2oY40B
         BtT6+GzPqtmcoosCtXaFZZWWOJ2X9V4F6d1ylBls=
Subject: patch "iio: adc: ti-ads8344: properly byte swap value" added to staging-linus
To:     alexandre.belloni@bootlin.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Apr 2020 14:08:50 +0200
Message-ID: <1587384530156159@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: adc: ti-ads8344: properly byte swap value

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From dd7de4c0023e7564cabe39d64b2822a522890792 Mon Sep 17 00:00:00 2001
From: Alexandre Belloni <alexandre.belloni@bootlin.com>
Date: Thu, 16 Apr 2020 22:54:27 +0200
Subject: iio: adc: ti-ads8344: properly byte swap value

The first received byte is the MSB, followed by the LSB so the value needs
to be byte swapped.

Also, the ADC actually has a delay of one clock on the SPI bus. Read three
bytes to get the last bit.

Fixes: 8dd2d7c0fed7 ("iio: adc: Add driver for the TI ADS8344 A/DC chips")
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/adc/ti-ads8344.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/iio/adc/ti-ads8344.c b/drivers/iio/adc/ti-ads8344.c
index 9a460807d46d..abe4b56c847c 100644
--- a/drivers/iio/adc/ti-ads8344.c
+++ b/drivers/iio/adc/ti-ads8344.c
@@ -29,7 +29,7 @@ struct ads8344 {
 	struct mutex lock;
 
 	u8 tx_buf ____cacheline_aligned;
-	u16 rx_buf;
+	u8 rx_buf[3];
 };
 
 #define ADS8344_VOLTAGE_CHANNEL(chan, si)				\
@@ -89,11 +89,11 @@ static int ads8344_adc_conversion(struct ads8344 *adc, int channel,
 
 	udelay(9);
 
-	ret = spi_read(spi, &adc->rx_buf, 2);
+	ret = spi_read(spi, adc->rx_buf, sizeof(adc->rx_buf));
 	if (ret)
 		return ret;
 
-	return adc->rx_buf;
+	return adc->rx_buf[0] << 9 | adc->rx_buf[1] << 1 | adc->rx_buf[2] >> 7;
 }
 
 static int ads8344_read_raw(struct iio_dev *iio,
-- 
2.26.1


