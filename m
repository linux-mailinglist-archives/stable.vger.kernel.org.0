Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C50B56BB048
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:16:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231994AbjCOMQz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:16:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231896AbjCOMQk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:16:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D80EC92265
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:16:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 751C561D13
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:16:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D95AC433EF;
        Wed, 15 Mar 2023 12:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678882595;
        bh=+gsPRaUG5fLRSqH8kjXvr1Gx47yxxrc8GYNVfeqrJ54=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jGdE1ko3+xcHzfQueDPb4m5t6kHfMkovSTXynSX/mJo0+WHgUw3I6Mj10wb/Qo2aQ
         nZD52hJLOWf0LnishxI0E097wEQN9g2MwgkivNfMGBvai6DDxAhPXfSfQ87MR3291/
         vnDmf8lek4K1rtY20YnOFIjJXfLq0ygFfCCMns4k=
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
Subject: [PATCH 4.19 37/39] cgroup/cpuset: Change cpuset_rwsem and hotplug lock order
Date:   Wed, 15 Mar 2023 13:12:51 +0100
Message-Id: <20230315115722.612166269@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115721.234756306@linuxfoundation.org>
References: <20230315115721.234756306@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juri Lelli <juri.lelli@redhat.com>

commit d74b27d63a8bebe2fe634944e4ebdc7b10db7a39 upstream.

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
 include/linux/cpuset.h |    8 ++++----
 kernel/cgroup/cpuset.c |   18 ++++++++++++++----
 2 files changed, 18 insertions(+), 8 deletions(-)

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


