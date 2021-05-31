Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B1D13968F7
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 22:31:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232366AbhEaUdb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 16:33:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232363AbhEaUdW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 May 2021 16:33:22 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECD86C061574;
        Mon, 31 May 2021 13:31:41 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1lnoZX-000FBv-Tw; Mon, 31 May 2021 22:31:40 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH v4.14 06/10] mac80211: add fragment cache to sta_info
Date:   Mon, 31 May 2021 22:31:31 +0200
Message-Id: <20210531203135.180427-7-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531203135.180427-1-johannes@sipsolutions.net>
References: <20210531203135.180427-1-johannes@sipsolutions.net>
MIME-Version: 1.0
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
---
 net/mac80211/ieee80211_i.h | 26 ++++--------------------
 net/mac80211/iface.c       |  9 ++-------
 net/mac80211/rx.c          | 41 ++++++++++++++++++++++++++++----------
 net/mac80211/sta_info.c    |  4 ++++
 net/mac80211/sta_info.h    | 30 ++++++++++++++++++++++++++++
 5 files changed, 70 insertions(+), 40 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 74186c2d9e6e..f38748efb98a 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -52,12 +52,6 @@ struct ieee80211_local;
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
 
@@ -90,19 +84,6 @@ extern const u8 ieee80211_ac_to_qos_mask[IEEE80211_NUM_ACS];
 
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
 
@@ -882,9 +863,7 @@ struct ieee80211_sub_if_data {
 
 	char name[IFNAMSIZ];
 
-	/* Fragment table for host-based reassembly */
-	struct ieee80211_fragment_entry	fragments[IEEE80211_FRAGMENT_MAX];
-	unsigned int fragment_next;
+	struct ieee80211_fragment_cache frags;
 
 	/* TID bitmap for NoAck policy */
 	u16 noack_map;
@@ -2164,4 +2143,7 @@ extern const struct ethtool_ops ieee80211_ethtool_ops;
 #define debug_noinline
 #endif
 
+void ieee80211_init_frag_cache(struct ieee80211_fragment_cache *cache);
+void ieee80211_destroy_frag_cache(struct ieee80211_fragment_cache *cache);
+
 #endif /* IEEE80211_I_H */
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index dc398a181678..adafa29d3021 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1127,16 +1127,12 @@ static void ieee80211_set_multicast_list(struct net_device *dev)
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
@@ -1846,8 +1842,7 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 	sdata->wdev.wiphy = local->hw.wiphy;
 	sdata->local = local;
 
-	for (i = 0; i < IEEE80211_FRAGMENT_MAX; i++)
-		skb_queue_head_init(&sdata->fragments[i].skb_list);
+	ieee80211_init_frag_cache(&sdata->frags);
 
 	INIT_LIST_HEAD(&sdata->key_list);
 
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index d6cdd0c025ca..39bc3d78f71a 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1899,19 +1899,34 @@ ieee80211_rx_h_decrypt(struct ieee80211_rx_data *rx)
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
@@ -1926,14 +1941,14 @@ ieee80211_reassemble_add(struct ieee80211_sub_if_data *sdata,
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
 
@@ -1941,7 +1956,7 @@ ieee80211_reassemble_find(struct ieee80211_sub_if_data *sdata,
 		if (idx < 0)
 			idx = IEEE80211_FRAGMENT_MAX - 1;
 
-		entry = &sdata->fragments[idx];
+		entry = &cache->entries[idx];
 		if (skb_queue_empty(&entry->skb_list) || entry->seq != seq ||
 		    entry->rx_queue != rx_queue ||
 		    entry->last_frag + 1 != frag)
@@ -1981,6 +1996,7 @@ static bool requires_sequential_pn(struct ieee80211_rx_data *rx, __le16 fc)
 static ieee80211_rx_result debug_noinline
 ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
 {
+	struct ieee80211_fragment_cache *cache = &rx->sdata->frags;
 	struct ieee80211_hdr *hdr;
 	u16 sc;
 	__le16 fc;
@@ -2002,6 +2018,9 @@ ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
 		goto out_no_led;
 	}
 
+	if (rx->sta)
+		cache = &rx->sta->frags;
+
 	if (likely(!ieee80211_has_morefrags(fc) && frag == 0))
 		goto out;
 
@@ -2020,7 +2039,7 @@ ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
 
 	if (frag == 0) {
 		/* This is the first fragment of a new frame. */
-		entry = ieee80211_reassemble_add(rx->sdata, frag, seq,
+		entry = ieee80211_reassemble_add(cache, frag, seq,
 						 rx->seqno_idx, &(rx->skb));
 		if (requires_sequential_pn(rx, fc)) {
 			int queue = rx->security_idx;
@@ -2048,7 +2067,7 @@ ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
 	/* This is a fragment for a frame that should already be pending in
 	 * fragment cache. Add this fragment to the end of the pending entry.
 	 */
-	entry = ieee80211_reassemble_find(rx->sdata, frag, seq,
+	entry = ieee80211_reassemble_find(cache, frag, seq,
 					  rx->seqno_idx, hdr);
 	if (!entry) {
 		I802_DEBUG_INC(rx->local->rx_handlers_drop_defrag);
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 32fede73ecd4..0d5265adf539 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -367,6 +367,8 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 
 	u64_stats_init(&sta->rx_stats.syncp);
 
+	ieee80211_init_frag_cache(&sta->frags);
+
 	sta->sta_state = IEEE80211_STA_NONE;
 
 	/* Mark TID as unreserved */
@@ -1005,6 +1007,8 @@ static void __sta_info_destroy_part2(struct sta_info *sta)
 	rate_control_remove_sta_debugfs(sta);
 	ieee80211_sta_debugfs_remove(sta);
 
+	ieee80211_destroy_frag_cache(&sta->frags);
+
 	cleanup_single_sta(sta);
 }
 
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 3acbdfa9f649..0447197c4a2b 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -398,6 +398,33 @@ struct ieee80211_sta_rx_stats {
 	u64 msdu[IEEE80211_NUM_TIDS + 1];
 };
 
+/*
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
 /**
  * The bandwidth threshold below which the per-station CoDel parameters will be
  * scaled to be more lenient (to prevent starvation of slow stations). This
@@ -470,6 +497,7 @@ struct ieee80211_sta_rx_stats {
  * @pcpu_rx_stats: per-CPU RX statistics, assigned only if the driver needs
  *	this (by advertising the USES_RSS hw flag)
  * @status_stats: TX status statistics
+ * @frags: fragment cache
  */
 struct sta_info {
 	/* General information, mostly static */
@@ -569,6 +597,8 @@ struct sta_info {
 
 	struct cfg80211_chan_def tdls_chandef;
 
+	struct ieee80211_fragment_cache frags;
+
 	/* keep last! */
 	struct ieee80211_sta sta;
 };
-- 
2.31.1

