Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2DA55B707B
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233837AbiIMO34 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:29:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234037AbiIMO3B (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:29:01 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 511F719C3C;
        Tue, 13 Sep 2022 07:18:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 982D7CE1276;
        Tue, 13 Sep 2022 14:18:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3D08C433D7;
        Tue, 13 Sep 2022 14:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078695;
        bh=A0qsj/Cg5UZo4oF1sBCD9D5O52VzN+ufFhFreEkRo7E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x00/QEdNFQM51byo2m8Jw/ZNcHgbgksaErrnXJQSAv6UNX+LS8DRH0mS5nIe+WvHN
         2SuxmUBVHLKB2dGbhCNfMdN6aua0Uqv/CAa5CgIS6LedpfbsWP8sp5+933ylZv8jdp
         ELsAuUCTaz9A7sP0743tNzOxllpQaq0ySH+PuHPk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Imran Khan <imran.f.khan@oracle.com>,
        Xuewen Yan <xuewen.yan@unisoc.com>
Subject: [PATCH 5.15 047/121] cgroup: Fix threadgroup_rwsem <-> cpus_read_lock() deadlock
Date:   Tue, 13 Sep 2022 16:03:58 +0200
Message-Id: <20220913140359.383124989@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140357.323297659@linuxfoundation.org>
References: <20220913140357.323297659@linuxfoundation.org>
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
 kernel/cgroup/cgroup.c | 77 +++++++++++++++++++++++++++++-------------
 kernel/cgroup/cpuset.c |  3 +-
 2 files changed, 55 insertions(+), 25 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index baebd1c7667b7..75c3881af0784 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -2345,6 +2345,47 @@ int task_cgroup_path(struct task_struct *task, char *buf, size_t buflen)
 }
 EXPORT_SYMBOL_GPL(task_cgroup_path);
 
+/**
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
 /**
  * cgroup_migrate_add_task - add a migration target task to a migration context
  * @task: target task
@@ -2821,8 +2862,7 @@ int cgroup_attach_task(struct cgroup *dst_cgrp, struct task_struct *leader,
 }
 
 struct task_struct *cgroup_procs_write_start(char *buf, bool threadgroup,
-					     bool *locked)
-	__acquires(&cgroup_threadgroup_rwsem)
+					     bool *threadgroup_locked)
 {
 	struct task_struct *tsk;
 	pid_t pid;
@@ -2839,12 +2879,8 @@ struct task_struct *cgroup_procs_write_start(char *buf, bool threadgroup,
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
@@ -2875,17 +2911,14 @@ struct task_struct *cgroup_procs_write_start(char *buf, bool threadgroup,
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
@@ -2893,8 +2926,8 @@ void cgroup_procs_write_finish(struct task_struct *task, bool locked)
 	/* release reference from cgroup_procs_write_start() */
 	put_task_struct(task);
 
-	if (locked)
-		percpu_up_write(&cgroup_threadgroup_rwsem);
+	cgroup_attach_unlock(threadgroup_locked);
+
 	for_each_subsys(ss, ssid)
 		if (ss->post_attach)
 			ss->post_attach();
@@ -2971,8 +3004,7 @@ static int cgroup_update_dfl_csses(struct cgroup *cgrp)
 	 * write-locking can be skipped safely.
 	 */
 	has_tasks = !list_empty(&mgctx.preloaded_src_csets);
-	if (has_tasks)
-		percpu_down_write(&cgroup_threadgroup_rwsem);
+	cgroup_attach_lock(has_tasks);
 
 	/* NULL dst indicates self on default hierarchy */
 	ret = cgroup_migrate_prepare_dst(&mgctx);
@@ -2993,8 +3025,7 @@ static int cgroup_update_dfl_csses(struct cgroup *cgrp)
 	ret = cgroup_migrate_execute(&mgctx);
 out_finish:
 	cgroup_migrate_finish(&mgctx);
-	if (has_tasks)
-		percpu_up_write(&cgroup_threadgroup_rwsem);
+	cgroup_attach_unlock(has_tasks);
 	return ret;
 }
 
@@ -4942,13 +4973,13 @@ static ssize_t __cgroup_procs_write(struct kernfs_open_file *of, char *buf,
 	struct task_struct *task;
 	const struct cred *saved_cred;
 	ssize_t ret;
-	bool locked;
+	bool threadgroup_locked;
 
 	dst_cgrp = cgroup_kn_lock_live(of->kn, false);
 	if (!dst_cgrp)
 		return -ENODEV;
 
-	task = cgroup_procs_write_start(buf, threadgroup, &locked);
+	task = cgroup_procs_write_start(buf, threadgroup, &threadgroup_locked);
 	ret = PTR_ERR_OR_ZERO(task);
 	if (ret)
 		goto out_unlock;
@@ -4974,7 +5005,7 @@ static ssize_t __cgroup_procs_write(struct kernfs_open_file *of, char *buf,
 	ret = cgroup_attach_task(dst_cgrp, task, threadgroup);
 
 out_finish:
-	cgroup_procs_write_finish(task, locked);
+	cgroup_procs_write_finish(task, threadgroup_locked);
 out_unlock:
 	cgroup_kn_unlock(of->kn);
 
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 9c5b659db63f4..3213d3c8ea0a8 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2249,7 +2249,7 @@ static void cpuset_attach(struct cgroup_taskset *tset)
 	cgroup_taskset_first(tset, &css);
 	cs = css_cs(css);
 
-	cpus_read_lock();
+	lockdep_assert_cpus_held();	/* see cgroup_attach_lock() */
 	percpu_down_write(&cpuset_rwsem);
 
 	guarantee_online_mems(cs, &cpuset_attach_nodemask_to);
@@ -2303,7 +2303,6 @@ static void cpuset_attach(struct cgroup_taskset *tset)
 		wake_up(&cpuset_attach_wq);
 
 	percpu_up_write(&cpuset_rwsem);
-	cpus_read_unlock();
 }
 
 /* The various types of files and directories in a cpuset file system */
-- 
2.35.1



