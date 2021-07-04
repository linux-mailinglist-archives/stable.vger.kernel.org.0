Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2D823BB267
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:14:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232009AbhGDXPa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:15:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:50748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233148AbhGDXON (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:14:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 69D636198A;
        Sun,  4 Jul 2021 23:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625440171;
        bh=7Af/1a8ubpi2lqngf8VAITbaoVHd239VIRc4rzOCK0A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RmqvtZdswVlH4q0cmpYajWx4/nqq8tKfaW+iN1XoR1ysgPpuBeN89SyB3rASu5fF7
         1VYGi3sm/EgDRhTH8PWr6vp9Jlk932IgCDTG0FJJ/NVgC01xhkfWij8jT+5VpMRT18
         XuM5fVZ3NM75RIC5dpPCJJb8BoZdxee5uvIe56bO7oeNHAEN+OZzflWF4LKW74YO4c
         OEslG53Jc/zz6MykFjaTSYeU63iZMqYqFKntzURrmNe61miZTuj+7U/JtVYP0eR1dt
         EXSmEBA8BGlml7cSKkWMssMbT8/XHhVrDBXZSyea5n3DQI3fSO8+8eVSDMKEBiTF/B
         sSmnFIdyf+qiA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Boqun Feng <boqun.feng@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.10 65/70] locking/lockdep: Fix the dep path printing for backwards BFS
Date:   Sun,  4 Jul 2021 19:07:58 -0400
Message-Id: <20210704230804.1490078-65-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230804.1490078-1-sashal@kernel.org>
References: <20210704230804.1490078-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Boqun Feng <boqun.feng@gmail.com>

[ Upstream commit 69c7a5fb2482636f525f016c8333fdb9111ecb9d ]

We use the same code to print backwards lock dependency path as the
forwards lock dependency path, and this could result into incorrect
printing because for a backwards lock_list ->trace is not the call trace
where the lock of ->class is acquired.

Fix this by introducing a separate function on printing the backwards
dependency path. Also add a few comments about the printing while we are
at it.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/r/20210618170110.3699115-2-boqun.feng@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/locking/lockdep.c | 108 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 106 insertions(+), 2 deletions(-)

diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index 858b96b438ce..a26a048f2af7 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -2295,7 +2295,56 @@ static void print_lock_class_header(struct lock_class *class, int depth)
 }
 
 /*
- * printk the shortest lock dependencies from @start to @end in reverse order:
+ * Dependency path printing:
+ *
+ * After BFS we get a lock dependency path (linked via ->parent of lock_list),
+ * printing out each lock in the dependency path will help on understanding how
+ * the deadlock could happen. Here are some details about dependency path
+ * printing:
+ *
+ * 1)	A lock_list can be either forwards or backwards for a lock dependency,
+ * 	for a lock dependency A -> B, there are two lock_lists:
+ *
+ * 	a)	lock_list in the ->locks_after list of A, whose ->class is B and
+ * 		->links_to is A. In this case, we can say the lock_list is
+ * 		"A -> B" (forwards case).
+ *
+ * 	b)	lock_list in the ->locks_before list of B, whose ->class is A
+ * 		and ->links_to is B. In this case, we can say the lock_list is
+ * 		"B <- A" (bacwards case).
+ *
+ * 	The ->trace of both a) and b) point to the call trace where B was
+ * 	acquired with A held.
+ *
+ * 2)	A "helper" lock_list is introduced during BFS, this lock_list doesn't
+ * 	represent a certain lock dependency, it only provides an initial entry
+ * 	for BFS. For example, BFS may introduce a "helper" lock_list whose
+ * 	->class is A, as a result BFS will search all dependencies starting with
+ * 	A, e.g. A -> B or A -> C.
+ *
+ * 	The notation of a forwards helper lock_list is like "-> A", which means
+ * 	we should search the forwards dependencies starting with "A", e.g A -> B
+ * 	or A -> C.
+ *
+ * 	The notation of a bacwards helper lock_list is like "<- B", which means
+ * 	we should search the backwards dependencies ending with "B", e.g.
+ * 	B <- A or B <- C.
+ */
+
+/*
+ * printk the shortest lock dependencies from @root to @leaf in reverse order.
+ *
+ * We have a lock dependency path as follow:
+ *
+ *    @root                                                                 @leaf
+ *      |                                                                     |
+ *      V                                                                     V
+ *	          ->parent                                   ->parent
+ * | lock_list | <--------- | lock_list | ... | lock_list  | <--------- | lock_list |
+ * |    -> L1  |            | L1 -> L2  | ... |Ln-2 -> Ln-1|            | Ln-1 -> Ln|
+ *
+ * , so it's natural that we start from @leaf and print every ->class and
+ * ->trace until we reach the @root.
  */
 static void __used
 print_shortest_lock_dependencies(struct lock_list *leaf,
@@ -2323,6 +2372,61 @@ print_shortest_lock_dependencies(struct lock_list *leaf,
 	} while (entry && (depth >= 0));
 }
 
+/*
+ * printk the shortest lock dependencies from @leaf to @root.
+ *
+ * We have a lock dependency path (from a backwards search) as follow:
+ *
+ *    @leaf                                                                 @root
+ *      |                                                                     |
+ *      V                                                                     V
+ *	          ->parent                                   ->parent
+ * | lock_list | ---------> | lock_list | ... | lock_list  | ---------> | lock_list |
+ * | L2 <- L1  |            | L3 <- L2  | ... | Ln <- Ln-1 |            |    <- Ln  |
+ *
+ * , so when we iterate from @leaf to @root, we actually print the lock
+ * dependency path L1 -> L2 -> .. -> Ln in the non-reverse order.
+ *
+ * Another thing to notice here is that ->class of L2 <- L1 is L1, while the
+ * ->trace of L2 <- L1 is the call trace of L2, in fact we don't have the call
+ * trace of L1 in the dependency path, which is alright, because most of the
+ * time we can figure out where L1 is held from the call trace of L2.
+ */
+static void __used
+print_shortest_lock_dependencies_backwards(struct lock_list *leaf,
+					   struct lock_list *root)
+{
+	struct lock_list *entry = leaf;
+	const struct lock_trace *trace = NULL;
+	int depth;
+
+	/*compute depth from generated tree by BFS*/
+	depth = get_lock_depth(leaf);
+
+	do {
+		print_lock_class_header(entry->class, depth);
+		if (trace) {
+			printk("%*s ... acquired at:\n", depth, "");
+			print_lock_trace(trace, 2);
+			printk("\n");
+		}
+
+		/*
+		 * Record the pointer to the trace for the next lock_list
+		 * entry, see the comments for the function.
+		 */
+		trace = entry->trace;
+
+		if (depth == 0 && (entry != root)) {
+			printk("lockdep:%s bad path found in chain graph\n", __func__);
+			break;
+		}
+
+		entry = get_lock_parent(entry);
+		depth--;
+	} while (entry && (depth >= 0));
+}
+
 static void
 print_irq_lock_scenario(struct lock_list *safe_entry,
 			struct lock_list *unsafe_entry,
@@ -2440,7 +2544,7 @@ print_bad_irq_dependency(struct task_struct *curr,
 	prev_root->trace = save_trace();
 	if (!prev_root->trace)
 		return;
-	print_shortest_lock_dependencies(backwards_entry, prev_root);
+	print_shortest_lock_dependencies_backwards(backwards_entry, prev_root);
 
 	pr_warn("\nthe dependencies between the lock to be acquired");
 	pr_warn(" and %s-irq-unsafe lock:\n", irqclass);
-- 
2.30.2

