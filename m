Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C3BD4F2E93
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:01:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241949AbiDEIgL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:36:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236512AbiDEIQr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:16:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FC7170936;
        Tue,  5 Apr 2022 01:04:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C4A63617D8;
        Tue,  5 Apr 2022 08:04:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB55FC385A2;
        Tue,  5 Apr 2022 08:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145850;
        bh=yR/qOrNs6Wtc/dp6s379KJkE4S1ibvxSryKggWogffM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yO0fdWAHEggAu5HnLmYU40B2Q+QOulpD6GVGhKAbU1A0xTbzgmrUB9lvjTAQAu1wF
         h2EkGVBg1lEa0WIFUrmftsdYKEe/r7UhAzlDUtonRpRqPvrx3dVZSfJytHhb4GyVTy
         JVGpuHEgyxZ+2FiiUBzBMjA8miV+oxwdhCX1V+Cg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0513/1126] mac80211: limit bandwidth in HE capabilities
Date:   Tue,  5 Apr 2022 09:21:00 +0200
Message-Id: <20220405070422.686867594@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 1f2c104448477512fcf7296df54bfbc3a6f9a765 ]

If we're limiting bandwidth for some reason such as regulatory
restrictions, then advertise that limitation just like we do
for VHT today, so the AP is aware we cannot use the higher BW
it might be using.

