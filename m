Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52D2F2F670
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:56:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727953AbfE3DKI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:10:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:46330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727934AbfE3DKH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:10:07 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 03BE12449C;
        Thu, 30 May 2019 03:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185806;
        bh=8xBGESUFn3UVCKaqyVsEpQi+l94Wz03szF3aBDE3578=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ot6Vx71WeRmz83wbNX7esa7WlqIhO3hi7uRnex+Whw/5XLID4y5Vhn4ThUfa6F84P
         GratUOUdw3n2nskTh/OLCvAYAEsTGnQTshkZF5Tlw7kWoc+Y2iyu/U711Cf7gOOK0l
         r/H5FNv215uj92k3bXloJCMSAAu0LaNFobINaK/8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 087/405] mt76: remove mt76_queue dependency from tx_queue_skb function pointer
Date:   Wed, 29 May 2019 20:01:25 -0700
Message-Id: <20190530030545.431244569@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 89a37842b0c13c9e568bf12f4fcbe6507147e41d ]

Remove mt76_queue dependency from tx_queue_skb function pointer and
rely on mt76_tx_qid instead. This is a preliminary patch to introduce
mt76_sw_queue support

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/dma.c           |  3 ++-
 drivers/net/wireless/mediatek/mt76/mt76.h          |  4 ++--
 drivers/net/wireless/mediatek/mt76/mt7603/beacon.c |  6 +++---
 drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c  |  4 ++--
 drivers/net/wireless/mediatek/mt76/tx.c            | 10 +++++-----
 drivers/net/wireless/mediatek/mt76/usb.c           |  3 ++-
 6 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index 76629b98c78d7..8c7ee8302fb87 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -271,10 +271,11 @@ mt76_dma_tx_queue_skb_raw(struct mt76_dev *dev, enum mt76_txq_id qid,
 	return 0;
 }
 
