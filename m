Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFC4B14E1E1
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 19:48:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731547AbgA3SsY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 13:48:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:59294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731545AbgA3SsX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 13:48:23 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B0718214AF;
        Thu, 30 Jan 2020 18:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580410102;
        bh=h3Dozgxivx3v/d8eOB2GQGgOpiynf7UVr6c+2jL5SgE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OK37YtpMDZQZuU4HcLNiHB7Fg1+j4nArYDa3vUm2A0hiehzbt2D2pjMndYREkFV9A
         cl4ORv3wTOcJf/cKK7sOyW2SIOMKmDvZaiGYLm1fmWdBe7m3AsAHxk3czEOQEu8ucK
         9ltA51DlhovqpmvhpHW7BxndMoIKWAd1OPT7wHgs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Galbraith <efault@gmx.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Janne Huttunen <janne.huttunen@nokia.com>
Subject: [PATCH 4.19 46/55] sched/fair: Add tmp_alone_branch assertion
Date:   Thu, 30 Jan 2020 19:39:27 +0100
Message-Id: <20200130183616.925160986@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200130183608.563083888@linuxfoundation.org>
References: <20200130183608.563083888@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

commit 5d299eabea5a251fbf66e8277704b874bbba92dc upstream.

The magic in list_add_leaf_cfs_rq() requires that at the end of
enqueue_task_fair():

  rq->tmp_alone_branch == &rq->lead_cfs_rq_list

If this is violated, list integrity is compromised for list entries
and the tmp_alone_branch pointer might dangle.

