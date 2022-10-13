Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EA645FDF4F
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 19:52:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229493AbiJMRw3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 13:52:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbiJMRw2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 13:52:28 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1CB73FA1E
        for <stable@vger.kernel.org>; Thu, 13 Oct 2022 10:52:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
        Resent-Message-ID:In-Reply-To:References;
        bh=pBODb7EumeeMQuHexPAPeUIyMXYHpd3je1L4SJpy8rM=; t=1665683546; x=1666893146; 
        b=YQyNWUQ4jTkgLiQJEnExqa9OVOIxFzR7lKJRjEjkyGAPEMWlxeWO72ggdgBa6fC7O/veZTo+OTk
        NuLGS12/04Oaa2C0TrUDkpyyfnR3GWpFn0atzIIsIeGBhiQkgbRWo3mcrqUxdCQ6uGCCDa8V7spTj
        GqpiMe1KSjfHbMfsus4WksBgylXHcmE2J8Q18BMJeh4EV4HrG5qdOkZCrcj6tbLSgyTEMfatibLD6
        p0oRkVSAFOoryVkMAuuBzN0MPFr1QND2ikJPv89el30ScQ3qxvpuZ7yNv/ypsXrHlQVZ3H7W1VsLM
        vRtL+jDNp0xv4LLfywYp7M4krM+bzRBcV43A==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1oj2Nb-005m6Z-0c;
        Thu, 13 Oct 2022 19:52:23 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Ilan Peer <ilan.peer@intel.com>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH v5.19] wifi: mac80211: fix MBSSID parsing use-after-free
Date:   Thu, 13 Oct 2022 19:52:15 +0200
Message-Id: <20221013175215.161367-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

Commit ff05d4b45dd89b922578dac497dcabf57cf771c6 upstream.

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
 net/mac80211/util.c        | 30 +++++++++++++++---------------
 2 files changed, 23 insertions(+), 15 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 48fbccbf2a54..44c8701af95c 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1640,6 +1640,14 @@ struct ieee802_11_elems {
 
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
index 504422cc683e..8f36ab8fcfb2 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1503,25 +1503,27 @@ struct ieee802_11_elems *ieee802_11_parse_elems_crc(const u8 *start, size_t len,
 	const struct element *non_inherit = NULL;
 	u8 *nontransmitted_profile;
 	int nontransmitted_profile_len = 0;
+	size_t scratch_len = len;
 
-	elems = kzalloc(sizeof(*elems), GFP_ATOMIC);
+	elems = kzalloc(sizeof(*elems) + scratch_len, GFP_ATOMIC);
 	if (!elems)
 		return NULL;
 	elems->ie_start = start;
 	elems->total_len = len;
+	elems->scratch_len = scratch_len;
+	elems->scratch_pos = elems->scratch;
 
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
+	nontransmitted_profile = elems->scratch_pos;
+	nontransmitted_profile_len =
+		ieee802_11_find_bssid_profile(start, len, elems,
+					      transmitter_bssid,
+					      bss_bssid,
+					      nontransmitted_profile);
+	elems->scratch_pos += nontransmitted_profile_len;
+	elems->scratch_len -= nontransmitted_profile_len;
+	non_inherit = cfg80211_find_ext_elem(WLAN_EID_EXT_NON_INHERITANCE,
+					     nontransmitted_profile,
+					     nontransmitted_profile_len);
 
 	crc = _ieee802_11_parse_elems_crc(start, len, action, elems, filter,
 					  crc, non_inherit);
@@ -1550,8 +1552,6 @@ struct ieee802_11_elems *ieee802_11_parse_elems_crc(const u8 *start, size_t len,
 	    offsetofend(struct ieee80211_bssid_index, dtim_count))
 		elems->dtim_count = elems->bssid_index->dtim_count;
 
-	kfree(nontransmitted_profile);
-
 	elems->crc = crc;
 
 	return elems;
-- 
2.37.3

