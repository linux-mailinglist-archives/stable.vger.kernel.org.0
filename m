Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BA08472EE5
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 15:21:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234420AbhLMOU5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 09:20:57 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:35458 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234255AbhLMOUu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 09:20:50 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 13A72B80EAF;
        Mon, 13 Dec 2021 14:20:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9D22C34604;
        Mon, 13 Dec 2021 14:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639405247;
        bh=MyO2f7bt77iRe95/2SVYq72DkKQD8HmpFJPLuKI8Eb4=;
        h=From:To:Cc:Subject:Date:From;
        b=pX2/OD7D6A4bT/P6D3wbz4RpSz9lJSel6WuOW9f2pYisMczVDrnk/UuSS936NZe/K
         2h7+KdE/cIN4qtHw1rYPRhlMPomEfOFT3AlKcr9IMoJ+q6eLnCxvNevplci8KrCxUj
         KSzTsT8FhzwfySSYaOf0fSdTx+ZOd3C1rI3U8Xo5gdmoSxTaO/cqXXnkFTDKOG3xja
         EixcyAB7TYC5knCrRvvPr08f/fDZn85g112QvMUWG/uuh1bMY4DnAhUxRZLtaTQd/4
         rwGyBtHvyQVVteKPFTOATVnhQQxAkevC5W6NykEDpwUTBwBMfowcICvxLXRurvLOvY
         vdTmyk7utjKIQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Frederic Weisbecker <frederic@kernel.org>,
        Hasegawa Hitomi <hasegawa-hitomi@fujitsu.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>,
        Phil Auld <pauld@redhat.com>, Sasha Levin <sashal@kernel.org>,
        mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com,
        vincent.guittot@linaro.org
Subject: [PATCH MANUALSEL 4.19] sched/cputime: Fix getrusage(RUSAGE_THREAD) with nohz_full
Date:   Mon, 13 Dec 2021 09:20:43 -0500
Message-Id: <20211213142045.352478-1-sashal@kernel.org>
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
index 53f883f5a2fd1..4dd0505a39fa7 100644
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
index 54eb9457b21d3..5d2e978d51d0a 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -665,7 +665,8 @@ void task_cputime_adjusted(struct task_struct *p, u64 *ut, u64 *st)
 		.sum_exec_runtime = p->se.sum_exec_runtime,
 	};
 
-	task_cputime(p, &cputime.utime, &cputime.stime);
+	if (task_cputime(p, &cputime.utime, &cputime.stime))
+		cputime.sum_exec_runtime = task_sched_runtime(p);
 	cputime_adjust(&cputime, &p->prev_cputime, ut, st);
 }
 EXPORT_SYMBOL_GPL(task_cputime_adjusted);
@@ -858,19 +859,21 @@ u64 task_gtime(struct task_struct *t)
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
@@ -880,6 +883,7 @@ void task_cputime(struct task_struct *t, u64 *utime, u64 *stime)
 		if (vtime->state == VTIME_INACTIVE || is_idle_task(t))
 			continue;
 
+		ret = true;
 		delta = vtime_delta(vtime);
 
 		/*
@@ -891,5 +895,7 @@ void task_cputime(struct task_struct *t, u64 *utime, u64 *stime)
 		else if (vtime->state == VTIME_SYS)
 			*stime += vtime->stime + delta;
 	} while (read_seqcount_retry(&vtime->seqcount, seq));
+
+	return ret;
 }
 #endif /* CONFIG_VIRT_CPU_ACCOUNTING_GEN */
-- 
2.33.0