Also, reflow list_add_leaf_cfs_rq() while there. This looses one
indentation level and generates a form that's convenient for the next
patch.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Janne Huttunen <janne.huttunen@nokia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/sched/fair.c |  126 +++++++++++++++++++++++++++++-----------------------
 1 file changed, 71 insertions(+), 55 deletions(-)

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -284,64 +284,69 @@ static inline struct cfs_rq *group_cfs_r
 
 static inline void list_add_leaf_cfs_rq(struct cfs_rq *cfs_rq)
 {
-	if (!cfs_rq->on_list) {
-		struct rq *rq = rq_of(cfs_rq);
-		int cpu = cpu_of(rq);
+	struct rq *rq = rq_of(cfs_rq);
+	int cpu = cpu_of(rq);
+
+	if (cfs_rq->on_list)
+		return;
+
+	cfs_rq->on_list = 1;
+
+	/*
+	 * Ensure we either appear before our parent (if already
+	 * enqueued) or force our parent to appear after us when it is
+	 * enqueued. The fact that we always enqueue bottom-up
+	 * reduces this to two cases and a special case for the root
+	 * cfs_rq. Furthermore, it also means that we will always reset
+	 * tmp_alone_branch either when the branch is connected
+	 * to a tree or when we reach the top of the tree
+	 */
+	if (cfs_rq->tg->parent &&
+	    cfs_rq->tg->parent->cfs_rq[cpu]->on_list) {
 		/*
-		 * Ensure we either appear before our parent (if already
-		 * enqueued) or force our parent to appear after us when it is
-		 * enqueued. The fact that we always enqueue bottom-up
-		 * reduces this to two cases and a special case for the root
-		 * cfs_rq. Furthermore, it also means that we will always reset
-		 * tmp_alone_branch either when the branch is connected
-		 * to a tree or when we reach the beg of the tree
+		 * If parent is already on the list, we add the child
+		 * just before. Thanks to circular linked property of
+		 * the list, this means to put the child at the tail
+		 * of the list that starts by parent.
 		 */
-		if (cfs_rq->tg->parent &&
-		    cfs_rq->tg->parent->cfs_rq[cpu]->on_list) {
-			/*
-			 * If parent is already on the list, we add the child
-			 * just before. Thanks to circular linked property of
-			 * the list, this means to put the child at the tail
-			 * of the list that starts by parent.
-			 */
-			list_add_tail_rcu(&cfs_rq->leaf_cfs_rq_list,
-				&(cfs_rq->tg->parent->cfs_rq[cpu]->leaf_cfs_rq_list));
-			/*
-			 * The branch is now connected to its tree so we can
-			 * reset tmp_alone_branch to the beginning of the
-			 * list.
-			 */
-			rq->tmp_alone_branch = &rq->leaf_cfs_rq_list;
-		} else if (!cfs_rq->tg->parent) {
-			/*
-			 * cfs rq without parent should be put
-			 * at the tail of the list.
-			 */
-			list_add_tail_rcu(&cfs_rq->leaf_cfs_rq_list,
-				&rq->leaf_cfs_rq_list);
-			/*
-			 * We have reach the beg of a tree so we can reset
-			 * tmp_alone_branch to the beginning of the list.
-			 */
-			rq->tmp_alone_branch = &rq->leaf_cfs_rq_list;
-		} else {
-			/*
-			 * The parent has not already been added so we want to
-			 * make sure that it will be put after us.
-			 * tmp_alone_branch points to the beg of the branch
-			 * where we will add parent.
-			 */
-			list_add_rcu(&cfs_rq->leaf_cfs_rq_list,
-				rq->tmp_alone_branch);
-			/*
-			 * update tmp_alone_branch to points to the new beg
-			 * of the branch
-			 */
-			rq->tmp_alone_branch = &cfs_rq->leaf_cfs_rq_list;
-		}
+		list_add_tail_rcu(&cfs_rq->leaf_cfs_rq_list,
+			&(cfs_rq->tg->parent->cfs_rq[cpu]->leaf_cfs_rq_list));
+		/*
+		 * The branch is now connected to its tree so we can
+		 * reset tmp_alone_branch to the beginning of the
+		 * list.
+		 */
+		rq->tmp_alone_branch = &rq->leaf_cfs_rq_list;
+		return;
+	}
 
-		cfs_rq->on_list = 1;
+	if (!cfs_rq->tg->parent) {
+		/*
+		 * cfs rq without parent should be put
+		 * at the tail of the list.
+		 */
+		list_add_tail_rcu(&cfs_rq->leaf_cfs_rq_list,
+			&rq->leaf_cfs_rq_list);
+		/*
+		 * We have reach the top of a tree so we can reset
+		 * tmp_alone_branch to the beginning of the list.
+		 */
+		rq->tmp_alone_branch = &rq->leaf_cfs_rq_list;
+		return;
 	}
+
+	/*
+	 * The parent has not already been added so we want to
+	 * make sure that it will be put after us.
+	 * tmp_alone_branch points to the begin of the branch
+	 * where we will add parent.
+	 */
+	list_add_rcu(&cfs_rq->leaf_cfs_rq_list, rq->tmp_alone_branch);
+	/*
+	 * update tmp_alone_branch to points to the new begin
+	 * of the branch
+	 */
+	rq->tmp_alone_branch = &cfs_rq->leaf_cfs_rq_list;
 }
 
 static inline void list_del_leaf_cfs_rq(struct cfs_rq *cfs_rq)
@@ -352,7 +357,12 @@ static inline void list_del_leaf_cfs_rq(
 	}
 }
 
-/* Iterate through all leaf cfs_rq's on a runqueue: */
+static inline void assert_list_leaf_cfs_rq(struct rq *rq)
+{
+	SCHED_WARN_ON(rq->tmp_alone_branch != &rq->leaf_cfs_rq_list);
+}
+
+/* Iterate through all cfs_rq's on a runqueue in bottom-up order */
 #define for_each_leaf_cfs_rq(rq, cfs_rq) \
 	list_for_each_entry_rcu(cfs_rq, &rq->leaf_cfs_rq_list, leaf_cfs_rq_list)
 
@@ -446,6 +456,10 @@ static inline void list_del_leaf_cfs_rq(
 {
 }
 
+static inline void assert_list_leaf_cfs_rq(struct rq *rq)
+{
+}
+
 #define for_each_leaf_cfs_rq(rq, cfs_rq)	\
 		for (cfs_rq = &rq->cfs; cfs_rq; cfs_rq = NULL)
 
@@ -5160,6 +5174,8 @@ enqueue_task_fair(struct rq *rq, struct
 	if (!se)
 		add_nr_running(rq, 1);
 
+	assert_list_leaf_cfs_rq(rq);
+
 	hrtick_update(rq);
 }
 


