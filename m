Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEA1659A44B
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 20:05:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353637AbiHSQmg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:42:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353313AbiHSQkC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:40:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40CB618B20;
        Fri, 19 Aug 2022 09:08:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 21DCE6181A;
        Fri, 19 Aug 2022 16:07:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4F99C433D6;
        Fri, 19 Aug 2022 16:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660925246;
        bh=DSjYKFmh06ko8rlbhaj8I90fRkZxrFNOwFOoqQGzFfw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d20B2fnK/jRc/sIAOcnBaqDHzjer8CSt1CTmwwJTMTwSC4WgmngOXtR3G+nvVK3en
         reJww1njkmRZ1HZKRhHmVFwWpdsuj9scn0MjWSckjS8NpNHIUzDqQjc4p4WQeZ9w6w
         lnS1M9BxsG/RWeTd0IRxjNg+fgl7F5fyidAFhqno=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Waiman Long <longman@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 430/545] sched, cpuset: Fix dl_cpu_busy() panic due to empty cs->cpus_allowed
Date:   Fri, 19 Aug 2022 17:43:20 +0200
Message-Id: <20220819153848.651668076@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
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

From: Waiman Long <longman@redhat.com>

[ Upstream commit b6e8d40d43ae4dec00c8fea2593eeea3114b8f44 ]

With cgroup v2, the cpuset's cpus_allowed mask can be empty indicating
that the cpuset will just use the effective CPUs of its parent. So
cpuset_can_attach() can call task_can_attach() with an empty mask.
This can lead to cpumask_any_and() returns nr_cpu_ids causing the call
to dl_bw_of() to crash due to percpu value access of an out of bound
CPU value. For example:

	[80468.182258] BUG: unable to handle page fault for address: ffffffff8b6648b0
	  :
	[80468.191019] RIP: 0010:dl_cpu_busy+0x30/0x2b0
	  :
	[80468.207946] Call Trace:
	[80468.208947]  cpuset_can_attach+0xa0/0x140
	[80468.209953]  cgroup_migrate_execute+0x8c/0x490
	[80468.210931]  cgroup_update_dfl_csses+0x254/0x270
	[80468.211898]  cgroup_subtree_control_write+0x322/0x400
	[80468.212854]  kernfs_fop_write_iter+0x11c/0x1b0
	[80468.213777]  new_sync_write+0x11f/0x1b0
	[80468.214689]  vfs_write+0x1eb/0x280
	[80468.215592]  ksys_write+0x5f/0xe0
	[80468.216463]  do_syscall_64+0x5c/0x80
	[80468.224287]  entry_SYSCALL_64_after_hwframe+0x44/0xae

Fix that by using effective_cpus instead. For cgroup v1, effective_cpus
is the same as cpus_allowed. For v2, effective_cpus is the real cpumask
to be used by tasks within the cpuset anyway.

Also update task_can_attach()'s 2nd argument name to cs_effective_cpus to
reflect the change. In addition, a check is added to task_can_attach()
to guard against the possibility that cpumask_any_and() may return a
value >= nr_cpu_ids.

Fixes: 7f51412a415d ("sched/deadline: Fix bandwidth check/update when migrating tasks between exclusive cpusets")
Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Juri Lelli <juri.lelli@redhat.com>
Link: https://lore.kernel.org/r/20220803015451.2219567-1-longman@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sched.h  | 2 +-
 kernel/cgroup/cpuset.c | 2 +-
 kernel/sched/core.c    | 8 +++++---
 3 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 4bca80c9931f..4e8425c1c560 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1658,7 +1658,7 @@ current_restore_flags(unsigned long orig_flags, unsigned long flags)
 }
 
 extern int cpuset_cpumask_can_shrink(const struct cpumask *cur, const struct cpumask *trial);
-extern int task_can_attach(struct task_struct *p, const struct cpumask *cs_cpus_allowed);
+extern int task_can_attach(struct task_struct *p, const struct cpumask *cs_effective_cpus);
 #ifdef CONFIG_SMP
 extern void do_set_cpus_allowed(struct task_struct *p, const struct cpumask *new_mask);
 extern int set_cpus_allowed_ptr(struct task_struct *p, const struct cpumask *new_mask);
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index ec39e123c2a5..c51863b63f93 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2162,7 +2162,7 @@ static int cpuset_can_attach(struct cgroup_taskset *tset)
 		goto out_unlock;
 
 	cgroup_taskset_for_each(task, css, tset) {
-		ret = task_can_attach(task, cs->cpus_allowed);
+		ret = task_can_attach(task, cs->effective_cpus);
 		if (ret)
 			goto out_unlock;
 		ret = security_task_setscheduler(task);
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 042efabf5378..8765de76a179 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6586,7 +6586,7 @@ int cpuset_cpumask_can_shrink(const struct cpumask *cur,
 }
 
 int task_can_attach(struct task_struct *p,
-		    const struct cpumask *cs_cpus_allowed)
+		    const struct cpumask *cs_effective_cpus)
 {
 	int ret = 0;
 
@@ -6605,9 +6605,11 @@ int task_can_attach(struct task_struct *p,
 	}
 
 	if (dl_task(p) && !cpumask_intersects(task_rq(p)->rd->span,
-					      cs_cpus_allowed)) {
-		int cpu = cpumask_any_and(cpu_active_mask, cs_cpus_allowed);
+					      cs_effective_cpus)) {
+		int cpu = cpumask_any_and(cpu_active_mask, cs_effective_cpus);
 
+		if (unlikely(cpu >= nr_cpu_ids))
+			return -EINVAL;
 		ret = dl_cpu_busy(cpu, p);
 	}
 
-- 
2.35.1



