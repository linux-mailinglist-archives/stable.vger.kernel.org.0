Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A794537CE3D
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:18:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239101AbhELRED (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 13:04:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:35488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236093AbhELQnM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:43:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6807461E60;
        Wed, 12 May 2021 16:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835984;
        bh=hjDRV1c7JCi4UmZzCkWKCeNRvIPF8johFIKLUDGLd1Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q9C1GGoACFy2u2FfzSeGcxnkuigf2AVeL7IV4nP7jALZ5tUA9P0jTj/kybw8kifGd
         ReAWPFWYUMDxPNVA6cYOIl1LUAS/V1APh78llp91nfwYsA8868AjTAqpRa4jfgq8bW
         VuEXKy1bKA+BeYB2bdOAcOBU3/ud6xQKzS7aY11w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 528/677] mt76: mt7615: fix mib stats counter reporting to mac80211
Date:   Wed, 12 May 2021 16:49:34 +0200
Message-Id: <20210512144854.925600854@linuxfoundation.org>
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
index e9c341e193f4..f594ea25ece6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
@@ -1825,10 +1825,8 @@ mt7615_mac_update_mib_stats(struct mt7615_phy *phy)
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
@@ -1841,24 +1839,16 @@ mt7615_mac_update_mib_stats(struct mt7615_phy *phy)
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
index ca74575569ae..8263ff81bb7b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/main.c
@@ -803,11 +803,17 @@ mt7615_get_stats(struct ieee80211_hw *hw,
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
index 491841bc6291..4bc0c379c579 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h
@@ -133,11 +133,11 @@ struct mt7615_vif {
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



