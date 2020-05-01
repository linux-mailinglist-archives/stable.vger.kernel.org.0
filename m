Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 652E51C1704
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 16:09:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730567AbgEAN4V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:56:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:57778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729617AbgEANcp (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:32:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84C95208C3;
        Fri,  1 May 2020 13:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588339965;
        bh=zP6VMlI64hQJZ2DTc28nD5ZTBc7aTru+OwhbaEP1Fzo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yxSPRgx/3qh2ZyDMItRul/3XdPrfrHyR8mhOpIyKpWYXXc9UDeachBej5Y50ji0Be
         qhB5lJiL3aAiN+ZdHKfEgyx5quXV/GK2xopEa6WjCXjUWZvgSyBpOzG4mw+O5/wuoS
         KwoOxf0t6v8mJhI55Hbq8e1AGTRBJoO2vLY3NPPI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Olivier Moysan <olivier.moysan@st.com>,
        Fabrice Gasnier <fabrice.gasnier@st.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 4.14 038/117] iio: adc: stm32-adc: fix sleep in atomic context
Date:   Fri,  1 May 2020 15:21:14 +0200
Message-Id: <20200501131549.294100823@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131544.291247695@linuxfoundation.org>
References: <20200501131544.291247695@linuxfoundation.org>
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
@@ -1311,8 +1311,30 @@ static unsigned int stm32_adc_dma_residu
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
@@ -1648,6 +1670,7 @@ static int stm32_adc_probe(struct platfo
 {
 	struct iio_dev *indio_dev;
 	struct device *dev = &pdev->dev;
+	irqreturn_t (*handler)(int irq, void *p) = NULL;
 	struct stm32_adc *adc;
 	int ret;
 
@@ -1730,9 +1753,11 @@ static int stm32_adc_probe(struct platfo
 	if (ret < 0)
 		goto err_clk_disable;
 
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


