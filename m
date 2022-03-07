Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9BA54CF8FA
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 11:02:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239286AbiCGKDM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 05:03:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238690AbiCGJ44 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:56:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2B8012743;
        Mon,  7 Mar 2022 01:45:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C50D4612D0;
        Mon,  7 Mar 2022 09:45:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0C1CC340E9;
        Mon,  7 Mar 2022 09:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646342;
        bh=QUdh0uVObcrhkGuVsczLW+N7CVD1Iz/YmeTIiOq53Jw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OSiP9SfOjGw1Pji77Odr0FGyqAOelZuRxOuiRefGKMEcuAcleLY+mtZCNaL/uXgNl
         xUwQVDPtoHxR2Wc/j6DvDyS1zJ5rxLpV8YonNq0sR6z84xQbhX8+f/I58HGibapU+a
         29SpYTkPG2fOex1Ny1u3BC7PDVrubX1m541hxiFQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jouni Malinen <j@w1.fi>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.15 175/262] mac80211: treat some SAE auth steps as final
Date:   Mon,  7 Mar 2022 10:18:39 +0100
Message-Id: <20220307091707.359310522@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

commit 94d9864cc86f572f881db9b842a78e9d075493ae upstream.

When we get anti-clogging token required (added by the commit
mentioned below), or the other status codes added by the later
commit 4e56cde15f7d ("mac80211: Handle special status codes in
SAE commit") we currently just pretend (towards the internal
state machine of authentication) that we didn't receive anything.

This has the undesirable consequence of retransmitting the prior
frame, which is not expected, because the timer is still armed.

If we just disarm the timer at that point, it would result in
the undesirable side effect of being in this state indefinitely
if userspace crashes, or so.

So to fix this, reset the timer and set a new auth_data->waiting
in order to have no more retransmissions, but to have the data
destroyed when the timer actually fires, which will only happen
if userspace didn't continue (i.e. crashed or abandoned it.)

Fixes: a4055e74a2ff ("mac80211: Don't destroy auth data in case of anti-clogging")
Reported-by: Jouni Malinen <j@w1.fi>
Link: https://lore.kernel.org/r/20220224103932.75964e1d7932.Ia487f91556f29daae734bf61f8181404642e1eec@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/ieee80211_i.h |    2 +-
 net/mac80211/mlme.c        |   16 ++++++++++++----
 2 files changed, 13 insertions(+), 5 deletions(-)

--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -376,7 +376,7 @@ struct ieee80211_mgd_auth_data {
 
 	u8 key[WLAN_KEY_LEN_WEP104];
 	u8 key_len, key_idx;
-	bool done;
+	bool done, waiting;
 	bool peer_confirmed;
 	bool timeout_started;
 
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -37,6 +37,7 @@
 #define IEEE80211_AUTH_TIMEOUT_SAE	(HZ * 2)
 #define IEEE80211_AUTH_MAX_TRIES	3
 #define IEEE80211_AUTH_WAIT_ASSOC	(HZ * 5)
+#define IEEE80211_AUTH_WAIT_SAE_RETRY	(HZ * 2)
 #define IEEE80211_ASSOC_TIMEOUT		(HZ / 5)
 #define IEEE80211_ASSOC_TIMEOUT_LONG	(HZ / 2)
 #define IEEE80211_ASSOC_TIMEOUT_SHORT	(HZ / 10)
@@ -2994,8 +2995,15 @@ static void ieee80211_rx_mgmt_auth(struc
 		    (status_code == WLAN_STATUS_ANTI_CLOG_REQUIRED ||
 		     (auth_transaction == 1 &&
 		      (status_code == WLAN_STATUS_SAE_HASH_TO_ELEMENT ||
-		       status_code == WLAN_STATUS_SAE_PK))))
+		       status_code == WLAN_STATUS_SAE_PK)))) {
+			/* waiting for userspace now */
+			ifmgd->auth_data->waiting = true;
+			ifmgd->auth_data->timeout =
+				jiffies + IEEE80211_AUTH_WAIT_SAE_RETRY;
+			ifmgd->auth_data->timeout_started = true;
+			run_again(sdata, ifmgd->auth_data->timeout);
 			goto notify_driver;
+		}
 
 		sdata_info(sdata, "%pM denied authentication (status %d)\n",
 			   mgmt->sa, status_code);
@@ -4557,10 +4565,10 @@ void ieee80211_sta_work(struct ieee80211
 
 	if (ifmgd->auth_data && ifmgd->auth_data->timeout_started &&
 	    time_after(jiffies, ifmgd->auth_data->timeout)) {
-		if (ifmgd->auth_data->done) {
+		if (ifmgd->auth_data->done || ifmgd->auth_data->waiting) {
 			/*
-			 * ok ... we waited for assoc but userspace didn't,
-			 * so let's just kill the auth data
+			 * ok ... we waited for assoc or continuation but
+			 * userspace didn't do it, so kill the auth data
 			 */
 			ieee80211_destroy_auth_data(sdata, false);
 		} else if (ieee80211_auth(sdata)) {


