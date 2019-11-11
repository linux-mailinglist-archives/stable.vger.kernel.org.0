Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DD89F7E24
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 20:02:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727343AbfKKSuV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:50:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:44038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728461AbfKKSuV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:50:21 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C32D9204FD;
        Mon, 11 Nov 2019 18:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498220;
        bh=Pe6Py8n2DNINwiacBMTrfmmqa8fmufKwuj0LTitGrb8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RVd/twFVSnl2koqSAg1u+N8djSPGpZKnHPYClcupCKiWxRfV5V33L9ukNjiPuyMBk
         OlPedh/dddonBOY3hBKWh403lv16lp98DVZaCPoC/g0ItU1UDdruDxHcBN2NmVJjfT
         R2SNngNOkF//Kwd4wvcZn77CodfjVy4zAXbgYRqs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabrice Gasnier <fabrice.gasnier@st.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.3 056/193] iio: adc: stm32-adc: fix stopping dma
Date:   Mon, 11 Nov 2019 19:27:18 +0100
Message-Id: <20191111181505.125706761@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181459.850623879@linuxfoundation.org>
References: <20191111181459.850623879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabrice Gasnier <fabrice.gasnier@st.com>

commit e6afcf6c598d6f3a0c9c408bfeddb3f5730608b0 upstream.

There maybe a race when using dmaengine_terminate_all(). The predisable
routine may call iio_triggered_buffer_predisable() prior to a pending DMA
callback.
Adopt dmaengine_terminate_sync() to ensure there's no pending DMA request
before calling iio_triggered_buffer_predisable().

Fixes: 2763ea0585c9 ("iio: adc: stm32: add optional dma support")

Signed-off-by: Fabrice Gasnier <fabrice.gasnier@st.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/adc/stm32-adc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/iio/adc/stm32-adc.c
+++ b/drivers/iio/adc/stm32-adc.c
@@ -1399,7 +1399,7 @@ static int stm32_adc_dma_start(struct ii
 	cookie = dmaengine_submit(desc);
 	ret = dma_submit_error(cookie);
 	if (ret) {
-		dmaengine_terminate_all(adc->dma_chan);
+		dmaengine_terminate_sync(adc->dma_chan);
 		return ret;
 	}
 
@@ -1477,7 +1477,7 @@ static void __stm32_adc_buffer_predisabl
 		stm32_adc_conv_irq_disable(adc);
 
 	if (adc->dma_chan)
-		dmaengine_terminate_all(adc->dma_chan);
+		dmaengine_terminate_sync(adc->dma_chan);
 
 	if (stm32_adc_set_trig(indio_dev, NULL))
 		dev_err(&indio_dev->dev, "Can't clear trigger\n");


