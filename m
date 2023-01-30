Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01F9C68126D
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:21:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237650AbjA3OVF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:21:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237644AbjA3OUu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:20:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7700912878
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:19:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B0326108C
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:18:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E306C433D2;
        Mon, 30 Jan 2023 14:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675088331;
        bh=Zj0lnm3OL0VumF5Vhr/lc+VXp5n79EcDQ42fFkkOMOs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TBurd8peelbz0OOZVCm66jAnEBmHFSJ1awTq5wMtGkMNZGlSakwyHrNFZsxpA9GLf
         SprqzaR/JtGgy5/EJ1uQtYeSaklHE4mPy4G7MWxket2YqcwwNcMl5Ppc2LKAL4G3/I
         t6UupM4imaeEuhjxOpGXYLikAEXMMnEfzzTHP87s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Biju Das <biju.das.jz@bp.renesas.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 188/204] ravb: Rename "no_ptp_cfg_active" and "ptp_cfg_active" variables
Date:   Mon, 30 Jan 2023 14:52:33 +0100
Message-Id: <20230130134324.810759176@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Biju Das <biju.das.jz@bp.renesas.com>

[ Upstream commit 2b061b545cd0d393585da2909044b15db1ac426f ]

Rename the variable "no_ptp_cfg_active" with "gptp" and
"ptp_cfg_active" with "ccc_gac" to match the HW features.

There is no functional change.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Suggested-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: c2b6cdee1d13 ("net: ravb: Fix lack of register setting after system resumed for Gen3")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/renesas/ravb.h      |  4 ++--
 drivers/net/ethernet/renesas/ravb_main.c | 26 ++++++++++++------------
 2 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
