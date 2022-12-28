Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A39ED657D9A
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:44:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233586AbiL1Po6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:44:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233574AbiL1Po5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:44:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D4361758A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:44:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 23635B81729
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:44:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90455C433EF;
        Wed, 28 Dec 2022 15:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242293;
        bh=EsTfxasj+Pu2bk7b5S5eiqqsttFKFKiSnWLfN7gh+7E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dqH9QH8hbiV6RSnbYm7NZfnrt+yc8OZj56K+0ZFrf1aoRSFIvHjCynUffleq180Ea
         qHPsbLywR+If6MEKnY9vENCbHz4PaEqmNYk3E+o/618WVIRoEXntGiShscPVmnb+Yc
         EgprXsIiHXBgVT6KZDbY9b3l3D+j2m2PcFT3VHyw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0351/1146] net: ethernet: mtk_eth_soc: do not overwrite mtu configuration running reset routine
Date:   Wed, 28 Dec 2022 15:31:30 +0100
Message-Id: <20221228144339.697892691@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

[ Upstream commit b677d6c7a695dad1b02d2e0e428c39b3b344f270 ]

Restore user configured MTU running mtk_hw_init() during tx timeout routine
since it will be overwritten after a hw reset.

Reported-by: Felix Fietkau <nbd@nbd.name>
Fixes: 9ea4d311509f ("net: ethernet: mediatek: add the whole ethernet reset into the reset process")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 53 +++++++++++++--------
 1 file changed, 34 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 1d36619c5ec9..1148e22001c0 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -3229,6 +3229,30 @@ static void mtk_dim_tx(struct work_struct *work)
 	dim->state = DIM_START_MEASURE;
 }
 
+static void mtk_set_mcr_max_rx(struct mtk_mac *mac, u32 val)
+{
+	struct mtk_eth *eth = mac->hw;
+	u32 mcr_cur, mcr_new;
+
+	if (MTK_HAS_CAPS(eth->soc->caps, MTK_SOC_MT7628))
+		return;
+
+	mcr_cur = mtk_r32(mac->hw, MTK_MAC_MCR(mac->id));
+	mcr_new = mcr_cur & ~MAC_MCR_MAX_RX_MASK;
+
+	if (val <= 1518)
+		mcr_new |= MAC_MCR_MAX_RX(MAC_MCR_MAX_RX_1518);
+	else if (val <= 1536)
+		mcr_new |= MAC_MCR_MAX_RX(MAC_MCR_MAX_RX_1536);
+	else if (val <= 1552)
+		mcr_new |= MAC_MCR_MAX_RX(MAC_MCR_MAX_RX_1552);
+	else
+		mcr_new |= MAC_MCR_MAX_RX(MAC_MCR_MAX_RX_2048);
+
+	if (mcr_new != mcr_cur)
+		mtk_w32(mac->hw, mcr_new, MTK_MAC_MCR(mac->id));
+}
+
 static int mtk_hw_init(struct mtk_eth *eth)
 {
 	u32 dma_mask = ETHSYS_DMA_AG_MAP_PDMA | ETHSYS_DMA_AG_MAP_QDMA |
@@ -3303,8 +3327,16 @@ static int mtk_hw_init(struct mtk_eth *eth)
 	 * up with the more appropriate value when mtk_mac_config call is being
 	 * invoked.
 	 */
-	for (i = 0; i < MTK_MAC_COUNT; i++)
+	for (i = 0; i < MTK_MAC_COUNT; i++) {
+		struct net_device *dev = eth->netdev[i];
+
 		mtk_w32(eth, MAC_MCR_FORCE_LINK_DOWN, MTK_MAC_MCR(i));
+		if (dev) {
+			struct mtk_mac *mac = netdev_priv(dev);
+
+			mtk_set_mcr_max_rx(mac, dev->mtu + MTK_RX_ETH_HLEN);
+		}
+	}
 
 	/* Indicates CDM to parse the MTK special tag from CPU
 	 * which also is working out for untag packets.
@@ -3420,7 +3452,6 @@ static int mtk_change_mtu(struct net_device *dev, int new_mtu)
 	int length = new_mtu + MTK_RX_ETH_HLEN;
 	struct mtk_mac *mac = netdev_priv(dev);
 	struct mtk_eth *eth = mac->hw;
-	u32 mcr_cur, mcr_new;
 
 	if (rcu_access_pointer(eth->prog) &&
 	    length > MTK_PP_MAX_BUF_SIZE) {
@@ -3428,23 +3459,7 @@ static int mtk_change_mtu(struct net_device *dev, int new_mtu)
 		return -EINVAL;
 	}
 
-	if (!MTK_HAS_CAPS(eth->soc->caps, MTK_SOC_MT7628)) {
-		mcr_cur = mtk_r32(mac->hw, MTK_MAC_MCR(mac->id));
-		mcr_new = mcr_cur & ~MAC_MCR_MAX_RX_MASK;
-
-		if (length <= 1518)
-			mcr_new |= MAC_MCR_MAX_RX(MAC_MCR_MAX_RX_1518);
-		else if (length <= 1536)
-			mcr_new |= MAC_MCR_MAX_RX(MAC_MCR_MAX_RX_1536);
-		else if (length <= 1552)
-			mcr_new |= MAC_MCR_MAX_RX(MAC_MCR_MAX_RX_1552);
-		else
-			mcr_new |= MAC_MCR_MAX_RX(MAC_MCR_MAX_RX_2048);
-
-		if (mcr_new != mcr_cur)
-			mtk_w32(mac->hw, mcr_new, MTK_MAC_MCR(mac->id));
-	}
-
+	mtk_set_mcr_max_rx(mac, length);
 	dev->mtu = new_mtu;
 
 	return 0;
-- 
2.35.1



