Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E780D601305
	for <lists+stable@lfdr.de>; Mon, 17 Oct 2022 17:54:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbiJQPyA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 11:54:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbiJQPx7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 11:53:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B2856D860;
        Mon, 17 Oct 2022 08:53:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 38BD7B819B3;
        Mon, 17 Oct 2022 15:53:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55DEAC433D6;
        Mon, 17 Oct 2022 15:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666022035;
        bh=mAm7w1zt9Cc49iAQnqfI+eab3AEpR1NagpCNOaIkNuQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cVjjG3fGJT2Z7xFBLrjJaygX1CO20AHAZ0/KgZJTRdyT66q6wfWQHmO3ErFnWT9g0
         ImJWfOSOV5J2SrgxFV+uGMjUQci9lFrCQ5E6HfVz2JF2xGVssOlNuLE1Hsr5vbtPh+
         JvwqVuJ5Zg6FF830IOGuj/5AAoVFgXPdcCu6bY7k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.4.219
Date:   Mon, 17 Oct 2022 17:53:47 +0200
Message-Id: <1666022027246199@kroah.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <1666022027212254@kroah.com>
References: <1666022027212254@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index c26d5ce1d676..58325c33ef0c 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 4
-SUBLEVEL = 218
+SUBLEVEL = 219
 EXTRAVERSION =
 NAME = Kleptomaniac Octopus
 
