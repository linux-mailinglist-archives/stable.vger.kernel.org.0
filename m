Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72E31226828
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:17:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387843AbgGTQP0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:15:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:56284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388410AbgGTQPZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:15:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 52CDF20656;
        Mon, 20 Jul 2020 16:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261724;
        bh=JPEzLH6tKL+WMDuIPV6rnfvXsiGH+MU8f5d/RrU/mdU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jV6qWQxJjbtpWQxUffQXqYE0HJkIZse2luGdK5apWavP772u1YGdu7/7EOqbzdqAG
         yTaRFlfEE2nNuCdYpBUs2d76uDyYWxqwA07jUXcSEjQxZKal5F/VqpRNUccHBKDxrh
         zE/u5kEFhjqCx5c9qa/pOwnXL8CJUBw4DPsY0Ir8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vincent Guittot <vincent.guittot@linaro.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Valentin Schneider <valentin.schneider@arm.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>
Subject: [PATCH 5.7 220/244] sched/fair: handle case of task_h_load() returning 0
Date:   Mon, 20 Jul 2020 17:38:11 +0200
Message-Id: <20200720152836.312927779@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152825.863040590@linuxfoundation.org>
References: <20200720152825.863040590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Guittot <vincent.guittot@linaro.org>

commit 01cfcde9c26d8555f0e6e9aea9d6049f87683998 upstream.

task_h_load() can return 0 in some situations like running stress-ng
mmapfork, which forks thousands of threads, in a sched group on a 224 cores
system. The load balance doesn't handle this correctly because
env->imbalance never decreases and it will stop pulling tasks only after
reaching loop_max, which can be equal to the number of running tasks of
the cfs. Make sure that imbalance will be decreased by at least 1.

misfit task is the other feature that doesn't handle correctly such
situation although it's probably more difficult to face the problem
because of the smaller number of CPUs and running tasks on heterogenous
system.

We can't simply ensure that task_h_load() returns at least one because it
would imply to handle underflow in other places.

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Valentin Schneider <valentin.schneider@arm.com>
Reviewed-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Tested-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: <stable@vger.kernel.org> # v4.4+
Link: https://lkml.kernel.org/r/20200710152426.16981-1-vincent.guittot@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/sched/fair.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4033,7 +4033,11 @@ static inline void update_misfit_status(
 		return;
 	}
 
-	rq->misfit_task_load = task_h_load(p);
+	/*
+	 * Make sure that misfit_task_load will not be null even if
+	 * task_h_load() returns 0.
+	 */
+	rq->misfit_task_load = max_t(unsigned long, task_h_load(p), 1);
 }
 
 #else /* CONFIG_SMP */
@@ -7633,7 +7637,14 @@ static int detach_tasks(struct lb_env *e
 
 		switch (env->migration_type) {
 		case migrate_load:
-			load = task_h_load(p);
+			/*
+			 * Depending of the number of CPUs and tasks and the
+			 * cgroup hierarchy, task_h_load() can return a null
+			 * value. Make sure that env->imbalance decreases
+			 * otherwise detach_tasks() will stop only after
+			 * detaching up to loop_max tasks.
+			 */
+			load = max_t(unsigned long, task_h_load(p), 1);
 
 			if (sched_feat(LB_MIN) &&
 			    load < 16 && !env->sd->nr_balance_failed)


