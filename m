Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D1C86E4C60
	for <lists+stable@lfdr.de>; Mon, 17 Apr 2023 17:07:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbjDQPHi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Apr 2023 11:07:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjDQPHh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Apr 2023 11:07:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B1EF1A8
        for <stable@vger.kernel.org>; Mon, 17 Apr 2023 08:06:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681744010;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UMbmur5ko65WD26mT375om7vZ5XMxeLdPZUoxa4yE7A=;
        b=R6qLo+5hGrwDUaPEGCq4hmeml2HVgw8DW1zdExe93v227gRd9+s350b7xljRKo6Vy+QU+P
        9oOy7XzSqjR2hu2+8HyJ52uWbt/gNrYcXGJXFT9+b9FTk7peDnuLdz1uUT0BxtjJqqhKvO
        lsyeYpqJnZezBQwYdXVFlPEMy6+uhm0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-325-keM1FA-XP0OLIrlP8tqA0Q-1; Mon, 17 Apr 2023 11:06:45 -0400
X-MC-Unique: keM1FA-XP0OLIrlP8tqA0Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8D4FC80D092;
        Mon, 17 Apr 2023 15:06:44 +0000 (UTC)
Received: from llong.com (dhcp-17-153.bos.redhat.com [10.18.17.153])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5B0B440CE2D4;
        Mon, 17 Apr 2023 15:06:44 +0000 (UTC)
From:   Waiman Long <longman@redhat.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     Tejun Heo <tj@kernel.org>,
        =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Waiman Long <longman@redhat.com>
Subject: [PATCH 6.1 2/3] cgroup/cpuset: Make cpuset_fork() handle CLONE_INTO_CGROUP properly
Date:   Mon, 17 Apr 2023 11:06:29 -0400
Message-Id: <20230417150630.3369187-2-longman@redhat.com>
In-Reply-To: <20230417150630.3369187-1-longman@redhat.com>
References: <20230417150630.3369187-1-longman@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 42a11bf5c5436e91b040aeb04063be1710bb9f9c upstream.

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
---
 kernel/cgroup/cpuset.c | 62 ++++++++++++++++++++++++++++--------------
 1 file changed, 42 insertions(+), 20 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 7c418ce4d3c9..6a5c2318df5b 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2503,16 +2503,33 @@ static void cpuset_cancel_attach(struct cgroup_taskset *tset)
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
@@ -2527,20 +2544,8 @@ static void cpuset_attach(struct cgroup_taskset *tset)
 
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
@@ -3228,11 +3233,28 @@ static void cpuset_bind(struct cgroup_subsys_state *root_css)
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
2.31.1

