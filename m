Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A37D106E90
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:09:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730776AbfKVLCu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 06:02:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:56632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731356AbfKVLCt (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 06:02:49 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB1F22075E;
        Fri, 22 Nov 2019 11:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420569;
        bh=0gEzsh+7Ngn7kbU3KfbwyUiSURyxIcBfrRMxOaEwNbA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l8Bny6AFkiC9EAXwhdf3nrqwCM6txxIVTdpoic7uVHnMZxHHJkgm1HDZVBrwCdUWh
         +H8j/v5RXp2t8xZpmZRTsd5gzIituzA77x/PI4sj2m2YM2vYdOMvNBm7j/S/CFKT3Z
         6dqtMHjzhdxKfGjwQW5lG4Z1FIj6MkknIbzlKvKU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 150/220] mmc: renesas_sdhi_internal_dmac: set scatter/gather max segment size
Date:   Fri, 22 Nov 2019 11:28:35 +0100
Message-Id: <20191122100923.526919896@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100912.732983531@linuxfoundation.org>
References: <20191122100912.732983531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

[ Upstream commit 54541815b43f4e49c82628bf28bbb31d86d2f58a ]

Fix warning when running with CONFIG_DMA_API_DEBUG_SG=y by allocating a
device_dma_parameters structure and filling in the max segment size. The
size used is the result of a discussion with Renesas hardware engineers
and unfortunately not found in the datasheet.

  renesas_sdhi_internal_dmac ee140000.sd: DMA-API: mapping sg segment
  longer than device claims to support [len=126976] [max=65536]

Reported-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
[wsa: simplified some logic after validating intended dma_parms life cycle
      and added comment]
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/renesas_sdhi_internal_dmac.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/mmc/host/renesas_sdhi_internal_dmac.c b/drivers/mmc/host/renesas_sdhi_internal_dmac.c
index f4aefa8954bfc..382172fb3da8f 100644
--- a/drivers/mmc/host/renesas_sdhi_internal_dmac.c
+++ b/drivers/mmc/host/renesas_sdhi_internal_dmac.c
@@ -310,12 +310,20 @@ static const struct soc_device_attribute gen3_soc_whitelist[] = {
 static int renesas_sdhi_internal_dmac_probe(struct platform_device *pdev)
 {
 	const struct soc_device_attribute *soc = soc_device_match(gen3_soc_whitelist);
+	struct device *dev = &pdev->dev;
 
 	if (!soc)
 		return -ENODEV;
 
 	global_flags |= (unsigned long)soc->data;
 
+	dev->dma_parms = devm_kzalloc(dev, sizeof(*dev->dma_parms), GFP_KERNEL);
+	if (!dev->dma_parms)
+		return -ENOMEM;
+
+	/* value is max of SD_SECCNT. Confirmed by HW engineers */
+	dma_set_max_seg_size(dev, 0xffffffff);
+
 	return renesas_sdhi_probe(pdev, &renesas_sdhi_internal_dmac_dma_ops);
 }
 
-- 
2.20.1