index 47c5377e4f42..a475f54a6b63 100644
--- a/drivers/net/ethernet/renesas/ravb.h
+++ b/drivers/net/ethernet/renesas/ravb.h
@@ -1000,8 +1000,8 @@ struct ravb_hw_info {
 	unsigned internal_delay:1;	/* AVB-DMAC has internal delays */
 	unsigned tx_counters:1;		/* E-MAC has TX counters */
 	unsigned multi_irqs:1;		/* AVB-DMAC and E-MAC has multiple irqs */
-	unsigned no_ptp_cfg_active:1;	/* AVB-DMAC does not support gPTP active in config mode */
-	unsigned ptp_cfg_active:1;	/* AVB-DMAC has gPTP support active in config mode */
+	unsigned gptp:1;		/* AVB-DMAC has gPTP support */
+	unsigned ccc_gac:1;		/* AVB-DMAC has gPTP support active in config mode */
 };
 
 struct ravb_private {
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index c89bcdd15f16..dcb18f1e6db0 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -1275,7 +1275,7 @@ static int ravb_set_ringparam(struct net_device *ndev,
 	if (netif_running(ndev)) {
 		netif_device_detach(ndev);
 		/* Stop PTP Clock driver */
-		if (info->no_ptp_cfg_active)
+		if (info->gptp)
 			ravb_ptp_stop(ndev);
 		/* Wait for DMA stopping */
 		error = ravb_stop_dma(ndev);
@@ -1307,7 +1307,7 @@ static int ravb_set_ringparam(struct net_device *ndev,
 		ravb_emac_init(ndev);
 
 		/* Initialise PTP Clock driver */
-		if (info->no_ptp_cfg_active)
+		if (info->gptp)
 			ravb_ptp_init(ndev, priv->pdev);
 
 		netif_device_attach(ndev);
@@ -1447,7 +1447,7 @@ static int ravb_open(struct net_device *ndev)
 	ravb_emac_init(ndev);
 
 	/* Initialise PTP Clock driver */
-	if (info->no_ptp_cfg_active)
+	if (info->gptp)
 		ravb_ptp_init(ndev, priv->pdev);
 
 	netif_tx_start_all_queues(ndev);
@@ -1461,7 +1461,7 @@ static int ravb_open(struct net_device *ndev)
 
 out_ptp_stop:
 	/* Stop PTP Clock driver */
-	if (info->no_ptp_cfg_active)
+	if (info->gptp)
 		ravb_ptp_stop(ndev);
 out_free_irq_nc_tx:
 	if (!info->multi_irqs)
@@ -1509,7 +1509,7 @@ static void ravb_tx_timeout_work(struct work_struct *work)
 	netif_tx_stop_all_queues(ndev);
 
 	/* Stop PTP Clock driver */
-	if (info->no_ptp_cfg_active)
+	if (info->gptp)
 		ravb_ptp_stop(ndev);
 
 	/* Wait for DMA stopping */
@@ -1544,7 +1544,7 @@ static void ravb_tx_timeout_work(struct work_struct *work)
 
 out:
 	/* Initialise PTP Clock driver */
-	if (info->no_ptp_cfg_active)
+	if (info->gptp)
 		ravb_ptp_init(ndev, priv->pdev);
 
 	netif_tx_start_all_queues(ndev);
@@ -1753,7 +1753,7 @@ static int ravb_close(struct net_device *ndev)
 	ravb_write(ndev, 0, TIC);
 
 	/* Stop PTP Clock driver */
-	if (info->no_ptp_cfg_active)
+	if (info->gptp)
 		ravb_ptp_stop(ndev);
 
 	/* Set the config mode to stop the AVB-DMAC's processes */
@@ -2019,7 +2019,7 @@ static const struct ravb_hw_info ravb_gen3_hw_info = {
 	.internal_delay = 1,
 	.tx_counters = 1,
 	.multi_irqs = 1,
-	.ptp_cfg_active = 1,
+	.ccc_gac = 1,
 };
 
 static const struct ravb_hw_info ravb_gen2_hw_info = {
@@ -2038,7 +2038,7 @@ static const struct ravb_hw_info ravb_gen2_hw_info = {
 	.stats_len = ARRAY_SIZE(ravb_gstrings_stats),
 	.max_rx_len = RX_BUF_SZ + RAVB_ALIGN - 1,
 	.aligned_tx = 1,
-	.no_ptp_cfg_active = 1,
+	.gptp = 1,
 };
 
 static const struct of_device_id ravb_match_table[] = {
@@ -2080,7 +2080,7 @@ static void ravb_set_config_mode(struct net_device *ndev)
 	struct ravb_private *priv = netdev_priv(ndev);
 	const struct ravb_hw_info *info = priv->info;
 
-	if (info->no_ptp_cfg_active) {
+	if (info->gptp) {
 		ravb_modify(ndev, CCC, CCC_OPC, CCC_OPC_CONFIG);
 		/* Set CSEL value */
 		ravb_modify(ndev, CCC, CCC_CSEL, CCC_CSEL_HPB);
@@ -2301,7 +2301,7 @@ static int ravb_probe(struct platform_device *pdev)
 	INIT_LIST_HEAD(&priv->ts_skb_list);
 
 	/* Initialise PTP Clock driver */
-	if (info->ptp_cfg_active)
+	if (info->ccc_gac)
 		ravb_ptp_init(ndev, pdev);
 
 	/* Debug message level */
@@ -2349,7 +2349,7 @@ static int ravb_probe(struct platform_device *pdev)
 			  priv->desc_bat_dma);
 
 	/* Stop PTP Clock driver */
-	if (info->ptp_cfg_active)
+	if (info->ccc_gac)
 		ravb_ptp_stop(ndev);
 out_disable_refclk:
 	clk_disable_unprepare(priv->refclk);
@@ -2369,7 +2369,7 @@ static int ravb_remove(struct platform_device *pdev)
 	const struct ravb_hw_info *info = priv->info;
 
 	/* Stop PTP Clock driver */
-	if (info->ptp_cfg_active)
+	if (info->ccc_gac)
 		ravb_ptp_stop(ndev);
 
 	clk_disable_unprepare(priv->refclk);
-- 
2.39.0



