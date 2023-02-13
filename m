Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58C326948DF
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 15:54:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbjBMOyH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 09:54:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230099AbjBMOyG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 09:54:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88BB21C7E5
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 06:53:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3E6EAB81258
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 14:53:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C681C433D2;
        Mon, 13 Feb 2023 14:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300034;
        bh=XmJTHJrOFMz+rBBev258Uxi8yZXJEb1aGZyH29/8ZqU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XH0NnCJJdGm3eDgqQVx0LNRHCBWHVe6VYBTUm2cqEVvVUyBokb01xDvA41yry6Wup
         C4DlsUQS9ZwQZA8mvbAh91eXvWjNmcilLvrcOjGaamqJfhk3zD3y/5RD5w3tThJxmF
         LZ4H4pdcotmJUWwUMG/zkci9kke15LlfWjRVj7m4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Will Deacon <will@kernel.org>,
        Waiman Long <longman@redhat.com>, Tejun Heo <tj@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 038/114] cpuset: Call set_cpus_allowed_ptr() with appropriate mask for task
Date:   Mon, 13 Feb 2023 15:47:53 +0100
Message-Id: <20230213144744.101360703@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144742.219399167@linuxfoundation.org>
References: <20230213144742.219399167@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will@kernel.org>

[ Upstream commit 7a2127e66a00e073db8d90f9aac308f4a8a64226 ]

set_cpus_allowed_ptr() will fail with -EINVAL if the requested
affinity mask is not a subset of the task_cpu_possible_mask() for the
task being updated. Consequently, on a heterogeneous system with cpusets
spanning the different CPU types, updates to the cgroup hierarchy can
silently fail to update task affinities when the effective affinity
mask for the cpuset is expanded.

For example, consider an arm64 system with 4 CPUs, where CPUs 2-3 are
the only cores capable of executing 32-bit tasks. Attaching a 32-bit
task to a cpuset containing CPUs 0-2 will correctly affine the task to
CPU 2. Extending the cpuset to CPUs 0-3, however, will fail to extend
the affinity mask of the 32-bit task because update_tasks_cpumask() will
pass the full 0-3 mask to set_cpus_allowed_ptr().

Extend update_tasks_cpumask() to take a temporary 'cpumask' paramater
and use it to mask the 'effective_cpus' mask with the possible mask for
each task being updated.

Fixes: 431c69fac05b ("cpuset: Honour task_cpu_possible_mask() in guarantee_online_cpus()")
Signed-off-by: Will Deacon <will@kernel.org>
Acked-by: Waiman Long <longman@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cpuset.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index a753adcbc7c70..fac4260366208 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1201,12 +1201,13 @@ void rebuild_sched_domains(void)
 /**
  * update_tasks_cpumask - Update the cpumasks of tasks in the cpuset.
  * @cs: the cpuset in which each task's cpus_allowed mask needs to be changed
+ * @new_cpus: the temp variable for the new effective_cpus mask
  *
  * Iterate through each task of @cs updating its cpus_allowed to the
  * effective cpuset's.  As this function is called with cpuset_rwsem held,
  * cpuset membership stays stable.
  */
-static void update_tasks_cpumask(struct cpuset *cs)
+static void update_tasks_cpumask(struct cpuset *cs, struct cpumask *new_cpus)
 {
 	struct css_task_iter it;
 	struct task_struct *task;
@@ -1220,7 +1221,10 @@ static void update_tasks_cpumask(struct cpuset *cs)
 		if (top_cs && (task->flags & PF_KTHREAD) &&
 		    kthread_is_per_cpu(task))
 			continue;
-		set_cpus_allowed_ptr(task, cs->effective_cpus);
+
+		cpumask_and(new_cpus, cs->effective_cpus,
+			    task_cpu_possible_mask(task));
+		set_cpus_allowed_ptr(task, new_cpus);
 	}
 	css_task_iter_end(&it);
 }
@@ -1505,7 +1509,7 @@ static int update_parent_subparts_cpumask(struct cpuset *cs, int cmd,
 	spin_unlock_irq(&callback_lock);
 
 	if (adding || deleting)
-		update_tasks_cpumask(parent);
+		update_tasks_cpumask(parent, tmp->new_cpus);
 
 	/*
 	 * Set or clear CS_SCHED_LOAD_BALANCE when partcmd_update, if necessary.
@@ -1657,7 +1661,7 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp,
 		WARN_ON(!is_in_v2_mode() &&
 			!cpumask_equal(cp->cpus_allowed, cp->effective_cpus));
 
-		update_tasks_cpumask(cp);
+		update_tasks_cpumask(cp, tmp->new_cpus);
 
 		/*
 		 * On legacy hierarchy, if the effective cpumask of any non-
@@ -2305,7 +2309,7 @@ static int update_prstate(struct cpuset *cs, int new_prs)
 		}
 	}
 
-	update_tasks_cpumask(parent);
+	update_tasks_cpumask(parent, tmpmask.new_cpus);
 
 	if (parent->child_ecpus_count)
 		update_sibling_cpumasks(parent, cs, &tmpmask);
@@ -3318,7 +3322,7 @@ hotplug_update_tasks_legacy(struct cpuset *cs,
 	 * as the tasks will be migrated to an ancestor.
 	 */
 	if (cpus_updated && !cpumask_empty(cs->cpus_allowed))
-		update_tasks_cpumask(cs);
+		update_tasks_cpumask(cs, new_cpus);
 	if (mems_updated && !nodes_empty(cs->mems_allowed))
 		update_tasks_nodemask(cs);
 
@@ -3355,7 +3359,7 @@ hotplug_update_tasks(struct cpuset *cs,
 	spin_unlock_irq(&callback_lock);
 
 	if (cpus_updated)
-		update_tasks_cpumask(cs);
+		update_tasks_cpumask(cs, new_cpus);
 	if (mems_updated)
 		update_tasks_nodemask(cs);
 }
-- 
2.39.0



