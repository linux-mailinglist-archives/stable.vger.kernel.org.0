Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80F84147D3E
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 11:02:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731051AbgAXJ6e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:58:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:34032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725821AbgAXJ6d (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:58:33 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 257B620709;
        Fri, 24 Jan 2020 09:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579859912;
        bh=YZQj15HykUfkx12S9MAongzeegBHADwge2FK/tjmt2k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vo7vKxIAygQ1hHeYfwZGeNE3zMzeP/qZP96oVRzfPDLJ7bkQralL6wZng99HkU/ws
         uzBt67TecdevcQEwUmW7T2LyrRhrKQeVM/Sc4u1FduNHPTNU1Tj6yevHC/dthAC4yS
         yCpGDNDllqhoLDfuwjnzZ/kD+DOggfQA9qzv/iCU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Hunter <jonathanh@nvidia.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 212/343] dmaengine: tegra210-adma: Fix crash during probe
Date:   Fri, 24 Jan 2020 10:30:30 +0100
Message-Id: <20200124092947.960310264@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092919.490687572@linuxfoundation.org>
References: <20200124092919.490687572@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jon Hunter <jonathanh@nvidia.com>

[ Upstream commit b53611fb1ce9b1786bd18205473e0c1d6bfa8934 ]

Commit f33e7bb3eb92 ("dmaengine: tegra210-adma: restore channel status")
added support to save and restore the DMA channel registers when runtime
suspending the ADMA. This change is causing the kernel to crash when
probing the ADMA, if the device is probed deferred when looking up the
channel interrupts. The crash occurs because not all of the channel base
addresses have been setup at this point and in the clean-up path of the
probe, pm_runtime_suspend() is called invoking its callback which
expects all the channel base addresses to be initialised.

Although this could be fixed by simply checking for a NULL address, on
further review of the driver it seems more appropriate that we only call
pm_runtime_get_sync() after all the channel interrupts and base
addresses have been configured. Therefore, fix this crash by moving the
calls to pm_runtime_enable(), pm_runtime_get_sync() and
tegra_adma_init() after the DMA channels have been initialised.

Fixes: f33e7bb3eb92 ("dmaengine: tegra210-adma: restore channel status")

Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/tegra210-adma.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/dma/tegra210-adma.c b/drivers/dma/tegra210-adma.c
index ac2a6b800db3e..4f4733d831a1a 100644
--- a/drivers/dma/tegra210-adma.c
+++ b/drivers/dma/tegra210-adma.c
@@ -744,16 +744,6 @@ static int tegra_adma_probe(struct platform_device *pdev)
 		return PTR_ERR(tdma->ahub_clk);
 	}
 
-	pm_runtime_enable(&pdev->dev);
-
-	ret = pm_runtime_get_sync(&pdev->dev);
-	if (ret < 0)
-		goto rpm_disable;
-
-	ret = tegra_adma_init(tdma);
-	if (ret)
-		goto rpm_put;
-
 	INIT_LIST_HEAD(&tdma->dma_dev.channels);
 	for (i = 0; i < tdma->nr_channels; i++) {
 		struct tegra_adma_chan *tdc = &tdma->channels[i];
@@ -771,6 +761,16 @@ static int tegra_adma_probe(struct platform_device *pdev)
 		tdc->tdma = tdma;
 	}
 
+	pm_runtime_enable(&pdev->dev);
+
+	ret = pm_runtime_get_sync(&pdev->dev);
+	if (ret < 0)
+		goto rpm_disable;
+
+	ret = tegra_adma_init(tdma);
+	if (ret)
+		goto rpm_put;
+
 	dma_cap_set(DMA_SLAVE, tdma->dma_dev.cap_mask);
 	dma_cap_set(DMA_PRIVATE, tdma->dma_dev.cap_mask);
 	dma_cap_set(DMA_CYCLIC, tdma->dma_dev.cap_mask);
@@ -812,13 +812,13 @@ static int tegra_adma_probe(struct platform_device *pdev)
 
 dma_remove:
 	dma_async_device_unregister(&tdma->dma_dev);
-irq_dispose:
-	while (--i >= 0)
-		irq_dispose_mapping(tdma->channels[i].irq);
 rpm_put:
 	pm_runtime_put_sync(&pdev->dev);
 rpm_disable:
 	pm_runtime_disable(&pdev->dev);
+irq_dispose:
+	while (--i >= 0)
+		irq_dispose_mapping(tdma->channels[i].irq);
 
 	return ret;
 }
-- 
2.20.1



