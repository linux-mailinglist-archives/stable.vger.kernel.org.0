Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8E115A49D4
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232312AbiH2LaK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:30:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232611AbiH2L3Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:29:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D4017B285;
        Mon, 29 Aug 2022 04:17:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 94884611B3;
        Mon, 29 Aug 2022 11:17:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96D09C433C1;
        Mon, 29 Aug 2022 11:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771854;
        bh=wDuprk3n4tghTeDX1/zd+4mjM2RqdJsPsWxn4D6eU+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pzi+zLEWfHuUnTvWMqsrPVRyvCTL4joOdBdIH0xfi/zp7ZiK3JVBl92TER8TMAWeB
         o39lptsfy//CgPNr9++cVRxf85v5yNTzINaKUYCmfUA+ax6V0QU34mfJHbluBKbr9l
         GM80lqlq1XLqpqX8fPe0/YtSIwhM60zvtiTzzdu8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 085/158] net: ethernet: mtk_eth_soc: fix hw hash reporting for MTK_NETSYS_V2
Date:   Mon, 29 Aug 2022 12:58:55 +0200
Message-Id: <20220829105812.625880024@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105808.828227973@linuxfoundation.org>
References: <20220829105808.828227973@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 0cf731f9ebb5bf6f252055bebf4463a5c0bd490b ]

Properly report hw rx hash for mt7986 chipset accroding to the new dma
descriptor layout.

Fixes: 197c9e9b17b11 ("net: ethernet: mtk_eth_soc: introduce support for mt7986 chipset")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://lore.kernel.org/r/091394ea4e705fbb35f828011d98d0ba33808f69.1661257293.git.lorenzo@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 22 +++++++++++----------
 drivers/net/ethernet/mediatek/mtk_eth_soc.h |  5 +++++
 2 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 6beb3d4873a37..dcf0aac0aa65d 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -1513,10 +1513,19 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 		skb->dev = netdev;
 		skb_put(skb, pktlen);
 
-		if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2))
+		if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2)) {
+			hash = trxd.rxd5 & MTK_RXD5_FOE_ENTRY;
+			if (hash != MTK_RXD5_FOE_ENTRY)
+				skb_set_hash(skb, jhash_1word(hash, 0),
+					     PKT_HASH_TYPE_L4);
 			rxdcsum = &trxd.rxd3;
-		else
+		} else {
+			hash = trxd.rxd4 & MTK_RXD4_FOE_ENTRY;
+			if (hash != MTK_RXD4_FOE_ENTRY)
+				skb_set_hash(skb, jhash_1word(hash, 0),
+					     PKT_HASH_TYPE_L4);
 			rxdcsum = &trxd.rxd4;
+		}
 
 		if (*rxdcsum & eth->soc->txrx.rx_dma_l4_valid)
 			skb->ip_summed = CHECKSUM_UNNECESSARY;
@@ -1525,16 +1534,9 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 		skb->protocol = eth_type_trans(skb, netdev);
 		bytes += pktlen;
 
-		hash = trxd.rxd4 & MTK_RXD4_FOE_ENTRY;
-		if (hash != MTK_RXD4_FOE_ENTRY) {
-			hash = jhash_1word(hash, 0);
-			skb_set_hash(skb, hash, PKT_HASH_TYPE_L4);
-		}
-
 		reason = FIELD_GET(MTK_RXD4_PPE_CPU_REASON, trxd.rxd4);
 		if (reason == MTK_PPE_CPU_REASON_HIT_UNBIND_RATE_REACHED)
-			mtk_ppe_check_skb(eth->ppe, skb,
-					  trxd.rxd4 & MTK_RXD4_FOE_ENTRY);
+			mtk_ppe_check_skb(eth->ppe, skb, hash);
 
 		if (netdev->features & NETIF_F_HW_VLAN_CTAG_RX) {
 			if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2)) {
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index 0a632896451a4..98d6a6d047e32 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -307,6 +307,11 @@
 #define RX_DMA_L4_VALID_PDMA	BIT(30)		/* when PDMA is used */
 #define RX_DMA_SPECIAL_TAG	BIT(22)
 
+/* PDMA descriptor rxd5 */
+#define MTK_RXD5_FOE_ENTRY	GENMASK(14, 0)
+#define MTK_RXD5_PPE_CPU_REASON	GENMASK(22, 18)
+#define MTK_RXD5_SRC_PORT	GENMASK(29, 26)
+
 #define RX_DMA_GET_SPORT(x)	(((x) >> 19) & 0xf)
 #define RX_DMA_GET_SPORT_V2(x)	(((x) >> 26) & 0x7)
 
-- 
2.35.1



