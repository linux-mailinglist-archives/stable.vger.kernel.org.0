Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DA1F6B413D
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 14:50:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230463AbjCJNuw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 08:50:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230467AbjCJNuv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 08:50:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B9CFE7EC2
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 05:50:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C9FE860F11
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 13:50:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C429DC4339B;
        Fri, 10 Mar 2023 13:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678456249;
        bh=dwjk4MqKV8Plta4pZ0qNQeyJcvbXYxKxLPSDtQlWrlw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ffIoTz4t6BQWMCEeHhVAE25zyyueGNkH9jlwIhMR4+7L/UnKMpJEGeAyRZ2cBCLca
         wVMzVhU1kmnTgbI6KU8bl45K7FvKJKXv6lhEFfXbsNWRdRJkF128B6nSN8axMyGGSV
         AiE1Bzq9X0Nbd6Dshsu82zF4XK/QFBs8F5G1XZKE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Alexander Wetzel <alexander@wetzel-home.de>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4.14 130/193] wifi: cfg80211: Fix use after free for wext
Date:   Fri, 10 Mar 2023 14:38:32 +0100
Message-Id: <20230310133715.567564053@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133710.926811681@linuxfoundation.org>
References: <20230310133710.926811681@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Wetzel <alexander@wetzel-home.de>

commit 015b8cc5e7c4d7bb671f1984d7b7338c310b185b upstream.

Key information in wext.connect is not reset on (re)connect and can hold
data from a previous connection.

Reset key data to avoid that drivers or mac80211 incorrectly detect a
WEP connection request and access the freed or already reused memory.

Additionally optimize cfg80211_sme_connect() and avoid an useless
schedule of conn_work.

Fixes: fffd0934b939 ("cfg80211: rework key operation")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20230124141856.356646-1-alexander@wetzel-home.de
Signed-off-by: Alexander Wetzel <alexander@wetzel-home.de>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/wireless/sme.c |   31 ++++++++++++++++++++++++++-----
 1 file changed, 26 insertions(+), 5 deletions(-)

--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -269,6 +269,15 @@ void cfg80211_conn_work(struct work_stru
 	rtnl_unlock();
 }
 
+static void cfg80211_step_auth_next(struct cfg80211_conn *conn,
+				    struct cfg80211_bss *bss)
+{
+	memcpy(conn->bssid, bss->bssid, ETH_ALEN);
+	conn->params.bssid = conn->bssid;
+	conn->params.channel = bss->channel;
+	conn->state = CFG80211_CONN_AUTHENTICATE_NEXT;
+}
+
 /* Returned bss is reference counted and must be cleaned up appropriately. */
 static struct cfg80211_bss *cfg80211_get_conn_bss(struct wireless_dev *wdev)
 {
@@ -286,10 +295,7 @@ static struct cfg80211_bss *cfg80211_get
 	if (!bss)
 		return NULL;
 
-	memcpy(wdev->conn->bssid, bss->bssid, ETH_ALEN);
-	wdev->conn->params.bssid = wdev->conn->bssid;
-	wdev->conn->params.channel = bss->channel;
-	wdev->conn->state = CFG80211_CONN_AUTHENTICATE_NEXT;
+	cfg80211_step_auth_next(wdev->conn, bss);
 	schedule_work(&rdev->conn_work);
 
 	return bss;
@@ -568,7 +574,12 @@ static int cfg80211_sme_connect(struct w
 	wdev->conn->params.ssid_len = wdev->ssid_len;
 
 	/* see if we have the bss already */
-	bss = cfg80211_get_conn_bss(wdev);
+	bss = cfg80211_get_bss(wdev->wiphy, wdev->conn->params.channel,
+			       wdev->conn->params.bssid,
+			       wdev->conn->params.ssid,
+			       wdev->conn->params.ssid_len,
+			       wdev->conn_bss_type,
+			       IEEE80211_PRIVACY(wdev->conn->params.privacy));
 
 	if (prev_bssid) {
 		memcpy(wdev->conn->prev_bssid, prev_bssid, ETH_ALEN);
@@ -579,6 +590,7 @@ static int cfg80211_sme_connect(struct w
 	if (bss) {
 		enum nl80211_timeout_reason treason;
 
+		cfg80211_step_auth_next(wdev->conn, bss);
 		err = cfg80211_conn_do_work(wdev, &treason);
 		cfg80211_put_bss(wdev->wiphy, bss);
 	} else {
@@ -1128,6 +1140,15 @@ int cfg80211_connect(struct cfg80211_reg
 	} else {
 		if (WARN_ON(connkeys))
 			return -EINVAL;
+
+		/* connect can point to wdev->wext.connect which
+		 * can hold key data from a previous connection
+		 */
+		connect->key = NULL;
+		connect->key_len = 0;
+		connect->key_idx = 0;
+		connect->crypto.cipher_group = 0;
+		connect->crypto.n_ciphers_pairwise = 0;
 	}
 
 	wdev->connect_keys = connkeys;


