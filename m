Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEEA65B7334
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 17:05:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234915AbiIMPEy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 11:04:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235281AbiIMPD5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 11:03:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60D9427CEF;
        Tue, 13 Sep 2022 07:29:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 81647B80F62;
        Tue, 13 Sep 2022 14:29:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF4E9C433D6;
        Tue, 13 Sep 2022 14:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663079379;
        bh=wrCLvSaAPaEWFtV09hkme+TgSL67YREqg4eTQhNtS8M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SLIJcjReA2iYbH3Y8M5gqRiKDwJmj0w5nIpjYLMQT1PieGBYM6gK/mT24FIX49nRC
         Hf1kVrgiOps1RhRLauUrJ04iwc3n6aPv04CCrt8d7ppn12uqoSIctiIqmUDzttmVhl
         xjI/ixKZ3fR3Is7SQNAkkxizq+F5sLLvnC4oZehE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Imran Khan <imran.f.khan@oracle.com>,
        Xuewen Yan <xuewen.yan@unisoc.com>
Subject: [PATCH 5.4 087/108] cgroup: Fix threadgroup_rwsem <-> cpus_read_lock() deadlock
Date:   Tue, 13 Sep 2022 16:06:58 +0200
Message-Id: <20220913140357.359330349@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140353.549108748@linuxfoundation.org>
References: <20220913140353.549108748@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tejun Heo <tj@kernel.org>

[ Upstream commit 4f7e7236435ca0abe005c674ebd6892c6e83aeb3 ]

Bringing up a CPU may involve creating and destroying tasks which requires
read-locking threadgroup_rwsem, so threadgroup_rwsem nests inside
cpus_read_lock(). However, cpuset's ->attach(), which may be called with
thredagroup_rwsem write-locked, also wants to disable CPU hotplug and
acquires cpus_read_lock(), leading to a deadlock.

Fix it by guaranteeing that ->attach() is always called with CPU hotplug
disabled and removing cpus_read_lock() call from cpuset_attach().

Signed-off-by: Tejun Heo <tj@kernel.org>
Reviewed-and-tested-by: Imran Khan <imran.f.khan@oracle.com>
Reported-and-tested-by: Xuewen Yan <xuewen.yan@unisoc.com>
Fixes: 05c7b7a92cc8 ("cgroup/cpuset: Fix a race between cpuset_attach() and cpu hotplug")
Cc: stable@vger.kernel.org # v5.17+
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cgroup.c |   78 ++++++++++++++++++++++++++++++++++---------------
 kernel/cgroup/cpuset.c |    3 -
 2 files changed, 56 insertions(+), 25 deletions(-)

--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -30,6 +30,7 @@
 
 #include "cgroup-internal.h"
 
+#include <linux/cpu.h>
 #include <linux/cred.h>
 #include <linux/errno.h>
 #include <linux/init_task.h>
