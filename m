Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C96415FFD9F
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 08:45:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbiJPGpu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 02:45:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbiJPGpq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 02:45:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D80B23640B;
        Sat, 15 Oct 2022 23:45:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C1471B8085D;
        Sun, 16 Oct 2022 06:45:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 193FBC433C1;
        Sun, 16 Oct 2022 06:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665902742;
        bh=0ZJ2LFMzVXl5F47JimqShryDmS3PyF4FnsQtVAmloX8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D8uK9pJz9Mojebeda5EB5gQS0gbyHdswywKTz7bTgFvYWctziushWr+MeuXRKinm2
         yz1/3pNGF0TCzJmlbyo+9KI4wNoEN2s+bOghHjoUii6Zu1Rat8cPZqPK4ufjhPKfzk
         A9ZhNUSV6euxA9AiEVp7uLa2L6OXdlWwsZqS3Y8w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ilan Peer <ilan.peer@intel.com>,
        Kees Cook <keescook@chromium.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.10 4/4] wifi: mac80211: fix MBSSID parsing use-after-free
Date:   Sun, 16 Oct 2022 08:46:14 +0200
Message-Id: <20221016064454.521268644@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221016064454.382206984@linuxfoundation.org>
References: <20221016064454.382206984@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/ieee80211_i.h |    2 ++
 net/mac80211/mlme.c        |    6 +++++-
 net/mac80211/scan.c        |    2 ++
 net/mac80211/util.c        |    7 ++++++-
 4 files changed, 15 insertions(+), 2 deletions(-)

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
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3394,6 +3394,7 @@ static bool ieee80211_assoc_success(stru
 			sdata_info(sdata,
 				   "AP bug: VHT operation missing from AssocResp\n");
 		}
+		kfree(bss_elems.nontx_profile);
 	}
 
 	/*
@@ -4045,6 +4046,7 @@ static void ieee80211_rx_mgmt_beacon(str
 		ifmgd->assoc_data->timeout = jiffies;
 		ifmgd->assoc_data->timeout_started = true;
 		run_again(sdata, ifmgd->assoc_data->timeout);
+		kfree(elems.nontx_profile);
 		return;
 	}
 
@@ -4222,7 +4224,7 @@ static void ieee80211_rx_mgmt_beacon(str
 		ieee80211_report_disconnect(sdata, deauth_buf,
 					    sizeof(deauth_buf), true,
 					    WLAN_REASON_DEAUTH_LEAVING);
-		return;
+		goto free;
 	}
 
 	if (sta && elems.opmode_notif)
@@ -4237,6 +4239,8 @@ static void ieee80211_rx_mgmt_beacon(str
 					       elems.cisco_dtpc_elem);
 
 	ieee80211_bss_info_change_notify(sdata, changed);
+free:
+	kfree(elems.nontx_profile);
 }
 
 void ieee80211_sta_rx_queued_ext(struct ieee80211_sub_if_data *sdata,
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -227,6 +227,8 @@ ieee80211_bss_info_update(struct ieee802
 						rx_status, beacon);
 	}
 
+	kfree(elems.nontx_profile);
+
 	return bss;
 }
 
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1483,6 +1483,11 @@ u32 ieee802_11_parse_elems_crc(const u8
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
@@ -1512,7 +1517,7 @@ u32 ieee802_11_parse_elems_crc(const u8
 	    offsetofend(struct ieee80211_bssid_index, dtim_count))
 		elems->dtim_count = elems->bssid_index->dtim_count;
 
-	kfree(nontransmitted_profile);
+	elems->nontx_profile = nontransmitted_profile;
 
 	return crc;
 }


