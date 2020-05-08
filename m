Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 347F21CAF3B
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:17:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729571AbgEHNQM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 09:16:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:44798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729277AbgEHMpV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:45:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 70FA321974;
        Fri,  8 May 2020 12:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941919;
        bh=tyFTvxW8drnM8ZLL/O+JgeoqrmJLhn9n7T5VMxnAa/4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=03HSoGaPHXQliaHBJnA5VaXHitweNVusHoJQ0obKz8TgAqUyhhTqVqleRyNmVTibm
         LnHoiP72jZxKTLT4ZpOIwxZzVAjAqBtZ+6BH34bRcRuK49EXP0qnkCPm8rUwnK4CV3
         3iwBoox9mIDS14cBy0lVhBJGo1ILk37BnBmmZPc8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jirka Hladky <jhladky@redhat.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 4.4 224/312] sched/fair: Fix calc_cfs_shares() fixed point arithmetics width confusion
Date:   Fri,  8 May 2020 14:33:35 +0200
Message-Id: <20200508123140.209726281@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

commit ea1dc6fc6242f991656e35e2ed3d90ec1cd13418 upstream.

Commit:

  fde7d22e01aa ("sched/fair: Fix overly small weight for interactive group entities")

did something non-obvious but also did it buggy yet latent.

The problem was exposed for real by a later commit in the v4.7 merge window:

  2159197d6677 ("sched/core: Enable increased load resolution on 64-bit kernels")

... after which tg->load_avg and cfs_rq->load.weight had different
units (10 bit fixed point and 20 bit fixed point resp.).

Add a comment to explain the use of cfs_rq->load.weight over the
'natural' cfs_rq->avg.load_avg and add scale_load_down() to correct
for the difference in unit.

Since this is (now, as per a previous commit) the only user of
calc_tg_weight(), collapse it.

The effects of this bug should be randomly inconsistent SMP-balancing
of cgroups workloads.

Reported-by: Jirka Hladky <jhladky@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Fixes: 2159197d6677 ("sched/core: Enable increased load resolution on 64-bit kernels")
Fixes: fde7d22e01aa ("sched/fair: Fix overly small weight for interactive group entities")
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/sched/fair.c |   27 +++++++++++----------------
 1 file changed, 11 insertions(+), 16 deletions(-)

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2394,28 +2394,22 @@ account_entity_dequeue(struct cfs_rq *cf
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
 # ifdef CONFIG_SMP
-static inline long calc_tg_weight(struct task_group *tg, struct cfs_rq *cfs_rq)
+static long calc_cfs_shares(struct cfs_rq *cfs_rq, struct task_group *tg)
 {
-	long tg_weight;
+	long tg_weight, load, shares;
 
 	/*
-	 * Use this CPU's real-time load instead of the last load contribution
-	 * as the updating of the contribution is delayed, and we will use the
-	 * the real-time load to calc the share. See update_tg_load_avg().
+	 * This really should be: cfs_rq->avg.load_avg, but instead we use
+	 * cfs_rq->load.weight, which is its upper bound. This helps ramp up
+	 * the shares for small weight interactive tasks.
 	 */
-	tg_weight = atomic_long_read(&tg->load_avg);
-	tg_weight -= cfs_rq->tg_load_avg_contrib;
-	tg_weight += cfs_rq->load.weight;
-
-	return tg_weight;
-}
+	load = scale_load_down(cfs_rq->load.weight);
 
-static long calc_cfs_shares(struct cfs_rq *cfs_rq, struct task_group *tg)
-{
-	long tg_weight, load, shares;
+	tg_weight = atomic_long_read(&tg->load_avg);
 
-	tg_weight = calc_tg_weight(tg, cfs_rq);
-	load = cfs_rq->load.weight;
+	/* Ensure tg_weight >= load */
+	tg_weight -= cfs_rq->tg_load_avg_contrib;
+	tg_weight += load;
 
 	shares = (tg->shares * load);
 	if (tg_weight)
@@ -2434,6 +2428,7 @@ static inline long calc_cfs_shares(struc
 	return tg->shares;
 }
 # endif /* CONFIG_SMP */
+
 static void reweight_entity(struct cfs_rq *cfs_rq, struct sched_entity *se,
 			    unsigned long weight)
 {


