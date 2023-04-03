Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 736F46D4736
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:18:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233000AbjDCOSP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:18:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232997AbjDCOSO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:18:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05BD52C9CC
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:18:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F2A861CF1
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:18:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26465C433EF;
        Mon,  3 Apr 2023 14:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680531491;
        bh=W6/FOF23wlOM8VXu4zc1Vocn6jOs6uwApoOig0HW8cA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kYnzSb7sZg5MTH1U8jsLCm2ieiYaaoecpEyiq3bNXS0GLLnz6wIQaxxdymHwfHmF5
         B6chMz8lvNmvkZsqh2DJijKlhLh7I+zC+uv57qPOf956XJ6sTKk0w177n5nu04s8XP
         P7Xjd8xki1xvnbQcgRqWyD3lZQ4nU0cYFxjuNFQY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Tejun Heo <tj@kernel.org>,
        Cai Xinchen <caixinchen1@huawei.com>,
        Imran Khan <imran.f.khan@oracle.com>,
        Xuewen Yan <xuewen.yan@unisoc.com>
Subject: [PATCH 4.19 83/84] cgroup: Fix threadgroup_rwsem <-> cpus_read_lock() deadlock
Date:   Mon,  3 Apr 2023 16:09:24 +0200
Message-Id: <20230403140356.258072954@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140353.406927418@linuxfoundation.org>
References: <20230403140353.406927418@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
v2:
 - Add #include <linux/cpu.h> in kernel/cgroup/cgroup.c to avoid compile
   error on some architectures
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/cgroup/cgroup.c |   50 ++++++++++++++++++++++++++++++++++++++++++++-----
 kernel/cgroup/cpuset.c |    7 ------
 2 files changed, 46 insertions(+), 11 deletions(-)

--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -55,6 +55,7 @@
 #include <linux/nsproxy.h>
 #include <linux/file.h>
 #include <linux/sched/cputime.h>
+#include <linux/cpu.h>
 #include <net/sock.h>
 
 #define CREATE_TRACE_POINTS
@@ -2210,6 +2211,45 @@ int task_cgroup_path(struct task_struct
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
+/**
  * cgroup_migrate_add_task - add a migration target task to a migration context
  * @task: target task
  * @mgctx: target migration context
@@ -2694,7 +2734,7 @@ struct task_struct *cgroup_procs_write_s
 	if (kstrtoint(strstrip(buf), 0, &pid) || pid < 0)
 		return ERR_PTR(-EINVAL);
 
-	percpu_down_write(&cgroup_threadgroup_rwsem);
+	cgroup_attach_lock();
 
 	rcu_read_lock();
 	if (pid) {
@@ -2725,7 +2765,7 @@ struct task_struct *cgroup_procs_write_s
 	goto out_unlock_rcu;
 
 out_unlock_threadgroup:
-	percpu_up_write(&cgroup_threadgroup_rwsem);
+	cgroup_attach_unlock();
 out_unlock_rcu:
 	rcu_read_unlock();
 	return tsk;
@@ -2740,7 +2780,7 @@ void cgroup_procs_write_finish(struct ta
 	/* release reference from cgroup_procs_write_start() */
 	put_task_struct(task);
 
-	percpu_up_write(&cgroup_threadgroup_rwsem);
+	cgroup_attach_unlock();
 	for_each_subsys(ss, ssid)
 		if (ss->post_attach)
 			ss->post_attach();
@@ -2799,7 +2839,7 @@ static int cgroup_update_dfl_csses(struc
 
 	lockdep_assert_held(&cgroup_mutex);
 
-	percpu_down_write(&cgroup_threadgroup_rwsem);
+	cgroup_attach_lock();
 
 	/* look up all csses currently attached to @cgrp's subtree */
 	spin_lock_irq(&css_set_lock);
@@ -2830,7 +2870,7 @@ static int cgroup_update_dfl_csses(struc
 	ret = cgroup_migrate_execute(&mgctx);
 out_finish:
 	cgroup_migrate_finish(&mgctx);
-	percpu_up_write(&cgroup_threadgroup_rwsem);
+	cgroup_attach_unlock();
 	return ret;
 }
 
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1528,11 +1528,7 @@ static void cpuset_attach(struct cgroup_
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
@@ -1588,7 +1584,6 @@ static void cpuset_attach(struct cgroup_
 		wake_up(&cpuset_attach_wq);
 
 	mutex_unlock(&cpuset_mutex);
-	put_online_cpus();
 }
 
 /* The various types of files and directories in a cpuset file system */


