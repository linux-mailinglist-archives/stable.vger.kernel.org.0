Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0FBB4F303C
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:27:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353480AbiDEKHt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:07:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344285AbiDEJTE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:19:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3A2D237D5;
        Tue,  5 Apr 2022 02:07:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5039661571;
        Tue,  5 Apr 2022 09:07:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 610E6C385A0;
        Tue,  5 Apr 2022 09:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649149635;
        bh=k6iKNpeDxt8rCXaLGbwnGgWvj0PRPQ0P0TfX5Pq02H8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ouzx1jvFkAS+js+conBhInDqeG8fbdKQHHe5aTIaj22gR6S3rHoP8bRsXkapI7/K/
         X050mRtQ8d2jgx4ymRoRtKkrMrJbKYzxBA0tJwYnE+hfYzDMCLX77BnsBLPDLcZKNK
         aBR3xafFP8XGH8VYrZcETVzENzpEsNo+hSeFr7Y0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Waiman Long <longman@redhat.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0785/1017] locking/lockdep: Iterate lock_classes directly when reading lockdep files
Date:   Tue,  5 Apr 2022 09:28:18 +0200
Message-Id: <20220405070417.556399366@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Waiman Long <longman@redhat.com>

[ Upstream commit fb7275acd6fb988313dddd8d3d19efa70d9015ad ]

When dumping lock_classes information via /proc/lockdep, we can't take
the lockdep lock as the lock hold time is indeterminate. Iterating
over all_lock_classes without holding lock can be dangerous as there
is a slight chance that it may branch off to other lists leading to
infinite loop or even access invalid memory if changes are made to
all_lock_classes list in parallel.

To avoid this problem, iteration of lock classes is now done directly
on the lock_classes array itself. The lock_classes_in_use bitmap is
checked to see if the lock class is being used. To avoid iterating
the full array all the times, a new max_lock_class_idx value is added
to track the maximum lock_class index that is currently being used.

We can theoretically take the lockdep lock for iterating all_lock_classes
when other lockdep files (lockdep_stats and lock_stat) are accessed as
the lock hold time will be shorter for them. For consistency, they are
also modified to iterate the lock_classes array directly.

Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20220211035526.1329503-2-longman@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/locking/lockdep.c           | 14 +++++---
 kernel/locking/lockdep_internals.h |  6 ++--
 kernel/locking/lockdep_proc.c      | 51 +++++++++++++++++++++++++-----
 3 files changed, 56 insertions(+), 15 deletions(-)

diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index 220913a84494..55570f52de5a 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -183,11 +183,9 @@ static DECLARE_BITMAP(list_entries_in_use, MAX_LOCKDEP_ENTRIES);
 static struct hlist_head lock_keys_hash[KEYHASH_SIZE];
 unsigned long nr_lock_classes;
 unsigned long nr_zapped_classes;
-#ifndef CONFIG_DEBUG_LOCKDEP
-static
-#endif
+unsigned long max_lock_class_idx;
 struct lock_class lock_classes[MAX_LOCKDEP_KEYS];
