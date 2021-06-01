Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6463A395C34
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:28:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231773AbhEaN35 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:29:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:33262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231960AbhEaN13 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:27:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F107613D0;
        Mon, 31 May 2021 13:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467305;
        bh=Q4kPj7kly2i3t4LsSwLS57WyCqf9oDjx6ThyKW7CfIc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Iw05X9mKwkMa6zOLjkvwMEFWMzo+ATU9H0z8j6+oJ3FAd6OEs3HU6zO1M/q+natrn
         KgnPWz+3NBr/abR1gvke7XzZDCLSvPHFJB3qH1V/OFkA05Rgsjr0MlRHoSI8Ql+tHm
         7ssUKU0sF9BwTB0cwl1nBS7chC3/ZPVA6DqkUf/8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4.19 016/116] mac80211: add fragment cache to sta_info
Date:   Mon, 31 May 2021 15:13:12 +0200
Message-Id: <20210531130640.705434590@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

commit 3a11ce08c45b50d69c891d71760b7c5b92074709 upstream.

Prior patches protected against fragmentation cache attacks
by coloring keys, but this shows that it can lead to issues
when multiple stations use the same sequence number. Add a
fragment cache to struct sta_info (in addition to the one in
the interface) to separate fragments for different stations
properly.

This then automatically clear most of the fragment cache when a
station disconnects (or reassociates) from an AP, or when client
interfaces disconnect from the network, etc.

On the way, also fix the comment there since this brings us in line
with the recommendation in 802.11-2016 ("An AP should support ...").
Additionally, remove a useless condition (since there's no problem
purging an already empty list).

Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210511200110.fc35046b0d52.I1ef101e3784d13e8f6600d83de7ec9a3a45bcd52@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/ieee80211_i.h |   26 ++++----------------------
 net/mac80211/iface.c       |   11 +++--------
 net/mac80211/rx.c          |   41 ++++++++++++++++++++++++++++++-----------
 net/mac80211/sta_info.c    |    6 +++++-
 net/mac80211/sta_info.h    |   31 +++++++++++++++++++++++++++++++
 5 files changed, 73 insertions(+), 42 deletions(-)

--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -53,12 +53,6 @@ struct ieee80211_local;
 #define IEEE80211_ENCRYPT_HEADROOM 8
 #define IEEE80211_ENCRYPT_TAILROOM 18
 
-/* IEEE 802.11 (Ch. 9.5 Defragmentation) requires support for concurrent
- * reception of at least three fragmented frames. This limit can be increased
- * by changing this define, at the cost of slower frame reassembly and
- * increased memory use (about 2 kB of RAM per entry). */
-#define IEEE80211_FRAGMENT_MAX 4
-
 /* power level hasn't been configured (or set to automatic) */
 #define IEEE80211_UNSET_POWER_LEVEL	INT_MIN
 
@@ -91,19 +85,6 @@ extern const u8 ieee80211_ac_to_qos_mask
 
 #define IEEE80211_MAX_NAN_INSTANCE_ID 255
 
