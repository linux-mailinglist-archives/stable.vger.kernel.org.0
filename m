Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A0FC6A3062
	for <lists+stable@lfdr.de>; Sun, 26 Feb 2023 15:49:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbjBZOtV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 09:49:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229990AbjBZOsP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 09:48:15 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 247AC13D54;
        Sun, 26 Feb 2023 06:47:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1C767CE0E89;
        Sun, 26 Feb 2023 14:47:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90A2FC4339B;
        Sun, 26 Feb 2023 14:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677422825;
        bh=mKW1A12ZS2cla0Jz1GSB5CYiwtK/oiTVMH3E4CPrt5w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uz/367iM0TtgTciPUC2g6wuiMMetvNM44PsrurOo7mnPvOs5KAHbrkiFIe/XcgB0Y
         Uv+DlNPyqzkQ45aNjDIR3l6X2dgstwN2PkN2I9+e8khfHHCARW2ItvcK5HQh/+Nmy9
         o6qX9/01wVLNUMvM5H5yHm9QjuCXxUw/kvOz9PLP6p0DT3ahbhMsf7MxIcejeFnnp1
         QF3uHVgoCkfUGxOEAplyE941sF4NGLno8ldQboRmC/QFuIbUtYHxkJJARrnFxhH5no
         hDwwbOJaMymLoPGiRJTK27EmURM82oisV7qvHukS/FnrnXz/VHqowkuVkrm4xJp0kL
         waT9Oej/SjGuA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zqiang <qiang1.zhang@intel.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>, frederic@kernel.org,
        quic_neeraju@quicinc.com, josh@joshtriplett.org,
        rcu@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 07/49] rcu-tasks: Make rude RCU-Tasks work well with CPU hotplug
Date:   Sun, 26 Feb 2023 09:46:07 -0500
Message-Id: <20230226144650.826470-7-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230226144650.826470-1-sashal@kernel.org>
References: <20230226144650.826470-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zqiang <qiang1.zhang@intel.com>

[ Upstream commit ea5c8987fef20a8cca07e428aa28bc64649c5104 ]

The synchronize_rcu_tasks_rude() function invokes rcu_tasks_rude_wait_gp()
to wait one rude RCU-tasks grace period.  The rcu_tasks_rude_wait_gp()
function in turn checks if there is only a single online CPU.  If so, it
will immediately return, because a call to synchronize_rcu_tasks_rude()
is by definition a grace period on a single-CPU system.  (We could
have blocked!)

Unfortunately, this check uses num_online_cpus() without synchronization,
which can result in too-short grace periods.  To see this, consider the
following scenario:

        CPU0                                   CPU1 (going offline)
                                          migration/1 task:
                                      cpu_stopper_thread
                                       -> take_cpu_down
                                          -> _cpu_disable
                                           (dec __num_online_cpus)
                                          ->cpuhp_invoke_callback
                                                preempt_disable
                                                access old_data0
           task1
 del old_data0                                  .....
 synchronize_rcu_tasks_rude()
 task1 schedule out
 ....
 task2 schedule in
 rcu_tasks_rude_wait_gp()
     ->__num_online_cpus == 1
       ->return
 ....
 task1 schedule in
 ->free old_data0
                                                preempt_enable

When CPU1 decrements __num_online_cpus, its value becomes 1.  However,
CPU1 has not finished going offline, and will take one last trip through
the scheduler and the idle loop before it actually stops executing
instructions.  Because synchronize_rcu_tasks_rude() is mostly used for
tracing, and because both the scheduler and the idle loop can be traced,
this means that CPU0's prematurely ended grace period might disrupt the
tracing on CPU1.  Given that this disruption might include CPU1 executing
instructions in memory that was just now freed (and maybe reallocated),
this is a matter of some concern.

This commit therefore removes that problematic single-CPU check from the
rcu_tasks_rude_wait_gp() function.  This dispenses with the single-CPU
optimization, but there is no evidence indicating that this optimization
is important.  In addition, synchronize_rcu_tasks_generic() contains a
similar optimization (albeit only for early boot), which also splats.
(As in exactly why are you invoking synchronize_rcu_tasks_rude() so
early in boot, anyway???)

It is OK for the synchronize_rcu_tasks_rude() function's check to be
unsynchronized because the only times that this check can evaluate to
true is when there is only a single CPU running with preemption
disabled.

While in the area, this commit also fixes a minor bug in which a
call to synchronize_rcu_tasks_rude() would instead be attributed to
synchronize_rcu_tasks().

[ paulmck: Add "synchronize_" prefix and "()" suffix. ]

Signed-off-by: Zqiang <qiang1.zhang@intel.com>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/tasks.h | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/kernel/rcu/tasks.h b/kernel/rcu/tasks.h
index f5bf6fb430dab..727e09909e403 100644
--- a/kernel/rcu/tasks.h
+++ b/kernel/rcu/tasks.h
@@ -560,8 +560,9 @@ static int __noreturn rcu_tasks_kthread(void *arg)
 static void synchronize_rcu_tasks_generic(struct rcu_tasks *rtp)
 {
 	/* Complain if the scheduler has not started.  */
-	WARN_ONCE(rcu_scheduler_active == RCU_SCHEDULER_INACTIVE,
-			 "synchronize_rcu_tasks called too soon");
+	if (WARN_ONCE(rcu_scheduler_active == RCU_SCHEDULER_INACTIVE,
+			 "synchronize_%s() called too soon", rtp->name))
+		return;
 
 	// If the grace-period kthread is running, use it.
 	if (READ_ONCE(rtp->kthread_ptr)) {
@@ -1036,9 +1037,6 @@ static void rcu_tasks_be_rude(struct work_struct *work)
 // Wait for one rude RCU-tasks grace period.
 static void rcu_tasks_rude_wait_gp(struct rcu_tasks *rtp)
 {
-	if (num_online_cpus() <= 1)
-		return;	// Fastpath for only one CPU.
-
 	rtp->n_ipis += cpumask_weight(cpu_online_mask);
 	schedule_on_each_cpu(rcu_tasks_be_rude);
 }
-- 
2.39.0

