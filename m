Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 532BE6E643D
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232002AbjDRMre (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:47:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232032AbjDRMrd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:47:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 698B01AD
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:47:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 45FB5633C0
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:47:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54C02C433EF;
        Tue, 18 Apr 2023 12:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681822040;
        bh=J8YeN0bcBGEjJ6rHDyK0jy1pVR8/z16ShKP8VJjOY4k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iqcpfuHB6JaSLuABudhDnK2xeobKLtqsW1soAs48cHY0Cyg7KzL4w20x/QnYyWlWl
         VWcS/xcK7wzojso1QLllfAv/xOavjtAqK2eL4IgUUEgc1PH0bnjgtZ81pwMgP+3gNQ
         WXNpC09YqMoccGYnwia/IADeTsAaaY7ElhnNHk9U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
        Waiman Long <longman@redhat.com>, Tejun Heo <tj@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 134/134] cgroup/cpuset: Add cpuset_can_fork() and cpuset_cancel_fork() methods
Date:   Tue, 18 Apr 2023 14:23:10 +0200
Message-Id: <20230418120317.838740115@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.001025904@linuxfoundation.org>
References: <20230418120313.001025904@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Waiman Long <longman@redhat.com>

[ Upstream commit eee87853794187f6adbe19533ed79c8b44b36a91 ]

In the case of CLONE_INTO_CGROUP, not all cpusets are ready to accept
new tasks. It is too late to check that in cpuset_fork(). So we need
to add the cpuset_can_fork() and cpuset_cancel_fork() methods to
pre-check it before we can allow attachment to a different cpuset.

We also need to set the attach_in_progress flag to alert other code
that a new task is going to be added to the cpuset.

Fixes: ef2c41cf38a7 ("clone3: allow spawning processes into cgroups")
Suggested-by: Michal Koutný <mkoutny@suse.com>
Signed-off-by: Waiman Long <longman@redhat.com>
Cc: stable@vger.kernel.org # v5.7+
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cpuset.c | 97 +++++++++++++++++++++++++++++++++++++-----
 1 file changed, 86 insertions(+), 11 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 85f071fb1a414..e276db7228451 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2453,6 +2453,20 @@ static int fmeter_getrate(struct fmeter *fmp)
 
 static struct cpuset *cpuset_attach_old_cs;
 
+/*
+ * Check to see if a cpuset can accept a new task
+ * For v1, cpus_allowed and mems_allowed can't be empty.
+ * For v2, effective_cpus can't be empty.
+ * Note that in v1, effective_cpus = cpus_allowed.
+ */
+static int cpuset_can_attach_check(struct cpuset *cs)
+{
+	if (cpumask_empty(cs->effective_cpus) ||
+	   (!is_in_v2_mode() && nodes_empty(cs->mems_allowed)))
+		return -ENOSPC;
+	return 0;
+}
+
 /* Called by cgroups to determine if a cpuset is usable; cpuset_rwsem held */
 static int cpuset_can_attach(struct cgroup_taskset *tset)
 {
@@ -2467,16 +2481,9 @@ static int cpuset_can_attach(struct cgroup_taskset *tset)
 
 	percpu_down_write(&cpuset_rwsem);
 
-	/* allow moving tasks into an empty cpuset if on default hierarchy */
-	ret = -ENOSPC;
-	if (!is_in_v2_mode() &&
-	    (cpumask_empty(cs->cpus_allowed) || nodes_empty(cs->mems_allowed)))
-		goto out_unlock;
-
-	/*
-	 * Task cannot be moved to a cpuset with empty effective cpus.
-	 */
-	if (cpumask_empty(cs->effective_cpus))
+	/* Check to see if task is allowed in the cpuset */
+	ret = cpuset_can_attach_check(cs);
+	if (ret)
 		goto out_unlock;
 
 	cgroup_taskset_for_each(task, css, tset) {
@@ -2493,7 +2500,6 @@ static int cpuset_can_attach(struct cgroup_taskset *tset)
 	 * changes which zero cpus/mems_allowed.
 	 */
 	cs->attach_in_progress++;
-	ret = 0;
 out_unlock:
 	percpu_up_write(&cpuset_rwsem);
 	return ret;
@@ -3238,6 +3244,68 @@ static void cpuset_bind(struct cgroup_subsys_state *root_css)
 	percpu_up_write(&cpuset_rwsem);
 }
 
+/*
+ * In case the child is cloned into a cpuset different from its parent,
+ * additional checks are done to see if the move is allowed.
+ */
+static int cpuset_can_fork(struct task_struct *task, struct css_set *cset)
+{
+	struct cpuset *cs = css_cs(cset->subsys[cpuset_cgrp_id]);
+	bool same_cs;
+	int ret;
+
+	rcu_read_lock();
+	same_cs = (cs == task_cs(current));
+	rcu_read_unlock();
+
+	if (same_cs)
+		return 0;
+
+	lockdep_assert_held(&cgroup_mutex);
+	percpu_down_write(&cpuset_rwsem);
+
+	/* Check to see if task is allowed in the cpuset */
+	ret = cpuset_can_attach_check(cs);
+	if (ret)
+		goto out_unlock;
+
+	ret = task_can_attach(task, cs->effective_cpus);
+	if (ret)
+		goto out_unlock;
+
+	ret = security_task_setscheduler(task);
+	if (ret)
+		goto out_unlock;
+
+	/*
+	 * Mark attach is in progress.  This makes validate_change() fail
+	 * changes which zero cpus/mems_allowed.
+	 */
+	cs->attach_in_progress++;
+out_unlock:
+	percpu_up_write(&cpuset_rwsem);
+	return ret;
+}
+
+static void cpuset_cancel_fork(struct task_struct *task, struct css_set *cset)
+{
+	struct cpuset *cs = css_cs(cset->subsys[cpuset_cgrp_id]);
+	bool same_cs;
+
+	rcu_read_lock();
+	same_cs = (cs == task_cs(current));
+	rcu_read_unlock();
+
+	if (same_cs)
+		return;
+
+	percpu_down_write(&cpuset_rwsem);
+	cs->attach_in_progress--;
+	if (!cs->attach_in_progress)
+		wake_up(&cpuset_attach_wq);
+	percpu_up_write(&cpuset_rwsem);
+}
+
 /*
  * Make sure the new task conform to the current state of its parent,
  * which could have been changed by cpuset just after it inherits the
@@ -3266,6 +3334,11 @@ static void cpuset_fork(struct task_struct *task)
 	percpu_down_write(&cpuset_rwsem);
 	guarantee_online_mems(cs, &cpuset_attach_nodemask_to);
 	cpuset_attach_task(cs, task);
+
+	cs->attach_in_progress--;
+	if (!cs->attach_in_progress)
+		wake_up(&cpuset_attach_wq);
+
 	percpu_up_write(&cpuset_rwsem);
 }
 
@@ -3279,6 +3352,8 @@ struct cgroup_subsys cpuset_cgrp_subsys = {
 	.attach		= cpuset_attach,
 	.post_attach	= cpuset_post_attach,
 	.bind		= cpuset_bind,
+	.can_fork	= cpuset_can_fork,
+	.cancel_fork	= cpuset_cancel_fork,
 	.fork		= cpuset_fork,
 	.legacy_cftypes	= legacy_files,
 	.dfl_cftypes	= dfl_files,
-- 
2.39.2



