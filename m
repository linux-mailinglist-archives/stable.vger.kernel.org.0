Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE8BB679BA3
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 15:22:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234069AbjAXOW3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 09:22:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234664AbjAXOW2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 09:22:28 -0500
Received: from ns2.wdyn.eu (ns2.wdyn.eu [IPv6:2a03:4000:40:5b2::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 12B9D8E;
        Tue, 24 Jan 2023 06:22:08 -0800 (PST)
From:   Alexander Wetzel <alexander@wetzel-home.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=wetzel-home.de;
        s=wetzel-home; t=1674570126;
        bh=pXJdbbsxWGnLLPpXbOLRYT8yZ0cLmYHXZUm5pq/GWWA=;
        h=From:To:Cc:Subject:Date;
        b=Wl77VnMc7RMg5urwC5VCXUPFN4hPG+3Qygb2dpi9L4pzqZi270jAqGg1jj7zOUgAR
         gER7lz8sZgZDURcuNDY23yG21tHYlRUdnO9b+HWLhTTlPi3u0V2NnLA3RCAb+nTkan
         oLmSS6qlc8FfMoWw9cZCNwPhdtfFqgxk7gFcTgBE=
To:     linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net,
        Alexander Wetzel <alexander@wetzel-home.de>,
        stable@vger.kernel.org
Subject: [PATCH v2] wifi: cfg80211: Fix use after free for wext
Date:   Tue, 24 Jan 2023 15:18:56 +0100
Message-Id: <20230124141856.356646-1-alexander@wetzel-home.de>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Key information in wext.connect is not reset on (re)connect and can hold
data from a previous connection.

Reset key data to avoid that drivers or mac80211 incorrectly detect a
WEP connection request and access the freed or already reused memory.

Additionally optimize cfg80211_sme_connect() and avoid an useless
schedule of conn_work.

Fixes: fffd0934b939 ("cfg80211: rework key operation")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/c80f04d2-8159-a02a-9287-26e5ec838826@wetzel-home.de
Signed-off-by: Alexander Wetzel <alexander@wetzel-home.de>

---
V2 changes:
- updated comment
- reset more key data

---
 net/wireless/sme.c | 31 ++++++++++++++++++++++++++-----
 1 file changed, 26 insertions(+), 5 deletions(-)

diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 123248b2c0be..0cc841c0c59b 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -285,6 +285,15 @@ void cfg80211_conn_work(struct work_struct *work)
 	wiphy_unlock(&rdev->wiphy);
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
@@ -302,10 +311,7 @@ static struct cfg80211_bss *cfg80211_get_conn_bss(struct wireless_dev *wdev)
 	if (!bss)
 		return NULL;
 
-	memcpy(wdev->conn->bssid, bss->bssid, ETH_ALEN);
-	wdev->conn->params.bssid = wdev->conn->bssid;
-	wdev->conn->params.channel = bss->channel;
-	wdev->conn->state = CFG80211_CONN_AUTHENTICATE_NEXT;
+	cfg80211_step_auth_next(wdev->conn, bss);
 	schedule_work(&rdev->conn_work);
 
 	return bss;
@@ -597,7 +603,12 @@ static int cfg80211_sme_connect(struct wireless_dev *wdev,
 	wdev->conn->params.ssid_len = wdev->u.client.ssid_len;
 
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
@@ -608,6 +619,7 @@ static int cfg80211_sme_connect(struct wireless_dev *wdev,
 	if (bss) {
 		enum nl80211_timeout_reason treason;
 
+		cfg80211_step_auth_next(wdev->conn, bss);
 		err = cfg80211_conn_do_work(wdev, &treason);
 		cfg80211_put_bss(wdev->wiphy, bss);
 	} else {
@@ -1464,6 +1476,15 @@ int cfg80211_connect(struct cfg80211_registered_device *rdev,
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
-- 
2.39.0

