Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34F7A2017A1
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:47:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387895AbgFSQlO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 12:41:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:36702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388665AbgFSOpN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:45:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CAB7921556;
        Fri, 19 Jun 2020 14:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592577912;
        bh=ULzMJ230Is2k3ZU3EMjmixjq11fp4tjy5YfjuKNr1PU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f0Tg1wKX2PTHMnt+F6sPd0eSr247+snjPs7U9jMQdj7ZoO9R0kcgZdd92K5Wp/H5e
         0Or4Dhic90ftiqDYHJSWlAT02CaOcw4PVjs/uwp2DMi73lk46euUWMzau7HCtcc5nn
         nHiQPzq3miP15QpdLxrVrt15ZkFaUfuPnL6Kj6vQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefano Garzarella <sgarzare@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 011/190] sched/fair: Dont NUMA balance for kthreads
Date:   Fri, 19 Jun 2020 16:30:56 +0200
Message-Id: <20200619141634.050109030@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141633.446429600@linuxfoundation.org>
References: <20200619141633.446429600@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 18f855e574d9799a0e7489f8ae6fd8447d0dd74a ]

Stefano reported a crash with using SQPOLL with io_uring:

  BUG: kernel NULL pointer dereference, address: 00000000000003b0
  CPU: 2 PID: 1307 Comm: io_uring-sq Not tainted 5.7.0-rc7 #11
  RIP: 0010:task_numa_work+0x4f/0x2c0
  Call Trace:
   task_work_run+0x68/0xa0
   io_sq_thread+0x252/0x3d0
   kthread+0xf9/0x130
   ret_from_fork+0x35/0x40

which is task_numa_work() oopsing on current->mm being NULL.

The task work is queued by task_tick_numa(), which checks if current->mm is
NULL at the time of the call. But this state isn't necessarily persistent,
if the kthread is using use_mm() to temporarily adopt the mm of a task.

Change the task_tick_numa() check to exclude kernel threads in general,
as it doesn't make sense to attempt ot balance for kthreads anyway.

Reported-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/865de121-8190-5d30-ece5-3b097dc74431@kernel.dk
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 0b4e997fea1a..4d8add44fffb 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2643,7 +2643,7 @@ void task_tick_numa(struct rq *rq, struct task_struct *curr)
 	/*
 	 * We don't care about NUMA placement if we don't have memory.
 	 */
-	if (!curr->mm || (curr->flags & PF_EXITING) || work->next != work)
+	if ((curr->flags & (PF_EXITING | PF_KTHREAD)) || work->next != work)
 		return;
 
 	/*
-- 
2.25.1



