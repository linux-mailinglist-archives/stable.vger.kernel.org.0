Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37B3B5949E1
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:15:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354703AbiHOXzJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:55:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355763AbiHOXw5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:52:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 262E1159C0A;
        Mon, 15 Aug 2022 13:17:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3759CB81136;
        Mon, 15 Aug 2022 20:17:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38677C4347C;
        Mon, 15 Aug 2022 20:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594647;
        bh=KkSJ+ro7D2VbIJYlaA95P0S/+U+ld2vCNAKiickgpQs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kMmzm4wGwQiZ2YRJbvHfmynI3kimeWapDmPyTG/gayi08b7kLFM5Tf82RQj7tI0R7
         rSrFaUuJo0yvTYIafjlOvSPHvHexa9AEMveDzKavA/B6P8fGSVNyAFpJDOlXo3PnfW
         nht+iDZ7e57oZM3Sd7X+pDUWHI2v92OjTa5XtR+w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0481/1157] mt76: mt7921: rely on mt76_dev in mt7921_mac_write_txwi signature
Date:   Mon, 15 Aug 2022 19:57:17 +0200
Message-Id: <20220815180458.875576460@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

[ Upstream commit e00b3e407efeed81dc30a72e4041ff57bf7068d5 ]

This is a preliminary patch to share txwi configuration code.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7921/mac.c   | 23 +++++++++----------
 .../net/wireless/mediatek/mt76/mt7921/mcu.c   |  2 +-
 .../wireless/mediatek/mt76/mt7921/mt7921.h    |  2 +-
 .../wireless/mediatek/mt76/mt7921/pci_mac.c   |  2 +-
 4 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
index a630ddbf19e5..2d4c81eec6dc 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
@@ -809,8 +809,8 @@ mt7921_mac_fill_rx(struct mt7921_dev *dev, struct sk_buff *skb)
 }
 
 static void
