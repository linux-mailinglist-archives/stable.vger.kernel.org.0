Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0170EA63DD
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 10:31:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbfICIbb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 04:31:31 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:59106 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725888AbfICIbb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Sep 2019 04:31:31 -0400
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1i54Dh-0002d6-3X; Tue, 03 Sep 2019 10:31:21 +0200
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id A08EB1C0DDE;
        Tue,  3 Sep 2019 10:31:20 +0200 (CEST)
Date:   Tue, 03 Sep 2019 08:31:20 -0000
From:   "tip-bot2 for Liangyan" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: sched/urgent] sched/fair: Don't assign runtime for throttled cfs_rq
Cc:     Liangyan <liangyan.peng@linux.alibaba.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Valentin Schneider <valentin.schneider@arm.com>,
        Ben Segall <bsegall@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        shanpeic@linux.alibaba.com, stable@vger.kernel.org,
        xlpang@linux.alibaba.com, Ingo Molnar <mingo@kernel.org>,
        Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20190826121633.6538-1-liangyan.peng@linux.alibaba.com>
References: <20190826121633.6538-1-liangyan.peng@linux.alibaba.com>
MIME-Version: 1.0
Message-ID: <156749948052.12827.9239935639656619220.tip-bot2@tip-bot2>
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the sched/urgent branch of tip:

Commit-ID:     5e2d2cc2588bd3307ce3937acbc2ed03c830a861
Gitweb:        https://git.kernel.org/tip/5e2d2cc2588bd3307ce3937acbc2ed03c830a861
Author:        Liangyan <liangyan.peng@linux.alibaba.com>
AuthorDate:    Mon, 26 Aug 2019 20:16:33 +08:00
Committer:     Ingo Molnar <mingo@kernel.org>
CommitterDate: Tue, 03 Sep 2019 08:55:07 +02:00

sched/fair: Don't assign runtime for throttled cfs_rq

do_sched_cfs_period_timer() will refill cfs_b runtime and call
distribute_cfs_runtime to unthrottle cfs_rq, sometimes cfs_b->runtime
will allocate all quota to one cfs_rq incorrectly, then other cfs_rqs
attached to this cfs_b can't get runtime and will be throttled.

We find that one throttled cfs_rq has non-negative
cfs_rq->runtime_remaining and cause an unexpetced cast from s64 to u64
in snippet:

  distribute_cfs_runtime() {
    runtime = -cfs_rq->runtime_remaining + 1;
  }

The runtime here will change to a large number and consume all
cfs_b->runtime in this cfs_b period.

According to Ben Segall, the throttled cfs_rq can have
account_cfs_rq_runtime called on it because it is throttled before
idle_balance, and the idle_balance calls update_rq_clock to add time
that is accounted to the task.

This commit prevents cfs_rq to be assgined new runtime if it has been
throttled until that distribute_cfs_runtime is called.

Signed-off-by: Liangyan <liangyan.peng@linux.alibaba.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Valentin Schneider <valentin.schneider@arm.com>
Reviewed-by: Ben Segall <bsegall@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: shanpeic@linux.alibaba.com
Cc: stable@vger.kernel.org
Cc: xlpang@linux.alibaba.com
Fixes: d3d9dc330236 ("sched: Throttle entities exceeding their allowed bandwidth")
Link: https://lkml.kernel.org/r/20190826121633.6538-1-liangyan.peng@linux.alibaba.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index bc9cfea..500f5db 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4470,6 +4470,8 @@ static void __account_cfs_rq_runtime(struct cfs_rq *cfs_rq, u64 delta_exec)
 	if (likely(cfs_rq->runtime_remaining > 0))
 		return;
 
+	if (cfs_rq->throttled)
+		return;
 	/*
 	 * if we're unable to extend our runtime we resched so that the active
 	 * hierarchy can be throttled
@@ -4673,6 +4675,9 @@ static u64 distribute_cfs_runtime(struct cfs_bandwidth *cfs_b,
 		if (!cfs_rq_throttled(cfs_rq))
 			goto next;
 
+		/* By the above check, this should never be true */
+		SCHED_WARN_ON(cfs_rq->runtime_remaining > 0);
+
 		runtime = -cfs_rq->runtime_remaining + 1;
 		if (runtime > remaining)
 			runtime = remaining;
