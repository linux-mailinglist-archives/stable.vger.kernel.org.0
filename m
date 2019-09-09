Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C287AE0D5
	for <lists+stable@lfdr.de>; Tue, 10 Sep 2019 00:19:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392083AbfIIWQX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Sep 2019 18:16:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:45204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392067AbfIIWQU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Sep 2019 18:16:20 -0400
Received: from sasha-vm.mshome.net (unknown [62.28.240.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4676821D7B;
        Mon,  9 Sep 2019 22:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568067379;
        bh=sjobayxK8BQV7kAzsBZ5thsoTl6H6cbirtCozGkDE30=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b0FVNnvQ3hp7K8rqP5xme5BJlwhCWSLCGOvSfClu0HKV1SgAeb80zyzl5mbUtns0h
         KBHkA7TY6bRxShbQTRFeroEQLo1mEKXML+U+flZgmIhkB/Vtc7xSnLlYOQ0hjtZ3Hs
         GbywuCdAJ6Rl/dBKHG2g6J42fPLLpbcdTxLpGDBQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Baolin Wang <baolin.wang@linaro.org>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        dmaengine@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 08/12] dmaengine: sprd: Fix the DMA link-list configuration
Date:   Mon,  9 Sep 2019 11:40:48 -0400
Message-Id: <20190909154052.30941-8-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190909154052.30941-1-sashal@kernel.org>
References: <20190909154052.30941-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Baolin Wang <baolin.wang@linaro.org>

[ Upstream commit 689379c2f383b1fdfdff03e84cf659daf62f2088 ]

For the Spreadtrum DMA link-list mode, when the DMA engine got a slave
hardware request, which will trigger the DMA engine to load the DMA
configuration from the link-list memory automatically. But before the
slave hardware request, the slave will get an incorrect residue due
to the first node used to trigger the link-list was configured as the
last source address and destination address.

Thus we should make sure the first node was configured the start source
address and destination address, which can fix this issue.

Fixes: 4ac695464763 ("dmaengine: sprd: Support DMA link-list mode")
Signed-off-by: Baolin Wang <baolin.wang@linaro.org>
Link: https://lore.kernel.org/r/77868edb7aff9d5cb12ac3af8827ef2e244441a6.1567150471.git.baolin.wang@linaro.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/sprd-dma.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/sprd-dma.c b/drivers/dma/sprd-dma.c
index baac476c86224..525dc7338fe3b 100644
--- a/drivers/dma/sprd-dma.c
+++ b/drivers/dma/sprd-dma.c
@@ -908,6 +908,7 @@ sprd_dma_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 	struct sprd_dma_chn *schan = to_sprd_dma_chan(chan);
 	struct dma_slave_config *slave_cfg = &schan->slave_cfg;
 	dma_addr_t src = 0, dst = 0;
+	dma_addr_t start_src = 0, start_dst = 0;
 	struct sprd_dma_desc *sdesc;
 	struct scatterlist *sg;
 	u32 len = 0;
@@ -954,6 +955,11 @@ sprd_dma_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 			dst = sg_dma_address(sg);
 		}
 
+		if (!i) {
+			start_src = src;
+			start_dst = dst;
+		}
+
 		/*
 		 * The link-list mode needs at least 2 link-list
 		 * configurations. If there is only one sg, it doesn't
@@ -970,8 +976,8 @@ sprd_dma_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 		}
 	}
 
-	ret = sprd_dma_fill_desc(chan, &sdesc->chn_hw, 0, 0, src, dst, len,
-				 dir, flags, slave_cfg);
+	ret = sprd_dma_fill_desc(chan, &sdesc->chn_hw, 0, 0, start_src,
+				 start_dst, len, dir, flags, slave_cfg);
 	if (ret) {
 		kfree(sdesc);
 		return NULL;
-- 
2.20.1

