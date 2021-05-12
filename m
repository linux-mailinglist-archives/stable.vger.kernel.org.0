Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64B4C37C9DD
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:48:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236777AbhELQXE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:23:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:58080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240462AbhELQSH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:18:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 583A861D74;
        Wed, 12 May 2021 15:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834253;
        bh=QVGmKyLAu1VLEa0grxvqfFi6Y/1TVYHFImckdqBGr0Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FkU47gPRlDhO/bzbxjYtBRTq1hIO4pMSRdzunqbbcirhqXVhihroEOXZCVtwZpDGP
         8pANGIMoaJECayBCkRt11xSV629PNS199Ag3Yr2c4VkJgzTDtN/V6yasF/sTfIWuoD
         RofyjSgQCLSCAbOTGRKVKWV4AlYHqoc2zGbg3HCQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ryder Lee <ryder.lee@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 470/601] mt76: mt7915: fix rxrate reporting
Date:   Wed, 12 May 2021 16:49:07 +0200
Message-Id: <20210512144843.328351900@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ryder Lee <ryder.lee@mediatek.com>

[ Upstream commit 7883906d22c1e73f1f316bd84fc4a7ff8edd12aa ]

Avoid directly updating sinfo->rxrate from firmware since rate_info might
be overwritten by wrong results even mt7915_mcu_get_rx_rate() fails check.

Add more error handlings accordingly.

Fixes: 11553d88d0b9 ("mt76: mt7915: query station rx rate from firmware")
Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7915/main.c  |  5 +-
 .../net/wireless/mediatek/mt76/mt7915/mcu.c   | 47 ++++++++++---------
 2 files changed, 30 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/main.c b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
index 2fa511ace45c..0721e9d85b65 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
@@ -833,9 +833,12 @@ static void mt7915_sta_statistics(struct ieee80211_hw *hw,
 	struct mt7915_phy *phy = mt7915_hw_phy(hw);
 	struct mt7915_sta *msta = (struct mt7915_sta *)sta->drv_priv;
 	struct mt7915_sta_stats *stats = &msta->stats;
+	struct rate_info rxrate = {};
 
-	if (mt7915_mcu_get_rx_rate(phy, vif, sta, &sinfo->rxrate) == 0)
+	if (!mt7915_mcu_get_rx_rate(phy, vif, sta, &rxrate)) {
+		sinfo->rxrate = rxrate;
 		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_RX_BITRATE);
+	}
 
 	if (!stats->tx_rate.legacy && !stats->tx_rate.flags)
 		return;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
index e211a2bd4d3c..ad71b8767c58 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -3469,9 +3469,8 @@ int mt7915_mcu_get_rx_rate(struct mt7915_phy *phy, struct ieee80211_vif *vif,
 	struct ieee80211_supported_band *sband;
 	struct mt7915_mcu_phy_rx_info *res;
 	struct sk_buff *skb;
-	u16 flags = 0;
 	int ret;
-	int i;
+	bool cck = false;
 
 	ret = mt76_mcu_send_and_get_msg(&dev->mt76, MCU_EXT_CMD_PHY_STAT_INFO,
 					&req, sizeof(req), true, &skb);
@@ -3485,48 +3484,53 @@ int mt7915_mcu_get_rx_rate(struct mt7915_phy *phy, struct ieee80211_vif *vif,
 
 	switch (res->mode) {
 	case MT_PHY_TYPE_CCK:
+		cck = true;
+		fallthrough;
 	case MT_PHY_TYPE_OFDM:
 		if (mphy->chandef.chan->band == NL80211_BAND_5GHZ)
 			sband = &mphy->sband_5g.sband;
 		else
 			sband = &mphy->sband_2g.sband;
 
-		for (i = 0; i < sband->n_bitrates; i++) {
-			if (rate->mcs != (sband->bitrates[i].hw_value & 0xf))
-				continue;
-
-			rate->legacy = sband->bitrates[i].bitrate;
-			break;
-		}
+		rate->mcs = mt76_get_rate(&dev->mt76, sband, rate->mcs, cck);
+		rate->legacy = sband->bitrates[rate->mcs].bitrate;
 		break;
 	case MT_PHY_TYPE_HT:
 	case MT_PHY_TYPE_HT_GF:
-		if (rate->mcs > 31)
-			return -EINVAL;
-
-		flags |= RATE_INFO_FLAGS_MCS;
+		if (rate->mcs > 31) {
+			ret = -EINVAL;
+			goto out;
+		}
 
+		rate->flags = RATE_INFO_FLAGS_MCS;
 		if (res->gi)
-			flags |= RATE_INFO_FLAGS_SHORT_GI;
+			rate->flags |= RATE_INFO_FLAGS_SHORT_GI;
 		break;
 	case MT_PHY_TYPE_VHT:
-		flags |= RATE_INFO_FLAGS_VHT_MCS;
+		if (rate->mcs > 9) {
+			ret = -EINVAL;
+			goto out;
+		}
 
+		rate->flags = RATE_INFO_FLAGS_VHT_MCS;
 		if (res->gi)
-			flags |= RATE_INFO_FLAGS_SHORT_GI;
+			rate->flags |= RATE_INFO_FLAGS_SHORT_GI;
 		break;
 	case MT_PHY_TYPE_HE_SU:
 	case MT_PHY_TYPE_HE_EXT_SU:
 	case MT_PHY_TYPE_HE_TB:
 	case MT_PHY_TYPE_HE_MU:
+		if (res->gi > NL80211_RATE_INFO_HE_GI_3_2 || rate->mcs > 11) {
+			ret = -EINVAL;
+			goto out;
+		}
 		rate->he_gi = res->gi;
-
-		flags |= RATE_INFO_FLAGS_HE_MCS;
+		rate->flags = RATE_INFO_FLAGS_HE_MCS;
 		break;
 	default:
-		break;
+		ret = -EINVAL;
+		goto out;
 	}
-	rate->flags = flags;
 
 	switch (res->bw) {
 	case IEEE80211_STA_RX_BW_160:
@@ -3543,7 +3547,8 @@ int mt7915_mcu_get_rx_rate(struct mt7915_phy *phy, struct ieee80211_vif *vif,
 		break;
 	}
 
+out:
 	dev_kfree_skb(skb);
 
-	return 0;
+	return ret;
 }
-- 
2.30.2



