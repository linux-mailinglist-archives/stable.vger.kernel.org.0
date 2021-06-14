Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CD9B3A634B
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:11:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234219AbhFNLL4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:11:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:39876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235180AbhFNLJR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:09:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A47F61934;
        Mon, 14 Jun 2021 10:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667596;
        bh=nu+nOGoMoJeQ4qAVP6L4bIpjHxDHoW5h7IIKNTJNzmg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ycOaV6gaWbEQ4fz6f9g2DHkD9nHLYGRanFS2gfPt+1Y6WPm/JBqSchB5MHDakg6G5
         K/QvOBXxsEVm+f4vQpikrqgz3Gw0uLiUp07tneaxazyt9G+RbvhEyE1YcjO4o6uRyK
         o3b4JI+ldrAEd9/d76QgnvaIAUH/YOVi79fQQ+bM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Odin Ugedal <odin@uged.al>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.10 114/131] sched/fair: Keep load_avg and load_sum synced
Date:   Mon, 14 Jun 2021 12:27:55 +0200
Message-Id: <20210614102656.896703672@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102652.964395392@linuxfoundation.org>
References: <20210614102652.964395392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Guittot <vincent.guittot@linaro.org>

commit 7c7ad626d9a0ff0a36c1e2a3cfbbc6a13828d5eb upstream.

when removing a cfs_rq from the list we only check _sum value so we must
ensure that _avg and _sum stay synced so load_sum can't be null whereas
load_avg is not after propagating load in the cgroup hierarchy.

Use load_avg to compute load_sum similarly to what is done for util_sum
and runnable_sum.

Fixes: 0e2d2aaaae52 ("sched/fair: Rewrite PELT migration propagation")
Reported-by: Odin Ugedal <odin@uged.al>
Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Odin Ugedal <odin@uged.al>
Link: https://lkml.kernel.org/r/20210527122916.27683-2-vincent.guittot@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/fair.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3501,10 +3501,9 @@ update_tg_cfs_runnable(struct cfs_rq *cf
 static inline void
 update_tg_cfs_load(struct cfs_rq *cfs_rq, struct sched_entity *se, struct cfs_rq *gcfs_rq)
 {
-	long delta_avg, running_sum, runnable_sum = gcfs_rq->prop_runnable_sum;
+	long delta, running_sum, runnable_sum = gcfs_rq->prop_runnable_sum;
 	unsigned long load_avg;
 	u64 load_sum = 0;
-	s64 delta_sum;
 	u32 divider;
 
 	if (!runnable_sum)
@@ -3551,13 +3550,13 @@ update_tg_cfs_load(struct cfs_rq *cfs_rq
 	load_sum = (s64)se_weight(se) * runnable_sum;
 	load_avg = div_s64(load_sum, divider);
 
-	delta_sum = load_sum - (s64)se_weight(se) * se->avg.load_sum;
-	delta_avg = load_avg - se->avg.load_avg;
+	delta = load_avg - se->avg.load_avg;
 
 	se->avg.load_sum = runnable_sum;
 	se->avg.load_avg = load_avg;
-	add_positive(&cfs_rq->avg.load_avg, delta_avg);
-	add_positive(&cfs_rq->avg.load_sum, delta_sum);
+
+	add_positive(&cfs_rq->avg.load_avg, delta);
+	cfs_rq->avg.load_sum = cfs_rq->avg.load_avg * divider;
 }
 
 static inline void add_tg_cfs_propagate(struct cfs_rq *cfs_rq, long runnable_sum)


