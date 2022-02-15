Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C3B04B60F2
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 03:24:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233559AbiBOCYf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 21:24:35 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230431AbiBOCYd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 21:24:33 -0500
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99AB475C13
        for <stable@vger.kernel.org>; Mon, 14 Feb 2022 18:24:23 -0800 (PST)
Received: from dggpemm500023.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4JyPvz4rv3z8wd3;
        Tue, 15 Feb 2022 10:21:03 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 15 Feb 2022 10:24:21 +0800
Received: from thunder-town.china.huawei.com (10.174.178.55) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 15 Feb 2022 10:24:21 +0800
From:   Zhen Lei <thunder.leizhen@huawei.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>
CC:     Zhen Lei <thunder.leizhen@huawei.com>,
        "Paul E . McKenney" <paulmck@kernel.org>
Subject: [PATCH 5.10] rcu: Do not report strict GPs for outgoing CPUs
Date:   Tue, 15 Feb 2022 10:23:19 +0800
Message-ID: <20220215022319.2036-1-thunder.leizhen@huawei.com>
X-Mailer: git-send-email 2.26.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.178.55]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Paul E. McKenney" <paulmck@kernel.org>

[ Upstream commit bfb3aa735f82c8d98b32a669934ee7d6b346264d ]

An outgoing CPU is marked offline in a stop-machine handler and most
of that CPU's services stop at that point, including IRQ work queues.
However, that CPU must take another pass through the scheduler and through
a number of CPU-hotplug notifiers, many of which contain RCU readers.
In the past, these readers were not a problem because the outgoing CPU
has interrupts disabled, so that rcu_read_unlock_special() would not
be invoked, and thus RCU would never attempt to queue IRQ work on the
outgoing CPU.

This changed with the advent of the CONFIG_RCU_STRICT_GRACE_PERIOD
Kconfig option, in which rcu_read_unlock_special() is invoked upon exit
from almost all RCU read-side critical sections.  Worse yet, because
interrupts are disabled, rcu_read_unlock_special() cannot immediately
report a quiescent state and will therefore attempt to defer this
reporting, for example, by queueing IRQ work.  Which fails with a splat
because the CPU is already marked as being offline.

But it turns out that there is no need to report this quiescent state
because rcu_report_dead() will do this job shortly after the outgoing
CPU makes its final dive into the idle loop.  This commit therefore
makes rcu_read_unlock_special() refrain from queuing IRQ work onto
outgoing CPUs.

Fixes: 44bad5b3cca2 ("rcu: Do full report for .need_qs for strict GPs")
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Cc: Jann Horn <jannh@google.com>
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
---
 kernel/rcu/tree_plugin.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 6ed153f226b3925..244f32e98360fdf 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -628,7 +628,7 @@ static void rcu_read_unlock_special(struct task_struct *t)
 			set_tsk_need_resched(current);
 			set_preempt_need_resched();
 			if (IS_ENABLED(CONFIG_IRQ_WORK) && irqs_were_disabled &&
-			    !rdp->defer_qs_iw_pending && exp) {
+			    !rdp->defer_qs_iw_pending && exp && cpu_online(rdp->cpu)) {
 				// Get scheduler to re-evaluate and call hooks.
 				// If !IRQ_WORK, FQS scan will eventually IPI.
 				init_irq_work(&rdp->defer_qs_iw,
-- 
2.26.0.106.g9fadedd

