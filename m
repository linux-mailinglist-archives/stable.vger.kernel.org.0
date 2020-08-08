Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A39C123FBD2
	for <lists+stable@lfdr.de>; Sun,  9 Aug 2020 01:51:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726722AbgHHXvl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Aug 2020 19:51:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:48168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726453AbgHHXfy (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 Aug 2020 19:35:54 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B79320723;
        Sat,  8 Aug 2020 23:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596929753;
        bh=Zm0JTxqN7Lag/Job7R8Q84ETS3hXl6RidvnjycO/Xu4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k4UkZ5RG/ueoN3TmetSAHBGVSHnSPaw9bCOdjvLiSgAsZ/PCUAUu2C9UCZdAS+v2B
         hJ3aO1IFefMQgNmv7PgC9fRqEjqzz5QOWrWn29vvInoNkrr31MhUpq9fVOcUpg+NNj
         O0UvCQcuCWirv3bKbghwCsgPqwq3PTgcnE27C3nQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vincent Guittot <vincent.guittot@linaro.org>,
        Peng Liu <iwtbavbm@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Valentin Schneider <valentin.schneider@arm.com>,
        Mel Gorman <mgorman@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.8 08/72] sched/fair: Fix NOHZ next idle balance
Date:   Sat,  8 Aug 2020 19:34:37 -0400
Message-Id: <20200808233542.3617339-8-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200808233542.3617339-1-sashal@kernel.org>
References: <20200808233542.3617339-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Guittot <vincent.guittot@linaro.org>

[ Upstream commit 3ea2f097b17e13a8280f1f9386c331b326a3dbef ]

With commit:
  'b7031a02ec75 ("sched/fair: Add NOHZ_STATS_KICK")'
rebalance_domains of the local cfs_rq happens before others idle cpus have
updated nohz.next_balance and its value is overwritten.

Move the update of nohz.next_balance for other idles cpus before balancing
and updating the next_balance of local cfs_rq.

Also, the nohz.next_balance is now updated only if all idle cpus got a
chance to rebalance their domains and the idle balance has not been aborted
because of new activities on the CPU. In case of need_resched, the idle
load balance will be kick the next jiffie in order to address remaining
ilb.

Fixes: b7031a02ec75 ("sched/fair: Add NOHZ_STATS_KICK")
Reported-by: Peng Liu <iwtbavbm@gmail.com>
Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Valentin Schneider <valentin.schneider@arm.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Link: https://lkml.kernel.org/r/20200609123748.18636-1-vincent.guittot@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 04fa8dbcfa4d7..6b3b59cc51d6c 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -10027,7 +10027,12 @@ static void kick_ilb(unsigned int flags)
 {
 	int ilb_cpu;
 
-	nohz.next_balance++;
+	/*
+	 * Increase nohz.next_balance only when if full ilb is triggered but
+	 * not if we only update stats.
+	 */
+	if (flags & NOHZ_BALANCE_KICK)
+		nohz.next_balance = jiffies+1;
 
 	ilb_cpu = find_new_ilb();
 
@@ -10348,6 +10353,14 @@ static bool _nohz_idle_balance(struct rq *this_rq, unsigned int flags,
 		}
 	}
 
+	/*
+	 * next_balance will be updated only when there is a need.
+	 * When the CPU is attached to null domain for ex, it will not be
+	 * updated.
+	 */
+	if (likely(update_next_balance))
+		nohz.next_balance = next_balance;
+
 	/* Newly idle CPU doesn't need an update */
 	if (idle != CPU_NEWLY_IDLE) {
 		update_blocked_averages(this_cpu);
@@ -10368,14 +10381,6 @@ static bool _nohz_idle_balance(struct rq *this_rq, unsigned int flags,
 	if (has_blocked_load)
 		WRITE_ONCE(nohz.has_blocked, 1);
 
-	/*
-	 * next_balance will be updated only when there is a need.
-	 * When the CPU is attached to null domain for ex, it will not be
-	 * updated.
-	 */
-	if (likely(update_next_balance))
-		nohz.next_balance = next_balance;
-
 	return ret;
 }
 
-- 
2.25.1

