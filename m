Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D84651E2E05
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391523AbgEZTFm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:05:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:33656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391515AbgEZTFi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:05:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 146A7208B3;
        Tue, 26 May 2020 19:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519938;
        bh=Sh0vWyUgql9rAjGEr/FgZ4H8MfQq4g5C35lNdF+t0H8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p49mqNoOpBZqwvx4GEsy8px4hyadzYPXyhEeo/JSYmd6PWmQmW0ZZPYHSM0onjhKf
         bnV581lgieU7wXk8FcW7lCNLMKD/fspTAuni8EV0Kmp/Sm9sRneT10Jn090Jz+lMDM
         6EZFPKacFO5RZA2WsZKYosx0Hc0m7Ac7bsHRo82k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabrice Gasnier <fabrice.gasnier@st.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 76/81] iio: adc: stm32-adc: fix device used to request dma
Date:   Tue, 26 May 2020 20:53:51 +0200
Message-Id: <20200526183935.502017260@linuxfoundation.org>
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

From: Fabrice Gasnier <fabrice.gasnier@st.com>

[ Upstream commit 52cd91c27f3908b88e8b25aed4a4d20660abcc45 ]

DMA channel request should use device struct from platform device struct.
Currently it's using iio device struct. But at this stage when probing,
device struct isn't yet registered (e.g. device_register is done in
iio_device_register). Since commit 71723a96b8b1 ("dmaengine: Create
symlinks between DMA channels and slaves"), a warning message is printed
as the links in sysfs can't be created, due to device isn't yet registered:
- Cannot create DMA slave symlink
- Cannot create DMA dma:rx symlink

Fix this by using device struct from platform device to request dma chan.

Fixes: 2763ea0585c99 ("iio: adc: stm32: add optional dma support")

Signed-off-by: Fabrice Gasnier <fabrice.gasnier@st.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/stm32-adc.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/iio/adc/stm32-adc.c b/drivers/iio/adc/stm32-adc.c
index d85caedda02e..59fd8b620c50 100644
--- a/drivers/iio/adc/stm32-adc.c
+++ b/drivers/iio/adc/stm32-adc.c
@@ -1682,18 +1682,18 @@ static int stm32_adc_chan_of_init(struct iio_dev *indio_dev)
 	return 0;
 }
 
-static int stm32_adc_dma_request(struct iio_dev *indio_dev)
+static int stm32_adc_dma_request(struct device *dev, struct iio_dev *indio_dev)
 {
 	struct stm32_adc *adc = iio_priv(indio_dev);
 	struct dma_slave_config config;
 	int ret;
 
-	adc->dma_chan = dma_request_chan(&indio_dev->dev, "rx");
+	adc->dma_chan = dma_request_chan(dev, "rx");
 	if (IS_ERR(adc->dma_chan)) {
 		ret = PTR_ERR(adc->dma_chan);
 		if (ret != -ENODEV) {
 			if (ret != -EPROBE_DEFER)
-				dev_err(&indio_dev->dev,
+				dev_err(dev,
 					"DMA channel request failed with %d\n",
 					ret);
 			return ret;
@@ -1816,7 +1816,7 @@ static int stm32_adc_probe(struct platform_device *pdev)
 	if (ret < 0)
 		goto err_clk_disable;
 
-	ret = stm32_adc_dma_request(indio_dev);
+	ret = stm32_adc_dma_request(dev, indio_dev);
 	if (ret < 0)
 		goto err_clk_disable;
 
-- 
2.25.1



