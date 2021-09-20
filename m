Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DADCA411B8C
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 18:59:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233634AbhITRAZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:00:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:46722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344052AbhITQ5x (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 12:57:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 30ABC613A5;
        Mon, 20 Sep 2021 16:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632156706;
        bh=W8EP0npO/PB/QkoBKSMmMWj/J4zuxfY8jfMx9HjwAAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RGW2xAAI6xXPF5PzO0R4q8EIuZdUQoMcn++zDOiedQPyhDZUaoGmo5JLvIlXONWcL
         nugnvEMvit1IWP8mijHXj72O5dLJTDxQTGF+CwMGgXI+kSVEP0z7/dHlSy9w9Js0ep
         ddji4xrogOfnNMtSwxMZHIQuSMa0GtsZL06X2sjI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Purna Chandra Mandal <purna.mandal@microchip.com>,
        Peter Ujfalusi <peter.ujfalusi@gmail.com>,
        Vinod Koul <vkoul@kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 049/175] spi: spi-pic32: Fix issue with uninitialized dma_slave_config
Date:   Mon, 20 Sep 2021 18:41:38 +0200
Message-Id: <20210920163919.659583453@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163918.068823680@linuxfoundation.org>
References: <20210920163918.068823680@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit 976c1de1de147bb7f4e0d87482f375221c05aeaf ]

Depending on the DMA driver being used, the struct dma_slave_config may
need to be initialized to zero for the unused data.

For example, we have three DMA drivers using src_port_window_size and
dst_port_window_size. If these are left uninitialized, it can cause DMA
failures.

For spi-pic32, this is probably not currently an issue but is still good to
fix though.

Fixes: 1bcb9f8ceb67 ("spi: spi-pic32: Add PIC32 SPI master driver")
Cc: Purna Chandra Mandal <purna.mandal@microchip.com>
Cc: Peter Ujfalusi <peter.ujfalusi@gmail.com>
Cc: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Link: https://lore.kernel.org/r/20210810081727.19491-2-tony@atomide.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-pic32.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spi-pic32.c b/drivers/spi/spi-pic32.c
index 9a97ad973c41..021dddf484e5 100644
--- a/drivers/spi/spi-pic32.c
+++ b/drivers/spi/spi-pic32.c
@@ -369,6 +369,7 @@ static int pic32_spi_dma_config(struct pic32_spi *pic32s, u32 dma_width)
 	struct dma_slave_config cfg;
 	int ret;
 
+	memset(&cfg, 0, sizeof(cfg));
 	cfg.device_fc = true;
 	cfg.src_addr = pic32s->dma_base + buf_offset;
 	cfg.dst_addr = pic32s->dma_base + buf_offset;
-- 
2.30.2



