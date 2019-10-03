Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10E96CA4BE
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:34:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391343AbfJCQ14 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:27:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:60042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728475AbfJCQ1v (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:27:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 01B6F215EA;
        Thu,  3 Oct 2019 16:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120071;
        bh=pdMMS9tRmwo2a56ecWxmdKFTESt+E7tmuAeeHjbvlCE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hHlSGVR/iszaAlM4pq16NUzVgkkIQhp1ln0FwssGHabYjtba2mtu/e1HiTg52Kg9o
         ac6ss/bFnntyHJI2oLaorQKUykGgVgoUjpZw751LVfSIhjWbpjBjc4HHb9L2COQA4n
         FHV4YbT3qhs1Z5e7UCtMoYrX7mxqb1VFDR44d25Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Phil Auld <pauld@redhat.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 087/313] sched/fair: Use rq_lock/unlock in online_fair_sched_group
Date:   Thu,  3 Oct 2019 17:51:05 +0200
Message-Id: <20191003154541.454452803@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154533.590915454@linuxfoundation.org>
References: <20191003154533.590915454@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Phil Auld <pauld@redhat.com>

[ Upstream commit a46d14eca7b75fffe35603aa8b81df654353d80f ]

Enabling WARN_DOUBLE_CLOCK in /sys/kernel/debug/sched_features causes
warning to fire in update_rq_clock. This seems to be caused by onlining
a new fair sched group not using the rq lock wrappers.

  [] rq->clock_update_flags & RQCF_UPDATED
  [] WARNING: CPU: 5 PID: 54385 at kernel/sched/core.c:210 update_rq_clock+0xec/0x150

  [] Call Trace:
  []  online_fair_sched_group+0x53/0x100
  []  cpu_cgroup_css_online+0x16/0x20
  []  online_css+0x1c/0x60
  []  cgroup_apply_control_enable+0x231/0x3b0
  []  cgroup_mkdir+0x41b/0x530
  []  kernfs_iop_mkdir+0x61/0xa0
  []  vfs_mkdir+0x108/0x1a0
  []  do_mkdirat+0x77/0xe0
  []  do_syscall_64+0x55/0x1d0
  []  entry_SYSCALL_64_after_hwframe+0x44/0xa9

Using the wrappers in online_fair_sched_group instead of the raw locking
removes this warning.

[ tglx: Use rq_*lock_irq() ]

Signed-off-by: Phil Auld <pauld@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Ingo Molnar <mingo@kernel.org>
Link: https://lkml.kernel.org/r/20190801133749.11033-1-pauld@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index f72bf8122fe4e..5a312c030b8d2 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -10569,18 +10569,18 @@ int alloc_fair_sched_group(struct task_group *tg, struct task_group *parent)
 void online_fair_sched_group(struct task_group *tg)
 {
 	struct sched_entity *se;
+	struct rq_flags rf;
 	struct rq *rq;
 	int i;
 
 	for_each_possible_cpu(i) {
 		rq = cpu_rq(i);
 		se = tg->se[i];
-
-		raw_spin_lock_irq(&rq->lock);
+		rq_lock_irq(rq, &rf);
 		update_rq_clock(rq);
 		attach_entity_cfs_rq(se);
 		sync_throttle(tg, i);
-		raw_spin_unlock_irq(&rq->lock);
+		rq_unlock_irq(rq, &rf);
 	}
 }
 
-- 
2.20.1



