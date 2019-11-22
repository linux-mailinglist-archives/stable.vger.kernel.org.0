Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FD0F106F25
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:14:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728731AbfKVLNg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 06:13:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:42226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730467AbfKVKz2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:55:28 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B0E8D20718;
        Fri, 22 Nov 2019 10:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420127;
        bh=CyxFmt8RNp2/3hmmxtbe3/3gSyvkKx15wfdi3MWjiG4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CRzwYqfpYuGbib4iUYFgXXydH48t7+C3Te11cEX08p5jmxL50DToqaPjtSysQtcUX
         P9vQKme5MfoMedGueogsOoDgDLwEFU3OCbZMzT1kgvsRHJOy7Xwz2wJQn0f9IDgXhe
         4ThOGKcsslmucCNP5N3XzbdYy302//Vx76bHlpSM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 081/122] dmaengine: rcar-dmac: set scatter/gather max segment size
Date:   Fri, 22 Nov 2019 11:28:54 +0100
Message-Id: <20191122100820.928960169@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100722.177052205@linuxfoundation.org>
References: <20191122100722.177052205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit 97d49c59e219acac576e16293a6b8cb99302f62f ]

Fix warning when running with CONFIG_DMA_API_DEBUG_SG=y by allocating a
device_dma_parameters structure and filling in the max segment size.

Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/sh/rcar-dmac.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/dma/sh/rcar-dmac.c b/drivers/dma/sh/rcar-dmac.c
index 19c7433e83097..f7ca57125ac7c 100644
--- a/drivers/dma/sh/rcar-dmac.c
+++ b/drivers/dma/sh/rcar-dmac.c
@@ -200,6 +200,7 @@ struct rcar_dmac {
 	struct dma_device engine;
 	struct device *dev;
 	void __iomem *iomem;
+	struct device_dma_parameters parms;
 
 	unsigned int n_channels;
 	struct rcar_dmac_chan *channels;
@@ -1764,6 +1765,8 @@ static int rcar_dmac_probe(struct platform_device *pdev)
 
 	dmac->dev = &pdev->dev;
 	platform_set_drvdata(pdev, dmac);
+	dmac->dev->dma_parms = &dmac->parms;
+	dma_set_max_seg_size(dmac->dev, RCAR_DMATCR_MASK);
 	dma_set_mask_and_coherent(dmac->dev, DMA_BIT_MASK(40));
 
 	ret = rcar_dmac_parse_of(&pdev->dev, dmac);
-- 
2.20.1



