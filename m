Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22ED437CE44
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:18:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239201AbhELRE1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 13:04:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:35700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236103AbhELQnM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:43:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC65F61E15;
        Wed, 12 May 2021 16:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835987;
        bh=C/KSMaBb2dEstc/EceDC4PvHThdEA4rZNMkt0UQyBv0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C4TCgeH0fxipseKsFTiJ57bAHNOPbvxD8nPG40uTdJ28hQtURrlReC8w+sVuG1p7E
         ANeLJoFJQDTx+MRgPzjVk7wDURFazFCMAR2HpBgTWuyuH0XWHEI+7GB9nLVseopPXQ
         a3uI2XK0CeYaDz7gj6QutCjUB87AKYqw1BPLwuGI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ryder Lee <ryder.lee@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 529/677] mt76: mt7915: fix mib stats counter reporting to mac80211
Date:   Wed, 12 May 2021 16:49:35 +0200
Message-Id: <20210512144854.955998765@linuxfoundation.org>
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

[ Upstream commit 2b35050a321865859fd2f12a3c18ed7be27858c9 ]

In order to properly report MIB counters to mac80211, resets stats in
mt7915_get_stats routine() and hold mt76 mutex accessing MIB counters.
Sum up MIB counters in mt7915_mac_update_mib_stats routine.

Fixes: e57b7901469f ("mt76: add mac80211 driver for MT7915 PCIe-based chipsets")
Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7915/mac.c   | 35 +++++++------------
 .../net/wireless/mediatek/mt76/mt7915/main.c  |  6 ++++
 .../wireless/mediatek/mt76/mt7915/mt7915.h    | 10 +++---
 3 files changed, 24 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
index b79d614aaad9..555274a2f436 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
@@ -1633,39 +1633,30 @@ mt7915_mac_update_mib_stats(struct mt7915_phy *phy)
 	bool ext_phy = phy != &dev->phy;
 	int i, aggr0, aggr1;
 
-	memset(mib, 0, sizeof(*mib));
-
-	mib->fcs_err_cnt = mt76_get_field(dev, MT_MIB_SDR3(ext_phy),
-					  MT_MIB_SDR3_FCS_ERR_MASK);
+	mib->fcs_err_cnt += mt76_get_field(dev, MT_MIB_SDR3(ext_phy),
+					   MT_MIB_SDR3_FCS_ERR_MASK);
 
 	aggr0 = ext_phy ? ARRAY_SIZE(dev->mt76.aggr_stats) / 2 : 0;
 	for (i = 0, aggr1 = aggr0 + 4; i < 4; i++) {
-		u32 val, val2;
+		u32 val;
 
 		val = mt76_rr(dev, MT_MIB_MB_SDR1(ext_phy, i));
-
-		val2 = FIELD_GET(MT_MIB_ACK_FAIL_COUNT_MASK, val);
-		if (val2 > mib->ack_fail_cnt)
-			mib->ack_fail_cnt = val2;
-
-		val2 = FIELD_GET(MT_MIB_BA_MISS_COUNT_MASK, val);
-		if (val2 > mib->ba_miss_cnt)
-			mib->ba_miss_cnt = val2;
+		mib->ba_miss_cnt += FIELD_GET(MT_MIB_BA_MISS_COUNT_MASK, val);
+		mib->ack_fail_cnt +=
+			FIELD_GET(MT_MIB_ACK_FAIL_COUNT_MASK, val);
 
 		val = mt76_rr(dev, MT_MIB_MB_SDR0(ext_phy, i));
-		val2 = FIELD_GET(MT_MIB_RTS_RETRIES_COUNT_MASK, val);
-		if (val2 > mib->rts_retries_cnt) {
-			mib->rts_cnt = FIELD_GET(MT_MIB_RTS_COUNT_MASK, val);
-			mib->rts_retries_cnt = val2;
-		}
+		mib->rts_cnt += FIELD_GET(MT_MIB_RTS_COUNT_MASK, val);
+		mib->rts_retries_cnt +=
+			FIELD_GET(MT_MIB_RTS_RETRIES_COUNT_MASK, val);
 
 		val = mt76_rr(dev, MT_TX_AGG_CNT(ext_phy, i));
-		val2 = mt76_rr(dev, MT_TX_AGG_CNT2(ext_phy, i));
-
 		dev->mt76.aggr_stats[aggr0++] += val & 0xffff;
 		dev->mt76.aggr_stats[aggr0++] += val >> 16;
-		dev->mt76.aggr_stats[aggr1++] += val2 & 0xffff;
-		dev->mt76.aggr_stats[aggr1++] += val2 >> 16;
+
+		val = mt76_rr(dev, MT_TX_AGG_CNT2(ext_phy, i));
+		dev->mt76.aggr_stats[aggr1++] += val & 0xffff;
+		dev->mt76.aggr_stats[aggr1++] += val >> 16;
 	}
 }
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/main.c b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
index d4969b2e1ffb..8c1bf397fd25 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
@@ -717,13 +717,19 @@ mt7915_get_stats(struct ieee80211_hw *hw,
 		 struct ieee80211_low_level_stats *stats)
 {
 	struct mt7915_phy *phy = mt7915_hw_phy(hw);
+	struct mt7915_dev *dev = mt7915_hw_dev(hw);
 	struct mib_stats *mib = &phy->mib;
 
+	mutex_lock(&dev->mt76.mutex);
 	stats->dot11RTSSuccessCount = mib->rts_cnt;
 	stats->dot11RTSFailureCount = mib->rts_retries_cnt;
 	stats->dot11FCSErrorCount = mib->fcs_err_cnt;
 	stats->dot11ACKFailureCount = mib->ack_fail_cnt;
 
+	memset(mib, 0, sizeof(*mib));
+
+	mutex_unlock(&dev->mt76.mutex);
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h b/drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h
index 5c7eefdf2013..1160d1bf8a7c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h
@@ -108,11 +108,11 @@ struct mt7915_vif {
 };
 
 struct mib_stats {
-	u16 ack_fail_cnt;
-	u16 fcs_err_cnt;
-	u16 rts_cnt;
-	u16 rts_retries_cnt;
-	u16 ba_miss_cnt;
+	u32 ack_fail_cnt;
+	u32 fcs_err_cnt;
+	u32 rts_cnt;
+	u32 rts_retries_cnt;
+	u32 ba_miss_cnt;
 };
 
 struct mt7915_hif {
-- 
2.30.2



