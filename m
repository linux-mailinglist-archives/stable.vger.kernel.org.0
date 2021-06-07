Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37DE939DB36
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 13:26:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230272AbhFGL2P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 07:28:15 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:53620 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230139AbhFGL2O (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Jun 2021 07:28:14 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 424941FDA1;
        Mon,  7 Jun 2021 11:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1623065182; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=VYk3TJrFrr+lHEsnNaXKyTcVO01puS4pzK82H1hP8Tw=;
        b=GtVhp/vFPwT52Kmu+aPd9eUXBqVx470QHrSFr3Wi+GEZ4FCFJWVORVIBAcEzJLNj+2QjT9
        4ICAkXJAN1LpLPfJM1sa+kL57D5J9WTx8A9CHPQXo49ZqnZNtv/lRRFtiYhDN5EhNzfCq3
        0LRSSXJEPF0tOKA0B01zZXmf7E9fVQ0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1623065182;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=VYk3TJrFrr+lHEsnNaXKyTcVO01puS4pzK82H1hP8Tw=;
        b=dQ6YM3Z4cmOR6ltwqi03dwdE5E99vYpusbf9kaQpvz+4gE86FCNrHCkhd5w6Tli4wE8dKT
        hjFokvOd0L1+CzAQ==
Received: from quack2.suse.cz (unknown [10.100.200.198])
        by relay2.suse.de (Postfix) with ESMTP id 1FC8CA3B8F;
        Mon,  7 Jun 2021 11:26:22 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id EA0041F2CA8; Mon,  7 Jun 2021 13:26:21 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Josef Bacik <josef@toxicpanda.com>,
        Oleg Nesterov <oleg@redhat.com>, <linux-block@vger.kernel.org>,
        Jan Kara <jack@suse.cz>, stable@vger.kernel.org
Subject: [PATCH] rq-qos: fix missed wake-ups in rq_qos_throttle try two
Date:   Mon,  7 Jun 2021 13:26:13 +0200
Message-Id: <20210607112613.25344-1-jack@suse.cz>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3920; h=from:subject; bh=fVXFw/MPglpM4nIVTV3vrCGL71nEBjBfatViHSO0Twk=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBgvgI4xJ4VX6B/zfqu0DwwCGSIJ4HtDmC9bPIi4utp 9qbVMQ2JATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCYL4COAAKCRCcnaoHP2RA2UFtCA CZLfOIqozkfUq3czdJfH7X/W2qfZMe8w7UPsLc08wmzjHDvEqsQ461QekrEvLMOitphVA/MOS+NWbI OLL0RO9N5mpLUrLWFIIPXXSvOtLLUF/jXuMZqfX/V6MeYEAuxQmB0jgQ/4GPW16jSnjbmLbp2nwOmA z4L9KZUbNdjpsFmY3udg6kITd1sbxJo6yCnXGkMLExJo4czOMkg2ElpDo48ub2lNCzzzYVzkz8of/s V7HdD42hAziQUHe1Pzw4ZtilR+xX9Zs+QaQL9GyrtPNHI5/pXenaeOSzLazQN1CC4ulQTu3mYn02hu tDdVw7v6RCdIazDkpTG3M+iapVUBZD
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 block/blk-rq-qos.c   | 4 ++--
 include/linux/wait.h | 2 +-
 kernel/sched/wait.c  | 9 +++++++--
 3 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/block/blk-rq-qos.c b/block/blk-rq-qos.c
index 656460636ad3..e83af7bc7591 100644
--- a/block/blk-rq-qos.c
+++ b/block/blk-rq-qos.c
@@ -266,8 +266,8 @@ void rq_qos_wait(struct rq_wait *rqw, void *private_data,
 	if (!has_sleeper && acquire_inflight_cb(rqw, private_data))
 		return;
 
-	prepare_to_wait_exclusive(&rqw->wait, &data.wq, TASK_UNINTERRUPTIBLE);
-	has_sleeper = !wq_has_single_sleeper(&rqw->wait);
+	has_sleeper = !prepare_to_wait_exclusive(&rqw->wait, &data.wq,
+						 TASK_UNINTERRUPTIBLE);
 	do {
 		/* The memory barrier in set_task_state saves us here. */
 		if (data.got_token)
diff --git a/include/linux/wait.h b/include/linux/wait.h
index fe10e8570a52..6598ae35e1b5 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -1136,7 +1136,7 @@ do {										\
  * Waitqueues which are removed from the waitqueue_head at wakeup time
  */
 void prepare_to_wait(struct wait_queue_head *wq_head, struct wait_queue_entry *wq_entry, int state);
-void prepare_to_wait_exclusive(struct wait_queue_head *wq_head, struct wait_queue_entry *wq_entry, int state);
+bool prepare_to_wait_exclusive(struct wait_queue_head *wq_head, struct wait_queue_entry *wq_entry, int state);
 long prepare_to_wait_event(struct wait_queue_head *wq_head, struct wait_queue_entry *wq_entry, int state);
 void finish_wait(struct wait_queue_head *wq_head, struct wait_queue_entry *wq_entry);
 long wait_woken(struct wait_queue_entry *wq_entry, unsigned mode, long timeout);
diff --git a/kernel/sched/wait.c b/kernel/sched/wait.c
index 183cc6ae68a6..76577d1642a5 100644
--- a/kernel/sched/wait.c
+++ b/kernel/sched/wait.c
@@ -264,17 +264,22 @@ prepare_to_wait(struct wait_queue_head *wq_head, struct wait_queue_entry *wq_ent
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
 
-- 
2.26.2

