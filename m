Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5E1910BD53
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:28:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731343AbfK0U6q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:58:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:50080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731075AbfK0U6p (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:58:45 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A41BC2158C;
        Wed, 27 Nov 2019 20:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888324;
        bh=xgT6/wLTWKXsDD6APvpdQh4mC3zZ6KWe9rFCgZs52iM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2coAOA4fYzjVuWFYlX2MvmYyQ0rxNz8uF+Fvdv+9wCFDPAIvC1hML22h/7thyPrHs
         DvYKeCMGuckOyGrv10JaJ9p8Qtue0msb5xhP8fPpCNKcWe/LdfffvvNqxSC/yCYyYa
         vGCzgSD/6u3oycSaLk5VmOUCZH9+L2KhLbf0Ipd4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 089/306] xfs: clear ail delwri queued bufs on unmount of shutdown fs
Date:   Wed, 27 Nov 2019 21:28:59 +0100
Message-Id: <20191127203121.421898916@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian Foster <bfoster@redhat.com>

[ Upstream commit efc3289cf8d39c34502a7cc9695ca2fa125aad0c ]

In the typical unmount case, the AIL is forced out by the unmount
sequence before the xfsaild task is stopped. Since AIL items are
removed on writeback completion, this means that the AIL
->ail_buf_list delwri queue has been drained. This is not always
true in the shutdown case, however.

It's possible for buffers to sit on a delwri queue for a period of
time across submission attempts if said items are locked or have
been relogged and pinned since first added to the queue. If the
attempt to log such an item results in a log I/O error, the error
processing can shutdown the fs, remove the item from the AIL, stale
the buffer (dropping the LRU reference) and clear its delwri queue
state. The latter bit means the buffer will be released from a
delwri queue on the next submission attempt, but this might never
occur if the filesystem has shutdown and the AIL is empty.

This means that such buffers are held indefinitely by the AIL delwri
queue across destruction of the AIL. Aside from being a memory leak,
these buffers can also hold references to in-core perag structures.
The latter problem manifests as a generic/475 failure, reproducing
the following asserts at unmount time:

  XFS: Assertion failed: atomic_read(&pag->pag_ref) == 0,
	file: fs/xfs/xfs_mount.c, line: 151
  XFS: Assertion failed: atomic_read(&pag->pag_ref) == 0,
	file: fs/xfs/xfs_mount.c, line: 132

To prevent this problem, clear the AIL delwri queue as a final step
before xfsaild() exit. The !empty state should never occur in the
normal case, so add an assert to catch unexpected problems going
forward.

[dgc: add comment explaining need for xfs_buf_delwri_cancel() after
 calling xfs_buf_delwri_submit_nowait().]

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_buf.c       |  7 +++++++
 fs/xfs/xfs_trans_ail.c | 28 ++++++++++++++++++++++------
 2 files changed, 29 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index f4a89c94c931b..e36124546d0db 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -2025,6 +2025,13 @@ xfs_buf_delwri_submit_buffers(
  * is only safely useable for callers that can track I/O completion by higher
  * level means, e.g. AIL pushing as the @buffer_list is consumed in this
  * function.
+ *
+ * Note: this function will skip buffers it would block on, and in doing so
+ * leaves them on @buffer_list so they can be retried on a later pass. As such,
+ * it is up to the caller to ensure that the buffer list is fully submitted or
+ * cancelled appropriately when they are finished with the list. Failure to
+ * cancel or resubmit the list until it is empty will result in leaked buffers
+ * at unmount time.
  */
 int
 xfs_buf_delwri_submit_nowait(
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 55326f971cb36..d3a4e89bf4a0d 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -531,17 +531,33 @@ xfsaild(
 			set_current_state(TASK_INTERRUPTIBLE);
 
 		/*
-		 * Check kthread_should_stop() after we set the task state
-		 * to guarantee that we either see the stop bit and exit or
-		 * the task state is reset to runnable such that it's not
-		 * scheduled out indefinitely and detects the stop bit at
-		 * next iteration.
-		 *
+		 * Check kthread_should_stop() after we set the task state to
+		 * guarantee that we either see the stop bit and exit or the
+		 * task state is reset to runnable such that it's not scheduled
+		 * out indefinitely and detects the stop bit at next iteration.
 		 * A memory barrier is included in above task state set to
 		 * serialize again kthread_stop().
 		 */
 		if (kthread_should_stop()) {
 			__set_current_state(TASK_RUNNING);
+
+			/*
+			 * The caller forces out the AIL before stopping the
+			 * thread in the common case, which means the delwri
+			 * queue is drained. In the shutdown case, the queue may
+			 * still hold relogged buffers that haven't been
+			 * submitted because they were pinned since added to the
+			 * queue.
+			 *
+			 * Log I/O error processing stales the underlying buffer
+			 * and clears the delwri state, expecting the buf to be
+			 * removed on the next submission attempt. That won't
+			 * happen if we're shutting down, so this is the last
+			 * opportunity to release such buffers from the queue.
+			 */
+			ASSERT(list_empty(&ailp->ail_buf_list) ||
+			       XFS_FORCED_SHUTDOWN(ailp->ail_mount));
+			xfs_buf_delwri_cancel(&ailp->ail_buf_list);
 			break;
 		}
 
-- 
2.20.1



