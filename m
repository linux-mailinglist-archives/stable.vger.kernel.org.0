Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5763A5FFD9D
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 08:45:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229798AbiJPGpp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 02:45:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229799AbiJPGpo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 02:45:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5710333423;
        Sat, 15 Oct 2022 23:45:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 613FB60A6F;
        Sun, 16 Oct 2022 06:45:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73F2AC433C1;
        Sun, 16 Oct 2022 06:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665902736;
        bh=DATtFxyW73e4CfeKhfHyo634vm8S27gJN70GI7pPcNw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1xvefH7iBIPVHyJvqneBZ9/ndfW+MwJtItFE2IZ/5B67NUhod6RfBDyf7HVxJu0sE
         giafrGLCt4Puru/CvSjWjBuP4VBjQzAfD8Zkr0G8tuE0mMG+AZQ7o+FIIubPx98QOp
         zUe43xRrgCYcP1kuK4Ie/870oI/TFHahBcW6ZR1g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.10 2/4] mac80211: mlme: find auth challenge directly
Date:   Sun, 16 Oct 2022 08:46:12 +0200
Message-Id: <20221016064454.457942478@linuxfoundation.org>
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

There's no need to parse all elements etc. just to find the
authentication challenge - use cfg80211_find_elem() instead.
This also allows us to remove WLAN_EID_CHALLENGE handling
from the element parsing entirely.

Link: https://lore.kernel.org/r/20210920154009.45f9b3a15722.Ice3159ffad03a007d6154cbf1fb3a8c48489e86f@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/ieee80211_i.h |    2 --
 net/mac80211/mlme.c        |   11 ++++++-----
 net/mac80211/util.c        |    4 ----
 3 files changed, 6 insertions(+), 11 deletions(-)

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
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2899,14 +2899,14 @@ static void ieee80211_auth_challenge(str
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
@@ -2914,7 +2914,8 @@ static void ieee80211_auth_challenge(str
 		tx_flags = IEEE80211_TX_CTL_REQ_TX_STATUS |
 			   IEEE80211_TX_INTFL_MLME_CONN_TX;
 	ieee80211_send_auth(sdata, 3, auth_data->algorithm, 0,
-			    elems.challenge - 2, elems.challenge_len + 2,
+			    (void *)challenge,
+			    challenge->datalen + sizeof(*challenge),
 			    auth_data->bss->bssid, auth_data->bss->bssid,
 			    auth_data->key, auth_data->key_len,
 			    auth_data->key_idx, tx_flags);
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1124,10 +1124,6 @@ _ieee802_11_parse_elems_crc(const u8 *st
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


