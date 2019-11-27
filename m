Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D24E10BCD2
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:24:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732046AbfK0VDc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:03:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:56738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731414AbfK0VDb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:03:31 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A08021771;
        Wed, 27 Nov 2019 21:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888610;
        bh=g5JG3N6L0NyVvDNzIuGXVjudP/DJfzVs1xq1Vs9a7Kg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AaBSu4L+IWplm3ysLZzSin3sMx5BmSM11RyrKVZ1+u+QB6oS5/M+g8qgvNWJJENPO
         rullNiMXa7scUyorLqBFVYhtut6vaZnu/Kp+TQBVAVxq7qc+zMDWcxGa5+rboWgG/f
         dZkMadijuYw23ps/ChB87XWKnQzevNzmBZtfKHEE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Valentin Schneider <valentin.schneider@arm.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Dietmar.Eggemann@arm.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, patrick.bellasi@arm.com,
        vincent.guittot@linaro.org, Ingo Molnar <mingo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 202/306] sched/fair: Dont increase sd->balance_interval on newidle balance
Date:   Wed, 27 Nov 2019 21:30:52 +0100
Message-Id: <20191127203129.917759626@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Valentin Schneider <valentin.schneider@arm.com>

[ Upstream commit 3f130a37c442d5c4d66531b240ebe9abfef426b5 ]

When load_balance() fails to move some load because of task affinity,
we end up increasing sd->balance_interval to delay the next periodic
balance in the hopes that next time we look, that annoying pinned
task(s) will be gone.

However, idle_balance() pays no attention to sd->balance_interval, yet
it will still lead to an increase in balance_interval in case of
pinned tasks.

If we're going through several newidle balances (e.g. we have a
periodic task), this can lead to a huge increase of the
balance_interval in a very small amount of time.

To prevent that, don't increase the balance interval when going
through a newidle balance.

This is a similar approach to what is done in commit 58b26c4c0257
("sched: Increment cache_nice_tries only on periodic lb"), where we
disregard newidle balance and rely on periodic balance for more stable
results.

Signed-off-by: Valentin Schneider <valentin.schneider@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Dietmar.Eggemann@arm.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: patrick.bellasi@arm.com
Cc: vincent.guittot@linaro.org
Link: http://lkml.kernel.org/r/1537974727-30788-2-git-send-email-valentin.schneider@arm.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index e5e8f67218728..f77fcd37b226f 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -8819,13 +8819,22 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 	sd->nr_balance_failed = 0;
 
 out_one_pinned:
+	ld_moved = 0;
+
+	/*
+	 * idle_balance() disregards balance intervals, so we could repeatedly
+	 * reach this code, which would lead to balance_interval skyrocketting
+	 * in a short amount of time. Skip the balance_interval increase logic
+	 * to avoid that.
+	 */
+	if (env.idle == CPU_NEWLY_IDLE)
+		goto out;
+
 	/* tune up the balancing interval */
 	if (((env.flags & LBF_ALL_PINNED) &&
 			sd->balance_interval < MAX_PINNED_INTERVAL) ||
 			(sd->balance_interval < sd->max_interval))
 		sd->balance_interval *= 2;
-
-	ld_moved = 0;
 out:
 	return ld_moved;
 }
-- 
2.20.1



