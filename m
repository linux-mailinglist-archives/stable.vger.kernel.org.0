Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC44B408F87
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241780AbhIMNoF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:44:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:46602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243168AbhIMNmD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:42:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E988F6140A;
        Mon, 13 Sep 2021 13:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539797;
        bh=hhogL4zU8gQLQND8wGSuGABv5pVKNw0UCU4ZuCVRets=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eFDAEn6RmqifpMjfXHZCSqjNE+YcYmVwM6TzC5YZzhK4YCPjQMCtEh1ECBz8Z6ewH
         T+6z3UaB2VFyqoQHeEgnjegl+f3KgMHaKBkVyyjpiIGH19wJuHSTFmuq2EZXS/wKxb
         fBKW2fCfsbkdm6rgSUUU7IZ9N8ecgzK7SR8/XuKY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 163/236] locking/lockdep: Mark local_lock_t
Date:   Mon, 13 Sep 2021 15:14:28 +0200
Message-Id: <20210913131105.926705272@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131100.316353015@linuxfoundation.org>
References: <20210913131100.316353015@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit dfd5e3f5fe27bda91d5cc028c86ffbb7a0614489 ]

The local_lock_t's are special, because they cannot form IRQ
inversions, make sure we can tell them apart from the rest of the
locks.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/local_lock_internal.h |  5 ++++-
 include/linux/lockdep.h             | 15 ++++++++++++---
 include/linux/lockdep_types.h       | 18 ++++++++++++++----
 kernel/locking/lockdep.c            | 16 +++++++++-------
 4 files changed, 39 insertions(+), 15 deletions(-)

