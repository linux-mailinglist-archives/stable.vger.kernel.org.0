Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E010C6D4734
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:18:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232992AbjDCOSL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:18:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232997AbjDCOSJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:18:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 497662BEF6
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:18:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D8EF861CCC
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:18:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF2C0C433EF;
        Mon,  3 Apr 2023 14:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680531486;
        bh=oeMo3j+UO3Ar8tYDF+vJ038dMcLrp5HC9ppOEsU7aVM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yas05GD891bWaGYlzJMtHMgPAtaIEd0rywayUO9pYAY7X2nBd5TBjZm5eyGXJs8Nw
         CbNDHaXRGHGYLS1BgrDg3Swdzaewj3tOszXtuRhY3tmATiK7ZUqZQBcoOTsIoj/fd6
         xYx6RhgvcsvxIpQ1oazPXEBORcftFYwDnQcpPcfs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, bristot@redhat.com,
        claudio@evidence.eu.com, lizefan@huawei.com, longman@redhat.com,
        luca.abeni@santannapisa.it, mathieu.poirier@linaro.org,
        rostedt@goodmis.org, tj@kernel.org,
        tommaso.cucinotta@santannapisa.it, Ingo Molnar <mingo@kernel.org>,
        Cai Xinchen <caixinchen1@huawei.com>
Subject: [PATCH 4.19 82/84] cgroup/cpuset: Change cpuset_rwsem and hotplug lock order
Date:   Mon,  3 Apr 2023 16:09:23 +0200
Message-Id: <20230403140356.228152282@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140353.406927418@linuxfoundation.org>
References: <20230403140353.406927418@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
v2:
 * Change get_online_cpus/put_online_cpus lock order in cpuset_attach
   to keep cpuset_mutex and hotplug lock order
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/cpuset.h |    8 ++++----
 kernel/cgroup/cpuset.c |   24 +++++++++++++++++-------
 2 files changed, 21 insertions(+), 11 deletions(-)

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
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -830,8 +830,8 @@ static void rebuild_sched_domains_locked
 	cpumask_var_t *doms;
 	int ndoms;
 
+	lockdep_assert_cpus_held();
 	lockdep_assert_held(&cpuset_mutex);
-	get_online_cpus();
 
 	/*
 	 * We have raced with CPU hotplug. Don't do anything to avoid
@@ -839,15 +839,13 @@ static void rebuild_sched_domains_locked
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
@@ -857,9 +855,11 @@ static void rebuild_sched_domains_locked
 
 void rebuild_sched_domains(void)
 {
+	get_online_cpus();
 	mutex_lock(&cpuset_mutex);
 	rebuild_sched_domains_locked();
 	mutex_unlock(&cpuset_mutex);
+	put_online_cpus();
 }
 
 /**
@@ -1528,13 +1528,13 @@ static void cpuset_attach(struct cgroup_
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
@@ -1553,7 +1553,6 @@ static void cpuset_attach(struct cgroup_
 		cpuset_change_task_nodemask(task, &cpuset_attach_nodemask_to);
 		cpuset_update_task_spread_flag(cs, task);
 	}
-       put_online_cpus();
 
 	/*
 	 * Change mm for all threadgroup leaders. This is expensive and may
@@ -1589,6 +1588,7 @@ static void cpuset_attach(struct cgroup_
 		wake_up(&cpuset_attach_wq);
 
 	mutex_unlock(&cpuset_mutex);
+	put_online_cpus();
 }
 
 /* The various types of files and directories in a cpuset file system */
@@ -1617,6 +1617,7 @@ static int cpuset_write_u64(struct cgrou
 	cpuset_filetype_t type = cft->private;
 	int retval = 0;
 
+	get_online_cpus();
 	mutex_lock(&cpuset_mutex);
 	if (!is_cpuset_online(cs)) {
 		retval = -ENODEV;
@@ -1654,6 +1655,7 @@ static int cpuset_write_u64(struct cgrou
 	}
 out_unlock:
 	mutex_unlock(&cpuset_mutex);
+	put_online_cpus();
 	return retval;
 }
 
@@ -1664,6 +1666,7 @@ static int cpuset_write_s64(struct cgrou
 	cpuset_filetype_t type = cft->private;
 	int retval = -ENODEV;
 
+	get_online_cpus();
 	mutex_lock(&cpuset_mutex);
 	if (!is_cpuset_online(cs))
 		goto out_unlock;
@@ -1678,6 +1681,7 @@ static int cpuset_write_s64(struct cgrou
 	}
 out_unlock:
 	mutex_unlock(&cpuset_mutex);
+	put_online_cpus();
 	return retval;
 }
 
@@ -1716,6 +1720,7 @@ static ssize_t cpuset_write_resmask(stru
 	kernfs_break_active_protection(of->kn);
 	flush_work(&cpuset_hotplug_work);
 
+	get_online_cpus();
 	mutex_lock(&cpuset_mutex);
 	if (!is_cpuset_online(cs))
 		goto out_unlock;
@@ -1741,6 +1746,7 @@ static ssize_t cpuset_write_resmask(stru
 	free_trial_cpuset(trialcs);
 out_unlock:
 	mutex_unlock(&cpuset_mutex);
+	put_online_cpus();
 	kernfs_unbreak_active_protection(of->kn);
 	css_put(&cs->css);
 	flush_workqueue(cpuset_migrate_mm_wq);
@@ -1985,6 +1991,7 @@ static int cpuset_css_online(struct cgro
 	if (!parent)
 		return 0;
 
+	get_online_cpus();
 	mutex_lock(&cpuset_mutex);
 
 	set_bit(CS_ONLINE, &cs->flags);
@@ -2035,6 +2042,7 @@ static int cpuset_css_online(struct cgro
 	spin_unlock_irq(&callback_lock);
 out_unlock:
 	mutex_unlock(&cpuset_mutex);
+	put_online_cpus();
 	return 0;
 }
 
@@ -2048,6 +2056,7 @@ static void cpuset_css_offline(struct cg
 {
 	struct cpuset *cs = css_cs(css);
 
+	get_online_cpus();
 	mutex_lock(&cpuset_mutex);
 
 	if (is_sched_load_balance(cs))
@@ -2057,6 +2066,7 @@ static void cpuset_css_offline(struct cg
 	clear_bit(CS_ONLINE, &cs->flags);
 
 	mutex_unlock(&cpuset_mutex);
+	put_online_cpus();
 }
 
 static void cpuset_css_free(struct cgroup_subsys_state *css)


