Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A5F9395C2F
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231680AbhEaN3m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:29:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:33126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232197AbhEaN1S (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:27:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C18060FEF;
        Mon, 31 May 2021 13:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467294;
        bh=lT60TqZGWDLi7vR5JEDYwqWtGhGSdkL/p+dLT4qHj6Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E0fSbXX8S27Fa9yNguH3nDzGqQd+fFmu1jpp40pcyHfzzEMHosLTQChSyOZEGEvgt
         RWf9vDTIshGA/GBMljvkZAZu+g61E3j4kJsUY1JPf+Zd2Z5cph371mrvW+UdJIn9QS
         bHuwEC8BqkSK/44Y8XoeHxQvmdXjqFAHoPqEkJAA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mathy Vanhoef <Mathy.Vanhoef@kuleuven.be>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4.19 012/116] mac80211: prevent mixed key and fragment cache attacks
Date:   Mon, 31 May 2021 15:13:08 +0200
Message-Id: <20210531130640.557292195@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130640.131924542@linuxfoundation.org>
References: <20210531130640.131924542@linuxfoundation.org>
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
@@ -100,6 +100,7 @@ struct ieee80211_fragment_entry {
 	u8 rx_queue;
 	bool check_sequential_pn; /* needed for CCMP/GCMP */
 	u8 last_pn[6]; /* PN of the last fragment if CCMP was used */
+	unsigned int key_color;
 };
 
 
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -653,6 +653,7 @@ int ieee80211_key_link(struct ieee80211_
 		       struct ieee80211_sub_if_data *sdata,
 		       struct sta_info *sta)
 {
+	static atomic_t key_color = ATOMIC_INIT(0);
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_key *old_key;
 	int idx = key->conf.keyidx;
@@ -688,6 +689,12 @@ int ieee80211_key_link(struct ieee80211_
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
@@ -2139,6 +2139,7 @@ ieee80211_rx_h_defragment(struct ieee802
 			 * next fragment has a sequential PN value.
 			 */
 			entry->check_sequential_pn = true;
+			entry->key_color = rx->key->color;
 			memcpy(entry->last_pn,
 			       rx->key->u.ccmp.rx_pn[queue],
 			       IEEE80211_CCMP_PN_LEN);
@@ -2176,6 +2177,11 @@ ieee80211_rx_h_defragment(struct ieee802
 
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


