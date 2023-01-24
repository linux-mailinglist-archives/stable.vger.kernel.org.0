Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D216D6796F3
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 12:45:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233897AbjAXLpe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 06:45:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233828AbjAXLpc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 06:45:32 -0500
Received: from ns2.wdyn.eu (ns2.wdyn.eu [IPv6:2a03:4000:40:5b2::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3E7583B652;
        Tue, 24 Jan 2023 03:45:29 -0800 (PST)
From:   Alexander Wetzel <alexander@wetzel-home.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=wetzel-home.de;
        s=wetzel-home; t=1674560725;
        bh=ueaOOEssXCx/XZD9ovp2eZuzf1Ukyz4ic9KSrbyuqqA=;
        h=From:To:Cc:Subject:Date;
        b=UVKfT44bNM7/J3j4OuZbUDMCVi++xz4o+L+jVvxzzMOlo7dtFFGRdbpvX+ERq+pWF
         vnhUwsKX/jqNSfbvPf62Vg024OJhrKOqkNSMytcbT7wzmAJNcNVyC6J9opXDUfAM3W
         V42jL7vpJw9smCNYHj4DenIogikzWSWxMBv1mR30=
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Alexander Wetzel <alexander@wetzel-home.de>,
        stable@vger.kernel.org
Subject: [PATCH] wifi: cfg80211: Fix use after free for wext
Date:   Tue, 24 Jan 2023 12:45:15 +0100
Message-Id: <20230124114515.186771-1-alexander@wetzel-home.de>
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
I was first wondering if the dangling scheduled work was part of the
problem. It's kind of pointless to schedule a work and then just do the job
yourself. While it turned out to be benign I still added it to the fix here.

Alexander
---
 net/wireless/sme.c | 29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)

diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 123248b2c0be..8d8176e31e31 100644
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
@@ -1464,6 +1476,13 @@ int cfg80211_connect(struct cfg80211_registered_device *rdev,
 	} else {
 		if (WARN_ON(connkeys))
 			return -EINVAL;
+
+		/* connect can point to wdev->connect
+		 * and may hold outdated key data
+		 */
+		connect->key = NULL;
+		connect->key_len = 0;
+		connect->key_idx = 0;
 	}
 
 	wdev->connect_keys = connkeys;
-- 
2.39.0

