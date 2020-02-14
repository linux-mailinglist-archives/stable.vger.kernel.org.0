Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B974E15EF4A
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:47:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389254AbgBNRqy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:46:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:48108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389236AbgBNQCE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:02:04 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A1132067D;
        Fri, 14 Feb 2020 16:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696123;
        bh=VAEiBAgjy/gCmBix35/puJS0Yzce1xq9F45YjCo8c9o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gTOsBgnFchYyTs3dreKaIfnAKJvQe/Y3D0IP5qRy3DKknrt1d/LOSWuDZ3JK+Y/uw
         Gt7FTjueK4+0JF0G2VX7Fwil8pixOJgMCSQH4tMCvrdj2axyFZNm2Q7z4b+jqTfqnH
         rGzOmJMafKx+iHlvlJnUVeZpdP8ApTORqIZBlmpI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marco Elver <elver@google.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Ingo Molnar <mingo@redhat.com>,
        Dmitry Vyukov <dvyukov@google.com>, rcu@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 010/459] rcu: Fix data-race due to atomic_t copy-by-value
Date:   Fri, 14 Feb 2020 10:54:20 -0500
Message-Id: <20200214160149.11681-10-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marco Elver <elver@google.com>

[ Upstream commit 6cf539a87a61a4fbc43f625267dbcbcf283872ed ]

This fixes a data-race where `atomic_t dynticks` is copied by value. The
copy is performed non-atomically, resulting in a data-race if `dynticks`
is updated concurrently.

This data-race was found with KCSAN:
==================================================================
BUG: KCSAN: data-race in dyntick_save_progress_counter / rcu_irq_enter

write to 0xffff989dbdbe98e0 of 4 bytes by task 10 on cpu 3:
 atomic_add_return include/asm-generic/atomic-instrumented.h:78 [inline]
 rcu_dynticks_snap kernel/rcu/tree.c:310 [inline]
 dyntick_save_progress_counter+0x43/0x1b0 kernel/rcu/tree.c:984
 force_qs_rnp+0x183/0x200 kernel/rcu/tree.c:2286
 rcu_gp_fqs kernel/rcu/tree.c:1601 [inline]
 rcu_gp_fqs_loop+0x71/0x880 kernel/rcu/tree.c:1653
 rcu_gp_kthread+0x22c/0x3b0 kernel/rcu/tree.c:1799
 kthread+0x1b5/0x200 kernel/kthread.c:255
 <snip>

read to 0xffff989dbdbe98e0 of 4 bytes by task 154 on cpu 7:
 rcu_nmi_enter_common kernel/rcu/tree.c:828 [inline]
 rcu_irq_enter+0xda/0x240 kernel/rcu/tree.c:870
 irq_enter+0x5/0x50 kernel/softirq.c:347
 <snip>

Reported by Kernel Concurrency Sanitizer on:
CPU: 7 PID: 154 Comm: kworker/7:1H Not tainted 5.3.0+ #5
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-1 04/01/2014
Workqueue: kblockd blk_mq_run_work_fn
==================================================================