-mt7921_mac_write_txwi_8023(struct mt7921_dev *dev, __le32 *txwi,
-			   struct sk_buff *skb, struct mt76_wcid *wcid)
+mt7921_mac_write_txwi_8023(__le32 *txwi, struct sk_buff *skb,
+			   struct mt76_wcid *wcid)
 {
 	u8 tid = skb->priority & IEEE80211_QOS_CTL_TID_MASK;
 	u8 fc_type, fc_stype;
@@ -848,7 +848,7 @@ mt7921_mac_write_txwi_8023(struct mt7921_dev *dev, __le32 *txwi,
 }
 
 static void
-mt7921_mac_write_txwi_80211(struct mt7921_dev *dev, __le32 *txwi,
+mt7921_mac_write_txwi_80211(struct mt76_dev *dev, __le32 *txwi,
 			    struct sk_buff *skb, struct ieee80211_key_conf *key)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
@@ -920,7 +920,7 @@ mt7921_mac_write_txwi_80211(struct mt7921_dev *dev, __le32 *txwi,
 		txwi[7] &= ~cpu_to_le32(MT_TXD7_HW_AMSDU);
 	}
 
-	if (mt76_is_mmio(&dev->mt76)) {
+	if (mt76_is_mmio(dev)) {
 		val = FIELD_PREP(MT_TXD7_TYPE, fc_type) |
 		      FIELD_PREP(MT_TXD7_SUB_TYPE, fc_stype);
 		txwi[7] |= cpu_to_le32(val);
@@ -931,17 +931,16 @@ mt7921_mac_write_txwi_80211(struct mt7921_dev *dev, __le32 *txwi,
 	}
 }
 
-void mt7921_mac_write_txwi(struct mt7921_dev *dev, __le32 *txwi,
+void mt7921_mac_write_txwi(struct mt76_dev *dev, __le32 *txwi,
 			   struct sk_buff *skb, struct mt76_wcid *wcid,
 			   struct ieee80211_key_conf *key, int pid,
 			   bool beacon)
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_vif *vif = info->control.vif;
-	struct mt76_phy *mphy = &dev->mphy;
+	struct mt76_phy *mphy = &dev->phy;
 	u8 p_fmt, q_idx, omac_idx = 0, wmm_idx = 0;
-	bool is_mmio = mt76_is_mmio(&dev->mt76);
-	u32 sz_txd = is_mmio ? MT_TXD_SIZE : MT_SDIO_TXD_SIZE;
+	u32 sz_txd = mt76_is_mmio(dev) ? MT_TXD_SIZE : MT_SDIO_TXD_SIZE;
 	bool is_8023 = info->flags & IEEE80211_TX_CTL_HW_80211_ENCAP;
 	u16 tx_count = 15;
 	u32 val;
@@ -957,10 +956,10 @@ void mt7921_mac_write_txwi(struct mt7921_dev *dev, __le32 *txwi,
 		p_fmt = MT_TX_TYPE_FW;
 		q_idx = MT_LMAC_BCN0;
 	} else if (skb_get_queue_mapping(skb) >= MT_TXQ_PSD) {
-		p_fmt = is_mmio ? MT_TX_TYPE_CT : MT_TX_TYPE_SF;
+		p_fmt = mt76_is_mmio(dev) ? MT_TX_TYPE_CT : MT_TX_TYPE_SF;
 		q_idx = MT_LMAC_ALTX0;
 	} else {
-		p_fmt = is_mmio ? MT_TX_TYPE_CT : MT_TX_TYPE_SF;
+		p_fmt = mt76_is_mmio(dev) ? MT_TX_TYPE_CT : MT_TX_TYPE_SF;
 		q_idx = wmm_idx * MT7921_MAX_WMM_SETS +
 			mt76_connac_lmac_mapping(skb_get_queue_mapping(skb));
 	}
@@ -995,7 +994,7 @@ void mt7921_mac_write_txwi(struct mt7921_dev *dev, __le32 *txwi,
 	txwi[7] = wcid->amsdu ? cpu_to_le32(MT_TXD7_HW_AMSDU) : 0;
 
 	if (is_8023)
-		mt7921_mac_write_txwi_8023(dev, txwi, skb, wcid);
+		mt7921_mac_write_txwi_8023(txwi, skb, wcid);
 	else
 		mt7921_mac_write_txwi_80211(dev, txwi, skb, key);
 
@@ -1646,7 +1645,7 @@ mt7921_usb_sdio_write_txwi(struct mt7921_dev *dev, struct mt76_wcid *wcid,
 	__le32 *txwi = (__le32 *)(skb->data - MT_SDIO_TXD_SIZE);
 
 	memset(txwi, 0, MT_SDIO_TXD_SIZE);
-	mt7921_mac_write_txwi(dev, txwi, skb, wcid, key, pid, false);
+	mt7921_mac_write_txwi(&dev->mt76, txwi, skb, wcid, key, pid, false);
 	skb_push(skb, MT_SDIO_TXD_SIZE);
 }
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
index 3765b345b741..6ccd469eb3e4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
@@ -1272,7 +1272,7 @@ mt7921_mcu_uni_add_beacon_offload(struct mt7921_dev *dev,
 		return -EINVAL;
 	}
 
-	mt7921_mac_write_txwi(dev, (__le32 *)(req.beacon_tlv.pkt), skb,
+	mt7921_mac_write_txwi(&dev->mt76, (__le32 *)(req.beacon_tlv.pkt), skb,
 			      wcid, NULL, 0, true);
 	memcpy(req.beacon_tlv.pkt + MT_TXD_SIZE, skb->data, skb->len);
 	req.beacon_tlv.pkt_len = cpu_to_le16(MT_TXD_SIZE + skb->len);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h b/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
index 5ca584bb2fc6..3dfc2d593aa4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
@@ -424,7 +424,7 @@ int mt7921_testmode_cmd(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			void *data, int len);
 int mt7921_testmode_dump(struct ieee80211_hw *hw, struct sk_buff *msg,
 			 struct netlink_callback *cb, void *data, int len);
-void mt7921_mac_write_txwi(struct mt7921_dev *dev, __le32 *txwi,
+void mt7921_mac_write_txwi(struct mt76_dev *dev, __le32 *txwi,
 			   struct sk_buff *skb, struct mt76_wcid *wcid,
 			   struct ieee80211_key_conf *key, int pid,
 			   bool beacon);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/pci_mac.c b/drivers/net/wireless/mediatek/mt76/mt7921/pci_mac.c
index 5ca14dbbdd26..f261cbfae2f3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/pci_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/pci_mac.c
@@ -72,7 +72,7 @@ int mt7921e_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
 	}
 
 	pid = mt76_tx_status_skb_add(mdev, wcid, tx_info->skb);
-	mt7921_mac_write_txwi(dev, txwi_ptr, tx_info->skb, wcid, key,
+	mt7921_mac_write_txwi(mdev, txwi_ptr, tx_info->skb, wcid, key,
 			      pid, false);
 
 	txp = (struct mt7921_txp_common *)(txwi + MT_TXD_SIZE);
-- 
2.35.1



