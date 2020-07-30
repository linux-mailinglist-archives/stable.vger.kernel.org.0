Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A072A233AE9
	for <lists+stable@lfdr.de>; Thu, 30 Jul 2020 23:35:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730552AbgG3Vfd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jul 2020 17:35:33 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:24877 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730551AbgG3Vfc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jul 2020 17:35:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1596144932; x=1627680932;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=eFvWBQeFrJLrkrBobJ3cC5vX4KhoBqg54LUohiUx7VQ=;
  b=DDuz6MuOgkl/YJOccafdlTzpylGoGONBW1vD8+jRZb92F6MPWZ5QYw4G
   K21Hx/jxODBAqwyVW/1ATlwDymYrWOzPCEbnO+DlJMsLNyELyihMmpFuy
   1kXdmAdmeBNUs5XgLnDVpsI6Y66+SLE27EyV3b3eLfmGT5RrzSjUjyl4S
   U=;
IronPort-SDR: kzGYIOWAi6Ok6i6/SMmZJs0fCtSinSnjW0lURzuR6Eq+FzraB+ifQG6UgSTKaGAkz8ZbitHgbK
 yncyjUszWsvQ==
X-IronPort-AV: E=Sophos;i="5.75,415,1589241600"; 
   d="scan'208";a="63142780"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2c-cc689b93.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 30 Jul 2020 21:35:30 +0000
Received: from EX13MTAUWA001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2c-cc689b93.us-west-2.amazon.com (Postfix) with ESMTPS id 969C412170D
        for <stable@vger.kernel.org>; Thu, 30 Jul 2020 21:35:29 +0000 (UTC)
Received: from EX13D01UWA002.ant.amazon.com (10.43.160.74) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.118) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 30 Jul 2020 21:35:28 +0000
Received: from u87e72aa3c6c25c.ant.amazon.com (10.43.162.85) by
 EX13d01UWA002.ant.amazon.com (10.43.160.74) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 30 Jul 2020 21:35:28 +0000
From:   Samuel Mendoza-Jonas <samjonas@amazon.com>
To:     <stable@vger.kernel.org>
CC:     <fllinden@amazon.com>, <surajjs@amazon.com>, <benh@amazon.com>,
        <anchalag@amazon.com>, Samuel Mendoza-Jonas <samjonas@amazon.com>
Subject: [PATCH 4.9 4.19] xfs: fix missed wakeup on l_flush_wait
Date:   Thu, 30 Jul 2020 14:35:07 -0700
Message-ID: <20200730213507.24791-1-samjonas@amazon.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.162.85]
X-ClientProxiedBy: EX13D24UWB002.ant.amazon.com (10.43.161.159) To
 EX13d01UWA002.ant.amazon.com (10.43.160.74)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rik van Riel <riel@surriel.com>

commit cdea5459ce263fbc963657a7736762ae897a8ae6 upstream

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
---
This issue was fixed in v5.4 but didn't appear to make it to stable. The
fixed commit goes back to v2.6, so backport this to stable kernels
before v5.4. The only difference is a contextual change at
	xlog_state_do_callback(log, XFS_LI_ABORTED, NULL);
Which in v5.4 is
	xlog_state_do_callback(log, true, NULL);

 fs/xfs/xfs_log.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 360e32220f93..0c0f70e6c7d9 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2684,7 +2684,6 @@ xlog_state_do_callback(
 	int		   funcdidcallbacks; /* flag: function did callbacks */
 	int		   repeats;	/* for issuing console warnings if
 					 * looping too many times */
-	int		   wake = 0;
 
 	spin_lock(&log->l_icloglock);
 	first_iclog = iclog = log->l_iclog;
@@ -2886,11 +2885,9 @@ xlog_state_do_callback(
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
 
 
@@ -4052,7 +4049,9 @@ xfs_log_force_umount(
 	 * item committed callback functions will do this again under lock to
 	 * avoid races.
 	 */
+	spin_lock(&log->l_cilp->xc_push_lock);
 	wake_up_all(&log->l_cilp->xc_commit_wait);
+	spin_unlock(&log->l_cilp->xc_push_lock);
 	xlog_state_do_callback(log, XFS_LI_ABORTED, NULL);
 
 #ifdef XFSERRORDEBUG
-- 
2.17.1

