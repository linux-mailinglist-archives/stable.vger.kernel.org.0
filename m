Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D6203ED7D4
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:44:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231232AbhHPNpK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:45:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:60152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230478AbhHPNpI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:45:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CCBE863282;
        Mon, 16 Aug 2021 13:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629121476;
        bh=DBLx5Qi1xn3W3lUbGH5/MbJacCST668Js48ekUZyKkU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aqz+j91WbqNXs+0TWqTn3VZHdph25VwNBZoh+3SAHxIOzR7iLrYyVQ2Lbx7BBZ4hC
         Gm/UIsvsK7vpnYgIpVH8vBAZofRdta8a5EXVLM1Eqg9Pl3y9dviRqSWYuIrI3oVwCh
         paj9AsP06bG+YT0eGbmx/CaMiDi6l3npoR86c8p1l3b+gaSDZ3S+B3+o5v3XVCAnl4
         /SOvbtnn+SWz6HbsT0Ex1qyiNmvu41eK0UtuVWtYKZEtJ5Y98CJqOdldomgxrU7dt+
         vVWbKSWqKfpOHlZ6qWdyr0ePsbRZc+8Bzby9TG24/OPWbNJPW8fVHvU7/BSSR1WMch
         IgQnzkFB2NXKA==
Received: by pali.im (Postfix)
        id CA4992B76; Mon, 16 Aug 2021 15:44:33 +0200 (CEST)
From:   =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To:     stable@vger.kernel.org
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        Sasha Levin <sashal@kernel.org>, Luca Coelho <luca@coelho.fi>,
        linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: drop data frames without key on encrypted links
Date:   Mon, 16 Aug 2021 15:44:24 +0200
Message-Id: <20210816134424.28191-1-pali@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200327150342.252AF20748@mail.kernel.org>
References: <20200327150342.252AF20748@mail.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

commit a0761a301746ec2d92d7fcb82af69c0a6a4339aa upstream.

If we know that we have an encrypted link (based on having had
a key configured for TX in the past) then drop all data frames
in the key selection handler if there's no key anymore.

This fixes an issue with mac80211 internal TXQs - there we can
buffer frames for an encrypted link, but then if the key is no
longer there when they're dequeued, the frames are sent without
encryption. This happens if a station is disconnected while the
frames are still on the TXQ.

Detecting that a link should be encrypted based on a first key
having been configured for TX is fine as there are no use cases
for a connection going from with encryption to no encryption.
With extended key IDs, however, there is a case of having a key
configured for only decryption, so we can't just trigger this
behaviour on a key being configured.

Cc: stable@vger.kernel.org
Reported-by: Jouni Malinen <j@w1.fi>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20200326150855.6865c7f28a14.I9fb1d911b064262d33e33dfba730cdeef83926ca@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
[pali: Backported to 4.19 and older versions]
Signed-off-by: Pali Rohár <pali@kernel.org>
---
 net/mac80211/debugfs_sta.c |  1 +
 net/mac80211/key.c         |  1 +
 net/mac80211/sta_info.h    |  1 +
 net/mac80211/tx.c          | 12 +++++++++---
 4 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index 4105081dc1df..6f390c2e4c8e 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -80,6 +80,7 @@ static const char * const sta_flag_names[] = {
 	FLAG(MPSP_OWNER),
 	FLAG(MPSP_RECIPIENT),
 	FLAG(PS_DELIVER),
+	FLAG(USES_ENCRYPTION),
 #undef FLAG
 };
 
diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index 6775d6cb7d3d..7fc55177db84 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -341,6 +341,7 @@ static void ieee80211_key_replace(struct ieee80211_sub_if_data *sdata,
 	if (sta) {
 		if (pairwise) {
 			rcu_assign_pointer(sta->ptk[idx], new);
+			set_sta_flag(sta, WLAN_STA_USES_ENCRYPTION);
 			sta->ptk_idx = idx;
 			ieee80211_check_fast_xmit(sta);
 		} else {
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index c33bc5fc0f2d..75d982ff7f3d 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -102,6 +102,7 @@ enum ieee80211_sta_info_flags {
 	WLAN_STA_MPSP_OWNER,
 	WLAN_STA_MPSP_RECIPIENT,
 	WLAN_STA_PS_DELIVER,
+	WLAN_STA_USES_ENCRYPTION,
 
 	NUM_WLAN_STA_FLAGS,
 };
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 98d048630ad2..3530d1a5fc98 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -593,10 +593,13 @@ ieee80211_tx_h_select_key(struct ieee80211_tx_data *tx)
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx->skb);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)tx->skb->data;
 
-	if (unlikely(info->flags & IEEE80211_TX_INTFL_DONT_ENCRYPT))
+	if (unlikely(info->flags & IEEE80211_TX_INTFL_DONT_ENCRYPT)) {
 		tx->key = NULL;
-	else if (tx->sta &&
-		 (key = rcu_dereference(tx->sta->ptk[tx->sta->ptk_idx])))
+		return TX_CONTINUE;
+	}
+
+	if (tx->sta &&
+	    (key = rcu_dereference(tx->sta->ptk[tx->sta->ptk_idx])))
 		tx->key = key;
 	else if (ieee80211_is_group_privacy_action(tx->skb) &&
 		(key = rcu_dereference(tx->sdata->default_multicast_key)))
@@ -657,6 +660,9 @@ ieee80211_tx_h_select_key(struct ieee80211_tx_data *tx)
 		if (!skip_hw && tx->key &&
 		    tx->key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE)
 			info->control.hw_key = &tx->key->conf;
+	} else if (!ieee80211_is_mgmt(hdr->frame_control) && tx->sta &&
+		   test_sta_flag(tx->sta, WLAN_STA_USES_ENCRYPTION)) {
+		return TX_DROP;
 	}
 
 	return TX_CONTINUE;
-- 
2.20.1

