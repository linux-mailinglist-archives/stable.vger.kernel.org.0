Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B23602C086D
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:16:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732717AbgKWMvK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:51:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:35284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387589AbgKWMue (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:50:34 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B67F8208C3;
        Mon, 23 Nov 2020 12:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135831;
        bh=Kpjv2vjdVuB+jkxDA0Kv2AL1fh/ayi1VCR2Z6onj4sw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dbMCncvytmChhF1xDNVl/k/6VsAxQyYlaFi5Sg+r9SY2hZT0CKKjKsQK9W+Z1qe/8
         HrC46RJQy5TI17/SH6AHm3txwV6mrus4NdTGBqGm4g95zPw/UBNwD5BZg+Qph4+gRd
         /Vs8q3Yk4NE0i0oN4nE5ncem+bTR6yoMvYec0/00=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 182/252] sched: Fix rq->nr_iowait ordering
Date:   Mon, 23 Nov 2020 13:22:12 +0100
Message-Id: <20201123121844.378746555@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit ec618b84f6e15281cc3660664d34cd0dd2f2579e ]

  schedule()				ttwu()
    deactivate_task();			  if (p->on_rq && ...) // false
					    atomic_dec(&task_rq(p)->nr_iowait);
    if (prev->in_iowait)
      atomic_inc(&rq->nr_iowait);

Allows nr_iowait to be decremented before it gets incremented,
resulting in more dodgy IO-wait numbers than usual.

Note that because we can now do ttwu_queue_wakelist() before
p->on_cpu==0, we lose the natural ordering and have to further delay
the decrement.

Fixes: c6e7bd7afaeb ("sched/core: Optimize ttwu() spinning on p->on_cpu")
Reported-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Link: https://lkml.kernel.org/r/20201117093829.GD3121429@hirez.programming.kicks-ass.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/core.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index b1e0da56abcac..c4da7e17b9061 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2505,7 +2505,12 @@ ttwu_do_activate(struct rq *rq, struct task_struct *p, int wake_flags,
 #ifdef CONFIG_SMP
 	if (wake_flags & WF_MIGRATED)
 		en_flags |= ENQUEUE_MIGRATED;
+	else
 #endif
+	if (p->in_iowait) {
+		delayacct_blkio_end(p);
+		atomic_dec(&task_rq(p)->nr_iowait);
+	}
 
 	activate_task(rq, p, en_flags);
 	ttwu_do_wakeup(rq, p, wake_flags, rf);
@@ -2892,11 +2897,6 @@ try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags)
 	if (READ_ONCE(p->on_rq) && ttwu_runnable(p, wake_flags))
 		goto unlock;
 
-	if (p->in_iowait) {
-		delayacct_blkio_end(p);
-		atomic_dec(&task_rq(p)->nr_iowait);
-	}
-
 #ifdef CONFIG_SMP
 	/*
 	 * Ensure we load p->on_cpu _after_ p->on_rq, otherwise it would be
@@ -2967,6 +2967,11 @@ try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags)
 
 	cpu = select_task_rq(p, p->wake_cpu, SD_BALANCE_WAKE, wake_flags);
 	if (task_cpu(p) != cpu) {
+		if (p->in_iowait) {
+			delayacct_blkio_end(p);
+			atomic_dec(&task_rq(p)->nr_iowait);
+		}
+
 		wake_flags |= WF_MIGRATED;
 		psi_ttwu_dequeue(p);
 		set_task_cpu(p, cpu);
-- 
2.27.0



