Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D9CE177FD2
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 19:58:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732272AbgCCRxD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:53:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:33358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732260AbgCCRxA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:53:00 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 32D4B206D5;
        Tue,  3 Mar 2020 17:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583257977;
        bh=l50NZA9oJ0p6Gllzz/XT7sP8w5HvfBl6UrumDnSHawA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HrOU7Bo9XnemMxeGwoAGqSmG0C2vcDvv2gVQGUvDNQyQGlezODw1wLmUKlrbLFwEN
         HwtMYEOh5670jaKVJzMymv8HZN6fKDqyC752yFPd+1BsRHdcOby5SimOPfw7oOwGWH
         t7ujIOZbLYE1OSGkYtDvokl4CDyBPM/eMVowKSlk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Scott Wood <swood@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 025/152] timers/nohz: Update NOHZ load in remote tick
Date:   Tue,  3 Mar 2020 18:42:03 +0100
Message-Id: <20200303174305.307542139@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174302.523080016@linuxfoundation.org>
References: <20200303174302.523080016@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra (Intel) <peterz@infradead.org>

[ Upstream commit ebc0f83c78a2d26384401ecf2d2fa48063c0ee27 ]

The way loadavg is tracked during nohz only pays attention to the load
upon entering nohz.  This can be particularly noticeable if full nohz is
entered while non-idle, and then the cpu goes idle and stays that way for
a long time.

Use the remote tick to ensure that full nohz cpus report their deltas
within a reasonable time.

[ swood: Added changelog and removed recheck of stopped tick. ]

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Scott Wood <swood@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lkml.kernel.org/r/1578736419-14628-3-git-send-email-swood@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sched/nohz.h |  2 ++
 kernel/sched/core.c        |  4 +++-
 kernel/sched/loadavg.c     | 33 +++++++++++++++++++++++----------
 3 files changed, 28 insertions(+), 11 deletions(-)

diff --git a/include/linux/sched/nohz.h b/include/linux/sched/nohz.h
index 1abe91ff6e4a2..6d67e9a5af6bb 100644
--- a/include/linux/sched/nohz.h
+++ b/include/linux/sched/nohz.h
@@ -15,9 +15,11 @@ static inline void nohz_balance_enter_idle(int cpu) { }
 
 #ifdef CONFIG_NO_HZ_COMMON
 void calc_load_nohz_start(void);
+void calc_load_nohz_remote(struct rq *rq);
 void calc_load_nohz_stop(void);
 #else
 static inline void calc_load_nohz_start(void) { }
+static inline void calc_load_nohz_remote(struct rq *rq) { }
 static inline void calc_load_nohz_stop(void) { }
 #endif /* CONFIG_NO_HZ_COMMON */
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 067ac465a4b25..8c89c893078af 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3676,6 +3676,7 @@ static void sched_tick_remote(struct work_struct *work)
 	if (cpu_is_offline(cpu))
 		goto out_unlock;
 
+	curr = rq->curr;
 	update_rq_clock(rq);
 
 	if (!is_idle_task(curr)) {
@@ -3688,10 +3689,11 @@ static void sched_tick_remote(struct work_struct *work)
 	}
 	curr->sched_class->task_tick(rq, curr, 0);
 
+	calc_load_nohz_remote(rq);
 out_unlock:
 	rq_unlock_irq(rq, &rf);
-
 out_requeue:
+
 	/*
 	 * Run the remote tick once per second (1Hz). This arbitrary
 	 * frequency is large enough to avoid overload but short enough
diff --git a/kernel/sched/loadavg.c b/kernel/sched/loadavg.c
index 28a516575c181..de22da666ac73 100644
--- a/kernel/sched/loadavg.c
+++ b/kernel/sched/loadavg.c
@@ -231,16 +231,11 @@ static inline int calc_load_read_idx(void)
 	return calc_load_idx & 1;
 }
 
-void calc_load_nohz_start(void)
+static void calc_load_nohz_fold(struct rq *rq)
 {
-	struct rq *this_rq = this_rq();
 	long delta;
 
-	/*
-	 * We're going into NO_HZ mode, if there's any pending delta, fold it
-	 * into the pending NO_HZ delta.
-	 */
-	delta = calc_load_fold_active(this_rq, 0);
+	delta = calc_load_fold_active(rq, 0);
 	if (delta) {
 		int idx = calc_load_write_idx();
 
@@ -248,6 +243,24 @@ void calc_load_nohz_start(void)
 	}
 }
 
+void calc_load_nohz_start(void)
+{
+	/*
+	 * We're going into NO_HZ mode, if there's any pending delta, fold it
+	 * into the pending NO_HZ delta.
+	 */
+	calc_load_nohz_fold(this_rq());
+}
+
+/*
+ * Keep track of the load for NOHZ_FULL, must be called between
+ * calc_load_nohz_{start,stop}().
+ */
+void calc_load_nohz_remote(struct rq *rq)
+{
+	calc_load_nohz_fold(rq);
+}
+
 void calc_load_nohz_stop(void)
 {
 	struct rq *this_rq = this_rq();
@@ -268,7 +281,7 @@ void calc_load_nohz_stop(void)
 		this_rq->calc_load_update += LOAD_FREQ;
 }
 
-static long calc_load_nohz_fold(void)
+static long calc_load_nohz_read(void)
 {
 	int idx = calc_load_read_idx();
 	long delta = 0;
@@ -323,7 +336,7 @@ static void calc_global_nohz(void)
 }
 #else /* !CONFIG_NO_HZ_COMMON */
 
-static inline long calc_load_nohz_fold(void) { return 0; }
+static inline long calc_load_nohz_read(void) { return 0; }
 static inline void calc_global_nohz(void) { }
 
 #endif /* CONFIG_NO_HZ_COMMON */
@@ -346,7 +359,7 @@ void calc_global_load(unsigned long ticks)
 	/*
 	 * Fold the 'old' NO_HZ-delta to include all NO_HZ CPUs.
 	 */
-	delta = calc_load_nohz_fold();
+	delta = calc_load_nohz_read();
 	if (delta)
 		atomic_long_add(delta, &calc_load_tasks);
 
-- 
2.20.1



