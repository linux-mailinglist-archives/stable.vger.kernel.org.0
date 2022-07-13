Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B0B2573407
	for <lists+stable@lfdr.de>; Wed, 13 Jul 2022 12:22:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235620AbiGMKWl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jul 2022 06:22:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230472AbiGMKWk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jul 2022 06:22:40 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FE88F6B93;
        Wed, 13 Jul 2022 03:22:39 -0700 (PDT)
Received: from dggpeml500021.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4LjYXn1BjJzkWfV;
        Wed, 13 Jul 2022 18:20:25 +0800 (CST)
Received: from dggpeml100012.china.huawei.com (7.185.36.121) by
 dggpeml500021.china.huawei.com (7.185.36.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 13 Jul 2022 18:22:37 +0800
Received: from ubuntu1804.huawei.com (10.67.174.66) by
 dggpeml100012.china.huawei.com (7.185.36.121) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 13 Jul 2022 18:22:37 +0800
From:   Zheng Yejian <zhengyejian1@huawei.com>
To:     <stable@vger.kernel.org>
CC:     <paulmck@linux.vnet.ibm.com>, <josh@joshtriplett.org>,
        <rostedt@goodmis.org>, <mathieu.desnoyers@efficios.com>,
        <jiangshanlai@gmail.com>, <linux-kernel@vger.kernel.org>,
        <peterz@infradead.org>, <xukuohai@huawei.com>
Subject: [PATCH 4.19] rcu/tree: Mark functions as notrace
Date:   Wed, 13 Jul 2022 18:20:09 +0800
Message-ID: <20220713102009.126339-1-zhengyejian1@huawei.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.174.66]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml100012.china.huawei.com (7.185.36.121)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This patch and problem analysis is based on v4.19 LTS, but v5.4 LTS
and below seem to be involved.

Hulk Robot reports a softlockup problem, see following logs:
  [   41.463870] watchdog: BUG: soft lockup - CPU#0 stuck for 22s!  [ksoftirqd/0:9]
  [   41.509763] Modules linked in:
  [   41.512295] CPU: 0 PID: 9 Comm: ksoftirqd/0 Not tainted 4.19.90 #13
  [   41.516134] Hardware name: linux,dummy-virt (DT)
  [   41.519182] pstate: 80c00005 (Nzcv daif +PAN +UAO)
  [   41.522415] pc : perf_trace_buf_alloc+0x138/0x238
  [   41.525583] lr : perf_trace_buf_alloc+0x138/0x238
  [   41.528656] sp : ffff8000c137e880
  [   41.531050] x29: ffff8000c137e880 x28: ffff20000850ced0
  [   41.534759] x27: 0000000000000000 x26: ffff8000c137e9c0
  [   41.538456] x25: ffff8000ce5c2ae0 x24: ffff200008358b08
  [   41.542151] x23: 0000000000000000 x22: ffff2000084a50ac
  [   41.545834] x21: ffff8000c137e880 x20: 000000000000001c
  [   41.549516] x19: ffff7dffbfdf88e8 x18: 0000000000000000
  [   41.553202] x17: 0000000000000000 x16: 0000000000000000
  [   41.556892] x15: 1ffff00036e07805 x14: 0000000000000000
  [   41.560592] x13: 0000000000000004 x12: 0000000000000000
  [   41.564315] x11: 1fffefbff7fbf120 x10: ffff0fbff7fbf120
  [   41.568003] x9 : dfff200000000000 x8 : ffff7dffbfdf8904
  [   41.571699] x7 : 0000000000000000 x6 : ffff0fbff7fbf121
  [   41.575398] x5 : ffff0fbff7fbf121 x4 : ffff0fbff7fbf121
  [   41.579086] x3 : ffff20000850cdc8 x2 : 0000000000000008
  [   41.582773] x1 : ffff8000c1376000 x0 : 0000000000000100
  [   41.586495] Call trace:
  [   41.588922]  perf_trace_buf_alloc+0x138/0x238
  [   41.591912]  perf_ftrace_function_call+0x1ac/0x248
  [   41.595123]  ftrace_ops_no_ops+0x3a4/0x488
  [   41.597998]  ftrace_graph_call+0x0/0xc
  [   41.600715]  rcu_dynticks_curr_cpu_in_eqs+0x14/0x70
  [   41.603962]  rcu_is_watching+0xc/0x20
  [   41.606635]  ftrace_ops_no_ops+0x240/0x488
  [   41.609530]  ftrace_graph_call+0x0/0xc
  [   41.612249]  __read_once_size_nocheck.constprop.0+0x1c/0x38
  [   41.615905]  unwind_frame+0x140/0x358
  [   41.618597]  walk_stackframe+0x34/0x60
  [   41.621359]  __save_stack_trace+0x204/0x3b8
  [   41.624328]  save_stack_trace+0x2c/0x38
  [   41.627112]  __kasan_slab_free+0x120/0x228
  [   41.630018]  kasan_slab_free+0x10/0x18
  [   41.632752]  kfree+0x84/0x250
  [   41.635107]  skb_free_head+0x70/0xb0
  [   41.637772]  skb_release_data+0x3f8/0x730
  [   41.640626]  skb_release_all+0x50/0x68
  [   41.643350]  kfree_skb+0x84/0x278
  [   41.645890]  kfree_skb_list+0x4c/0x78
  [   41.648595]  __dev_queue_xmit+0x1a4c/0x23a0
  [   41.651541]  dev_queue_xmit+0x28/0x38
  [   41.654254]  ip6_finish_output2+0xeb0/0x1630
  [   41.657261]  ip6_finish_output+0x2d8/0x7f8
  [   41.660174]  ip6_output+0x19c/0x348
  [   41.663850]  mld_sendpack+0x560/0x9e0
  [   41.666564]  mld_ifc_timer_expire+0x484/0x8a8
  [   41.669624]  call_timer_fn+0x68/0x4b0
  [   41.672355]  expire_timers+0x168/0x498
  [   41.675126]  run_timer_softirq+0x230/0x7a8
  [   41.678052]  __do_softirq+0x2d0/0xba0
  [   41.680763]  run_ksoftirqd+0x110/0x1a0
  [   41.683512]  smpboot_thread_fn+0x31c/0x620
  [   41.686429]  kthread+0x2c8/0x348
  [   41.688927]  ret_from_fork+0x10/0x18

