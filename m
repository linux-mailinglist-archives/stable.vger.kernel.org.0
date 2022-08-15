Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC967593CBB
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:39:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344381AbiHOTnF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:43:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344700AbiHOTlY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:41:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C79E65811;
        Mon, 15 Aug 2022 11:47:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A6A15B81084;
        Mon, 15 Aug 2022 18:47:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11A57C433C1;
        Mon, 15 Aug 2022 18:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589243;
        bh=m/cZj8U6SnnRtObGLL41hNZvW4O1KjdnXBw2od3BvTU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O2g2xXbJ0S9ELeOv+nVYn9dDxwuwNyyCL3LmZcTE6T95mEc1dDBqX1Os8ZRt7qLh8
         KnZGWLupkYlReZoRsge2WpX9yx/u7vWmB1hXuo3Vuw8Oj9BcU9oFwHaqM3RPITNyfU
         0siAFSGjavMTqLpb+TDyUPZwHz5VXRNbBej19B60=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Waiman Long <longman@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 656/779] sched, cpuset: Fix dl_cpu_busy() panic due to empty cs->cpus_allowed
Date:   Mon, 15 Aug 2022 20:05:00 +0200
Message-Id: <20220815180405.422575786@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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
index ad7ff332a0ac..dcba347cbffa 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1797,7 +1797,7 @@ current_restore_flags(unsigned long orig_flags, unsigned long flags)
 }
 
 extern int cpuset_cpumask_can_shrink(const struct cpumask *cur, const struct cpumask *trial);
-extern int task_can_attach(struct task_struct *p, const struct cpumask *cs_cpus_allowed);
+extern int task_can_attach(struct task_struct *p, const struct cpumask *cs_effective_cpus);
 #ifdef CONFIG_SMP
 extern void do_set_cpus_allowed(struct task_struct *p, const struct cpumask *new_mask);
 extern int set_cpus_allowed_ptr(struct task_struct *p, const struct cpumask *new_mask);
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 31f94c6ea0a5..9c5b659db63f 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2199,7 +2199,7 @@ static int cpuset_can_attach(struct cgroup_taskset *tset)
 		goto out_unlock;
 
 	cgroup_taskset_for_each(task, css, tset) {
-		ret = task_can_attach(task, cs->cpus_allowed);
+		ret = task_can_attach(task, cs->effective_cpus);
 		if (ret)
 			goto out_unlock;
 		ret = security_task_setscheduler(task);
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 154506e4d1f5..5c7937b504d2 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -8741,7 +8741,7 @@ int cpuset_cpumask_can_shrink(const struct cpumask *cur,
 }
 
 int task_can_attach(struct task_struct *p,
-		    const struct cpumask *cs_cpus_allowed)
+		    const struct cpumask *cs_effective_cpus)
 {
 	int ret = 0;
 
@@ -8760,9 +8760,11 @@ int task_can_attach(struct task_struct *p,
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



