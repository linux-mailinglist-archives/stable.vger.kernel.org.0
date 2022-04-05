Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 811EF4F2AEF
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238461AbiDEIiC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:38:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237996AbiDEISg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:18:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85BC9B8234;
        Tue,  5 Apr 2022 01:07:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EC381B81BB1;
        Tue,  5 Apr 2022 08:07:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41063C385B3;
        Tue,  5 Apr 2022 08:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146071;
        bh=rGr6vuXVboyo80Fw1TUoe9tzXEz4B4m9CD9ZjDVUClI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PXhj7y1fIRxQRzEmxPkGvQKH1wCJ+defIUMYxgbKHqrMdo5Y1YHkcne3UQUcgfGWK
         d0MxBlGsbLPrswuOslT22Gbm9zmd0zJDOBFGEDhyP2GHvEF6l/8YbQE10YEBfaxH6f
         M0aNOdz63ea07NdXQDoozIml4KKDD1ST/QqMXjlw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0594/1126] mt76: fix endianness errors in reverse_frag0_hdr_trans
Date:   Tue,  5 Apr 2022 09:22:21 +0200
Message-Id: <20220405070425.069979982@linuxfoundation.org>
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

[ Upstream commit d0c0cefb87e283b5000121989f3c10c9915a2787 ]

Fix ht ctl field size in mt{7615,7915,7921}_reverse_frag0_hdr_trans.
Fix the following endianness warnings in mt{7615,7915,7921}_reverse_frag0_hdr_trans:

drivers/net/wireless/mediatek/mt76/mt7915/mac.c:417:29: warning: cast to restricted __le32
drivers/net/wireless/mediatek/mt76/mt7915/mac.c:417:29: warning: restricted __le32 degrades to integer
drivers/net/wireless/mediatek/mt76/mt7915/mac.c:417:29: warning: restricted __le32 degrades to integer
drivers/net/wireless/mediatek/mt76/mt7915/mac.c:417:27: warning: incorrect type in assignment (different base types)
drivers/net/wireless/mediatek/mt76/mt7915/mac.c:417:27:    expected restricted __le16 [usertype] frame_control
drivers/net/wireless/mediatek/mt76/mt7915/mac.c:417:27:    got unsigned long
drivers/net/wireless/mediatek/mt76/mt7915/mac.c:418:24: warning: cast to restricted __le32
drivers/net/wireless/mediatek/mt76/mt7915/mac.c:418:24: warning: restricted __le32 degrades to integer
drivers/net/wireless/mediatek/mt76/mt7915/mac.c:418:24: warning: restricted __le32 degrades to integer
drivers/net/wireless/mediatek/mt76/mt7915/mac.c:418:22: warning: incorrect type in assignment (different base types)
drivers/net/wireless/mediatek/mt76/mt7915/mac.c:418:22:    expected restricted __le16 [usertype] seq_ctrl
drivers/net/wireless/mediatek/mt76/mt7915/mac.c:418:22:    got unsigned long
drivers/net/wireless/mediatek/mt76/mt7915/mac.c:419:20: warning: cast to restricted __le32
drivers/net/wireless/mediatek/mt76/mt7915/mac.c:419:20: warning: restricted __le32 degrades to integer
drivers/net/wireless/mediatek/mt76/mt7915/mac.c:419:20: warning: restricted __le32 degrades to integer
drivers/net/wireless/mediatek/mt76/mt7915/mac.c:419:18: warning: incorrect type in assignment (different base types)
drivers/net/wireless/mediatek/mt76/mt7915/mac.c:419:18:    expected restricted __le32 [usertype] qos_ctrl
drivers/net/wireless/mediatek/mt76/mt7915/mac.c:419:18:    got unsigned long
drivers/net/wireless/mediatek/mt76/mt7915/mac.c:420:19: warning: cast to restricted __le32
drivers/net/wireless/mediatek/mt76/mt7915/mac.c:420:19: warning: restricted __le32 degrades to integer
drivers/net/wireless/mediatek/mt76/mt7915/mac.c:420:19: warning: restricted __le32 degrades to integer
drivers/net/wireless/mediatek/mt76/mt7915/mac.c:420:17: warning: incorrect type in assignment (different base types)
drivers/net/wireless/mediatek/mt76/mt7915/mac.c:420:17:    expected restricted __le32 [usertype] ht_ctrl
drivers/net/wireless/mediatek/mt76/mt7915/mac.c:420:17:    got unsigned long
drivers/net/wireless/mediatek/mt76/mt7915/mac.c:448:25: warning: restricted __be16 degrades to integer
drivers/net/wireless/mediatek/mt76/mt7915/mac.c:448:38: warning: restricted __be16 degrades to integer
drivers/net/wireless/mediatek/mt76/mt7915/mac.c:1450:23: warning: incorrect type in assignment (different base types)
drivers/net/wireless/mediatek/mt76/mt7915/mac.c:1450:23:    expected unsigned int [usertype] *cur_info
drivers/net/wireless/mediatek/mt76/mt7915/mac.c:1450:23:    got restricted __le32 *
drivers/net/wireless/mediatek/mt76/mt7915/mac.c:1451:34: warning: cast to restricted __le32

