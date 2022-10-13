Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 057325FE148
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 20:32:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231963AbiJMScY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 14:32:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232029AbiJMScE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 14:32:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F363194216;
        Thu, 13 Oct 2022 11:28:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7D56AB8206C;
        Thu, 13 Oct 2022 18:00:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8AABC433C1;
        Thu, 13 Oct 2022 18:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665684035;
        bh=iFDYfkZv+13hUjNnwoj0yShUJzr5cGRa6UiH4O+3Hu8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pV9DJ7/h7FGsGGF8d4EaYUWod/kjDVjxjAjTD/qG4kmM2x/Q9YzRdZ11gKkCJt5ZI
         1r3SfpIpP+SM5AS0BeZRbVi42as1DiZ60hP7kIs1QG0FUht6LjaT60uNP7UshnzQi2
         TxHs7GWvlkrWBt2vs2W5y9+dtq0F3OtOUkVqs7yA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ilan Peer <ilan.peer@intel.com>,
        Kees Cook <keescook@chromium.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.19 22/33] wifi: mac80211: fix MBSSID parsing use-after-free
Date:   Thu, 13 Oct 2022 19:52:54 +0200
Message-Id: <20221013175146.021304834@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221013175145.236739253@linuxfoundation.org>
References: <20221013175145.236739253@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

commit ff05d4b45dd89b922578dac497dcabf57cf771c6 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/ieee80211_i.h |    8 ++++++++
 net/mac80211/util.c        |   31 ++++++++++++++++---------------
 2 files changed, 24 insertions(+), 15 deletions(-)

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
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1503,25 +1503,28 @@ struct ieee802_11_elems *ieee802_11_pars
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
+	non_inherit =
+		cfg80211_find_ext_elem(WLAN_EID_EXT_NON_INHERITANCE,
+				       nontransmitted_profile,
+				       nontransmitted_profile_len);
 
 	crc = _ieee802_11_parse_elems_crc(start, len, action, elems, filter,
 					  crc, non_inherit);
@@ -1550,8 +1553,6 @@ struct ieee802_11_elems *ieee802_11_pars
 	    offsetofend(struct ieee80211_bssid_index, dtim_count))
 		elems->dtim_count = elems->bssid_index->dtim_count;
 
-	kfree(nontransmitted_profile);
-
 	elems->crc = crc;
 
 	return elems;


