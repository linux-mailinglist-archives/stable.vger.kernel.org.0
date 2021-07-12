Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DE613C49E1
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:33:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238337AbhGLGrJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:47:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:45554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237797AbhGLGqb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:46:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F0126115A;
        Mon, 12 Jul 2021 06:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072137;
        bh=1weI87J3HuGB9Few8pYRG04Ft700xcnGZ+M+IMJ5ZAo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bvyp+++5EToLQdc97th3W3sz3xUOOeC2FYW913BjZDsqED3ieKQsql3G9Kykruf7s
         fqx3rosuaN8Jy6b5NQj2lOCFTcBFyRvpWV16es1/VgPUVC7nRVMFBdu+4rwzxY2n6O
         PXVlbKwLPdws83yIkClqOhRL48LVC2TBkDYvDn7M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 369/593] mt76: mt7615: fix NULL pointer dereference in tx_prepare_skb()
Date:   Mon, 12 Jul 2021 08:08:49 +0200
Message-Id: <20210712060927.257954202@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 8d3cdc1bbb1d355f0ebef973175ae5fd74286feb ]

Fix theoretical NULL pointer dereference in mt7615_tx_prepare_skb and
mt7663_usb_sdio_tx_prepare_skb routines. This issue has been identified
by code analysis.

Fixes: 6aa4ed7927f11 ("mt76: mt7615: implement DMA support for MT7622")
Fixes: 4bb586bc33b98 ("mt76: mt7663u: sync probe sampling with rate configuration")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/pci_mac.c  | 5 +++--
 drivers/net/wireless/mediatek/mt76/mt7615/usb_sdio.c | 5 +++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/pci_mac.c b/drivers/net/wireless/mediatek/mt76/mt7615/pci_mac.c
index 4cf7c5d34325..490d55651de3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/pci_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/pci_mac.c
@@ -133,20 +133,21 @@ int mt7615_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
 			  struct mt76_tx_info *tx_info)
 {
 	struct mt7615_dev *dev = container_of(mdev, struct mt7615_dev, mt76);
-	struct mt7615_sta *msta = container_of(wcid, struct mt7615_sta, wcid);
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx_info->skb);
 	struct ieee80211_key_conf *key = info->control.hw_key;
 	int pid, id;
 	u8 *txwi = (u8 *)txwi_ptr;
 	struct mt76_txwi_cache *t;
+	struct mt7615_sta *msta;
 	void *txp;
 
+	msta = wcid ? container_of(wcid, struct mt7615_sta, wcid) : NULL;
 	if (!wcid)
 		wcid = &dev->mt76.global_wcid;
 
 	pid = mt76_tx_status_skb_add(mdev, wcid, tx_info->skb);
 
-	if (info->flags & IEEE80211_TX_CTL_RATE_CTRL_PROBE) {
+	if ((info->flags & IEEE80211_TX_CTL_RATE_CTRL_PROBE) && msta) {
 		struct mt7615_phy *phy = &dev->phy;
 
 		if ((info->hw_queue & MT_TX_HW_QUEUE_EXT_PHY) && mdev->phy2)
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/usb_sdio.c b/drivers/net/wireless/mediatek/mt76/mt7615/usb_sdio.c
index 3b29a6d3dc64..18082b4ce7d3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/usb_sdio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/usb_sdio.c
@@ -243,14 +243,15 @@ int mt7663_usb_sdio_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
 				   struct ieee80211_sta *sta,
 				   struct mt76_tx_info *tx_info)
 {
-	struct mt7615_sta *msta = container_of(wcid, struct mt7615_sta, wcid);
 	struct mt7615_dev *dev = container_of(mdev, struct mt7615_dev, mt76);
 	struct sk_buff *skb = tx_info->skb;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct mt7615_sta *msta;
 	int pad;
 
+	msta = wcid ? container_of(wcid, struct mt7615_sta, wcid) : NULL;
 	if ((info->flags & IEEE80211_TX_CTL_RATE_CTRL_PROBE) &&
-	    !msta->rate_probe) {
+	    msta && !msta->rate_probe) {
 		/* request to configure sampling rate */
 		spin_lock_bh(&dev->mt76.lock);
 		mt7615_mac_set_rates(&dev->phy, msta, &info->control.rates[0],
-- 
2.30.2