-struct ieee80211_fragment_entry {
-	struct sk_buff_head skb_list;
-	unsigned long first_frag_time;
-	u16 seq;
-	u16 extra_len;
-	u16 last_frag;
-	u8 rx_queue;
-	bool check_sequential_pn; /* needed for CCMP/GCMP */
-	u8 last_pn[6]; /* PN of the last fragment if CCMP was used */
-	unsigned int key_color;
-};
-
-
 struct ieee80211_bss {
 	u32 device_ts_beacon, device_ts_presp;
 
@@ -885,9 +866,7 @@ struct ieee80211_sub_if_data {
 
 	char name[IFNAMSIZ];
 
-	/* Fragment table for host-based reassembly */
-	struct ieee80211_fragment_entry	fragments[IEEE80211_FRAGMENT_MAX];
-	unsigned int fragment_next;
+	struct ieee80211_fragment_cache frags;
 
 	/* TID bitmap for NoAck policy */
 	u16 noack_map;
@@ -2205,4 +2184,7 @@ extern const struct ethtool_ops ieee8021
 #define debug_noinline
 #endif
 
+void ieee80211_init_frag_cache(struct ieee80211_fragment_cache *cache);
+void ieee80211_destroy_frag_cache(struct ieee80211_fragment_cache *cache);
+
 #endif /* IEEE80211_I_H */
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -7,7 +7,7 @@
  * Copyright 2008, Johannes Berg <johannes@sipsolutions.net>
  * Copyright 2013-2014  Intel Mobile Communications GmbH
  * Copyright (c) 2016        Intel Deutschland GmbH
- * Copyright (C) 2018 Intel Corporation
+ * Copyright (C) 2018-2021 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -1111,16 +1111,12 @@ static void ieee80211_set_multicast_list
  */
 static void ieee80211_teardown_sdata(struct ieee80211_sub_if_data *sdata)
 {
-	int i;
-
 	/* free extra data */
 	ieee80211_free_keys(sdata, false);
 
 	ieee80211_debugfs_remove_netdev(sdata);
 
-	for (i = 0; i < IEEE80211_FRAGMENT_MAX; i++)
-		__skb_queue_purge(&sdata->fragments[i].skb_list);
-	sdata->fragment_next = 0;
+	ieee80211_destroy_frag_cache(&sdata->frags);
 
 	if (ieee80211_vif_is_mesh(&sdata->vif))
 		ieee80211_mesh_teardown_sdata(sdata);
@@ -1832,8 +1828,7 @@ int ieee80211_if_add(struct ieee80211_lo
 	sdata->wdev.wiphy = local->hw.wiphy;
 	sdata->local = local;
 
-	for (i = 0; i < IEEE80211_FRAGMENT_MAX; i++)
-		skb_queue_head_init(&sdata->fragments[i].skb_list);
+	ieee80211_init_frag_cache(&sdata->frags);
 
 	INIT_LIST_HEAD(&sdata->key_list);
 
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2009,19 +2009,34 @@ ieee80211_rx_h_decrypt(struct ieee80211_
 	return result;
 }
 
+void ieee80211_init_frag_cache(struct ieee80211_fragment_cache *cache)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(cache->entries); i++)
+		skb_queue_head_init(&cache->entries[i].skb_list);
+}
+
+void ieee80211_destroy_frag_cache(struct ieee80211_fragment_cache *cache)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(cache->entries); i++)
+		__skb_queue_purge(&cache->entries[i].skb_list);
+}
+
 static inline struct ieee80211_fragment_entry *