Fixes: dc5399a50b45f ("mt76: reverse the first fragmented frame to 802.11")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7615/mac.c   | 31 ++++++++++++-------
 .../net/wireless/mediatek/mt76/mt7915/mac.c   | 30 +++++++++++-------
 .../net/wireless/mediatek/mt76/mt7921/mac.c   | 30 +++++++++++-------
 3 files changed, 55 insertions(+), 36 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
index 21941e7873d8..ba31bb7caaf9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
@@ -259,7 +259,7 @@ static int mt7615_reverse_frag0_hdr_trans(struct sk_buff *skb, u16 hdr_gap)
 	struct ieee80211_sta *sta;
 	struct ieee80211_vif *vif;
 	struct ieee80211_hdr hdr;
-	__le32 qos_ctrl, ht_ctrl;
+	u16 frame_control;
 
 	if (FIELD_GET(MT_RXD1_NORMAL_ADDR_TYPE, le32_to_cpu(rxd[1])) !=
 	    MT_RXD1_NORMAL_U2M)
@@ -275,16 +275,15 @@ static int mt7615_reverse_frag0_hdr_trans(struct sk_buff *skb, u16 hdr_gap)
 	vif = container_of((void *)msta->vif, struct ieee80211_vif, drv_priv);
 
 	/* store the info from RXD and ethhdr to avoid being overridden */
-	hdr.frame_control = FIELD_GET(MT_RXD4_FRAME_CONTROL, rxd[4]);
-	hdr.seq_ctrl = FIELD_GET(MT_RXD6_SEQ_CTRL, rxd[6]);
-	qos_ctrl = FIELD_GET(MT_RXD6_QOS_CTL, rxd[6]);
-	ht_ctrl = FIELD_GET(MT_RXD7_HT_CONTROL, rxd[7]);
-
+	frame_control = le32_get_bits(rxd[4], MT_RXD4_FRAME_CONTROL);
+	hdr.frame_control = cpu_to_le16(frame_control);
+	hdr.seq_ctrl = cpu_to_le16(le32_get_bits(rxd[6], MT_RXD6_SEQ_CTRL));
 	hdr.duration_id = 0;
+
 	ether_addr_copy(hdr.addr1, vif->addr);
 	ether_addr_copy(hdr.addr2, sta->addr);
