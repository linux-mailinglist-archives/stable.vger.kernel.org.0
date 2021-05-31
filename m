Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35FC83968C2
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 22:28:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232132AbhEaUaZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 16:30:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232102AbhEaUaV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 May 2021 16:30:21 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAF14C061760;
        Mon, 31 May 2021 13:28:40 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1lnoWc-000F0y-RQ; Mon, 31 May 2021 22:28:38 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     stable@vger.kernel.org, Mathy Vanhoef <Mathy.Vanhoef@kuleuven.be>
Subject: [PATCH v4.4 02/10] mac80211: prevent mixed key and fragment cache attacks
Date:   Mon, 31 May 2021 22:28:26 +0200
Message-Id: <20210531202834.179810-3-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531202834.179810-1-johannes@sipsolutions.net>
References: <20210531202834.179810-1-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathy Vanhoef <Mathy.Vanhoef@kuleuven.be>

commit 94034c40ab4a3fcf581fbc7f8fdf4e29943c4a24 upstream.

Simultaneously prevent mixed key attacks (CVE-2020-24587) and fragment
cache attacks (CVE-2020-24586). This is accomplished by assigning a
unique color to every key (per interface) and using this to track which
key was used to decrypt a fragment. When reassembling frames, it is
now checked whether all fragments were decrypted using the same key.

To assure that fragment cache attacks are also prevented, the ID that is
assigned to keys is unique even over (re)associations and (re)connects.
This means fragments separated by a (re)association or (re)connect will
not be reassembled. Because mac80211 now also prevents the reassembly of
mixed encrypted and plaintext fragments, all cache attacks are prevented.

Cc: stable@vger.kernel.org
Signed-off-by: Mathy Vanhoef <Mathy.Vanhoef@kuleuven.be>
Link: https://lore.kernel.org/r/20210511200110.3f8290e59823.I622a67769ed39257327a362cfc09c812320eb979@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h | 1 +
 net/mac80211/key.c         | 7 +++++++
 net/mac80211/key.h         | 2 ++
 net/mac80211/rx.c          | 6 ++++++
 4 files changed, 16 insertions(+)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 1046520d726d..16510a57f2e7 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -94,6 +94,7 @@ struct ieee80211_fragment_entry {
 	u8 rx_queue;
 	bool check_sequential_pn; /* needed for CCMP/GCMP */
 	u8 last_pn[6]; /* PN of the last fragment if CCMP was used */
+	unsigned int key_color;
 };
 
 
diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index 91a4e606edcd..a2050d5776ce 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -646,6 +646,7 @@ int ieee80211_key_link(struct ieee80211_key *key,
 		       struct sta_info *sta)
 {
 	struct ieee80211_local *local = sdata->local;
+	static atomic_t key_color = ATOMIC_INIT(0);
 	struct ieee80211_key *old_key;
 	int idx = key->conf.keyidx;
 	bool pairwise = key->conf.flags & IEEE80211_KEY_FLAG_PAIRWISE;
@@ -680,6 +681,12 @@ int ieee80211_key_link(struct ieee80211_key *key,
 	key->sdata = sdata;
 	key->sta = sta;
 
+	/*
+	 * Assign a unique ID to every key so we can easily prevent mixed
+	 * key and fragment cache attacks.
+	 */
+	key->color = atomic_inc_return(&key_color);
+
 	increment_tailroom_need_count(sdata);
 
 	ieee80211_key_replace(sdata, sta, pairwise, old_key, key);
diff --git a/net/mac80211/key.h b/net/mac80211/key.h
index 9951ef06323e..9ac5c00dbe80 100644
--- a/net/mac80211/key.h
+++ b/net/mac80211/key.h
@@ -123,6 +123,8 @@ struct ieee80211_key {
 	} debugfs;
 #endif
 
+	unsigned int color;
+
 	/*
 	 * key config, must be last because it contains key
 	 * material as variable length member
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index eaad526cd0bf..85d7ac83d847 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1869,6 +1869,7 @@ ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
 			 * next fragment has a sequential PN value.
 			 */
 			entry->check_sequential_pn = true;
+			entry->key_color = rx->key->color;
 			memcpy(entry->last_pn,
 			       rx->key->u.ccmp.rx_pn[queue],
 			       IEEE80211_CCMP_PN_LEN);
@@ -1906,6 +1907,11 @@ ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
 
 		if (!requires_sequential_pn(rx, fc))
 			return RX_DROP_UNUSABLE;
+
+		/* Prevent mixed key and fragment cache attacks */
+		if (entry->key_color != rx->key->color)
+			return RX_DROP_UNUSABLE;
+
 		memcpy(pn, entry->last_pn, IEEE80211_CCMP_PN_LEN);
 		for (i = IEEE80211_CCMP_PN_LEN - 1; i >= 0; i--) {
 			pn[i]++;
-- 
2.31.1

