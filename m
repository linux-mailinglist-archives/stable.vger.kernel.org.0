Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8768737C9DA
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:48:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236714AbhELQWw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:22:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:51294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240440AbhELQSF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:18:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9439461C85;
        Wed, 12 May 2021 15:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834244;
        bh=0T0wkpVhrcJw+bomBbSdE35Rx7jjrSVLicVG+GFn088=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BwBvbaT/4O2oZDfzrBPj9dCJscXSzBPZcnKV493tNhdD1CA3KOgUPkve+Mt/wz1DI
         ujurQKZNdj3tVwn92RMNt1RZCy6HxATCoThAaHDaUqG65h/W36xhVZp10NIDbEgc+J
         f+D0drZATwDhhvFu1YhNg7L+GDJCPVc7X9NIDrMg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 466/601] mt76: mt7615: fix mib stats counter reporting to mac80211
Date:   Wed, 12 May 2021 16:49:03 +0200
Message-Id: <20210512144843.184027883@linuxfoundation.org>
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

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 2eb6f6c437745bce46bd7a8f3a22a732d5b9becb ]

In order to properly report MIB counters to mac80211, resets stats in
mt7615_get_stats routine and hold mt76 mutex accessing MIB counters.
Sum up MIB counters in mt7615_mac_update_mib_stats routine.

Fixes: c388d8584bc83 ("mt76: mt7615: add a get_stats() callback")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7615/mac.c   | 26 ++++++-------------
 .../net/wireless/mediatek/mt76/mt7615/main.c  |  6 +++++
 .../wireless/mediatek/mt76/mt7615/mt7615.h    | 10 +++----
 3 files changed, 19 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
index 34a88eab74ab..052d96f6fd66 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
@@ -1819,10 +1819,8 @@ mt7615_mac_update_mib_stats(struct mt7615_phy *phy)
 	int i, aggr;
 	u32 val, val2;
 
-	memset(mib, 0, sizeof(*mib));
-
-	mib->fcs_err_cnt = mt76_get_field(dev, MT_MIB_SDR3(ext_phy),
-					  MT_MIB_SDR3_FCS_ERR_MASK);
+	mib->fcs_err_cnt += mt76_get_field(dev, MT_MIB_SDR3(ext_phy),
+					   MT_MIB_SDR3_FCS_ERR_MASK);
 
 	val = mt76_get_field(dev, MT_MIB_SDR14(ext_phy),
 			     MT_MIB_AMPDU_MPDU_COUNT);
@@ -1835,24 +1833,16 @@ mt7615_mac_update_mib_stats(struct mt7615_phy *phy)
 	aggr = ext_phy ? ARRAY_SIZE(dev->mt76.aggr_stats) / 2 : 0;
 	for (i = 0; i < 4; i++) {
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
+		mib->ack_fail_cnt += FIELD_GET(MT_MIB_ACK_FAIL_COUNT_MASK,
+					       val);
 
 		val = mt76_rr(dev, MT_MIB_MB_SDR0(ext_phy, i));
-		val2 = FIELD_GET(MT_MIB_RTS_RETRIES_COUNT_MASK, val);
-		if (val2 > mib->rts_retries_cnt) {
-			mib->rts_cnt = FIELD_GET(MT_MIB_RTS_COUNT_MASK, val);
-			mib->rts_retries_cnt = val2;
-		}
+		mib->rts_cnt += FIELD_GET(MT_MIB_RTS_COUNT_MASK, val);
+		mib->rts_retries_cnt += FIELD_GET(MT_MIB_RTS_RETRIES_COUNT_MASK,
+						  val);
 
 		val = mt76_rr(dev, MT_TX_AGG_CNT(ext_phy, i));
-
 		dev->mt76.aggr_stats[aggr++] += val & 0xffff;
 		dev->mt76.aggr_stats[aggr++] += val >> 16;
 	}
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/main.c b/drivers/net/wireless/mediatek/mt76/mt7615/main.c
index 56dd0b4e4460..a42b4d96860d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/main.c
@@ -827,11 +827,17 @@ mt7615_get_stats(struct ieee80211_hw *hw,
 	struct mt7615_phy *phy = mt7615_hw_phy(hw);
 	struct mib_stats *mib = &phy->mib;
 
+	mt7615_mutex_acquire(phy->dev);
+
 	stats->dot11RTSSuccessCount = mib->rts_cnt;
 	stats->dot11RTSFailureCount = mib->rts_retries_cnt;
 	stats->dot11FCSErrorCount = mib->fcs_err_cnt;
 	stats->dot11ACKFailureCount = mib->ack_fail_cnt;
 
+	memset(mib, 0, sizeof(*mib));
+
+	mt7615_mutex_release(phy->dev);
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h b/drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h
index d697ff2ea56e..b56b82279f98 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h
@@ -143,11 +143,11 @@ struct mt7615_vif {
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
 	unsigned long aggr_per;
 };
 
-- 
2.30.2



