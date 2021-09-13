Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF5B4408E44
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:34:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241208AbhIMNci (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:32:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:58178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240192AbhIMNav (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:30:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 25C7B610D1;
        Mon, 13 Sep 2021 13:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539494;
        bh=iZOEkqagWFQK/UfbKbL342VqoOpfn4NC4W77Ur++LRk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RD8ei693gboPTtCW1NkrF8aLSodjvUrKv0si/ZCYhbxp/l5fX8p4KOb/FHhnsxuPO
         NShbrLXCyx+JE+BqxruFjgGgiFFsLMYQ5NS1P6hX323vDIXUnm8iPaKvvdT1F04fB+
         Y4i7rO94mMoFsVcvH86yBisYLGcIjjhyiWbDT0XM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qais Yousef <qais.yousef@arm.com>,
        Yanfei Xu <yanfei.xu@windriver.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 046/236] rcu: Fix stall-warning deadlock due to non-release of rcu_node ->lock
Date:   Mon, 13 Sep 2021 15:12:31 +0200
Message-Id: <20210913131101.915696431@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131100.316353015@linuxfoundation.org>
References: <20210913131100.316353015@linuxfoundation.org>
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
index 3fc21617546d..251a9af3709a 100644
--- a/kernel/rcu/tree_stall.h
+++ b/kernel/rcu/tree_stall.h
@@ -263,8 +263,10 @@ static int rcu_print_task_stall(struct rcu_node *rnp, unsigned long flags)
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



