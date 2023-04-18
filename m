Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92E596E643C
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232033AbjDRMrd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:47:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232002AbjDRMrc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:47:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E4B86A4E
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:47:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F511633C5
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:47:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B20BEC433EF;
        Tue, 18 Apr 2023 12:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681822038;
        bh=BsCfp74AGdXgZ/qhpWgg5qXAIsy0A35s6k5zs29Wwn8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ltVNKQqocK9/qr2dHZo4+6s+4ci6J2gYgIEWuuNPTM2arzfXTpdHxX9eYT/1Gr6uD
         TPrlcpz7nRz7/VVjg+HO2OSO1c43Mu/jN2KrMwgom8jIfcUsXflYYrSJI1h1WWPeZ4
         zFCfa55YVZCgEAs/aPAGLYpKy7Yd4vtiozIqMpC8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Giuseppe Scrivano <gscrivan@redhat.com>,
        Waiman Long <longman@redhat.com>, Tejun Heo <tj@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 133/134] cgroup/cpuset: Make cpuset_fork() handle CLONE_INTO_CGROUP properly
Date:   Tue, 18 Apr 2023 14:23:09 +0200
Message-Id: <20230418120317.802543750@linuxfoundation.org>
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

[ Upstream commit 42a11bf5c5436e91b040aeb04063be1710bb9f9c ]

By default, the clone(2) syscall spawn a child process into the same
cgroup as its parent. With the use of the CLONE_INTO_CGROUP flag
introduced by commit ef2c41cf38a7 ("clone3: allow spawning processes
into cgroups"), the child will be spawned into a different cgroup which
is somewhat similar to writing the child's tid into "cgroup.threads".

The current cpuset_fork() method does not properly handle the
CLONE_INTO_CGROUP case where the cpuset of the child may be different
from that of its parent.  Update the cpuset_fork() method to treat the
CLONE_INTO_CGROUP case similar to cpuset_attach().

Since the newly cloned task has not been running yet, its actual
memory usage isn't known. So it is not necessary to make change to mm
in cpuset_fork().

Fixes: ef2c41cf38a7 ("clone3: allow spawning processes into cgroups")
Reported-by: Giuseppe Scrivano <gscrivan@redhat.com>
Signed-off-by: Waiman Long <longman@redhat.com>
Cc: stable@vger.kernel.org # v5.7+
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cpuset.c | 62 ++++++++++++++++++++++++++++--------------
 1 file changed, 42 insertions(+), 20 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 1c549452c4abb..85f071fb1a414 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2515,16 +2515,33 @@ static void cpuset_cancel_attach(struct cgroup_taskset *tset)
 }
 
 /*
- * Protected by cpuset_rwsem.  cpus_attach is used only by cpuset_attach()
+ * Protected by cpuset_rwsem. cpus_attach is used only by cpuset_attach_task()
  * but we can't allocate it dynamically there.  Define it global and
  * allocate from cpuset_init().
  */
 static cpumask_var_t cpus_attach;
+static nodemask_t cpuset_attach_nodemask_to;
+
+static void cpuset_attach_task(struct cpuset *cs, struct task_struct *task)
+{
+	percpu_rwsem_assert_held(&cpuset_rwsem);
+
+	if (cs != &top_cpuset)
+		guarantee_online_cpus(task, cpus_attach);
+	else
+		cpumask_copy(cpus_attach, task_cpu_possible_mask(task));
+	/*
+	 * can_attach beforehand should guarantee that this doesn't
+	 * fail.  TODO: have a better way to handle failure here
+	 */
+	WARN_ON_ONCE(set_cpus_allowed_ptr(task, cpus_attach));
+
+	cpuset_change_task_nodemask(task, &cpuset_attach_nodemask_to);
+	cpuset_update_task_spread_flags(cs, task);
+}
 
 static void cpuset_attach(struct cgroup_taskset *tset)
 {
-	/* static buf protected by cpuset_rwsem */
-	static nodemask_t cpuset_attach_nodemask_to;
 	struct task_struct *task;
 	struct task_struct *leader;
 	struct cgroup_subsys_state *css;
@@ -2539,20 +2556,8 @@ static void cpuset_attach(struct cgroup_taskset *tset)
 
 	guarantee_online_mems(cs, &cpuset_attach_nodemask_to);
 
-	cgroup_taskset_for_each(task, css, tset) {
-		if (cs != &top_cpuset)
-			guarantee_online_cpus(task, cpus_attach);
-		else
-			cpumask_copy(cpus_attach, task_cpu_possible_mask(task));
-		/*
-		 * can_attach beforehand should guarantee that this doesn't
-		 * fail.  TODO: have a better way to handle failure here
-		 */
-		WARN_ON_ONCE(set_cpus_allowed_ptr(task, cpus_attach));
-
-		cpuset_change_task_nodemask(task, &cpuset_attach_nodemask_to);
-		cpuset_update_task_spread_flags(cs, task);
-	}
+	cgroup_taskset_for_each(task, css, tset)
+		cpuset_attach_task(cs, task);
 
 	/*
 	 * Change mm for all threadgroup leaders. This is expensive and may
@@ -3240,11 +3245,28 @@ static void cpuset_bind(struct cgroup_subsys_state *root_css)
  */
 static void cpuset_fork(struct task_struct *task)
 {
-	if (task_css_is_root(task, cpuset_cgrp_id))
+	struct cpuset *cs;
+	bool same_cs;
+
+	rcu_read_lock();
+	cs = task_cs(task);
+	same_cs = (cs == task_cs(current));
+	rcu_read_unlock();
+
+	if (same_cs) {
+		if (cs == &top_cpuset)
+			return;
+
+		set_cpus_allowed_ptr(task, current->cpus_ptr);
+		task->mems_allowed = current->mems_allowed;
 		return;
+	}
 
-	set_cpus_allowed_ptr(task, current->cpus_ptr);
-	task->mems_allowed = current->mems_allowed;
+	/* CLONE_INTO_CGROUP */
+	percpu_down_write(&cpuset_rwsem);
+	guarantee_online_mems(cs, &cpuset_attach_nodemask_to);
+	cpuset_attach_task(cs, task);
+	percpu_up_write(&cpuset_rwsem);
 }
 
 struct cgroup_subsys cpuset_cgrp_subsys = {
-- 
2.39.2



