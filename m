Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B28B594104
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:49:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232192AbiHOVFF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:05:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344317AbiHOVDr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:03:47 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEC7BD346F;
        Mon, 15 Aug 2022 12:14:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 53203CE12C7;
        Mon, 15 Aug 2022 19:14:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 532BDC433D6;
        Mon, 15 Aug 2022 19:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590873;
        bh=QqpK5lGfpu6Sugnz3kv58SDcN45rswAEAFe5os5dbDY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EkhjHWm2NQO+qdKozkXb2aIpz6qohmNKEPXtHkqBTG9ch7Z5XJXXYs1xFOx8sq/Mo
         vtmMHxL54eJBsNZhQ13f0w3Wqr82qqtX20eWYF5iVQanq8RTfL3+J3JU+0lGqv8iiq
         9/ECDK6TXkaaT0ABXH5rmvAGmKNc3tGiU7OWSQa4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Frederic Weisbecker <frederic@kernel.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0367/1095] rcutorture: Fix ksoftirqd boosting timing and iteration
Date:   Mon, 15 Aug 2022 19:56:06 +0200
Message-Id: <20220815180444.902013702@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frederic Weisbecker <frederic@kernel.org>

[ Upstream commit 3002153a91a9732a6d1d0bb95138593c7da15743 ]

The RCU priority boosting can fail in two situations:

1) If (nr_cpus= > maxcpus=), which means if the total number of CPUs
is higher than those brought online at boot, then torture_onoff() may
later bring up CPUs that weren't online on boot. Now since rcutorture
initialization only boosts the ksoftirqds of the CPUs that have been
set online on boot, the CPUs later set online by torture_onoff won't
benefit from the boost, making RCU priority boosting fail.

2) The ksoftirqd kthreads are boosted after the creation of
rcu_torture_boost() kthreads, which opens a window large enough for these
rcu_torture_boost() kthreads to wait (despite running at FIFO priority)
for ksoftirqds that are still running at SCHED_NORMAL priority.

The issues can trigger for example with:

	./kvm.sh --configs TREE01 --kconfig "CONFIG_RCU_BOOST=y"

	[   34.968561] rcu-torture: !!!
	[   34.968627] ------------[ cut here ]------------
	[   35.014054] WARNING: CPU: 4 PID: 114 at kernel/rcu/rcutorture.c:1979 rcu_torture_stats_print+0x5ad/0x610
	[   35.052043] Modules linked in:
	[   35.069138] CPU: 4 PID: 114 Comm: rcu_torture_sta Not tainted 5.18.0-rc1 #1
	[   35.096424] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.14.0-0-g155821a-rebuilt.opensuse.org 04/01/2014
	[   35.154570] RIP: 0010:rcu_torture_stats_print+0x5ad/0x610
	[   35.198527] Code: 63 1b 02 00 74 02 0f 0b 48 83 3d 35 63 1b 02 00 74 02 0f 0b 48 83 3d 21 63 1b 02 00 74 02 0f 0b 48 83 3d 0d 63 1b 02 00 74 02 <0f> 0b 83 eb 01 0f 8e ba fc ff ff 0f 0b e9 b3 fc ff f82
	[   37.251049] RSP: 0000:ffffa92a0050bdf8 EFLAGS: 00010202
	[   37.277320] rcu: De-offloading 8
	[   37.290367] RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000001
	[   37.290387] RDX: 0000000000000000 RSI: 00000000ffffbfff RDI: 00000000ffffffff
	[   37.290398] RBP: 000000000000007b R08: 0000000000000000 R09: c0000000ffffbfff
	[   37.290407] R10: 000000000000002a R11: ffffa92a0050bc18 R12: ffffa92a0050be20
	[   37.290417] R13: ffffa92a0050be78 R14: 0000000000000000 R15: 000000000001bea0
	[   37.290427] FS:  0000000000000000(0000) GS:ffff96045eb00000(0000) knlGS:0000000000000000
	[   37.290448] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
	[   37.290460] CR2: 0000000000000000 CR3: 000000001dc0c000 CR4: 00000000000006e0
	[   37.290470] Call Trace:
	[   37.295049]  <TASK>
	[   37.295065]  ? preempt_count_add+0x63/0x90
	[   37.295095]  ? _raw_spin_lock_irqsave+0x12/0x40
	[   37.295125]  ? rcu_torture_stats_print+0x610/0x610
	[   37.295143]  rcu_torture_stats+0x29/0x70
	[   37.295160]  kthread+0xe3/0x110
	[   37.295176]  ? kthread_complete_and_exit+0x20/0x20
	[   37.295193]  ret_from_fork+0x22/0x30
	[   37.295218]  </TASK>

Fix this with boosting the ksoftirqds kthreads from the boosting
hotplug callback itself and before the boosting kthreads are created.

Fixes: ea6d962e80b6 ("rcutorture: Judge RCU priority boosting on grace periods, not callbacks")
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/rcutorture.c | 28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/kernel/rcu/rcutorture.c b/kernel/rcu/rcutorture.c
index 55d049c39608..7c3a7f8c828b 100644
--- a/kernel/rcu/rcutorture.c
+++ b/kernel/rcu/rcutorture.c
@@ -2030,6 +2030,19 @@ static int rcutorture_booster_init(unsigned int cpu)
 	if (boost_tasks[cpu] != NULL)
 		return 0;  /* Already created, nothing more to do. */
 
+	// Testing RCU priority boosting requires rcutorture do
+	// some serious abuse.  Counter this by running ksoftirqd
+	// at higher priority.
+	if (IS_BUILTIN(CONFIG_RCU_TORTURE_TEST)) {
+		struct sched_param sp;
+		struct task_struct *t;
+
+		t = per_cpu(ksoftirqd, cpu);
+		WARN_ON_ONCE(!t);
+		sp.sched_priority = 2;
+		sched_setscheduler_nocheck(t, SCHED_FIFO, &sp);
+	}
+
 	/* Don't allow time recalculation while creating a new task. */
 	mutex_lock(&boost_mutex);
 	rcu_torture_disable_rt_throttle();
@@ -3281,21 +3294,6 @@ rcu_torture_init(void)
 		rcutor_hp = firsterr;
 		if (torture_init_error(firsterr))
 			goto unwind;
-
-		// Testing RCU priority boosting requires rcutorture do
-		// some serious abuse.  Counter this by running ksoftirqd
-		// at higher priority.
-		if (IS_BUILTIN(CONFIG_RCU_TORTURE_TEST)) {
-			for_each_online_cpu(cpu) {
-				struct sched_param sp;
-				struct task_struct *t;
-
-				t = per_cpu(ksoftirqd, cpu);
-				WARN_ON_ONCE(!t);
-				sp.sched_priority = 2;
-				sched_setscheduler_nocheck(t, SCHED_FIFO, &sp);
-			}
-		}
 	}
 	shutdown_jiffies = jiffies + shutdown_secs * HZ;
 	firsterr = torture_shutdown_init(shutdown_secs, rcu_torture_cleanup);
-- 
2.35.1



