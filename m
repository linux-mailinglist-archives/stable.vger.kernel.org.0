Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EEE4408E4B
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236206AbhIMNcp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:32:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:58362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242065AbhIMNa4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:30:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F317B610CF;
        Mon, 13 Sep 2021 13:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539505;
        bh=zI6ZAt0/5MVMLtxd2ZnC1lYICx39p9MpuBKpK/u7SDk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QStFa7A4mHY5dxOcXaGd6jFzJIp/X22Z83Sb4TS8mgOw+F6iXuBjQtlLINB/vkc/I
         xpMqTtAqnHb5ZBGWFuDGt5PYYNBFRCLNx5vU0dDhC5M8F6nZ5IceYLdCsypZvs2zJP
         cc5BHU9p6OZrM6rXzfxdzqNOrPfwQqdLihOCK0K0=
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
Subject: [PATCH 5.10 050/236] spi: spi-pic32: Fix issue with uninitialized dma_slave_config
Date:   Mon, 13 Sep 2021 15:12:35 +0200
Message-Id: <20210913131102.059265865@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131100.316353015@linuxfoundation.org>
References: <20210913131100.316353015@linuxfoundation.org>
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
index 104bde153efd..5eb7b61bbb4d 100644
--- a/drivers/spi/spi-pic32.c
+++ b/drivers/spi/spi-pic32.c
@@ -361,6 +361,7 @@ static int pic32_spi_dma_config(struct pic32_spi *pic32s, u32 dma_width)
 	struct dma_slave_config cfg;
 	int ret;
 
+	memset(&cfg, 0, sizeof(cfg));
 	cfg.device_fc = true;
 	cfg.src_addr = pic32s->dma_base + buf_offset;
 	cfg.dst_addr = pic32s->dma_base + buf_offset;
-- 
2.30.2



