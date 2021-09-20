Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 676D8411D07
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:14:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346053AbhITRPg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:15:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:40008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344742AbhITRNs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:13:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 20D48619EE;
        Mon, 20 Sep 2021 16:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157083;
        bh=bsH36aUAWjs1dpaT5X/LPIv0juds1Qn0+Ft9B2n5BeQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tC49gG2BwaQy+Z6vaqsspIIHHqxec81HK3B4kfzKEwXFkCAwZ8p8aY8cBWkFIoWCM
         scZgxOP+LpXC+aXNTWXgaIccaAh86VZ2QulC30MenLXPxI0tX6e/SPMz7Ke0c/0RjG
         E6mQ8AMiJmBAYP+ZrEZkp2hA54la7XDnKea/mBKg=
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
Subject: [PATCH 4.14 046/217] spi: spi-fsl-dspi: Fix issue with uninitialized dma_slave_config
Date:   Mon, 20 Sep 2021 18:41:07 +0200
Message-Id: <20210920163926.183478250@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163924.591371269@linuxfoundation.org>
References: <20210920163924.591371269@linuxfoundation.org>
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
index ed114f00a6d1..59f18e344bfb 100644
--- a/drivers/spi/spi-fsl-dspi.c
+++ b/drivers/spi/spi-fsl-dspi.c
@@ -394,6 +394,7 @@ static int dspi_request_dma(struct fsl_dspi *dspi, phys_addr_t phy_addr)
 		goto err_rx_dma_buf;
 	}
 
+	memset(&cfg, 0, sizeof(cfg));
 	cfg.src_addr = phy_addr + SPI_POPR;
 	cfg.dst_addr = phy_addr + SPI_PUSHR;
 	cfg.src_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
-- 
2.30.2



