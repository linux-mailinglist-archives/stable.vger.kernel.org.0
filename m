Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02FF36E625F
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:32:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbjDRMcQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:32:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbjDRMcP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:32:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BCF3D32C
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:31:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3100E63220
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:31:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4710EC433D2;
        Tue, 18 Apr 2023 12:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821103;
        bh=uXwVlug8FfZ63Ctx4eV1l+ppntFoqIhG1dcb+A+I+hQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nt60a+CK3/IF45fqVrcyCM8FukhS2Et2kjVKVjz/P3Q6AR5I+9GXWgIX/K6aljxA2
         +m0duMvfxHQ9pup97rfAbunveOdBazgRM3APKfwmlBzqQYJ8EEiKdo2kiT4oyiXsum
         Vtiom8LT559IwOKJ6XL7R/gL4JlIRbfrwYr9VHJQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, "Darrick J. Wong" <djwong@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Dave Chinner <dchinner@redhat.com>,
        Amir Goldstein <amir73il@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>
Subject: [PATCH 5.4 92/92] xfs: force log and push AIL to clear pinned inodes when aborting mount
Date:   Tue, 18 Apr 2023 14:22:07 +0200
Message-Id: <20230418120308.001845933@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120304.658273364@linuxfoundation.org>
References: <20230418120304.658273364@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

commit d336f7ebc65007f5831e2297e6f3383ae8dbf8ed upstream.

[ Slightly modify fs/xfs/xfs_mount.c to resolve merge conflicts ]

If we allocate quota inodes in the process of mounting a filesystem but
then decide to abort the mount, it's possible that the quota inodes are
sitting around pinned by the log.  Now that inode reclaim relies on the
AIL to flush inodes, we have to force the log and push the AIL in
between releasing the quota inodes and kicking off reclaim to tear down
all the incore inodes.  Do this by extracting the bits we need from the
unmount path and reusing them.  As an added bonus, failed writes during
a failed mount will not retry forever now.

This was originally found during a fuzz test of metadata directories
(xfs/1546), but the actual symptom was that reclaim hung up on the quota
inodes.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_mount.c |   90 +++++++++++++++++++++++++----------------------------
 1 file changed, 44 insertions(+), 46 deletions(-)

--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -675,6 +675,47 @@ xfs_check_summary_counts(
 }
 
 /*
+ * Flush and reclaim dirty inodes in preparation for unmount. Inodes and
+ * internal inode structures can be sitting in the CIL and AIL at this point,
+ * so we need to unpin them, write them back and/or reclaim them before unmount
+ * can proceed.
+ *
+ * An inode cluster that has been freed can have its buffer still pinned in
+ * memory because the transaction is still sitting in a iclog. The stale inodes
+ * on that buffer will be pinned to the buffer until the transaction hits the
+ * disk and the callbacks run. Pushing the AIL will skip the stale inodes and
+ * may never see the pinned buffer, so nothing will push out the iclog and
+ * unpin the buffer.
+ *
+ * Hence we need to force the log to unpin everything first. However, log
+ * forces don't wait for the discards they issue to complete, so we have to
+ * explicitly wait for them to complete here as well.
+ *
+ * Then we can tell the world we are unmounting so that error handling knows
+ * that the filesystem is going away and we should error out anything that we
+ * have been retrying in the background.  This will prevent never-ending
+ * retries in AIL pushing from hanging the unmount.
+ *
+ * Finally, we can push the AIL to clean all the remaining dirty objects, then
+ * reclaim the remaining inodes that are still in memory at this point in time.
+ */
+static void
+xfs_unmount_flush_inodes(
+	struct xfs_mount	*mp)
+{
+	xfs_log_force(mp, XFS_LOG_SYNC);
+	xfs_extent_busy_wait_all(mp);
+	flush_workqueue(xfs_discard_wq);
+
+	mp->m_flags |= XFS_MOUNT_UNMOUNTING;
+
+	xfs_ail_push_all_sync(mp->m_ail);
+	cancel_delayed_work_sync(&mp->m_reclaim_work);
+	xfs_reclaim_inodes(mp, SYNC_WAIT);
+	xfs_health_unmount(mp);
+}
+
+/*
  * This function does the following on an initial mount of a file system:
  *	- reads the superblock from disk and init the mount struct
  *	- if we're a 32-bit kernel, do a size check on the superblock
@@ -1047,7 +1088,7 @@ xfs_mountfs(
 	/* Clean out dquots that might be in memory after quotacheck. */
 	xfs_qm_unmount(mp);
 	/*
-	 * Cancel all delayed reclaim work and reclaim the inodes directly.
+	 * Flush all inode reclamation work and flush the log.
 	 * We have to do this /after/ rtunmount and qm_unmount because those
 	 * two will have scheduled delayed reclaim for the rt/quota inodes.
 	 *
@@ -1057,11 +1098,8 @@ xfs_mountfs(
 	 * qm_unmount_quotas and therefore rely on qm_unmount to release the
 	 * quota inodes.
 	 */
-	cancel_delayed_work_sync(&mp->m_reclaim_work);
-	xfs_reclaim_inodes(mp, SYNC_WAIT);
-	xfs_health_unmount(mp);
+	xfs_unmount_flush_inodes(mp);
  out_log_dealloc:
-	mp->m_flags |= XFS_MOUNT_UNMOUNTING;
 	xfs_log_mount_cancel(mp);
  out_fail_wait:
 	if (mp->m_logdev_targp && mp->m_logdev_targp != mp->m_ddev_targp)
@@ -1102,47 +1140,7 @@ xfs_unmountfs(
 	xfs_rtunmount_inodes(mp);
 	xfs_irele(mp->m_rootip);
 
-	/*
-	 * We can potentially deadlock here if we have an inode cluster
-	 * that has been freed has its buffer still pinned in memory because
-	 * the transaction is still sitting in a iclog. The stale inodes
-	 * on that buffer will have their flush locks held until the
-	 * transaction hits the disk and the callbacks run. the inode
-	 * flush takes the flush lock unconditionally and with nothing to
-	 * push out the iclog we will never get that unlocked. hence we
-	 * need to force the log first.
-	 */
-	xfs_log_force(mp, XFS_LOG_SYNC);
-
-	/*
-	 * Wait for all busy extents to be freed, including completion of
-	 * any discard operation.
-	 */
-	xfs_extent_busy_wait_all(mp);
-	flush_workqueue(xfs_discard_wq);
-
-	/*
-	 * We now need to tell the world we are unmounting. This will allow
-	 * us to detect that the filesystem is going away and we should error
-	 * out anything that we have been retrying in the background. This will
-	 * prevent neverending retries in AIL pushing from hanging the unmount.
-	 */
-	mp->m_flags |= XFS_MOUNT_UNMOUNTING;
-
-	/*
-	 * Flush all pending changes from the AIL.
-	 */
-	xfs_ail_push_all_sync(mp->m_ail);
-
-	/*
-	 * And reclaim all inodes.  At this point there should be no dirty
-	 * inodes and none should be pinned or locked, but use synchronous
-	 * reclaim just to be sure. We can stop background inode reclaim
-	 * here as well if it is still running.
-	 */
-	cancel_delayed_work_sync(&mp->m_reclaim_work);
-	xfs_reclaim_inodes(mp, SYNC_WAIT);
-	xfs_health_unmount(mp);
+	xfs_unmount_flush_inodes(mp);
 
 	xfs_qm_unmount(mp);
 


