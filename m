Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9562315EAD0
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:17:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391990AbgBNRQR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:16:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:39020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391877AbgBNQL5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:11:57 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8D36222C2;
        Fri, 14 Feb 2020 16:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696716;
        bh=+2u6VCYeEc6ZE9pvV3ZpiM8JNxbrXYBB8tjL4aeEA3s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RLgFKLQtnejhjC9HxOWBEM1PgM9FwOwSwlnwONl7viGtmTH7dzTyLiho/gD7Pg2fm
         OP1PlEFQn9WR5Tv8FEo9ACyVk3coi/Dq2Btt/qCZHQTczFtqHhDDwDDe/8gSZXF+Nv
         M2QOS+TN8GqNUO03fRTc2MDxais/mILAXbIKiRU8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@kernel.org>, Tejun Heo <tj@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 006/252] cpu/hotplug, stop_machine: Fix stop_machine vs hotplug order
Date:   Fri, 14 Feb 2020 11:07:41 -0500
Message-Id: <20200214161147.15842-6-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214161147.15842-1-sashal@kernel.org>
References: <20200214161147.15842-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 45178ac0cea853fe0e405bf11e101bdebea57b15 ]

Paul reported a very sporadic, rcutorture induced, workqueue failure.
When the planets align, the workqueue rescuer's self-migrate fails and
then triggers a WARN for running a work on the wrong CPU.

Tejun then figured that set_cpus_allowed_ptr()'s stop_one_cpu() call
could be ignored! When stopper->enabled is false, stop_machine will
insta complete the work, without actually doing the work. Worse, it
will not WARN about this (we really should fix this).

It turns out there is a small window where a freshly online'ed CPU is
marked 'online' but doesn't yet have the stopper task running:

	BP				AP

	bringup_cpu()
	  __cpu_up(cpu, idle)	 -->	start_secondary()
					...
					cpu_startup_entry()
	  bringup_wait_for_ap()
	    wait_for_ap_thread() <--	  cpuhp_online_idle()
					  while (1)
					    do_idle()

					... available to run kthreads ...

	    stop_machine_unpark()
	      stopper->enable = true;

Close this by moving the stop_machine_unpark() into
cpuhp_online_idle(), such that the stopper thread is ready before we
start the idle loop and schedule.

Reported-by: "Paul E. McKenney" <paulmck@kernel.org>
Debugged-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: "Paul E. McKenney" <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cpu.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index 8d6b8b5493f9f..2d850eaaf82e3 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -493,8 +493,7 @@ static int bringup_wait_for_ap(unsigned int cpu)
 	if (WARN_ON_ONCE((!cpu_online(cpu))))
 		return -ECANCELED;
 
-	/* Unpark the stopper thread and the hotplug thread of the target cpu */
-	stop_machine_unpark(cpu);
+	/* Unpark the hotplug thread of the target cpu */
 	kthread_unpark(st->thread);
 
 	/*
@@ -1048,8 +1047,8 @@ void notify_cpu_starting(unsigned int cpu)
 
 /*
  * Called from the idle task. Wake up the controlling task which brings the
- * stopper and the hotplug thread of the upcoming CPU up and then delegates
- * the rest of the online bringup to the hotplug thread.
+ * hotplug thread of the upcoming CPU up and then delegates the rest of the
+ * online bringup to the hotplug thread.
  */
 void cpuhp_online_idle(enum cpuhp_state state)
 {
@@ -1059,6 +1058,12 @@ void cpuhp_online_idle(enum cpuhp_state state)
 	if (state != CPUHP_AP_ONLINE_IDLE)
 		return;
 
+	/*
+	 * Unpart the stopper thread before we start the idle loop (and start
+	 * scheduling); this ensures the stopper task is always available.
+	 */
+	stop_machine_unpark(smp_processor_id());
+
 	st->state = CPUHP_AP_ONLINE_IDLE;
 	complete_ap_thread(st, true);
 }
-- 
2.20.1