-static DECLARE_BITMAP(lock_classes_in_use, MAX_LOCKDEP_KEYS);
+DECLARE_BITMAP(lock_classes_in_use, MAX_LOCKDEP_KEYS);
 
 static inline struct lock_class *hlock_class(struct held_lock *hlock)
 {
@@ -338,7 +336,7 @@ static inline void lock_release_holdtime(struct held_lock *hlock)
  * elements. These elements are linked together by the lock_entry member in
  * struct lock_class.
  */
-LIST_HEAD(all_lock_classes);
+static LIST_HEAD(all_lock_classes);
 static LIST_HEAD(free_lock_classes);
 
 /**
@@ -1252,6 +1250,7 @@ register_lock_class(struct lockdep_map *lock, unsigned int subclass, int force)
 	struct lockdep_subclass_key *key;
 	struct hlist_head *hash_head;
 	struct lock_class *class;
+	int idx;
 
 	DEBUG_LOCKS_WARN_ON(!irqs_disabled());
 
@@ -1317,6 +1316,9 @@ register_lock_class(struct lockdep_map *lock, unsigned int subclass, int force)
 	 * of classes.
 	 */
 	list_move_tail(&class->lock_entry, &all_lock_classes);
+	idx = class - lock_classes;
+	if (idx > max_lock_class_idx)
+		max_lock_class_idx = idx;
 
 	if (verbose(class)) {
 		graph_unlock();
@@ -5998,6 +6000,8 @@ static void zap_class(struct pending_free *pf, struct lock_class *class)
 		WRITE_ONCE(class->name, NULL);
 		nr_lock_classes--;
 		__clear_bit(class - lock_classes, lock_classes_in_use);
+		if (class - lock_classes == max_lock_class_idx)
+			max_lock_class_idx--;
 	} else {
 		WARN_ONCE(true, "%s() failed for class %s\n", __func__,
 			  class->name);
diff --git a/kernel/locking/lockdep_internals.h b/kernel/locking/lockdep_internals.h
index ecb8662e7a4e..bbe9000260d0 100644
--- a/kernel/locking/lockdep_internals.h
+++ b/kernel/locking/lockdep_internals.h
@@ -121,7 +121,6 @@ static const unsigned long LOCKF_USED_IN_IRQ_READ =
 
 #define MAX_LOCKDEP_CHAIN_HLOCKS (MAX_LOCKDEP_CHAINS*5)
 
-extern struct list_head all_lock_classes;
 extern struct lock_chain lock_chains[];
 
 #define LOCK_USAGE_CHARS (2*XXX_LOCK_USAGE_STATES + 1)
@@ -151,6 +150,10 @@ extern unsigned int nr_large_chain_blocks;
 
 extern unsigned int max_lockdep_depth;
 extern unsigned int max_bfs_queue_depth;
+extern unsigned long max_lock_class_idx;
+
+extern struct lock_class lock_classes[MAX_LOCKDEP_KEYS];
+extern unsigned long lock_classes_in_use[];
 
 #ifdef CONFIG_PROVE_LOCKING
 extern unsigned long lockdep_count_forward_deps(struct lock_class *);
@@ -205,7 +208,6 @@ struct lockdep_stats {
 };
 
 DECLARE_PER_CPU(struct lockdep_stats, lockdep_stats);
-extern struct lock_class lock_classes[MAX_LOCKDEP_KEYS];
 
 #define __debug_atomic_inc(ptr)					\
 	this_cpu_inc(lockdep_stats.ptr);
diff --git a/kernel/locking/lockdep_proc.c b/kernel/locking/lockdep_proc.c
index b8d9a050c337..15fdc7fa5c68 100644
--- a/kernel/locking/lockdep_proc.c
+++ b/kernel/locking/lockdep_proc.c
@@ -24,14 +24,33 @@
 
 #include "lockdep_internals.h"
 
+/*
+ * Since iteration of lock_classes is done without holding the lockdep lock,
+ * it is not safe to iterate all_lock_classes list directly as the iteration
+ * may branch off to free_lock_classes or the zapped list. Iteration is done
+ * directly on the lock_classes array by checking the lock_classes_in_use
+ * bitmap and max_lock_class_idx.
+ */
+#define iterate_lock_classes(idx, class)				\
+	for (idx = 0, class = lock_classes; idx <= max_lock_class_idx;	\
+	     idx++, class++)
+
 static void *l_next(struct seq_file *m, void *v, loff_t *pos)
 {
-	return seq_list_next(v, &all_lock_classes, pos);
+	struct lock_class *class = v;
+
+	++class;
+	*pos = class - lock_classes;
+	return (*pos > max_lock_class_idx) ? NULL : class;
 }
 
 static void *l_start(struct seq_file *m, loff_t *pos)
 {
-	return seq_list_start_head(&all_lock_classes, *pos);
+	unsigned long idx = *pos;
+
+	if (idx > max_lock_class_idx)
+		return NULL;
+	return lock_classes + idx;
 }
 
 static void l_stop(struct seq_file *m, void *v)
@@ -57,14 +76,16 @@ static void print_name(struct seq_file *m, struct lock_class *class)
 
 static int l_show(struct seq_file *m, void *v)
 {
-	struct lock_class *class = list_entry(v, struct lock_class, lock_entry);
+	struct lock_class *class = v;
 	struct lock_list *entry;
 	char usage[LOCK_USAGE_CHARS];
+	int idx = class - lock_classes;
 
-	if (v == &all_lock_classes) {
+	if (v == lock_classes)
 		seq_printf(m, "all lock classes:\n");
+
+	if (!test_bit(idx, lock_classes_in_use))
 		return 0;
-	}
 
 	seq_printf(m, "%p", class->key);
 #ifdef CONFIG_DEBUG_LOCKDEP
@@ -220,8 +241,11 @@ static int lockdep_stats_show(struct seq_file *m, void *v)
 
 #ifdef CONFIG_PROVE_LOCKING
 	struct lock_class *class;
+	unsigned long idx;
 
-	list_for_each_entry(class, &all_lock_classes, lock_entry) {
+	iterate_lock_classes(idx, class) {
+		if (!test_bit(idx, lock_classes_in_use))
+			continue;
 
 		if (class->usage_mask == 0)
 			nr_unused++;
@@ -254,6 +278,7 @@ static int lockdep_stats_show(struct seq_file *m, void *v)
 
 		sum_forward_deps += lockdep_count_forward_deps(class);
 	}
+
 #ifdef CONFIG_DEBUG_LOCKDEP
 	DEBUG_LOCKS_WARN_ON(debug_atomic_read(nr_unused_locks) != nr_unused);
 #endif
@@ -345,6 +370,8 @@ static int lockdep_stats_show(struct seq_file *m, void *v)
 	seq_printf(m, " max bfs queue depth:           %11u\n",
 			max_bfs_queue_depth);
 #endif
+	seq_printf(m, " max lock class index:          %11lu\n",
+			max_lock_class_idx);
 	lockdep_stats_debug_show(m);
 	seq_printf(m, " debug_locks:                   %11u\n",
 			debug_locks);
@@ -622,12 +649,16 @@ static int lock_stat_open(struct inode *inode, struct file *file)
 	if (!res) {
 		struct lock_stat_data *iter = data->stats;
 		struct seq_file *m = file->private_data;
+		unsigned long idx;
 
-		list_for_each_entry(class, &all_lock_classes, lock_entry) {
+		iterate_lock_classes(idx, class) {
+			if (!test_bit(idx, lock_classes_in_use))
+				continue;
 			iter->class = class;
 			iter->stats = lock_stats(class);
 			iter++;
 		}
+
 		data->iter_end = iter;
 
 		sort(data->stats, data->iter_end - data->stats,
@@ -645,6 +676,7 @@ static ssize_t lock_stat_write(struct file *file, const char __user *buf,
 			       size_t count, loff_t *ppos)
 {
 	struct lock_class *class;
+	unsigned long idx;
 	char c;
 
 	if (count) {
@@ -654,8 +686,11 @@ static ssize_t lock_stat_write(struct file *file, const char __user *buf,
 		if (c != '0')
 			return count;
 
-		list_for_each_entry(class, &all_lock_classes, lock_entry)
+		iterate_lock_classes(idx, class) {
+			if (!test_bit(idx, lock_classes_in_use))
+				continue;
 			clear_lock_stats(class);
+		}
 	}
 	return count;
 }
-- 
2.34.1



