Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5746A1D4FFD
	for <lists+stable@lfdr.de>; Fri, 15 May 2020 16:06:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726197AbgEOOG1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 May 2020 10:06:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:57464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726163AbgEOOG1 (ORCPT <rfc822;Stable@vger.kernel.org>);
        Fri, 15 May 2020 10:06:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C9F2B2075F;
        Fri, 15 May 2020 14:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589551586;
        bh=MUdkywnLbrROZV3+U6vGDDP9eqJgTdBScY6Wwax93TE=;
        h=Subject:To:From:Date:From;
        b=mi5bD2q0WMYSn5C8PevZS/Lc5ssl+BYIHrdMYXQ1/GHJ/AT7qthHUXJDjbvbumi/m
         XTUN3MVvGXqWuzFkPpM7O6TSd+ZyecRnxO+4H42Ex8I0okQDMpGbAAxkXOfQJLhkJf
         QfHEMaNUgtUjXkDirqk3phe7EyGPBvozLFBgK2J4=
Subject: patch "iio: adc: stm32-dfsdm: fix device used to request dma" added to staging-linus
To:     fabrice.gasnier@st.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 15 May 2020 16:06:09 +0200
Message-ID: <158955156919478@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: adc: stm32-dfsdm: fix device used to request dma

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From b455d06e6fb3c035711e8aab1ca18082ccb15d87 Mon Sep 17 00:00:00 2001
From: Fabrice Gasnier <fabrice.gasnier@st.com>
Date: Thu, 30 Apr 2020 11:28:46 +0200
Subject: iio: adc: stm32-dfsdm: fix device used to request dma

DMA channel request should use device struct from platform device struct.
Currently it's using iio device struct. But at this stage when probing,
device struct isn't yet registered (e.g. device_register is done in
iio_device_register). Since commit 71723a96b8b1 ("dmaengine: Create
symlinks between DMA channels and slaves"), a warning message is printed
as the links in sysfs can't be created, due to device isn't yet registered:
- Cannot create DMA slave symlink
- Cannot create DMA dma:rx symlink

Fix this by using device struct from platform device to request dma chan.

Fixes: eca949800d2d ("IIO: ADC: add stm32 DFSDM support for PDM microphone")

Signed-off-by: Fabrice Gasnier <fabrice.gasnier@st.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/adc/stm32-dfsdm-adc.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/iio/adc/stm32-dfsdm-adc.c b/drivers/iio/adc/stm32-dfsdm-adc.c
index 76a60d93fe23..506bf519f64c 100644
--- a/drivers/iio/adc/stm32-dfsdm-adc.c
+++ b/drivers/iio/adc/stm32-dfsdm-adc.c
@@ -62,7 +62,7 @@ enum sd_converter_type {
 
 struct stm32_dfsdm_dev_data {
 	int type;
-	int (*init)(struct iio_dev *indio_dev);
+	int (*init)(struct device *dev, struct iio_dev *indio_dev);
 	unsigned int num_channels;
 	const struct regmap_config *regmap_cfg;
 };
@@ -1365,11 +1365,12 @@ static void stm32_dfsdm_dma_release(struct iio_dev *indio_dev)
 	}
 }
 
-static int stm32_dfsdm_dma_request(struct iio_dev *indio_dev)
+static int stm32_dfsdm_dma_request(struct device *dev,
+				   struct iio_dev *indio_dev)
 {
 	struct stm32_dfsdm_adc *adc = iio_priv(indio_dev);
 
-	adc->dma_chan = dma_request_chan(&indio_dev->dev, "rx");
+	adc->dma_chan = dma_request_chan(dev, "rx");
 	if (IS_ERR(adc->dma_chan)) {
 		int ret = PTR_ERR(adc->dma_chan);
 
@@ -1425,7 +1426,7 @@ static int stm32_dfsdm_adc_chan_init_one(struct iio_dev *indio_dev,
 					  &adc->dfsdm->ch_list[ch->channel]);
 }
 
-static int stm32_dfsdm_audio_init(struct iio_dev *indio_dev)
+static int stm32_dfsdm_audio_init(struct device *dev, struct iio_dev *indio_dev)
 {
 	struct iio_chan_spec *ch;
 	struct stm32_dfsdm_adc *adc = iio_priv(indio_dev);
@@ -1452,10 +1453,10 @@ static int stm32_dfsdm_audio_init(struct iio_dev *indio_dev)
 	indio_dev->num_channels = 1;
 	indio_dev->channels = ch;
 
-	return stm32_dfsdm_dma_request(indio_dev);
+	return stm32_dfsdm_dma_request(dev, indio_dev);
 }
 
-static int stm32_dfsdm_adc_init(struct iio_dev *indio_dev)
+static int stm32_dfsdm_adc_init(struct device *dev, struct iio_dev *indio_dev)
 {
 	struct iio_chan_spec *ch;
 	struct stm32_dfsdm_adc *adc = iio_priv(indio_dev);
@@ -1499,17 +1500,17 @@ static int stm32_dfsdm_adc_init(struct iio_dev *indio_dev)
 	init_completion(&adc->completion);
 
 	/* Optionally request DMA */
-	ret = stm32_dfsdm_dma_request(indio_dev);
+	ret = stm32_dfsdm_dma_request(dev, indio_dev);
 	if (ret) {
 		if (ret != -ENODEV) {
 			if (ret != -EPROBE_DEFER)
-				dev_err(&indio_dev->dev,
+				dev_err(dev,
 					"DMA channel request failed with %d\n",
 					ret);
 			return ret;
 		}
 
-		dev_dbg(&indio_dev->dev, "No DMA support\n");
+		dev_dbg(dev, "No DMA support\n");
 		return 0;
 	}
 
@@ -1622,7 +1623,7 @@ static int stm32_dfsdm_adc_probe(struct platform_device *pdev)
 		adc->dfsdm->fl_list[adc->fl_id].sync_mode = val;
 
 	adc->dev_data = dev_data;
-	ret = dev_data->init(iio);
+	ret = dev_data->init(dev, iio);
 	if (ret < 0)
 		return ret;
 
-- 
2.26.2