diff --git a/fs/splice.c b/fs/splice.c
index ae5623244d5e..e509239d7e06 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -895,15 +895,17 @@ ssize_t splice_direct_to_actor(struct file *in, struct splice_desc *sd,
 {
 	struct pipe_inode_info *pipe;
 	long ret, bytes;
+	umode_t i_mode;
 	size_t len;
 	int i, flags, more;
 
 	/*
-	 * We require the input to be seekable, as we don't want to randomly
-	 * drop data for eg socket -> socket splicing. Use the piped splicing
-	 * for that!
+	 * We require the input being a regular file, as we don't want to
+	 * randomly drop data for eg socket -> socket splicing. Use the
+	 * piped splicing for that!
 	 */
-	if (unlikely(!(in->f_mode & FMODE_LSEEK)))
+	i_mode = file_inode(in)->i_mode;
+	if (unlikely(!S_ISREG(i_mode) && !S_ISBLK(i_mode)))
 		return -EINVAL;
 
 	/*
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 7747a6f46d29..f30a205323de 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1460,7 +1460,6 @@ struct ieee802_11_elems {
 	const u8 *supp_rates;
 	const u8 *ds_params;
 	const struct ieee80211_tim_ie *tim;
-	const u8 *challenge;
 	const u8 *rsn;
 	const u8 *erp_info;
 	const u8 *ext_supp_rates;
@@ -1507,7 +1506,6 @@ struct ieee802_11_elems {
 	u8 ssid_len;
 	u8 supp_rates_len;
 	u8 tim_len;
-	u8 challenge_len;
 	u8 rsn_len;
 	u8 ext_supp_rates_len;
 	u8 wmm_info_len;
@@ -1521,6 +1519,8 @@ struct ieee802_11_elems {
 	u8 country_elem_len;
 	u8 bssid_index_len;
 
+	void *nontx_profile;
+
 	/* whether a parse error occurred while retrieving these elements */
 	bool parse_error;
 };
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 5415e566e09d..b48a09043663 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2829,14 +2829,14 @@ static void ieee80211_auth_challenge(struct ieee80211_sub_if_data *sdata,
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_mgd_auth_data *auth_data = sdata->u.mgd.auth_data;
+	const struct element *challenge;
 	u8 *pos;
-	struct ieee802_11_elems elems;
 	u32 tx_flags = 0;
 
 	pos = mgmt->u.auth.variable;
-	ieee802_11_parse_elems(pos, len - (pos - (u8 *)mgmt), false, &elems,
-			       mgmt->bssid, auth_data->bss->bssid);
-	if (!elems.challenge)
+	challenge = cfg80211_find_elem(WLAN_EID_CHALLENGE, pos,
+				       len - (pos - (u8 *)mgmt));
+	if (!challenge)
 		return;
 	auth_data->expected_transaction = 4;
 	drv_mgd_prepare_tx(sdata->local, sdata, 0);
@@ -2844,7 +2844,8 @@ static void ieee80211_auth_challenge(struct ieee80211_sub_if_data *sdata,
 		tx_flags = IEEE80211_TX_CTL_REQ_TX_STATUS |
 			   IEEE80211_TX_INTFL_MLME_CONN_TX;
 	ieee80211_send_auth(sdata, 3, auth_data->algorithm, 0,
-			    elems.challenge - 2, elems.challenge_len + 2,
+			    (void *)challenge,
+			    challenge->datalen + sizeof(*challenge),
 			    auth_data->bss->bssid, auth_data->bss->bssid,
 			    auth_data->key, auth_data->key_len,
 			    auth_data->key_idx, tx_flags);
@@ -3223,7 +3224,7 @@ static bool ieee80211_assoc_success(struct ieee80211_sub_if_data *sdata,
 
 	pos = mgmt->u.assoc_resp.variable;
 	ieee802_11_parse_elems(pos, len - (pos - (u8 *)mgmt), false, &elems,
-			       mgmt->bssid, assoc_data->bss->bssid);
+			       mgmt->bssid, NULL);
 
 	if (!elems.supp_rates) {
 		sdata_info(sdata, "no SuppRates element in AssocResp\n");
@@ -3298,6 +3299,7 @@ static bool ieee80211_assoc_success(struct ieee80211_sub_if_data *sdata,
 			sdata_info(sdata,
 				   "AP bug: VHT operation missing from AssocResp\n");
 		}
+		kfree(bss_elems.nontx_profile);
 	}
 
 	/*
@@ -3575,7 +3577,7 @@ static void ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
 
 	pos = mgmt->u.assoc_resp.variable;
 	ieee802_11_parse_elems(pos, len - (pos - (u8 *)mgmt), false, &elems,
-			       mgmt->bssid, assoc_data->bss->bssid);
+			       mgmt->bssid, NULL);
 
 	if (status_code == WLAN_STATUS_ASSOC_REJECTED_TEMPORARILY &&
 	    elems.timeout_int &&
@@ -3882,6 +3884,7 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 		ifmgd->assoc_data->timeout = jiffies;
 		ifmgd->assoc_data->timeout_started = true;
 		run_again(sdata, ifmgd->assoc_data->timeout);
+		kfree(elems.nontx_profile);
 		return;
 	}
 
@@ -4049,7 +4052,7 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 		ieee80211_report_disconnect(sdata, deauth_buf,
 					    sizeof(deauth_buf), true,
 					    WLAN_REASON_DEAUTH_LEAVING);
-		return;
+		goto free;
 	}
 
 	if (sta && elems.opmode_notif)
@@ -4064,6 +4067,8 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
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
index a529861256e6..6223af1c3457 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1006,10 +1006,6 @@ _ieee802_11_parse_elems_crc(const u8 *start, size_t len, bool action,
 			} else
 				elem_parse_failed = true;
 			break;
-		case WLAN_EID_CHALLENGE:
-			elems->challenge = pos;
-			elems->challenge_len = elen;
-			break;
 		case WLAN_EID_VENDOR_SPECIFIC:
 			if (elen >= 4 && pos[0] == 0x00 && pos[1] == 0x50 &&
 			    pos[2] == 0xf2) {
@@ -1367,6 +1363,11 @@ u32 ieee802_11_parse_elems_crc(const u8 *start, size_t len, bool action,
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
@@ -1396,7 +1397,7 @@ u32 ieee802_11_parse_elems_crc(const u8 *start, size_t len, bool action,
 	    offsetofend(struct ieee80211_bssid_index, dtim_count))
 		elems->dtim_count = elems->bssid_index->dtim_count;
 
-	kfree(nontransmitted_profile);
+	elems->nontx_profile = nontransmitted_profile;
 
 	return crc;
 }
