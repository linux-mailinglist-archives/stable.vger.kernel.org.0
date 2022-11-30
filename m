Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFB4B63DFC7
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:50:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231415AbiK3Su2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:50:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231452AbiK3SuZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:50:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5A4155C89
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:50:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F22961D70
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:50:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A7D1C433C1;
        Wed, 30 Nov 2022 18:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669834223;
        bh=v3qPkOMglHPrRRzDMVGJiot7/RVnBh3S11lvZll3PwM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ph6JvTtqegTVYPwlP0hUMFYcNRF+vbrA7RlGACrsQjwLPcAKeNzPufxd/AEg71NAb
         /kNciQH4wEtFjyzuj82o7JVzkqkAJtkaJeTqgRnz7zfScMcfAvhAgvXffTi9ls7lu1
         auZTqnMq7N8D1ceij9lGIH+cC4hDB/0LWZl7NhEo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Daniel Golle <daniel@makrotopia.org>,
        Bo Jiao <Bo.Jiao@mediatek.com>,
        Sujuan Chen <sujuan.chen@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 137/289] net: ethernet: mtk_eth_soc: move ppe table hash offset to mtk_soc_data structure
Date:   Wed, 30 Nov 2022 19:22:02 +0100
Message-Id: <20221130180547.244489504@linuxfoundation.org>
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

[ Upstream commit ba2fc48c5e1e9e1934939f0d12ff8b985dcc6e5d ]

This is a preliminary patch to introduce mt7986 hw packet engine.