Look into above call stack, there is a recursive call in
'ftrace_graph_call', and the direct cause of above recursion is that
'rcu_dynticks_curr_cpu_in_eqs' is traced, see following snippet:
    __read_once_size_nocheck.constprop.0
      ftrace_graph_call    <-- 1. first call
        ......
          rcu_dynticks_curr_cpu_in_eqs
            ftrace_graph_call    <-- 2. recursive call here!!!

Comparing with mainline kernel, commit ff5c4f5cad33 ("rcu/tree:
Mark the idle relevant functions noinstr") mark related functions as
'noinstr' which implies notrace, noinline and sticks things in the
.noinstr.text section.
Link: https://lore.kernel.org/all/20200416114706.625340212@infradead.org/

But we cannot directly backport that commit, because there seems to be
many prepatches. Instead, marking the functions as 'notrace' where it is
'noinstr' in that commit and mark 'rcu_dynticks_curr_cpu_in_eqs' as
inline look like it resolves the problem.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zheng Yejian <zhengyejian1@huawei.com>
---
 kernel/rcu/tree.c        | 22 +++++++++++-----------
 kernel/rcu/tree_plugin.h |  4 ++--
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index f7e89c989df7..01bc3c1f93f9 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -275,7 +275,7 @@ static DEFINE_PER_CPU(struct rcu_dynticks, rcu_dynticks) = {
  * Record entry into an extended quiescent state.  This is only to be
  * called when not already in an extended quiescent state.
  */
-static void rcu_dynticks_eqs_enter(void)
+static notrace void rcu_dynticks_eqs_enter(void)
 {
 	struct rcu_dynticks *rdtp = this_cpu_ptr(&rcu_dynticks);
 	int seq;
@@ -298,7 +298,7 @@ static void rcu_dynticks_eqs_enter(void)
  * Record exit from an extended quiescent state.  This is only to be
  * called from an extended quiescent state.
  */
-static void rcu_dynticks_eqs_exit(void)
+static notrace void rcu_dynticks_eqs_exit(void)
 {
 	struct rcu_dynticks *rdtp = this_cpu_ptr(&rcu_dynticks);
 	int seq;
@@ -343,7 +343,7 @@ static void rcu_dynticks_eqs_online(void)
  *
  * No ordering, as we are sampling CPU-local information.
  */
-bool rcu_dynticks_curr_cpu_in_eqs(void)
+static __always_inline bool rcu_dynticks_curr_cpu_in_eqs(void)
 {
 	struct rcu_dynticks *rdtp = this_cpu_ptr(&rcu_dynticks);
 
@@ -706,7 +706,7 @@ static struct rcu_node *rcu_get_root(struct rcu_state *rsp)
  * the possibility of usermode upcalls having messed up our count
  * of interrupt nesting level during the prior busy period.
  */
-static void rcu_eqs_enter(bool user)
+static notrace void rcu_eqs_enter(bool user)
 {
 	struct rcu_state *rsp;
 	struct rcu_data *rdp;
@@ -763,7 +763,7 @@ void rcu_idle_enter(void)
  * If you add or remove a call to rcu_user_enter(), be sure to test with
  * CONFIG_RCU_EQS_DEBUG=y.
  */
-void rcu_user_enter(void)
+notrace void rcu_user_enter(void)
 {
 	lockdep_assert_irqs_disabled();
 	rcu_eqs_enter(true);
@@ -781,7 +781,7 @@ void rcu_user_enter(void)
  * If you add or remove a call to rcu_nmi_exit(), be sure to test
  * with CONFIG_RCU_EQS_DEBUG=y.
  */
-void rcu_nmi_exit(void)
+notrace void rcu_nmi_exit(void)
 {
 	struct rcu_dynticks *rdtp = this_cpu_ptr(&rcu_dynticks);
 
@@ -829,7 +829,7 @@ void rcu_nmi_exit(void)
  * If you add or remove a call to rcu_irq_exit(), be sure to test with
  * CONFIG_RCU_EQS_DEBUG=y.
  */
-void rcu_irq_exit(void)
+notrace void rcu_irq_exit(void)
 {
 	struct rcu_dynticks *rdtp = this_cpu_ptr(&rcu_dynticks);
 
@@ -864,7 +864,7 @@ void rcu_irq_exit_irqson(void)
  * allow for the possibility of usermode upcalls messing up our count of
  * interrupt nesting level during the busy period that is just now starting.
  */
-static void rcu_eqs_exit(bool user)
+static notrace void rcu_eqs_exit(bool user)
 {
 	struct rcu_dynticks *rdtp;
 	long oldval;
@@ -914,7 +914,7 @@ void rcu_idle_exit(void)
  * If you add or remove a call to rcu_user_exit(), be sure to test with
  * CONFIG_RCU_EQS_DEBUG=y.
  */
-void rcu_user_exit(void)
+void notrace rcu_user_exit(void)
 {
 	rcu_eqs_exit(1);
 }
@@ -932,7 +932,7 @@ void rcu_user_exit(void)
  * If you add or remove a call to rcu_nmi_enter(), be sure to test
  * with CONFIG_RCU_EQS_DEBUG=y.
  */
-void rcu_nmi_enter(void)
+notrace void rcu_nmi_enter(void)
 {
 	struct rcu_dynticks *rdtp = this_cpu_ptr(&rcu_dynticks);
 	long incby = 2;
@@ -982,7 +982,7 @@ void rcu_nmi_enter(void)
  * If you add or remove a call to rcu_irq_enter(), be sure to test with
  * CONFIG_RCU_EQS_DEBUG=y.
  */
-void rcu_irq_enter(void)
+notrace void rcu_irq_enter(void)
 {
 	struct rcu_dynticks *rdtp = this_cpu_ptr(&rcu_dynticks);
 
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 5f6de49dc78e..568818bef28f 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -2677,7 +2677,7 @@ static void rcu_bind_gp_kthread(void)
 }
 
 /* Record the current task on dyntick-idle entry. */
-static void rcu_dynticks_task_enter(void)
+static notrace void rcu_dynticks_task_enter(void)
 {
 #if defined(CONFIG_TASKS_RCU) && defined(CONFIG_NO_HZ_FULL)
 	WRITE_ONCE(current->rcu_tasks_idle_cpu, smp_processor_id());
@@ -2685,7 +2685,7 @@ static void rcu_dynticks_task_enter(void)
 }
 
 /* Record no current task on dyntick-idle exit. */
-static void rcu_dynticks_task_exit(void)
+static notrace void rcu_dynticks_task_exit(void)
 {
 #if defined(CONFIG_TASKS_RCU) && defined(CONFIG_NO_HZ_FULL)
 	WRITE_ONCE(current->rcu_tasks_idle_cpu, -1);
-- 
2.32.0

