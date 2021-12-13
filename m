Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0B81472EB1
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 15:19:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233376AbhLMOT6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 09:19:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232397AbhLMOT6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 09:19:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6996BC061574;
        Mon, 13 Dec 2021 06:19:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E69306109A;
        Mon, 13 Dec 2021 14:19:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DBE5C34603;
        Mon, 13 Dec 2021 14:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639405197;
        bh=cf6HQpghohc60PqvTuVp83j1DRDmqwoJZ/lY40Posr8=;
        h=From:To:Cc:Subject:Date:From;
        b=QIeQ4F1RysDTtveJXBSG8Oe+elN2NirLvNCNUWzoNc77bHNngr71mU8BgWYJeeC16
         kbUdfHkcg8fZaN7QmyyH0sjhuxyMfLkHM4zFlZCGdfgUUIHAu2QhnDkF6Pymm+BdqD
         WZhjZUtskwP1UtnV6Wmrq2F3D6HPS3yEgPerajQMYslz89fP1Yk9ViMXWf295p77ou
         xCmaiXqczNSTcqTIiDXvAwKSYrARUsccXPOaWp3uJRTcGwD8lQR05xK0/WGfdRYdDh
         7OCtEuKtxEH+LO6NpuwHHZaHiqLnSHSlbcmVzqfipdzot5ao8Jp6+9Xd+6UfnfoqFk
         0BbhfxM0NUBng==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Frederic Weisbecker <frederic@kernel.org>,
        Hasegawa Hitomi <hasegawa-hitomi@fujitsu.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>,
        Phil Auld <pauld@redhat.com>, Sasha Levin <sashal@kernel.org>,
        mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com,
        vincent.guittot@linaro.org
Subject: [PATCH MANUALSEL 5.15 1/9] sched/cputime: Fix getrusage(RUSAGE_THREAD) with nohz_full
Date:   Mon, 13 Dec 2021 09:19:34 -0500
Message-Id: <20211213141944.352249-1-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frederic Weisbecker <frederic@kernel.org>

[ Upstream commit e7f2be115f0746b969c0df14c0d182f65f005ca5 ]

getrusage(RUSAGE_THREAD) with nohz_full may return shorter utime/stime
than the actual time.

task_cputime_adjusted() snapshots utime and stime and then adjust their
sum to match the scheduler maintained cputime.sum_exec_runtime.
Unfortunately in nohz_full, sum_exec_runtime is only updated once per
second in the worst case, causing a discrepancy against utime and stime
that can be updated anytime by the reader using vtime.

To fix this situation, perform an update of cputime.sum_exec_runtime
when the cputime snapshot reports the task as actually running while
the tick is disabled. The related overhead is then contained within the
relevant situations.

Reported-by: Hasegawa Hitomi <hasegawa-hitomi@fujitsu.com>
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Hasegawa Hitomi <hasegawa-hitomi@fujitsu.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
Acked-by: Phil Auld <pauld@redhat.com>
Link: https://lore.kernel.org/r/20211026141055.57358-3-frederic@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sched/cputime.h |  5 +++--
 kernel/sched/cputime.c        | 12 +++++++++---
 2 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/include/linux/sched/cputime.h b/include/linux/sched/cputime.h
index 6c9f19a33865a..ce3c58286062c 100644
--- a/include/linux/sched/cputime.h
+++ b/include/linux/sched/cputime.h
@@ -18,15 +18,16 @@
 #endif /* CONFIG_VIRT_CPU_ACCOUNTING_NATIVE */
 
 #ifdef CONFIG_VIRT_CPU_ACCOUNTING_GEN
-extern void task_cputime(struct task_struct *t,
+extern bool task_cputime(struct task_struct *t,
 			 u64 *utime, u64 *stime);
 extern u64 task_gtime(struct task_struct *t);
 #else
-static inline void task_cputime(struct task_struct *t,
+static inline bool task_cputime(struct task_struct *t,
 				u64 *utime, u64 *stime)
 {
 	*utime = t->utime;
 	*stime = t->stime;
+	return false;
 }
 
 static inline u64 task_gtime(struct task_struct *t)
diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index 872e481d5098c..9392aea1804e5 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -615,7 +615,8 @@ void task_cputime_adjusted(struct task_struct *p, u64 *ut, u64 *st)
 		.sum_exec_runtime = p->se.sum_exec_runtime,
 	};
 
-	task_cputime(p, &cputime.utime, &cputime.stime);
+	if (task_cputime(p, &cputime.utime, &cputime.stime))
+		cputime.sum_exec_runtime = task_sched_runtime(p);
 	cputime_adjust(&cputime, &p->prev_cputime, ut, st);
 }
 EXPORT_SYMBOL_GPL(task_cputime_adjusted);
@@ -828,19 +829,21 @@ u64 task_gtime(struct task_struct *t)
  * add up the pending nohz execution time since the last
  * cputime snapshot.
  */
-void task_cputime(struct task_struct *t, u64 *utime, u64 *stime)
+bool task_cputime(struct task_struct *t, u64 *utime, u64 *stime)
 {
 	struct vtime *vtime = &t->vtime;
 	unsigned int seq;
 	u64 delta;
+	int ret;
 
 	if (!vtime_accounting_enabled()) {
 		*utime = t->utime;
 		*stime = t->stime;
-		return;
+		return false;
 	}
 
 	do {
+		ret = false;
 		seq = read_seqcount_begin(&vtime->seqcount);
 
 		*utime = t->utime;
@@ -850,6 +853,7 @@ void task_cputime(struct task_struct *t, u64 *utime, u64 *stime)
 		if (vtime->state < VTIME_SYS)
 			continue;
 
+		ret = true;
 		delta = vtime_delta(vtime);
 
 		/*
@@ -861,6 +865,8 @@ void task_cputime(struct task_struct *t, u64 *utime, u64 *stime)
 		else
 			*utime += vtime->utime + delta;
 	} while (read_seqcount_retry(&vtime->seqcount, seq));
+
+	return ret;
 }
 
 static int vtime_state_fetch(struct vtime *vtime, int cpu)
-- 
2.33.0

