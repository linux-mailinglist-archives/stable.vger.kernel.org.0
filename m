Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 831BF4093E1
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:26:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344617AbhIMOZ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:25:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:41880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345254AbhIMOW2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:22:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 53FD861B39;
        Mon, 13 Sep 2021 13:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540843;
        bh=nD1nGfIPISEgG+0FeIZQbH3JTWsPv+IA/1iKH8ecKIA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JzwyPIYG0RGKNUpuEzH0La3QiSEvE8C07kxqfxJ3W5oAWmntdpDrxLz6yfymYuvsV
         BMrB0Q/WTqwjeQYp4HIb5PbsOTwdWyHPGpz+4BkhzBD3Yb8F5EZZu4qKeKemSzH9ZP
         Hvnpcq5rOW8oLZdzued4+gDg87ex7DfdqUvA+Z2o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qais Yousef <qais.yousef@arm.com>,
        Yanfei Xu <yanfei.xu@windriver.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 056/334] rcu: Fix stall-warning deadlock due to non-release of rcu_node ->lock
Date:   Mon, 13 Sep 2021 15:11:50 +0200
Message-Id: <20210913131115.312077932@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yanfei Xu <yanfei.xu@windriver.com>

[ Upstream commit dc87740c8a6806bd2162bfb441770e4e53be5601 ]

If rcu_print_task_stall() is invoked on an rcu_node structure that does
not contain any tasks blocking the current grace period, it takes an
early exit that fails to release that rcu_node structure's lock.  This
results in a self-deadlock, which is detected by lockdep.

To reproduce this bug:

tools/testing/selftests/rcutorture/bin/kvm.sh --allcpus --duration 3 --trust-make --configs "TREE03" --kconfig "CONFIG_PROVE_LOCKING=y" --bootargs "rcutorture.stall_cpu=30 rcutorture.stall_cpu_block=1 rcutorture.fwd_progress=0 rcutorture.test_boost=0"

This will also result in other complaints, including RCU's scheduler
hook complaining about blocking rather than preemption and an rcutorture
writer stall.

Only a partial RCU CPU stall warning message will be printed because of
the self-deadlock.

This commit therefore releases the lock on the rcu_print_task_stall()
function's early exit path.

Fixes: c583bcb8f5ed ("rcu: Don't invoke try_invoke_on_locked_down_task() with irqs disabled")
Tested-by: Qais Yousef <qais.yousef@arm.com>
Signed-off-by: Yanfei Xu <yanfei.xu@windriver.com>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/tree_stall.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/rcu/tree_stall.h b/kernel/rcu/tree_stall.h
index d56b4ede1db3..0e7a60706d1c 100644
--- a/kernel/rcu/tree_stall.h
+++ b/kernel/rcu/tree_stall.h
@@ -269,8 +269,10 @@ static int rcu_print_task_stall(struct rcu_node *rnp, unsigned long flags)
 	struct task_struct *ts[8];
 
 	lockdep_assert_irqs_disabled();
-	if (!rcu_preempt_blocked_readers_cgp(rnp))
+	if (!rcu_preempt_blocked_readers_cgp(rnp)) {
+		raw_spin_unlock_irqrestore_rcu_node(rnp, flags);
 		return 0;
+	}
 	pr_err("\tTasks blocked on level-%d rcu_node (CPUs %d-%d):",
 	       rnp->level, rnp->grplo, rnp->grphi);
 	t = list_entry(rnp->gp_tasks->prev,
-- 
2.30.2