Tested-by: Daniel Golle <daniel@makrotopia.org>
Co-developed-by: Bo Jiao <Bo.Jiao@mediatek.com>
Signed-off-by: Bo Jiao <Bo.Jiao@mediatek.com>
Co-developed-by: Sujuan Chen <sujuan.chen@mediatek.com>
Signed-off-by: Sujuan Chen <sujuan.chen@mediatek.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 8110437e5961 ("net: ethernet: mtk_eth_soc: fix resource leak in error path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c |  4 ++++
 drivers/net/ethernet/mediatek/mtk_eth_soc.h |  2 ++
 drivers/net/ethernet/mediatek/mtk_ppe.c     | 24 +++++++++++++++------
 drivers/net/ethernet/mediatek/mtk_ppe.h     |  2 +-
 4 files changed, 25 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 83c636d44142..3db24ddd1261 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -4210,6 +4210,7 @@ static const struct mtk_soc_data mt7621_data = {
 	.required_clks = MT7621_CLKS_BITMAP,
 	.required_pctl = false,
 	.offload_version = 2,
+	.hash_offset = 2,
 	.txrx = {
 		.txd_size = sizeof(struct mtk_tx_dma),
 		.rxd_size = sizeof(struct mtk_rx_dma),
@@ -4228,6 +4229,7 @@ static const struct mtk_soc_data mt7622_data = {
 	.required_clks = MT7622_CLKS_BITMAP,
 	.required_pctl = false,
 	.offload_version = 2,
+	.hash_offset = 2,
 	.txrx = {
 		.txd_size = sizeof(struct mtk_tx_dma),
 		.rxd_size = sizeof(struct mtk_rx_dma),
@@ -4245,6 +4247,7 @@ static const struct mtk_soc_data mt7623_data = {
 	.required_clks = MT7623_CLKS_BITMAP,
 	.required_pctl = true,
 	.offload_version = 2,
+	.hash_offset = 2,
 	.txrx = {
 		.txd_size = sizeof(struct mtk_tx_dma),
 		.rxd_size = sizeof(struct mtk_rx_dma),
@@ -4278,6 +4281,7 @@ static const struct mtk_soc_data mt7986_data = {
 	.caps = MT7986_CAPS,
 	.required_clks = MT7986_CLKS_BITMAP,
 	.required_pctl = false,
+	.hash_offset = 4,
 	.txrx = {
 		.txd_size = sizeof(struct mtk_tx_dma_v2),
 		.rxd_size = sizeof(struct mtk_rx_dma_v2),
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index 511752729f5c..26ed1c8b77c3 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -969,6 +969,7 @@ struct mtk_reg_map {
  *				the target SoC
  * @required_pctl		A bool value to show whether the SoC requires
  *				the extra setup for those pins used by GMAC.
+ * @hash_offset			Flow table hash offset.
  * @txd_size			Tx DMA descriptor size.
  * @rxd_size			Rx DMA descriptor size.
  * @rx_irq_done_mask		Rx irq done register mask.
@@ -983,6 +984,7 @@ struct mtk_soc_data {
 	u32		required_clks;
 	bool		required_pctl;
 	u8		offload_version;
+	u8		hash_offset;
 	netdev_features_t hw_features;
 	struct {
 		u32	txd_size;
diff --git a/drivers/net/ethernet/mediatek/mtk_ppe.c b/drivers/net/ethernet/mediatek/mtk_ppe.c
index 148ea636ef97..6ecac461fd76 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe.c
@@ -88,7 +88,7 @@ static void mtk_ppe_cache_enable(struct mtk_ppe *ppe, bool enable)
 		enable * MTK_PPE_CACHE_CTL_EN);
 }
 
-static u32 mtk_ppe_hash_entry(struct mtk_foe_entry *e)
+static u32 mtk_ppe_hash_entry(struct mtk_eth *eth, struct mtk_foe_entry *e)
 {
 	u32 hv1, hv2, hv3;
 	u32 hash;
@@ -122,7 +122,7 @@ static u32 mtk_ppe_hash_entry(struct mtk_foe_entry *e)
 	hash = (hash >> 24) | ((hash & 0xffffff) << 8);
 	hash ^= hv1 ^ hv2 ^ hv3;
 	hash ^= hash >> 16;
-	hash <<= 1;
+	hash <<= (ffs(eth->soc->hash_offset) - 1);
 	hash &= MTK_PPE_ENTRIES - 1;
 
 	return hash;
@@ -540,15 +540,16 @@ mtk_foe_entry_commit_l2(struct mtk_ppe *ppe, struct mtk_flow_entry *entry)
 int mtk_foe_entry_commit(struct mtk_ppe *ppe, struct mtk_flow_entry *entry)
 {
 	int type = FIELD_GET(MTK_FOE_IB1_PACKET_TYPE, entry->data.ib1);
+	const struct mtk_soc_data *soc = ppe->eth->soc;
 	u32 hash;
 
 	if (type == MTK_PPE_PKT_TYPE_BRIDGE)
 		return mtk_foe_entry_commit_l2(ppe, entry);
 
-	hash = mtk_ppe_hash_entry(&entry->data);
+	hash = mtk_ppe_hash_entry(ppe->eth, &entry->data);
 	entry->hash = 0xffff;
 	spin_lock_bh(&ppe_lock);
-	hlist_add_head(&entry->list, &ppe->foe_flow[hash / 2]);
+	hlist_add_head(&entry->list, &ppe->foe_flow[hash / soc->hash_offset]);
 	spin_unlock_bh(&ppe_lock);
 
 	return 0;
@@ -558,6 +559,7 @@ static void
 mtk_foe_entry_commit_subflow(struct mtk_ppe *ppe, struct mtk_flow_entry *entry,
 			     u16 hash)
 {
+	const struct mtk_soc_data *soc = ppe->eth->soc;
 	struct mtk_flow_entry *flow_info;
 	struct mtk_foe_entry foe, *hwe;
 	struct mtk_foe_mac_info *l2;
@@ -572,7 +574,8 @@ mtk_foe_entry_commit_subflow(struct mtk_ppe *ppe, struct mtk_flow_entry *entry,
 	flow_info->l2_data.base_flow = entry;
 	flow_info->type = MTK_FLOW_TYPE_L2_SUBFLOW;
 	flow_info->hash = hash;
-	hlist_add_head(&flow_info->list, &ppe->foe_flow[hash / 2]);
+	hlist_add_head(&flow_info->list,
+		       &ppe->foe_flow[hash / soc->hash_offset]);
 	hlist_add_head(&flow_info->l2_data.list, &entry->l2_flows);
 
 	hwe = &ppe->foe_table[hash];
@@ -596,7 +599,8 @@ mtk_foe_entry_commit_subflow(struct mtk_ppe *ppe, struct mtk_flow_entry *entry,
 
 void __mtk_ppe_check_skb(struct mtk_ppe *ppe, struct sk_buff *skb, u16 hash)
 {
-	struct hlist_head *head = &ppe->foe_flow[hash / 2];
+	const struct mtk_soc_data *soc = ppe->eth->soc;
+	struct hlist_head *head = &ppe->foe_flow[hash / soc->hash_offset];
 	struct mtk_foe_entry *hwe = &ppe->foe_table[hash];
 	struct mtk_flow_entry *entry;
 	struct mtk_foe_bridge key = {};
@@ -680,9 +684,11 @@ int mtk_foe_entry_idle_time(struct mtk_ppe *ppe, struct mtk_flow_entry *entry)
 struct mtk_ppe *mtk_ppe_init(struct mtk_eth *eth, void __iomem *base,
 		 int version)
 {
+	const struct mtk_soc_data *soc = eth->soc;
 	struct device *dev = eth->dev;
 	struct mtk_foe_entry *foe;
 	struct mtk_ppe *ppe;
+	u32 foe_flow_size;
 
 	ppe = devm_kzalloc(dev, sizeof(*ppe), GFP_KERNEL);
 	if (!ppe)
@@ -705,6 +711,12 @@ struct mtk_ppe *mtk_ppe_init(struct mtk_eth *eth, void __iomem *base,
 
 	ppe->foe_table = foe;
 
+	foe_flow_size = (MTK_PPE_ENTRIES / soc->hash_offset) *
+			sizeof(*ppe->foe_flow);
+	ppe->foe_flow = devm_kzalloc(dev, foe_flow_size, GFP_KERNEL);
+	if (!ppe->foe_flow)
+		return NULL;
+
 	mtk_ppe_debugfs_init(ppe);
 
 	return ppe;
diff --git a/drivers/net/ethernet/mediatek/mtk_ppe.h b/drivers/net/ethernet/mediatek/mtk_ppe.h
index ceb7dfe281de..7a16503690f3 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe.h
+++ b/drivers/net/ethernet/mediatek/mtk_ppe.h
@@ -270,7 +270,7 @@ struct mtk_ppe {
 	dma_addr_t foe_phys;
 
 	u16 foe_check_time[MTK_PPE_ENTRIES];
-	struct hlist_head foe_flow[MTK_PPE_ENTRIES / 2];
+	struct hlist_head *foe_flow;
 
 	struct rhashtable l2_flows;
 
-- 
2.35.1



