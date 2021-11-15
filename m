Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E412C450BB9
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:26:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236737AbhKOR3T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:29:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:50934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237828AbhKOR02 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:26:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7D136325D;
        Mon, 15 Nov 2021 17:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996686;
        bh=KJ/VXmUshvt4YkoR1haYv/EuljwzbtgKLxKB04yihFc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ffQMjr0FwH3t3WqRkFZWm2d34RIDMVrlOnFi0IMZkDZHs+9lREkoIZzFryIsPUDkc
         m8w7t+Xf1s6HODVzmYSyCDgDDPd+q/6x3xBSpzINUiGmZ50/91X04c3FUqJCPUTGHA
         FcwEwQ3QJTbGWR8ioPRKTN6Bu0GrH91aV603pdPE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 230/355] mt76: mt76x02: fix endianness warnings in mt76x02_mac.c
Date:   Mon, 15 Nov 2021 18:02:34 +0100
Message-Id: <20211115165321.195094888@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit c33edef520213feccebc22c9474c685b9fb60611 ]

Fix the following sparse warning in mt76x02_mac_write_txwi and
mt76x02_mac_tx_rate_val routines:
drivers/net/wireless/mediatek/mt76/mt76x02_mac.c:237:19:
	warning: restricted __le16 degrades to intege
	warning: cast from restricted __le16
drivers/net/wireless/mediatek/mt76/mt76x02_mac.c:383:28:
	warning: incorrect type in assignment (different base types)
	expected restricted __le16 [usertype] rate
	got unsigned long

Fixes: db9f11d3433f7 ("mt76: store wcid tx rate info in one u32 reduce locking")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
index abacb4ea7179d..5c12cd7fce940 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -154,7 +154,7 @@ void mt76x02_mac_wcid_set_drop(struct mt76x02_dev *dev, u8 idx, bool drop)
 		mt76_wr(dev, MT_WCID_DROP(idx), (val & ~bit) | (bit * drop));
 }
 
-static __le16
+static u16
 mt76x02_mac_tx_rate_val(struct mt76x02_dev *dev,
 			const struct ieee80211_tx_rate *rate, u8 *nss_val)
 {
@@ -200,14 +200,14 @@ mt76x02_mac_tx_rate_val(struct mt76x02_dev *dev,
 		rateval |= MT_RXWI_RATE_SGI;
 
 	*nss_val = nss;
-	return cpu_to_le16(rateval);
+	return rateval;
 }
 
 void mt76x02_mac_wcid_set_rate(struct mt76x02_dev *dev, struct mt76_wcid *wcid,
 			       const struct ieee80211_tx_rate *rate)
 {
 	s8 max_txpwr_adj = mt76x02_tx_get_max_txpwr_adj(dev, rate);
-	__le16 rateval;
+	u16 rateval;
 	u32 tx_info;
 	s8 nss;
 
@@ -320,7 +320,7 @@ void mt76x02_mac_write_txwi(struct mt76x02_dev *dev, struct mt76x02_txwi *txwi,
 	struct ieee80211_key_conf *key = info->control.hw_key;
 	u32 wcid_tx_info;
 	u16 rate_ht_mask = FIELD_PREP(MT_RXWI_RATE_PHY, BIT(1) | BIT(2));
-	u16 txwi_flags = 0;
+	u16 txwi_flags = 0, rateval;
 	u8 nss;
 	s8 txpwr_adj, max_txpwr_adj;
 	u8 ccmp_pn[8], nstreams = dev->mt76.chainmask & 0xf;
@@ -356,14 +356,15 @@ void mt76x02_mac_write_txwi(struct mt76x02_dev *dev, struct mt76x02_txwi *txwi,
 
 	if (wcid && (rate->idx < 0 || !rate->count)) {
 		wcid_tx_info = wcid->tx_info;
-		txwi->rate = FIELD_GET(MT_WCID_TX_INFO_RATE, wcid_tx_info);
+		rateval = FIELD_GET(MT_WCID_TX_INFO_RATE, wcid_tx_info);
 		max_txpwr_adj = FIELD_GET(MT_WCID_TX_INFO_TXPWR_ADJ,
 					  wcid_tx_info);
 		nss = FIELD_GET(MT_WCID_TX_INFO_NSS, wcid_tx_info);
 	} else {
-		txwi->rate = mt76x02_mac_tx_rate_val(dev, rate, &nss);
+		rateval = mt76x02_mac_tx_rate_val(dev, rate, &nss);
 		max_txpwr_adj = mt76x02_tx_get_max_txpwr_adj(dev, rate);
 	}
+	txwi->rate = cpu_to_le16(rateval);
 
 	txpwr_adj = mt76x02_tx_get_txpwr_adj(dev, dev->mt76.txpower_conf,
 					     max_txpwr_adj);
-- 
2.33.0



