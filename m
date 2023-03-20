Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AA326C0880
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 02:29:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbjCTB3n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Mar 2023 21:29:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbjCTB3U (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Mar 2023 21:29:20 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C36F7FF18;
        Sun, 19 Mar 2023 18:21:56 -0700 (PDT)
Received: from kwepemi500024.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Pfxg647x4znYTy;
        Mon, 20 Mar 2023 09:17:38 +0800 (CST)
Received: from ci.huawei.com (10.67.175.89) by kwepemi500024.china.huawei.com
 (7.221.188.100) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21; Mon, 20 Mar
 2023 09:20:42 +0800
From:   Cai Xinchen <caixinchen1@huawei.com>
To:     <longman@redhat.com>, <lizefan.x@bytedance.com>, <tj@kernel.org>,
        <hannes@cmpxchg.org>, <gregkh@linuxfoundation.org>,
        <sashal@kernel.org>
CC:     <mkoutny@suse.com>, <zhangqiao22@huawei.com>,
        <juri.lelli@redhat.com>, <penguin-kernel@I-love.SAKURA.ne.jp>,
        <stable@vger.kernel.org>, <cgroups@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 4.19 2/3] cgroup: Fix threadgroup_rwsem <-> cpus_read_lock() deadlock
Date:   Mon, 20 Mar 2023 01:15:06 +0000
Message-ID: <20230320011507.129441-3-caixinchen1@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230320011507.129441-1-caixinchen1@huawei.com>
References: <20230320011507.129441-1-caixinchen1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.175.89]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemi500024.china.huawei.com (7.221.188.100)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tejun Heo <tj@kernel.org>

commit 4f7e7236435ca0abe005c674ebd6892c6e83aeb3 upstream.

Add #include <linux/cpu.h> to avoid compile error on some architectures.

commit 9a3284fad42f6 ("cgroup: Optimize single thread migration") and
commit 671c11f0619e5 ("cgroup: Elide write-locking threadgroup_rwsem
when updating csses on an empty subtree") are not backport. So ignore the
input parameter of cgroup_attach_lock/cgroup_attach_unlock.

original commit message:

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
Signed-off-by: Cai Xinchen <caixinchen1@huawei.com>
---
v2:
 - Add #include <linux/cpu.h> in kernel/cgroup/cgroup.c to avoid compile
   error on some architectures
---
 kernel/cgroup/cgroup.c | 50 +++++++++++++++++++++++++++++++++++++-----
 kernel/cgroup/cpuset.c |  7 +-----
 2 files changed, 46 insertions(+), 11 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index a892a99eb4bf..a8185cdb8587 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -55,6 +55,7 @@
 #include <linux/nsproxy.h>
 #include <linux/file.h>
 #include <linux/sched/cputime.h>
+#include <linux/cpu.h>
 #include <net/sock.h>
 
 #define CREATE_TRACE_POINTS
@@ -2209,6 +2210,45 @@ int task_cgroup_path(struct task_struct *task, char *buf, size_t buflen)
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
+static void cgroup_attach_lock(void)
+{
+	get_online_cpus();
+	percpu_down_write(&cgroup_threadgroup_rwsem);
+}
+
+/**
+ * cgroup_attach_unlock - Undo cgroup_attach_lock()
+ * @lock_threadgroup: whether to up_write cgroup_threadgroup_rwsem
+ */
+static void cgroup_attach_unlock(void)
+{
+	percpu_up_write(&cgroup_threadgroup_rwsem);
+	put_online_cpus();
+}
+
 /**
  * cgroup_migrate_add_task - add a migration target task to a migration context
  * @task: target task
@@ -2694,7 +2734,7 @@ struct task_struct *cgroup_procs_write_start(char *buf, bool threadgroup)
 	if (kstrtoint(strstrip(buf), 0, &pid) || pid < 0)
 		return ERR_PTR(-EINVAL);
 
-	percpu_down_write(&cgroup_threadgroup_rwsem);
+	cgroup_attach_lock();
 
 	rcu_read_lock();
 	if (pid) {
@@ -2725,7 +2765,7 @@ struct task_struct *cgroup_procs_write_start(char *buf, bool threadgroup)
 	goto out_unlock_rcu;
 
 out_unlock_threadgroup:
-	percpu_up_write(&cgroup_threadgroup_rwsem);
+	cgroup_attach_unlock();
 out_unlock_rcu:
 	rcu_read_unlock();
 	return tsk;
@@ -2740,7 +2780,7 @@ void cgroup_procs_write_finish(struct task_struct *task)
 	/* release reference from cgroup_procs_write_start() */
 	put_task_struct(task);
 
-	percpu_up_write(&cgroup_threadgroup_rwsem);
+	cgroup_attach_unlock();
 	for_each_subsys(ss, ssid)
 		if (ss->post_attach)
 			ss->post_attach();
@@ -2799,7 +2839,7 @@ static int cgroup_update_dfl_csses(struct cgroup *cgrp)
 
 	lockdep_assert_held(&cgroup_mutex);
 
-	percpu_down_write(&cgroup_threadgroup_rwsem);
+	cgroup_attach_lock();
 
 	/* look up all csses currently attached to @cgrp's subtree */
 	spin_lock_irq(&css_set_lock);
@@ -2830,7 +2870,7 @@ static int cgroup_update_dfl_csses(struct cgroup *cgrp)
 	ret = cgroup_migrate_execute(&mgctx);
 out_finish:
 	cgroup_migrate_finish(&mgctx);
-	percpu_up_write(&cgroup_threadgroup_rwsem);
+	cgroup_attach_unlock();
 	return ret;
 }
 
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 7169e47fb48b..c6d412cebc43 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1528,11 +1528,7 @@ static void cpuset_attach(struct cgroup_taskset *tset)
 	cgroup_taskset_first(tset, &css);
 	cs = css_cs(css);
 
-	/*
-	 * It should hold cpus lock because a cpu offline event can
-	 * cause set_cpus_allowed_ptr() failed.
-	 */
-	get_online_cpus();
+	lockdep_assert_cpus_held();     /* see cgroup_attach_lock() */
 	mutex_lock(&cpuset_mutex);
 
 	/* prepare for attach */
@@ -1588,7 +1584,6 @@ static void cpuset_attach(struct cgroup_taskset *tset)
 		wake_up(&cpuset_attach_wq);
 
 	mutex_unlock(&cpuset_mutex);
-	put_online_cpus();
 }
 
 /* The various types of files and directories in a cpuset file system */
-- 
2.17.1

