Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F5C44F31F3
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:53:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233089AbiDEIiZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:38:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237956AbiDEISe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:18:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAB6CB821D;
        Tue,  5 Apr 2022 01:07:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 83336617EE;
        Tue,  5 Apr 2022 08:07:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90FE6C385A1;
        Tue,  5 Apr 2022 08:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146068;
        bh=y+dar7JCW4XERL+1xxtW86hKLcwtyN/Rw9l7lfqSf5s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uYJV8jRNvYG1pbJjafeRnCl1e6xIZIKyw9a1yaLSnFRMrJMz4yUvs2wFrM/0AyiUi
         DB54fuTEWE1IMsgTAZvNIGE9PPfB6I+2xdWXh3nT5DmNQj4lyNnzAM8yqrXJnMpcTL
         XQihK4gWVimd6U1C8U2UoPCDUqVRhqvKbBwD7gP0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0593/1126] mt76: do not always copy ethhdr in reverse_frag0_hdr_trans
Date:   Tue,  5 Apr 2022 09:22:20 +0200
Message-Id: <20220405070425.040301065@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
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

[ Upstream commit eea7437e80216ac29a87b417896ce75656816b56 ]

Do not always copy ethernet header in mt{7615,7915,7921}_reverse_frag0_hdr_trans
and use a pointer instead.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7615/mac.c   | 19 +++++++++----------
 .../net/wireless/mediatek/mt76/mt7915/mac.c   | 19 +++++++++----------
 .../net/wireless/mediatek/mt76/mt7921/mac.c   | 19 +++++++++----------
 3 files changed, 27 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
