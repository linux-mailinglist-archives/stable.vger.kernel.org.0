Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7940EFF33F
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 17:24:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728298AbfKPPma (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 10:42:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:46074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728294AbfKPPm3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:42:29 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C005C2083E;
        Sat, 16 Nov 2019 15:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573918948;
        bh=xgT6/wLTWKXsDD6APvpdQh4mC3zZ6KWe9rFCgZs52iM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZnnbDDuSv22DRx7P0cu16SGAoztPqwDutOdl0VhmJ4Eh3ytSWo20XJv9o7cQZAmky
         Nvs6s+RZY0oJwRYsc4GfYtZErUwtgylBdEzQMfci2vXO/00qRyPIwwf2oLrt+oatDp
         xcTnHIcdS6Gf4uB4+0iVRszM/sRhdhAQ/RXgKndo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Brian Foster <bfoster@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 070/237] xfs: clear ail delwri queued bufs on unmount of shutdown fs
Date:   Sat, 16 Nov 2019 10:38:25 -0500
Message-Id: <20191116154113.7417-70-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

