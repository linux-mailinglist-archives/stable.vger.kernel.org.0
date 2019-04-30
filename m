Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 986C9F831
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 14:06:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729213AbfD3MGN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 08:06:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:48896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727992AbfD3LlW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:41:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C14E921670;
        Tue, 30 Apr 2019 11:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624481;
        bh=qRmKrYYbqkg1FwSL1lD95/YIPLn4v7ox5OG63TAr2ZE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ig2rSMqPuAGDv0kQchaR05pqMQ0PzekHV/DzUArNf9LRxfVOzbxKYtnQnw2jYutH0
         k4ETFoSpe3vX3R3HZgkJE3QF9vTv3E6mGenaR7k9zUX0SxHqJdWaejJSBrY/zKr0Pe
         WF+dzj3qJauwOZoo9QTVq8uxxlkP+b5FKqllpNqg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xie XiuQi <xiexiuqi@huawei.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, cj.chengjian@huawei.com,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 4.14 10/53] sched/numa: Fix a possible divide-by-zero
Date:   Tue, 30 Apr 2019 13:38:17 +0200
Message-Id: <20190430113552.326734493@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430113549.400132183@linuxfoundation.org>
References: <20190430113549.400132183@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xie XiuQi <xiexiuqi@huawei.com>

commit a860fa7b96e1a1c974556327aa1aee852d434c21 upstream.

sched_clock_cpu() may not be consistent between CPUs. If a task
migrates to another CPU, then se.exec_start is set to that CPU's
rq_clock_task() by update_stats_curr_start(). Specifically, the new
value might be before the old value due to clock skew.

So then if in numa_get_avg_runtime() the expression:

  'now - p->last_task_numa_placement'

ends up as -1, then the divider '*period + 1' in task_numa_placement()
is 0 and things go bang. Similar to update_curr(), check if time goes
backwards to avoid this.

[ peterz: Wrote new changelog. ]
[ mingo: Tweaked the code comment. ]

Signed-off-by: Xie XiuQi <xiexiuqi@huawei.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: cj.chengjian@huawei.com
Cc: <stable@vger.kernel.org>
Link: http://lkml.kernel.org/r/20190425080016.GX11158@hirez.programming.kicks-ass.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/sched/fair.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2026,6 +2026,10 @@ static u64 numa_get_avg_runtime(struct t
 	if (p->last_task_numa_placement) {
 		delta = runtime - p->last_sum_exec_runtime;
 		*period = now - p->last_task_numa_placement;
+
+		/* Avoid time going backwards, prevent potential divide error: */
+		if (unlikely((s64)*period < 0))
+			*period = 0;
 	} else {
 		delta = p->se.avg.load_sum / p->se.load.weight;
 		*period = LOAD_AVG_MAX;


