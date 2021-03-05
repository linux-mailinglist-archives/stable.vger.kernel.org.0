Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C30E32E822
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:25:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230444AbhCEMZR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:25:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:59990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231148AbhCEMY7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:24:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7856465028;
        Fri,  5 Mar 2021 12:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947099;
        bh=iLwubWxhvhUlNc6rOFVX93JqktLbJof17wRubEj8Alk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2ikQZbivdNK+ne7isdX2OPOH38HQPZCwB/eg+MXOgZ5aC+zFc/OBaBYcudoScrStr
         leV5fdXKzWFqD2KmV7Urx7v9fT1TXKCFvHpo/KnIQARNn1mkZxWyargSp2wBo3V84D
         67RyOBT6speJBzdFXtR60/XYlrPusPVhizEbW4fE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bo Jiao <bo.jiao@mediatek.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 047/104] mt76: mt7915: reset token when mac_reset happens
Date:   Fri,  5 Mar 2021 13:20:52 +0100
Message-Id: <20210305120905.474587773@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120903.166929741@linuxfoundation.org>
References: <20210305120903.166929741@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ryder Lee <ryder.lee@mediatek.com>

[ Upstream commit f285dfb98562e8380101095d168910df1d07d8be ]

Reset buffering token in mt7915_mac_reset_work() to avoid possible leakege,
which leads to Tx stop after mac reset.

Tested-by: Bo Jiao <bo.jiao@mediatek.com>
Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7915/init.c  | 18 +-------------
 .../net/wireless/mediatek/mt76/mt7915/mac.c   | 24 +++++++++++++++++++
 .../wireless/mediatek/mt76/mt7915/mt7915.h    |  1 +
 3 files changed, 26 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/init.c b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
index 102a8f14c22d..2ec18aaa8280 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
@@ -672,28 +672,12 @@ int mt7915_register_device(struct mt7915_dev *dev)
 
 void mt7915_unregister_device(struct mt7915_dev *dev)
 {
-	struct mt76_txwi_cache *txwi;
-	int id;
-
 	mt7915_unregister_ext_phy(dev);
 	mt76_unregister_device(&dev->mt76);
 	mt7915_mcu_exit(dev);
 	mt7915_dma_cleanup(dev);
 
-	spin_lock_bh(&dev->token_lock);
-	idr_for_each_entry(&dev->token, txwi, id) {
-		mt7915_txp_skb_unmap(&dev->mt76, txwi);
-		if (txwi->skb) {
-			struct ieee80211_hw *hw;
-
-			hw = mt76_tx_status_get_hw(&dev->mt76, txwi->skb);
-			ieee80211_free_txskb(hw, txwi->skb);
-		}
-		mt76_put_txwi(&dev->mt76, txwi);
-		dev->token_count--;
-	}
-	spin_unlock_bh(&dev->token_lock);
-	idr_destroy(&dev->token);
+	mt7915_tx_token_put(dev);
 
 	mt76_free_device(&dev->mt76);
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
index f504eeb221f9..1b4d65310b88 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
@@ -1485,6 +1485,27 @@ mt7915_dma_reset(struct mt7915_phy *phy)
 		 MT_WFDMA1_GLO_CFG_TX_DMA_EN | MT_WFDMA1_GLO_CFG_RX_DMA_EN);
 }
 
+void mt7915_tx_token_put(struct mt7915_dev *dev)
+{
+	struct mt76_txwi_cache *txwi;
+	int id;
+
+	spin_lock_bh(&dev->token_lock);
+	idr_for_each_entry(&dev->token, txwi, id) {
+		mt7915_txp_skb_unmap(&dev->mt76, txwi);
+		if (txwi->skb) {
+			struct ieee80211_hw *hw;
+
+			hw = mt76_tx_status_get_hw(&dev->mt76, txwi->skb);
+			ieee80211_free_txskb(hw, txwi->skb);
+		}
+		mt76_put_txwi(&dev->mt76, txwi);
+		dev->token_count--;
+	}
+	spin_unlock_bh(&dev->token_lock);
+	idr_destroy(&dev->token);
+}
+
 /* system error recovery */
 void mt7915_mac_reset_work(struct work_struct *work)
 {
@@ -1525,6 +1546,9 @@ void mt7915_mac_reset_work(struct work_struct *work)
 
 	mt76_wr(dev, MT_MCU_INT_EVENT, MT_MCU_INT_EVENT_DMA_STOPPED);
 
+	mt7915_tx_token_put(dev);
+	idr_init(&dev->token);
+
 	if (mt7915_wait_reset_state(dev, MT_MCU_CMD_RESET_DONE)) {
 		mt7915_dma_reset(&dev->phy);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h b/drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h
index 0339abf360d3..94bed8a3a050 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h
@@ -463,6 +463,7 @@ int mt7915_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
 			  struct ieee80211_sta *sta,
 			  struct mt76_tx_info *tx_info);
 void mt7915_tx_complete_skb(struct mt76_dev *mdev, struct mt76_queue_entry *e);
+void mt7915_tx_token_put(struct mt7915_dev *dev);
 int mt7915_init_tx_queues(struct mt7915_phy *phy, int idx, int n_desc);
 void mt7915_queue_rx_skb(struct mt76_dev *mdev, enum mt76_rxq_id q,
 			 struct sk_buff *skb);
-- 
2.30.1



