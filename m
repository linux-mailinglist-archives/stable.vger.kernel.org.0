Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D72E6C08AA
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 02:41:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229878AbjCTBl2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Mar 2023 21:41:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbjCTBlN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Mar 2023 21:41:13 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9D781BC0;
        Sun, 19 Mar 2023 18:39:20 -0700 (PDT)
Received: from kwepemi500024.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Pfxg61TgRznYTt;
        Mon, 20 Mar 2023 09:17:38 +0800 (CST)
Received: from ci.huawei.com (10.67.175.89) by kwepemi500024.china.huawei.com
 (7.221.188.100) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21; Mon, 20 Mar
 2023 09:20:41 +0800
From:   Cai Xinchen <caixinchen1@huawei.com>
To:     <longman@redhat.com>, <lizefan.x@bytedance.com>, <tj@kernel.org>,
        <hannes@cmpxchg.org>, <gregkh@linuxfoundation.org>,
        <sashal@kernel.org>
CC:     <mkoutny@suse.com>, <zhangqiao22@huawei.com>,
        <juri.lelli@redhat.com>, <penguin-kernel@I-love.SAKURA.ne.jp>,
        <stable@vger.kernel.org>, <cgroups@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 4.19 1/3] cgroup/cpuset: Change cpuset_rwsem and hotplug lock order
Date:   Mon, 20 Mar 2023 01:15:05 +0000
Message-ID: <20230320011507.129441-2-caixinchen1@huawei.com>
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

From: Juri Lelli <juri.lelli@redhat.com>

commit d74b27d63a8bebe2fe634944e4ebdc7b10db7a39 upstream.

commit 1243dc518c9da ("cgroup/cpuset: Convert cpuset_mutex to
percpu_rwsem") is performance patch which is not backport. So
convert percpu_rwsem to cpuset_mutex.

commit aa44002e7db25 ("cpuset: Fix unsafe lock order between
cpuset lock and cpuslock") makes lock order keep cpuset_mutex
->cpu_hotplug_lock. We should change lock order in cpuset_attach.

original commit message:

cpuset_rwsem is going to be acquired from sched_setscheduler() with a
following patch. There are however paths (e.g., spawn_ksoftirqd) in
which sched_scheduler() is eventually called while holding hotplug lock;
this creates a dependecy between hotplug lock (to be always acquired
first) and cpuset_rwsem (to be always acquired after hotplug lock).

Fix paths which currently take the two locks in the wrong order (after
a following patch is applied).

Tested-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Signed-off-by: Juri Lelli <juri.lelli@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: bristot@redhat.com
Cc: claudio@evidence.eu.com
Cc: lizefan@huawei.com
Cc: longman@redhat.com
Cc: luca.abeni@santannapisa.it
Cc: mathieu.poirier@linaro.org
Cc: rostedt@goodmis.org
Cc: tj@kernel.org
Cc: tommaso.cucinotta@santannapisa.it
Link: https://lkml.kernel.org/r/20190719140000.31694-7-juri.lelli@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Cai Xinchen <caixinchen1@huawei.com>
---
v2:
 * Change get_online_cpus/put_online_cpus lock order in cpuset_attach
   to keep cpuset_mutex and hotplug lock order
---
 include/linux/cpuset.h |  8 ++++----
 kernel/cgroup/cpuset.c | 24 +++++++++++++++++-------
 2 files changed, 21 insertions(+), 11 deletions(-)

diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
index 934633a05d20..7f1478c26a33 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -40,14 +40,14 @@ static inline bool cpusets_enabled(void)
 
 static inline void cpuset_inc(void)
 {
-	static_branch_inc(&cpusets_pre_enable_key);
-	static_branch_inc(&cpusets_enabled_key);
+	static_branch_inc_cpuslocked(&cpusets_pre_enable_key);
+	static_branch_inc_cpuslocked(&cpusets_enabled_key);
 }
 
 static inline void cpuset_dec(void)
 {
-	static_branch_dec(&cpusets_enabled_key);
-	static_branch_dec(&cpusets_pre_enable_key);
+	static_branch_dec_cpuslocked(&cpusets_enabled_key);
+	static_branch_dec_cpuslocked(&cpusets_pre_enable_key);
 }
 
 extern int cpuset_init(void);
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index dcd5755b1fe2..7169e47fb48b 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -830,8 +830,8 @@ static void rebuild_sched_domains_locked(void)
 	cpumask_var_t *doms;
 	int ndoms;
 
+	lockdep_assert_cpus_held();
 	lockdep_assert_held(&cpuset_mutex);
-	get_online_cpus();
 
 	/*
 	 * We have raced with CPU hotplug. Don't do anything to avoid
@@ -839,15 +839,13 @@ static void rebuild_sched_domains_locked(void)
 	 * Anyways, hotplug work item will rebuild sched domains.
 	 */
 	if (!cpumask_equal(top_cpuset.effective_cpus, cpu_active_mask))
-		goto out;
+		return;
 
 	/* Generate domain masks and attrs */
 	ndoms = generate_sched_domains(&doms, &attr);
 
 	/* Have scheduler rebuild the domains */
 	partition_sched_domains(ndoms, doms, attr);
-out:
-	put_online_cpus();
 }
 #else /* !CONFIG_SMP */
 static void rebuild_sched_domains_locked(void)
@@ -857,9 +855,11 @@ static void rebuild_sched_domains_locked(void)
 
 void rebuild_sched_domains(void)
 {
+	get_online_cpus();
 	mutex_lock(&cpuset_mutex);
 	rebuild_sched_domains_locked();
 	mutex_unlock(&cpuset_mutex);
+	put_online_cpus();
 }
 
 /**
@@ -1528,13 +1528,13 @@ static void cpuset_attach(struct cgroup_taskset *tset)
 	cgroup_taskset_first(tset, &css);
 	cs = css_cs(css);
 
-	mutex_lock(&cpuset_mutex);
-
 	/*
 	 * It should hold cpus lock because a cpu offline event can
 	 * cause set_cpus_allowed_ptr() failed.
 	 */
 	get_online_cpus();
+	mutex_lock(&cpuset_mutex);
+
 	/* prepare for attach */
 	if (cs == &top_cpuset)
 		cpumask_copy(cpus_attach, cpu_possible_mask);
@@ -1553,7 +1553,6 @@ static void cpuset_attach(struct cgroup_taskset *tset)
 		cpuset_change_task_nodemask(task, &cpuset_attach_nodemask_to);
 		cpuset_update_task_spread_flag(cs, task);
 	}