diff --git a/include/linux/local_lock_internal.h b/include/linux/local_lock_internal.h
index 4a8795b21d77..ded90b097e6e 100644
--- a/include/linux/local_lock_internal.h
+++ b/include/linux/local_lock_internal.h
@@ -18,6 +18,7 @@ typedef struct {
 	.dep_map = {					\
 		.name = #lockname,			\
 		.wait_type_inner = LD_WAIT_CONFIG,	\
+		.lock_type = LD_LOCK_PERCPU,			\
 	}
 #else
 # define LL_DEP_MAP_INIT(lockname)
@@ -30,7 +31,9 @@ do {								\
 	static struct lock_class_key __key;			\
 								\
 	debug_check_no_locks_freed((void *)lock, sizeof(*lock));\
-	lockdep_init_map_wait(&(lock)->dep_map, #lock, &__key, 0, LD_WAIT_CONFIG);\
+	lockdep_init_map_type(&(lock)->dep_map, #lock, &__key, 0, \
+			      LD_WAIT_CONFIG, LD_WAIT_INV,	\
+			      LD_LOCK_PERCPU);			\
 } while (0)
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index f5594879175a..20b6797babe2 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -185,12 +185,19 @@ extern void lockdep_unregister_key(struct lock_class_key *key);
  * to lockdep:
  */
 
-extern void lockdep_init_map_waits(struct lockdep_map *lock, const char *name,
-	struct lock_class_key *key, int subclass, short inner, short outer);
+extern void lockdep_init_map_type(struct lockdep_map *lock, const char *name,
+	struct lock_class_key *key, int subclass, u8 inner, u8 outer, u8 lock_type);
+
+static inline void
+lockdep_init_map_waits(struct lockdep_map *lock, const char *name,
+		       struct lock_class_key *key, int subclass, u8 inner, u8 outer)
+{
+	lockdep_init_map_type(lock, name, key, subclass, inner, LD_WAIT_INV, LD_LOCK_NORMAL);
+}
 
 static inline void
 lockdep_init_map_wait(struct lockdep_map *lock, const char *name,
-		      struct lock_class_key *key, int subclass, short inner)
+		      struct lock_class_key *key, int subclass, u8 inner)
 {
 	lockdep_init_map_waits(lock, name, key, subclass, inner, LD_WAIT_INV);
 }
@@ -340,6 +347,8 @@ static inline void lockdep_set_selftest_task(struct task_struct *task)
 # define lock_set_class(l, n, k, s, i)		do { } while (0)
 # define lock_set_subclass(l, s, i)		do { } while (0)
 # define lockdep_init()				do { } while (0)
+# define lockdep_init_map_type(lock, name, key, sub, inner, outer, type) \
+		do { (void)(name); (void)(key); } while (0)
 # define lockdep_init_map_waits(lock, name, key, sub, inner, outer) \
 		do { (void)(name); (void)(key); } while (0)
 # define lockdep_init_map_wait(lock, name, key, sub, inner) \
diff --git a/include/linux/lockdep_types.h b/include/linux/lockdep_types.h
index 9a1fd49df17f..2ec9ff5a7fff 100644
--- a/include/linux/lockdep_types.h
+++ b/include/linux/lockdep_types.h
@@ -30,6 +30,12 @@ enum lockdep_wait_type {
 	LD_WAIT_MAX,		/* must be last */
 };
 
+enum lockdep_lock_type {
+	LD_LOCK_NORMAL = 0,	/* normal, catch all */
+	LD_LOCK_PERCPU,		/* percpu */
+	LD_LOCK_MAX,
+};
+
 #ifdef CONFIG_LOCKDEP
 
 /*
@@ -119,8 +125,10 @@ struct lock_class {
 	int				name_version;
 	const char			*name;
 
-	short				wait_type_inner;
-	short				wait_type_outer;
+	u8				wait_type_inner;
+	u8				wait_type_outer;
+	u8				lock_type;
+	/* u8				hole; */
 
 #ifdef CONFIG_LOCK_STAT
 	unsigned long			contention_point[LOCKSTAT_POINTS];
@@ -169,8 +177,10 @@ struct lockdep_map {
 	struct lock_class_key		*key;
 	struct lock_class		*class_cache[NR_LOCKDEP_CACHING_CLASSES];
 	const char			*name;
-	short				wait_type_outer; /* can be taken in this context */
-	short				wait_type_inner; /* presents this context */
+	u8				wait_type_outer; /* can be taken in this context */
+	u8				wait_type_inner; /* presents this context */
+	u8				lock_type;
+	/* u8				hole; */
 #ifdef CONFIG_LOCK_STAT
 	int				cpu;
 	unsigned long			ip;
diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index 8ae9d7abebc0..5184f6896815 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -1293,6 +1293,7 @@ register_lock_class(struct lockdep_map *lock, unsigned int subclass, int force)
 	class->name_version = count_matching_names(class);
 	class->wait_type_inner = lock->wait_type_inner;
 	class->wait_type_outer = lock->wait_type_outer;
+	class->lock_type = lock->lock_type;
 	/*
 	 * We use RCU's safe list-add method to make
 	 * parallel walking of the hash-list safe:
@@ -4621,9 +4622,9 @@ print_lock_invalid_wait_context(struct task_struct *curr,
  */
 static int check_wait_context(struct task_struct *curr, struct held_lock *next)
 {
-	short next_inner = hlock_class(next)->wait_type_inner;
-	short next_outer = hlock_class(next)->wait_type_outer;
-	short curr_inner;
+	u8 next_inner = hlock_class(next)->wait_type_inner;
+	u8 next_outer = hlock_class(next)->wait_type_outer;
+	u8 curr_inner;
 	int depth;
 
 	if (!next_inner || next->trylock)
@@ -4646,7 +4647,7 @@ static int check_wait_context(struct task_struct *curr, struct held_lock *next)
 
 	for (; depth < curr->lockdep_depth; depth++) {
 		struct held_lock *prev = curr->held_locks + depth;
-		short prev_inner = hlock_class(prev)->wait_type_inner;
+		u8 prev_inner = hlock_class(prev)->wait_type_inner;
 
 		if (prev_inner) {
 			/*
@@ -4695,9 +4696,9 @@ static inline int check_wait_context(struct task_struct *curr,
 /*
  * Initialize a lock instance's lock-class mapping info:
  */
-void lockdep_init_map_waits(struct lockdep_map *lock, const char *name,
+void lockdep_init_map_type(struct lockdep_map *lock, const char *name,
 			    struct lock_class_key *key, int subclass,
-			    short inner, short outer)
+			    u8 inner, u8 outer, u8 lock_type)
 {
 	int i;
 
@@ -4720,6 +4721,7 @@ void lockdep_init_map_waits(struct lockdep_map *lock, const char *name,
 
 	lock->wait_type_outer = outer;
 	lock->wait_type_inner = inner;
+	lock->lock_type = lock_type;
 
 	/*
 	 * No key, no joy, we need to hash something.
@@ -4754,7 +4756,7 @@ void lockdep_init_map_waits(struct lockdep_map *lock, const char *name,
 		raw_local_irq_restore(flags);
 	}
 }
-EXPORT_SYMBOL_GPL(lockdep_init_map_waits);
+EXPORT_SYMBOL_GPL(lockdep_init_map_type);
 
 struct lock_class_key __lockdep_no_validate__;
 EXPORT_SYMBOL_GPL(__lockdep_no_validate__);
-- 
2.30.2



