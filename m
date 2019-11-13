Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20945FA3C8
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:13:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730014AbfKMCMV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 21:12:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:52188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730011AbfKMB6Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:58:25 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B0B22245C;
        Wed, 13 Nov 2019 01:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610305;
        bh=CyxFmt8RNp2/3hmmxtbe3/3gSyvkKx15wfdi3MWjiG4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1Wpb1LrkdQ/dv1j33cBk0WIYghbaOlfQL9zTBPyKrezSzYXfoIkvq117r9gZHldNP
         LnxkUWUBTYkIhrB7wcQuq/j6B5Bo0h/ZNLir6/lHF3rMtWNAhikJhuTidY/3hjAYBo
         FGnUqKeAyehbgRt8yd9DZXWXSANTpYygcqYIGptU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        dmaengine@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 074/115] dmaengine: rcar-dmac: set scatter/gather max segment size
Date:   Tue, 12 Nov 2019 20:55:41 -0500
Message-Id: <20191113015622.11592-74-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015622.11592-1-sashal@kernel.org>
References: <20191113015622.11592-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

