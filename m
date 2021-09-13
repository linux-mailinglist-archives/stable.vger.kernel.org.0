Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BFFE4094E3
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:35:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345594AbhIMOgO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:36:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:52002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346876AbhIMOdw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:33:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6926A61BB5;
        Mon, 13 Sep 2021 13:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541170;
        bh=uA+Z2jQe7KBT4hJxNx/BhsMOfuKOHHJiobTrQm6FA7s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZDX2p8sCsILFFW1WenKXOLPJrahf2FHK3d1c252ob5B9m+CIpC73rKKG063sfukx+
         5y8CXg1jkxEsiOW/qVSWQsoQP5nw8K1ugAx5e8MFmH48ZoVi5An+lJ9KBsRPGGDuDx
         oCsTOyAKuZ83YcybW+6S68M4N+JtzwzTM2llFxmg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Waiman Long <longman@redhat.com>,
        Tejun Heo <tj@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 191/334] cgroup/cpuset: Fix violation of cpuset locking rule
Date:   Mon, 13 Sep 2021 15:14:05 +0200
Message-Id: <20210913131119.823763660@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Waiman Long <longman@redhat.com>

[ Upstream commit 6ba34d3c73674e46d9e126e4f0cee79e5ef2481c ]

The cpuset fields that manage partition root state do not strictly
follow the cpuset locking rule that update to cpuset has to be done
with both the callback_lock and cpuset_mutex held. This is now fixed
by making sure that the locking rule is upheld.

