Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1273196B5
	for <lists+stable@lfdr.de>; Fri, 10 May 2019 04:34:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726939AbfEJCeB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 22:34:01 -0400
Received: from mail-pl1-f201.google.com ([209.85.214.201]:34797 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726806AbfEJCeB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 May 2019 22:34:01 -0400
Received: by mail-pl1-f201.google.com with SMTP id s22so2769027plq.1
        for <stable@vger.kernel.org>; Thu, 09 May 2019 19:33:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=mTvjxC5V/lACtGrAkoJdngIQcFBSnY3JagtZ+Alk2L0=;
        b=APLQ41gwYHJW5IMu+tiWhNalPKKt1kq0+zU7UI0PrE5F0s6Zd9h8ozU7P7g/dl06uG
         uEeCmbKjxv7XKybLOIqD4muLdl8OOuiukUyxZz2DRVhQ5y+DH1momwYiOtL8Gbq6OKso
         aIuFwkkwDQXmcvsdG3fqi6DxSu71/9rwY2gYWi/BtovrdxZzCfVPGcw893Yw0SA2ffv8
         ZRXQdHH0tJQHkqVEcSQt9QWfwp39SDt3Dvsuuni1tQiyT2PrRJWNXK7u92Y0EZXWqm4W
         X8PCUP9UTcC4noMCTPkP2PuInkD9sp2AAloKtv97QUTjYOBHr9ViurwgkE5YVy6JjF20
         I0fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=mTvjxC5V/lACtGrAkoJdngIQcFBSnY3JagtZ+Alk2L0=;
        b=tpbcNfT8Fh6YC/TpSCkKy6VFgyKHqzWbEGx9gCnbZTclo8tisVBTnvQDcBW8M4KKAx
         d0iEgL7j864hxLeVaqkBB95CpnM52c7B3nAbAxtVzoDLRkFtFAxvu3fGX76Ill0KeLLM
         honRZ/rgjumaYQnIH7J/1x8Uu8+IK+28YOVfwHr/Ks+FFj/jBS8CLE9ncPy1BBazZ/75
         zrrtJFiGUaORr0hiLVNFOXezbIxld+fS+LYeijoJUfEoRUKzPK8qHOBai8Hvod/arVLZ
         2X2OcBxhUnElApm7J/6qwvlpMQGUSEY5a8wiATXztWV8zIgWhgq8tlAWbUw/Ju3UB4Bc
         VB9w==
X-Gm-Message-State: APjAAAWejH2YP3s2BSDJ/sOe8RulaOGttp8rDu0FDFhQAJ+IZ1alHgn2
        gUEl9nNB2rIF9LEKff6WZ4P62hQNvC2bYBzT8KCk8LvwR39zMxKESz6fhrB3efMrUQszGLXAaUi
        OsFOolniQ+C2oyzP35o613Dle5ujEh5zYkhMCNJlYKhN0ccVFlcJkVX2ptgo=
X-Google-Smtp-Source: APXvYqzsmeyzziW+VIMrD7cnfaw5Gjsx7c/HzfxZv6voDXZIjA39zz9UP4pILTr7D+u7+upNlH+hqzC9Pw==
X-Received: by 2002:a63:6b49:: with SMTP id g70mr10451820pgc.340.1557455639095;
 Thu, 09 May 2019 19:33:59 -0700 (PDT)
Date:   Thu,  9 May 2019 19:33:54 -0700
In-Reply-To: <20190510023354.182171-1-fengc@google.com>
Message-Id: <20190510023354.182171-2-fengc@google.com>
Mime-Version: 1.0
References: <20190510023354.182171-1-fengc@google.com>
X-Mailer: git-send-email 2.21.0.1020.gf2820cf01a-goog
Subject: [stable 4.9.y 2/2] bpf: convert htab map to hlist_nulls
From:   Chenbo Feng <fengc@google.com>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, kernel-team@android.com,
        maze@google.com, lorenzo@google.com,
        Jonathan Perry <jonperry@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Chenbo Feng <fengc@google.com>
Content-Type: text/plain; charset="utf-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexei Starovoitov <ast@fb.com>

commit 4fe8435909fddc97b81472026aa954e06dd192a5 upstream.

when all map elements are pre-allocated one cpu can delete and reuse htab_elem
while another cpu is still walking the hlist. In such case the lookup may
miss the element. Convert hlist to hlist_nulls to avoid such scenario.
When bucket lock is taken there is no need to take such precautions,
so only convert map_lookup and map_get_next to nulls.
The race window is extremely small and only reproducible with explicit
udelay() inside lookup_nulls_elem_raw()

Similar to hlist add hlist_nulls_for_each_entry_safe() and
hlist_nulls_entry_safe() helpers.

Fixes: 6c9059817432 ("bpf: pre-allocate hash map elements")
Reported-by: Jonathan Perry <jonperry@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chenbo Feng <fengc@google.com>
---
 include/linux/list_nulls.h    |  5 +++
 include/linux/rculist_nulls.h | 14 +++++++
 kernel/bpf/hashtab.c          | 71 +++++++++++++++++++++++------------
 3 files changed, 67 insertions(+), 23 deletions(-)

diff --git a/include/linux/list_nulls.h b/include/linux/list_nulls.h
index b01fe1009084..87ff4f58a2f0 100644
--- a/include/linux/list_nulls.h
+++ b/include/linux/list_nulls.h
@@ -29,6 +29,11 @@ struct hlist_nulls_node {
 	((ptr)->first = (struct hlist_nulls_node *) NULLS_MARKER(nulls))
 
 #define hlist_nulls_entry(ptr, type, member) container_of(ptr,type,member)
+
+#define hlist_nulls_entry_safe(ptr, type, member) \
+	({ typeof(ptr) ____ptr = (ptr); \
+	   !is_a_nulls(____ptr) ? hlist_nulls_entry(____ptr, type, member) : NULL; \
+	})
 /**
  * ptr_is_a_nulls - Test if a ptr is a nulls
  * @ptr: ptr to be tested
diff --git a/include/linux/rculist_nulls.h b/include/linux/rculist_nulls.h
index 6224a0ab0b1e..2720b2fbfb86 100644
--- a/include/linux/rculist_nulls.h
+++ b/include/linux/rculist_nulls.h
@@ -118,5 +118,19 @@ static inline void hlist_nulls_add_head_rcu(struct hlist_nulls_node *n,
 		({ tpos = hlist_nulls_entry(pos, typeof(*tpos), member); 1; }); \
 		pos = rcu_dereference_raw(hlist_nulls_next_rcu(pos)))
 
+/**
+ * hlist_nulls_for_each_entry_safe -
+ *   iterate over list of given type safe against removal of list entry
+ * @tpos:	the type * to use as a loop cursor.
+ * @pos:	the &struct hlist_nulls_node to use as a loop cursor.
+ * @head:	the head for your list.
+ * @member:	the name of the hlist_nulls_node within the struct.
+ */
+#define hlist_nulls_for_each_entry_safe(tpos, pos, head, member)		\
+	for (({barrier();}),							\
+	     pos = rcu_dereference_raw(hlist_nulls_first_rcu(head));		\
+		(!is_a_nulls(pos)) &&						\
+		({ tpos = hlist_nulls_entry(pos, typeof(*tpos), member);	\
+		   pos = rcu_dereference_raw(hlist_nulls_next_rcu(pos)); 1; });)
 #endif
 #endif
diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index f9d53ac57f64..8648d7d29708 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -13,10 +13,11 @@
 #include <linux/bpf.h>
 #include <linux/jhash.h>
 #include <linux/filter.h>
+#include <linux/rculist_nulls.h>
 #include "percpu_freelist.h"
 
 struct bucket {
-	struct hlist_head head;
+	struct hlist_nulls_head head;
 	raw_spinlock_t lock;
 };
 
@@ -40,7 +41,7 @@ enum extra_elem_state {
 /* each htab element is struct htab_elem + key + value */
 struct htab_elem {
 	union {
-		struct hlist_node hash_node;
+		struct hlist_nulls_node hash_node;
 		struct {
 			void *padding;
 			union {
@@ -245,7 +246,7 @@ static struct bpf_map *htab_map_alloc(union bpf_attr *attr)
 		goto free_htab;
 
 	for (i = 0; i < htab->n_buckets; i++) {
-		INIT_HLIST_HEAD(&htab->buckets[i].head);
+		INIT_HLIST_NULLS_HEAD(&htab->buckets[i].head, i);
 		raw_spin_lock_init(&htab->buckets[i].lock);
 	}
 
@@ -282,28 +283,52 @@ static inline struct bucket *__select_bucket(struct bpf_htab *htab, u32 hash)
 	return &htab->buckets[hash & (htab->n_buckets - 1)];
 }
 
-static inline struct hlist_head *select_bucket(struct bpf_htab *htab, u32 hash)
+static inline struct hlist_nulls_head *select_bucket(struct bpf_htab *htab, u32 hash)
 {
 	return &__select_bucket(htab, hash)->head;
 }
 
-static struct htab_elem *lookup_elem_raw(struct hlist_head *head, u32 hash,
+/* this lookup function can only be called with bucket lock taken */
+static struct htab_elem *lookup_elem_raw(struct hlist_nulls_head *head, u32 hash,
 					 void *key, u32 key_size)
 {
+	struct hlist_nulls_node *n;
 	struct htab_elem *l;
 
-	hlist_for_each_entry_rcu(l, head, hash_node)
+	hlist_nulls_for_each_entry_rcu(l, n, head, hash_node)
 		if (l->hash == hash && !memcmp(&l->key, key, key_size))
 			return l;
 
 	return NULL;
 }
 
+/* can be called without bucket lock. it will repeat the loop in
+ * the unlikely event when elements moved from one bucket into another
+ * while link list is being walked
+ */
+static struct htab_elem *lookup_nulls_elem_raw(struct hlist_nulls_head *head,
+					       u32 hash, void *key,
+					       u32 key_size, u32 n_buckets)
+{
+	struct hlist_nulls_node *n;
+	struct htab_elem *l;
+
+again:
+	hlist_nulls_for_each_entry_rcu(l, n, head, hash_node)
+		if (l->hash == hash && !memcmp(&l->key, key, key_size))
+			return l;
+
+	if (unlikely(get_nulls_value(n) != (hash & (n_buckets - 1))))
+		goto again;
+
+	return NULL;
+}
+
 /* Called from syscall or from eBPF program */
 static void *__htab_map_lookup_elem(struct bpf_map *map, void *key)
 {
 	struct bpf_htab *htab = container_of(map, struct bpf_htab, map);
-	struct hlist_head *head;
+	struct hlist_nulls_head *head;
 	struct htab_elem *l;
 	u32 hash, key_size;
 
@@ -316,7 +341,7 @@ static void *__htab_map_lookup_elem(struct bpf_map *map, void *key)
 
 	head = select_bucket(htab, hash);
 
-	l = lookup_elem_raw(head, hash, key, key_size);
+	l = lookup_nulls_elem_raw(head, hash, key, key_size, htab->n_buckets);
 
 	return l;
 }
@@ -335,7 +360,7 @@ static void *htab_map_lookup_elem(struct bpf_map *map, void *key)
 static int htab_map_get_next_key(struct bpf_map *map, void *key, void *next_key)
 {
 	struct bpf_htab *htab = container_of(map, struct bpf_htab, map);
-	struct hlist_head *head;
+	struct hlist_nulls_head *head;
 	struct htab_elem *l, *next_l;
 	u32 hash, key_size;
 	int i = 0;
@@ -352,13 +377,13 @@ static int htab_map_get_next_key(struct bpf_map *map, void *key, void *next_key)
 	head = select_bucket(htab, hash);
 
 	/* lookup the key */
-	l = lookup_elem_raw(head, hash, key, key_size);
+	l = lookup_nulls_elem_raw(head, hash, key, key_size, htab->n_buckets);
 
 	if (!l)
 		goto find_first_elem;
 
 	/* key was found, get next key in the same bucket */
-	next_l = hlist_entry_safe(rcu_dereference_raw(hlist_next_rcu(&l->hash_node)),
+	next_l = hlist_nulls_entry_safe(rcu_dereference_raw(hlist_nulls_next_rcu(&l->hash_node)),
 				  struct htab_elem, hash_node);
 
 	if (next_l) {
@@ -377,7 +402,7 @@ static int htab_map_get_next_key(struct bpf_map *map, void *key, void *next_key)
 		head = select_bucket(htab, i);
 
 		/* pick first element in the bucket */
-		next_l = hlist_entry_safe(rcu_dereference_raw(hlist_first_rcu(head)),
+		next_l = hlist_nulls_entry_safe(rcu_dereference_raw(hlist_nulls_first_rcu(head)),
 					  struct htab_elem, hash_node);
 		if (next_l) {
 			/* if it's not empty, just return it */
@@ -534,7 +559,7 @@ static int htab_map_update_elem(struct bpf_map *map, void *key, void *value,
 {
 	struct bpf_htab *htab = container_of(map, struct bpf_htab, map);
 	struct htab_elem *l_new = NULL, *l_old;
-	struct hlist_head *head;
+	struct hlist_nulls_head *head;
 	unsigned long flags;
 	struct bucket *b;
 	u32 key_size, hash;
@@ -573,9 +598,9 @@ static int htab_map_update_elem(struct bpf_map *map, void *key, void *value,
 	/* add new element to the head of the list, so that
 	 * concurrent search will find it before old elem
 	 */
-	hlist_add_head_rcu(&l_new->hash_node, head);
+	hlist_nulls_add_head_rcu(&l_new->hash_node, head);
 	if (l_old) {
-		hlist_del_rcu(&l_old->hash_node);
+		hlist_nulls_del_rcu(&l_old->hash_node);
 		free_htab_elem(htab, l_old);
 	}
 	ret = 0;
@@ -590,7 +615,7 @@ static int __htab_percpu_map_update_elem(struct bpf_map *map, void *key,
 {
 	struct bpf_htab *htab = container_of(map, struct bpf_htab, map);
 	struct htab_elem *l_new = NULL, *l_old;
-	struct hlist_head *head;
+	struct hlist_nulls_head *head;
 	unsigned long flags;
 	struct bucket *b;
 	u32 key_size, hash;
@@ -642,7 +667,7 @@ static int __htab_percpu_map_update_elem(struct bpf_map *map, void *key,
 			ret = PTR_ERR(l_new);
 			goto err;
 		}
-		hlist_add_head_rcu(&l_new->hash_node, head);
+		hlist_nulls_add_head_rcu(&l_new->hash_node, head);
 	}
 	ret = 0;
 err:
@@ -660,7 +685,7 @@ static int htab_percpu_map_update_elem(struct bpf_map *map, void *key,
 static int htab_map_delete_elem(struct bpf_map *map, void *key)
 {
 	struct bpf_htab *htab = container_of(map, struct bpf_htab, map);
-	struct hlist_head *head;
+	struct hlist_nulls_head *head;
 	struct bucket *b;
 	struct htab_elem *l;
 	unsigned long flags;
@@ -680,7 +705,7 @@ static int htab_map_delete_elem(struct bpf_map *map, void *key)
 	l = lookup_elem_raw(head, hash, key, key_size);
 
 	if (l) {
-		hlist_del_rcu(&l->hash_node);
+		hlist_nulls_del_rcu(&l->hash_node);
 		free_htab_elem(htab, l);
 		ret = 0;
 	}
@@ -694,12 +719,12 @@ static void delete_all_elements(struct bpf_htab *htab)
 	int i;
 
 	for (i = 0; i < htab->n_buckets; i++) {
-		struct hlist_head *head = select_bucket(htab, i);
-		struct hlist_node *n;
+		struct hlist_nulls_head *head = select_bucket(htab, i);
+		struct hlist_nulls_node *n;
 		struct htab_elem *l;
 
-		hlist_for_each_entry_safe(l, n, head, hash_node) {
-			hlist_del_rcu(&l->hash_node);
+		hlist_nulls_for_each_entry_safe(l, n, head, hash_node) {
+			hlist_nulls_del_rcu(&l->hash_node);
 			if (l->state != HTAB_EXTRA_ELEM_USED)
 				htab_elem_free(htab, l);
 		}
-- 
2.21.0.1020.gf2820cf01a-goog

