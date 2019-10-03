Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3755ACABD2
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:45:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727587AbfJCQAn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:00:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:44562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729838AbfJCQAm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:00:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D070920700;
        Thu,  3 Oct 2019 16:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570118441;
        bh=4P6MSDnzsesx6pv5JsKnOe6/ahOueIEhgfYHMzGTTjU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=16REERKDipfuUqBSq1iW2ycAzK9kBCLtQTqqXr4C09t9X1mS0eXHITrekFUaWeBL/
         AsO/x/AwlhA57OZruxTQgKat47+DDXKe294iJ1m6tuRbe9fDtAtI8A0PrJA9Ey7EvT
         BjSVkUJpJOTF44LgfYTBPl1wTQ33fIFg9Yh7Mr3g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yu Wang <yyuwang@codeaurora.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 013/129] mac80211: handle deauthentication/disassociation from TDLS peer
Date:   Thu,  3 Oct 2019 17:52:16 +0200
Message-Id: <20191003154324.605928554@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154318.081116689@linuxfoundation.org>
References: <20191003154318.081116689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yu Wang <yyuwang@codeaurora.org>

[ Upstream commit 79c92ca42b5a3e0ea172ea2ce8df8e125af237da ]

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

Cc: stable@vger.kernel.org
Signed-off-by: Yu Wang <yyuwang@codeaurora.org>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/ieee80211_i.h |  3 +++
 net/mac80211/mlme.c        | 12 +++++++++++-
 net/mac80211/tdls.c        | 23 +++++++++++++++++++++++
 3 files changed, 37 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 6708de10a3e5e..0b0de3030e0dc 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -2123,6 +2123,9 @@ void ieee80211_tdls_cancel_channel_switch(struct wiphy *wiphy,
 					  const u8 *addr);
 void ieee80211_teardown_tdls_peers(struct ieee80211_sub_if_data *sdata);
 void ieee80211_tdls_chsw_work(struct work_struct *wk);
+void ieee80211_tdls_handle_disconnect(struct ieee80211_sub_if_data *sdata,
+				      const u8 *peer, u16 reason);
+const char *ieee80211_get_reason_code_string(u16 reason_code);
 
 extern const struct ethtool_ops ieee80211_ethtool_ops;
 
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 090e2aa8630e8..c75594a12c38e 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2755,7 +2755,7 @@ static void ieee80211_rx_mgmt_auth(struct ieee80211_sub_if_data *sdata,
 #define case_WLAN(type) \
 	case WLAN_REASON_##type: return #type
 
-static const char *ieee80211_get_reason_code_string(u16 reason_code)
+const char *ieee80211_get_reason_code_string(u16 reason_code)
 {
 	switch (reason_code) {
 	case_WLAN(UNSPECIFIED);
@@ -2820,6 +2820,11 @@ static void ieee80211_rx_mgmt_deauth(struct ieee80211_sub_if_data *sdata,
 	if (len < 24 + 2)
 		return;
 
+	if (!ether_addr_equal(mgmt->bssid, mgmt->sa)) {
+		ieee80211_tdls_handle_disconnect(sdata, mgmt->sa, reason_code);
+		return;
+	}
+
 	if (ifmgd->associated &&
 	    ether_addr_equal(mgmt->bssid, ifmgd->associated->bssid)) {
 		const u8 *bssid = ifmgd->associated->bssid;
@@ -2869,6 +2874,11 @@ static void ieee80211_rx_mgmt_disassoc(struct ieee80211_sub_if_data *sdata,
 
 	reason_code = le16_to_cpu(mgmt->u.disassoc.reason_code);
 
+	if (!ether_addr_equal(mgmt->bssid, mgmt->sa)) {
+		ieee80211_tdls_handle_disconnect(sdata, mgmt->sa, reason_code);
+		return;
+	}
+
 	sdata_info(sdata, "disassociated from %pM (Reason: %u=%s)\n",
 		   mgmt->sa, reason_code,
 		   ieee80211_get_reason_code_string(reason_code));
diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
index c64ae68ae4f84..863f92c087014 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -2001,3 +2001,26 @@ void ieee80211_tdls_chsw_work(struct work_struct *wk)
 	}
 	rtnl_unlock();
 }
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
-- 
2.20.1



