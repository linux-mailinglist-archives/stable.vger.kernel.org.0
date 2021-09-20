Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD3CE411A98
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 18:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240419AbhITQuq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 12:50:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:38900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244043AbhITQt4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 12:49:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 42FC76126A;
        Mon, 20 Sep 2021 16:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632156508;
        bh=zBOa4a2NLtFvjXQzzYMCfKFizliRUmmgMZgOtvlFwvg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wawWn2lLyLCFYkeRqKTC00aFll6ky8+7SkJAkKgtjmQ87v2p2Gj6cr7MX2z656nDV
         k/ukurOjTDMgi1WEwnnP/289eVf6PFHy9VIBrRoYtSDPb2iMAcazw1q9R5fXEQjM7L
         b7rGY/fq/bTkjybFKKSqVzWbe/MPGlQiOREZ84UA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shawn Lin <shawn.lin@rock-chips.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Peter Ujfalusi <peter.ujfalusi@gmail.com>,
        Vinod Koul <vkoul@kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 060/133] mmc: dw_mmc: Fix issue with uninitialized dma_slave_config
Date:   Mon, 20 Sep 2021 18:42:18 +0200
Message-Id: <20210920163914.613873335@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163912.603434365@linuxfoundation.org>
References: <20210920163912.603434365@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit c3ff0189d3bc9c03845fe37472c140f0fefd0c79 ]

Depending on the DMA driver being used, the struct dma_slave_config may
need to be initialized to zero for the unused data.

For example, we have three DMA drivers using src_port_window_size and
dst_port_window_size. If these are left uninitialized, it can cause DMA
failures.

For dw_mmc, this is probably not currently an issue but is still good to
fix though.

Fixes: 3fc7eaef44db ("mmc: dw_mmc: Add external dma interface support")
Cc: Shawn Lin <shawn.lin@rock-chips.com>
Cc: Jaehoon Chung <jh80.chung@samsung.com>
Cc: Peter Ujfalusi <peter.ujfalusi@gmail.com>
Cc: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Link: https://lore.kernel.org/r/20210810081644.19353-2-tony@atomide.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/dw_mmc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
index 9eff3b41a086..03ac8d599763 100644
--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -701,6 +701,7 @@ static int dw_mci_edmac_start_dma(struct dw_mci *host,
 	int ret = 0;
 
 	/* Set external dma config: burst size, burst width */
+	memset(&cfg, 0, sizeof(cfg));
 	cfg.dst_addr = host->phy_regs + fifo_offset;
 	cfg.src_addr = cfg.dst_addr;
 	cfg.dst_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
-- 
2.30.2



