Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC1475FF26B
	for <lists+stable@lfdr.de>; Fri, 14 Oct 2022 18:42:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230434AbiJNQmo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 12:42:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230426AbiJNQmn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 12:42:43 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10E3C1974C6;
        Fri, 14 Oct 2022 09:42:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Content-Type:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=SWiY8E2PYOU7qDancAMB7gDkdEZZFUJTaCLA0z3cNxs=;
        t=1665765762; x=1666975362; b=JVfUwxokyEwJuplxLFAZMLZZQ0aBMyOCV9Ly4b5oKvDQhuI
        5YVWA7TSOrDWc3Bu1Z+xpNsD2sGkGoTWIdjrJtHAo7AQVcF13IvfBTFps8R7PZrp37DopLHT3RDxu
        4VK3yn2aPMm1gGsJXodH6B51pylE875yHbnpEQmlEIIF0zTNkBSZ/LArLQInpBZnWYjdKgSGcTtv/
        W7U6V/4rron9GSQgdRiOiEd9i4SKdzglUBms/qoe9TiNT/Y+mdhoyOHw86mPYzp+jTC4EYQ8ZES9G
        /B5Kqdk5JDOi0lMIJsoTrQjOt/IZyZGkl+qEe3bHtHks/4Q5CzNII/y7v6kvNLXw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1ojNla-006gql-2J;
        Fri, 14 Oct 2022 18:42:39 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org, stable@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Marcus Meissner <meissner@suse.de>,
        Jiri Kosina <jkosina@suse.de>,
        Johannes Berg <johannes.berg@intel.com>,
        Ilan Peer <ilan.peer@intel.com>,
        Kees Cook <keescook@chromium.org>
Subject: [RFC v5.10 3/3] wifi: mac80211: fix MBSSID parsing use-after-free
Date:   Fri, 14 Oct 2022 18:41:50 +0200
Message-Id: <20221014184133.bbea30b40ae3.I4691a91b83e1325524f786a638e853ccb49c2443@changeid>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221014164150.24310-1-johannes@sipsolutions.net>
References: <20221014164150.24310-1-johannes@sipsolutions.net>
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
This is a different version of the commit, changed to store
the non-transmitted profile in the elems, and freeing it in
the few places where it's relevant, since that is only the
case when the last argument for parsing (the non-tx BSSID)
is non-NULL.

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
 net/mac80211/ieee80211_i.h | 2 ++
 net/mac80211/mlme.c        | 6 +++++-
 net/mac80211/scan.c        | 2 ++
 net/mac80211/util.c        | 7 ++++++-
 4 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index e11f6d3fbd2b..63499db5c63d 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1551,6 +1551,8 @@ struct ieee802_11_elems {
 	u8 country_elem_len;
 	u8 bssid_index_len;
 
+	void *nontx_profile;
+
 	/* whether a parse error occurred while retrieving these elements */
 	bool parse_error;
 };
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 0163b835f608..c52b8eb7fb8a 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3394,6 +3394,7 @@ static bool ieee80211_assoc_success(struct ieee80211_sub_if_data *sdata,
 			sdata_info(sdata,
 				   "AP bug: VHT operation missing from AssocResp\n");
 		}
+		kfree(bss_elems.nontx_profile);
 	}
 
 	/*
@@ -4045,6 +4046,7 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 		ifmgd->assoc_data->timeout = jiffies;
 		ifmgd->assoc_data->timeout_started = true;
 		run_again(sdata, ifmgd->assoc_data->timeout);
+		kfree(elems.nontx_profile);
 		return;
 	}
 
@@ -4222,7 +4224,7 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 		ieee80211_report_disconnect(sdata, deauth_buf,
 					    sizeof(deauth_buf), true,
 					    WLAN_REASON_DEAUTH_LEAVING);
-		return;
+		goto free;
 	}
 
 	if (sta && elems.opmode_notif)
@@ -4237,6 +4239,8 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 					       elems.cisco_dtpc_elem);
 
 	ieee80211_bss_info_change_notify(sdata, changed);
+free:
+	kfree(elems.nontx_profile);
 }
 
 void ieee80211_sta_rx_queued_ext(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index d6afaacaf7ef..b241ff8c015a 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -227,6 +227,8 @@ ieee80211_bss_info_update(struct ieee80211_local *local,
 						rx_status, beacon);
 	}
 
+	kfree(elems.nontx_profile);
+
 	return bss;
 }
 
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index e6b5d164a0ee..7fa6efa8b83c 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1483,6 +1483,11 @@ u32 ieee802_11_parse_elems_crc(const u8 *start, size_t len, bool action,
 			cfg80211_find_ext_elem(WLAN_EID_EXT_NON_INHERITANCE,
 					       nontransmitted_profile,
 					       nontransmitted_profile_len);
+		if (!nontransmitted_profile_len) {
+			nontransmitted_profile_len = 0;
+			kfree(nontransmitted_profile);
+			nontransmitted_profile = NULL;
+		}
 	}
 
 	crc = _ieee802_11_parse_elems_crc(start, len, action, elems, filter,
@@ -1512,7 +1517,7 @@ u32 ieee802_11_parse_elems_crc(const u8 *start, size_t len, bool action,
 	    offsetofend(struct ieee80211_bssid_index, dtim_count))
 		elems->dtim_count = elems->bssid_index->dtim_count;
 
-	kfree(nontransmitted_profile);
+	elems->nontx_profile = nontransmitted_profile;
 
 	return crc;
 }
-- 
2.37.3

