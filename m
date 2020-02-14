Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03EAE15E98C
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:08:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404034AbgBNRHp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:07:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:43782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392292AbgBNQOS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:14:18 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6CE04246D6;
        Fri, 14 Feb 2020 16:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696858;
        bh=GRvpBHdwaRmGyhqFV9SutAkddtjGkMHJbBSngALE17A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BCk8NFs6s9+VnZ72u+Vf6H2Hg8btTRXSNUAc6xcZh/B2bsipvvAE748NTWqIoyV79
         E/dBYPUxAtDWCbBXHgPhbuYfjZW5MetjY1BdgFqcdyoowXVcX53reOvAoHYLjbI02b
         zM8LyS2/QzNlvmGgL3pbLsVC4tnAjH50js6nft2M=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sascha Hauer <s.hauer@pengutronix.de>,
        Robin Gong <yibin.gong@nxp.com>, Vinod Koul <vkoul@kernel.org>,
        Sasha Levin <sashal@kernel.org>, dmaengine@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 118/252] dmaengine: imx-sdma: Fix memory leak
Date:   Fri, 14 Feb 2020 11:09:33 -0500
Message-Id: <20200214161147.15842-118-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214161147.15842-1-sashal@kernel.org>
References: <20200214161147.15842-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sascha Hauer <s.hauer@pengutronix.de>

[ Upstream commit 02939cd167095f16328a1bd5cab5a90b550606df ]

The current descriptor is not on any list of the virtual DMA channel.
Once sdma_terminate_all() is called when a descriptor is currently
in flight then this one is forgotten to be freed. We have to call
vchan_terminate_vdesc() on this descriptor to re-add it to the lists.
Now that we also free the currently running descriptor we can (and
actually have to) remove the current descriptor from its list also
for the cyclic case.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Reviewed-by: Robin Gong <yibin.gong@nxp.com>
Tested-by: Robin Gong <yibin.gong@nxp.com>
Link: https://lore.kernel.org/r/20191216105328.15198-10-s.hauer@pengutronix.de
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/imx-sdma.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
index ceb82e74f5b4e..d66a7fdff898e 100644
--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -738,12 +738,8 @@ static void sdma_start_desc(struct sdma_channel *sdmac)
 		return;
 	}
 	sdmac->desc = desc = to_sdma_desc(&vd->tx);
-	/*
-	 * Do not delete the node in desc_issued list in cyclic mode, otherwise
-	 * the desc allocated will never be freed in vchan_dma_desc_free_list
-	 */
-	if (!(sdmac->flags & IMX_DMA_SG_LOOP))
-		list_del(&vd->node);
+
+	list_del(&vd->node);
 
 	sdma->channel_control[channel].base_bd_ptr = desc->bd_phys;
 	sdma->channel_control[channel].current_bd_ptr = desc->bd_phys;
@@ -1044,7 +1040,6 @@ static void sdma_channel_terminate_work(struct work_struct *work)
 
 	spin_lock_irqsave(&sdmac->vc.lock, flags);
 	vchan_get_all_descriptors(&sdmac->vc, &head);
-	sdmac->desc = NULL;
 	spin_unlock_irqrestore(&sdmac->vc.lock, flags);
 	vchan_dma_desc_free_list(&sdmac->vc, &head);
 }
@@ -1052,11 +1047,19 @@ static void sdma_channel_terminate_work(struct work_struct *work)
 static int sdma_disable_channel_async(struct dma_chan *chan)
 {
 	struct sdma_channel *sdmac = to_sdma_chan(chan);
+	unsigned long flags;
+
+	spin_lock_irqsave(&sdmac->vc.lock, flags);
 
 	sdma_disable_channel(chan);
 
-	if (sdmac->desc)
+	if (sdmac->desc) {
+		vchan_terminate_vdesc(&sdmac->desc->vd);
+		sdmac->desc = NULL;
 		schedule_work(&sdmac->terminate_worker);
+	}
+
+	spin_unlock_irqrestore(&sdmac->vc.lock, flags);
 
 	return 0;
 }
-- 
2.20.1

