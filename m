Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D44051EF786
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 14:29:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727912AbgFEM0s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 08:26:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:58888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727854AbgFEM0c (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Jun 2020 08:26:32 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3227D20897;
        Fri,  5 Jun 2020 12:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591359991;
        bh=5HVWv+yeXAK/6AIGQi9SCv3LhH94DSJPjBaZTuUGycU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GzfUl6OygOkDdNRkKMuhtUl7u1expTaiilvp+Lz9oPmBOW3kstVW5MG635eBXmKO/
         sNI0rExSMveZx+EWYXJXNqhqRBt+njfLKGI0VaamYVZEfF2kZVgSrck2ib8xaGqgoZ
         YCMjQB7N5SxJmHMrrpWkX/+TuSXhVCabBWoD6UpY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.4 2/3] sched/fair: Don't NUMA balance for kthreads
Date:   Fri,  5 Jun 2020 08:26:27 -0400
Message-Id: <20200605122629.2883065-2-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200605122629.2883065-1-sashal@kernel.org>
References: <20200605122629.2883065-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 0daf4a40a985..971e31e47bfd 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2325,7 +2325,7 @@ void task_tick_numa(struct rq *rq, struct task_struct *curr)
 	/*
 	 * We don't care about NUMA placement if we don't have memory.
 	 */
-	if (!curr->mm || (curr->flags & PF_EXITING) || work->next != work)
+	if ((curr->flags & (PF_EXITING | PF_KTHREAD)) || work->next != work)
 		return;
 
 	/*
-- 
2.25.1

