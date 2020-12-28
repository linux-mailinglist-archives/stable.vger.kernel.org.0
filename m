Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD7EA2E3996
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:25:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388861AbgL1NZQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:25:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:53918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388872AbgL1NZO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:25:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 113012072C;
        Mon, 28 Dec 2020 13:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161873;
        bh=+AoAnIZZ/9A6WTdD5RGCO12One7qNrVF0qIULMCRCF8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q7yKdiQ+fw4KGtbAdV9rJsBINUtzeuAc6tz6IiybYUusdS7HRfwAm6uyqelTzBd3M
         i+gu6u0S/dZNyWdMsZiEIxi3Vx3EekXWFwaLNC6Kg80GrtXgUiF+5XkPhexag6zZui
         yREGktMd95ibEeUfMKZJJooLNYEYns+ok6p7115w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 111/346] sched: Reenable interrupts in do_sched_yield()
Date:   Mon, 28 Dec 2020 13:47:10 +0100
Message-Id: <20201228124925.154328017@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
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
index b166320f7633e..013b1c6cb4ed9 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4984,12 +4984,8 @@ static void do_sched_yield(void)
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



