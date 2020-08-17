Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C2522471BE
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 20:33:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391156AbgHQScw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 14:32:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:48138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387560AbgHQQAo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 12:00:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C3BC320885;
        Mon, 17 Aug 2020 16:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597680043;
        bh=cytyOljv7NTOTrVBQRiR1DPgvbeXqME725xfguHR8S8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uvzN39dpuDg1BeBRKMu0VV8twt+AM/Q6s/qXE5EaYSp9whIdEiUmNysM761iwUqju
         BbHO50eiEb3BICZDpZ4w4hbjgNL5j07+Lrah5bGQdZjowVd9m+WV3GaS/QjbALiKfo
         sIrjAl/MEPRikfyWidBdJ4/V1u3OlJLbc3rzwrXo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peng Liu <iwtbavbm@gmail.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Valentin Schneider <valentin.schneider@arm.com>,
        Mel Gorman <mgorman@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 007/270] sched/fair: Fix NOHZ next idle balance
Date:   Mon, 17 Aug 2020 17:13:28 +0200
Message-Id: <20200817143756.173459004@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143755.807583758@linuxfoundation.org>
References: <20200817143755.807583758@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 9b16080093be1..20bf1f66733ac 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -9385,7 +9385,12 @@ static void kick_ilb(unsigned int flags)
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
 
@@ -9703,6 +9708,14 @@ static bool _nohz_idle_balance(struct rq *this_rq, unsigned int flags,
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
@@ -9723,14 +9736,6 @@ static bool _nohz_idle_balance(struct rq *this_rq, unsigned int flags,
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