-	switch (le16_to_cpu(hdr.frame_control) &
-		(IEEE80211_FCTL_TODS | IEEE80211_FCTL_FROMDS)) {
+	switch (frame_control & (IEEE80211_FCTL_TODS |
+				 IEEE80211_FCTL_FROMDS)) {
 	case 0:
 		ether_addr_copy(hdr.addr3, vif->bss_conf.bssid);
 		break;
@@ -306,15 +305,23 @@ static int mt7615_reverse_frag0_hdr_trans(struct sk_buff *skb, u16 hdr_gap)
 	if (eth_hdr->h_proto == cpu_to_be16(ETH_P_AARP) ||
 	    eth_hdr->h_proto == cpu_to_be16(ETH_P_IPX))
 		ether_addr_copy(skb_push(skb, ETH_ALEN), bridge_tunnel_header);
-	else if (eth_hdr->h_proto >= cpu_to_be16(ETH_P_802_3_MIN))
+	else if (be16_to_cpu(eth_hdr->h_proto) >= ETH_P_802_3_MIN)
 		ether_addr_copy(skb_push(skb, ETH_ALEN), rfc1042_header);
 	else
 		skb_pull(skb, 2);
 
 	if (ieee80211_has_order(hdr.frame_control))
-		memcpy(skb_push(skb, 2), &ht_ctrl, 2);
-	if (ieee80211_is_data_qos(hdr.frame_control))
-		memcpy(skb_push(skb, 2), &qos_ctrl, 2);
+		memcpy(skb_push(skb, IEEE80211_HT_CTL_LEN), &rxd[7],
+		       IEEE80211_HT_CTL_LEN);
+
+	if (ieee80211_is_data_qos(hdr.frame_control)) {
+		__le16 qos_ctrl;
+
+		qos_ctrl = cpu_to_le16(le32_get_bits(rxd[6], MT_RXD6_QOS_CTL));
+		memcpy(skb_push(skb, IEEE80211_QOS_CTL_LEN), &qos_ctrl,
+		       IEEE80211_QOS_CTL_LEN);
+	}
+
 	if (ieee80211_has_a4(hdr.frame_control))
 		memcpy(skb_push(skb, sizeof(hdr)), &hdr, sizeof(hdr));
 	else
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
index bca340cf8dcc..12567b653607 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
@@ -397,7 +397,7 @@ static int mt7915_reverse_frag0_hdr_trans(struct sk_buff *skb, u16 hdr_gap)
 	struct ieee80211_sta *sta;
 	struct ieee80211_vif *vif;
 	struct ieee80211_hdr hdr;
-	__le32 qos_ctrl, ht_ctrl;
+	u16 frame_control;
 
 	if (FIELD_GET(MT_RXD3_NORMAL_ADDR_TYPE, le32_to_cpu(rxd[3])) !=
 	    MT_RXD3_NORMAL_U2M)
@@ -413,16 +413,15 @@ static int mt7915_reverse_frag0_hdr_trans(struct sk_buff *skb, u16 hdr_gap)
 	vif = container_of((void *)msta->vif, struct ieee80211_vif, drv_priv);
 
 	/* store the info from RXD and ethhdr to avoid being overridden */
-	hdr.frame_control = FIELD_GET(MT_RXD6_FRAME_CONTROL, rxd[6]);
-	hdr.seq_ctrl = FIELD_GET(MT_RXD8_SEQ_CTRL, rxd[8]);
-	qos_ctrl = FIELD_GET(MT_RXD8_QOS_CTL, rxd[8]);
-	ht_ctrl = FIELD_GET(MT_RXD9_HT_CONTROL, rxd[9]);
-
+	frame_control = le32_get_bits(rxd[6], MT_RXD6_FRAME_CONTROL);
+	hdr.frame_control = cpu_to_le16(frame_control);
+	hdr.seq_ctrl = cpu_to_le16(le32_get_bits(rxd[8], MT_RXD8_SEQ_CTRL));
 	hdr.duration_id = 0;
+
 	ether_addr_copy(hdr.addr1, vif->addr);
 	ether_addr_copy(hdr.addr2, sta->addr);
-	switch (le16_to_cpu(hdr.frame_control) &
-		(IEEE80211_FCTL_TODS | IEEE80211_FCTL_FROMDS)) {
+	switch (frame_control & (IEEE80211_FCTL_TODS |
+				 IEEE80211_FCTL_FROMDS)) {
 	case 0:
 		ether_addr_copy(hdr.addr3, vif->bss_conf.bssid);
 		break;
@@ -444,15 +443,22 @@ static int mt7915_reverse_frag0_hdr_trans(struct sk_buff *skb, u16 hdr_gap)
 	if (eth_hdr->h_proto == cpu_to_be16(ETH_P_AARP) ||
 	    eth_hdr->h_proto == cpu_to_be16(ETH_P_IPX))
 		ether_addr_copy(skb_push(skb, ETH_ALEN), bridge_tunnel_header);
-	else if (eth_hdr->h_proto >= cpu_to_be16(ETH_P_802_3_MIN))
+	else if (be16_to_cpu(eth_hdr->h_proto) >= ETH_P_802_3_MIN)
 		ether_addr_copy(skb_push(skb, ETH_ALEN), rfc1042_header);
 	else
 		skb_pull(skb, 2);
 
 	if (ieee80211_has_order(hdr.frame_control))
-		memcpy(skb_push(skb, 2), &ht_ctrl, 2);
-	if (ieee80211_is_data_qos(hdr.frame_control))
-		memcpy(skb_push(skb, 2), &qos_ctrl, 2);
+		memcpy(skb_push(skb, IEEE80211_HT_CTL_LEN), &rxd[9],
+		       IEEE80211_HT_CTL_LEN);
+	if (ieee80211_is_data_qos(hdr.frame_control)) {
+		__le16 qos_ctrl;
+
+		qos_ctrl = cpu_to_le16(le32_get_bits(rxd[8], MT_RXD8_QOS_CTL));
+		memcpy(skb_push(skb, IEEE80211_QOS_CTL_LEN), &qos_ctrl,
+		       IEEE80211_QOS_CTL_LEN);
+	}
+
 	if (ieee80211_has_a4(hdr.frame_control))
 		memcpy(skb_push(skb, sizeof(hdr)), &hdr, sizeof(hdr));
 	else
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
index 2b6bbe0682c0..f8d95d64fe46 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
@@ -408,7 +408,7 @@ static int mt7921_reverse_frag0_hdr_trans(struct sk_buff *skb, u16 hdr_gap)
 	struct ieee80211_sta *sta;
 	struct ieee80211_vif *vif;
 	struct ieee80211_hdr hdr;
-	__le32 qos_ctrl, ht_ctrl;
+	u16 frame_control;
 
 	if (FIELD_GET(MT_RXD3_NORMAL_ADDR_TYPE, le32_to_cpu(rxd[3])) !=
 	    MT_RXD3_NORMAL_U2M)
@@ -424,16 +424,15 @@ static int mt7921_reverse_frag0_hdr_trans(struct sk_buff *skb, u16 hdr_gap)
 	vif = container_of((void *)msta->vif, struct ieee80211_vif, drv_priv);
 
 	/* store the info from RXD and ethhdr to avoid being overridden */
-	hdr.frame_control = FIELD_GET(MT_RXD6_FRAME_CONTROL, rxd[6]);
-	hdr.seq_ctrl = FIELD_GET(MT_RXD8_SEQ_CTRL, rxd[8]);
-	qos_ctrl = FIELD_GET(MT_RXD8_QOS_CTL, rxd[8]);
-	ht_ctrl = FIELD_GET(MT_RXD9_HT_CONTROL, rxd[9]);
-
+	frame_control = le32_get_bits(rxd[6], MT_RXD6_FRAME_CONTROL);
+	hdr.frame_control = cpu_to_le16(frame_control);
+	hdr.seq_ctrl = cpu_to_le16(le32_get_bits(rxd[8], MT_RXD8_SEQ_CTRL));
 	hdr.duration_id = 0;
+
 	ether_addr_copy(hdr.addr1, vif->addr);
 	ether_addr_copy(hdr.addr2, sta->addr);
-	switch (le16_to_cpu(hdr.frame_control) &
-		(IEEE80211_FCTL_TODS | IEEE80211_FCTL_FROMDS)) {
+	switch (frame_control & (IEEE80211_FCTL_TODS |
+				 IEEE80211_FCTL_FROMDS)) {
 	case 0:
 		ether_addr_copy(hdr.addr3, vif->bss_conf.bssid);
 		break;
@@ -455,15 +454,22 @@ static int mt7921_reverse_frag0_hdr_trans(struct sk_buff *skb, u16 hdr_gap)
 	if (eth_hdr->h_proto == cpu_to_be16(ETH_P_AARP) ||
 	    eth_hdr->h_proto == cpu_to_be16(ETH_P_IPX))
 		ether_addr_copy(skb_push(skb, ETH_ALEN), bridge_tunnel_header);
-	else if (eth_hdr->h_proto >= cpu_to_be16(ETH_P_802_3_MIN))
+	else if (be16_to_cpu(eth_hdr->h_proto) >= ETH_P_802_3_MIN)
 		ether_addr_copy(skb_push(skb, ETH_ALEN), rfc1042_header);
 	else
 		skb_pull(skb, 2);
 
 	if (ieee80211_has_order(hdr.frame_control))
-		memcpy(skb_push(skb, 2), &ht_ctrl, 2);
-	if (ieee80211_is_data_qos(hdr.frame_control))
-		memcpy(skb_push(skb, 2), &qos_ctrl, 2);
+		memcpy(skb_push(skb, IEEE80211_HT_CTL_LEN), &rxd[9],
+		       IEEE80211_HT_CTL_LEN);
+	if (ieee80211_is_data_qos(hdr.frame_control)) {
+		__le16 qos_ctrl;
+
+		qos_ctrl = cpu_to_le16(le32_get_bits(rxd[8], MT_RXD8_QOS_CTL));
+		memcpy(skb_push(skb, IEEE80211_QOS_CTL_LEN), &qos_ctrl,
+		       IEEE80211_QOS_CTL_LEN);
+	}
+
 	if (ieee80211_has_a4(hdr.frame_control))
 		memcpy(skb_push(skb, sizeof(hdr)), &hdr, sizeof(hdr));
 	else
-- 
2.34.1



