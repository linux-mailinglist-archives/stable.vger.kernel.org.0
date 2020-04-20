Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B14C31B08D8
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 14:08:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726470AbgDTMIu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 08:08:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:47240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726380AbgDTMIu (ORCPT <rfc822;Stable@vger.kernel.org>);
        Mon, 20 Apr 2020 08:08:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE6C5206B9;
        Mon, 20 Apr 2020 12:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587384529;
        bh=dzdJnTgqh7oJ3dtwi7/GMQM7mnYrX09aCBt0SvsniJM=;
        h=Subject:To:From:Date:From;
        b=rh5EdrsL9G5SfGrRLu7Y1laAATNKa0yVdczj/xPlSyVADExNn23Ihm04wWFC0yBDZ
         nshzKl2ZoplmGQy0UfG5C8R71EIXiP+POFovVd7BkkzSixjMaq7yvWOvOfAhu73kLz
         1XD8nP4ZMajV3JwuLIQMBa3MEWbG77hgUZn9WWUQ=
Subject: patch "iio: adc: stm32-adc: fix sleep in atomic context" added to staging-linus
To:     olivier.moysan@st.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, fabrice.gasnier@st.com
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Apr 2020 14:08:44 +0200
Message-ID: <158738452424172@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: adc: stm32-adc: fix sleep in atomic context

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From e2042d2936dfc84e9c600fe9b9d0039ca0e54b7d Mon Sep 17 00:00:00 2001
From: Olivier Moysan <olivier.moysan@st.com>
Date: Mon, 9 Mar 2020 11:02:12 +0100
Subject: iio: adc: stm32-adc: fix sleep in atomic context

This commit fixes the following error:
"BUG: sleeping function called from invalid context at kernel/irq/chip.c"

In DMA mode suppress the trigger irq handler, and make the buffer
transfers directly in DMA callback, instead.

Fixes: 2763ea0585c9 ("iio: adc: stm32: add optional dma support")
Signed-off-by: Olivier Moysan <olivier.moysan@st.com>
Acked-by: Fabrice Gasnier <fabrice.gasnier@st.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/adc/stm32-adc.c | 31 ++++++++++++++++++++++++++++---
 1 file changed, 28 insertions(+), 3 deletions(-)

diff --git a/drivers/iio/adc/stm32-adc.c b/drivers/iio/adc/stm32-adc.c
index 80c3f963527b..ae622ee6d08c 100644
--- a/drivers/iio/adc/stm32-adc.c
+++ b/drivers/iio/adc/stm32-adc.c
@@ -1418,8 +1418,30 @@ static unsigned int stm32_adc_dma_residue(struct stm32_adc *adc)
 static void stm32_adc_dma_buffer_done(void *data)
 {
 	struct iio_dev *indio_dev = data;
+	struct stm32_adc *adc = iio_priv(indio_dev);
+	int residue = stm32_adc_dma_residue(adc);
+
+	/*
+	 * In DMA mode the trigger services of IIO are not used
+	 * (e.g. no call to iio_trigger_poll).
+	 * Calling irq handler associated to the hardware trigger is not
+	 * relevant as the conversions have already been done. Data
+	 * transfers are performed directly in DMA callback instead.
+	 * This implementation avoids to call trigger irq handler that
+	 * may sleep, in an atomic context (DMA irq handler context).
+	 */
+	dev_dbg(&indio_dev->dev, "%s bufi=%d\n", __func__, adc->bufi);
 
-	iio_trigger_poll_chained(indio_dev->trig);
+	while (residue >= indio_dev->scan_bytes) {
+		u16 *buffer = (u16 *)&adc->rx_buf[adc->bufi];
+
+		iio_push_to_buffers(indio_dev, buffer);
+
+		residue -= indio_dev->scan_bytes;
+		adc->bufi += indio_dev->scan_bytes;
+		if (adc->bufi >= adc->rx_buf_sz)
+			adc->bufi = 0;
+	}
 }
 
 static int stm32_adc_dma_start(struct iio_dev *indio_dev)
@@ -1845,6 +1867,7 @@ static int stm32_adc_probe(struct platform_device *pdev)
 {
 	struct iio_dev *indio_dev;
 	struct device *dev = &pdev->dev;
+	irqreturn_t (*handler)(int irq, void *p) = NULL;
 	struct stm32_adc *adc;
 	int ret;
 
@@ -1911,9 +1934,11 @@ static int stm32_adc_probe(struct platform_device *pdev)
 	if (ret < 0)
 		return ret;
 
+	if (!adc->dma_chan)
+		handler = &stm32_adc_trigger_handler;
+
 	ret = iio_triggered_buffer_setup(indio_dev,
-					 &iio_pollfunc_store_time,
-					 &stm32_adc_trigger_handler,
+					 &iio_pollfunc_store_time, handler,
 					 &stm32_adc_buffer_setup_ops);
 	if (ret) {
 		dev_err(&pdev->dev, "buffer setup failed\n");
-- 
2.26.1


