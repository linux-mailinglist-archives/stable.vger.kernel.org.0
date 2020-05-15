Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B00411D4FFB
	for <lists+stable@lfdr.de>; Fri, 15 May 2020 16:06:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726144AbgEOOGW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 May 2020 10:06:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:57342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726197AbgEOOGW (ORCPT <rfc822;Stable@vger.kernel.org>);
        Fri, 15 May 2020 10:06:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0CBD820671;
        Fri, 15 May 2020 14:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589551581;
        bh=auGVcXQICarqIKcUNPRVWNTAkCFSj9iYu2VGqN3dWMU=;
        h=Subject:To:From:Date:From;
        b=b2O1F4mMJ+8WdA9qZiS+cgl8N8bp1RtSsaTdlEZt0szOqCnYXybF7NpUaUd6t4ZSL
         qs2iM+S+dIP/tLqYLHnkXO9xVRTtDWyf4ysz+hhtP6Fqk0E+1CQc/WRiZ7BwLJS246
         MzIWDB/FS9otTAssbg/+F0fVMqmC5BBSikdieHZ8=
Subject: patch "iio: adc: ti-ads8344: Fix channel selection" added to staging-linus
To:     gregory.clement@bootlin.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 15 May 2020 16:06:08 +0200
Message-ID: <158955156824921@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: adc: ti-ads8344: Fix channel selection

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From bcfa1e253d2e329e1ebab5c89f3c73f6dd17606c Mon Sep 17 00:00:00 2001
From: Gregory CLEMENT <gregory.clement@bootlin.com>
Date: Thu, 30 Apr 2020 15:05:47 +0200
Subject: iio: adc: ti-ads8344: Fix channel selection

During initial submission the selection of the channel was done using
the scan_index member of the iio_chan_spec structure. It was an abuse
because this member is supposed to be used with a buffer so it was
removed.

However there was still the need to be able to known how to select a
channel, the correct member to store this information is address.

Thanks to this it is possible to select any other channel than the
channel 0.

Fixes: 8dd2d7c0fed7 ("iio: adc: Add driver for the TI ADS8344 A/DC chips")
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/adc/ti-ads8344.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/iio/adc/ti-ads8344.c b/drivers/iio/adc/ti-ads8344.c
index abe4b56c847c..8a8792010c20 100644
--- a/drivers/iio/adc/ti-ads8344.c
+++ b/drivers/iio/adc/ti-ads8344.c
@@ -32,16 +32,17 @@ struct ads8344 {
 	u8 rx_buf[3];
 };
 
-#define ADS8344_VOLTAGE_CHANNEL(chan, si)				\
+#define ADS8344_VOLTAGE_CHANNEL(chan, addr)				\
 	{								\
 		.type = IIO_VOLTAGE,					\
 		.indexed = 1,						\
 		.channel = chan,					\
 		.info_mask_separate = BIT(IIO_CHAN_INFO_RAW),		\
 		.info_mask_shared_by_type = BIT(IIO_CHAN_INFO_SCALE),	\
+		.address = addr,					\
 	}
 
-#define ADS8344_VOLTAGE_CHANNEL_DIFF(chan1, chan2, si)			\
+#define ADS8344_VOLTAGE_CHANNEL_DIFF(chan1, chan2, addr)		\
 	{								\
 		.type = IIO_VOLTAGE,					\
 		.indexed = 1,						\
@@ -50,6 +51,7 @@ struct ads8344 {
 		.differential = 1,					\
 		.info_mask_separate = BIT(IIO_CHAN_INFO_RAW),		\
 		.info_mask_shared_by_type = BIT(IIO_CHAN_INFO_SCALE),	\
+		.address = addr,					\
 	}
 
 static const struct iio_chan_spec ads8344_channels[] = {
@@ -105,7 +107,7 @@ static int ads8344_read_raw(struct iio_dev *iio,
 	switch (mask) {
 	case IIO_CHAN_INFO_RAW:
 		mutex_lock(&adc->lock);
-		*value = ads8344_adc_conversion(adc, channel->scan_index,
+		*value = ads8344_adc_conversion(adc, channel->address,
 						channel->differential);
 		mutex_unlock(&adc->lock);
 		if (*value < 0)
-- 
2.26.2


