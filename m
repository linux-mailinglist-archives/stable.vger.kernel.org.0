Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D05E594917
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:11:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354575AbiHOXy6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:54:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355813AbiHOXxE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:53:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C9F41593CF;
        Mon, 15 Aug 2022 13:17:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CCD4A60FAD;
        Mon, 15 Aug 2022 20:17:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B82C0C433C1;
        Mon, 15 Aug 2022 20:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594651;
        bh=gZ04kFEOTaCBzHDBPqlBL7aIbDhklJyOflcYG66T3P0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=emgFw0WdRhcXAb5RwD2qnc/pUljT9uNwOTPQWYkQP8PMhxcBFtxa/HpT2ffULkda7
         NtxgH409i+19kCsfvv5YxUMkI38SJ0tbSMQYvOMx58nz1zWQ8z/gzu+utoBs6B3eOg
         iXxIemuJzt4q85Q71UWWxWGEdCh+kaQ5lPehfb3Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0482/1157] mt76: mt7915: rely on mt76_dev in mt7915_mac_write_txwi signature
Date:   Mon, 15 Aug 2022 19:57:18 +0200
Message-Id: <20220815180458.906173601@linuxfoundation.org>
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

[ Upstream commit d502e30020b85857ead0f9d392d24dba8c0f44cb ]

This is a preliminary patch to share txwi configuration code.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7915/mac.c   | 23 +++++++++----------
 .../net/wireless/mediatek/mt76/mt7915/mcu.c   |  4 ++--
 .../wireless/mediatek/mt76/mt7915/mt7915.h    |  2 +-
 3 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
index 086244d9be76..b8704018dcc0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
@@ -1010,8 +1010,8 @@ mt7915_mac_write_txwi_tm(struct mt7915_phy *phy, __le32 *txwi,
 }
 
 static void
