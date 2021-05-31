Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B483C395BE4
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:24:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231796AbhEaNZo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:25:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:55060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231822AbhEaNXs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:23:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0864160FE8;
        Mon, 31 May 2021 13:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467207;
        bh=5Kjm/MX9uQ8kR71j/gCNkL71LD7bxn607SZxIhDz/JI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cyBPf3Y4TplA/JfpwysYLt7wNQb3zxrn00CN5iEvPHohGxZxGLT5eT2+CazVrIh8E
         Y7bRzWzNSBoc/85fGbyHDQovoMwS6QC3zgFIN5E3WjCypqSLprImwjHLXLv9cOptpq
         SLjO515T2rdEvbQcHGY3wyLSPw0qZRkAVg2Yuq7w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mathy Vanhoef <Mathy.Vanhoef@kuleuven.be>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4.9 10/66] mac80211: prevent mixed key and fragment cache attacks
Date:   Mon, 31 May 2021 15:13:43 +0200
Message-Id: <20210531130636.591895707@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130636.254683895@linuxfoundation.org>
References: <20210531130636.254683895@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/key.c         |    7 +++++++
 net/mac80211/key.h         |    2 ++
 net/mac80211/rx.c          |    6 ++++++
 4 files changed, 16 insertions(+)

--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -97,6 +97,7 @@ struct ieee80211_fragment_entry {
 	u8 rx_queue;
 	bool check_sequential_pn; /* needed for CCMP/GCMP */
 	u8 last_pn[6]; /* PN of the last fragment if CCMP was used */
+	unsigned int key_color;
 };
 
 
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -646,6 +646,7 @@ int ieee80211_key_link(struct ieee80211_
 		       struct ieee80211_sub_if_data *sdata,
 		       struct sta_info *sta)
 {
+	static atomic_t key_color = ATOMIC_INIT(0);
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_key *old_key;
 	int idx = key->conf.keyidx;
@@ -681,6 +682,12 @@ int ieee80211_key_link(struct ieee80211_
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
--- a/net/mac80211/key.h
+++ b/net/mac80211/key.h
@@ -127,6 +127,8 @@ struct ieee80211_key {
 	} debugfs;
 #endif
 
+	unsigned int color;
+
 	/*
 	 * key config, must be last because it contains key
 	 * material as variable length member
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2004,6 +2004,7 @@ ieee80211_rx_h_defragment(struct ieee802
 			 * next fragment has a sequential PN value.
 			 */
 			entry->check_sequential_pn = true;
+			entry->key_color = rx->key->color;
 			memcpy(entry->last_pn,
 			       rx->key->u.ccmp.rx_pn[queue],
 			       IEEE80211_CCMP_PN_LEN);
@@ -2041,6 +2042,11 @@ ieee80211_rx_h_defragment(struct ieee802
 
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


