Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6536F37CDD5
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:16:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239818AbhELQ6v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:58:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:34162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244275AbhELQmv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:42:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E485061D40;
        Wed, 12 May 2021 16:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835935;
        bh=MpxhMahEBC0yECHXFSyoHxnv6tvQx/d3vzPZM1xILo0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nbi44OfWvX0mXSpp+zcvQvbA/OkJhvyaxZJKvqyjlZyONtX7th1pEL/LfqktMfxmn
         rJSKs9LVoM/IlTH/7sznB8ZHvvyXChfgYmL4pbEzU1MTgenBG0h3kGFZEyb/uytAbX
         1NVNbW8ZpVsIifDoeSZec7T4VleWD9l80LxbQF1o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 526/677] mt76: mt7921: fix stats register definitions
Date:   Wed, 12 May 2021 16:49:32 +0200
Message-Id: <20210512144854.862501953@linuxfoundation.org>
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

[ Upstream commit f76e9019913bffee0e49b096068e6f6b12f9b0e0 ]

Fix register definitions for mac80211 stats reporting.
Move mib counter reset to mt7921_get_stats routine.

Fixes: 163f4d22c118d ("mt76: mt7921: add MAC support")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7921/mac.c   | 31 ++++++-------------
 .../net/wireless/mediatek/mt76/mt7921/main.c  |  6 ++++
 .../wireless/mediatek/mt76/mt7921/mt7921.h    | 10 +++---
 .../net/wireless/mediatek/mt76/mt7921/regs.h  | 15 ++++++---
 4 files changed, 31 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
index b4388a290753..a6d2a25b3495 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
@@ -1318,31 +1318,20 @@ mt7921_mac_update_mib_stats(struct mt7921_phy *phy)
 	struct mib_stats *mib = &phy->mib;
 	int i, aggr0 = 0, aggr1;
 
