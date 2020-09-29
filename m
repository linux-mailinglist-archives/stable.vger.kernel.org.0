Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A053927D433
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 19:13:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728140AbgI2RNA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 13:13:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:50730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725554AbgI2RNA (ORCPT <rfc822;Stable@vger.kernel.org>);
        Tue, 29 Sep 2020 13:13:00 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A0F0E20936;
        Tue, 29 Sep 2020 17:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601399579;
        bh=nJGETUizDb3YL4cOdeEY4BCcrR85Y48pB4UftZZklb4=;
        h=Subject:To:From:Date:From;
        b=ws5doyzJoC8sY4I7EuJ1Zz7w/ynrs3JJxXtCkMbelaaHza8vs+qBmltofaWNByoGV
         RkS3mErkx/2ghHFJgOxGDLlAn/RSPn+HJJ2APxiHQmYtARccjpF6PbhFkwZae4R9si
         RPEtO84zGR9iDbE72LBrNCvJpE2/Mg72GR3ln360=
Subject: patch "iio: adc: at91-sama5d2_adc: fix DMA conversion crash" added to staging-testing
To:     eugen.hristev@microchip.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 29 Sep 2020 19:12:10 +0200
Message-ID: <1601399530242120@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: adc: at91-sama5d2_adc: fix DMA conversion crash

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the staging-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 1a198794451449113fa86994ed491d6986802c23 Mon Sep 17 00:00:00 2001
From: Eugen Hristev <eugen.hristev@microchip.com>
Date: Wed, 23 Sep 2020 15:17:48 +0300
Subject: iio: adc: at91-sama5d2_adc: fix DMA conversion crash

After the move of the postenable code to preenable, the DMA start was
done before the DMA init, which is not correct.
The DMA is initialized in set_watermark. Because of this, we need to call
the DMA start functions in set_watermark, after the DMA init, instead of
preenable hook, when the DMA is not properly setup yet.

Fixes: f3c034f61775 ("iio: at91-sama5d2_adc: adjust iio_triggered_buffer_{predisable,postenable} positions")
Signed-off-by: Eugen Hristev <eugen.hristev@microchip.com>
Link: https://lore.kernel.org/r/20200923121748.49384-1-eugen.hristev@microchip.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/adc/at91-sama5d2_adc.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/iio/adc/at91-sama5d2_adc.c b/drivers/iio/adc/at91-sama5d2_adc.c
index ad7d9819f83c..b917a4714a9c 100644
--- a/drivers/iio/adc/at91-sama5d2_adc.c
+++ b/drivers/iio/adc/at91-sama5d2_adc.c
@@ -884,7 +884,7 @@ static bool at91_adc_current_chan_is_touch(struct iio_dev *indio_dev)
 			       AT91_SAMA5D2_MAX_CHAN_IDX + 1);
 }
 
-static int at91_adc_buffer_preenable(struct iio_dev *indio_dev)
+static int at91_adc_buffer_prepare(struct iio_dev *indio_dev)
 {
 	int ret;
 	u8 bit;
@@ -901,7 +901,7 @@ static int at91_adc_buffer_preenable(struct iio_dev *indio_dev)
 	/* we continue with the triggered buffer */
 	ret = at91_adc_dma_start(indio_dev);
 	if (ret) {
-		dev_err(&indio_dev->dev, "buffer postenable failed\n");
+		dev_err(&indio_dev->dev, "buffer prepare failed\n");
 		return ret;
 	}
 
@@ -989,7 +989,6 @@ static int at91_adc_buffer_postdisable(struct iio_dev *indio_dev)
 }
 
 static const struct iio_buffer_setup_ops at91_buffer_setup_ops = {
-	.preenable = &at91_adc_buffer_preenable,
 	.postdisable = &at91_adc_buffer_postdisable,
 };
 
@@ -1563,6 +1562,7 @@ static void at91_adc_dma_disable(struct platform_device *pdev)
 static int at91_adc_set_watermark(struct iio_dev *indio_dev, unsigned int val)
 {
 	struct at91_adc_state *st = iio_priv(indio_dev);
+	int ret;
 
 	if (val > AT91_HWFIFO_MAX_SIZE)
 		return -EINVAL;
@@ -1586,7 +1586,15 @@ static int at91_adc_set_watermark(struct iio_dev *indio_dev, unsigned int val)
 	else if (val > 1)
 		at91_adc_dma_init(to_platform_device(&indio_dev->dev));
 
-	return 0;
+	/*
+	 * We can start the DMA only after setting the watermark and
+	 * having the DMA initialization completed
+	 */
+	ret = at91_adc_buffer_prepare(indio_dev);
+	if (ret)
+		at91_adc_dma_disable(to_platform_device(&indio_dev->dev));
+
+	return ret;
 }
 
 static int at91_adc_update_scan_mode(struct iio_dev *indio_dev,
-- 
2.28.0