-mt7915_mac_write_txwi_8023(struct mt7915_dev *dev, __le32 *txwi,
-			   struct sk_buff *skb, struct mt76_wcid *wcid)
+mt7915_mac_write_txwi_8023(__le32 *txwi, struct sk_buff *skb,
+			   struct mt76_wcid *wcid)
 {
 
 	u8 tid = skb->priority & IEEE80211_QOS_CTL_TID_MASK;
@@ -1050,9 +1050,8 @@ mt7915_mac_write_txwi_8023(struct mt7915_dev *dev, __le32 *txwi,
 }
 
 static void
-mt7915_mac_write_txwi_80211(struct mt7915_dev *dev, __le32 *txwi,
-			    struct sk_buff *skb, struct ieee80211_key_conf *key,
-			    bool *mcast)
+mt7915_mac_write_txwi_80211(__le32 *txwi, struct sk_buff *skb,
+			    struct ieee80211_key_conf *key, bool *mcast)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct ieee80211_mgmt *mgmt = (struct ieee80211_mgmt *)skb->data;
@@ -1175,13 +1174,13 @@ mt7915_mac_tx_rate_val(struct mt76_phy *mphy, struct ieee80211_vif *vif,
 	       FIELD_PREP(MT_TX_RATE_MODE, mode);
 }
 
-void mt7915_mac_write_txwi(struct mt7915_dev *dev, __le32 *txwi,
+void mt7915_mac_write_txwi(struct mt76_dev *dev, __le32 *txwi,
 			   struct sk_buff *skb, struct mt76_wcid *wcid, int pid,
 			   struct ieee80211_key_conf *key, u32 changed)
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_vif *vif = info->control.vif;
-	struct mt76_phy *mphy = &dev->mphy;
+	struct mt76_phy *mphy = &dev->phy;
 	bool ext_phy = info->hw_queue & MT_TX_HW_QUEUE_EXT_PHY;
 	u8 p_fmt, q_idx, omac_idx = 0, wmm_idx = 0, band_idx = 0;
 	bool is_8023 = info->flags & IEEE80211_TX_CTL_HW_80211_ENCAP;
@@ -1201,8 +1200,8 @@ void mt7915_mac_write_txwi(struct mt7915_dev *dev, __le32 *txwi,
 		band_idx = mvif->mt76.band_idx;
 	}
 
-	if (ext_phy && dev->mt76.phy2)
-		mphy = dev->mt76.phy2;
+	if (ext_phy && dev->phy2)
+		mphy = dev->phy2;
 
 	if (inband_disc) {
 		p_fmt = MT_TX_TYPE_FW;
@@ -1254,9 +1253,9 @@ void mt7915_mac_write_txwi(struct mt7915_dev *dev, __le32 *txwi,
 	txwi[7] = wcid->amsdu ? cpu_to_le32(MT_TXD7_HW_AMSDU) : 0;
 
 	if (is_8023)
-		mt7915_mac_write_txwi_8023(dev, txwi, skb, wcid);
+		mt7915_mac_write_txwi_8023(txwi, skb, wcid);
 	else
-		mt7915_mac_write_txwi_80211(dev, txwi, skb, key, &mcast);
+		mt7915_mac_write_txwi_80211(txwi, skb, key, &mcast);
 
 	if (txwi[2] & cpu_to_le32(MT_TXD2_FIX_RATE)) {
 		u16 rate = mt7915_mac_tx_rate_val(mphy, vif, beacon, mcast);
@@ -1315,7 +1314,7 @@ int mt7915_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
 		return id;
 
 	pid = mt76_tx_status_skb_add(mdev, wcid, tx_info->skb);
-	mt7915_mac_write_txwi(dev, txwi_ptr, tx_info->skb, wcid, pid, key, 0);
+	mt7915_mac_write_txwi(mdev, txwi_ptr, tx_info->skb, wcid, pid, key, 0);
 
 	txp = (struct mt7915_txp *)(txwi + MT_TXD_SIZE);
 	for (i = 0; i < nbuf; i++) {
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
index 1b3d6634a72e..4ac45fd63662 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -1910,7 +1910,7 @@ mt7915_mcu_beacon_cont(struct mt7915_dev *dev, struct ieee80211_vif *vif,
 	}
 
 	buf = (u8 *)tlv + sizeof(*cont);
-	mt7915_mac_write_txwi(dev, (__le32 *)buf, skb, wcid, 0, NULL,
+	mt7915_mac_write_txwi(&dev->mt76, (__le32 *)buf, skb, wcid, 0, NULL,
 			      BSS_CHANGED_BEACON);
 	memcpy(buf + MT_TXD_SIZE, skb->data, skb->len);
 }
@@ -2049,7 +2049,7 @@ mt7915_mcu_beacon_inband_discov(struct mt7915_dev *dev, struct ieee80211_vif *vi
 
 	buf = (u8 *)tlv + sizeof(*discov);
 
-	mt7915_mac_write_txwi(dev, (__le32 *)buf, skb, wcid, 0, NULL,
+	mt7915_mac_write_txwi(&dev->mt76, (__le32 *)buf, skb, wcid, 0, NULL,
 			      changed);
 	memcpy(buf + MT_TXD_SIZE, skb->data, skb->len);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h b/drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h
index 4dcae6991669..8fcaa1d22f01 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h
@@ -557,7 +557,7 @@ bool mt7915_mac_wtbl_update(struct mt7915_dev *dev, int idx, u32 mask);
 void mt7915_mac_reset_counters(struct mt7915_phy *phy);
 void mt7915_mac_cca_stats_reset(struct mt7915_phy *phy);
 void mt7915_mac_enable_nf(struct mt7915_dev *dev, bool ext_phy);
-void mt7915_mac_write_txwi(struct mt7915_dev *dev, __le32 *txwi,
+void mt7915_mac_write_txwi(struct mt76_dev *dev, __le32 *txwi,
 			   struct sk_buff *skb, struct mt76_wcid *wcid, int pid,
 			   struct ieee80211_key_conf *key, u32 changed);
 void mt7915_mac_set_timing(struct mt7915_phy *phy);
-- 
2.35.1



