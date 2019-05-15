Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13B9C1F42D
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:22:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726680AbfEOK6R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 06:58:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:54444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726720AbfEOK6Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 06:58:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E20932084E;
        Wed, 15 May 2019 10:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557917895;
        bh=J/MujyT89XVFd+QaMgS2rxgq10bcaAAGLw9s82tiKdk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cwl7T1GHnBD/hzzk4ZXK/tsomjRJXaYz3lBWKBbB4fmG+RtApDFjKSOc/ubxvES0M
         hEP7Q5FDm0iCvxWMuUhTcsy96LZGXpMdg0hHtv0l5fgfV3knTp/kjSEbu6Y10Ow+Rn
         XWXgCQWxefjMPgqspjElBLmzusRC5R+jo1GaV2cA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xie XiuQi <xiexiuqi@huawei.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, cj.chengjian@huawei.com,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 3.18 03/86] sched/numa: Fix a possible divide-by-zero
Date:   Wed, 15 May 2019 12:54:40 +0200
Message-Id: <20190515090643.049301271@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090642.339346723@linuxfoundation.org>
References: <20190515090642.339346723@linuxfoundation.org>
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
@@ -1569,6 +1569,10 @@ static u64 numa_get_avg_runtime(struct t
 	if (p->last_task_numa_placement) {
 		delta = runtime - p->last_sum_exec_runtime;
 		*period = now - p->last_task_numa_placement;
+
+		/* Avoid time going backwards, prevent potential divide error: */
+		if (unlikely((s64)*period < 0))
+			*period = 0;
 	} else {
 		delta = p->se.avg.runnable_avg_sum;
 		*period = p->se.avg.runnable_avg_period;


