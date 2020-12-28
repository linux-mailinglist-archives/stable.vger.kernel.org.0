Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EAB62E674B
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:24:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2633089AbgL1QXN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 11:23:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:39772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731876AbgL1NLx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:11:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C6B4C207C9;
        Mon, 28 Dec 2020 13:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161073;
        bh=CKvCff/TjX0Irjb1rYE0n5vX4aDYDAx0sSYOzQctXwM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uKZwmCyS7D2I08kQ9lBvOc4mBCcKuKLT0IKxF++vI9+esT3odw75MV4CdVXPvYWF7
         9DnT/x9oWrj4OUBMzhCVaVOLFnvIDGMhgZKW2UmQ5/2ECeRW9M3jNQWj7FoQvi8AOf
         ILbLz0Hg6716lhCi8BdjseZV+np6v+LVtyMI3zXM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 074/242] sched: Reenable interrupts in do_sched_yield()
Date:   Mon, 28 Dec 2020 13:47:59 +0100
Message-Id: <20201228124908.329826479@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124904.654293249@linuxfoundation.org>
References: <20201228124904.654293249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit 345a957fcc95630bf5535d7668a59ed983eb49a7 ]

do_sched_yield() invokes schedule() with interrupts disabled which is
not allowed. This goes back to the pre git era to commit a6efb709806c
("[PATCH] irqlock patch 2.5.27-H6") in the history tree.

Reenable interrupts and remove the misleading comment which "explains" it.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/87r1pt7y5c.fsf@nanos.tec.linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/core.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index c5599174e7450..7cedada731c1b 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4826,12 +4826,8 @@ SYSCALL_DEFINE0(sched_yield)
 	schedstat_inc(rq->yld_count);
 	current->sched_class->yield_task(rq);
 
-	/*
-	 * Since we are going to call schedule() anyway, there's
-	 * no need to preempt or enable interrupts:
-	 */
 	preempt_disable();
-	rq_unlock(rq, &rf);
+	rq_unlock_irq(rq, &rf);
 	sched_preempt_enable_no_resched();
 
 	schedule();
-- 
2.27.0



