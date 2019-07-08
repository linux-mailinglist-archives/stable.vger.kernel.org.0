Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8C6F622BA
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:29:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389277AbfGHP23 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:28:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:56968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389295AbfGHP22 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:28:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8EAEE204EC;
        Mon,  8 Jul 2019 15:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599707;
        bh=rTGdvXqbpBlqYW6829dqvbaQPJhzV1cWAW8WcA4eh2U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oIHExFSbIspxsa66LxibA9RIDTDI26MWt3EZcyOD6bwwBLpQnOseHbjEZ8icOwAT5
         4otp687Jj7TYy/pkChJsyAup8r8xrodnMWJNgpz0aJDg0m25DkjfAERt19O6kN16R4
         Dmohp+JLGpfVcbwiTCdeOxotK1SGluXHzYVu6Wpo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        syzbot+fab6de82892b6b9c6191@syzkaller.appspotmail.com,
        syzbot+53c0b767f7ca0dc0c451@syzkaller.appspotmail.com,
        syzbot+a3accb352f9c22041cfa@syzkaller.appspotmail.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@lst.de>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.19 51/90] fs/userfaultfd.c: disable irqs for fault_pending and event locks
Date:   Mon,  8 Jul 2019 17:13:18 +0200
Message-Id: <20190708150525.110658846@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150521.829733162@linuxfoundation.org>
References: <20190708150521.829733162@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit cbcfa130a911c613a1d9d921af2eea171c414172 upstream.

When IOCB_CMD_POLL is used on a userfaultfd, aio_poll() disables IRQs
and takes kioctx::ctx_lock, then userfaultfd_ctx::fd_wqh.lock.

This may have to wait for userfaultfd_ctx::fd_wqh.lock to be released by
userfaultfd_ctx_read(), which in turn can be waiting for
userfaultfd_ctx::fault_pending_wqh.lock or
userfaultfd_ctx::event_wqh.lock.

But elsewhere the fault_pending_wqh and event_wqh locks are taken with
IRQs enabled.  Since the IRQ handler may take kioctx::ctx_lock, lockdep
reports that a deadlock is possible.

Fix it by always disabling IRQs when taking the fault_pending_wqh and
event_wqh locks.

