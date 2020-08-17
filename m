Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1C2E247271
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 20:42:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730949AbgHQSmu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 14:42:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:44636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388097AbgHQP5K (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:57:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D4DC620885;
        Mon, 17 Aug 2020 15:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597679821;
        bh=9lydp8hjxOFrZPhNQnlx2zjaziqBxM76PYiRf3Woj4k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TDHkEEWdPjbiRDpbQ6phXOGYLYCV/JS/NRg1Wk4Sz8vE3Mzr+/492RmapUph0Jeu8
         amFytFu5xBzb/dvLz18bgOkkFN0tQw7bLN6egXD4meeNydyYsdHIwUXHCb7kiTOFN/
         a/LIMtUKBsuBmaksub6w5jjbF1pKIpdVvmtyi7oY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matt Fleming <matt@codeblueprint.co.uk>,
        Frederic Weisbecker <frederic@kernel.org>, stable@kernel.org,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 5.7 345/393] tick/nohz: Narrow down noise while setting current tasks tick dependency
Date:   Mon, 17 Aug 2020 17:16:35 +0200
Message-Id: <20200817143836.335532888@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143819.579311991@linuxfoundation.org>
References: <20200817143819.579311991@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frederic Weisbecker <frederic@kernel.org>

commit 3c8920e2dbd1a55f72dc14d656df9d0097cf5c72 upstream.

Setting a tick dependency on any task, including the case where a task
sets that dependency on itself, triggers an IPI to all CPUs.  That is
of course suboptimal but it had previously not been an issue because it
was only used by POSIX CPU timers on nohz_full, which apparently never
occurs in latency-sensitive workloads in production.  (Or users of such
systems are suffering in silence on the one hand or venting their ire
on the wrong people on the other.)

But RCU now sets a task tick dependency on the current task in order
to fix stall issues that can occur during RCU callback processing.
Thus, RCU callback processing triggers frequent system-wide IPIs from
nohz_full CPUs.  This is quite counter-productive, after all, avoiding
IPIs is what nohz_full is supposed to be all about.

This commit therefore optimizes tasks' self-setting of a task tick
dependency by using tick_nohz_full_kick() to avoid the system-wide IPI.
Instead, only the execution of the one task is disturbed, which is
acceptable given that this disturbance is well down into the noise
compared to the degree to which the RCU callback processing itself
disturbs execution.

Fixes: 6a949b7af82d (rcu: Force on tick when invoking lots of callbacks)
Reported-by: Matt Fleming <matt@codeblueprint.co.uk>
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Cc: stable@kernel.org
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/time/tick-sched.c |   22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -351,16 +351,24 @@ void tick_nohz_dep_clear_cpu(int cpu, en
 EXPORT_SYMBOL_GPL(tick_nohz_dep_clear_cpu);
 
 /*
- * Set a per-task tick dependency. Posix CPU timers need this in order to elapse
- * per task timers.
+ * Set a per-task tick dependency. RCU need this. Also posix CPU timers
+ * in order to elapse per task timers.
  */
 void tick_nohz_dep_set_task(struct task_struct *tsk, enum tick_dep_bits bit)
 {
-	/*
-	 * We could optimize this with just kicking the target running the task
-	 * if that noise matters for nohz full users.
-	 */
-	tick_nohz_dep_set_all(&tsk->tick_dep_mask, bit);
+	if (!atomic_fetch_or(BIT(bit), &tsk->tick_dep_mask)) {
+		if (tsk == current) {
+			preempt_disable();
+			tick_nohz_full_kick();
+			preempt_enable();
+		} else {
+			/*
+			 * Some future tick_nohz_full_kick_task()
+			 * should optimize this.
+			 */
+			tick_nohz_full_kick_all();
+		}
+	}
 }
 EXPORT_SYMBOL_GPL(tick_nohz_dep_set_task);
 


