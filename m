Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 233A72408C1
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 17:24:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728197AbgHJPYs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 11:24:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:58142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728444AbgHJPYs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 11:24:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5DA7920772;
        Mon, 10 Aug 2020 15:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597073085;
        bh=Tf+p7CMS4ZrtDpkrLIlQSvDm2KJ149qhlFy25X70m1Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tqG0ugWsATFQBkmk99/Rqf0ZQZK4UDGZ6w40Hn21SlggC/X7atBB87t3zcjbtSU+k
         nHa4dqStOvYDrn3yt1c10adVZ6uy4j+F3ArbNJcPzj1Os0p/IVilg83J6weDMRijWb
         oVRZhm94ZePfmxNVn5iAbnLHI3OAZFtHiuQcPvOU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.7 61/79] rhashtable: Restore RCU marking on rhash_lock_head
Date:   Mon, 10 Aug 2020 17:21:20 +0200
Message-Id: <20200810151815.252920533@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200810151812.114485777@linuxfoundation.org>
References: <20200810151812.114485777@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit ce9b362bf6db51a083c4221ef0f93c16cfb1facf ]

This patch restores the RCU marking on bucket_table->buckets as
it really does need RCU protection.  Its removal had led to a fatal
bug.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/rhashtable.h |   56 +++++++++++++++++++--------------------------
 lib/rhashtable.c           |   35 ++++++++++++----------------
 2 files changed, 40 insertions(+), 51 deletions(-)

--- a/include/linux/rhashtable.h
+++ b/include/linux/rhashtable.h
@@ -84,7 +84,7 @@ struct bucket_table {
 
 	struct lockdep_map	dep_map;
 
-	struct rhash_lock_head *buckets[] ____cacheline_aligned_in_smp;
+	struct rhash_lock_head __rcu *buckets[] ____cacheline_aligned_in_smp;
 };
 
 /*
@@ -261,13 +261,12 @@ void rhashtable_free_and_destroy(struct
 				 void *arg);
 void rhashtable_destroy(struct rhashtable *ht);
 
-struct rhash_lock_head **rht_bucket_nested(const struct bucket_table *tbl,
-					   unsigned int hash);
-struct rhash_lock_head **__rht_bucket_nested(const struct bucket_table *tbl,
-					     unsigned int hash);
-struct rhash_lock_head **rht_bucket_nested_insert(struct rhashtable *ht,
-						  struct bucket_table *tbl,
-						  unsigned int hash);
+struct rhash_lock_head __rcu **rht_bucket_nested(
+	const struct bucket_table *tbl, unsigned int hash);
+struct rhash_lock_head __rcu **__rht_bucket_nested(
+	const struct bucket_table *tbl, unsigned int hash);
+struct rhash_lock_head __rcu **rht_bucket_nested_insert(
+	struct rhashtable *ht, struct bucket_table *tbl, unsigned int hash);
 
 #define rht_dereference(p, ht) \
 	rcu_dereference_protected(p, lockdep_rht_mutex_is_held(ht))
@@ -284,21 +283,21 @@ struct rhash_lock_head **rht_bucket_nest
 #define rht_entry(tpos, pos, member) \
 	({ tpos = container_of(pos, typeof(*tpos), member); 1; })
 
-static inline struct rhash_lock_head *const *rht_bucket(
+static inline struct rhash_lock_head __rcu *const *rht_bucket(
 	const struct bucket_table *tbl, unsigned int hash)
 {
 	return unlikely(tbl->nest) ? rht_bucket_nested(tbl, hash) :
 				     &tbl->buckets[hash];
 }
 
-static inline struct rhash_lock_head **rht_bucket_var(
+static inline struct rhash_lock_head __rcu **rht_bucket_var(
 	struct bucket_table *tbl, unsigned int hash)
 {
 	return unlikely(tbl->nest) ? __rht_bucket_nested(tbl, hash) :
 				     &tbl->buckets[hash];
 }
 
-static inline struct rhash_lock_head **rht_bucket_insert(
+static inline struct rhash_lock_head __rcu **rht_bucket_insert(
 	struct rhashtable *ht, struct bucket_table *tbl, unsigned int hash)
 {
 	return unlikely(tbl->nest) ? rht_bucket_nested_insert(ht, tbl, hash) :
@@ -325,7 +324,7 @@ static inline struct rhash_lock_head **r
  */
 
 static inline void rht_lock(struct bucket_table *tbl,
-			    struct rhash_lock_head **bkt)
+			    struct rhash_lock_head __rcu **bkt)
 {
 	local_bh_disable();
 	bit_spin_lock(0, (unsigned long *)bkt);
@@ -333,7 +332,7 @@ static inline void rht_lock(struct bucke
 }
 
 static inline void rht_lock_nested(struct bucket_table *tbl,
-				   struct rhash_lock_head **bucket,
+				   struct rhash_lock_head __rcu **bucket,
 				   unsigned int subclass)
 {
 	local_bh_disable();
@@ -342,7 +341,7 @@ static inline void rht_lock_nested(struc
 }
 
 static inline void rht_unlock(struct bucket_table *tbl,
-			      struct rhash_lock_head **bkt)
+			      struct rhash_lock_head __rcu **bkt)
 {
 	lock_map_release(&tbl->dep_map);
 	bit_spin_unlock(0, (unsigned long *)bkt);
@@ -365,48 +364,41 @@ static inline struct rhash_head *__rht_p
  *            access is guaranteed, such as when destroying the table.
  */
 static inline struct rhash_head *rht_ptr_rcu(
-	struct rhash_lock_head *const *p)
+	struct rhash_lock_head __rcu *const *bkt)
 {
-	struct rhash_lock_head __rcu *const *bkt = (void *)p;
 	return __rht_ptr(rcu_dereference(*bkt), bkt);
 }
 
 static inline struct rhash_head *rht_ptr(
-	struct rhash_lock_head *const *p,
+	struct rhash_lock_head __rcu *const *bkt,
 	struct bucket_table *tbl,
 	unsigned int hash)
 {
-	struct rhash_lock_head __rcu *const *bkt = (void *)p;
 	return __rht_ptr(rht_dereference_bucket(*bkt, tbl, hash), bkt);
 }
 
 static inline struct rhash_head *rht_ptr_exclusive(
-	struct rhash_lock_head *const *p)
+	struct rhash_lock_head __rcu *const *bkt)
 {
-	struct rhash_lock_head __rcu *const *bkt = (void *)p;
 	return __rht_ptr(rcu_dereference_protected(*bkt, 1), bkt);
 }
 
