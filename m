Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F31384F33D3
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:23:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235523AbiDEJei (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:34:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245669AbiDEI4r (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:56:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D272013F31;
        Tue,  5 Apr 2022 01:52:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7BBC8B81B92;
        Tue,  5 Apr 2022 08:52:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7AC3C385A1;
        Tue,  5 Apr 2022 08:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148751;
        bh=Znt/vm9vgOXsZw7Xjc+NTDjQbVSwwPCtRs0hStLIK7I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ks54k/qOxdyj3PYUxTlI+AgVjA7CxtjwOlc7csyAO6GsCt25ex8Sn1cmNcFzzpjlP
         rvWdr73R19O3bnozF2xK3Cu1WSO2+Axyy+wvAnR/BDmMNadk/UXgZWISKimyAHpgf4
         RQsxKXzLJzMPUdDYC9hg6XQ55r7BEdSYxDauTt3c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Chiu <chui-hao.chiu@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0466/1017] mt76: mt7915: fix mcs_map in mt7915_mcu_set_sta_he_mcs()
Date:   Tue,  5 Apr 2022 09:22:59 +0200
Message-Id: <20220405070408.131841328@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Chiu <chui-hao.chiu@mediatek.com>

[ Upstream commit ade25ca7950bc8930356d98ec89aa41560a9dab5 ]

Should use peer's bandwidth instead of chandef->width to
get correct mcs_map.

Fixes: 76be6c076c077 ("mt76: mt7915: add .set_bitrate_mask() callback")
Signed-off-by: Peter Chiu <chui-hao.chiu@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7915/mcu.c   | 29 +++++--------------
 1 file changed, 8 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
index 0b6fecc8b3b6..ef8b0d0a05ef 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -211,24 +211,12 @@ mt7915_mcu_get_sta_nss(u16 mcs_map)
 
 static void
 mt7915_mcu_set_sta_he_mcs(struct ieee80211_sta *sta, __le16 *he_mcs,
-			  const u16 *mask)
+			  u16 mcs_map)
 {
 	struct mt7915_sta *msta = (struct mt7915_sta *)sta->drv_priv;
-	struct cfg80211_chan_def *chandef = &msta->vif->phy->mt76->chandef;
+	enum nl80211_band band = msta->vif->phy->mt76->chandef.chan->band;
+	const u16 *mask = msta->vif->bitrate_mask.control[band].he_mcs;
 	int nss, max_nss = sta->rx_nss > 3 ? 4 : sta->rx_nss;
-	u16 mcs_map;
-
-	switch (chandef->width) {
-	case NL80211_CHAN_WIDTH_80P80:
-		mcs_map = le16_to_cpu(sta->he_cap.he_mcs_nss_supp.rx_mcs_80p80);
-		break;
-	case NL80211_CHAN_WIDTH_160:
-		mcs_map = le16_to_cpu(sta->he_cap.he_mcs_nss_supp.rx_mcs_160);
-		break;
-	default:
-		mcs_map = le16_to_cpu(sta->he_cap.he_mcs_nss_supp.rx_mcs_80);
-		break;
-	}
 
 	for (nss = 0; nss < max_nss; nss++) {
 		int mcs;
@@ -1344,11 +1332,9 @@ static void
 mt7915_mcu_sta_he_tlv(struct sk_buff *skb, struct ieee80211_sta *sta,
 		      struct ieee80211_vif *vif)
 {
-	struct mt7915_sta *msta = (struct mt7915_sta *)sta->drv_priv;
 	struct mt7915_vif *mvif = (struct mt7915_vif *)vif->drv_priv;
 	struct ieee80211_he_cap_elem *elem = &sta->he_cap.he_cap_elem;
-	enum nl80211_band band = msta->vif->phy->mt76->chandef.chan->band;
-	const u16 *mcs_mask = msta->vif->bitrate_mask.control[band].he_mcs;
+	struct ieee80211_he_mcs_nss_supp mcs_map;
 	struct sta_rec_he *he;
 	struct tlv *tlv;
 	u32 cap = 0;
@@ -1438,22 +1424,23 @@ mt7915_mcu_sta_he_tlv(struct sk_buff *skb, struct ieee80211_sta *sta,
 
 	he->he_cap = cpu_to_le32(cap);
 
+	mcs_map = sta->he_cap.he_mcs_nss_supp;
 	switch (sta->bandwidth) {
 	case IEEE80211_STA_RX_BW_160:
 		if (elem->phy_cap_info[0] &
 		    IEEE80211_HE_PHY_CAP0_CHANNEL_WIDTH_SET_80PLUS80_MHZ_IN_5G)
 			mt7915_mcu_set_sta_he_mcs(sta,
 						  &he->max_nss_mcs[CMD_HE_MCS_BW8080],
-						  mcs_mask);
+						  le16_to_cpu(mcs_map.rx_mcs_80p80));
 
 		mt7915_mcu_set_sta_he_mcs(sta,
 					  &he->max_nss_mcs[CMD_HE_MCS_BW160],
-					  mcs_mask);
+					  le16_to_cpu(mcs_map.rx_mcs_160));
 		fallthrough;
 	default:
 		mt7915_mcu_set_sta_he_mcs(sta,
 					  &he->max_nss_mcs[CMD_HE_MCS_BW80],
-					  mcs_mask);
+					  le16_to_cpu(mcs_map.rx_mcs_80));
 		break;
 	}
 
-- 
2.34.1



