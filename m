Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89C5F37C4C6
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:32:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234570AbhELPdS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:33:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:40900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235583AbhELP2e (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:28:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BAFB361C28;
        Wed, 12 May 2021 15:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832442;
        bh=Ccpil1lsjVYtsb27r5DhOZBARhMh6yaAtrRkONSysM0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qml71Da9espq8OE79WX0zslQUXjBMBT3E4uwcNSBFfrIqXr3NF4QCNbd2YwrAnQh0
         fwJ/M0V91FF5hPD1jeATafy8pmb+yZhD1pPIuhUYOCHHGCSGdO1+yZhfpNI27mH+DE
         yXFyP0fwD5n/1aCK8iNGp1qnozKmE4xeSQOTxmAQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+d7581744d5fd27c9fbe1@syzkaller.appspotmail.com,
        Valentin Schneider <valentin.schneider@arm.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 281/530] sched/fair: Fix shift-out-of-bounds in load_balance()
Date:   Wed, 12 May 2021 16:46:31 +0200
Message-Id: <20210512144829.045871925@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Valentin Schneider <valentin.schneider@arm.com>

[ Upstream commit 39a2a6eb5c9b66ea7c8055026303b3aa681b49a5 ]

Syzbot reported a handful of occurrences where an sd->nr_balance_failed can
grow to much higher values than one would expect.

A successful load_balance() resets it to 0; a failed one increments
it. Once it gets to sd->cache_nice_tries + 3, this *should* trigger an
active balance, which will either set it to sd->cache_nice_tries+1 or reset
it to 0. However, in case the to-be-active-balanced task is not allowed to
run on env->dst_cpu, then the increment is done without any further
modification.

This could then be repeated ad nauseam, and would explain the absurdly high
values reported by syzbot (86, 149). VincentG noted there is value in
letting sd->cache_nice_tries grow, so the shift itself should be
fixed. That means preventing:

  """
  If the value of the right operand is negative or is greater than or equal
  to the width of the promoted left operand, the behavior is undefined.
  """

Thus we need to cap the shift exponent to
  BITS_PER_TYPE(typeof(lefthand)) - 1.

I had a look around for other similar cases via coccinelle:

  @expr@
  position pos;
  expression E1;
  expression E2;
  @@
  (
  E1 >> E2@pos
  |
  E1 >> E2@pos
  )

  @cst depends on expr@
  position pos;
  expression expr.E1;
  constant cst;
  @@
  (
  E1 >> cst@pos
  |
  E1 << cst@pos
  )

  @script:python depends on !cst@
  pos << expr.pos;
  exp << expr.E2;
  @@
  # Dirty hack to ignore constexpr
  if exp.upper() != exp:
     coccilib.report.print_report(pos[0], "Possible UB shift here")

The only other match in kernel/sched is rq_clock_thermal() which employs
sched_thermal_decay_shift, and that exponent is already capped to 10, so
that one is fine.

Fixes: 5a7f55590467 ("sched/fair: Relax constraint on task's load during load balance")
Reported-by: syzbot+d7581744d5fd27c9fbe1@syzkaller.appspotmail.com
Signed-off-by: Valentin Schneider <valentin.schneider@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: http://lore.kernel.org/r/000000000000ffac1205b9a2112f@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c  | 3 +--
 kernel/sched/sched.h | 7 +++++++
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index a0239649c741..c80d1a039d19 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -7735,8 +7735,7 @@ static int detach_tasks(struct lb_env *env)
 			 * scheduler fails to find a good waiting task to
 			 * migrate.
 			 */
-
-			if ((load >> env->sd->nr_balance_failed) > env->imbalance)
+			if (shr_bound(load, env->sd->nr_balance_failed) > env->imbalance)
 				goto next;
 
 			env->imbalance -= load;
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index fac1b121d113..fdebfcbdfca9 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -205,6 +205,13 @@ static inline void update_avg(u64 *avg, u64 sample)
 	*avg += diff / 8;
 }
 
+/*
+ * Shifting a value by an exponent greater *or equal* to the size of said value
+ * is UB; cap at size-1.
+ */
+#define shr_bound(val, shift)							\
+	(val >> min_t(typeof(shift), shift, BITS_PER_TYPE(typeof(val)) - 1))
+
 /*
  * !! For sched_setattr_nocheck() (kernel) only !!
  *
-- 
2.30.2



