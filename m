Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B2DB408E48
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:34:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240856AbhIMNck (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:32:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:58356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241357AbhIMNa4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:30:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5F6C461288;
        Mon, 13 Sep 2021 13:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539502;
        bh=yZD8SegFW9VZXM1gnQs7nsGAbgf53JK5MyEPkIN/eAk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gtWlKgThWBRcnlgzmddGpWh1OVNjZYXqFGyFNUov4IurYor8PIvYvzJ6AwYm5FDmr
         PAsGmzP5zm2Hwv/qfh64hOMgDX06W6Ia8yoINLHIOpZ38g8o+s4toerCmsORSl4Wq9
         AcfL7kcOfevwrk9BdqDARUH2VXBu9GxpbsBtTF2A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sanchayan Maity <maitysanchayan@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Peter Ujfalusi <peter.ujfalusi@gmail.com>,
        Vinod Koul <vkoul@kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 049/236] spi: spi-fsl-dspi: Fix issue with uninitialized dma_slave_config
Date:   Mon, 13 Sep 2021 15:12:34 +0200
Message-Id: <20210913131102.027523217@linuxfoundation.org>
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

[ Upstream commit 209ab223ad5b18e437289235e3bde12593b94ac4 ]

Depending on the DMA driver being used, the struct dma_slave_config may
need to be initialized to zero for the unused data.

For example, we have three DMA drivers using src_port_window_size and
dst_port_window_size. If these are left uninitialized, it can cause DMA
failures.

For spi-fsl-dspi, this is probably not currently an issue but is still
good to fix though.

Fixes: 90ba37033cb9 ("spi: spi-fsl-dspi: Add DMA support for Vybrid")
Cc: Sanchayan Maity <maitysanchayan@gmail.com>
Cc: Vladimir Oltean <vladimir.oltean@nxp.com>
Cc: Peter Ujfalusi <peter.ujfalusi@gmail.com>
Cc: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Acked-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://lore.kernel.org/r/20210810081727.19491-1-tony@atomide.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-fsl-dspi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spi-fsl-dspi.c b/drivers/spi/spi-fsl-dspi.c
index fb45e6af6638..fd004c9db9dc 100644
--- a/drivers/spi/spi-fsl-dspi.c
+++ b/drivers/spi/spi-fsl-dspi.c
@@ -530,6 +530,7 @@ static int dspi_request_dma(struct fsl_dspi *dspi, phys_addr_t phy_addr)
 		goto err_rx_dma_buf;
 	}
 
+	memset(&cfg, 0, sizeof(cfg));
 	cfg.src_addr = phy_addr + SPI_POPR;
 	cfg.dst_addr = phy_addr + SPI_PUSHR;
 	cfg.src_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
-- 
2.30.2



