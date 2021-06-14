Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2C603A6486
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:25:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235321AbhFNL0I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:26:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:52248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235917AbhFNLYB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:24:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DB425619A7;
        Mon, 14 Jun 2021 10:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667995;
        bh=xQasJXoVujPa56MbKuyaLQzvLXZxPivhwoPvLlnTKvY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RQetFahZuNXDKxqgQKtk1Hk3rC/MW7YFPTvanUxShcDzq8otYt70b9xQHNxF+J/4Q
         S2Mv2CJBf2rswhXZkv4WlCypmWyKdVvPo7jzE8H4MlHoddexlzD9xH84T8taIO0sem
         xvJhnMw5jSl/Pw2QddPeVErUZWYVjBmyA3h/iz/k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Odin Ugedal <odin@uged.al>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.12 154/173] sched/fair: Keep load_avg and load_sum synced
Date:   Mon, 14 Jun 2021 12:28:06 +0200
Message-Id: <20210614102703.286907102@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102658.137943264@linuxfoundation.org>
References: <20210614102658.137943264@linuxfoundation.org>
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
@@ -3494,10 +3494,9 @@ update_tg_cfs_runnable(struct cfs_rq *cf
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
@@ -3544,13 +3543,13 @@ update_tg_cfs_load(struct cfs_rq *cfs_rq
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


