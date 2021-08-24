Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BDC33F672A
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241254AbhHXRbL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:31:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:34176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241338AbhHXR3M (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:29:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 435C7613AB;
        Tue, 24 Aug 2021 17:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824728;
        bh=naIbeR4Q0img5rV9yIyCU3Uxp5cahogBHpVBlchT/yE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=beiCc+Q8t8L67nboLcs8qW0QG3zCkxDyJoGess6M5AG6iUegTlcDXlEXftKy4BmHv
         Fxe+SziE7ap0vxDECGlAK3YyFMYkwu8WzJhDUj5NQYPnUINHs7Z3dTtxppgK3BZpYT
         ejbdJcsq+bUWilqgSrjDbMIVUbddph23Nfo+uDRReyWsdOT/826y23xZJTOu95+K4x
         atXmOChZ71Wqees+E+5O0x3b7/m8i8lf+HduCa1fW6OgpcYtgDYQdxTUfLcq/zRTpX
         vcPVfGDLlu/9eFQT1LmF/lPJ9VRqDxhgq+nJIF/woFP7cLCHtqvIb8uK+Y3lN50r38
         beWQf4REUlyFg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>, Jouni Malinen <j@w1.fi>,
        Luca Coelho <luciano.coelho@intel.com>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.14 30/64] mac80211: drop data frames without key on encrypted links
Date:   Tue, 24 Aug 2021 13:04:23 -0400
Message-Id: <20210824170457.710623-31-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170457.710623-1-sashal@kernel.org>
References: <20210824170457.710623-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.245-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.245-rc1
X-KernelTest-Deadline: 2021-08-26T17:04+00:00
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
index b15412c21ac9..d0fed5ceb2b7 100644
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
index d122031e389a..87ed1210295f 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -335,6 +335,7 @@ static void ieee80211_key_replace(struct ieee80211_sub_if_data *sdata,
 	if (sta) {
 		if (pairwise) {
 			rcu_assign_pointer(sta->ptk[idx], new);
+			set_sta_flag(sta, WLAN_STA_USES_ENCRYPTION);
 			sta->ptk_idx = idx;
 			ieee80211_check_fast_xmit(sta);
 		} else {
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index f1d293f5678f..154c26d473a8 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -101,6 +101,7 @@ enum ieee80211_sta_info_flags {
 	WLAN_STA_MPSP_OWNER,
 	WLAN_STA_MPSP_RECIPIENT,
 	WLAN_STA_PS_DELIVER,
+	WLAN_STA_USES_ENCRYPTION,
 
 	NUM_WLAN_STA_FLAGS,
 };
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 0ab710576673..c7e8935224c0 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -589,10 +589,13 @@ ieee80211_tx_h_select_key(struct ieee80211_tx_data *tx)
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
@@ -653,6 +656,9 @@ ieee80211_tx_h_select_key(struct ieee80211_tx_data *tx)
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

