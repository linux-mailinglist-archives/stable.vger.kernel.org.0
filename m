Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EF0D189938
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 11:24:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726733AbgCRKYY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Mar 2020 06:24:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:58784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726310AbgCRKYY (ORCPT <rfc822;Stable@vger.kernel.org>);
        Wed, 18 Mar 2020 06:24:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 32FA820776;
        Wed, 18 Mar 2020 10:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584527063;
        bh=pseIxGQusjMOmBa201uDge8xpcwujCsuMrAWPqJYEbI=;
        h=Subject:To:From:Date:From;
        b=xUXEqomRz0TEvXkHuR+brXpcCbCikAi+dSIIwxf7TxIFAzEBKLAil5Umi9Zx6tQW6
         dpQhCHUzZ4uTNnPutPsK+3VIhWeluotf5BbcpXyOqv49yDAIzmdWcV9iLPo6IJOJrZ
         UvdOwqO4qLzhHi+DtlN62g5rq7tmLDKu+CS0CI+8=
Subject: patch "iio: adc: stm32-dfsdm: fix sleep in atomic context" added to staging-linus
To:     olivier.moysan@st.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 18 Mar 2020 11:24:18 +0100
Message-ID: <158452705832135@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: adc: stm32-dfsdm: fix sleep in atomic context

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From e19ac9d9a978f8238a85a28ed624094a497d5ae6 Mon Sep 17 00:00:00 2001
From: Olivier Moysan <olivier.moysan@st.com>
Date: Tue, 21 Jan 2020 12:02:56 +0100
Subject: iio: adc: stm32-dfsdm: fix sleep in atomic context

This commit fixes the error message:
"BUG: sleeping function called from invalid context at kernel/irq/chip.c"
Suppress the trigger irq handler. Make the buffer transfers directly
in DMA callback, instead.
Push buffers without timestamps, as timestamps are not supported
in DFSDM driver.

Fixes: 11646e81d775 ("iio: adc: stm32-dfsdm: add support for buffer modes")

Signed-off-by: Olivier Moysan <olivier.moysan@st.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/adc/stm32-dfsdm-adc.c | 43 +++++++------------------------
 1 file changed, 10 insertions(+), 33 deletions(-)

diff --git a/drivers/iio/adc/stm32-dfsdm-adc.c b/drivers/iio/adc/stm32-dfsdm-adc.c
index 2aad2cda6943..76a60d93fe23 100644
--- a/drivers/iio/adc/stm32-dfsdm-adc.c
+++ b/drivers/iio/adc/stm32-dfsdm-adc.c
@@ -842,31 +842,6 @@ static inline void stm32_dfsdm_process_data(struct stm32_dfsdm_adc *adc,
 	}
 }
 
-static irqreturn_t stm32_dfsdm_adc_trigger_handler(int irq, void *p)
-{
-	struct iio_poll_func *pf = p;
-	struct iio_dev *indio_dev = pf->indio_dev;
-	struct stm32_dfsdm_adc *adc = iio_priv(indio_dev);
-	int available = stm32_dfsdm_adc_dma_residue(adc);
-
-	while (available >= indio_dev->scan_bytes) {
-		s32 *buffer = (s32 *)&adc->rx_buf[adc->bufi];
-
-		stm32_dfsdm_process_data(adc, buffer);
-
-		iio_push_to_buffers_with_timestamp(indio_dev, buffer,
-						   pf->timestamp);
-		available -= indio_dev->scan_bytes;
-		adc->bufi += indio_dev->scan_bytes;
-		if (adc->bufi >= adc->buf_sz)
-			adc->bufi = 0;
-	}
-
-	iio_trigger_notify_done(indio_dev->trig);
-
-	return IRQ_HANDLED;
-}
-
 static void stm32_dfsdm_dma_buffer_done(void *data)
 {
 	struct iio_dev *indio_dev = data;
@@ -874,11 +849,6 @@ static void stm32_dfsdm_dma_buffer_done(void *data)
 	int available = stm32_dfsdm_adc_dma_residue(adc);
 	size_t old_pos;
 
-	if (indio_dev->currentmode & INDIO_BUFFER_TRIGGERED) {
-		iio_trigger_poll_chained(indio_dev->trig);
-		return;
-	}
-
 	/*
 	 * FIXME: In Kernel interface does not support cyclic DMA buffer,and
 	 * offers only an interface to push data samples per samples.
@@ -906,7 +876,15 @@ static void stm32_dfsdm_dma_buffer_done(void *data)
 			adc->bufi = 0;
 			old_pos = 0;
 		}
-		/* regular iio buffer without trigger */
+		/*
+		 * In DMA mode the trigger services of IIO are not used
+		 * (e.g. no call to iio_trigger_poll).
+		 * Calling irq handler associated to the hardware trigger is not
+		 * relevant as the conversions have already been done. Data
+		 * transfers are performed directly in DMA callback instead.
+		 * This implementation avoids to call trigger irq handler that
+		 * may sleep, in an atomic context (DMA irq handler context).
+		 */
 		if (adc->dev_data->type == DFSDM_IIO)
 			iio_push_to_buffers(indio_dev, buffer);
 	}
@@ -1536,8 +1514,7 @@ static int stm32_dfsdm_adc_init(struct iio_dev *indio_dev)
 	}
 
 	ret = iio_triggered_buffer_setup(indio_dev,
-					 &iio_pollfunc_store_time,
-					 &stm32_dfsdm_adc_trigger_handler,
+					 &iio_pollfunc_store_time, NULL,
 					 &stm32_dfsdm_buffer_setup_ops);
 	if (ret) {
 		stm32_dfsdm_dma_release(indio_dev);
-- 
2.25.1