Fixes: 3881b86128d0 ("cpuset: Add an error state to cpuset.sched.partition")
Fixes: 4b842da276a8 ("cpuset: Make CPU hotplug work with partition")
Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cpuset.c | 58 +++++++++++++++++++++++++-----------------
 1 file changed, 35 insertions(+), 23 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 28a784bf64b1..13b5be6df4da 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1148,6 +1148,7 @@ static int update_parent_subparts_cpumask(struct cpuset *cpuset, int cmd,
 	struct cpuset *parent = parent_cs(cpuset);
 	int adding;	/* Moving cpus from effective_cpus to subparts_cpus */
 	int deleting;	/* Moving cpus from subparts_cpus to effective_cpus */
+	int new_prs;
 	bool part_error = false;	/* Partition error? */
 
 	percpu_rwsem_assert_held(&cpuset_rwsem);
@@ -1183,6 +1184,7 @@ static int update_parent_subparts_cpumask(struct cpuset *cpuset, int cmd,
 	 * A cpumask update cannot make parent's effective_cpus become empty.
 	 */
 	adding = deleting = false;
+	new_prs = cpuset->partition_root_state;
 	if (cmd == partcmd_enable) {
 		cpumask_copy(tmp->addmask, cpuset->cpus_allowed);
 		adding = true;
@@ -1247,11 +1249,11 @@ static int update_parent_subparts_cpumask(struct cpuset *cpuset, int cmd,
 		switch (cpuset->partition_root_state) {
 		case PRS_ENABLED:
 			if (part_error)
-				cpuset->partition_root_state = PRS_ERROR;
+				new_prs = PRS_ERROR;
 			break;
 		case PRS_ERROR:
 			if (!part_error)
-				cpuset->partition_root_state = PRS_ENABLED;
+				new_prs = PRS_ENABLED;
 			break;
 		}
 		/*
@@ -1260,10 +1262,10 @@ static int update_parent_subparts_cpumask(struct cpuset *cpuset, int cmd,
 		part_error = (prev_prs == PRS_ERROR);
 	}
 
-	if (!part_error && (cpuset->partition_root_state == PRS_ERROR))
+	if (!part_error && (new_prs == PRS_ERROR))
 		return 0;	/* Nothing need to be done */
 
-	if (cpuset->partition_root_state == PRS_ERROR) {
+	if (new_prs == PRS_ERROR) {
 		/*
 		 * Remove all its cpus from parent's subparts_cpus.
 		 */
@@ -1272,7 +1274,7 @@ static int update_parent_subparts_cpumask(struct cpuset *cpuset, int cmd,
 				       parent->subparts_cpus);
 	}
 
-	if (!adding && !deleting)
+	if (!adding && !deleting && (new_prs == cpuset->partition_root_state))
 		return 0;
 
 	/*
@@ -1299,6 +1301,9 @@ static int update_parent_subparts_cpumask(struct cpuset *cpuset, int cmd,
 	}
 
 	parent->nr_subparts_cpus = cpumask_weight(parent->subparts_cpus);
+
+	if (cpuset->partition_root_state != new_prs)
+		cpuset->partition_root_state = new_prs;
 	spin_unlock_irq(&callback_lock);
 
 	return cmd == partcmd_update;
@@ -1321,6 +1326,7 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp)
 	struct cpuset *cp;
 	struct cgroup_subsys_state *pos_css;
 	bool need_rebuild_sched_domains = false;
+	int new_prs;
 
 	rcu_read_lock();
 	cpuset_for_each_descendant_pre(cp, pos_css, cs) {
@@ -1360,7 +1366,8 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp)
 		 * update_tasks_cpumask() again for tasks in the parent
 		 * cpuset if the parent's subparts_cpus changes.
 		 */
-		if ((cp != cs) && cp->partition_root_state) {
+		new_prs = cp->partition_root_state;
+		if ((cp != cs) && new_prs) {
 			switch (parent->partition_root_state) {
 			case PRS_DISABLED:
 				/*
@@ -1370,7 +1377,7 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp)
 				 */
 				WARN_ON_ONCE(cp->partition_root_state
 					     != PRS_ERROR);
-				cp->partition_root_state = PRS_DISABLED;
+				new_prs = PRS_DISABLED;
 
 				/*
 				 * clear_bit() is an atomic operation and
@@ -1391,11 +1398,7 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp)
 				/*
 				 * When parent is invalid, it has to be too.
 				 */
-				cp->partition_root_state = PRS_ERROR;
-				if (cp->nr_subparts_cpus) {
-					cp->nr_subparts_cpus = 0;
-					cpumask_clear(cp->subparts_cpus);
-				}
+				new_prs = PRS_ERROR;
 				break;
 			}
 		}
@@ -1407,8 +1410,7 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp)
 		spin_lock_irq(&callback_lock);
 
 		cpumask_copy(cp->effective_cpus, tmp->new_cpus);
-		if (cp->nr_subparts_cpus &&
-		   (cp->partition_root_state != PRS_ENABLED)) {
+		if (cp->nr_subparts_cpus && (new_prs != PRS_ENABLED)) {
 			cp->nr_subparts_cpus = 0;
 			cpumask_clear(cp->subparts_cpus);
 		} else if (cp->nr_subparts_cpus) {
@@ -1435,6 +1437,10 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp)
 					= cpumask_weight(cp->subparts_cpus);
 			}
 		}
+
+		if (new_prs != cp->partition_root_state)
+			cp->partition_root_state = new_prs;
+
 		spin_unlock_irq(&callback_lock);
 
 		WARN_ON(!is_in_v2_mode() &&
@@ -1944,25 +1950,25 @@ out:
  */
 static int update_prstate(struct cpuset *cs, int new_prs)
 {
-	int err;
+	int err, old_prs = cs->partition_root_state;
 	struct cpuset *parent = parent_cs(cs);
 	struct tmpmasks tmpmask;
 
-	if (new_prs == cs->partition_root_state)
+	if (old_prs == new_prs)
 		return 0;
 
 	/*
 	 * Cannot force a partial or invalid partition root to a full
 	 * partition root.
 	 */
-	if (new_prs && (cs->partition_root_state < 0))
+	if (new_prs && (old_prs == PRS_ERROR))
 		return -EINVAL;
 
 	if (alloc_cpumasks(NULL, &tmpmask))
 		return -ENOMEM;
 
 	err = -EINVAL;
-	if (!cs->partition_root_state) {
+	if (!old_prs) {
 		/*
 		 * Turning on partition root requires setting the
 		 * CS_CPU_EXCLUSIVE bit implicitly as well and cpus_allowed
@@ -1981,14 +1987,12 @@ static int update_prstate(struct cpuset *cs, int new_prs)
 			update_flag(CS_CPU_EXCLUSIVE, cs, 0);
 			goto out;
 		}
-		cs->partition_root_state = PRS_ENABLED;
 	} else {
 		/*
 		 * Turning off partition root will clear the
 		 * CS_CPU_EXCLUSIVE bit.
 		 */
-		if (cs->partition_root_state == PRS_ERROR) {
-			cs->partition_root_state = PRS_DISABLED;
+		if (old_prs == PRS_ERROR) {
 			update_flag(CS_CPU_EXCLUSIVE, cs, 0);
 			err = 0;
 			goto out;
@@ -1999,8 +2003,6 @@ static int update_prstate(struct cpuset *cs, int new_prs)
 		if (err)
 			goto out;
 
-		cs->partition_root_state = PRS_DISABLED;
-
 		/* Turning off CS_CPU_EXCLUSIVE will not return error */
 		update_flag(CS_CPU_EXCLUSIVE, cs, 0);
 	}
@@ -2017,6 +2019,12 @@ static int update_prstate(struct cpuset *cs, int new_prs)
 
 	rebuild_sched_domains_locked();
 out:
+	if (!err) {
+		spin_lock_irq(&callback_lock);
+		cs->partition_root_state = new_prs;
+		spin_unlock_irq(&callback_lock);
+	}
+
 	free_cpumasks(NULL, &tmpmask);
 	return err;
 }
@@ -3080,8 +3088,10 @@ retry:
 	if (is_partition_root(cs) && (cpumask_empty(&new_cpus) ||
 	   (parent->partition_root_state == PRS_ERROR))) {
 		if (cs->nr_subparts_cpus) {
+			spin_lock_irq(&callback_lock);
 			cs->nr_subparts_cpus = 0;
 			cpumask_clear(cs->subparts_cpus);
+			spin_unlock_irq(&callback_lock);
 			compute_effective_cpumask(&new_cpus, cs, parent);
 		}
 
@@ -3095,7 +3105,9 @@ retry:
 		     cpumask_empty(&new_cpus)) {
 			update_parent_subparts_cpumask(cs, partcmd_disable,
 						       NULL, tmp);
+			spin_lock_irq(&callback_lock);
 			cs->partition_root_state = PRS_ERROR;
+			spin_unlock_irq(&callback_lock);
 		}
 		cpuset_force_rebuild();
 	}
-- 
2.30.2



