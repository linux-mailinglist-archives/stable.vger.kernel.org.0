Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5C984F28F1
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:23:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234109AbiDEIYD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:24:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237504AbiDEISE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:18:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C612D6A407;
        Tue,  5 Apr 2022 01:06:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 11A2B617EE;
        Tue,  5 Apr 2022 08:06:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12A52C385A2;
        Tue,  5 Apr 2022 08:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145989;
        bh=yS1FTjx13/PPoaV9hk4QqSl/Og//CV6PkJ0VbDGU0Cc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=smEvmQZveb2OPwE9JybV6nHsBa/lmksHg0ndv+5Y22fF09kl98Dx7rM6Oc9EY5528
         zK5NgLebXYufDaiBU7A17YmiGEki2bqL5/wSHTeQMQQNyhSX5G0TswHjJRnQbTPNcj
         0Ah/UDGYdASv+z5SEgos8POZ7RKurNbf8KLyWv+w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ryder Lee <ryder.lee@mediatek.com>,
        MeiChia Chiu <meichia.chiu@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0603/1126] mt76: mt7915: fix the muru tlv issue
Date:   Tue,  5 Apr 2022 09:22:30 +0200
Message-Id: <20220405070425.333533577@linuxfoundation.org>
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

From: MeiChia Chiu <meichia.chiu@mediatek.com>

[ Upstream commit d98a72725bc96c98f68eac12e5a91ec349322c88 ]

The muru enable/disable are only set after the first station connection.
Without this patch, the firmware couldn't enable muru
if the first connected station is non-HE type.

Fixes: 16bff457dd33a ("mt76: mt7915: rework mt7915_mcu_sta_muru_tlv()")
Reviewed-by: Ryder Lee <ryder.lee@mediatek.com>
Signed-off-by: MeiChia Chiu <meichia.chiu@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
index 8ff2402c4817..31634d7ed173 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -1516,9 +1516,6 @@ mt7915_mcu_sta_muru_tlv(struct sk_buff *skb, struct ieee80211_sta *sta,
 	    vif->type != NL80211_IFTYPE_AP)
 		return;
 
-	if (!sta->vht_cap.vht_supported)
-		return;
-
 	tlv = mt7915_mcu_add_tlv(skb, STA_REC_MURU, sizeof(*muru));
 
 	muru = (struct sta_rec_muru *)tlv;
@@ -1526,9 +1523,12 @@ mt7915_mcu_sta_muru_tlv(struct sk_buff *skb, struct ieee80211_sta *sta,
 	muru->cfg.mimo_dl_en = mvif->cap.he_mu_ebfer ||
 			       mvif->cap.vht_mu_ebfer ||
 			       mvif->cap.vht_mu_ebfee;
+	muru->cfg.mimo_ul_en = true;
+	muru->cfg.ofdma_dl_en = true;
 
-	muru->mimo_dl.vht_mu_bfee =
-		!!(sta->vht_cap.cap & IEEE80211_VHT_CAP_MU_BEAMFORMEE_CAPABLE);
+	if (sta->vht_cap.vht_supported)
+		muru->mimo_dl.vht_mu_bfee =
+			!!(sta->vht_cap.cap & IEEE80211_VHT_CAP_MU_BEAMFORMEE_CAPABLE);
 
 	if (!sta->he_cap.has_he)
 		return;
@@ -1536,13 +1536,11 @@ mt7915_mcu_sta_muru_tlv(struct sk_buff *skb, struct ieee80211_sta *sta,
 	muru->mimo_dl.partial_bw_dl_mimo =
 		HE_PHY(CAP6_PARTIAL_BANDWIDTH_DL_MUMIMO, elem->phy_cap_info[6]);
 
-	muru->cfg.mimo_ul_en = true;
 	muru->mimo_ul.full_ul_mimo =
 		HE_PHY(CAP2_UL_MU_FULL_MU_MIMO, elem->phy_cap_info[2]);
 	muru->mimo_ul.partial_ul_mimo =
 		HE_PHY(CAP2_UL_MU_PARTIAL_MU_MIMO, elem->phy_cap_info[2]);
 
-	muru->cfg.ofdma_dl_en = true;
 	muru->ofdma_dl.punc_pream_rx =
 		HE_PHY(CAP1_PREAMBLE_PUNC_RX_MASK, elem->phy_cap_info[1]);
 	muru->ofdma_dl.he_20m_in_40m_2g =
-- 
2.34.1



