Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB2B7537BE7
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 15:28:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236836AbiE3N2F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 09:28:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236837AbiE3N1F (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 09:27:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DBE6880DC;
        Mon, 30 May 2022 06:25:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AE2AF60EDE;
        Mon, 30 May 2022 13:25:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AF20C36AEA;
        Mon, 30 May 2022 13:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917140;
        bh=MBi8JzpAoUKy5cp3Ar4hTl0Sf7G2CWS3MZih0JaaO5M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s89wRGC2mjAdvcSacbkDpxkTTWfO1UzBBoWBhjaOHpnvpJBaoI138TeCqu2/S6Lmw
         m0vEs6QcFhrBuIfptMGDEDAwlZ7eV1GKA939NmwJy5ujuPg4Q5Uc75RCSw4bBGYzV0
         2RdwjOYKll6UU7NYHAwduRZZ+sl02Q4/CorjuX58srt2ltN+UiWqsKTAWLopU3gsCb
         5fKm8xabdP2OuBQKjupcb4KuMJs+qRX7LXWdaSW5Nu5fG2u7jcp1qCPqnMNARZnBBz
         PbH8jlqobPG01+UYTCI1yKTntwM8PrNJLEazfu+dDMBZZmVn0f6KaaeKgqEsxe7TfJ
         wHE9eCFhp/JJA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Biju Das <biju.das.jz@bp.renesas.com>,
        Vinod Koul <vkoul@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 031/159] spi: spi-rspi: Remove setting {src,dst}_{addr,addr_width} based on DMA direction
Date:   Mon, 30 May 2022 09:22:16 -0400
Message-Id: <20220530132425.1929512-31-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530132425.1929512-1-sashal@kernel.org>
References: <20220530132425.1929512-1-sashal@kernel.org>
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
index bd5708d7e5a1..7a014eeec2d0 100644
--- a/drivers/spi/spi-rspi.c
+++ b/drivers/spi/spi-rspi.c
@@ -1108,14 +1108,11 @@ static struct dma_chan *rspi_request_dma_chan(struct device *dev,
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
@@ -1146,12 +1143,12 @@ static int rspi_request_dma(struct device *dev, struct spi_controller *ctlr,
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

