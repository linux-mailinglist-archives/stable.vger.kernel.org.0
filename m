Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F36E5380A0
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 16:24:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235975AbiE3ODc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 10:03:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239602AbiE3OBn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 10:01:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D110C5D83;
        Mon, 30 May 2022 06:39:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D024760F9B;
        Mon, 30 May 2022 13:39:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B304C3411E;
        Mon, 30 May 2022 13:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917971;
        bh=CPnkfdhDvvK18QY0iB6KzCYkpZ8e2EraQNOJJmpAkcY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S4GEdMpDXfaRk0My1QTs6yO8nr58dvngS1Kesyc1WsV2Dojdd97L9s+7v3yA3a3GD
         muFFkdLMeFnTkrCjNP3DE7D225JcBU4Qn0zFcrZ61r/2S/TIuNa5dOryQ4bG1wpN1s
         I3fSN6wbrS8lxNSAVsd1xD7wu8vlSOyLksSJmfgl/Mvn2VA+7VZ0Vs8lAcjbQVPy97
         rPkMm2eYvaxepV/K6ktPlsNWy+JfNksbeIU5h33m6Ds/MrCiBX9v2bCy4mnq6qG3b7
         t+rNz+isISpXkbcwdM0Ln6KXRxv//XuVjb+uTPF5JZgC3WDppsRfKMc6Ll8xL5TZIN
         WgzWCzfT1OzaQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Biju Das <biju.das.jz@bp.renesas.com>,
        Vinod Koul <vkoul@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 022/109] spi: spi-rspi: Remove setting {src,dst}_{addr,addr_width} based on DMA direction
Date:   Mon, 30 May 2022 09:36:58 -0400
Message-Id: <20220530133825.1933431-22-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530133825.1933431-1-sashal@kernel.org>
References: <20220530133825.1933431-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Biju Das <biju.das.jz@bp.renesas.com>

[ Upstream commit 6f381481a5b236cb53d6de2c49c6ef83a4d0f432 ]

The direction field in the DMA config is deprecated. The rspi driver
sets {src,dst}_{addr,addr_width} based on the DMA direction and
it results in dmaengine_slave_config() failure as RZ DMAC driver
validates {src,dst}_addr_width values independent of DMA direction.

This patch fixes the issue by passing both {src,dst}_{addr,addr_width}
values independent of DMA direction.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Suggested-by: Vinod Koul <vkoul@kernel.org>
Reviewed-by: Vinod Koul <vkoul@kernel.org>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/20220411173115.6619-1-biju.das.jz@bp.renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-rspi.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/spi/spi-rspi.c b/drivers/spi/spi-rspi.c
index d16ed88802d3..d575c935e9f0 100644
--- a/drivers/spi/spi-rspi.c
+++ b/drivers/spi/spi-rspi.c
@@ -1107,14 +1107,11 @@ static struct dma_chan *rspi_request_dma_chan(struct device *dev,
 	}
 
 	memset(&cfg, 0, sizeof(cfg));
+	cfg.dst_addr = port_addr + RSPI_SPDR;
+	cfg.src_addr = port_addr + RSPI_SPDR;
+	cfg.dst_addr_width = DMA_SLAVE_BUSWIDTH_1_BYTE;
+	cfg.src_addr_width = DMA_SLAVE_BUSWIDTH_1_BYTE;
 	cfg.direction = dir;
-	if (dir == DMA_MEM_TO_DEV) {
-		cfg.dst_addr = port_addr;
-		cfg.dst_addr_width = DMA_SLAVE_BUSWIDTH_1_BYTE;
-	} else {
-		cfg.src_addr = port_addr;
-		cfg.src_addr_width = DMA_SLAVE_BUSWIDTH_1_BYTE;
-	}
 
 	ret = dmaengine_slave_config(chan, &cfg);
 	if (ret) {
@@ -1145,12 +1142,12 @@ static int rspi_request_dma(struct device *dev, struct spi_controller *ctlr,
 	}
 
 	ctlr->dma_tx = rspi_request_dma_chan(dev, DMA_MEM_TO_DEV, dma_tx_id,
-					     res->start + RSPI_SPDR);
+					     res->start);
 	if (!ctlr->dma_tx)
 		return -ENODEV;
 
 	ctlr->dma_rx = rspi_request_dma_chan(dev, DMA_DEV_TO_MEM, dma_rx_id,
-					     res->start + RSPI_SPDR);
+					     res->start);
 	if (!ctlr->dma_rx) {
 		dma_release_channel(ctlr->dma_tx);
 		ctlr->dma_tx = NULL;
-- 
2.35.1