@@ -2377,6 +2378,47 @@ int task_cgroup_path(struct task_struct
 EXPORT_SYMBOL_GPL(task_cgroup_path);
 
 /**
+ * cgroup_attach_lock - Lock for ->attach()
+ * @lock_threadgroup: whether to down_write cgroup_threadgroup_rwsem
+ *
+ * cgroup migration sometimes needs to stabilize threadgroups against forks and
+ * exits by write-locking cgroup_threadgroup_rwsem. However, some ->attach()
+ * implementations (e.g. cpuset), also need to disable CPU hotplug.
+ * Unfortunately, letting ->attach() operations acquire cpus_read_lock() can
+ * lead to deadlocks.
+ *
+ * Bringing up a CPU may involve creating and destroying tasks which requires
+ * read-locking threadgroup_rwsem, so threadgroup_rwsem nests inside
+ * cpus_read_lock(). If we call an ->attach() which acquires the cpus lock while
+ * write-locking threadgroup_rwsem, the locking order is reversed and we end up
+ * waiting for an on-going CPU hotplug operation which in turn is waiting for
+ * the threadgroup_rwsem to be released to create new tasks. For more details:
+ *
+ *   http://lkml.kernel.org/r/20220711174629.uehfmqegcwn2lqzu@wubuntu
+ *
+ * Resolve the situation by always acquiring cpus_read_lock() before optionally
+ * write-locking cgroup_threadgroup_rwsem. This allows ->attach() to assume that
+ * CPU hotplug is disabled on entry.
+ */
+static void cgroup_attach_lock(bool lock_threadgroup)
+{
+	cpus_read_lock();
+	if (lock_threadgroup)
+		percpu_down_write(&cgroup_threadgroup_rwsem);
+}
+
+/**
+ * cgroup_attach_unlock - Undo cgroup_attach_lock()
+ * @lock_threadgroup: whether to up_write cgroup_threadgroup_rwsem
+ */
+static void cgroup_attach_unlock(bool lock_threadgroup)
+{
+	if (lock_threadgroup)
+		percpu_up_write(&cgroup_threadgroup_rwsem);
+	cpus_read_unlock();
+}
+
+/**
  * cgroup_migrate_add_task - add a migration target task to a migration context
  * @task: target task
  * @mgctx: target migration context
@@ -2857,8 +2899,7 @@ int cgroup_attach_task(struct cgroup *ds
 }
 
 struct task_struct *cgroup_procs_write_start(char *buf, bool threadgroup,
-					     bool *locked)
-	__acquires(&cgroup_threadgroup_rwsem)
+					     bool *threadgroup_locked)
 {
 	struct task_struct *tsk;
 	pid_t pid;
@@ -2875,12 +2916,8 @@ struct task_struct *cgroup_procs_write_s
 	 * Therefore, we can skip the global lock.
 	 */
 	lockdep_assert_held(&cgroup_mutex);
-	if (pid || threadgroup) {
-		percpu_down_write(&cgroup_threadgroup_rwsem);
-		*locked = true;
-	} else {
-		*locked = false;
-	}
+	*threadgroup_locked = pid || threadgroup;
+	cgroup_attach_lock(*threadgroup_locked);
 
 	rcu_read_lock();
 	if (pid) {
@@ -2911,17 +2948,14 @@ struct task_struct *cgroup_procs_write_s
 	goto out_unlock_rcu;
 
 out_unlock_threadgroup:
-	if (*locked) {
-		percpu_up_write(&cgroup_threadgroup_rwsem);
-		*locked = false;
-	}
+	cgroup_attach_unlock(*threadgroup_locked);
+	*threadgroup_locked = false;
 out_unlock_rcu:
 	rcu_read_unlock();
 	return tsk;
 }
 
-void cgroup_procs_write_finish(struct task_struct *task, bool locked)
-	__releases(&cgroup_threadgroup_rwsem)
+void cgroup_procs_write_finish(struct task_struct *task, bool threadgroup_locked)
 {
 	struct cgroup_subsys *ss;
 	int ssid;
@@ -2929,8 +2963,8 @@ void cgroup_procs_write_finish(struct ta
 	/* release reference from cgroup_procs_write_start() */
 	put_task_struct(task);
 
-	if (locked)
-		percpu_up_write(&cgroup_threadgroup_rwsem);
+	cgroup_attach_unlock(threadgroup_locked);
+
 	for_each_subsys(ss, ssid)
 		if (ss->post_attach)
 			ss->post_attach();
@@ -3007,8 +3041,7 @@ static int cgroup_update_dfl_csses(struc
 	 * write-locking can be skipped safely.
 	 */
 	has_tasks = !list_empty(&mgctx.preloaded_src_csets);
-	if (has_tasks)
-		percpu_down_write(&cgroup_threadgroup_rwsem);
+	cgroup_attach_lock(has_tasks);
 
 	/* NULL dst indicates self on default hierarchy */
 	ret = cgroup_migrate_prepare_dst(&mgctx);
@@ -3029,8 +3062,7 @@ static int cgroup_update_dfl_csses(struc
 	ret = cgroup_migrate_execute(&mgctx);
 out_finish:
 	cgroup_migrate_finish(&mgctx);
-	if (has_tasks)
-		percpu_up_write(&cgroup_threadgroup_rwsem);
+	cgroup_attach_unlock(has_tasks);
 	return ret;
 }
 
@@ -4859,13 +4891,13 @@ static ssize_t cgroup_procs_write(struct
 	struct task_struct *task;
 	const struct cred *saved_cred;
 	ssize_t ret;
-	bool locked;
+	bool threadgroup_locked;
 
 	dst_cgrp = cgroup_kn_lock_live(of->kn, false);
 	if (!dst_cgrp)
 		return -ENODEV;
 
-	task = cgroup_procs_write_start(buf, true, &locked);
+	task = cgroup_procs_write_start(buf, true, &threadgroup_locked);
 	ret = PTR_ERR_OR_ZERO(task);
 	if (ret)
 		goto out_unlock;
@@ -4891,7 +4923,7 @@ static ssize_t cgroup_procs_write(struct
 	ret = cgroup_attach_task(dst_cgrp, task, true);
 
 out_finish:
-	cgroup_procs_write_finish(task, locked);
+	cgroup_procs_write_finish(task, threadgroup_locked);
 out_unlock:
 	cgroup_kn_unlock(of->kn);
 
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2204,7 +2204,7 @@ static void cpuset_attach(struct cgroup_
 	cgroup_taskset_first(tset, &css);
 	cs = css_cs(css);
 
-	cpus_read_lock();
+	lockdep_assert_cpus_held();	/* see cgroup_attach_lock() */
 	percpu_down_write(&cpuset_rwsem);
 
 	/* prepare for attach */
@@ -2260,7 +2260,6 @@ static void cpuset_attach(struct cgroup_
 		wake_up(&cpuset_attach_wq);
 
 	percpu_up_write(&cpuset_rwsem);
-	cpus_read_unlock();
 }
 
 /* The various types of files and directories in a cpuset file system */


