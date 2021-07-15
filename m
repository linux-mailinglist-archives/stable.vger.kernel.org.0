Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 280123CA66E
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:45:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231193AbhGOSrw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:47:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:49802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237256AbhGOSrl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:47:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5F3FD601FF;
        Thu, 15 Jul 2021 18:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626374686;
        bh=heIKjzrVWDCz5r4LnpqUSfigJCY+N0dJARnlDFNZtsc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nQ3AMKIuixo1LzfoB9prz4756bUOJP/0G5gFZfg46HyPhW3c8dyHEqV1sRgXGk+t6
         LdD/BYggv2ObH2BfksFKA3UfvgoFMnAr0mDXjbvZJv9y8EDoYY5bHf+5cKYguNlmqc
         N9AX5yn7WAkFPy/tgJGGqMorDMnb8/eElDqF+bCc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.4 104/122] rq-qos: fix missed wake-ups in rq_qos_throttle try two
Date:   Thu, 15 Jul 2021 20:39:11 +0200
Message-Id: <20210715182519.612194347@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182448.393443551@linuxfoundation.org>
References: <20210715182448.393443551@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

commit 11c7aa0ddea8611007768d3e6b58d45dc60a19e1 upstream.

Commit 545fbd0775ba ("rq-qos: fix missed wake-ups in rq_qos_throttle")
tried to fix a problem that a process could be sleeping in rq_qos_wait()
without anyone to wake it up. However the fix is not complete and the
following can still happen:

CPU1 (waiter1)		CPU2 (waiter2)		CPU3 (waker)
rq_qos_wait()		rq_qos_wait()
  acquire_inflight_cb() -> fails
			  acquire_inflight_cb() -> fails

						completes IOs, inflight
						  decreased
  prepare_to_wait_exclusive()
			  prepare_to_wait_exclusive()
  has_sleeper = !wq_has_single_sleeper() -> true as there are two sleepers
			  has_sleeper = !wq_has_single_sleeper() -> true
  io_schedule()		  io_schedule()

Deadlock as now there's nobody to wakeup the two waiters. The logic
automatically blocking when there are already sleepers is really subtle
and the only way to make it work reliably is that we check whether there
are some waiters in the queue when adding ourselves there. That way, we
are guaranteed that at least the first process to enter the wait queue
will recheck the waiting condition before going to sleep and thus
guarantee forward progress.

Fixes: 545fbd0775ba ("rq-qos: fix missed wake-ups in rq_qos_throttle")
CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20210607112613.25344-1-jack@suse.cz
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-rq-qos.c   |    4 ++--
 include/linux/wait.h |    2 +-
 kernel/sched/wait.c  |    9 +++++++--
 3 files changed, 10 insertions(+), 5 deletions(-)

--- a/block/blk-rq-qos.c
+++ b/block/blk-rq-qos.c
@@ -266,8 +266,8 @@ void rq_qos_wait(struct rq_wait *rqw, vo
 	if (!has_sleeper && acquire_inflight_cb(rqw, private_data))
 		return;
 
-	prepare_to_wait_exclusive(&rqw->wait, &data.wq, TASK_UNINTERRUPTIBLE);
-	has_sleeper = !wq_has_single_sleeper(&rqw->wait);
+	has_sleeper = !prepare_to_wait_exclusive(&rqw->wait, &data.wq,
+						 TASK_UNINTERRUPTIBLE);
 	do {
 		/* The memory barrier in set_task_state saves us here. */
 		if (data.got_token)
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -1121,7 +1121,7 @@ do {										\
  * Waitqueues which are removed from the waitqueue_head at wakeup time
  */
 void prepare_to_wait(struct wait_queue_head *wq_head, struct wait_queue_entry *wq_entry, int state);
-void prepare_to_wait_exclusive(struct wait_queue_head *wq_head, struct wait_queue_entry *wq_entry, int state);
+bool prepare_to_wait_exclusive(struct wait_queue_head *wq_head, struct wait_queue_entry *wq_entry, int state);
 long prepare_to_wait_event(struct wait_queue_head *wq_head, struct wait_queue_entry *wq_entry, int state);
 void finish_wait(struct wait_queue_head *wq_head, struct wait_queue_entry *wq_entry);
 long wait_woken(struct wait_queue_entry *wq_entry, unsigned mode, long timeout);
--- a/kernel/sched/wait.c
+++ b/kernel/sched/wait.c
@@ -232,17 +232,22 @@ prepare_to_wait(struct wait_queue_head *
 }
 EXPORT_SYMBOL(prepare_to_wait);
 
-void
+/* Returns true if we are the first waiter in the queue, false otherwise. */
+bool
 prepare_to_wait_exclusive(struct wait_queue_head *wq_head, struct wait_queue_entry *wq_entry, int state)
 {
 	unsigned long flags;
+	bool was_empty = false;
 
 	wq_entry->flags |= WQ_FLAG_EXCLUSIVE;
 	spin_lock_irqsave(&wq_head->lock, flags);
-	if (list_empty(&wq_entry->entry))
+	if (list_empty(&wq_entry->entry)) {
+		was_empty = list_empty(&wq_head->head);
 		__add_wait_queue_entry_tail(wq_head, wq_entry);
+	}
 	set_current_state(state);
 	spin_unlock_irqrestore(&wq_head->lock, flags);
+	return was_empty;
 }
 EXPORT_SYMBOL(prepare_to_wait_exclusive);
 