-int mt76_dma_tx_queue_skb(struct mt76_dev *dev, struct mt76_queue *q,
+int mt76_dma_tx_queue_skb(struct mt76_dev *dev, enum mt76_txq_id qid,
 			  struct sk_buff *skb, struct mt76_wcid *wcid,
 			  struct ieee80211_sta *sta)
 {
+	struct mt76_queue *q = &dev->q_tx[qid];
 	struct mt76_queue_entry e;
 	struct mt76_txwi_cache *t;
 	struct mt76_queue_buf buf[32];
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index bcbfd3c4a44b6..eb882b2cbc0ec 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -156,7 +156,7 @@ struct mt76_queue_ops {
 		       struct mt76_queue_buf *buf, int nbufs, u32 info,
 		       struct sk_buff *skb, void *txwi);
 
-	int (*tx_queue_skb)(struct mt76_dev *dev, struct mt76_queue *q,
+	int (*tx_queue_skb)(struct mt76_dev *dev, enum mt76_txq_id qid,
 			    struct sk_buff *skb, struct mt76_wcid *wcid,
 			    struct ieee80211_sta *sta);
 
@@ -645,7 +645,7 @@ static inline struct mt76_tx_cb *mt76_tx_skb_cb(struct sk_buff *skb)
 	return ((void *) IEEE80211_SKB_CB(skb)->status.status_driver_data);
 }
 
-int mt76_dma_tx_queue_skb(struct mt76_dev *dev, struct mt76_queue *q,
+int mt76_dma_tx_queue_skb(struct mt76_dev *dev, enum mt76_txq_id qid,
 			  struct sk_buff *skb, struct mt76_wcid *wcid,
 			  struct ieee80211_sta *sta);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/beacon.c b/drivers/net/wireless/mediatek/mt76/mt7603/beacon.c
index 4dcb465095d19..99c0a3ba37cb7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/beacon.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/beacon.c
@@ -23,7 +23,7 @@ mt7603_update_beacon_iter(void *priv, u8 *mac, struct ieee80211_vif *vif)
 	if (!skb)
 		return;
 
-	mt76_dma_tx_queue_skb(&dev->mt76, &dev->mt76.q_tx[MT_TXQ_BEACON], skb,
+	mt76_dma_tx_queue_skb(&dev->mt76, MT_TXQ_BEACON, skb,
 			      &mvif->sta.wcid, NULL);
 
 	spin_lock_bh(&dev->ps_lock);
@@ -118,8 +118,8 @@ void mt7603_pre_tbtt_tasklet(unsigned long arg)
 		struct ieee80211_vif *vif = info->control.vif;
 		struct mt7603_vif *mvif = (struct mt7603_vif *)vif->drv_priv;
 
-		mt76_dma_tx_queue_skb(&dev->mt76, q, skb, &mvif->sta.wcid,
-				      NULL);
+		mt76_dma_tx_queue_skb(&dev->mt76, MT_TXQ_CAB, skb,
+				      &mvif->sta.wcid, NULL);
 	}
 	mt76_queue_kick(dev, q);
 	spin_unlock_bh(&q->lock);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
index daaed1220147e..952fe19cba9b6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
@@ -146,8 +146,8 @@ static void mt76x02_pre_tbtt_tasklet(unsigned long arg)
 		struct ieee80211_vif *vif = info->control.vif;
 		struct mt76x02_vif *mvif = (struct mt76x02_vif *)vif->drv_priv;
 
-		mt76_dma_tx_queue_skb(&dev->mt76, q, skb, &mvif->group_wcid,
-				      NULL);
+		mt76_dma_tx_queue_skb(&dev->mt76, MT_TXQ_PSD, skb,
+				      &mvif->group_wcid, NULL);
 	}
 	spin_unlock_bh(&q->lock);
 }
diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
index 2585df5123350..0c1036da9a92a 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -286,7 +286,7 @@ mt76_tx(struct mt76_dev *dev, struct ieee80211_sta *sta,
 	q = &dev->q_tx[qid];
 
 	spin_lock_bh(&q->lock);
-	dev->queue_ops->tx_queue_skb(dev, q, skb, wcid, sta);
+	dev->queue_ops->tx_queue_skb(dev, qid, skb, wcid, sta);
 	dev->queue_ops->kick(dev, q);
 
 	if (q->queued > q->ndesc - 8 && !q->stopped) {
@@ -327,7 +327,6 @@ mt76_queue_ps_skb(struct mt76_dev *dev, struct ieee80211_sta *sta,
 {
 	struct mt76_wcid *wcid = (struct mt76_wcid *) sta->drv_priv;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	struct mt76_queue *hwq = &dev->q_tx[MT_TXQ_PSD];
 
 	info->control.flags |= IEEE80211_TX_CTRL_PS_RESPONSE;
 	if (last)
@@ -335,7 +334,7 @@ mt76_queue_ps_skb(struct mt76_dev *dev, struct ieee80211_sta *sta,
 			       IEEE80211_TX_CTL_REQ_TX_STATUS;
 
 	mt76_skb_set_moredata(skb, !last);
-	dev->queue_ops->tx_queue_skb(dev, hwq, skb, wcid, sta);
+	dev->queue_ops->tx_queue_skb(dev, MT_TXQ_PSD, skb, wcid, sta);
 }
 
 void
@@ -390,6 +389,7 @@ mt76_txq_send_burst(struct mt76_dev *dev, struct mt76_queue *hwq,
 		    struct mt76_txq *mtxq, bool *empty)
 {
 	struct ieee80211_txq *txq = mtxq_to_txq(mtxq);
+	enum mt76_txq_id qid = mt76_txq_get_qid(txq);
 	struct ieee80211_tx_info *info;
 	struct mt76_wcid *wcid = mtxq->wcid;
 	struct sk_buff *skb;
@@ -423,7 +423,7 @@ mt76_txq_send_burst(struct mt76_dev *dev, struct mt76_queue *hwq,
 	if (ampdu)
 		mt76_check_agg_ssn(mtxq, skb);
 
-	idx = dev->queue_ops->tx_queue_skb(dev, hwq, skb, wcid, txq->sta);
+	idx = dev->queue_ops->tx_queue_skb(dev, qid, skb, wcid, txq->sta);
 
 	if (idx < 0)
 		return idx;
@@ -458,7 +458,7 @@ mt76_txq_send_burst(struct mt76_dev *dev, struct mt76_queue *hwq,
 		if (cur_ampdu)
 			mt76_check_agg_ssn(mtxq, skb);
 
-		idx = dev->queue_ops->tx_queue_skb(dev, hwq, skb, wcid,
+		idx = dev->queue_ops->tx_queue_skb(dev, qid, skb, wcid,
 						   txq->sta);
 		if (idx < 0)
 			return idx;
diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index 4c1abd4924054..b1551419338f0 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -726,10 +726,11 @@ mt76u_tx_build_sg(struct mt76_dev *dev, struct sk_buff *skb,
 }
 
 static int
-mt76u_tx_queue_skb(struct mt76_dev *dev, struct mt76_queue *q,
+mt76u_tx_queue_skb(struct mt76_dev *dev, enum mt76_txq_id qid,
 		   struct sk_buff *skb, struct mt76_wcid *wcid,
 		   struct ieee80211_sta *sta)
 {
+	struct mt76_queue *q = &dev->q_tx[qid];
 	struct mt76u_buf *buf;
 	u16 idx = q->tail;
 	int err;
-- 
2.20.1



