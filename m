Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 396F037CDD7
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:16:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239918AbhELQ6z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:58:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:33470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244278AbhELQmv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:42:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0DF1861D29;
        Wed, 12 May 2021 16:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835912;
        bh=n/drkzbpv5kORQkzPHiYtzf9uV2emDfLYV/qkXe8C5c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2XX1ABUG9WTcH92C7sSqm2+79r7KdgAtrAxYKmgmo0W9IXVq6NC6XG+DmzynoT646
         MlorELQd52pWJ7BsGMGyP5sLZH3Tgwk2gbwtguk/qmYBMTq2l8zVUBhoRXDwfQY+Q8
         LHgtdICvpwn6Dwh2b7/x1IOdmXHMY7fRhtKDT/OA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evelyn Tsai <evelyn.tsai@mediatek.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 535/677] mt76: mt7915: fix txrate reporting
Date:   Wed, 12 May 2021 16:49:41 +0200
Message-Id: <20210512144855.147581548@linuxfoundation.org>
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

[ Upstream commit f43b941fd61003659a3f0e039595e5e525917aa8 ]

Properly check rate_info to fix unexpected reporting.

[ 1215.161863] Call trace:
[ 1215.164307]  cfg80211_calculate_bitrate+0x124/0x200 [cfg80211]
[ 1215.170139]  ieee80211s_update_metric+0x80/0xc0 [mac80211]
[ 1215.175624]  ieee80211_tx_status_ext+0x508/0x838 [mac80211]
[ 1215.181190]  mt7915_mcu_get_rx_rate+0x28c/0x8d0 [mt7915e]
[ 1215.186580]  mt7915_mac_tx_free+0x324/0x7c0 [mt7915e]
[ 1215.191623]  mt7915_queue_rx_skb+0xa8/0xd0 [mt7915e]
[ 1215.196582]  mt76_dma_cleanup+0x7b0/0x11d0 [mt76]
[ 1215.201276]  __napi_poll+0x38/0xf8
[ 1215.204668]  napi_workfn+0x40/0x80
[ 1215.208062]  process_one_work+0x1fc/0x390
[ 1215.212062]  worker_thread+0x48/0x4d0
[ 1215.215715]  kthread+0x120/0x128
[ 1215.218935]  ret_from_fork+0x10/0x1c

Fixes: e57b7901469f ("mt76: add mac80211 driver for MT7915 PCIe-based chipsets")
Fixes: e4c5ead632ff ("mt76: mt7915: rename mt7915_mcu_get_rate_info to mt7915_mcu_get_tx_rate")
Reported-by: Evelyn Tsai <evelyn.tsai@mediatek.com>
Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7915/mcu.c   | 38 ++++++++++++-------
 1 file changed, 24 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
index ca3e7a9bbcb6..443cb09ae7cb 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -351,54 +351,62 @@ mt7915_mcu_rx_radar_detected(struct mt7915_dev *dev, struct sk_buff *skb)
 	dev->hw_pattern++;
 }
 
-static void
+static int
 mt7915_mcu_tx_rate_parse(struct mt76_phy *mphy, struct mt7915_mcu_ra_info *ra,
 			 struct rate_info *rate, u16 r)
 {
 	struct ieee80211_supported_band *sband;
 	u16 ru_idx = le16_to_cpu(ra->ru_idx);
-	u16 flags = 0;
+	bool cck = false;
 
 	rate->mcs = FIELD_GET(MT_RA_RATE_MCS, r);
 	rate->nss = FIELD_GET(MT_RA_RATE_NSS, r) + 1;
 
 	switch (FIELD_GET(MT_RA_RATE_TX_MODE, r)) {
 	case MT_PHY_TYPE_CCK:
+		cck = true;
+		fallthrough;
 	case MT_PHY_TYPE_OFDM:
 		if (mphy->chandef.chan->band == NL80211_BAND_5GHZ)
 			sband = &mphy->sband_5g.sband;
 		else
 			sband = &mphy->sband_2g.sband;
 
+		rate->mcs = mt76_get_rate(mphy->dev, sband, rate->mcs, cck);
 		rate->legacy = sband->bitrates[rate->mcs].bitrate;
 		break;
 	case MT_PHY_TYPE_HT:
 	case MT_PHY_TYPE_HT_GF:
 		rate->mcs += (rate->nss - 1) * 8;
-		flags |= RATE_INFO_FLAGS_MCS;
+		if (rate->mcs > 31)
+			return -EINVAL;
 
+		rate->flags = RATE_INFO_FLAGS_MCS;
 		if (ra->gi)
-			flags |= RATE_INFO_FLAGS_SHORT_GI;
+			rate->flags |= RATE_INFO_FLAGS_SHORT_GI;
 		break;
 	case MT_PHY_TYPE_VHT:
-		flags |= RATE_INFO_FLAGS_VHT_MCS;
+		if (rate->mcs > 9)
+			return -EINVAL;
 
+		rate->flags = RATE_INFO_FLAGS_VHT_MCS;
 		if (ra->gi)
-			flags |= RATE_INFO_FLAGS_SHORT_GI;
+			rate->flags |= RATE_INFO_FLAGS_SHORT_GI;
 		break;
 	case MT_PHY_TYPE_HE_SU:
 	case MT_PHY_TYPE_HE_EXT_SU:
 	case MT_PHY_TYPE_HE_TB:
 	case MT_PHY_TYPE_HE_MU:
+		if (ra->gi > NL80211_RATE_INFO_HE_GI_3_2 || rate->mcs > 11)
+			return -EINVAL;
+
 		rate->he_gi = ra->gi;
 		rate->he_dcm = FIELD_GET(MT_RA_RATE_DCM_EN, r);
-
-		flags |= RATE_INFO_FLAGS_HE_MCS;
+		rate->flags = RATE_INFO_FLAGS_HE_MCS;
 		break;
 	default:
-		break;
+		return -EINVAL;
 	}
-	rate->flags = flags;
 
 	if (ru_idx) {
 		switch (ru_idx) {
@@ -435,6 +443,8 @@ mt7915_mcu_tx_rate_parse(struct mt76_phy *mphy, struct mt7915_mcu_ra_info *ra,
 			break;
 		}
 	}
+
+	return 0;
 }
 
 static void
@@ -465,12 +475,12 @@ mt7915_mcu_tx_rate_report(struct mt7915_dev *dev, struct sk_buff *skb)
 		mphy = dev->mt76.phy2;
 
 	/* current rate */
-	mt7915_mcu_tx_rate_parse(mphy, ra, &rate, curr);
-	stats->tx_rate = rate;
+	if (!mt7915_mcu_tx_rate_parse(mphy, ra, &rate, curr))
+		stats->tx_rate = rate;
 
 	/* probing rate */
-	mt7915_mcu_tx_rate_parse(mphy, ra, &prob_rate, probe);
-	stats->prob_rate = prob_rate;
+	if (!mt7915_mcu_tx_rate_parse(mphy, ra, &prob_rate, probe))
+		stats->prob_rate = prob_rate;
 
 	if (attempts) {
 		u16 success = le16_to_cpu(ra->success);
-- 
2.30.2



