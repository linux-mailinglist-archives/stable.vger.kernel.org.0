Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE8341E2E07
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:26:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390522AbgEZT0X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:26:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:33692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391521AbgEZTFl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:05:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B54120873;
        Tue, 26 May 2020 19:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519940;
        bh=gkOodJPnHPt2bn5Ii9IrOlStnEZJDKD9xkLvRS4kHSQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v8lnzqQel1Q/+KR2D0czq2NPxE0lTz/t1dClrK+cK94hGLXDNC2Imj71YtQ8Meu2/
         hZ4nDpOyHgX8gia06ssSsDHcOVhirLzhQvYCG92Q24B31XtL6NQJrEXy67sHJSqXuk
         F+RcI26UDFNXlIofENiGq7CjguzZzODOuEeCHHxc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Olivier Moysan <olivier.moysan@st.com>,
        Fabrice Gasnier <fabrice.gasnier@st.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 77/81] iio: adc: stm32-dfsdm: Use dma_request_chan() instead dma_request_slave_channel()
Date:   Tue, 26 May 2020 20:53:52 +0200
Message-Id: <20200526183935.612357218@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183923.108515292@linuxfoundation.org>
References: <20200526183923.108515292@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Ujfalusi <peter.ujfalusi@ti.com>

[ Upstream commit a9ab624edd9186fbad734cfe5d606a6da3ca34db ]

dma_request_slave_channel() is a wrapper on top of dma_request_chan()
eating up the error code.

By using dma_request_chan() directly the driver can support deferred
probing against DMA.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Acked-by: Olivier Moysan <olivier.moysan@st.com>
Acked-by: Fabrice Gasnier <fabrice.gasnier@st.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/stm32-dfsdm-adc.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/iio/adc/stm32-dfsdm-adc.c b/drivers/iio/adc/stm32-dfsdm-adc.c
index f5586dd6414d..516d7d22d9f4 100644
--- a/drivers/iio/adc/stm32-dfsdm-adc.c
+++ b/drivers/iio/adc/stm32-dfsdm-adc.c
@@ -933,9 +933,13 @@ static int stm32_dfsdm_dma_request(struct iio_dev *indio_dev)
 	};
 	int ret;
 
-	adc->dma_chan = dma_request_slave_channel(&indio_dev->dev, "rx");
-	if (!adc->dma_chan)
-		return -EINVAL;
+	adc->dma_chan = dma_request_chan(&indio_dev->dev, "rx");
+	if (IS_ERR(adc->dma_chan)) {
+		int ret = PTR_ERR(adc->dma_chan);
+
+		adc->dma_chan = NULL;
+		return ret;
+	}
 
 	adc->rx_buf = dma_alloc_coherent(adc->dma_chan->device->dev,
 					 DFSDM_DMA_BUFFER_SIZE,
-- 
2.25.1