index 6d0ff5af8fec..21941e7873d8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
@@ -253,12 +253,12 @@ static void mt7615_mac_fill_tm_rx(struct mt7615_phy *phy, __le32 *rxv)
 static int mt7615_reverse_frag0_hdr_trans(struct sk_buff *skb, u16 hdr_gap)
 {
 	struct mt76_rx_status *status = (struct mt76_rx_status *)skb->cb;
+	struct ethhdr *eth_hdr = (struct ethhdr *)(skb->data + hdr_gap);
 	struct mt7615_sta *msta = (struct mt7615_sta *)status->wcid;
+	__le32 *rxd = (__le32 *)skb->data;
 	struct ieee80211_sta *sta;
 	struct ieee80211_vif *vif;
 	struct ieee80211_hdr hdr;
-	struct ethhdr eth_hdr;
-	__le32 *rxd = (__le32 *)skb->data;
 	__le32 qos_ctrl, ht_ctrl;
 
 	if (FIELD_GET(MT_RXD1_NORMAL_ADDR_TYPE, le32_to_cpu(rxd[1])) !=
@@ -275,7 +275,6 @@ static int mt7615_reverse_frag0_hdr_trans(struct sk_buff *skb, u16 hdr_gap)
 	vif = container_of((void *)msta->vif, struct ieee80211_vif, drv_priv);
 
 	/* store the info from RXD and ethhdr to avoid being overridden */
-	memcpy(&eth_hdr, skb->data + hdr_gap, sizeof(eth_hdr));
 	hdr.frame_control = FIELD_GET(MT_RXD4_FRAME_CONTROL, rxd[4]);
 	hdr.seq_ctrl = FIELD_GET(MT_RXD6_SEQ_CTRL, rxd[6]);
 	qos_ctrl = FIELD_GET(MT_RXD6_QOS_CTL, rxd[6]);
@@ -290,24 +289,24 @@ static int mt7615_reverse_frag0_hdr_trans(struct sk_buff *skb, u16 hdr_gap)
 		ether_addr_copy(hdr.addr3, vif->bss_conf.bssid);
 		break;
 	case IEEE80211_FCTL_FROMDS:
-		ether_addr_copy(hdr.addr3, eth_hdr.h_source);
+		ether_addr_copy(hdr.addr3, eth_hdr->h_source);
 		break;
 	case IEEE80211_FCTL_TODS:
-		ether_addr_copy(hdr.addr3, eth_hdr.h_dest);
+		ether_addr_copy(hdr.addr3, eth_hdr->h_dest);
 		break;
 	case IEEE80211_FCTL_TODS | IEEE80211_FCTL_FROMDS:
-		ether_addr_copy(hdr.addr3, eth_hdr.h_dest);
-		ether_addr_copy(hdr.addr4, eth_hdr.h_source);
+		ether_addr_copy(hdr.addr3, eth_hdr->h_dest);
+		ether_addr_copy(hdr.addr4, eth_hdr->h_source);
 		break;
 	default:
 		break;
 	}
 
 	skb_pull(skb, hdr_gap + sizeof(struct ethhdr) - 2);
-	if (eth_hdr.h_proto == htons(ETH_P_AARP) ||
-	    eth_hdr.h_proto == htons(ETH_P_IPX))
+	if (eth_hdr->h_proto == cpu_to_be16(ETH_P_AARP) ||
+	    eth_hdr->h_proto == cpu_to_be16(ETH_P_IPX))
 		ether_addr_copy(skb_push(skb, ETH_ALEN), bridge_tunnel_header);
-	else if (eth_hdr.h_proto >= htons(ETH_P_802_3_MIN))
+	else if (eth_hdr->h_proto >= cpu_to_be16(ETH_P_802_3_MIN))
 		ether_addr_copy(skb_push(skb, ETH_ALEN), rfc1042_header);
 	else
 		skb_pull(skb, 2);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
index d18a2e93cff5..bca340cf8dcc 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
@@ -391,12 +391,12 @@ mt7915_mac_decode_he_radiotap(struct sk_buff *skb, __le32 *rxv, u32 mode)
 static int mt7915_reverse_frag0_hdr_trans(struct sk_buff *skb, u16 hdr_gap)
 {
 	struct mt76_rx_status *status = (struct mt76_rx_status *)skb->cb;
+	struct ethhdr *eth_hdr = (struct ethhdr *)(skb->data + hdr_gap);
 	struct mt7915_sta *msta = (struct mt7915_sta *)status->wcid;
+	__le32 *rxd = (__le32 *)skb->data;
 	struct ieee80211_sta *sta;
 	struct ieee80211_vif *vif;
 	struct ieee80211_hdr hdr;
-	struct ethhdr eth_hdr;
-	__le32 *rxd = (__le32 *)skb->data;
 	__le32 qos_ctrl, ht_ctrl;
 
 	if (FIELD_GET(MT_RXD3_NORMAL_ADDR_TYPE, le32_to_cpu(rxd[3])) !=
@@ -413,7 +413,6 @@ static int mt7915_reverse_frag0_hdr_trans(struct sk_buff *skb, u16 hdr_gap)
 	vif = container_of((void *)msta->vif, struct ieee80211_vif, drv_priv);
 
 	/* store the info from RXD and ethhdr to avoid being overridden */
-	memcpy(&eth_hdr, skb->data + hdr_gap, sizeof(eth_hdr));
 	hdr.frame_control = FIELD_GET(MT_RXD6_FRAME_CONTROL, rxd[6]);
 	hdr.seq_ctrl = FIELD_GET(MT_RXD8_SEQ_CTRL, rxd[8]);
 	qos_ctrl = FIELD_GET(MT_RXD8_QOS_CTL, rxd[8]);
@@ -428,24 +427,24 @@ static int mt7915_reverse_frag0_hdr_trans(struct sk_buff *skb, u16 hdr_gap)
 		ether_addr_copy(hdr.addr3, vif->bss_conf.bssid);
 		break;
 	case IEEE80211_FCTL_FROMDS:
-		ether_addr_copy(hdr.addr3, eth_hdr.h_source);
+		ether_addr_copy(hdr.addr3, eth_hdr->h_source);
 		break;
 	case IEEE80211_FCTL_TODS:
-		ether_addr_copy(hdr.addr3, eth_hdr.h_dest);
+		ether_addr_copy(hdr.addr3, eth_hdr->h_dest);
 		break;
 	case IEEE80211_FCTL_TODS | IEEE80211_FCTL_FROMDS:
-		ether_addr_copy(hdr.addr3, eth_hdr.h_dest);
-		ether_addr_copy(hdr.addr4, eth_hdr.h_source);
+		ether_addr_copy(hdr.addr3, eth_hdr->h_dest);
+		ether_addr_copy(hdr.addr4, eth_hdr->h_source);
 		break;
 	default:
 		break;
 	}
 
 	skb_pull(skb, hdr_gap + sizeof(struct ethhdr) - 2);
-	if (eth_hdr.h_proto == htons(ETH_P_AARP) ||
-	    eth_hdr.h_proto == htons(ETH_P_IPX))
+	if (eth_hdr->h_proto == cpu_to_be16(ETH_P_AARP) ||
+	    eth_hdr->h_proto == cpu_to_be16(ETH_P_IPX))
 		ether_addr_copy(skb_push(skb, ETH_ALEN), bridge_tunnel_header);
-	else if (eth_hdr.h_proto >= htons(ETH_P_802_3_MIN))
+	else if (eth_hdr->h_proto >= cpu_to_be16(ETH_P_802_3_MIN))
 		ether_addr_copy(skb_push(skb, ETH_ALEN), rfc1042_header);
 	else
 		skb_pull(skb, 2);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
index c6a849ee817c..2b6bbe0682c0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
@@ -402,12 +402,12 @@ mt7921_mac_assoc_rssi(struct mt7921_dev *dev, struct sk_buff *skb)
 static int mt7921_reverse_frag0_hdr_trans(struct sk_buff *skb, u16 hdr_gap)
 {
 	struct mt76_rx_status *status = (struct mt76_rx_status *)skb->cb;
+	struct ethhdr *eth_hdr = (struct ethhdr *)(skb->data + hdr_gap);
 	struct mt7921_sta *msta = (struct mt7921_sta *)status->wcid;
+	__le32 *rxd = (__le32 *)skb->data;
 	struct ieee80211_sta *sta;
 	struct ieee80211_vif *vif;
 	struct ieee80211_hdr hdr;
-	struct ethhdr eth_hdr;
-	__le32 *rxd = (__le32 *)skb->data;
 	__le32 qos_ctrl, ht_ctrl;
 
 	if (FIELD_GET(MT_RXD3_NORMAL_ADDR_TYPE, le32_to_cpu(rxd[3])) !=
@@ -424,7 +424,6 @@ static int mt7921_reverse_frag0_hdr_trans(struct sk_buff *skb, u16 hdr_gap)
 	vif = container_of((void *)msta->vif, struct ieee80211_vif, drv_priv);
 
 	/* store the info from RXD and ethhdr to avoid being overridden */
-	memcpy(&eth_hdr, skb->data + hdr_gap, sizeof(eth_hdr));
 	hdr.frame_control = FIELD_GET(MT_RXD6_FRAME_CONTROL, rxd[6]);
 	hdr.seq_ctrl = FIELD_GET(MT_RXD8_SEQ_CTRL, rxd[8]);
 	qos_ctrl = FIELD_GET(MT_RXD8_QOS_CTL, rxd[8]);
@@ -439,24 +438,24 @@ static int mt7921_reverse_frag0_hdr_trans(struct sk_buff *skb, u16 hdr_gap)
 		ether_addr_copy(hdr.addr3, vif->bss_conf.bssid);
 		break;
 	case IEEE80211_FCTL_FROMDS:
-		ether_addr_copy(hdr.addr3, eth_hdr.h_source);
+		ether_addr_copy(hdr.addr3, eth_hdr->h_source);
 		break;
 	case IEEE80211_FCTL_TODS:
-		ether_addr_copy(hdr.addr3, eth_hdr.h_dest);
+		ether_addr_copy(hdr.addr3, eth_hdr->h_dest);
 		break;
 	case IEEE80211_FCTL_TODS | IEEE80211_FCTL_FROMDS:
-		ether_addr_copy(hdr.addr3, eth_hdr.h_dest);
-		ether_addr_copy(hdr.addr4, eth_hdr.h_source);
+		ether_addr_copy(hdr.addr3, eth_hdr->h_dest);
+		ether_addr_copy(hdr.addr4, eth_hdr->h_source);
 		break;
 	default:
 		break;
 	}
 
 	skb_pull(skb, hdr_gap + sizeof(struct ethhdr) - 2);
-	if (eth_hdr.h_proto == htons(ETH_P_AARP) ||
-	    eth_hdr.h_proto == htons(ETH_P_IPX))
+	if (eth_hdr->h_proto == cpu_to_be16(ETH_P_AARP) ||
+	    eth_hdr->h_proto == cpu_to_be16(ETH_P_IPX))
 		ether_addr_copy(skb_push(skb, ETH_ALEN), bridge_tunnel_header);
-	else if (eth_hdr.h_proto >= htons(ETH_P_802_3_MIN))
+	else if (eth_hdr->h_proto >= cpu_to_be16(ETH_P_802_3_MIN))
 		ether_addr_copy(skb_push(skb, ETH_ALEN), rfc1042_header);
 	else
 		skb_pull(skb, 2);
-- 
2.34.1



