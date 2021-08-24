Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1B3C3F67AB
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241595AbhHXRg3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:36:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:40580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242038AbhHXRe2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:34:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF30861BB3;
        Tue, 24 Aug 2021 17:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824796;
        bh=foClriLhbogmWjB0f890i0PurWB2UWh7C6w6rVtb5do=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sk+nPCxwK7AB4/qT+NC501QmZ+jx+gE/DbAu14Q5yPYvm5hN67ks41t6rFJU0UvOr
         EmjYp7WbOVv/Jd9RxlDXCgmsqBSr3zWjNFjXFjXuLgJ0uTvTzWCBeoRY1o+/AOu67j
         amY4YP4A9gJvg5B6c9UnPYiqC5EsIuem38EXTpWK1Xcsleg64FH41pa0pqH+xB6/J8
         RHgBxpILeESb5q1YueLDt7YKp9Kf8GjogdJllvJ28i76l4eK9YRCzFu+TmyxElUzjN
         zG0uCc5N5aQT7hnFXlWIiB7QN4O8b3NxraQtXwHSUZxmg/qWMzdkgoqW/naAcQTzVd
         p5prjsF02VrUQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>, Jouni Malinen <j@w1.fi>,
        Luca Coelho <luciano.coelho@intel.com>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.9 20/43] mac80211: drop data frames without key on encrypted links
Date:   Tue, 24 Aug 2021 13:05:51 -0400
Message-Id: <20210824170614.710813-21-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170614.710813-1-sashal@kernel.org>
References: <20210824170614.710813-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.281-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.281-rc1
X-KernelTest-Deadline: 2021-08-26T17:06+00:00
X-stable: review
X-Patchwork-Hint: Ignore
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/debugfs_sta.c |  1 +
 net/mac80211/key.c         |  1 +
 net/mac80211/sta_info.h    |  1 +
 net/mac80211/tx.c          | 12 +++++++++---
 4 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index 14ec63a02669..91b94ac9a88a 100644
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
index 4e23f240f599..a0d9507cb6a7 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -334,6 +334,7 @@ static void ieee80211_key_replace(struct ieee80211_sub_if_data *sdata,
 	if (sta) {
 		if (pairwise) {
 			rcu_assign_pointer(sta->ptk[idx], new);
+			set_sta_flag(sta, WLAN_STA_USES_ENCRYPTION);
 			sta->ptk_idx = idx;
 			ieee80211_check_fast_xmit(sta);
 		} else {
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index fd31c4db1282..0909332965bc 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -100,6 +100,7 @@ enum ieee80211_sta_info_flags {
 	WLAN_STA_MPSP_OWNER,
 	WLAN_STA_MPSP_RECIPIENT,
 	WLAN_STA_PS_DELIVER,
+	WLAN_STA_USES_ENCRYPTION,
 
 	NUM_WLAN_STA_FLAGS,
 };
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index eebbddccb47b..48d0dd0beaa5 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -588,10 +588,13 @@ ieee80211_tx_h_select_key(struct ieee80211_tx_data *tx)
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
@@ -652,6 +655,9 @@ ieee80211_tx_h_select_key(struct ieee80211_tx_data *tx)
 		if (!skip_hw && tx->key &&
 		    tx->key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE)
 			info->control.hw_key = &tx->key->conf;
+	} else if (!ieee80211_is_mgmt(hdr->frame_control) && tx->sta &&
+		   test_sta_flag(tx->sta, WLAN_STA_USES_ENCRYPTION)) {
+		return TX_DROP;
 	}
 
 	return TX_CONTINUE;
-- 
2.30.2

