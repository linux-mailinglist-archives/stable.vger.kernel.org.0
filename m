Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E81D508CD
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:23:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730809AbfFXKVv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:21:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:57610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728680AbfFXKVu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 06:21:50 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7A9A20645;
        Mon, 24 Jun 2019 10:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561371710;
        bh=2O6klZl1Cu9YfcxPEx5jd2KAtElllTh3d9lfI4uuWps=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qqSO9PccA9A11ZM8UMM7M2hxxZEeL66mjTgveym5dTuj0LL5We/kBV2cTqzPPTsHC
         lTd4Njp9MwjmY2ClulhYw7s3pvPnNX0BsEFygbMIv64LDX0TAVQNqVKayJv//3yomt
         S6HQ6hQxFHgf/rCDYco7OnztJnpKz66/RgG7qT80=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yu Wang <yyuwang@codeaurora.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.1 118/121] mac80211: handle deauthentication/disassociation from TDLS peer
Date:   Mon, 24 Jun 2019 17:57:30 +0800
Message-Id: <20190624092326.652262919@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092320.652599624@linuxfoundation.org>
References: <20190624092320.652599624@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

Cc: stable@vger.kernel.org
Signed-off-by: Yu Wang <yyuwang@codeaurora.org>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/ieee80211_i.h |    3 +++
 net/mac80211/mlme.c        |   12 +++++++++++-
 net/mac80211/tdls.c        |   23 +++++++++++++++++++++++
 3 files changed, 37 insertions(+), 1 deletion(-)

--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -2222,6 +2222,9 @@ void ieee80211_tdls_cancel_channel_switc
 					  const u8 *addr);
 void ieee80211_teardown_tdls_peers(struct ieee80211_sub_if_data *sdata);
 void ieee80211_tdls_chsw_work(struct work_struct *wk);
+void ieee80211_tdls_handle_disconnect(struct ieee80211_sub_if_data *sdata,
+				      const u8 *peer, u16 reason);
+const char *ieee80211_get_reason_code_string(u16 reason_code);
 
 extern const struct ethtool_ops ieee80211_ethtool_ops;
 
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2963,7 +2963,7 @@ static void ieee80211_rx_mgmt_auth(struc
 #define case_WLAN(type) \
 	case WLAN_REASON_##type: return #type
 
-static const char *ieee80211_get_reason_code_string(u16 reason_code)
+const char *ieee80211_get_reason_code_string(u16 reason_code)
 {
 	switch (reason_code) {
 	case_WLAN(UNSPECIFIED);
@@ -3028,6 +3028,11 @@ static void ieee80211_rx_mgmt_deauth(str
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
@@ -3077,6 +3082,11 @@ static void ieee80211_rx_mgmt_disassoc(s
 
 	reason_code = le16_to_cpu(mgmt->u.disassoc.reason_code);
 
+	if (!ether_addr_equal(mgmt->bssid, mgmt->sa)) {
+		ieee80211_tdls_handle_disconnect(sdata, mgmt->sa, reason_code);
+		return;
+	}
+
 	sdata_info(sdata, "disassociated from %pM (Reason: %u=%s)\n",
 		   mgmt->sa, reason_code,
 		   ieee80211_get_reason_code_string(reason_code));
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -1994,3 +1994,26 @@ void ieee80211_tdls_chsw_work(struct wor
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


