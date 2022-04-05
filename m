Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBB704F28CC
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:22:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233468AbiDEIW5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:22:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235436AbiDEIQK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:16:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20576A94F3;
        Tue,  5 Apr 2022 01:03:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F0A861753;
        Tue,  5 Apr 2022 08:03:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A44B5C385A3;
        Tue,  5 Apr 2022 08:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145803;
        bh=a1m4cMTbuV1ChAmpSXyVBeKDPl09KCXziqzprdAqbWM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c+ZsCLfiEy8+hylUcjX+nwP12SdKpsSYQpBPGeGilK6y+vKTzdgH1tq78eVKpDu2x
         LKT9y0pb7I3+aiyvJA8jlhJpQUJQFQOLSJq+AFWg2FcM4yftgCE6wQz9hXK48+mGOg
         BsFamjRp9CQ59i/dIE1RFEiBvoSBfExqXDGWg3aM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Chiu <chui-hao.chiu@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0508/1126] mt76: mt7915: fix mcs_map in mt7915_mcu_set_sta_he_mcs()
Date:   Tue,  5 Apr 2022 09:20:55 +0200
Message-Id: <20220405070422.539038765@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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
index 1afeb7493268..f7b97b7ab21f 100644
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
@@ -1345,11 +1333,9 @@ static void
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
@@ -1439,22 +1425,23 @@ mt7915_mcu_sta_he_tlv(struct sk_buff *skb, struct ieee80211_sta *sta,
 
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



