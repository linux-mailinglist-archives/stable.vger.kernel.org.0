Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A417D5FF266
	for <lists+stable@lfdr.de>; Fri, 14 Oct 2022 18:42:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230334AbiJNQmW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 12:42:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230332AbiJNQmV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 12:42:21 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC3AF1BE1CF;
        Fri, 14 Oct 2022 09:42:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Content-Type:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=KpXge4+rVoZIw8QW9HWNtJMdoQKNqLOLNcFesvoxsZU=;
        t=1665765740; x=1666975340; b=XSJJOlCmUzkoLBjmx/P42b7hBQpmRw2xmS8W+m5T8YZ6hEu
        I0NQYjn9BcapFqVD3j4RBKZiVgtdT5BKViV43w5282m8rB77pvacveHa5Yq5kX7KVtEgOlgGIC2OZ
        cBmmJbzgxKsNLUjM81riM9fvsEzytw9O7hNmqpbNZ29FsZgpfFtZzdVtw/RsfBKeCkZ4TwFfuFW0s
        NKe5SfLPLdPgc6MXgxJYxEWUKJiJYpXhK5QQY0a5wmJE9iw7n3Rt61Rr8Gn/0P4hMgGpXAbhvidoS
        PVUn8Ucg34jhHIcMlBMF9dDNu3zW18r6+hwm2nRyYG1fXb8FNtf3xQuvdetoCLWw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1ojNlH-006gql-20;
        Fri, 14 Oct 2022 18:42:16 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org, stable@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Marcus Meissner <meissner@suse.de>,
        Jiri Kosina <jkosina@suse.de>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [RFC v5.10 1/3] mac80211: mlme: find auth challenge directly
Date:   Fri, 14 Oct 2022 18:41:48 +0200
Message-Id: <20221014164150.24310-2-johannes@sipsolutions.net>
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

There's no need to parse all elements etc. just to find the
authentication challenge - use cfg80211_find_elem() instead.
This also allows us to remove WLAN_EID_CHALLENGE handling
from the element parsing entirely.

Link: https://lore.kernel.org/r/20210920154009.45f9b3a15722.Ice3159ffad03a007d6154cbf1fb3a8c48489e86f@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h |  2 --
 net/mac80211/mlme.c        | 11 ++++++-----
 net/mac80211/util.c        |  4 ----
 3 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index bcc94cc1b620..e11f6d3fbd2b 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1485,7 +1485,6 @@ struct ieee802_11_elems {
 	const u8 *supp_rates;
 	const u8 *ds_params;
 	const struct ieee80211_tim_ie *tim;
-	const u8 *challenge;
 	const u8 *rsn;
 	const u8 *rsnx;
 	const u8 *erp_info;
@@ -1538,7 +1537,6 @@ struct ieee802_11_elems {
 	u8 ssid_len;
 	u8 supp_rates_len;
 	u8 tim_len;
-	u8 challenge_len;
 	u8 rsn_len;
 	u8 rsnx_len;
 	u8 ext_supp_rates_len;
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 3988403064ab..9e70cb86b420 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2899,14 +2899,14 @@ static void ieee80211_auth_challenge(struct ieee80211_sub_if_data *sdata,
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
@@ -2914,7 +2914,8 @@ static void ieee80211_auth_challenge(struct ieee80211_sub_if_data *sdata,
 		tx_flags = IEEE80211_TX_CTL_REQ_TX_STATUS |
 			   IEEE80211_TX_INTFL_MLME_CONN_TX;
 	ieee80211_send_auth(sdata, 3, auth_data->algorithm, 0,
-			    elems.challenge - 2, elems.challenge_len + 2,
+			    (void *)challenge,
+			    challenge->datalen + sizeof(*challenge),
 			    auth_data->bss->bssid, auth_data->bss->bssid,
 			    auth_data->key, auth_data->key_len,
 			    auth_data->key_idx, tx_flags);
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 11d5686893c6..e6b5d164a0ee 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1124,10 +1124,6 @@ _ieee802_11_parse_elems_crc(const u8 *start, size_t len, bool action,
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
-- 
2.37.3

