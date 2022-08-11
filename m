Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40E7C5900CD
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 17:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235695AbiHKPq0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 11:46:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236670AbiHKPqE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 11:46:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6095949B6A;
        Thu, 11 Aug 2022 08:40:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 149DCB82123;
        Thu, 11 Aug 2022 15:40:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8062C433C1;
        Thu, 11 Aug 2022 15:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660232421;
        bh=dk42DaDuQOkb0gYVLaWsFmO3MuTUwAa80XBuoCtuws8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cyIYOIJaLHjUpsNyAGhSK/OQktvWu/YtvDYGajraJirIbqS8OQKh4QWhAPVHBOew7
         7OVFG66vqNzsnyU+eLu2Be/ES4DLRFF5cBmdI7whNMbyPtUGxbfH5juX2N/W8r3Qh8
         g8ErkuCaTE631KkujeuFQ84kAdMaZQAUpa4K3snz5ggXiiM1ay6WxHwIliR9RR3Kk6
         jvYsZFkITqHAPBYE8NFjvNbGpyimHp15nUEEvFiFxjsAtRjLG1lIPLvqUcQ7bRcrxC
         Iu1Y40CyD0nWreiI7tJCmZ2Xg5FGrk1mImj1fR3FgtoRbyCVgR2hFwk1tVzdDOv46D
         obPgalPwaw+zg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Patrick Wang <patrick.wang.shcn@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Neeraj Upadhyay <quic_neeraju@quicinc.com>,
        Sasha Levin <sashal@kernel.org>, frederic@kernel.org,
        josh@joshtriplett.org, rcu@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 078/105] rcu: Avoid tracing a few functions executed in stop machine
Date:   Thu, 11 Aug 2022 11:28:02 -0400
Message-Id: <20220811152851.1520029-78-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811152851.1520029-1-sashal@kernel.org>
References: <20220811152851.1520029-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Patrick Wang <patrick.wang.shcn@gmail.com>

[ Upstream commit 48f8070f5dd8e13148ae4647780a452d53c457a2 ]

Stop-machine recently started calling additional functions while waiting:

----------------------------------------------------------------
Former stop machine wait loop:
do {
    cpu_relax(); => macro
    ...
} while (curstate != STOPMACHINE_EXIT);
-----------------------------------------------------------------
Current stop machine wait loop:
do {
    stop_machine_yield(cpumask); => function (notraced)
    ...
    touch_nmi_watchdog(); => function (notraced, inside calls also notraced)
    ...
    rcu_momentary_dyntick_idle(); => function (notraced, inside calls traced)
} while (curstate != MULTI_STOP_EXIT);
------------------------------------------------------------------

These functions (and the functions that they call) must be marked
notrace to prevent them from being updated while they are executing.
The consequences of failing to mark these functions can be severe:

  rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
  rcu: 	1-...!: (0 ticks this GP) idle=14f/1/0x4000000000000000 softirq=3397/3397 fqs=0
  rcu: 	3-...!: (0 ticks this GP) idle=ee9/1/0x4000000000000000 softirq=5168/5168 fqs=0
  	(detected by 0, t=8137 jiffies, g=5889, q=2 ncpus=4)
  Task dump for CPU 1:
  task:migration/1     state:R  running task     stack:    0 pid:   19 ppid:     2 flags:0x00000000
  Stopper: multi_cpu_stop+0x0/0x18c <- stop_machine_cpuslocked+0x128/0x174
  Call Trace:
  Task dump for CPU 3:
  task:migration/3     state:R  running task     stack:    0 pid:   29 ppid:     2 flags:0x00000000
  Stopper: multi_cpu_stop+0x0/0x18c <- stop_machine_cpuslocked+0x128/0x174
  Call Trace:
  rcu: rcu_preempt kthread timer wakeup didn't happen for 8136 jiffies! g5889 f0x0 RCU_GP_WAIT_FQS(5) ->state=0x402
  rcu: 	Possible timer handling issue on cpu=2 timer-softirq=594
  rcu: rcu_preempt kthread starved for 8137 jiffies! g5889 f0x0 RCU_GP_WAIT_FQS(5) ->state=0x402 ->cpu=2
  rcu: 	Unless rcu_preempt kthread gets sufficient CPU time, OOM is now expected behavior.
  rcu: RCU grace-period kthread stack dump:
  task:rcu_preempt     state:I stack:    0 pid:   14 ppid:     2 flags:0x00000000
  Call Trace:
    schedule+0x56/0xc2
    schedule_timeout+0x82/0x184
    rcu_gp_fqs_loop+0x19a/0x318
    rcu_gp_kthread+0x11a/0x140
    kthread+0xee/0x118
    ret_from_exception+0x0/0x14
  rcu: Stack dump where RCU GP kthread last ran:
  Task dump for CPU 2:
  task:migration/2     state:R  running task     stack:    0 pid:   24 ppid:     2 flags:0x00000000
  Stopper: multi_cpu_stop+0x0/0x18c <- stop_machine_cpuslocked+0x128/0x174
  Call Trace:

This commit therefore marks these functions notrace:
 rcu_preempt_deferred_qs()
 rcu_preempt_need_deferred_qs()
 rcu_preempt_deferred_qs_irqrestore()

[ paulmck: Apply feedback from Neeraj Upadhyay. ]

Signed-off-by: Patrick Wang <patrick.wang.shcn@gmail.com>
Acked-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Reviewed-by: Neeraj Upadhyay <quic_neeraju@quicinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/tree_plugin.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index c8ba0fe17267..7a07f2ca153e 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -460,7 +460,7 @@ static bool rcu_preempt_has_tasks(struct rcu_node *rnp)
  * be quite short, for example, in the case of the call from
  * rcu_read_unlock_special().
  */
-static void
+static notrace void
 rcu_preempt_deferred_qs_irqrestore(struct task_struct *t, unsigned long flags)
 {
 	bool empty_exp;
@@ -581,7 +581,7 @@ rcu_preempt_deferred_qs_irqrestore(struct task_struct *t, unsigned long flags)
  * is disabled.  This function cannot be expected to understand these
  * nuances, so the caller must handle them.
  */
-static bool rcu_preempt_need_deferred_qs(struct task_struct *t)
+static notrace bool rcu_preempt_need_deferred_qs(struct task_struct *t)
 {
 	return (__this_cpu_read(rcu_data.cpu_no_qs.b.exp) ||
 		READ_ONCE(t->rcu_read_unlock_special.s)) &&
@@ -595,7 +595,7 @@ static bool rcu_preempt_need_deferred_qs(struct task_struct *t)
  * evaluate safety in terms of interrupt, softirq, and preemption
  * disabling.
  */
-static void rcu_preempt_deferred_qs(struct task_struct *t)
+static notrace void rcu_preempt_deferred_qs(struct task_struct *t)
 {
 	unsigned long flags;
 
@@ -926,7 +926,7 @@ static bool rcu_preempt_has_tasks(struct rcu_node *rnp)
  * Because there is no preemptible RCU, there can be no deferred quiescent
  * states.
  */
-static bool rcu_preempt_need_deferred_qs(struct task_struct *t)
+static notrace bool rcu_preempt_need_deferred_qs(struct task_struct *t)
 {
 	return false;
 }
@@ -935,7 +935,7 @@ static bool rcu_preempt_need_deferred_qs(struct task_struct *t)
 // period for a quiescent state from this CPU.  Note that requests from
 // tasks are handled when removing the task from the blocked-tasks list
 // below.
-static void rcu_preempt_deferred_qs(struct task_struct *t)
+static notrace void rcu_preempt_deferred_qs(struct task_struct *t)
 {
 	struct rcu_data *rdp = this_cpu_ptr(&rcu_data);
 
-- 
2.35.1

