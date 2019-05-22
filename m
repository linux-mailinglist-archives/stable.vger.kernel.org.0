Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57FD926B3B
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 21:25:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731541AbfEVTZT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 15:25:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:46628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731537AbfEVTZT (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 May 2019 15:25:19 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3A612173C;
        Wed, 22 May 2019 19:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558553118;
        bh=LXQWtieiVyBU/u0+NP2QrRfZT/to96KcHZBXu33pD60=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=150e834Z4r3cZRNOfxfESoGu62L3P3NF92qUuJ8cYzMmupOM9+68claAzEVTsE6rX
         mPEJH0g5vzm6i+zovbU+1LVFbibgAtqOtjI5Vzjmg7dolgDRwcMVXngHBT91KltvQy
         +bRMXZN4PtIA9uyGYk2RAHEj6Q+SqGWfnnAeG1/U=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.0 058/317] sched/nohz: Run NOHZ idle load balancer on HK_FLAG_MISC CPUs
Date:   Wed, 22 May 2019 15:19:19 -0400
Message-Id: <20190522192338.23715-58-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190522192338.23715-1-sashal@kernel.org>
References: <20190522192338.23715-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>

[ Upstream commit 9b019acb72e4b5741d88e8936d6f200ed44b66b2 ]

The NOHZ idle balancer runs on the lowest idle CPU. This can
interfere with isolated CPUs, so confine it to HK_FLAG_MISC
housekeeping CPUs.

HK_FLAG_SCHED is not used for this because it is not set anywhere
at the moment. This could be folded into HK_FLAG_SCHED once that
option is fixed.

The problem was observed with increased jitter on an application
running on CPU0, caused by NOHZ idle load balancing being run on
CPU1 (an SMT sibling).

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: https://lkml.kernel.org/r/20190412042613.28930-1-npiggin@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index be55a64748ba3..d905c443e10e5 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -9456,22 +9456,26 @@ static inline int on_null_domain(struct rq *rq)
  * - When one of the busy CPUs notice that there may be an idle rebalancing
  *   needed, they will kick the idle load balancer, which then does idle
  *   load balancing for all the idle CPUs.
+ * - HK_FLAG_MISC CPUs are used for this task, because HK_FLAG_SCHED not set
+ *   anywhere yet.
  */
 
 static inline int find_new_ilb(void)
 {
-	int ilb = cpumask_first(nohz.idle_cpus_mask);
+	int ilb;
 
-	if (ilb < nr_cpu_ids && idle_cpu(ilb))
-		return ilb;
+	for_each_cpu_and(ilb, nohz.idle_cpus_mask,
+			      housekeeping_cpumask(HK_FLAG_MISC)) {
+		if (idle_cpu(ilb))
+			return ilb;
+	}
 
 	return nr_cpu_ids;
 }
 
 /*
- * Kick a CPU to do the nohz balancing, if it is time for it. We pick the
- * nohz_load_balancer CPU (if there is one) otherwise fallback to any idle
- * CPU (if there is one).
+ * Kick a CPU to do the nohz balancing, if it is time for it. We pick any
+ * idle CPU in the HK_FLAG_MISC housekeeping set (if there is one).
  */
 static void kick_ilb(unsigned int flags)
 {
-- 
2.20.1

