Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 710463C53EB
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348637AbhGLH4Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:56:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:37770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350772AbhGLHvS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:51:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0152D61156;
        Mon, 12 Jul 2021 07:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076095;
        bh=U/8ID9shn4XfjgQGe/5x+Qq7N4XKfmmwuXChBBj+SyA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RbVVvps/4IqLTiwL5YpZFvAnXifyL5fEBH0tMuTro8Y14ahOKICa2EXWHQ3hxSCtp
         IWOAwNb0LvgvhzMSSpEourVkHTZd81y6/DHYt7ffc4AZ9w+yTgNC0C+A/xjl4DOwUV
         uuaFtmxuB6KIMX6hazsaZAYMA2ojeqDgvaAwb9fM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Deren Wu <deren.wu@mediatek.com>,
        YN Chen <yn.chen@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 496/800] mt76: mt7921: add back connection monitor support
Date:   Mon, 12 Jul 2021 08:08:39 +0200
Message-Id: <20210712061019.969103096@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Wang <sean.wang@mediatek.com>

[ Upstream commit 10de032a31683585292cd10b598d896d7bcf276f ]

Hw beacon cmd to the mt7921 firmware doesn't only filter out the beacon,
but also performs its own connection monitoring, including periodic
keep-alives to the AP and probing the AP on beacon loss. Will indicate
the host with the event when the firmware detects the connection is lost.

Fixes: 1d8efc741df8 ("mt76: mt7921: introduce Runtime PM support")
Reviewed-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Deren Wu <deren.wu@mediatek.com>
Signed-off-by: YN Chen <yn.chen@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7921/init.c  |  4 +++
 .../net/wireless/mediatek/mt76/mt7921/mcu.c   | 32 +++++++++++++------
 2 files changed, 27 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/init.c b/drivers/net/wireless/mediatek/mt76/mt7921/init.c
index b85e46f5820f..2cb0252e63b2 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/init.c
@@ -73,6 +73,7 @@ static void
 mt7921_init_wiphy(struct ieee80211_hw *hw)
 {
 	struct mt7921_phy *phy = mt7921_hw_phy(hw);
+	struct mt7921_dev *dev = phy->dev;
 	struct wiphy *wiphy = hw->wiphy;
 
 	hw->queues = 4;
@@ -110,6 +111,9 @@ mt7921_init_wiphy(struct ieee80211_hw *hw)
 	ieee80211_hw_set(hw, SUPPORTS_PS);
 	ieee80211_hw_set(hw, SUPPORTS_DYNAMIC_PS);
 
+	if (dev->pm.enable)
+		ieee80211_hw_set(hw, CONNECTION_MONITOR);
+
 	hw->max_tx_fragments = 4;
 }
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
index 67dc4b4cc094..7c68182cad55 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
@@ -450,22 +450,33 @@ mt7921_mcu_scan_event(struct mt7921_dev *dev, struct sk_buff *skb)
 }
 
 static void
-mt7921_mcu_beacon_loss_event(struct mt7921_dev *dev, struct sk_buff *skb)
+mt7921_mcu_connection_loss_iter(void *priv, u8 *mac,
+				struct ieee80211_vif *vif)
+{
+	struct mt76_vif *mvif = (struct mt76_vif *)vif->drv_priv;
+	struct mt76_connac_beacon_loss_event *event = priv;
+
+	if (mvif->idx != event->bss_idx)
+		return;
+
+	if (!(vif->driver_flags & IEEE80211_VIF_BEACON_FILTER))
+		return;
+
+	ieee80211_connection_loss(vif);
+}
+
+static void
+mt7921_mcu_connection_loss_event(struct mt7921_dev *dev, struct sk_buff *skb)
 {
 	struct mt76_connac_beacon_loss_event *event;
-	struct mt76_phy *mphy;
-	u8 band_idx = 0; /* DBDC support */
+	struct mt76_phy *mphy = &dev->mt76.phy;
 
 	skb_pull(skb, sizeof(struct mt7921_mcu_rxd));
 	event = (struct mt76_connac_beacon_loss_event *)skb->data;
-	if (band_idx && dev->mt76.phy2)
-		mphy = dev->mt76.phy2;
-	else
-		mphy = &dev->mt76.phy;
 
 	ieee80211_iterate_active_interfaces_atomic(mphy->hw,
 					IEEE80211_IFACE_ITER_RESUME_ALL,
-					mt76_connac_mcu_beacon_loss_iter, event);
+					mt7921_mcu_connection_loss_iter, event);
 }
 
 static void
@@ -530,7 +541,7 @@ mt7921_mcu_rx_unsolicited_event(struct mt7921_dev *dev, struct sk_buff *skb)
 
 	switch (rxd->eid) {
 	case MCU_EVENT_BSS_BEACON_LOSS:
-		mt7921_mcu_beacon_loss_event(dev, skb);
+		mt7921_mcu_connection_loss_event(dev, skb);
 		break;
 	case MCU_EVENT_SCHED_SCAN_DONE:
 	case MCU_EVENT_SCAN_DONE:
@@ -1368,6 +1379,7 @@ mt7921_pm_interface_iter(void *priv, u8 *mac, struct ieee80211_vif *vif)
 {
 	struct mt7921_phy *phy = priv;
 	struct mt7921_dev *dev = phy->dev;
+	struct ieee80211_hw *hw = mt76_hw(dev);
 	int ret;
 
 	if (dev->pm.enable)
@@ -1380,9 +1392,11 @@ mt7921_pm_interface_iter(void *priv, u8 *mac, struct ieee80211_vif *vif)
 
 	if (dev->pm.enable) {
 		vif->driver_flags |= IEEE80211_VIF_BEACON_FILTER;
+		ieee80211_hw_set(hw, CONNECTION_MONITOR);
 		mt76_set(dev, MT_WF_RFCR(0), MT_WF_RFCR_DROP_OTHER_BEACON);
 	} else {
 		vif->driver_flags &= ~IEEE80211_VIF_BEACON_FILTER;
+		__clear_bit(IEEE80211_HW_CONNECTION_MONITOR, hw->flags);
 		mt76_clear(dev, MT_WF_RFCR(0), MT_WF_RFCR_DROP_OTHER_BEACON);
 	}
 }
-- 
2.30.2