Commit ae62c16e105a ("userfaultfd: disable irqs when taking the
waitqueue lock") didn't fix this because it only accounted for the
fd_wqh lock, not the other locks nested inside it.

Link: http://lkml.kernel.org/r/20190627075004.21259-1-ebiggers@kernel.org
Fixes: bfe4037e722e ("aio: implement IOCB_CMD_POLL")
Signed-off-by: Eric Biggers <ebiggers@google.com>
Reported-by: syzbot+fab6de82892b6b9c6191@syzkaller.appspotmail.com
Reported-by: syzbot+53c0b767f7ca0dc0c451@syzkaller.appspotmail.com
Reported-by: syzbot+a3accb352f9c22041cfa@syzkaller.appspotmail.com
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: <stable@vger.kernel.org>	[4.19+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/userfaultfd.c |   42 ++++++++++++++++++++++++++----------------
 1 file changed, 26 insertions(+), 16 deletions(-)

--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -40,6 +40,16 @@ enum userfaultfd_state {
 /*
  * Start with fault_pending_wqh and fault_wqh so they're more likely
  * to be in the same cacheline.
+ *
+ * Locking order:
+ *	fd_wqh.lock
+ *		fault_pending_wqh.lock
+ *			fault_wqh.lock
+ *		event_wqh.lock
+ *
+ * To avoid deadlocks, IRQs must be disabled when taking any of the above locks,
+ * since fd_wqh.lock is taken by aio_poll() while it's holding a lock that's
+ * also taken in IRQ context.
  */
 struct userfaultfd_ctx {
 	/* waitqueue head for the pending (i.e. not read) userfaults */
@@ -459,7 +469,7 @@ vm_fault_t handle_userfault(struct vm_fa
 	blocking_state = return_to_userland ? TASK_INTERRUPTIBLE :
 			 TASK_KILLABLE;
 
-	spin_lock(&ctx->fault_pending_wqh.lock);
+	spin_lock_irq(&ctx->fault_pending_wqh.lock);
 	/*
 	 * After the __add_wait_queue the uwq is visible to userland
 	 * through poll/read().
@@ -471,7 +481,7 @@ vm_fault_t handle_userfault(struct vm_fa
 	 * __add_wait_queue.
 	 */
 	set_current_state(blocking_state);
-	spin_unlock(&ctx->fault_pending_wqh.lock);
+	spin_unlock_irq(&ctx->fault_pending_wqh.lock);
 
 	if (!is_vm_hugetlb_page(vmf->vma))
 		must_wait = userfaultfd_must_wait(ctx, vmf->address, vmf->flags,
@@ -553,13 +563,13 @@ vm_fault_t handle_userfault(struct vm_fa
 	 * kernel stack can be released after the list_del_init.
 	 */
 	if (!list_empty_careful(&uwq.wq.entry)) {
-		spin_lock(&ctx->fault_pending_wqh.lock);
+		spin_lock_irq(&ctx->fault_pending_wqh.lock);
 		/*
 		 * No need of list_del_init(), the uwq on the stack
 		 * will be freed shortly anyway.
 		 */
 		list_del(&uwq.wq.entry);
-		spin_unlock(&ctx->fault_pending_wqh.lock);
+		spin_unlock_irq(&ctx->fault_pending_wqh.lock);
 	}
 
 	/*
@@ -584,7 +594,7 @@ static void userfaultfd_event_wait_compl
 	init_waitqueue_entry(&ewq->wq, current);
 	release_new_ctx = NULL;
 
-	spin_lock(&ctx->event_wqh.lock);
+	spin_lock_irq(&ctx->event_wqh.lock);
 	/*
 	 * After the __add_wait_queue the uwq is visible to userland
 	 * through poll/read().
@@ -614,15 +624,15 @@ static void userfaultfd_event_wait_compl
 			break;
 		}
 
-		spin_unlock(&ctx->event_wqh.lock);
+		spin_unlock_irq(&ctx->event_wqh.lock);
 
 		wake_up_poll(&ctx->fd_wqh, EPOLLIN);
 		schedule();
 
-		spin_lock(&ctx->event_wqh.lock);
+		spin_lock_irq(&ctx->event_wqh.lock);
 	}
 	__set_current_state(TASK_RUNNING);
-	spin_unlock(&ctx->event_wqh.lock);
+	spin_unlock_irq(&ctx->event_wqh.lock);
 
 	if (release_new_ctx) {
 		struct vm_area_struct *vma;
@@ -919,10 +929,10 @@ wakeup:
 	 * the last page faults that may have been already waiting on
 	 * the fault_*wqh.
 	 */
-	spin_lock(&ctx->fault_pending_wqh.lock);
+	spin_lock_irq(&ctx->fault_pending_wqh.lock);
 	__wake_up_locked_key(&ctx->fault_pending_wqh, TASK_NORMAL, &range);
 	__wake_up(&ctx->fault_wqh, TASK_NORMAL, 1, &range);
-	spin_unlock(&ctx->fault_pending_wqh.lock);
+	spin_unlock_irq(&ctx->fault_pending_wqh.lock);
 
 	/* Flush pending events that may still wait on event_wqh */
 	wake_up_all(&ctx->event_wqh);
@@ -1135,7 +1145,7 @@ static ssize_t userfaultfd_ctx_read(stru
 
 	if (!ret && msg->event == UFFD_EVENT_FORK) {
 		ret = resolve_userfault_fork(ctx, fork_nctx, msg);
-		spin_lock(&ctx->event_wqh.lock);
+		spin_lock_irq(&ctx->event_wqh.lock);
 		if (!list_empty(&fork_event)) {
 			/*
 			 * The fork thread didn't abort, so we can
@@ -1181,7 +1191,7 @@ static ssize_t userfaultfd_ctx_read(stru
 			if (ret)
 				userfaultfd_ctx_put(fork_nctx);
 		}
-		spin_unlock(&ctx->event_wqh.lock);
+		spin_unlock_irq(&ctx->event_wqh.lock);
 	}
 
 	return ret;
@@ -1220,14 +1230,14 @@ static ssize_t userfaultfd_read(struct f
 static void __wake_userfault(struct userfaultfd_ctx *ctx,
 			     struct userfaultfd_wake_range *range)
 {
-	spin_lock(&ctx->fault_pending_wqh.lock);
+	spin_lock_irq(&ctx->fault_pending_wqh.lock);
 	/* wake all in the range and autoremove */
 	if (waitqueue_active(&ctx->fault_pending_wqh))
 		__wake_up_locked_key(&ctx->fault_pending_wqh, TASK_NORMAL,
 				     range);
 	if (waitqueue_active(&ctx->fault_wqh))
 		__wake_up(&ctx->fault_wqh, TASK_NORMAL, 1, range);
-	spin_unlock(&ctx->fault_pending_wqh.lock);
+	spin_unlock_irq(&ctx->fault_pending_wqh.lock);
 }
 
 static __always_inline void wake_userfault(struct userfaultfd_ctx *ctx,
@@ -1882,7 +1892,7 @@ static void userfaultfd_show_fdinfo(stru
 	wait_queue_entry_t *wq;
 	unsigned long pending = 0, total = 0;
 
-	spin_lock(&ctx->fault_pending_wqh.lock);
+	spin_lock_irq(&ctx->fault_pending_wqh.lock);
 	list_for_each_entry(wq, &ctx->fault_pending_wqh.head, entry) {
 		pending++;
 		total++;
@@ -1890,7 +1900,7 @@ static void userfaultfd_show_fdinfo(stru
 	list_for_each_entry(wq, &ctx->fault_wqh.head, entry) {
 		total++;
 	}
-	spin_unlock(&ctx->fault_pending_wqh.lock);
+	spin_unlock_irq(&ctx->fault_pending_wqh.lock);
 
 	/*
 	 * If more protocols will be added, there will be all shown


