Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2FA11BC96F
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:44:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730385AbgD1Slf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:41:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:33120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731004AbgD1Sle (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:41:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D35782085B;
        Tue, 28 Apr 2020 18:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588099293;
        bh=hOYDr3W9wY/JWlZ8DY1wJ2I7TR7v+K/j8Rp2MUsSRnY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LZQSw8gj9IE0lwp1utX57GFS7KUCbPFi7dD4KYdDtPhGf++pyNEhtE+jpWCnenvrh
         ipqcnsR/LTwftHAgPrIRIQCZrB52O892VxKMyhFRaETpDApSeN84EgYgZ2u48fbCAB
         FAUJo96zK4U/elSrmTCzK/dHy3iAiQqoGbKZJmNw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Olivier Moysan <olivier.moysan@st.com>,
        Fabrice Gasnier <fabrice.gasnier@st.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.4 089/168] iio: adc: stm32-adc: fix sleep in atomic context
Date:   Tue, 28 Apr 2020 20:24:23 +0200
Message-Id: <20200428182243.588223414@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182231.704304409@linuxfoundation.org>
References: <20200428182231.704304409@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Olivier Moysan <olivier.moysan@st.com>

commit e2042d2936dfc84e9c600fe9b9d0039ca0e54b7d upstream.

This commit fixes the following error:
"BUG: sleeping function called from invalid context at kernel/irq/chip.c"

In DMA mode suppress the trigger irq handler, and make the buffer
transfers directly in DMA callback, instead.

Fixes: 2763ea0585c9 ("iio: adc: stm32: add optional dma support")
Signed-off-by: Olivier Moysan <olivier.moysan@st.com>
Acked-by: Fabrice Gasnier <fabrice.gasnier@st.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/adc/stm32-adc.c |   31 ++++++++++++++++++++++++++++---
 1 file changed, 28 insertions(+), 3 deletions(-)

--- a/drivers/iio/adc/stm32-adc.c
+++ b/drivers/iio/adc/stm32-adc.c
@@ -1367,8 +1367,30 @@ static unsigned int stm32_adc_dma_residu
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
+
+	while (residue >= indio_dev->scan_bytes) {
+		u16 *buffer = (u16 *)&adc->rx_buf[adc->bufi];
 
-	iio_trigger_poll_chained(indio_dev->trig);
+		iio_push_to_buffers(indio_dev, buffer);
+
+		residue -= indio_dev->scan_bytes;
+		adc->bufi += indio_dev->scan_bytes;
+		if (adc->bufi >= adc->rx_buf_sz)
+			adc->bufi = 0;
+	}
 }
 
 static int stm32_adc_dma_start(struct iio_dev *indio_dev)
@@ -1778,6 +1800,7 @@ static int stm32_adc_probe(struct platfo
 {
 	struct iio_dev *indio_dev;
 	struct device *dev = &pdev->dev;
+	irqreturn_t (*handler)(int irq, void *p) = NULL;
 	struct stm32_adc *adc;
 	int ret;
 
@@ -1843,9 +1866,11 @@ static int stm32_adc_probe(struct platfo
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