-ieee80211_reassemble_add(struct ieee80211_sub_if_data *sdata,
+ieee80211_reassemble_add(struct ieee80211_fragment_cache *cache,
 			 unsigned int frag, unsigned int seq, int rx_queue,
 			 struct sk_buff **skb)
 {
 	struct ieee80211_fragment_entry *entry;
 
-	entry = &sdata->fragments[sdata->fragment_next++];
-	if (sdata->fragment_next >= IEEE80211_FRAGMENT_MAX)
-		sdata->fragment_next = 0;
+	entry = &cache->entries[cache->next++];
+	if (cache->next >= IEEE80211_FRAGMENT_MAX)
+		cache->next = 0;
 
-	if (!skb_queue_empty(&entry->skb_list))
-		__skb_queue_purge(&entry->skb_list);
+	__skb_queue_purge(&entry->skb_list);
 
 	__skb_queue_tail(&entry->skb_list, *skb); /* no need for locking */
 	*skb = NULL;
@@ -2036,14 +2051,14 @@ ieee80211_reassemble_add(struct ieee8021
 }
 
 static inline struct ieee80211_fragment_entry *
-ieee80211_reassemble_find(struct ieee80211_sub_if_data *sdata,
+ieee80211_reassemble_find(struct ieee80211_fragment_cache *cache,
 			  unsigned int frag, unsigned int seq,
 			  int rx_queue, struct ieee80211_hdr *hdr)
 {
 	struct ieee80211_fragment_entry *entry;
 	int i, idx;
 
-	idx = sdata->fragment_next;
+	idx = cache->next;
 	for (i = 0; i < IEEE80211_FRAGMENT_MAX; i++) {
 		struct ieee80211_hdr *f_hdr;
 
@@ -2051,7 +2066,7 @@ ieee80211_reassemble_find(struct ieee802
 		if (idx < 0)
 			idx = IEEE80211_FRAGMENT_MAX - 1;
 
-		entry = &sdata->fragments[idx];
+		entry = &cache->entries[idx];
 		if (skb_queue_empty(&entry->skb_list) || entry->seq != seq ||
 		    entry->rx_queue != rx_queue ||
 		    entry->last_frag + 1 != frag)
@@ -2091,6 +2106,7 @@ static bool requires_sequential_pn(struc
 static ieee80211_rx_result debug_noinline
 ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
 {
+	struct ieee80211_fragment_cache *cache = &rx->sdata->frags;
 	struct ieee80211_hdr *hdr;
 	u16 sc;
 	__le16 fc;
@@ -2112,6 +2128,9 @@ ieee80211_rx_h_defragment(struct ieee802
 		goto out_no_led;
 	}
 
+	if (rx->sta)
+		cache = &rx->sta->frags;
+
 	if (likely(!ieee80211_has_morefrags(fc) && frag == 0))
 		goto out;
 
@@ -2130,7 +2149,7 @@ ieee80211_rx_h_defragment(struct ieee802
 
 	if (frag == 0) {
 		/* This is the first fragment of a new frame. */
-		entry = ieee80211_reassemble_add(rx->sdata, frag, seq,
+		entry = ieee80211_reassemble_add(cache, frag, seq,
 						 rx->seqno_idx, &(rx->skb));
 		if (requires_sequential_pn(rx, fc)) {
 			int queue = rx->security_idx;
@@ -2158,7 +2177,7 @@ ieee80211_rx_h_defragment(struct ieee802
 	/* This is a fragment for a frame that should already be pending in
 	 * fragment cache. Add this fragment to the end of the pending entry.
 	 */
-	entry = ieee80211_reassemble_find(rx->sdata, frag, seq,
+	entry = ieee80211_reassemble_find(cache, frag, seq,
 					  rx->seqno_idx, hdr);
 	if (!entry) {
 		I802_DEBUG_INC(rx->local->rx_handlers_drop_defrag);
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -3,7 +3,7 @@
  * Copyright 2006-2007	Jiri Benc <jbenc@suse.cz>
  * Copyright 2013-2014  Intel Mobile Communications GmbH
  * Copyright (C) 2015 - 2017 Intel Deutschland GmbH
- * Copyright (C) 2018-2020 Intel Corporation
+ * Copyright (C) 2018-2021 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -369,6 +369,8 @@ struct sta_info *sta_info_alloc(struct i
 
 	u64_stats_init(&sta->rx_stats.syncp);
 
+	ieee80211_init_frag_cache(&sta->frags);
+
 	sta->sta_state = IEEE80211_STA_NONE;
 
 	/* Mark TID as unreserved */
@@ -1032,6 +1034,8 @@ static void __sta_info_destroy_part2(str
 	rate_control_remove_sta_debugfs(sta);
 	ieee80211_sta_debugfs_remove(sta);
 
+	ieee80211_destroy_frag_cache(&sta->frags);
+
 	cleanup_single_sta(sta);
 }
 
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -2,6 +2,7 @@
  * Copyright 2002-2005, Devicescape Software, Inc.
  * Copyright 2013-2014  Intel Mobile Communications GmbH
  * Copyright(c) 2015-2017 Intel Deutschland GmbH
+ * Copyright(c) 2020-2021 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -412,6 +413,33 @@ struct ieee80211_sta_rx_stats {
 };
 
 /*
+ * IEEE 802.11-2016 (10.6 "Defragmentation") recommends support for "concurrent
+ * reception of at least one MSDU per access category per associated STA"
+ * on APs, or "at least one MSDU per access category" on other interface types.
+ *
+ * This limit can be increased by changing this define, at the cost of slower
+ * frame reassembly and increased memory use while fragments are pending.
+ */
+#define IEEE80211_FRAGMENT_MAX 4
+
+struct ieee80211_fragment_entry {
+	struct sk_buff_head skb_list;
+	unsigned long first_frag_time;
+	u16 seq;
+	u16 extra_len;
+	u16 last_frag;
+	u8 rx_queue;
+	bool check_sequential_pn; /* needed for CCMP/GCMP */
+	u8 last_pn[6]; /* PN of the last fragment if CCMP was used */
+	unsigned int key_color;
+};
+
+struct ieee80211_fragment_cache {
+	struct ieee80211_fragment_entry	entries[IEEE80211_FRAGMENT_MAX];
+	unsigned int next;
+};
+
+/*
  * The bandwidth threshold below which the per-station CoDel parameters will be
  * scaled to be more lenient (to prevent starvation of slow stations). This
  * value will be scaled by the number of active stations when it is being
@@ -482,6 +510,7 @@ struct ieee80211_sta_rx_stats {
  * @pcpu_rx_stats: per-CPU RX statistics, assigned only if the driver needs
  *	this (by advertising the USES_RSS hw flag)
  * @status_stats: TX status statistics
+ * @frags: fragment cache
  */
 struct sta_info {
 	/* General information, mostly static */
@@ -583,6 +612,8 @@ struct sta_info {
 
 	struct cfg80211_chan_def tdls_chandef;
 
+	struct ieee80211_fragment_cache frags;
+
 	/* keep last! */
 	struct ieee80211_sta sta;
 };


