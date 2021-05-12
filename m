Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A41B37CDC8
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:16:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343726AbhELQ6J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:58:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:36672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244182AbhELQmk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:42:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DBE8561C67;
        Wed, 12 May 2021 16:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835885;
        bh=CrIZvZ+YAT/AwztQX3d4Sl6iNx5lTiJUyGNxvJDeXr8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fAeYBGfh0iAK1IirDzuYauBNkF/189AsheUELUKaaf6usgqYTEo3Vtnctc3TJ1OMj
         RV+VBj9v7DmbZAgxM/i5Ozb0WCKAQCXB4YBhBndilJ5i4xt7uy7bkgJhEIAqLtsqo0
         fPmOtSoIV/FqTLyskmdSQdy0XLlxYA3DYgek9J6A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Wang <sean.wang@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 522/677] mt76: mt7921: fixup rx bitrate statistics
Date:   Wed, 12 May 2021 16:49:28 +0200
Message-Id: <20210512144854.730590260@linuxfoundation.org>
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

From: Sean Wang <sean.wang@mediatek.com>

[ Upstream commit 0940605a2a70803fc3362eeccba4c31adf4e70e7 ]

Since the related rx bitrate fields have been moved to group3 in Rxv,
fix rx bitrate statistics in mt7921_mac_fill_rx routine.

Fixes: 163f4d22c118d ("mt76: mt7921: add MAC support")
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7921/mac.c   | 155 +++++++++---------
 .../net/wireless/mediatek/mt76/mt7921/mac.h   |  10 +-
 2 files changed, 86 insertions(+), 79 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
index d51ec8a550d8..b4388a290753 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
@@ -400,7 +400,9 @@ int mt7921_mac_fill_rx(struct mt7921_dev *dev, struct sk_buff *skb)
 
 	/* RXD Group 3 - P-RXV */
 	if (rxd1 & MT_RXD1_NORMAL_GROUP_3) {
-		u32 v0, v1, v2;
+		u8 stbc, gi;
+		u32 v0, v1;
+		bool cck;
 
 		rxv = rxd;
 		rxd += 2;
@@ -409,7 +411,6 @@ int mt7921_mac_fill_rx(struct mt7921_dev *dev, struct sk_buff *skb)
 
 		v0 = le32_to_cpu(rxv[0]);
 		v1 = le32_to_cpu(rxv[1]);
-		v2 = le32_to_cpu(rxv[2]);
 
 		if (v0 & MT_PRXV_HT_AD_CODE)
 			status->enc_flags |= RX_ENC_FLAG_LDPC;
@@ -429,87 +430,87 @@ int mt7921_mac_fill_rx(struct mt7921_dev *dev, struct sk_buff *skb)
 					     status->chain_signal[i]);
 		}
 
