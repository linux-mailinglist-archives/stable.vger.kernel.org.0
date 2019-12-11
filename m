Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DBDA11B77A
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 17:09:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731091AbfLKPMT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:12:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:33634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731083AbfLKPMS (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:12:18 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F5DD2465B;
        Wed, 11 Dec 2019 15:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077137;
        bh=zQiU5dKwHOVRXTN0rVnNamHfzml94EObSwNzq6VHy0k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2b0Q2Nu52JuT65VBZPg33Y7Sx7jY9EENYN4Xcs3d7aJqS4uJrrBJ62Xf/aLhOzd4e
         PtYShHhLtEiW3cXP4tVODnSNi4kKcM13ZfeVa20O/oUvnhwoudM+gc6dDsLgMvZixd
         g0DZFcj8hmIuTtncqm9KU7ZpBtozBzFBGnsHWNQ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vincent Guittot <vincent.guittot@linaro.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, dietmar.eggemann@arm.com,
        dsmythies@telus.net, juri.lelli@redhat.com, mgorman@suse.de,
        rostedt@goodmis.org, Ingo Molnar <mingo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 030/105] sched/pelt: Fix update of blocked PELT ordering
Date:   Wed, 11 Dec 2019 16:05:19 +0100
Message-Id: <20191211150230.499055068@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150221.153659747@linuxfoundation.org>
References: <20191211150221.153659747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Guittot <vincent.guittot@linaro.org>

[ Upstream commit b90f7c9d2198d789709390280a43e0a46345682b ]

update_cfs_rq_load_avg() can call cpufreq_update_util() to trigger an
update of the frequency. Make sure that RT, DL and IRQ PELT signals have
been updated before calling cpufreq.

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: dietmar.eggemann@arm.com
Cc: dsmythies@telus.net
Cc: juri.lelli@redhat.com
Cc: mgorman@suse.de
Cc: rostedt@goodmis.org
Fixes: 371bf4273269 ("sched/rt: Add rt_rq utilization tracking")
Fixes: 3727e0e16340 ("sched/dl: Add dl_rq utilization tracking")
Fixes: 91c27493e78d ("sched/irq: Add IRQ utilization tracking")
Link: https://lkml.kernel.org/r/1572434309-32512-1-git-send-email-vincent.guittot@linaro.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 649c6b60929e2..ba7cc68a39935 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -7530,6 +7530,19 @@ static void update_blocked_averages(int cpu)
 	rq_lock_irqsave(rq, &rf);
 	update_rq_clock(rq);
 
+	/*
+	 * update_cfs_rq_load_avg() can call cpufreq_update_util(). Make sure
+	 * that RT, DL and IRQ signals have been updated before updating CFS.
+	 */
+	curr_class = rq->curr->sched_class;
+	update_rt_rq_load_avg(rq_clock_pelt(rq), rq, curr_class == &rt_sched_class);
+	update_dl_rq_load_avg(rq_clock_pelt(rq), rq, curr_class == &dl_sched_class);
+	update_irq_load_avg(rq, 0);
+
+	/* Don't need periodic decay once load/util_avg are null */
+	if (others_have_blocked(rq))
+		done = false;
+
 	/*
 	 * Iterates the task_group tree in a bottom up fashion, see
 	 * list_add_leaf_cfs_rq() for details.
@@ -7557,14 +7570,6 @@ static void update_blocked_averages(int cpu)
 			done = false;
 	}
 
-	curr_class = rq->curr->sched_class;
-	update_rt_rq_load_avg(rq_clock_pelt(rq), rq, curr_class == &rt_sched_class);
-	update_dl_rq_load_avg(rq_clock_pelt(rq), rq, curr_class == &dl_sched_class);
-	update_irq_load_avg(rq, 0);
-	/* Don't need periodic decay once load/util_avg are null */
-	if (others_have_blocked(rq))
-		done = false;
-
 	update_blocked_load_status(rq, !done);
 	rq_unlock_irqrestore(rq, &rf);
 }
@@ -7625,12 +7630,18 @@ static inline void update_blocked_averages(int cpu)
 
 	rq_lock_irqsave(rq, &rf);
 	update_rq_clock(rq);
-	update_cfs_rq_load_avg(cfs_rq_clock_pelt(cfs_rq), cfs_rq);
 
+	/*
+	 * update_cfs_rq_load_avg() can call cpufreq_update_util(). Make sure
+	 * that RT, DL and IRQ signals have been updated before updating CFS.
+	 */
 	curr_class = rq->curr->sched_class;
 	update_rt_rq_load_avg(rq_clock_pelt(rq), rq, curr_class == &rt_sched_class);
 	update_dl_rq_load_avg(rq_clock_pelt(rq), rq, curr_class == &dl_sched_class);
 	update_irq_load_avg(rq, 0);
+
+	update_cfs_rq_load_avg(cfs_rq_clock_pelt(cfs_rq), cfs_rq);
+
 	update_blocked_load_status(rq, cfs_rq_has_blocked(cfs_rq) || others_have_blocked(rq));
 	rq_unlock_irqrestore(rq, &rf);
 }
-- 
2.20.1



