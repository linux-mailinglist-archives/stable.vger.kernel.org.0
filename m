Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07E0E5FE2C3
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 21:36:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbiJMTgO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 15:36:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbiJMTgK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 15:36:10 -0400
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E830170DFB
        for <stable@vger.kernel.org>; Thu, 13 Oct 2022 12:36:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=/21HR1+kgDN4b9uTtw/fNZENTGXDaVFZVPS6WEQvUKM=; b=LBcSP6I4o50oqu8DD02CEAbxrT
        J6Y684GSRwArc7cn6PCd8ph1rdBdQp3suS7hT6suq8T8Zc9Pq+qtQInlTySlkyLLn5JssxlmSiKSw
        jbNgVHK+jBlSyD61IR4RdSRr+HOyKkCcFUxpEnGOnX+ZILLgG6f/Rv9uuciVDhUbL79E=;
Received: from p200300daa7301d0028e1e1004b08c350.dip0.t-ipconnect.de ([2003:da:a730:1d00:28e1:e100:4b08:c350] helo=Maecks.lan)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1oj2kU-00CXRx-C7; Thu, 13 Oct 2022 20:16:02 +0200
From:   Felix Fietkau <nbd@nbd.name>
To:     stable@vger.kernel.org
Cc:     johannes@sipsolutions.net
Subject: [PATCH 5.15 2/6] mac80211: move CRC into struct ieee802_11_elems
Date:   Thu, 13 Oct 2022 20:15:57 +0200
Message-Id: <20221013181601.5712-2-nbd@nbd.name>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20221013181601.5712-1-nbd@nbd.name>
References: <20221013181601.5712-1-nbd@nbd.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

commit c6e37ed498f958254b5459253199e816b6bfc52f upstream.

We're currently returning this value, but to prepare for
returning the allocated structure, move it into there.

Link: https://lore.kernel.org/r/20210920154009.479b8ebf999d.If0d4ba75ee38998dc3eeae25058aa748efcb2fc9@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h |  9 +++++----
 net/mac80211/mlme.c        |  9 +++++----
 net/mac80211/util.c        | 10 +++++-----
 3 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 4bd55af184b2..5ea38ae65809 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1532,6 +1532,7 @@ struct ieee80211_csa_ie {
 struct ieee802_11_elems {
 	const u8 *ie_start;
 	size_t total_len;
+	u32 crc;
 
 	/* pointers to IEs */
 	const struct ieee80211_tdls_lnkie *lnk_id;
@@ -2218,10 +2219,10 @@ static inline void ieee80211_tx_skb(struct ieee80211_sub_if_data *sdata,
 	ieee80211_tx_skb_tid(sdata, skb, 7);
 }
 
-u32 ieee802_11_parse_elems_crc(const u8 *start, size_t len, bool action,
-			       struct ieee802_11_elems *elems,
-			       u64 filter, u32 crc, u8 *transmitter_bssid,
-			       u8 *bss_bssid);
+void ieee802_11_parse_elems_crc(const u8 *start, size_t len, bool action,
+				struct ieee802_11_elems *elems,
+				u64 filter, u32 crc, u8 *transmitter_bssid,
+				u8 *bss_bssid);
 static inline void ieee802_11_parse_elems(const u8 *start, size_t len,
 					  bool action,
 					  struct ieee802_11_elems *elems,
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 1548f532dc1a..4414e82e71d1 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -4102,10 +4102,11 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 	 */
 	if (!ieee80211_is_s1g_beacon(hdr->frame_control))
 		ncrc = crc32_be(0, (void *)&mgmt->u.beacon.beacon_int, 4);
-	ncrc = ieee802_11_parse_elems_crc(variable,
-					  len - baselen, false, &elems,
-					  care_about_ies, ncrc,
-					  mgmt->bssid, bssid);
+	ieee802_11_parse_elems_crc(variable,
+				   len - baselen, false, &elems,
+				   care_about_ies, ncrc,
+				   mgmt->bssid, bssid);
+	ncrc = elems.crc;
 
 	if (ieee80211_hw_check(&local->hw, PS_NULLFUNC_STACK) &&
 	    ieee80211_check_tim(elems.tim, elems.tim_len, bss_conf->aid)) {
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 00543ea9c6b5..ceb6894381e4 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1468,10 +1468,10 @@ static size_t ieee802_11_find_bssid_profile(const u8 *start, size_t len,
 	return found ? profile_len : 0;
 }
 
-u32 ieee802_11_parse_elems_crc(const u8 *start, size_t len, bool action,
-			       struct ieee802_11_elems *elems,
-			       u64 filter, u32 crc, u8 *transmitter_bssid,
-			       u8 *bss_bssid)
+void ieee802_11_parse_elems_crc(const u8 *start, size_t len, bool action,
+				struct ieee802_11_elems *elems,
+				u64 filter, u32 crc, u8 *transmitter_bssid,
+				u8 *bss_bssid)
 {
 	const struct element *non_inherit = NULL;
 	u8 *nontransmitted_profile;
@@ -1523,7 +1523,7 @@ u32 ieee802_11_parse_elems_crc(const u8 *start, size_t len, bool action,
 
 	kfree(nontransmitted_profile);
 
-	return crc;
+	elems->crc = crc;
 }
 
 void ieee80211_regulatory_limit_wmm_params(struct ieee80211_sub_if_data *sdata,
-- 
2.36.1

