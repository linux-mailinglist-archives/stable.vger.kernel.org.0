Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFA285FE2C4
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 21:36:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbiJMTgP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 15:36:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbiJMTgL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 15:36:11 -0400
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6B7C179380
        for <stable@vger.kernel.org>; Thu, 13 Oct 2022 12:36:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=NCRXQf5/2puGWe7Ed7Q886GvsqbVvC7VwfzWni/LJCw=; b=OTYmmeUsnhpmu3YNydxabDW303
        swF+q61AqEoMD87COMfbxyQ8bJLxn2aea3vXPPp3Uqc4IY1tdzvw7Q/M8XyoWwtho98hPVxQ4P8T/
        AxEhK8W4USXsNzPXcoxiu5rpCF4Njsb6GaRdzXzhR9Sko7I6z7gj0y1l3EQs/qQ5eVfk=;
Received: from p200300daa7301d0028e1e1004b08c350.dip0.t-ipconnect.de ([2003:da:a730:1d00:28e1:e100:4b08:c350] helo=Maecks.lan)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1oj2kV-00CXRx-EX; Thu, 13 Oct 2022 20:16:03 +0200
From:   Felix Fietkau <nbd@nbd.name>
To:     stable@vger.kernel.org
Cc:     johannes@sipsolutions.net
Subject: [PATCH 5.15 6/6] wifi: mac80211: fix MBSSID parsing use-after-free
Date:   Thu, 13 Oct 2022 20:16:01 +0200
Message-Id: <20221013181601.5712-6-nbd@nbd.name>
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

commit ff05d4b45dd89b922578dac497dcabf57cf771c6

When we parse a multi-BSSID element, we might point some
element pointers into the allocated nontransmitted_profile.
However, we free this before returning, causing UAF when the
relevant pointers in the parsed elements are accessed.

Fix this by not allocating the scratch buffer separately but
as part of the returned structure instead, that way, there
are no lifetime issues with it.

The scratch buffer introduction as part of the returned data
here is taken from MLO feature work done by Ilan.

This fixes CVE-2022-42719.

Fixes: 5023b14cf4df ("mac80211: support profile split between elements")
Co-developed-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h |  8 ++++++++
 net/mac80211/util.c        | 29 ++++++++++++++---------------
 2 files changed, 22 insertions(+), 15 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 3633e49239c7..21549a440b38 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1613,6 +1613,14 @@ struct ieee802_11_elems {
 
 	/* whether a parse error occurred while retrieving these elements */
 	bool parse_error;
+
+	/*
+	 * scratch buffer that can be used for various element parsing related
+	 * tasks, e.g., element de-fragmentation etc.
+	 */
+	size_t scratch_len;
+	u8 *scratch_pos;
+	u8 scratch[];
 };
 
 static inline struct ieee80211_local *hw_to_local(
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 2ac61e68b6b4..354badd32793 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1475,24 +1475,25 @@ struct ieee802_11_elems *ieee802_11_parse_elems_crc(const u8 *start, size_t len,
 	u8 *nontransmitted_profile;
 	int nontransmitted_profile_len = 0;
 
-	elems = kzalloc(sizeof(*elems), GFP_ATOMIC);
+	elems = kzalloc(sizeof(*elems) + len, GFP_ATOMIC);
 	if (!elems)
 		return NULL;
 	elems->ie_start = start;
 	elems->total_len = len;
 
-	nontransmitted_profile = kmalloc(len, GFP_ATOMIC);
-	if (nontransmitted_profile) {
-		nontransmitted_profile_len =
-			ieee802_11_find_bssid_profile(start, len, elems,
-						      transmitter_bssid,
-						      bss_bssid,
-						      nontransmitted_profile);
-		non_inherit =
-			cfg80211_find_ext_elem(WLAN_EID_EXT_NON_INHERITANCE,
-					       nontransmitted_profile,
-					       nontransmitted_profile_len);
-	}
+	elems->scratch_len = len;
+	elems->scratch_pos = elems->scratch;
+
+	nontransmitted_profile = elems->scratch_pos;
+	nontransmitted_profile_len =
+		ieee802_11_find_bssid_profile(start, len, elems,
+					      transmitter_bssid,
+					      bss_bssid,
+					      nontransmitted_profile);
+	non_inherit =
+		cfg80211_find_ext_elem(WLAN_EID_EXT_NON_INHERITANCE,
+				       nontransmitted_profile,
+				       nontransmitted_profile_len);
 
 	crc = _ieee802_11_parse_elems_crc(start, len, action, elems, filter,
 					  crc, non_inherit);
@@ -1521,8 +1522,6 @@ struct ieee802_11_elems *ieee802_11_parse_elems_crc(const u8 *start, size_t len,
 	    offsetofend(struct ieee80211_bssid_index, dtim_count))
 		elems->dtim_count = elems->bssid_index->dtim_count;
 
-	kfree(nontransmitted_profile);
-
 	elems->crc = crc;
 
 	return elems;
-- 
2.36.1

