Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A34EC40914E
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243473AbhIMOAl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:00:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:46016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244478AbhIMN6h (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:58:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5D89C61A07;
        Mon, 13 Sep 2021 13:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540206;
        bh=Mojw9uHvDEWkN7PjN9fjBXXNrTTjfVdQtrSiV/mBBzc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SJNRq7uQd/MR7Z2IXeTPDtR6UQ6CVgFSkDikEupuUODRBzB0vdQtUwOk3svm9w7lB
         7jvzdzC9inXhadyWnJqsyWilSjijZzX+RC5dtNTV8CHhTP9QYpPadlklQILSaXZ+Z0
         W5lwz832SkdCl8hMZvtrWZt4uCQZ2K9GwmpUfs40=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qais Yousef <qais.yousef@arm.com>,
        Yanfei Xu <yanfei.xu@windriver.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 054/300] rcu: Fix to include first blocked task in stall warning
Date:   Mon, 13 Sep 2021 15:11:55 +0200
Message-Id: <20210913131111.186251356@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
References: <20210913131109.253835823@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yanfei Xu <yanfei.xu@windriver.com>

[ Upstream commit e6a901a44f76878ed1653626c9ff4cfc5a3f58f8 ]

The for loop in rcu_print_task_stall() always omits ts[0], which points
to the first task blocking the stalled grace period.  This in turn fails
to count this first task, which means that ndetected will be equal to
zero when all CPUs have passed through their quiescent states and only
one task is blocking the stalled grace period.  This zero value for
ndetected will in turn result in an incorrect "All QSes seen" message:

rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
rcu:    Tasks blocked on level-1 rcu_node (CPUs 12-23):
        (detected by 15, t=6504 jiffies, g=164777, q=9011209)
rcu: All QSes seen, last rcu_preempt kthread activity 1 (4295252379-4295252378), jiffies_till_next_fqs=1, root ->qsmask 0x2
BUG: sleeping function called from invalid context at include/linux/uaccess.h:156
in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 70613, name: msgstress04
INFO: lockdep is turned off.
Preemption disabled at:
[<ffff8000104031a4>] create_object.isra.0+0x204/0x4b0
CPU: 15 PID: 70613 Comm: msgstress04 Kdump: loaded Not tainted
5.12.2-yoctodev-standard #1
Hardware name: Marvell OcteonTX CN96XX board (DT)
Call trace:
 dump_backtrace+0x0/0x2cc
 show_stack+0x24/0x30
 dump_stack+0x110/0x188
 ___might_sleep+0x214/0x2d0
 __might_sleep+0x7c/0xe0

This commit therefore fixes the loop to include ts[0].

Fixes: c583bcb8f5ed ("rcu: Don't invoke try_invoke_on_locked_down_task() with irqs disabled")
Tested-by: Qais Yousef <qais.yousef@arm.com>
Signed-off-by: Yanfei Xu <yanfei.xu@windriver.com>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/tree_stall.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/rcu/tree_stall.h b/kernel/rcu/tree_stall.h
index 4aaa4a12e95f..f1e011d4a899 100644
--- a/kernel/rcu/tree_stall.h
+++ b/kernel/rcu/tree_stall.h
@@ -282,8 +282,8 @@ static int rcu_print_task_stall(struct rcu_node *rnp, unsigned long flags)
 			break;
 	}
 	raw_spin_unlock_irqrestore_rcu_node(rnp, flags);
-	for (i--; i; i--) {
-		t = ts[i];
+	while (i) {
+		t = ts[--i];
 		if (!try_invoke_on_locked_down_task(t, check_slow_task, &rscr))
 			pr_cont(" P%d", t->pid);
 		else
-- 
2.30.2



