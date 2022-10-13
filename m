Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D00A75FE14C
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 20:33:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230008AbiJMSdt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 14:33:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbiJMSdV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 14:33:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CBA517FD5F;
        Thu, 13 Oct 2022 11:29:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A026761A51;
        Thu, 13 Oct 2022 18:01:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFEA8C433D7;
        Thu, 13 Oct 2022 18:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665684096;
        bh=Ajm14oqIOS8bNZ+O27M/3u4Vz08BqrePq7KdTFY7v80=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hy2H85DMOI2HJ2ZZn20GJS61mnFdnhcLrmxKapiO0JL5uVO8wO+v8VfXBBKYmgUh9
         HByX3njDxrMwhaCjbGnhbJ+RgOLOOz9KzXw14wI+IBf8fWkASFdoG2KJwi1vR0o+GM
         WTaHk6mMU3/Ew4ExqI12h3cHrV2VLJIyjAM0bUYc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ilan Peer <ilan.peer@intel.com>,
        Kees Cook <keescook@chromium.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.0 23/34] wifi: mac80211: fix MBSSID parsing use-after-free
Date:   Thu, 13 Oct 2022 19:53:01 +0200
Message-Id: <20221013175147.118965481@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221013175146.507746257@linuxfoundation.org>
References: <20221013175146.507746257@linuxfoundation.org>
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
 net/mac80211/util.c        |   28 ++++++++++++++--------------
 2 files changed, 22 insertions(+), 14 deletions(-)

--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1704,6 +1704,14 @@ struct ieee802_11_elems {
 
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
@@ -1503,24 +1503,26 @@ ieee802_11_parse_elems_full(struct ieee8
 	const struct element *non_inherit = NULL;
 	u8 *nontransmitted_profile;
 	int nontransmitted_profile_len = 0;
+	size_t scratch_len = params->len;
 
-	elems = kzalloc(sizeof(*elems), GFP_ATOMIC);
+	elems = kzalloc(sizeof(*elems) + scratch_len, GFP_ATOMIC);
 	if (!elems)
 		return NULL;
 	elems->ie_start = params->start;
 	elems->total_len = params->len;
+	elems->scratch_len = scratch_len;
+	elems->scratch_pos = elems->scratch;
 
-	nontransmitted_profile = kmalloc(params->len, GFP_ATOMIC);
-	if (nontransmitted_profile) {
-		nontransmitted_profile_len =
-			ieee802_11_find_bssid_profile(params->start, params->len,
-						      elems, params->bss,
-						      nontransmitted_profile);
-		non_inherit =
-			cfg80211_find_ext_elem(WLAN_EID_EXT_NON_INHERITANCE,
-					       nontransmitted_profile,
-					       nontransmitted_profile_len);
-	}
+	nontransmitted_profile = elems->scratch_pos;
+	nontransmitted_profile_len =
+		ieee802_11_find_bssid_profile(params->start, params->len,
+					      elems, params->bss,
+					      nontransmitted_profile);
+	elems->scratch_pos += nontransmitted_profile_len;
+	elems->scratch_len -= nontransmitted_profile_len;
+	non_inherit = cfg80211_find_ext_elem(WLAN_EID_EXT_NON_INHERITANCE,
+					     nontransmitted_profile,
+					     nontransmitted_profile_len);
 
 	elems->crc = _ieee802_11_parse_elems_full(params, elems, non_inherit);
 
@@ -1554,8 +1556,6 @@ ieee802_11_parse_elems_full(struct ieee8
 	    offsetofend(struct ieee80211_bssid_index, dtim_count))
 		elems->dtim_count = elems->bssid_index->dtim_count;
 
-	kfree(nontransmitted_profile);
-
 	return elems;
 }
 