-	memset(mib, 0, sizeof(*mib));
-
-	mib->fcs_err_cnt = mt76_get_field(dev, MT_MIB_SDR3(0),
-					  MT_MIB_SDR3_FCS_ERR_MASK);
+	mib->fcs_err_cnt += mt76_get_field(dev, MT_MIB_SDR3(0),
+					   MT_MIB_SDR3_FCS_ERR_MASK);
+	mib->ack_fail_cnt += mt76_get_field(dev, MT_MIB_MB_BSDR3(0),
+					    MT_MIB_ACK_FAIL_COUNT_MASK);
+	mib->ba_miss_cnt += mt76_get_field(dev, MT_MIB_MB_BSDR2(0),
+					   MT_MIB_BA_FAIL_COUNT_MASK);
+	mib->rts_cnt += mt76_get_field(dev, MT_MIB_MB_BSDR0(0),
+				       MT_MIB_RTS_COUNT_MASK);
+	mib->rts_retries_cnt += mt76_get_field(dev, MT_MIB_MB_BSDR1(0),
+					       MT_MIB_RTS_FAIL_COUNT_MASK);
 
 	for (i = 0, aggr1 = aggr0 + 4; i < 4; i++) {
 		u32 val, val2;
 
-		val = mt76_rr(dev, MT_MIB_MB_SDR1(0, i));
-
-		val2 = FIELD_GET(MT_MIB_ACK_FAIL_COUNT_MASK, val);
-		if (val2 > mib->ack_fail_cnt)
-			mib->ack_fail_cnt = val2;
-
-		val2 = FIELD_GET(MT_MIB_BA_MISS_COUNT_MASK, val);
-		if (val2 > mib->ba_miss_cnt)
-			mib->ba_miss_cnt = val2;
-
-		val = mt76_rr(dev, MT_MIB_MB_SDR0(0, i));
-		val2 = FIELD_GET(MT_MIB_RTS_RETRIES_COUNT_MASK, val);
-		if (val2 > mib->rts_retries_cnt) {
-			mib->rts_cnt = FIELD_GET(MT_MIB_RTS_COUNT_MASK, val);
-			mib->rts_retries_cnt = val2;
-		}
-
 		val = mt76_rr(dev, MT_TX_AGG_CNT(0, i));
 		val2 = mt76_rr(dev, MT_TX_AGG_CNT2(0, i));
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/main.c b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
index 729f6c42cdde..3566059e5704 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
@@ -814,11 +814,17 @@ mt7921_get_stats(struct ieee80211_hw *hw,
 	struct mt7921_phy *phy = mt7921_hw_phy(hw);
 	struct mib_stats *mib = &phy->mib;
 
+	mt7921_mutex_acquire(phy->dev);
+
 	stats->dot11RTSSuccessCount = mib->rts_cnt;
 	stats->dot11RTSFailureCount = mib->rts_retries_cnt;
 	stats->dot11FCSErrorCount = mib->fcs_err_cnt;
 	stats->dot11ACKFailureCount = mib->ack_fail_cnt;
 
+	memset(mib, 0, sizeof(*mib));
+
+	mt7921_mutex_release(phy->dev);
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h b/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
index 46e6aeec35ae..2979d06ee0ad 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
@@ -102,11 +102,11 @@ struct mt7921_vif {
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
 
 struct mt7921_phy {
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/regs.h b/drivers/net/wireless/mediatek/mt76/mt7921/regs.h
index 11d5aa44ae7b..2dd2e628b776 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/regs.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/regs.h
@@ -96,8 +96,8 @@
 #define MT_WF_MIB_BASE(_band)		((_band) ? 0xa4800 : 0x24800)
 #define MT_WF_MIB(_band, ofs)		(MT_WF_MIB_BASE(_band) + (ofs))
 
-#define MT_MIB_SDR3(_band)		MT_WF_MIB(_band, 0x014)
-#define MT_MIB_SDR3_FCS_ERR_MASK	GENMASK(15, 0)
+#define MT_MIB_SDR3(_band)		MT_WF_MIB(_band, 0x698)
+#define MT_MIB_SDR3_FCS_ERR_MASK	GENMASK(31, 16)
 
 #define MT_MIB_SDR9(_band)		MT_WF_MIB(_band, 0x02c)
 #define MT_MIB_SDR9_BUSY_MASK		GENMASK(23, 0)
@@ -121,9 +121,14 @@
 #define MT_MIB_RTS_RETRIES_COUNT_MASK	GENMASK(31, 16)
 #define MT_MIB_RTS_COUNT_MASK		GENMASK(15, 0)
 
-#define MT_MIB_MB_SDR1(_band, n)	MT_WF_MIB(_band, 0x104 + ((n) << 4))
-#define MT_MIB_BA_MISS_COUNT_MASK	GENMASK(15, 0)
-#define MT_MIB_ACK_FAIL_COUNT_MASK	GENMASK(31, 16)
+#define MT_MIB_MB_BSDR0(_band)		MT_WF_MIB(_band, 0x688)
+#define MT_MIB_RTS_COUNT_MASK		GENMASK(15, 0)
+#define MT_MIB_MB_BSDR1(_band)		MT_WF_MIB(_band, 0x690)
+#define MT_MIB_RTS_FAIL_COUNT_MASK	GENMASK(15, 0)
+#define MT_MIB_MB_BSDR2(_band)		MT_WF_MIB(_band, 0x518)
+#define MT_MIB_BA_FAIL_COUNT_MASK	GENMASK(15, 0)
+#define MT_MIB_MB_BSDR3(_band)		MT_WF_MIB(_band, 0x520)
+#define MT_MIB_ACK_FAIL_COUNT_MASK	GENMASK(15, 0)
 
 #define MT_MIB_MB_SDR2(_band, n)	MT_WF_MIB(_band, 0x108 + ((n) << 4))
 #define MT_MIB_FRAME_RETRIES_COUNT_MASK	GENMASK(15, 0)
-- 
2.30.2



