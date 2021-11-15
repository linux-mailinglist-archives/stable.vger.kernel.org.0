Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 784C4450F3E
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:25:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241208AbhKOS2F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:28:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:35520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241889AbhKOSZk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:25:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B4A076342A;
        Mon, 15 Nov 2021 17:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998954;
        bh=85i5/CtCbdDbEoZ2C8eeuIruaYrkv5rpVAakvtNBd4g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Os7nxA6gjZHvhmhOL4EsnkZt67bRVSNglRAfDLA3R8HnWFj2bDf4sQnrRQs8w9H75
         fndfcHfsoM/TB0Ljzk5phDBpj30lE7AHciem2iNEAm2XnrXOjB5VEZB1ofpklz/wjP
         j6q7IeNkjzR2xhUllSatLjLi7Jj+F/BnsEmNXHy8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 5.14 122/849] mt76: mt7615: fix skb use-after-free on mac reset
Date:   Mon, 15 Nov 2021 17:53:25 +0100
Message-Id: <20211115165424.223965198@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

commit b5cd1fd6043bbb7c5810067b5f93f3016bfd8a6f upstream.

When clearing all existing pending tx slots, mt76_tx_complete_skb needs to
be used to free the skbs, to ensure that they are cleared from the status
list as well.

Cc: stable@vger.kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c |   45 ++++++++++++------------
 1 file changed, 23 insertions(+), 22 deletions(-)

--- a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
@@ -1494,32 +1494,41 @@ out:
 }
 
 static void
-mt7615_mac_tx_free_token(struct mt7615_dev *dev, u16 token)
+mt7615_txwi_free(struct mt7615_dev *dev, struct mt76_txwi_cache *txwi)
 {
 	struct mt76_dev *mdev = &dev->mt76;
-	struct mt76_txwi_cache *txwi;
 	__le32 *txwi_data;
 	u32 val;
 	u8 wcid;
 
-	trace_mac_tx_free(dev, token);
-	txwi = mt76_token_put(mdev, token);
-	if (!txwi)
-		return;
+	mt7615_txp_skb_unmap(mdev, txwi);
+	if (!txwi->skb)
+		goto out;
 
 	txwi_data = (__le32 *)mt76_get_txwi_ptr(mdev, txwi);
 	val = le32_to_cpu(txwi_data[1]);
 	wcid = FIELD_GET(MT_TXD1_WLAN_IDX, val);
+	mt76_tx_complete_skb(mdev, wcid, txwi->skb);
 
-	mt7615_txp_skb_unmap(mdev, txwi);
-	if (txwi->skb) {
-		mt76_tx_complete_skb(mdev, wcid, txwi->skb);
-		txwi->skb = NULL;
-	}
-
+out:
+	txwi->skb = NULL;
 	mt76_put_txwi(mdev, txwi);
 }
 
+static void
+mt7615_mac_tx_free_token(struct mt7615_dev *dev, u16 token)
+{
+	struct mt76_dev *mdev = &dev->mt76;
+	struct mt76_txwi_cache *txwi;
+
+	trace_mac_tx_free(dev, token);
+	txwi = mt76_token_put(mdev, token);
+	if (!txwi)
+		return;
+
+	mt7615_txwi_free(dev, txwi);
+}
+
 static void mt7615_mac_tx_free(struct mt7615_dev *dev, struct sk_buff *skb)
 {
 	struct mt7615_tx_free *free = (struct mt7615_tx_free *)skb->data;
@@ -2026,16 +2035,8 @@ void mt7615_tx_token_put(struct mt7615_d
 	int id;
 
 	spin_lock_bh(&dev->mt76.token_lock);
-	idr_for_each_entry(&dev->mt76.token, txwi, id) {
-		mt7615_txp_skb_unmap(&dev->mt76, txwi);
-		if (txwi->skb) {
-			struct ieee80211_hw *hw;
-
-			hw = mt76_tx_status_get_hw(&dev->mt76, txwi->skb);
-			ieee80211_free_txskb(hw, txwi->skb);
-		}
-		mt76_put_txwi(&dev->mt76, txwi);
-	}
+	idr_for_each_entry(&dev->mt76.token, txwi, id)
+		mt7615_txwi_free(dev, txwi);
 	spin_unlock_bh(&dev->mt76.token_lock);
 	idr_destroy(&dev->mt76.token);
 }


