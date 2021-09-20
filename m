Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B229411A9A
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 18:49:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243415AbhITQus (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 12:50:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:38940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244081AbhITQuB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 12:50:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 719F961245;
        Mon, 20 Sep 2021 16:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632156510;
        bh=QM53qf0i/7e0dwga1vWh5MnbgvfUlKtIQfgN/VKBaBU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YcaY6VTnVmwgfVtC53MOLgozW7RJIOLOfdVpG7yusdcQzXd1Wd93xRjt/3Ws3Pzhq
         3RpmYtpAgLsaEe/VuWU225dLODV2Hq8NyjRTrYveU4L5MPiL19++kcQ6Pm4lgRM/8Y
         vtZNWz2yS4e4zP1oHy5LjY6XjKxNS+Zh30ZFahH4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonas Jensen <jonas.jensen@gmail.com>,
        Vinod Koul <vkoul@kernel.org>,
        Peter Ujfalusi <peter.ujfalusi@gmail.com>,
        Tony Lindgren <tony@atomide.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 061/133] mmc: moxart: Fix issue with uninitialized dma_slave_config
Date:   Mon, 20 Sep 2021 18:42:19 +0200
Message-Id: <20210920163914.647749159@linuxfoundation.org>
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

[ Upstream commit ee5165354d498e5bceb0b386e480ac84c5f8c28c ]

Depending on the DMA driver being used, the struct dma_slave_config may
need to be initialized to zero for the unused data.

For example, we have three DMA drivers using src_port_window_size and
dst_port_window_size. If these are left uninitialized, it can cause DMA
failures.

For moxart, this is probably not currently an issue but is still good to
fix though.

Fixes: 1b66e94e6b99 ("mmc: moxart: Add MOXA ART SD/MMC driver")
Cc: Jonas Jensen <jonas.jensen@gmail.com>
Cc: Vinod Koul <vkoul@kernel.org>
Cc: Peter Ujfalusi <peter.ujfalusi@gmail.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Link: https://lore.kernel.org/r/20210810081644.19353-3-tony@atomide.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/moxart-mmc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mmc/host/moxart-mmc.c b/drivers/mmc/host/moxart-mmc.c
index bbad309679cf..41a5493cb68d 100644
--- a/drivers/mmc/host/moxart-mmc.c
+++ b/drivers/mmc/host/moxart-mmc.c
@@ -633,6 +633,7 @@ static int moxart_probe(struct platform_device *pdev)
 			 host->dma_chan_tx, host->dma_chan_rx);
 		host->have_dma = true;
 
+		memset(&cfg, 0, sizeof(cfg));
 		cfg.src_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
 		cfg.dst_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
 
-- 
2.30.2