-static inline void rht_assign_locked(struct rhash_lock_head **bkt,
+static inline void rht_assign_locked(struct rhash_lock_head __rcu **bkt,
 				     struct rhash_head *obj)
 {
-	struct rhash_head __rcu **p = (struct rhash_head __rcu **)bkt;
-
 	if (rht_is_a_nulls(obj))
 		obj = NULL;
-	rcu_assign_pointer(*p, (void *)((unsigned long)obj | BIT(0)));
+	rcu_assign_pointer(*bkt, (void *)((unsigned long)obj | BIT(0)));
 }
 
 static inline void rht_assign_unlock(struct bucket_table *tbl,
-				     struct rhash_lock_head **bkt,
+				     struct rhash_lock_head __rcu **bkt,
 				     struct rhash_head *obj)
 {
-	struct rhash_head __rcu **p = (struct rhash_head __rcu **)bkt;
-
 	if (rht_is_a_nulls(obj))
 		obj = NULL;
 	lock_map_release(&tbl->dep_map);
-	rcu_assign_pointer(*p, obj);
+	rcu_assign_pointer(*bkt, (void *)obj);
 	preempt_enable();
 	__release(bitlock);
 	local_bh_enable();
@@ -594,7 +586,7 @@ static inline struct rhash_head *__rhash
 		.ht = ht,
 		.key = key,
 	};
-	struct rhash_lock_head *const *bkt;
+	struct rhash_lock_head __rcu *const *bkt;
 	struct bucket_table *tbl;
 	struct rhash_head *he;
 	unsigned int hash;
@@ -710,7 +702,7 @@ static inline void *__rhashtable_insert_
 		.ht = ht,
 		.key = key,
 	};
-	struct rhash_lock_head **bkt;
+	struct rhash_lock_head __rcu **bkt;
 	struct rhash_head __rcu **pprev;
 	struct bucket_table *tbl;
 	struct rhash_head *head;
