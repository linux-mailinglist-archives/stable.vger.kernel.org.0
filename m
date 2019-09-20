Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8480B92C6
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 16:35:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388136AbfITOf1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 10:35:27 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36052 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388135AbfITOZE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 10:25:04 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqH-000514-O9; Fri, 20 Sep 2019 15:25:01 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqH-0007xu-0M; Fri, 20 Sep 2019 15:25:01 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Yu Wang" <yyuwang@codeaurora.org>,
        "Johannes Berg" <johannes.berg@intel.com>
Date:   Fri, 20 Sep 2019 15:23:35 +0100
Message-ID: <lsq.1568989415.312987132@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 109/132] mac80211: handle deauthentication/disassociation
 from TDLS peer
In-Reply-To: <lsq.1568989414.954567518@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.74-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Wang <yyuwang@codeaurora.org>

commit 79c92ca42b5a3e0ea172ea2ce8df8e125af237da upstream.

When receiving a deauthentication/disassociation frame from a TDLS
peer, a station should not disconnect the current AP, but only
disable the current TDLS link if it's enabled.

Without this change, a TDLS issue can be reproduced by following the
steps as below:

1. STA-1 and STA-2 are connected to AP, bidirection traffic is running
   between STA-1 and STA-2.
2. Set up TDLS link between STA-1 and STA-2, stay for a while, then
   teardown TDLS link.
3. Repeat step #2 and monitor the connection between STA and AP.

During the test, one STA may send a deauthentication/disassociation
frame to another, after TDLS teardown, with reason code 6/7, which
means: Class 2/3 frame received from nonassociated STA.

On receive this frame, the receiver STA will disconnect the current
AP and then reconnect. It's not a expected behavior, purpose of this
frame should be disabling the TDLS link, not the link with AP.

Signed-off-by: Yu Wang <yyuwang@codeaurora.org>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
[bwh: Backported to 3.16:
 - Initialise reason_code earlier in ieee80211_rx_mgmt_deauth()
 - Adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1858,6 +1858,9 @@ int ieee80211_tdls_mgmt(struct wiphy *wi
 			const u8 *extra_ies, size_t extra_ies_len);
 int ieee80211_tdls_oper(struct wiphy *wiphy, struct net_device *dev,
 			const u8 *peer, enum nl80211_tdls_operation oper);
+void ieee80211_tdls_handle_disconnect(struct ieee80211_sub_if_data *sdata,
+				      const u8 *peer, u16 reason);
+const char *ieee80211_get_reason_code_string(u16 reason_code);
 
 
 #ifdef CONFIG_MAC80211_NOINLINE
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2298,7 +2298,7 @@ static void ieee80211_rx_mgmt_auth(struc
 #define case_WLAN(type) \
 	case WLAN_REASON_##type: return #type
 
-static const char *ieee80211_get_reason_code_string(u16 reason_code)
+const char *ieee80211_get_reason_code_string(u16 reason_code)
 {
 	switch (reason_code) {
 	case_WLAN(UNSPECIFIED);
@@ -2357,21 +2357,24 @@ static void ieee80211_rx_mgmt_deauth(str
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	const u8 *bssid = NULL;
-	u16 reason_code;
+	u16 reason_code = le16_to_cpu(mgmt->u.deauth.reason_code);
 
 	sdata_assert_lock(sdata);
 
 	if (len < 24 + 2)
 		return;
 
+	if (!ether_addr_equal(mgmt->bssid, mgmt->sa)) {
+		ieee80211_tdls_handle_disconnect(sdata, mgmt->sa, reason_code);
+		return;
+	}
+
 	if (!ifmgd->associated ||
 	    !ether_addr_equal(mgmt->bssid, ifmgd->associated->bssid))
 		return;
 
 	bssid = ifmgd->associated->bssid;
 
-	reason_code = le16_to_cpu(mgmt->u.deauth.reason_code);
-
 	sdata_info(sdata, "deauthenticated from %pM (Reason: %u=%s)\n",
 		   bssid, reason_code, ieee80211_get_reason_code_string(reason_code));
 
@@ -2398,6 +2401,11 @@ static void ieee80211_rx_mgmt_disassoc(s
 
 	reason_code = le16_to_cpu(mgmt->u.disassoc.reason_code);
 
+	if (!ether_addr_equal(mgmt->bssid, mgmt->sa)) {
+		ieee80211_tdls_handle_disconnect(sdata, mgmt->sa, reason_code);
+		return;
+	}
+
 	sdata_info(sdata, "disassociated from %pM (Reason: %u)\n",
 		   mgmt->sa, reason_code);
 
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -340,3 +340,26 @@ void ieee80211_tdls_oper_request(struct
 	cfg80211_tdls_oper_request(sdata->dev, peer, oper, reason_code, gfp);
 }
 EXPORT_SYMBOL(ieee80211_tdls_oper_request);
+
+void ieee80211_tdls_handle_disconnect(struct ieee80211_sub_if_data *sdata,
+				      const u8 *peer, u16 reason)
+{
+	struct ieee80211_sta *sta;
+
+	rcu_read_lock();
+	sta = ieee80211_find_sta(&sdata->vif, peer);
+	if (!sta || !sta->tdls) {
+		rcu_read_unlock();
+		return;
+	}
+	rcu_read_unlock();
+
+	tdls_dbg(sdata, "disconnected from TDLS peer %pM (Reason: %u=%s)\n",
+		 peer, reason,
+		 ieee80211_get_reason_code_string(reason));
+
+	ieee80211_tdls_oper_request(&sdata->vif, peer,
+				    NL80211_TDLS_TEARDOWN,
+				    WLAN_REASON_TDLS_TEARDOWN_UNREACHABLE,
+				    GFP_ATOMIC);
+}

