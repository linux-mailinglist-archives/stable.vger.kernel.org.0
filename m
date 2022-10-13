Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84D9A5FE2C7
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 21:36:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbiJMTgW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 15:36:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229762AbiJMTgU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 15:36:20 -0400
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C26317C54A
        for <stable@vger.kernel.org>; Thu, 13 Oct 2022 12:36:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=It4jByTPo6kXjsj6KYFguxl1CvHt97DlNU4T6dSsI1I=; b=jWaF8srxFw1c2Vr7VyVPqtRM29
        o1g5WtWnGGaM+nxggFGsaiFvez0ioND2yNancvCpYyb4JBc9EgsRJwHqSXtglMOoEuzWsSnYQ6aRo
        q3b+lKkV6P43BHjSudTbp0Wf1Xa5sTSOCNwpKHrz4votoXHKlZyuTHiDg3LuaaDOryV4=;
Received: from p200300daa7301d0028e1e1004b08c350.dip0.t-ipconnect.de ([2003:da:a730:1d00:28e1:e100:4b08:c350] helo=Maecks.lan)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1oj2kU-00CXRx-RC; Thu, 13 Oct 2022 20:16:02 +0200
From:   Felix Fietkau <nbd@nbd.name>
To:     stable@vger.kernel.org
Cc:     johannes@sipsolutions.net
Subject: [PATCH 5.15 3/6] mac80211: mlme: find auth challenge directly
Date:   Thu, 13 Oct 2022 20:15:58 +0200
Message-Id: <20221013181601.5712-3-nbd@nbd.name>
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

commit 49a765d6785e99157ff5091cc37485732496864e upstream.

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
index 5ea38ae65809..c5f0ff805010 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1542,7 +1542,6 @@ struct ieee802_11_elems {
 	const u8 *supp_rates;
 	const u8 *ds_params;
 	const struct ieee80211_tim_ie *tim;
-	const u8 *challenge;
 	const u8 *rsn;
 	const u8 *rsnx;
 	const u8 *erp_info;
@@ -1596,7 +1595,6 @@ struct ieee802_11_elems {
 	u8 ssid_len;
 	u8 supp_rates_len;
 	u8 tim_len;
-	u8 challenge_len;
 	u8 rsn_len;
 	u8 rsnx_len;
 	u8 ext_supp_rates_len;
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 4414e82e71d1..548cd14c5503 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2889,17 +2889,17 @@ static void ieee80211_auth_challenge(struct ieee80211_sub_if_data *sdata,
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_mgd_auth_data *auth_data = sdata->u.mgd.auth_data;
+	const struct element *challenge;
 	u8 *pos;
-	struct ieee802_11_elems elems;
 	u32 tx_flags = 0;
 	struct ieee80211_prep_tx_info info = {
 		.subtype = IEEE80211_STYPE_AUTH,
 	};
 
 	pos = mgmt->u.auth.variable;
-	ieee802_11_parse_elems(pos, len - (pos - (u8 *)mgmt), false, &elems,
-			       mgmt->bssid, auth_data->bss->bssid);
-	if (!elems.challenge)
+	challenge = cfg80211_find_elem(WLAN_EID_CHALLENGE, pos,
+				       len - (pos - (u8 *)mgmt));
+	if (!challenge)
 		return;
 	auth_data->expected_transaction = 4;
 	drv_mgd_prepare_tx(sdata->local, sdata, &info);
@@ -2907,7 +2907,8 @@ static void ieee80211_auth_challenge(struct ieee80211_sub_if_data *sdata,
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
index ceb6894381e4..664c32b6db19 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1117,10 +1117,6 @@ _ieee802_11_parse_elems_crc(const u8 *start, size_t len, bool action,
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
2.36.1

