Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31FD524BAC1
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 14:18:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730164AbgHTMQb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 08:16:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:40426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730093AbgHTJ4v (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:56:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 426E620855;
        Thu, 20 Aug 2020 09:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597917410;
        bh=v82VMAnIc4Uxb3auCZw26sAs6sE1Xz0aSxH4vCm1s5o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OmRAzxyRgibsOC9w5OyuT6ffhFKbnegvBZ1t4s5ixJvZAoKA1XQy4ETG0UtkhZo8D
         XQHHPN1cLnUWiESYITvkOYguZQIScsATMsHCOTcqMHDScCx4/g1rHhKvEtp603+k6s
         7RuNIZo9nQBeZptrlaQCSH9VmvaLpS/Mj6MY/3fg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Mason <clm@fb.com>,
        Rik van Riel <riel@surriel.com>,
        Dave Chinner <dchinner@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Samuel Mendoza-Jonas <samjonas@amazon.com>,
        Frank van der Linden <fllinden@amazon.com>,
        Suraj Jitindar Singh <surajjs@amazon.com>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        Anchal Agarwal <anchalag@amazon.com>
Subject: [PATCH 4.9 021/212] xfs: fix missed wakeup on l_flush_wait
Date:   Thu, 20 Aug 2020 11:19:54 +0200
Message-Id: <20200820091603.404319017@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091602.251285210@linuxfoundation.org>
References: <20200820091602.251285210@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rik van Riel <riel@surriel.com>

commit cdea5459ce263fbc963657a7736762ae897a8ae6 upstream.

The code in xlog_wait uses the spinlock to make adding the task to
the wait queue, and setting the task state to UNINTERRUPTIBLE atomic
with respect to the waker.

Doing the wakeup after releasing the spinlock opens up the following
race condition:

Task 1					task 2
add task to wait queue
					wake up task
set task state to UNINTERRUPTIBLE

This issue was found through code inspection as a result of kworkers
being observed stuck in UNINTERRUPTIBLE state with an empty
wait queue. It is rare and largely unreproducable.

Simply moving the spin_unlock to after the wake_up_all results
in the waker not being able to see a task on the waitqueue before
it has set its state to UNINTERRUPTIBLE.

This bug dates back to the conversion of this code to generic
waitqueue infrastructure from a counting semaphore back in 2008
which didn't place the wakeups consistently w.r.t. to the relevant
spin locks.

[dchinner: Also fix a similar issue in the shutdown path on
xc_commit_wait. Update commit log with more details of the issue.]

Fixes: d748c62367eb ("[XFS] Convert l_flushsema to a sv_t")
Reported-by: Chris Mason <clm@fb.com>
Signed-off-by: Rik van Riel <riel@surriel.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Cc: stable@vger.kernel.org # 4.9.x-4.19.x
[modified for contextual change near xlog_state_do_callback()]
Signed-off-by: Samuel Mendoza-Jonas <samjonas@amazon.com>
Reviewed-by: Frank van der Linden <fllinden@amazon.com>
Reviewed-by: Suraj Jitindar Singh <surajjs@amazon.com>
Reviewed-by: Benjamin Herrenschmidt <benh@amazon.com>
Reviewed-by: Anchal Agarwal <anchalag@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/xfs/xfs_log.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2634,7 +2634,6 @@ xlog_state_do_callback(
 	int		   funcdidcallbacks; /* flag: function did callbacks */
 	int		   repeats;	/* for issuing console warnings if
 					 * looping too many times */
-	int		   wake = 0;
 
 	spin_lock(&log->l_icloglock);
 	first_iclog = iclog = log->l_iclog;
@@ -2836,11 +2835,9 @@ xlog_state_do_callback(
 #endif
 
 	if (log->l_iclog->ic_state & (XLOG_STATE_ACTIVE|XLOG_STATE_IOERROR))
-		wake = 1;
-	spin_unlock(&log->l_icloglock);
-
-	if (wake)
 		wake_up_all(&log->l_flush_wait);
+
+	spin_unlock(&log->l_icloglock);
 }
 
 
@@ -4002,7 +3999,9 @@ xfs_log_force_umount(
 	 * item committed callback functions will do this again under lock to
 	 * avoid races.
 	 */
+	spin_lock(&log->l_cilp->xc_push_lock);
 	wake_up_all(&log->l_cilp->xc_commit_wait);
+	spin_unlock(&log->l_cilp->xc_push_lock);
 	xlog_state_do_callback(log, XFS_LI_ABORTED, NULL);
 
 #ifdef XFSERRORDEBUG


