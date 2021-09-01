Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A8143FDAC7
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:16:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343976AbhIAMey (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:34:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:35228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244950AbhIAMds (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:33:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 23D93610FA;
        Wed,  1 Sep 2021 12:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499529;
        bh=Z+qGvNFkH33y85GovEN8cehxzKdQlwA2Yc5kgUVXwMo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lM9xgsYwQTYX3MhhsDboBTaicUUUWiojeB7pWrhgyvNWemQtds2bDz+7CPZXsMcEn
         cawq3xqD2mPdWOi3t16LePAOV3Mv93xPavzd+0oOJrVC3zg/pW2SMz6+bIs13DFNWy
         a5qJ5jsMvAXCfAgs29msIQVlb2i7jAsgTy3G/JKg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yafang Shao <laoar.shao@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Michal Hocko <mhocko@suse.com>,
        David Rientjes <rientjes@google.com>, Qian Cai <cai@lca.pw>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 07/48] mm, oom: make the calculation of oom badness more accurate
Date:   Wed,  1 Sep 2021 14:27:57 +0200
Message-Id: <20210901122253.639091616@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122253.388326997@linuxfoundation.org>
References: <20210901122253.388326997@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yafang Shao <laoar.shao@gmail.com>

[ Upstream commit 9066e5cfb73cdbcdbb49e87999482ab615e9fc76 ]

Recently we found an issue on our production environment that when memcg
oom is triggered the oom killer doesn't chose the process with largest
resident memory but chose the first scanned process.  Note that all
processes in this memcg have the same oom_score_adj, so the oom killer
should chose the process with largest resident memory.

Bellow is part of the oom info, which is enough to analyze this issue.
[7516987.983223] memory: usage 16777216kB, limit 16777216kB, failcnt 52843037
[7516987.983224] memory+swap: usage 16777216kB, limit 9007199254740988kB, failcnt 0
[7516987.983225] kmem: usage 301464kB, limit 9007199254740988kB, failcnt 0
[...]
[7516987.983293] [ pid ]   uid  tgid total_vm      rss pgtables_bytes swapents oom_score_adj name
[7516987.983510] [ 5740]     0  5740      257        1    32768        0          -998 pause
[7516987.983574] [58804]     0 58804     4594      771    81920        0          -998 entry_point.bas
[7516987.983577] [58908]     0 58908     7089      689    98304        0          -998 cron
[7516987.983580] [58910]     0 58910    16235     5576   163840        0          -998 supervisord
[7516987.983590] [59620]     0 59620    18074     1395   188416        0          -998 sshd
[7516987.983594] [59622]     0 59622    18680     6679   188416        0          -998 python
[7516987.983598] [59624]     0 59624  1859266     5161   548864        0          -998 odin-agent
[7516987.983600] [59625]     0 59625   707223     9248   983040        0          -998 filebeat
[7516987.983604] [59627]     0 59627   416433    64239   774144        0          -998 odin-log-agent
[7516987.983607] [59631]     0 59631   180671    15012   385024        0          -998 python3
[7516987.983612] [61396]     0 61396   791287     3189   352256        0          -998 client
[7516987.983615] [61641]     0 61641  1844642    29089   946176        0          -998 client
[7516987.983765] [ 9236]     0  9236     2642      467    53248        0          -998 php_scanner
[7516987.983911] [42898]     0 42898    15543      838   167936        0          -998 su
[7516987.983915] [42900]  1000 42900     3673      867    77824        0          -998 exec_script_vr2
[7516987.983918] [42925]  1000 42925    36475    19033   335872        0          -998 python
[7516987.983921] [57146]  1000 57146     3673      848    73728        0          -998 exec_script_J2p
[7516987.983925] [57195]  1000 57195   186359    22958   491520        0          -998 python2
[7516987.983928] [58376]  1000 58376   275764    14402   290816        0          -998 rosmaster
[7516987.983931] [58395]  1000 58395   155166     4449   245760        0          -998 rosout
[7516987.983935] [58406]  1000 58406 18285584  3967322 37101568        0          -998 data_sim
[7516987.984221] oom-kill:constraint=CONSTRAINT_MEMCG,nodemask=(null),cpuset=3aa16c9482ae3a6f6b78bda68a55d32c87c99b985e0f11331cddf05af6c4d753,mems_allowed=0-1,oom_memcg=/kubepods/podf1c273d3-9b36-11ea-b3df-246e9693c184,task_memcg=/kubepods/podf1c273d3-9b36-11ea-b3df-246e9693c184/1f246a3eeea8f70bf91141eeaf1805346a666e225f823906485ea0b6c37dfc3d,task=pause,pid=5740,uid=0
[7516987.984254] Memory cgroup out of memory: Killed process 5740 (pause) total-vm:1028kB, anon-rss:4kB, file-rss:0kB, shmem-rss:0kB
[7516988.092344] oom_reaper: reaped process 5740 (pause), now anon-rss:0kB, file-rss:0kB, shmem-rss:0kB

We can find that the first scanned process 5740 (pause) was killed, but
its rss is only one page.  That is because, when we calculate the oom
badness in oom_badness(), we always ignore the negtive point and convert
all of these negtive points to 1.  Now as oom_score_adj of all the
processes in this targeted memcg have the same value -998, the points of
these processes are all negtive value.  As a result, the first scanned
process will be killed.

The oom_socre_adj (-998) in this memcg is set by kubelet, because it is a
a Guaranteed pod, which has higher priority to prevent from being killed
by system oom.

To fix this issue, we should make the calculation of oom point more
accurate.  We can achieve it by convert the chosen_point from 'unsigned
long' to 'long'.

[cai@lca.pw: reported a issue in the previous version]
[mhocko@suse.com: fixed the issue reported by Cai]
[mhocko@suse.com: add the comment in proc_oom_score()]
[laoar.shao@gmail.com: v3]
  Link: http://lkml.kernel.org/r/1594396651-9931-1-git-send-email-laoar.shao@gmail.com

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Tested-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Qian Cai <cai@lca.pw>
Link: http://lkml.kernel.org/r/1594309987-9919-1-git-send-email-laoar.shao@gmail.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/proc/base.c      | 11 ++++++++++-
 include/linux/oom.h |  4 ++--
 mm/oom_kill.c       | 22 ++++++++++------------
 3 files changed, 22 insertions(+), 15 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 90d2f62a9672..5a187e9b7221 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -549,8 +549,17 @@ static int proc_oom_score(struct seq_file *m, struct pid_namespace *ns,
 {
 	unsigned long totalpages = totalram_pages() + total_swap_pages;
 	unsigned long points = 0;
+	long badness;
+
+	badness = oom_badness(task, totalpages);
+	/*
+	 * Special case OOM_SCORE_ADJ_MIN for all others scale the
+	 * badness value into [0, 2000] range which we have been
+	 * exporting for a long time so userspace might depend on it.
+	 */
+	if (badness != LONG_MIN)
+		points = (1000 + badness * 1000 / (long)totalpages) * 2 / 3;
 
-	points = oom_badness(task, totalpages) * 1000 / totalpages;
 	seq_printf(m, "%lu\n", points);
 
 	return 0;
diff --git a/include/linux/oom.h b/include/linux/oom.h
index b9df34326772..2db9a1432511 100644
--- a/include/linux/oom.h
+++ b/include/linux/oom.h
@@ -48,7 +48,7 @@ struct oom_control {
 	/* Used by oom implementation, do not set */
 	unsigned long totalpages;
 	struct task_struct *chosen;
-	unsigned long chosen_points;
+	long chosen_points;
 
 	/* Used to print the constraint info. */
 	enum oom_constraint constraint;
@@ -108,7 +108,7 @@ static inline vm_fault_t check_stable_address_space(struct mm_struct *mm)
 
 bool __oom_reap_task_mm(struct mm_struct *mm);
 
-extern unsigned long oom_badness(struct task_struct *p,
+long oom_badness(struct task_struct *p,
 		unsigned long totalpages);
 
 extern bool out_of_memory(struct oom_control *oc);
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 212e71874301..f1b810ddf232 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -197,17 +197,17 @@ static bool is_dump_unreclaim_slabs(void)
  * predictable as possible.  The goal is to return the highest value for the
  * task consuming the most memory to avoid subsequent oom failures.
  */
-unsigned long oom_badness(struct task_struct *p, unsigned long totalpages)
+long oom_badness(struct task_struct *p, unsigned long totalpages)
 {
 	long points;
 	long adj;
 
 	if (oom_unkillable_task(p))
-		return 0;
+		return LONG_MIN;
 
 	p = find_lock_task_mm(p);
 	if (!p)
-		return 0;
+		return LONG_MIN;
 
 	/*
 	 * Do not even consider tasks which are explicitly marked oom
@@ -219,7 +219,7 @@ unsigned long oom_badness(struct task_struct *p, unsigned long totalpages)
 			test_bit(MMF_OOM_SKIP, &p->mm->flags) ||
 			in_vfork(p)) {
 		task_unlock(p);
-		return 0;
+		return LONG_MIN;
 	}
 
 	/*
@@ -234,11 +234,7 @@ unsigned long oom_badness(struct task_struct *p, unsigned long totalpages)
 	adj *= totalpages / 1000;
 	points += adj;
 
-	/*
-	 * Never return 0 for an eligible task regardless of the root bonus and
-	 * oom_score_adj (oom_score_adj can't be OOM_SCORE_ADJ_MIN here).
-	 */
-	return points > 0 ? points : 1;
+	return points;
 }
 
 static const char * const oom_constraint_text[] = {
@@ -311,7 +307,7 @@ static enum oom_constraint constrained_alloc(struct oom_control *oc)
 static int oom_evaluate_task(struct task_struct *task, void *arg)
 {
 	struct oom_control *oc = arg;
-	unsigned long points;
+	long points;
 
 	if (oom_unkillable_task(task))
 		goto next;
@@ -337,12 +333,12 @@ static int oom_evaluate_task(struct task_struct *task, void *arg)
 	 * killed first if it triggers an oom, then select it.
 	 */
 	if (oom_task_origin(task)) {
-		points = ULONG_MAX;
+		points = LONG_MAX;
 		goto select;
 	}
 
 	points = oom_badness(task, oc->totalpages);
-	if (!points || points < oc->chosen_points)
+	if (points == LONG_MIN || points < oc->chosen_points)
 		goto next;
 
 select:
@@ -366,6 +362,8 @@ static int oom_evaluate_task(struct task_struct *task, void *arg)
  */
 static void select_bad_process(struct oom_control *oc)
 {
+	oc->chosen_points = LONG_MIN;
+
 	if (is_memcg_oom(oc))
 		mem_cgroup_scan_tasks(oc->memcg, oom_evaluate_task, oc);
 	else {
-- 
2.30.2



