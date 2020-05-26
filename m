Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7608F1E2B24
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:03:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391068AbgEZTCZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:02:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:57188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390269AbgEZTCZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:02:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 275F420849;
        Tue, 26 May 2020 19:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519744;
        bh=H63YJtgJZbKb64vMUxzAPQwIpPLNoz1QOyiyGbsojyM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a3SpKxXT3UYhD1YAJO6bSCvnIcqqhsV9MG5E3FFRwXnC/TAQhd64QU2SZqIAk9goY
         pRCZ2x7T54urCI2lvRWoReq5fV282BU4abc4Wc5PrJU5wxVz4Wy2DRuydkDbzBIBgy
         rI9CT4fTRjOIglyM9Xb9R3gXjlTyhFAHeJJ4c36M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Fabrice Gasnier <fabrice.gasnier@st.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 58/59] iio: adc: stm32-adc: Use dma_request_chan() instead dma_request_slave_channel()
Date:   Tue, 26 May 2020 20:53:43 +0200
Message-Id: <20200526183924.580101506@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183907.123822792@linuxfoundation.org>
References: <20200526183907.123822792@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Ujfalusi <peter.ujfalusi@ti.com>

[ Upstream commit 735404b846dffcb320264f62b76e6f70012214dd ]

dma_request_slave_channel() is a wrapper on top of dma_request_chan()
eating up the error code.

By using dma_request_chan() directly the driver can support deferred
probing against DMA.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Acked-by: Fabrice Gasnier <fabrice.gasnier@st.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/stm32-adc.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/adc/stm32-adc.c b/drivers/iio/adc/stm32-adc.c
index 3cfb2d4b2441..9a243f06389d 100644
--- a/drivers/iio/adc/stm32-adc.c
+++ b/drivers/iio/adc/stm32-adc.c
@@ -1633,9 +1633,21 @@ static int stm32_adc_dma_request(struct iio_dev *indio_dev)
 	struct dma_slave_config config;
 	int ret;
 
-	adc->dma_chan = dma_request_slave_channel(&indio_dev->dev, "rx");
-	if (!adc->dma_chan)
+	adc->dma_chan = dma_request_chan(&indio_dev->dev, "rx");
+	if (IS_ERR(adc->dma_chan)) {
+		ret = PTR_ERR(adc->dma_chan);
+		if (ret != -ENODEV) {
+			if (ret != -EPROBE_DEFER)
+				dev_err(&indio_dev->dev,
+					"DMA channel request failed with %d\n",
+					ret);
+			return ret;
+		}
+
+		/* DMA is optional: fall back to IRQ mode */
+		adc->dma_chan = NULL;
 		return 0;
+	}
 
 	adc->rx_buf = dma_alloc_coherent(adc->dma_chan->device->dev,
 					 STM32_DMA_BUFFER_SIZE,
-- 
2.25.1



