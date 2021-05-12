Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9190C37CE3A
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:18:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238558AbhELRD7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 13:03:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:35726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234447AbhELQm7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:42:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 025D561E56;
        Wed, 12 May 2021 16:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835962;
        bh=2KBY+xQ5kGYpXRDXbdysKXaYbyvf3w/MdV9zmfdRUlA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lGwzAhhYo3rrHZW2pSbw3Bg/17FmuLHNGtN/qSnkRTHugf050jGPnZi779DvW/lak
         VplTCshxXFqNnHdzgrbdSiru1twGmk/3DAomjMX1tO3X/T12Il/b4DDygb8t21pSNC
         WL73uGm4k+BKHLMxtPIeaEgUGRvKCHV4ETeXB6xk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ryder Lee <ryder.lee@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 527/677] mt76: mt7615: fix TSF configuration
Date:   Wed, 12 May 2021 16:49:33 +0200
Message-Id: <20210512144854.894068153@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ryder Lee <ryder.lee@mediatek.com>

[ Upstream commit a4a5a430b076860691e95337787bc666c8ab28ff ]

The index of TSF counters should follow HWBSSID.

Fixes: d8d59f66d136 ("mt76: mt7615: support 16 interfaces")
Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c  |  6 +++++-
 drivers/net/wireless/mediatek/mt76/mt7615/main.c | 16 ++++++++++++++--
 drivers/net/wireless/mediatek/mt76/mt7615/regs.h |  7 ++++---
 .../net/wireless/mediatek/mt76/mt7615/usb_sdio.c |  6 +++++-
 4 files changed, 28 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