@@ -996,7 +988,7 @@ static inline int __rhashtable_remove_fa
 	struct rhash_head *obj, const struct rhashtable_params params,
 	bool rhlist)
 {
-	struct rhash_lock_head **bkt;
+	struct rhash_lock_head __rcu **bkt;
 	struct rhash_head __rcu **pprev;
 	struct rhash_head *he;
 	unsigned int hash;
@@ -1148,7 +1140,7 @@ static inline int __rhashtable_replace_f
 	struct rhash_head *obj_old, struct rhash_head *obj_new,
 	const struct rhashtable_params params)
 {
-	struct rhash_lock_head **bkt;
+	struct rhash_lock_head __rcu **bkt;
 	struct rhash_head __rcu **pprev;
 	struct rhash_head *he;
 	unsigned int hash;
--- a/lib/rhashtable.c
+++ b/lib/rhashtable.c
@@ -31,7 +31,7 @@
 
 union nested_table {
 	union nested_table __rcu *table;
-	struct rhash_lock_head *bucket;
+	struct rhash_lock_head __rcu *bucket;
 };
 
 static u32 head_hashfn(struct rhashtable *ht,
@@ -213,7 +213,7 @@ static struct bucket_table *rhashtable_l
 }
 
 static int rhashtable_rehash_one(struct rhashtable *ht,
-				 struct rhash_lock_head **bkt,
+				 struct rhash_lock_head __rcu **bkt,
 				 unsigned int old_hash)
 {
 	struct bucket_table *old_tbl = rht_dereference(ht->tbl, ht);
@@ -266,7 +266,7 @@ static int rhashtable_rehash_chain(struc
 				    unsigned int old_hash)
 {
 	struct bucket_table *old_tbl = rht_dereference(ht->tbl, ht);
-	struct rhash_lock_head **bkt = rht_bucket_var(old_tbl, old_hash);
+	struct rhash_lock_head __rcu **bkt = rht_bucket_var(old_tbl, old_hash);
 	int err;
 
 	if (!bkt)
@@ -476,7 +476,7 @@ fail:
 }
 
 static void *rhashtable_lookup_one(struct rhashtable *ht,
-				   struct rhash_lock_head **bkt,
+				   struct rhash_lock_head __rcu **bkt,
 				   struct bucket_table *tbl, unsigned int hash,
 				   const void *key, struct rhash_head *obj)
 {
@@ -526,12 +526,10 @@ static void *rhashtable_lookup_one(struc
 	return ERR_PTR(-ENOENT);
 }
 
-static struct bucket_table *rhashtable_insert_one(struct rhashtable *ht,
-						  struct rhash_lock_head **bkt,
-						  struct bucket_table *tbl,
-						  unsigned int hash,
-						  struct rhash_head *obj,
-						  void *data)
+static struct bucket_table *rhashtable_insert_one(
+	struct rhashtable *ht, struct rhash_lock_head __rcu **bkt,
+	struct bucket_table *tbl, unsigned int hash, struct rhash_head *obj,
+	void *data)
 {
 	struct bucket_table *new_tbl;
 	struct rhash_head *head;
@@ -582,7 +580,7 @@ static void *rhashtable_try_insert(struc
 {
 	struct bucket_table *new_tbl;
 	struct bucket_table *tbl;
-	struct rhash_lock_head **bkt;
+	struct rhash_lock_head __rcu **bkt;
 	unsigned int hash;
 	void *data;
 
@@ -1164,8 +1162,8 @@ void rhashtable_destroy(struct rhashtabl
 }
 EXPORT_SYMBOL_GPL(rhashtable_destroy);
 
-struct rhash_lock_head **__rht_bucket_nested(const struct bucket_table *tbl,
-					     unsigned int hash)
+struct rhash_lock_head __rcu **__rht_bucket_nested(
+	const struct bucket_table *tbl, unsigned int hash)
 {
 	const unsigned int shift = PAGE_SHIFT - ilog2(sizeof(void *));
 	unsigned int index = hash & ((1 << tbl->nest) - 1);
@@ -1193,10 +1191,10 @@ struct rhash_lock_head **__rht_bucket_ne
 }
 EXPORT_SYMBOL_GPL(__rht_bucket_nested);
 
-struct rhash_lock_head **rht_bucket_nested(const struct bucket_table *tbl,
-					   unsigned int hash)
+struct rhash_lock_head __rcu **rht_bucket_nested(
+	const struct bucket_table *tbl, unsigned int hash)
 {
-	static struct rhash_lock_head *rhnull;
+	static struct rhash_lock_head __rcu *rhnull;
 
 	if (!rhnull)
 		INIT_RHT_NULLS_HEAD(rhnull);
@@ -1204,9 +1202,8 @@ struct rhash_lock_head **rht_bucket_nest
 }
 EXPORT_SYMBOL_GPL(rht_bucket_nested);
 
-struct rhash_lock_head **rht_bucket_nested_insert(struct rhashtable *ht,
-						  struct bucket_table *tbl,
-						  unsigned int hash)
+struct rhash_lock_head __rcu **rht_bucket_nested_insert(
+	struct rhashtable *ht, struct bucket_table *tbl, unsigned int hash)
 {
 	const unsigned int shift = PAGE_SHIFT - ilog2(sizeof(void *));
 	unsigned int index = hash & ((1 << tbl->nest) - 1);


