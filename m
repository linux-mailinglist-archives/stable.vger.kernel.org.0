Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50B12409209
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:06:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344752AbhIMOHZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:07:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:56004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344591AbhIMOFM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:05:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B0B9C610E7;
        Mon, 13 Sep 2021 13:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540381;
        bh=50zYpnkjEY2pTp+vMAnZUQeG2tdydDrCG/kJxt09Po8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rCx10e5PUz+tYmuPYpm2TrYM4Fw+F7akIFfMNoE/p4/ed3aohmbssq7bBAr1v3P/3
         TkrFpXZKd7R++SGKT08PL0k0sa1m1aDp9JSXCMM5zPnnzydBHu6RIG9u9mTe7kH7+J
         h3FurMcF99q4ql9r43oIw/yMGZOFALJy063vqFLM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Waiman Long <longman@redhat.com>,
        Tejun Heo <tj@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 170/300] cgroup/cpuset: Miscellaneous code cleanup
Date:   Mon, 13 Sep 2021 15:13:51 +0200
Message-Id: <20210913131115.150290204@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
References: <20210913131109.253835823@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Waiman Long <longman@redhat.com>

[ Upstream commit 0f3adb8a1e5f36e792598c1d77a2cfac9c90a4f9 ]

Use more descriptive variable names for update_prstate(), remove
unnecessary code and fix some typos. There is no functional change.

Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cpuset.c | 40 +++++++++++++++++++---------------------
 1 file changed, 19 insertions(+), 21 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 592e9e37542f..28a784bf64b1 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1114,7 +1114,7 @@ enum subparts_cmd {
  * cpus_allowed can be granted or an error code will be returned.
  *
  * For partcmd_disable, the cpuset is being transofrmed from a partition
- * root back to a non-partition root. any CPUs in cpus_allowed that are in
+ * root back to a non-partition root. Any CPUs in cpus_allowed that are in
  * parent's subparts_cpus will be taken away from that cpumask and put back
  * into parent's effective_cpus. 0 should always be returned.
  *
@@ -1225,7 +1225,7 @@ static int update_parent_subparts_cpumask(struct cpuset *cpuset, int cmd,
 		/*
 		 * partcmd_update w/o newmask:
 		 *
-		 * addmask = cpus_allowed & parent->effectiveb_cpus
+		 * addmask = cpus_allowed & parent->effective_cpus
 		 *
 		 * Note that parent's subparts_cpus may have been
 		 * pre-shrunk in case there is a change in the cpu list.
@@ -1365,12 +1365,12 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp)
 			case PRS_DISABLED:
 				/*
 				 * If parent is not a partition root or an
-				 * invalid partition root, clear the state
-				 * state and the CS_CPU_EXCLUSIVE flag.
+				 * invalid partition root, clear its state
+				 * and its CS_CPU_EXCLUSIVE flag.
 				 */
 				WARN_ON_ONCE(cp->partition_root_state
 					     != PRS_ERROR);
-				cp->partition_root_state = 0;
+				cp->partition_root_state = PRS_DISABLED;
 
 				/*
 				 * clear_bit() is an atomic operation and
@@ -1937,30 +1937,28 @@ out:
 
 /*
  * update_prstate - update partititon_root_state
- * cs:	the cpuset to update
- * val: 0 - disabled, 1 - enabled
+ * cs: the cpuset to update
+ * new_prs: new partition root state
  *
  * Call with cpuset_mutex held.
  */
-static int update_prstate(struct cpuset *cs, int val)
+static int update_prstate(struct cpuset *cs, int new_prs)
 {
 	int err;
 	struct cpuset *parent = parent_cs(cs);
-	struct tmpmasks tmp;
+	struct tmpmasks tmpmask;
 
-	if ((val != 0) && (val != 1))
-		return -EINVAL;
-	if (val == cs->partition_root_state)
+	if (new_prs == cs->partition_root_state)
 		return 0;
 
 	/*
 	 * Cannot force a partial or invalid partition root to a full
 	 * partition root.
 	 */
-	if (val && cs->partition_root_state)
+	if (new_prs && (cs->partition_root_state < 0))
 		return -EINVAL;
 
-	if (alloc_cpumasks(NULL, &tmp))
+	if (alloc_cpumasks(NULL, &tmpmask))
 		return -ENOMEM;
 
 	err = -EINVAL;
@@ -1978,7 +1976,7 @@ static int update_prstate(struct cpuset *cs, int val)
 			goto out;
 
 		err = update_parent_subparts_cpumask(cs, partcmd_enable,
-						     NULL, &tmp);
+						     NULL, &tmpmask);
 		if (err) {
 			update_flag(CS_CPU_EXCLUSIVE, cs, 0);
 			goto out;
@@ -1990,18 +1988,18 @@ static int update_prstate(struct cpuset *cs, int val)
 		 * CS_CPU_EXCLUSIVE bit.
 		 */
 		if (cs->partition_root_state == PRS_ERROR) {
-			cs->partition_root_state = 0;
+			cs->partition_root_state = PRS_DISABLED;
 			update_flag(CS_CPU_EXCLUSIVE, cs, 0);
 			err = 0;
 			goto out;
 		}
 
 		err = update_parent_subparts_cpumask(cs, partcmd_disable,
-						     NULL, &tmp);
+						     NULL, &tmpmask);
 		if (err)
 			goto out;
 
-		cs->partition_root_state = 0;
+		cs->partition_root_state = PRS_DISABLED;
 
 		/* Turning off CS_CPU_EXCLUSIVE will not return error */
 		update_flag(CS_CPU_EXCLUSIVE, cs, 0);
@@ -2015,11 +2013,11 @@ static int update_prstate(struct cpuset *cs, int val)
 		update_tasks_cpumask(parent);
 
 	if (parent->child_ecpus_count)
-		update_sibling_cpumasks(parent, cs, &tmp);
+		update_sibling_cpumasks(parent, cs, &tmpmask);
 
 	rebuild_sched_domains_locked();
 out:
-	free_cpumasks(NULL, &tmp);
+	free_cpumasks(NULL, &tmpmask);
 	return err;
 }
 
@@ -3060,7 +3058,7 @@ retry:
 		goto retry;
 	}
 
-	parent =  parent_cs(cs);
+	parent = parent_cs(cs);
 	compute_effective_cpumask(&new_cpus, cs, parent);
 	nodes_and(new_mems, cs->mems_allowed, parent->effective_mems);
 
-- 
2.30.2



