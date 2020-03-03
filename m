Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 195A3178176
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 20:02:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388235AbgCCSCd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 13:02:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:47092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388226AbgCCSC3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 13:02:29 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 72E63206D5;
        Tue,  3 Mar 2020 18:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583258547;
        bh=0xlMtQIoyzAVvX8j4C4/77qTkqd8Dd9Gk4a4Bx7/u1U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aRwSnYhPBezdv2OpW4Tt0tUYbVTbUpHMtd1URhU+H5CHcH+c3qrXFEQnrIqkcOB9C
         XcxsBruP9s/6InXIB6/55gxr88y/3kxS1L4OGrxdMTI/v0CSLdNGH+he2SdjCCehJI
         fmtmemGo8o1H0OU8w2FD39p8xgFcFBAh8FQyHmAE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vincent Guittot <vincent.guittot@linaro.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, sargun@sargun.me,
        tj@kernel.org, xiexiuqi@huawei.com, xiezhipeng1@huawei.com,
        Ingo Molnar <mingo@kernel.org>,
        Vishnu Rangayyan <vishnu.rangayyan@apple.com>
Subject: [PATCH 4.19 73/87] sched/fair: Fix O(nr_cgroups) in the load balancing path
Date:   Tue,  3 Mar 2020 18:44:04 +0100
Message-Id: <20200303174356.821996642@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174349.075101355@linuxfoundation.org>
References: <20200303174349.075101355@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Guittot <vincent.guittot@linaro.org>

commit 039ae8bcf7a5f4476f4487e6bf816885fb3fb617 upstream.

This re-applies the commit reverted here:

  commit c40f7d74c741 ("sched/fair: Fix infinite loop in update_blocked_averages() by reverting a9e7f6544b9c")

I.e. now that cfs_rq can be safely removed/added in the list, we can re-apply:

 commit a9e7f6544b9c ("sched/fair: Fix O(nr_cgroups) in load balance path")

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: sargun@sargun.me
Cc: tj@kernel.org
Cc: xiexiuqi@huawei.com
Cc: xiezhipeng1@huawei.com
Link: https://lkml.kernel.org/r/1549469662-13614-3-git-send-email-vincent.guittot@linaro.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Vishnu Rangayyan <vishnu.rangayyan@apple.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/sched/fair.c |   43 ++++++++++++++++++++++++++++++++++---------
 1 file changed, 34 insertions(+), 9 deletions(-)

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -375,9 +375,10 @@ static inline void assert_list_leaf_cfs_
 	SCHED_WARN_ON(rq->tmp_alone_branch != &rq->leaf_cfs_rq_list);
 }
 
-/* Iterate through all cfs_rq's on a runqueue in bottom-up order */
-#define for_each_leaf_cfs_rq(rq, cfs_rq) \
-	list_for_each_entry_rcu(cfs_rq, &rq->leaf_cfs_rq_list, leaf_cfs_rq_list)
+/* Iterate thr' all leaf cfs_rq's on a runqueue */
+#define for_each_leaf_cfs_rq_safe(rq, cfs_rq, pos)			\
+	list_for_each_entry_safe(cfs_rq, pos, &rq->leaf_cfs_rq_list,	\
+				 leaf_cfs_rq_list)
 
 /* Do the two (enqueued) entities belong to the same group ? */
 static inline struct cfs_rq *
@@ -474,8 +475,8 @@ static inline void assert_list_leaf_cfs_
 {
 }
 
-#define for_each_leaf_cfs_rq(rq, cfs_rq)	\
-		for (cfs_rq = &rq->cfs; cfs_rq; cfs_rq = NULL)
+#define for_each_leaf_cfs_rq_safe(rq, cfs_rq, pos)	\
+		for (cfs_rq = &rq->cfs, pos = NULL; cfs_rq; cfs_rq = pos)
 
 static inline struct sched_entity *parent_entity(struct sched_entity *se)
 {
@@ -7461,10 +7462,27 @@ static inline bool others_have_blocked(s
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
 
+static inline bool cfs_rq_is_decayed(struct cfs_rq *cfs_rq)
+{
+	if (cfs_rq->load.weight)
+		return false;
+
+	if (cfs_rq->avg.load_sum)
+		return false;
+
+	if (cfs_rq->avg.util_sum)
+		return false;
+
+	if (cfs_rq->avg.runnable_load_sum)
+		return false;
+
+	return true;
+}
+
 static void update_blocked_averages(int cpu)
 {
 	struct rq *rq = cpu_rq(cpu);
-	struct cfs_rq *cfs_rq;
+	struct cfs_rq *cfs_rq, *pos;
 	const struct sched_class *curr_class;
 	struct rq_flags rf;
 	bool done = true;
@@ -7476,7 +7494,7 @@ static void update_blocked_averages(int
 	 * Iterates the task_group tree in a bottom up fashion, see
 	 * list_add_leaf_cfs_rq() for details.
 	 */
-	for_each_leaf_cfs_rq(rq, cfs_rq) {
+	for_each_leaf_cfs_rq_safe(rq, cfs_rq, pos) {
 		struct sched_entity *se;
 
 		if (update_cfs_rq_load_avg(cfs_rq_clock_task(cfs_rq), cfs_rq))
@@ -7487,6 +7505,13 @@ static void update_blocked_averages(int
 		if (se && !skip_blocked_update(se))
 			update_load_avg(cfs_rq_of(se), se, 0);
 
+		/*
+		 * There can be a lot of idle CPU cgroups.  Don't let fully
+		 * decayed cfs_rqs linger on the list.
+		 */
+		if (cfs_rq_is_decayed(cfs_rq))
+			list_del_leaf_cfs_rq(cfs_rq);
+
 		/* Don't need periodic decay once load/util_avg are null */
 		if (cfs_rq_has_blocked(cfs_rq))
 			done = false;
@@ -10272,10 +10297,10 @@ const struct sched_class fair_sched_clas
 #ifdef CONFIG_SCHED_DEBUG
 void print_cfs_stats(struct seq_file *m, int cpu)
 {
-	struct cfs_rq *cfs_rq;
+	struct cfs_rq *cfs_rq, *pos;
 
 	rcu_read_lock();
-	for_each_leaf_cfs_rq(cpu_rq(cpu), cfs_rq)
+	for_each_leaf_cfs_rq_safe(cpu_rq(cpu), cfs_rq, pos)
 		print_cfs_rq(m, cpu, cfs_rq);
 	rcu_read_unlock();
 }