Signed-off-by: Marco Elver <elver@google.com>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: rcu@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Reviewed-by: Joel Fernandes (Google) <joel@joelfernandes.org>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/trace/events/rcu.h |  4 ++--
 kernel/rcu/tree.c          | 11 ++++++-----
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/include/trace/events/rcu.h b/include/trace/events/rcu.h
index 694bd040cf51a..fdd31c5fd1265 100644
--- a/include/trace/events/rcu.h
+++ b/include/trace/events/rcu.h
@@ -442,7 +442,7 @@ TRACE_EVENT_RCU(rcu_fqs,
  */
 TRACE_EVENT_RCU(rcu_dyntick,
 
-	TP_PROTO(const char *polarity, long oldnesting, long newnesting, atomic_t dynticks),
+	TP_PROTO(const char *polarity, long oldnesting, long newnesting, int dynticks),
 
 	TP_ARGS(polarity, oldnesting, newnesting, dynticks),
 
@@ -457,7 +457,7 @@ TRACE_EVENT_RCU(rcu_dyntick,
 		__entry->polarity = polarity;
 		__entry->oldnesting = oldnesting;
 		__entry->newnesting = newnesting;
-		__entry->dynticks = atomic_read(&dynticks);
+		__entry->dynticks = dynticks;
 	),
 
 	TP_printk("%s %lx %lx %#3x", __entry->polarity,
diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 81105141b6a82..62e59596a30a0 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -576,7 +576,7 @@ static void rcu_eqs_enter(bool user)
 	}
 
 	lockdep_assert_irqs_disabled();
-	trace_rcu_dyntick(TPS("Start"), rdp->dynticks_nesting, 0, rdp->dynticks);
+	trace_rcu_dyntick(TPS("Start"), rdp->dynticks_nesting, 0, atomic_read(&rdp->dynticks));
 	WARN_ON_ONCE(IS_ENABLED(CONFIG_RCU_EQS_DEBUG) && !user && !is_idle_task(current));
 	rdp = this_cpu_ptr(&rcu_data);
 	do_nocb_deferred_wakeup(rdp);
@@ -649,14 +649,15 @@ static __always_inline void rcu_nmi_exit_common(bool irq)
 	 * leave it in non-RCU-idle state.
 	 */
 	if (rdp->dynticks_nmi_nesting != 1) {
-		trace_rcu_dyntick(TPS("--="), rdp->dynticks_nmi_nesting, rdp->dynticks_nmi_nesting - 2, rdp->dynticks);
+		trace_rcu_dyntick(TPS("--="), rdp->dynticks_nmi_nesting, rdp->dynticks_nmi_nesting - 2,
+				  atomic_read(&rdp->dynticks));
 		WRITE_ONCE(rdp->dynticks_nmi_nesting, /* No store tearing. */
 			   rdp->dynticks_nmi_nesting - 2);
 		return;
 	}
 
 	/* This NMI interrupted an RCU-idle CPU, restore RCU-idleness. */
-	trace_rcu_dyntick(TPS("Startirq"), rdp->dynticks_nmi_nesting, 0, rdp->dynticks);
+	trace_rcu_dyntick(TPS("Startirq"), rdp->dynticks_nmi_nesting, 0, atomic_read(&rdp->dynticks));
 	WRITE_ONCE(rdp->dynticks_nmi_nesting, 0); /* Avoid store tearing. */
 
 	if (irq)
@@ -743,7 +744,7 @@ static void rcu_eqs_exit(bool user)
 	rcu_dynticks_task_exit();
 	rcu_dynticks_eqs_exit();
 	rcu_cleanup_after_idle();
-	trace_rcu_dyntick(TPS("End"), rdp->dynticks_nesting, 1, rdp->dynticks);
+	trace_rcu_dyntick(TPS("End"), rdp->dynticks_nesting, 1, atomic_read(&rdp->dynticks));
 	WARN_ON_ONCE(IS_ENABLED(CONFIG_RCU_EQS_DEBUG) && !user && !is_idle_task(current));
 	WRITE_ONCE(rdp->dynticks_nesting, 1);
 	WARN_ON_ONCE(rdp->dynticks_nmi_nesting);
@@ -827,7 +828,7 @@ static __always_inline void rcu_nmi_enter_common(bool irq)
 	}
 	trace_rcu_dyntick(incby == 1 ? TPS("Endirq") : TPS("++="),
 			  rdp->dynticks_nmi_nesting,
-			  rdp->dynticks_nmi_nesting + incby, rdp->dynticks);
+			  rdp->dynticks_nmi_nesting + incby, atomic_read(&rdp->dynticks));
 	WRITE_ONCE(rdp->dynticks_nmi_nesting, /* Prevent store tearing. */
 		   rdp->dynticks_nmi_nesting + incby);
 	barrier();
-- 
2.20.1

