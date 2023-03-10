Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E61D6B48BE
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:06:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233168AbjCJPGb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:06:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233810AbjCJPGK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:06:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 088D6222EB
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:59:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2C02DB8231D
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:58:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5988AC4339B;
        Fri, 10 Mar 2023 14:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678460295;
        bh=7K1HydJUtJlBBOidbQEBjAvjKoKIDFZdwv0YPp4WMRs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gKqReg/tE9r3iMvQ4N3uMjeqoKrKPPZvWswrlDeWJY3MYKo18cZtiAJjCnCTyQooe
         NcIIRJeW4nn9Ty3d4+tqHgXy+/LEph51rf7pK6mTGEZFQjyO2ptpXqJ5x3c/4NlhbA
         6vaDgKC5nkHDRMaeq49ltQG0qjsSynR9A3xjaT/M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zqiang <qiang1.zhang@intel.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 288/529] rcu-tasks: Make rude RCU-Tasks work well with CPU hotplug
Date:   Fri, 10 Mar 2023 14:37:11 +0100
Message-Id: <20230310133818.306016219@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
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
index df8143c8a6a8e..c66d47685b28e 100644
--- a/kernel/rcu/tasks.h
+++ b/kernel/rcu/tasks.h
@@ -171,8 +171,9 @@ static void call_rcu_tasks_generic(struct rcu_head *rhp, rcu_callback_t func,
 static void synchronize_rcu_tasks_generic(struct rcu_tasks *rtp)
 {
 	/* Complain if the scheduler has not started.  */
-	WARN_ONCE(rcu_scheduler_active == RCU_SCHEDULER_INACTIVE,
-			 "synchronize_rcu_tasks called too soon");
+	if (WARN_ONCE(rcu_scheduler_active == RCU_SCHEDULER_INACTIVE,
+			 "synchronize_%s() called too soon", rtp->name))
+		return;
 
 	/* Wait for the grace period. */
 	wait_rcu_gp(rtp->call_func);
@@ -648,9 +649,6 @@ static void rcu_tasks_be_rude(struct work_struct *work)
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
2.39.2



