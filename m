Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 588363BF004
	for <lists+stable@lfdr.de>; Wed,  7 Jul 2021 21:05:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230500AbhGGTHw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Jul 2021 15:07:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41964 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231142AbhGGTHw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Jul 2021 15:07:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625684711;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Q4SO5ZfrTWxlwKe3MYbD+wDiZHgLaanRMH/JOhXsvA8=;
        b=AguPQptmrzGpQVAgAUPFZ8/VvnJigtq37e/A0cBq0PFMnRaeOWhQVG8Ns5I/7mwkDAJYUQ
        yvLdQVP0DVTE3vQXHAa4p5dv3DSOVMJbWn0lxKyM5EI0ahI2sEcK+x4OX/tQ3XmnPtwxk0
        kMiJC/oj6DFwqcyYnj8o4+II47PtbU4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-340-wOkl9LZTOaaT6-PggZHJgA-1; Wed, 07 Jul 2021 15:05:08 -0400
X-MC-Unique: wOkl9LZTOaaT6-PggZHJgA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0925556B43;
        Wed,  7 Jul 2021 19:05:07 +0000 (UTC)
Received: from lorien.usersys.redhat.com (ovpn-116-12.rdu2.redhat.com [10.10.116.12])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 472A760843;
        Wed,  7 Jul 2021 19:04:58 +0000 (UTC)
From:   Phil Auld <pauld@redhat.com>
To:     linux-kernel <linux-kernel@vger.kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Waiman Long <longman@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        stable@vger.kernel.org, Phil Auld <pauld@redhat.com>
Subject: [PATCH] sched: Fix nr_uninterruptible race causing increasing load average
Date:   Wed,  7 Jul 2021 15:04:57 -0400
Message-Id: <20210707190457.60521-1-pauld@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On systems with weaker memory ordering (e.g. power) commit dbfb089d360b
("sched: Fix loadavg accounting race") causes increasing values of load
average (via rq->calc_load_active and calc_load_tasks) due to the wakeup
CPU not always seeing the write to task->sched_contributes_to_load in
__schedule(). Missing that we fail to decrement nr_uninterruptible when
waking up a task which incremented nr_uninterruptible when it slept.

The rq->lock serialization is insufficient across different rq->locks.

Add smp_wmb() to schedule and smp_rmb() before the read in
ttwu_do_activate().

Fixes: dbfb089d360b ("sched: Fix loadavg accounting race")
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Waiman Long <longman@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Phil Auld <pauld@redhat.com>
---
 kernel/sched/core.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 4ca80df205ce..ced7074716eb 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2992,6 +2992,8 @@ ttwu_do_activate(struct rq *rq, struct task_struct *p, int wake_flags,
 
 	lockdep_assert_held(&rq->lock);
 
+	/* Pairs with smp_wmb in __schedule() */
+	smp_rmb();
 	if (p->sched_contributes_to_load)
 		rq->nr_uninterruptible--;
 
@@ -5084,6 +5086,11 @@ static void __sched notrace __schedule(bool preempt)
 				!(prev_state & TASK_NOLOAD) &&
 				!(prev->flags & PF_FROZEN);
 
+			/*
+			 * Make sure the previous write is ordered before p->on_rq etc so
+			 * that it is visible to other cpus in the wakeup path (ttwu_do_activate()).
+			 */
+			smp_wmb();
 			if (prev->sched_contributes_to_load)
 				rq->nr_uninterruptible++;
 
-- 
2.18.0

