Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 715464F374A
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352686AbiDELMR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:12:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348936AbiDEJst (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:48:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70BEFA27D3;
        Tue,  5 Apr 2022 02:38:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0B8B4B818F3;
        Tue,  5 Apr 2022 09:38:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7002DC385A0;
        Tue,  5 Apr 2022 09:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151482;
        bh=OKfJzWTQmHLjMXWrifHpPa9eLq/SqrNqn+2tLoJncbQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DTYTxaUHmIYhAdg8/OaSPoujXW/s7aCedkJAZnXcUVEJFh/UC/gCLQz6Ylf/Ew6fd
         NUQRspuiQk9JF/8+M4SyvghJKOZvoXj20lH28qirb9+Cjwh9/sJ/oNgH1X+/6trkey
         VtyGuY9O8A+FHEsWhNQKxeo40nRDOm2z26B5pQhM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 431/913] mac80211: limit bandwidth in HE capabilities
Date:   Tue,  5 Apr 2022 09:24:53 +0200
Message-Id: <20220405070352.764932079@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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
index 6a88195e5abe..d30bd21697a3 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -2379,7 +2379,7 @@ u8 *ieee80211_ie_build_vht_cap(u8 *pos, struct ieee80211_sta_vht_cap *vht_cap,
 u8 *ieee80211_ie_build_vht_oper(u8 *pos, struct ieee80211_sta_vht_cap *vht_cap,
 				const struct cfg80211_chan_def *chandef);
 u8 ieee80211_ie_len_he_cap(struct ieee80211_sub_if_data *sdata, u8 iftype);
-u8 *ieee80211_ie_build_he_cap(u8 *pos,
+u8 *ieee80211_ie_build_he_cap(u32 disable_flags, u8 *pos,
 			      const struct ieee80211_sta_he_cap *he_cap,
 			      u8 *end);
 void ieee80211_ie_build_he_6ghz_cap(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 5dcfd53a4ab6..42bd81a30310 100644
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
index 8d9fe2765836..c8332452c118 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -630,7 +630,7 @@ static void ieee80211_add_he_ie(struct ieee80211_sub_if_data *sdata,
 				struct sk_buff *skb,
 				struct ieee80211_supported_band *sband)
 {
-	u8 *pos;
+	u8 *pos, *pre_he_pos;
 	const struct ieee80211_sta_he_cap *he_cap = NULL;
 	struct ieee80211_chanctx_conf *chanctx_conf;
 	u8 he_cap_size;
@@ -647,16 +647,21 @@ static void ieee80211_add_he_ie(struct ieee80211_sub_if_data *sdata,
 
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
index 2fe71ed9137b..be1911d8089f 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1959,7 +1959,7 @@ static int ieee80211_build_preq_ies_band(struct ieee80211_sub_if_data *sdata,
 	if (he_cap &&
 	    cfg80211_any_usable_channels(local->hw.wiphy, BIT(sband->band),
 					 IEEE80211_CHAN_NO_HE)) {
-		pos = ieee80211_ie_build_he_cap(pos, he_cap, end);
+		pos = ieee80211_ie_build_he_cap(0, pos, he_cap, end);
 		if (!pos)
 			goto out_err;
 	}
@@ -2903,10 +2903,11 @@ u8 ieee80211_ie_len_he_cap(struct ieee80211_sub_if_data *sdata, u8 iftype)
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
@@ -2919,7 +2920,23 @@ u8 *ieee80211_ie_build_he_cap(u8 *pos,
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
@@ -2933,8 +2950,8 @@ u8 *ieee80211_ie_build_he_cap(u8 *pos,
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