index b313442b2d9e..e9c341e193f4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
@@ -966,6 +966,7 @@ void mt7615_mac_set_rates(struct mt7615_phy *phy, struct mt7615_sta *sta,
 	struct mt7615_dev *dev = phy->dev;
 	struct mt7615_rate_desc rd;
 	u32 w5, w27, addr;
+	u16 idx = sta->vif->mt76.omac_idx;
 
 	if (!mt76_is_mmio(&dev->mt76)) {
 		mt7615_mac_queue_rate_update(phy, sta, probe_rate, rates);
@@ -1017,7 +1018,10 @@ void mt7615_mac_set_rates(struct mt7615_phy *phy, struct mt7615_sta *sta,
 
 	mt76_wr(dev, addr + 27 * 4, w27);
 
-	mt76_set(dev, MT_LPON_T0CR, MT_LPON_T0CR_MODE); /* TSF read */
+	idx = idx > HW_BSSID_MAX ? HW_BSSID_0 : idx;
+	addr = idx > 1 ? MT_LPON_TCR2(idx): MT_LPON_TCR0(idx);
+
+	mt76_set(dev, addr, MT_LPON_TCR_MODE); /* TSF read */
 	sta->rate_set_tsf = mt76_rr(dev, MT_LPON_UTTR0) & ~BIT(0);
 	sta->rate_set_tsf |= rd.rateset;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/main.c b/drivers/net/wireless/mediatek/mt76/mt7615/main.c
index 25faf486d279..ca74575569ae 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/main.c
@@ -814,15 +814,21 @@ mt7615_get_stats(struct ieee80211_hw *hw,
 static u64
 mt7615_get_tsf(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 {
+	struct mt7615_vif *mvif = (struct mt7615_vif *)vif->drv_priv;
 	struct mt7615_dev *dev = mt7615_hw_dev(hw);
 	union {
 		u64 t64;
 		u32 t32[2];
 	} tsf;
+	u16 idx = mvif->mt76.omac_idx;
+	u32 reg;
+
+	idx = idx > HW_BSSID_MAX ? HW_BSSID_0 : idx;
+	reg = idx > 1 ? MT_LPON_TCR2(idx): MT_LPON_TCR0(idx);
 
 	mt7615_mutex_acquire(dev);
 
-	mt76_set(dev, MT_LPON_T0CR, MT_LPON_T0CR_MODE); /* TSF read */
+	mt76_set(dev, reg, MT_LPON_TCR_MODE); /* TSF read */
 	tsf.t32[0] = mt76_rr(dev, MT_LPON_UTTR0);
 	tsf.t32[1] = mt76_rr(dev, MT_LPON_UTTR1);
 
@@ -835,18 +841,24 @@ static void
 mt7615_set_tsf(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	       u64 timestamp)
 {
+	struct mt7615_vif *mvif = (struct mt7615_vif *)vif->drv_priv;
 	struct mt7615_dev *dev = mt7615_hw_dev(hw);
 	union {
 		u64 t64;
 		u32 t32[2];
 	} tsf = { .t64 = timestamp, };
+	u16 idx = mvif->mt76.omac_idx;
+	u32 reg;
+
+	idx = idx > HW_BSSID_MAX ? HW_BSSID_0 : idx;
+	reg = idx > 1 ? MT_LPON_TCR2(idx): MT_LPON_TCR0(idx);
 
 	mt7615_mutex_acquire(dev);
 
 	mt76_wr(dev, MT_LPON_UTTR0, tsf.t32[0]);
 	mt76_wr(dev, MT_LPON_UTTR1, tsf.t32[1]);
 	/* TSF software overwrite */
-	mt76_set(dev, MT_LPON_T0CR, MT_LPON_T0CR_WRITE);
+	mt76_set(dev, reg, MT_LPON_TCR_WRITE);
 
 	mt7615_mutex_release(dev);
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/regs.h b/drivers/net/wireless/mediatek/mt76/mt7615/regs.h
index 6e5db015b32c..6e4710d3ddd3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/regs.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/regs.h
@@ -447,9 +447,10 @@ enum mt7615_reg_base {
 
 #define MT_LPON(_n)			((dev)->reg_map[MT_LPON_BASE] + (_n))
 
-#define MT_LPON_T0CR			MT_LPON(0x010)
-#define MT_LPON_T0CR_MODE		GENMASK(1, 0)
-#define MT_LPON_T0CR_WRITE		BIT(0)
+#define MT_LPON_TCR0(_n)		MT_LPON(0x010 + ((_n) * 4))
+#define MT_LPON_TCR2(_n)		MT_LPON(0x0f8 + ((_n) - 2) * 4)
+#define MT_LPON_TCR_MODE		GENMASK(1, 0)
+#define MT_LPON_TCR_WRITE		BIT(0)
 
 #define MT_LPON_UTTR0			MT_LPON(0x018)
 #define MT_LPON_UTTR1			MT_LPON(0x01c)
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/usb_sdio.c b/drivers/net/wireless/mediatek/mt76/mt7615/usb_sdio.c
index 203256862dfd..4a370b9f7a17 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/usb_sdio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/usb_sdio.c
@@ -67,6 +67,7 @@ static int mt7663_usb_sdio_set_rates(struct mt7615_dev *dev,
 	struct mt7615_rate_desc *rate = &wrd->rate;
 	struct mt7615_sta *sta = wrd->sta;
 	u32 w5, w27, addr, val;
+	u16 idx = sta->vif->mt76.omac_idx;
 
 	lockdep_assert_held(&dev->mt76.mutex);
 
@@ -118,7 +119,10 @@ static int mt7663_usb_sdio_set_rates(struct mt7615_dev *dev,
 
 	sta->rate_probe = sta->rateset[rate->rateset].probe_rate.idx != -1;
 
-	mt76_set(dev, MT_LPON_T0CR, MT_LPON_T0CR_MODE); /* TSF read */
+	idx = idx > HW_BSSID_MAX ? HW_BSSID_0 : idx;
+	addr = idx > 1 ? MT_LPON_TCR2(idx): MT_LPON_TCR0(idx);
+
+	mt76_set(dev, addr, MT_LPON_TCR_MODE); /* TSF read */
 	val = mt76_rr(dev, MT_LPON_UTTR0);
 	sta->rate_set_tsf = (val & ~BIT(0)) | rate->rateset;
 
-- 
2.30.2



