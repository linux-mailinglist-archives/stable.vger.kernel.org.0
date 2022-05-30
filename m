Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF1945381EC
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 16:33:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241266AbiE3OVZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 10:21:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241501AbiE3ORi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 10:17:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A1A1532DD;
        Mon, 30 May 2022 06:47:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 349D3B80D89;
        Mon, 30 May 2022 13:47:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ECB5C36AFD;
        Mon, 30 May 2022 13:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653918450;
        bh=TBUDZ+myfFdQp2Q9crrRnwOfAHGZg4s6dWhVQ8ghWYA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KwAZdaNOnYyjfrEsAJm+2oLWAttVA9OWP4m6Mwg9p6QA9pOaN++67uBue4/PWk0t4
         baaNz+63yQZYUn5qog6Kp0m5fnhBrTBYR/R67t37G7Neh4IY/Yni4NVA67AQeK2MeC
         CdU2wfMZbELBLVnd19gzPj5LMTA/tIN3CjF8lu39DhxX+WV5mkef2wlka1uh+YKbCd
         fqZEb3gq6md35ae6aElI6AGBvID1cF2nKi6uxK6Z6e2b4Sf3MlGW0fMAfGOXfJkb6S
         iXpHOD7Ec3naZ2AWbA3bbsiK4398fvtGJ5hWxpY/x0XnVSM20vwDCzxN6ZpLOrPrHQ
         fpwi0sSdoKcMA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Biju Das <biju.das.jz@bp.renesas.com>,
        Vinod Koul <vkoul@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 11/55] spi: spi-rspi: Remove setting {src,dst}_{addr,addr_width} based on DMA direction
Date:   Mon, 30 May 2022 09:46:17 -0400
Message-Id: <20220530134701.1935933-11-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530134701.1935933-1-sashal@kernel.org>
References: <20220530134701.1935933-1-sashal@kernel.org>
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
index 7222c7689c3c..0524741d73b9 100644
--- a/drivers/spi/spi-rspi.c
+++ b/drivers/spi/spi-rspi.c
@@ -1044,14 +1044,11 @@ static struct dma_chan *rspi_request_dma_chan(struct device *dev,
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
@@ -1082,12 +1079,12 @@ static int rspi_request_dma(struct device *dev, struct spi_controller *ctlr,
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

