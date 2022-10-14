Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E96145FF283
	for <lists+stable@lfdr.de>; Fri, 14 Oct 2022 18:48:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230044AbiJNQsT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 12:48:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229994AbiJNQsL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 12:48:11 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AC411C97D6;
        Fri, 14 Oct 2022 09:48:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Content-Type:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=GECKQhOYk4SRCHi7X/tcBe1wmEDBMxeEoS0zQhgrTvk=;
        t=1665766088; x=1666975688; b=hrBD6fgmVf6NZfX1gngYAVN1DJf2kWQXR/mB28ecHn86vsF
        QbtzeAwFbMEofH0i/vsRbTiF/0x5nLNOvQaTHAXXLzSQGTqNT0AIn4Ys1n0yFgJ4I24oqEImc8x9n
        Kb2O1OXjMHUwMPGLx4B0qDX+HsRphpD4vAn7pHGr0vIhcxPkP+Hm2JGQVuID+vIp7OTM+ojkN2NAV
        MXUaj9i5j2qnxXzvpI2jVxG1Rrbton37c9l7YTm+mVKmwAD4KxBHlSX+8H8AVNVCeXgWQcyT9oatK
        CJL1VedbHvzX7fTKZZJW6MDc9n2T1IcyxTner6EOLr2cX+hIN6BepCHrP8TkbGSg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1ojNqr-006gzN-0U;
        Fri, 14 Oct 2022 18:48:03 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org, stable@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Marcus Meissner <meissner@suse.de>,
        Jiri Kosina <jkosina@suse.de>,
        Steve deRosier <steve.derosier@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Ilan Peer <ilan.peer@intel.com>,
        Kees Cook <keescook@chromium.org>
Subject: [RFC v5.4 3/3] wifi: mac80211: fix MBSSID parsing use-after-free
Date:   Fri, 14 Oct 2022 18:47:05 +0200
Message-Id: <20221014184650.0065abf86cc0.I4691a91b83e1325524f786a638e853ccb49c2443@changeid>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221014164705.31486-1-johannes@sipsolutions.net>
References: <20221014164705.31486-1-johannes@sipsolutions.net>
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
index 3d5da7a97be4..f30a205323de 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1519,6 +1519,8 @@ struct ieee802_11_elems {
 	u8 country_elem_len;
 	u8 bssid_index_len;
 
+	void *nontx_profile;
+
 	/* whether a parse error occurred while retrieving these elements */
 	bool parse_error;
 };
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 7d116aa4ea1f..b48a09043663 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3299,6 +3299,7 @@ static bool ieee80211_assoc_success(struct ieee80211_sub_if_data *sdata,
 			sdata_info(sdata,
 				   "AP bug: VHT operation missing from AssocResp\n");
 		}
+		kfree(bss_elems.nontx_profile);
 	}
 
 	/*
@@ -3883,6 +3884,7 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 		ifmgd->assoc_data->timeout = jiffies;
 		ifmgd->assoc_data->timeout_started = true;
 		run_again(sdata, ifmgd->assoc_data->timeout);
+		kfree(elems.nontx_profile);
 		return;
 	}
 
@@ -4050,7 +4052,7 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 		ieee80211_report_disconnect(sdata, deauth_buf,
 					    sizeof(deauth_buf), true,
 					    WLAN_REASON_DEAUTH_LEAVING);
-		return;
+		goto free;
 	}
 
 	if (sta && elems.opmode_notif)
@@ -4065,6 +4067,8 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 					       elems.cisco_dtpc_elem);
 
 	ieee80211_bss_info_change_notify(sdata, changed);
+free:
+	kfree(elems.nontx_profile);
 }
 
 void ieee80211_sta_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index c353162e81ae..ee65f1f50a0a 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -216,6 +216,8 @@ ieee80211_bss_info_update(struct ieee80211_local *local,
 						rx_status, beacon);
 	}
 
+	kfree(elems.nontx_profile);
+
 	return bss;
 }
 
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 1ba37f67a2a0..6223af1c3457 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1363,6 +1363,11 @@ u32 ieee802_11_parse_elems_crc(const u8 *start, size_t len, bool action,
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
@@ -1392,7 +1397,7 @@ u32 ieee802_11_parse_elems_crc(const u8 *start, size_t len, bool action,
 	    offsetofend(struct ieee80211_bssid_index, dtim_count))
 		elems->dtim_count = elems->bssid_index->dtim_count;
 
-	kfree(nontransmitted_profile);
+	elems->nontx_profile = nontransmitted_profile;
 
 	return crc;
 }
-- 
2.37.3

