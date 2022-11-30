Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 453C463DF98
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:48:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231358AbiK3Ss4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:48:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231417AbiK3Sso (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:48:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E770799F55
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:48:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6686861D89
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:48:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73361C433B5;
        Wed, 30 Nov 2022 18:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669834120;
        bh=pOjs84J4/OzkFaq56jzvhkDHt04VPcLgs9YN3OnZtD4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AgsHsPA7X2G8f2rLVQ2wN5oeXfpMXlt9ISo1RW1RbTn7QK6ytbntE+06YgIHMvSRT
         L6JNh0/4xCAbfjcCG1ce6IicoYUaBy9cndhTpuNJPtiPBsOpdiRLhLf1cbZhNt3WJm
         zsZ82lqPTtyBnSh81WvukWtSPyq/sNw0UHd60kEs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Daniel Golle <daniel@makrotopia.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 136/289] net: ethernet: mtk_eth_soc: move gdma_to_ppe and ppe_base definitions in mtk register map
Date:   Wed, 30 Nov 2022 19:22:01 +0100
Message-Id: <20221130180547.221529708@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 329bce5139cfb00dba40f038ec090572b81ff2a9 ]

This is a preliminary patch to introduce mt7986 hw packet engine.

Tested-by: Daniel Golle <daniel@makrotopia.org>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 8110437e5961 ("net: ethernet: mtk_eth_soc: fix resource leak in error path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 15 +++++++++++----
 drivers/net/ethernet/mediatek/mtk_eth_soc.h |  3 ++-
 drivers/net/ethernet/mediatek/mtk_ppe.h     |  2 --
 3 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 916b570bdbf4..83c636d44142 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -73,6 +73,8 @@ static const struct mtk_reg_map mtk_reg_map = {
 		.fq_blen	= 0x1b2c,
 	},
 	.gdm1_cnt		= 0x2400,
+	.gdma_to_ppe		= 0x4444,
+	.ppe_base		= 0x0c00,
 };
 
 static const struct mtk_reg_map mt7628_reg_map = {
@@ -126,6 +128,8 @@ static const struct mtk_reg_map mt7986_reg_map = {
 		.fq_blen	= 0x472c,
 	},
 	.gdm1_cnt		= 0x1c00,
+	.gdma_to_ppe		= 0x3333,
+	.ppe_base		= 0x2000,
 };
 
 /* strings used by ethtool */
@@ -2978,6 +2982,7 @@ static int mtk_open(struct net_device *dev)
 
 	/* we run 2 netdevs on the same dma ring so we only bring it up once */
 	if (!refcount_read(&eth->dma_refcnt)) {
+		const struct mtk_soc_data *soc = eth->soc;
 		u32 gdm_config = MTK_GDMA_TO_PDMA;
 
 		err = mtk_start_dma(eth);
@@ -2986,15 +2991,15 @@ static int mtk_open(struct net_device *dev)
 			return err;
 		}
 
-		if (eth->soc->offload_version && mtk_ppe_start(eth->ppe) == 0)
-			gdm_config = MTK_GDMA_TO_PPE;
+		if (soc->offload_version && mtk_ppe_start(eth->ppe) == 0)
+			gdm_config = soc->reg_map->gdma_to_ppe;
 
 		mtk_gdm_config(eth, gdm_config);
 
 		napi_enable(&eth->tx_napi);
 		napi_enable(&eth->rx_napi);
 		mtk_tx_irq_enable(eth, MTK_TX_DONE_INT);
-		mtk_rx_irq_enable(eth, eth->soc->txrx.rx_irq_done_mask);
+		mtk_rx_irq_enable(eth, soc->txrx.rx_irq_done_mask);
 		refcount_set(&eth->dma_refcnt, 1);
 	}
 	else
@@ -4104,7 +4109,9 @@ static int mtk_probe(struct platform_device *pdev)
 	}
 
 	if (eth->soc->offload_version) {
-		eth->ppe = mtk_ppe_init(eth, eth->base + MTK_ETH_PPE_BASE, 2);
+		u32 ppe_addr = eth->soc->reg_map->ppe_base;
+
+		eth->ppe = mtk_ppe_init(eth, eth->base + ppe_addr, 2);
 		if (!eth->ppe) {
 			err = -ENOMEM;
 			goto err_free_dev;
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index 0f9668a4079d..511752729f5c 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -105,7 +105,6 @@
 #define MTK_GDMA_TCS_EN		BIT(21)
 #define MTK_GDMA_UCS_EN		BIT(20)
 #define MTK_GDMA_TO_PDMA	0x0
-#define MTK_GDMA_TO_PPE		0x4444
 #define MTK_GDMA_DROP_ALL       0x7777
 
 /* Unicast Filter MAC Address Register - Low */
@@ -955,6 +954,8 @@ struct mtk_reg_map {
 		u32	fq_blen;	/* fq free page buffer length */
 	} qdma;
 	u32	gdm1_cnt;
+	u32	gdma_to_ppe;
+	u32	ppe_base;
 };
 
 /* struct mtk_eth_data -	This is the structure holding all differences
diff --git a/drivers/net/ethernet/mediatek/mtk_ppe.h b/drivers/net/ethernet/mediatek/mtk_ppe.h
index 69ffce04d630..ceb7dfe281de 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe.h
+++ b/drivers/net/ethernet/mediatek/mtk_ppe.h
@@ -8,8 +8,6 @@
 #include <linux/bitfield.h>
 #include <linux/rhashtable.h>
 
-#define MTK_ETH_PPE_BASE		0xc00
-
 #define MTK_PPE_ENTRIES_SHIFT		3
 #define MTK_PPE_ENTRIES			(1024 << MTK_PPE_ENTRIES_SHIFT)
 #define MTK_PPE_HASH_MASK		(MTK_PPE_ENTRIES - 1)
-- 
2.35.1



