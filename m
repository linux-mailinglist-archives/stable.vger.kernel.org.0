Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCA552EBE5
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:16:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730786AbfE3DQo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:16:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:43698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730779AbfE3DQn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:16:43 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 366AA24624;
        Thu, 30 May 2019 03:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186203;
        bh=PXyNiBVDngqp8kmfxOJ/7Q+LgxW2Mff6MtqJg3Du+ZU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LNCeYOX5UZfail6Wbsl0gw3dslm7PInh2+xnLckNoujoQ7OwaZiIu3Dgk1Nd8pqM1
         mjRKfWH9OMk0CNyqX8keHYAhGZwzyDtM0TLmEHGaGpcYVhIlN/h4C0LPgGRmEJeLPO
         Z1TMCpjynESecksrCXwcxCqUUqaktN+h6xyDBy+k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 088/276] sched/nohz: Run NOHZ idle load balancer on HK_FLAG_MISC CPUs
Date:   Wed, 29 May 2019 20:04:06 -0700
Message-Id: <20190530030531.755189018@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030523.133519668@linuxfoundation.org>
References: <20190530030523.133519668@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index d31916366d39c..7a1e9db617f76 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -9083,22 +9083,26 @@ static inline int on_null_domain(struct rq *rq)
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