-       put_online_cpus();
 
 	/*
 	 * Change mm for all threadgroup leaders. This is expensive and may
@@ -1589,6 +1588,7 @@ static void cpuset_attach(struct cgroup_taskset *tset)
 		wake_up(&cpuset_attach_wq);
 
 	mutex_unlock(&cpuset_mutex);
+	put_online_cpus();
 }
 
 /* The various types of files and directories in a cpuset file system */
@@ -1617,6 +1617,7 @@ static int cpuset_write_u64(struct cgroup_subsys_state *css, struct cftype *cft,
 	cpuset_filetype_t type = cft->private;
 	int retval = 0;
 
+	get_online_cpus();
 	mutex_lock(&cpuset_mutex);
 	if (!is_cpuset_online(cs)) {
 		retval = -ENODEV;
@@ -1654,6 +1655,7 @@ static int cpuset_write_u64(struct cgroup_subsys_state *css, struct cftype *cft,
 	}
 out_unlock:
 	mutex_unlock(&cpuset_mutex);
+	put_online_cpus();
 	return retval;
 }
 
@@ -1664,6 +1666,7 @@ static int cpuset_write_s64(struct cgroup_subsys_state *css, struct cftype *cft,
 	cpuset_filetype_t type = cft->private;
 	int retval = -ENODEV;
 
+	get_online_cpus();
 	mutex_lock(&cpuset_mutex);
 	if (!is_cpuset_online(cs))
 		goto out_unlock;
@@ -1678,6 +1681,7 @@ static int cpuset_write_s64(struct cgroup_subsys_state *css, struct cftype *cft,
 	}
 out_unlock:
 	mutex_unlock(&cpuset_mutex);
+	put_online_cpus();
 	return retval;
 }
 
@@ -1716,6 +1720,7 @@ static ssize_t cpuset_write_resmask(struct kernfs_open_file *of,
 	kernfs_break_active_protection(of->kn);
 	flush_work(&cpuset_hotplug_work);
 
+	get_online_cpus();
 	mutex_lock(&cpuset_mutex);
 	if (!is_cpuset_online(cs))
 		goto out_unlock;
@@ -1741,6 +1746,7 @@ static ssize_t cpuset_write_resmask(struct kernfs_open_file *of,
 	free_trial_cpuset(trialcs);
 out_unlock:
 	mutex_unlock(&cpuset_mutex);
+	put_online_cpus();
 	kernfs_unbreak_active_protection(of->kn);
 	css_put(&cs->css);
 	flush_workqueue(cpuset_migrate_mm_wq);
@@ -1985,6 +1991,7 @@ static int cpuset_css_online(struct cgroup_subsys_state *css)
 	if (!parent)
 		return 0;
 
+	get_online_cpus();
 	mutex_lock(&cpuset_mutex);
 
 	set_bit(CS_ONLINE, &cs->flags);
@@ -2035,6 +2042,7 @@ static int cpuset_css_online(struct cgroup_subsys_state *css)
 	spin_unlock_irq(&callback_lock);
 out_unlock:
 	mutex_unlock(&cpuset_mutex);
+	put_online_cpus();
 	return 0;
 }
 
@@ -2048,6 +2056,7 @@ static void cpuset_css_offline(struct cgroup_subsys_state *css)
 {
 	struct cpuset *cs = css_cs(css);
 
+	get_online_cpus();
 	mutex_lock(&cpuset_mutex);
 
 	if (is_sched_load_balance(cs))
@@ -2057,6 +2066,7 @@ static void cpuset_css_offline(struct cgroup_subsys_state *css)
 	clear_bit(CS_ONLINE, &cs->flags);
 
 	mutex_unlock(&cpuset_mutex);
+	put_online_cpus();
 }
 
 static void cpuset_css_free(struct cgroup_subsys_state *css)
-- 
2.17.1