Fixes: 41cbb0f5a295 ("mac80211: add support for HE")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20220202104617.70c8e3e7ee76.If317630de69ff1146bec7d47f5b83038695eb71d@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/ieee80211_i.h |  2 +-
 net/mac80211/mesh.c        |  2 +-
 net/mac80211/mlme.c        | 11 ++++++++---
 net/mac80211/util.c        | 27 ++++++++++++++++++++++-----
 4 files changed, 32 insertions(+), 10 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index e87bccaab561..95aaf00c876c 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -2380,7 +2380,7 @@ u8 *ieee80211_ie_build_vht_cap(u8 *pos, struct ieee80211_sta_vht_cap *vht_cap,
 u8 *ieee80211_ie_build_vht_oper(u8 *pos, struct ieee80211_sta_vht_cap *vht_cap,
 				const struct cfg80211_chan_def *chandef);
 u8 ieee80211_ie_len_he_cap(struct ieee80211_sub_if_data *sdata, u8 iftype);
-u8 *ieee80211_ie_build_he_cap(u8 *pos,
+u8 *ieee80211_ie_build_he_cap(u32 disable_flags, u8 *pos,
 			      const struct ieee80211_sta_he_cap *he_cap,
 			      u8 *end);
 void ieee80211_ie_build_he_6ghz_cap(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 15ac08d111ea..6847fdf93439 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -580,7 +580,7 @@ int mesh_add_he_cap_ie(struct ieee80211_sub_if_data *sdata,
 		return -ENOMEM;
 
 	pos = skb_put(skb, ie_len);
-	ieee80211_ie_build_he_cap(pos, he_cap, pos + ie_len);
+	ieee80211_ie_build_he_cap(0, pos, he_cap, pos + ie_len);
 
 	return 0;
 }
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 744842c4513b..c4d3e2da73f2 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -636,7 +636,7 @@ static void ieee80211_add_he_ie(struct ieee80211_sub_if_data *sdata,
 				struct sk_buff *skb,
 				struct ieee80211_supported_band *sband)
 {
-	u8 *pos;
+	u8 *pos, *pre_he_pos;
 	const struct ieee80211_sta_he_cap *he_cap = NULL;
 	struct ieee80211_chanctx_conf *chanctx_conf;
 	u8 he_cap_size;
@@ -653,16 +653,21 @@ static void ieee80211_add_he_ie(struct ieee80211_sub_if_data *sdata,
 
 	he_cap = ieee80211_get_he_iftype_cap(sband,
 					     ieee80211_vif_type_p2p(&sdata->vif));
-	if (!he_cap || !reg_cap)
+	if (!he_cap || !chanctx_conf || !reg_cap)
 		return;
 
+	/* get a max size estimate */
 	he_cap_size =
 		2 + 1 + sizeof(he_cap->he_cap_elem) +
 		ieee80211_he_mcs_nss_size(&he_cap->he_cap_elem) +
 		ieee80211_he_ppe_size(he_cap->ppe_thres[0],
 				      he_cap->he_cap_elem.phy_cap_info);
 	pos = skb_put(skb, he_cap_size);
-	ieee80211_ie_build_he_cap(pos, he_cap, pos + he_cap_size);
+	pre_he_pos = pos;
+	pos = ieee80211_ie_build_he_cap(sdata->u.mgd.flags,
+					pos, he_cap, pos + he_cap_size);
+	/* trim excess if any */
+	skb_trim(skb, skb->len - (pre_he_pos + he_cap_size - pos));
 
 	ieee80211_ie_build_he_6ghz_cap(sdata, skb);
 }
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index f71b042a5c8b..342c2bfe2709 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1974,7 +1974,7 @@ static int ieee80211_build_preq_ies_band(struct ieee80211_sub_if_data *sdata,
 	if (he_cap &&
 	    cfg80211_any_usable_channels(local->hw.wiphy, BIT(sband->band),
 					 IEEE80211_CHAN_NO_HE)) {
-		pos = ieee80211_ie_build_he_cap(pos, he_cap, end);
+		pos = ieee80211_ie_build_he_cap(0, pos, he_cap, end);
 		if (!pos)
 			goto out_err;
 	}
@@ -2918,10 +2918,11 @@ u8 ieee80211_ie_len_he_cap(struct ieee80211_sub_if_data *sdata, u8 iftype)
 				     he_cap->he_cap_elem.phy_cap_info);
 }
 
-u8 *ieee80211_ie_build_he_cap(u8 *pos,
+u8 *ieee80211_ie_build_he_cap(u32 disable_flags, u8 *pos,
 			      const struct ieee80211_sta_he_cap *he_cap,
 			      u8 *end)
 {
+	struct ieee80211_he_cap_elem elem;
 	u8 n;
 	u8 ie_len;
 	u8 *orig_pos = pos;
@@ -2934,7 +2935,23 @@ u8 *ieee80211_ie_build_he_cap(u8 *pos,
 	if (!he_cap)
 		return orig_pos;
 
-	n = ieee80211_he_mcs_nss_size(&he_cap->he_cap_elem);
+	/* modify on stack first to calculate 'n' and 'ie_len' correctly */
+	elem = he_cap->he_cap_elem;
+
+	if (disable_flags & IEEE80211_STA_DISABLE_40MHZ)
+		elem.phy_cap_info[0] &=
+			~(IEEE80211_HE_PHY_CAP0_CHANNEL_WIDTH_SET_40MHZ_80MHZ_IN_5G |
+			  IEEE80211_HE_PHY_CAP0_CHANNEL_WIDTH_SET_40MHZ_IN_2G);
+
+	if (disable_flags & IEEE80211_STA_DISABLE_160MHZ)
+		elem.phy_cap_info[0] &=
+			~IEEE80211_HE_PHY_CAP0_CHANNEL_WIDTH_SET_160MHZ_IN_5G;
+
+	if (disable_flags & IEEE80211_STA_DISABLE_80P80MHZ)
+		elem.phy_cap_info[0] &=
+			~IEEE80211_HE_PHY_CAP0_CHANNEL_WIDTH_SET_80PLUS80_MHZ_IN_5G;
+
+	n = ieee80211_he_mcs_nss_size(&elem);
 	ie_len = 2 + 1 +
 		 sizeof(he_cap->he_cap_elem) + n +
 		 ieee80211_he_ppe_size(he_cap->ppe_thres[0],
@@ -2948,8 +2965,8 @@ u8 *ieee80211_ie_build_he_cap(u8 *pos,
 	*pos++ = WLAN_EID_EXT_HE_CAPABILITY;
 
 	/* Fixed data */
-	memcpy(pos, &he_cap->he_cap_elem, sizeof(he_cap->he_cap_elem));
-	pos += sizeof(he_cap->he_cap_elem);
+	memcpy(pos, &elem, sizeof(elem));
+	pos += sizeof(elem);
 
 	memcpy(pos, &he_cap->he_mcs_nss_supp, n);
 	pos += n;
-- 
2.34.1



