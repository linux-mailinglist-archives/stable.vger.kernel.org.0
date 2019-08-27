Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B41AE9E05F
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732160AbfH0IDE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 04:03:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:60378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732194AbfH0IDE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 04:03:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A18B206BF;
        Tue, 27 Aug 2019 08:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566892983;
        bh=sERXVAUQL0WXqPWiqdhEpxNm86OC64R5zrZRprdxLpk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1W+FjBJPqDdqk7yEvdO0FeLiCphje+ksAPayN/EfMK44A18dzVnV1uWvRpZsV0ZUh
         fCM/2Lo09s4aOX/Zw7Vs1cz0Y94ovMige6kdSPK/YPmAAsQkjynapp8NY0bKcPUFR/
         WfkdevF4pWggyd5974Oy0lPLhHIJaEyUBR8cLdMw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Valentin Schneider <valentin.schneider@arm.com>,
        Ingo Molnar <mingo@kernel.org>,
        Luca Abeni <luca.abeni@santannapisa.it>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Qais Yousef <qais.yousef@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 082/162] sched/deadline: Fix double accounting of rq/running bw in push & pull
Date:   Tue, 27 Aug 2019 09:50:10 +0200
Message-Id: <20190827072740.978380340@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072738.093683223@linuxfoundation.org>
References: <20190827072738.093683223@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit f4904815f97a934258445a8f763f6b6c48f007e7 ]

{push,pull}_dl_task() always calls {de,}activate_task() with .flags=0
which sets p->on_rq=TASK_ON_RQ_MIGRATING.

{push,pull}_dl_task()->{de,}activate_task()->{de,en}queue_task()->
{de,en}queue_task_dl() calls {sub,add}_{running,rq}_bw() since
p->on_rq==TASK_ON_RQ_MIGRATING.
So {sub,add}_{running,rq}_bw() in {push,pull}_dl_task() is
double-accounting for that task.

Fix it by removing rq/running bw accounting in [push/pull]_dl_task().

Fixes: 7dd778841164 ("sched/core: Unify p->on_rq updates")
Signed-off-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Valentin Schneider <valentin.schneider@arm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Luca Abeni <luca.abeni@santannapisa.it>
Cc: Daniel Bristot de Oliveira <bristot@redhat.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Qais Yousef <qais.yousef@arm.com>
Link: https://lkml.kernel.org/r/20190802145945.18702-2-dietmar.eggemann@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/deadline.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 43901fa3f2693..1c66480afda81 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -2088,17 +2088,13 @@ retry:
 	}
 
 	deactivate_task(rq, next_task, 0);
-	sub_running_bw(&next_task->dl, &rq->dl);
-	sub_rq_bw(&next_task->dl, &rq->dl);
 	set_task_cpu(next_task, later_rq->cpu);
-	add_rq_bw(&next_task->dl, &later_rq->dl);
 
 	/*
 	 * Update the later_rq clock here, because the clock is used
 	 * by the cpufreq_update_util() inside __add_running_bw().
 	 */
 	update_rq_clock(later_rq);
-	add_running_bw(&next_task->dl, &later_rq->dl);
 	activate_task(later_rq, next_task, ENQUEUE_NOCLOCK);
 	ret = 1;
 
@@ -2186,11 +2182,7 @@ static void pull_dl_task(struct rq *this_rq)
 			resched = true;
 
 			deactivate_task(src_rq, p, 0);
-			sub_running_bw(&p->dl, &src_rq->dl);
-			sub_rq_bw(&p->dl, &src_rq->dl);
 			set_task_cpu(p, this_cpu);
-			add_rq_bw(&p->dl, &this_rq->dl);
-			add_running_bw(&p->dl, &this_rq->dl);
 			activate_task(this_rq, p, 0);
 			dmin = p->dl.deadline;
 
-- 
2.20.1



