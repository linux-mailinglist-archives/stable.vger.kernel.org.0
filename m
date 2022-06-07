Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 816C0541B23
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:43:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380877AbiFGVma (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:42:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380177AbiFGVix (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:38:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C12A7231CD6;
        Tue,  7 Jun 2022 12:05:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4DB50B8220B;
        Tue,  7 Jun 2022 19:05:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5B7FC34115;
        Tue,  7 Jun 2022 19:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628734;
        bh=aO/SV0l/d9y49PZJE2/jKTLD3IMu0kfthqT705tJwJc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y6+ojdqt86CrRezKFmLMKZcSnYhFJ3Ur9lrLbZ262iHJ78vMz6DuCWup7krV0H8uY
         kaI40IAuhZ67C4CwbdQ5sLWgV+SWS9CwO03Q3XXvMnjWEaz0aRSsNXTbtI5R91DwlB
         K4agSjvTH2rPiYPZ/U6DaPy1vl64HUUlIomemMSU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 436/879] mt76: mt7915: report rx mode value in mt7915_mac_fill_rx_rate
Date:   Tue,  7 Jun 2022 18:59:14 +0200
Message-Id: <20220607165015.526603063@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 05268cf1789d99eda491c4a32f23a4c5b9bddeba ]

Report rx mode in mt7915_mac_fill_rx_rate routine in order to properly
add he radiotap if mode is at least HE_SU.

Fixes: 1c9db0aa23fd1 ("mt76: mt7915: update rx rate reporting for mt7916")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7915/mac.c   | 22 +++++++++----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
index fe2b63cf61d8..45169a027fda 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
@@ -309,7 +309,7 @@ mt7915_mac_decode_he_mu_radiotap(struct sk_buff *skb, __le32 *rxv)
 }
 
 static void
-mt7915_mac_decode_he_radiotap(struct sk_buff *skb, __le32 *rxv, u32 mode)
+mt7915_mac_decode_he_radiotap(struct sk_buff *skb, __le32 *rxv, u8 mode)
 {
 	struct mt76_rx_status *status = (struct mt76_rx_status *)skb->cb;
 	static const struct ieee80211_radiotap_he known = {
@@ -474,10 +474,10 @@ static int
 mt7915_mac_fill_rx_rate(struct mt7915_dev *dev,
 			struct mt76_rx_status *status,
 			struct ieee80211_supported_band *sband,
-			__le32 *rxv)
+			__le32 *rxv, u8 *mode)
 {
 	u32 v0, v2;
-	u8 stbc, gi, bw, dcm, mode, nss;
+	u8 stbc, gi, bw, dcm, nss;
 	int i, idx;
 	bool cck = false;
 
@@ -490,18 +490,18 @@ mt7915_mac_fill_rx_rate(struct mt7915_dev *dev,
 	if (!is_mt7915(&dev->mt76)) {
 		stbc = FIELD_GET(MT_PRXV_HT_STBC, v0);
 		gi = FIELD_GET(MT_PRXV_HT_SHORT_GI, v0);
-		mode = FIELD_GET(MT_PRXV_TX_MODE, v0);
+		*mode = FIELD_GET(MT_PRXV_TX_MODE, v0);
 		dcm = FIELD_GET(MT_PRXV_DCM, v0);
 		bw = FIELD_GET(MT_PRXV_FRAME_MODE, v0);
 	} else {
 		stbc = FIELD_GET(MT_CRXV_HT_STBC, v2);
 		gi = FIELD_GET(MT_CRXV_HT_SHORT_GI, v2);
-		mode = FIELD_GET(MT_CRXV_TX_MODE, v2);
+		*mode = FIELD_GET(MT_CRXV_TX_MODE, v2);
 		dcm = !!(idx & GENMASK(3, 0) & MT_PRXV_TX_DCM);
 		bw = FIELD_GET(MT_CRXV_FRAME_MODE, v2);
 	}
 
-	switch (mode) {
+	switch (*mode) {
 	case MT_PHY_TYPE_CCK:
 		cck = true;
 		fallthrough;
@@ -546,7 +546,7 @@ mt7915_mac_fill_rx_rate(struct mt7915_dev *dev,
 	case IEEE80211_STA_RX_BW_20:
 		break;
 	case IEEE80211_STA_RX_BW_40:
-		if (mode & MT_PHY_TYPE_HE_EXT_SU &&
+		if (*mode & MT_PHY_TYPE_HE_EXT_SU &&
 		    (idx & MT_PRXV_TX_ER_SU_106T)) {
 			status->bw = RATE_INFO_BW_HE_RU;
 			status->he_ru =
@@ -566,7 +566,7 @@ mt7915_mac_fill_rx_rate(struct mt7915_dev *dev,
 	}
 
 	status->enc_flags |= RX_ENC_FLAG_STBC_MASK * stbc;
-	if (mode < MT_PHY_TYPE_HE_SU && gi)
+	if (*mode < MT_PHY_TYPE_HE_SU && gi)
 		status->enc_flags |= RX_ENC_FLAG_SHORT_GI;
 
 	return 0;
@@ -581,7 +581,6 @@ mt7915_mac_fill_rx(struct mt7915_dev *dev, struct sk_buff *skb)
 	struct ieee80211_supported_band *sband;
 	__le32 *rxd = (__le32 *)skb->data;
 	__le32 *rxv = NULL;
-	u32 mode = 0;
 	u32 rxd0 = le32_to_cpu(rxd[0]);
 	u32 rxd1 = le32_to_cpu(rxd[1]);
 	u32 rxd2 = le32_to_cpu(rxd[2]);
@@ -590,10 +589,10 @@ mt7915_mac_fill_rx(struct mt7915_dev *dev, struct sk_buff *skb)
 	u32 csum_mask = MT_RXD0_NORMAL_IP_SUM | MT_RXD0_NORMAL_UDP_TCP_SUM;
 	bool unicast, insert_ccmp_hdr = false;
 	u8 remove_pad, amsdu_info;
+	u8 mode = 0, qos_ctl = 0;
 	bool hdr_trans;
 	u16 hdr_gap;
 	u16 seq_ctrl = 0;
-	u8 qos_ctl = 0;
 	__le16 fc = 0;
 	int idx;
 
@@ -766,7 +765,8 @@ mt7915_mac_fill_rx(struct mt7915_dev *dev, struct sk_buff *skb)
 		}
 
 		if (!is_mt7915(&dev->mt76) || (rxd1 & MT_RXD1_NORMAL_GROUP_5)) {
-			ret = mt7915_mac_fill_rx_rate(dev, status, sband, rxv);
+			ret = mt7915_mac_fill_rx_rate(dev, status, sband, rxv,
+						      &mode);
 			if (ret < 0)
 				return ret;
 		}
-- 
2.35.1