-		/* RXD Group 5 - C-RXV */
-		if (rxd1 & MT_RXD1_NORMAL_GROUP_5) {
-			u8 stbc = FIELD_GET(MT_CRXV_HT_STBC, v2);
-			u8 gi = FIELD_GET(MT_CRXV_HT_SHORT_GI, v2);
-			bool cck = false;
+		stbc = FIELD_GET(MT_PRXV_STBC, v0);
+		gi = FIELD_GET(MT_PRXV_SGI, v0);
+		cck = false;
 
-			rxd += 18;
-			if ((u8 *)rxd - skb->data >= skb->len)
-				return -EINVAL;
+		idx = i = FIELD_GET(MT_PRXV_TX_RATE, v0);
+		mode = FIELD_GET(MT_PRXV_TX_MODE, v0);
 
-			idx = i = FIELD_GET(MT_PRXV_TX_RATE, v0);
-			mode = FIELD_GET(MT_CRXV_TX_MODE, v2);
-
-			switch (mode) {
-			case MT_PHY_TYPE_CCK:
-				cck = true;
-				fallthrough;
-			case MT_PHY_TYPE_OFDM:
-				i = mt76_get_rate(&dev->mt76, sband, i, cck);
-				break;
-			case MT_PHY_TYPE_HT_GF:
-			case MT_PHY_TYPE_HT:
-				status->encoding = RX_ENC_HT;
-				if (i > 31)
-					return -EINVAL;
-				break;
-			case MT_PHY_TYPE_VHT:
-				status->nss =
-					FIELD_GET(MT_PRXV_NSTS, v0) + 1;
-				status->encoding = RX_ENC_VHT;
-				if (i > 9)
-					return -EINVAL;
-				break;
-			case MT_PHY_TYPE_HE_MU:
-				status->flag |= RX_FLAG_RADIOTAP_HE_MU;
-				fallthrough;
-			case MT_PHY_TYPE_HE_SU:
-			case MT_PHY_TYPE_HE_EXT_SU:
-			case MT_PHY_TYPE_HE_TB:
-				status->nss =
-					FIELD_GET(MT_PRXV_NSTS, v0) + 1;
-				status->encoding = RX_ENC_HE;
-				status->flag |= RX_FLAG_RADIOTAP_HE;
-				i &= GENMASK(3, 0);
-
-				if (gi <= NL80211_RATE_INFO_HE_GI_3_2)
-					status->he_gi = gi;
-
-				status->he_dcm = !!(idx & MT_PRXV_TX_DCM);
-				break;
-			default:
+		switch (mode) {
+		case MT_PHY_TYPE_CCK:
+			cck = true;
+			fallthrough;
+		case MT_PHY_TYPE_OFDM:
+			i = mt76_get_rate(&dev->mt76, sband, i, cck);
+			break;
+		case MT_PHY_TYPE_HT_GF:
+		case MT_PHY_TYPE_HT:
+			status->encoding = RX_ENC_HT;
+			if (i > 31)
 				return -EINVAL;
-			}
-			status->rate_idx = i;
-
-			switch (FIELD_GET(MT_CRXV_FRAME_MODE, v2)) {
-			case IEEE80211_STA_RX_BW_20:
-				break;
-			case IEEE80211_STA_RX_BW_40:
-				if (mode & MT_PHY_TYPE_HE_EXT_SU &&
-				    (idx & MT_PRXV_TX_ER_SU_106T)) {
-					status->bw = RATE_INFO_BW_HE_RU;
-					status->he_ru =
-						NL80211_RATE_INFO_HE_RU_ALLOC_106;
-				} else {
-					status->bw = RATE_INFO_BW_40;
-				}
-				break;
-			case IEEE80211_STA_RX_BW_80:
-				status->bw = RATE_INFO_BW_80;
-				break;
-			case IEEE80211_STA_RX_BW_160:
-				status->bw = RATE_INFO_BW_160;
-				break;
-			default:
+			break;
+		case MT_PHY_TYPE_VHT:
+			status->nss =
+				FIELD_GET(MT_PRXV_NSTS, v0) + 1;
+			status->encoding = RX_ENC_VHT;
+			if (i > 9)
 				return -EINVAL;
+			break;
+		case MT_PHY_TYPE_HE_MU:
+			status->flag |= RX_FLAG_RADIOTAP_HE_MU;
+			fallthrough;
+		case MT_PHY_TYPE_HE_SU:
+		case MT_PHY_TYPE_HE_EXT_SU:
+		case MT_PHY_TYPE_HE_TB:
+			status->nss =
+				FIELD_GET(MT_PRXV_NSTS, v0) + 1;
+			status->encoding = RX_ENC_HE;
+			status->flag |= RX_FLAG_RADIOTAP_HE;
+			i &= GENMASK(3, 0);
+
+			if (gi <= NL80211_RATE_INFO_HE_GI_3_2)
+				status->he_gi = gi;
+
+			status->he_dcm = !!(idx & MT_PRXV_TX_DCM);
+			break;
+		default:
+			return -EINVAL;
+		}
+
+		status->rate_idx = i;
+
+		switch (FIELD_GET(MT_PRXV_FRAME_MODE, v0)) {
+		case IEEE80211_STA_RX_BW_20:
+			break;
+		case IEEE80211_STA_RX_BW_40:
+			if (mode & MT_PHY_TYPE_HE_EXT_SU &&
+			    (idx & MT_PRXV_TX_ER_SU_106T)) {
+				status->bw = RATE_INFO_BW_HE_RU;
+				status->he_ru =
+					NL80211_RATE_INFO_HE_RU_ALLOC_106;
+			} else {
+				status->bw = RATE_INFO_BW_40;
 			}
+			break;
+		case IEEE80211_STA_RX_BW_80:
+			status->bw = RATE_INFO_BW_80;
+			break;
+		case IEEE80211_STA_RX_BW_160:
+			status->bw = RATE_INFO_BW_160;
+			break;
+		default:
+			return -EINVAL;
+		}
+
+		status->enc_flags |= RX_ENC_FLAG_STBC_MASK * stbc;
+		if (mode < MT_PHY_TYPE_HE_SU && gi)
+			status->enc_flags |= RX_ENC_FLAG_SHORT_GI;
 
-			status->enc_flags |= RX_ENC_FLAG_STBC_MASK * stbc;
-			if (mode < MT_PHY_TYPE_HE_SU && gi)
-				status->enc_flags |= RX_ENC_FLAG_SHORT_GI;
+		if (rxd1 & MT_RXD1_NORMAL_GROUP_5) {
+			rxd += 18;
+			if ((u8 *)rxd - skb->data >= skb->len)
+				return -EINVAL;
 		}
 	}
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mac.h b/drivers/net/wireless/mediatek/mt76/mt7921/mac.h
index a0c1fa0f20e4..109c8849d106 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mac.h
@@ -97,18 +97,24 @@ enum rx_pkt_type {
 #define MT_RXD3_NORMAL_PF_MODE		BIT(29)
 #define MT_RXD3_NORMAL_PF_STS		GENMASK(31, 30)
 
-/* P-RXV */
+/* P-RXV DW0 */
 #define MT_PRXV_TX_RATE			GENMASK(6, 0)
 #define MT_PRXV_TX_DCM			BIT(4)
 #define MT_PRXV_TX_ER_SU_106T		BIT(5)
 #define MT_PRXV_NSTS			GENMASK(9, 7)
 #define MT_PRXV_HT_AD_CODE		BIT(11)
+#define MT_PRXV_FRAME_MODE		GENMASK(14, 12)
+#define MT_PRXV_SGI			GENMASK(16, 15)
+#define MT_PRXV_STBC			GENMASK(23, 22)
+#define MT_PRXV_TX_MODE			GENMASK(27, 24)
 #define MT_PRXV_HE_RU_ALLOC_L		GENMASK(31, 28)
-#define MT_PRXV_HE_RU_ALLOC_H		GENMASK(3, 0)
+
+/* P-RXV DW1 */
 #define MT_PRXV_RCPI3			GENMASK(31, 24)
 #define MT_PRXV_RCPI2			GENMASK(23, 16)
 #define MT_PRXV_RCPI1			GENMASK(15, 8)
 #define MT_PRXV_RCPI0			GENMASK(7, 0)
+#define MT_PRXV_HE_RU_ALLOC_H		GENMASK(3, 0)
 
 /* C-RXV */
 #define MT_CRXV_HT_STBC			GENMASK(1, 0)
-- 
2.30.2



