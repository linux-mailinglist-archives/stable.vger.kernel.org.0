Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9CF42DEFB3
	for <lists+stable@lfdr.de>; Sat, 19 Dec 2020 14:08:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727408AbgLSNHR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Dec 2020 08:07:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:45308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727754AbgLSM6j (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 19 Dec 2020 07:58:39 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fugang Duan <fugang.duan@nxp.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.9 18/49] net: stmmac: overwrite the dma_cap.addr64 according to HW design
Date:   Sat, 19 Dec 2020 13:58:22 +0100
Message-Id: <20201219125345.573322209@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201219125344.671832095@linuxfoundation.org>
References: <20201219125344.671832095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fugang Duan <fugang.duan@nxp.com>

[ Upstream commit f119cc9818eb33b66e977ad3af75aef6500bbdc3 ]

The current IP register MAC_HW_Feature1[ADDR64] only defines
32/40/64 bit width, but some SOCs support others like i.MX8MP
support 34 bits but it maps to 40 bits width in MAC_HW_Feature1[ADDR64].
So overwrite dma_cap.addr64 according to HW real design.

Fixes: 94abdad6974a ("net: ethernet: dwmac: add ethernet glue logic for NXP imx8 chip")
Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c   |    9 +--------
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |    8 ++++++++
 include/linux/stmmac.h                            |    1 +
 3 files changed, 10 insertions(+), 8 deletions(-)

--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c
@@ -247,13 +247,7 @@ static int imx_dwmac_probe(struct platfo
 		goto err_parse_dt;
 	}
 
-	ret = dma_set_mask_and_coherent(&pdev->dev,
-					DMA_BIT_MASK(dwmac->ops->addr_width));
-	if (ret) {
-		dev_err(&pdev->dev, "DMA mask set failed\n");
-		goto err_dma_mask;
-	}
-
+	plat_dat->addr64 = dwmac->ops->addr_width;
 	plat_dat->init = imx_dwmac_init;
 	plat_dat->exit = imx_dwmac_exit;
 	plat_dat->fix_mac_speed = imx_dwmac_fix_speed;
@@ -273,7 +267,6 @@ static int imx_dwmac_probe(struct platfo
 err_dwmac_init:
 err_drv_probe:
 	imx_dwmac_exit(pdev, plat_dat->bsp_priv);
-err_dma_mask:
 err_parse_dt:
 err_match_data:
 	stmmac_remove_config_dt(pdev, plat_dat);
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4842,6 +4842,14 @@ int stmmac_dvr_probe(struct device *devi
 		dev_info(priv->device, "SPH feature enabled\n");
 	}
 
+	/* The current IP register MAC_HW_Feature1[ADDR64] only define
+	 * 32/40/64 bit width, but some SOC support others like i.MX8MP
+	 * support 34 bits but it map to 40 bits width in MAC_HW_Feature1[ADDR64].
+	 * So overwrite dma_cap.addr64 according to HW real design.
+	 */
+	if (priv->plat->addr64)
+		priv->dma_cap.addr64 = priv->plat->addr64;
+
 	if (priv->dma_cap.addr64) {
 		ret = dma_set_mask_and_coherent(device,
 				DMA_BIT_MASK(priv->dma_cap.addr64));
--- a/include/linux/stmmac.h
+++ b/include/linux/stmmac.h
@@ -170,6 +170,7 @@ struct plat_stmmacenet_data {
 	int unicast_filter_entries;
 	int tx_fifo_size;
 	int rx_fifo_size;
+	u32 addr64;
 	u32 rx_queues_to_use;
 	u32 tx_queues_to_use;
 	u8 rx_sched_algorithm;


