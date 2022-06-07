Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACB595407F7
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348762AbiFGRxW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:53:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349448AbiFGRus (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:50:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC08513AF3B;
        Tue,  7 Jun 2022 10:38:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D07E8615B9;
        Tue,  7 Jun 2022 17:38:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE3F2C385A5;
        Tue,  7 Jun 2022 17:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654623483;
        bh=NqwxbRucv15MoniNBWErDnERTvfSH/0JOqpfOH3JhyE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wgHxjZh56sgxFL4D7ZOKW5J8c34HJJeY33UhniaVv+sdntQgg6ei5qIwdGT6Vo5S1
         b/3BQxqOTleiiPZcv3cu+CNRPwEQ5fYI6Dz5lxZUVTbhWK0y+pX47sMsWhxpZr3wHh
         2kYla7OuCEp6Op1Agb2JrhSL4ONkVcmVgMOBDHIg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Dave Chinner <dchinner@redhat.com>,
        Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 5.10 435/452] xfs: force log and push AIL to clear pinned inodes when aborting mount
Date:   Tue,  7 Jun 2022 19:04:52 +0200
Message-Id: <20220607164921.521531633@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

commit d336f7ebc65007f5831e2297e6f3383ae8dbf8ed upstream.

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
---
 fs/xfs/xfs_mount.c |   90 +++++++++++++++++++++++++----------------------------
 1 file changed, 44 insertions(+), 46 deletions(-)

--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -632,6 +632,47 @@ xfs_check_summary_counts(
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
+	xfs_reclaim_inodes(mp);
+	xfs_health_unmount(mp);
+}
+
+/*
  * This function does the following on an initial mount of a file system:
  *	- reads the superblock from disk and init the mount struct
  *	- if we're a 32-bit kernel, do a size check on the superblock
@@ -1005,7 +1046,7 @@ xfs_mountfs(
 	/* Clean out dquots that might be in memory after quotacheck. */
 	xfs_qm_unmount(mp);
 	/*
-	 * Cancel all delayed reclaim work and reclaim the inodes directly.
+	 * Flush all inode reclamation work and flush the log.
 	 * We have to do this /after/ rtunmount and qm_unmount because those
 	 * two will have scheduled delayed reclaim for the rt/quota inodes.
 	 *
@@ -1015,11 +1056,8 @@ xfs_mountfs(
 	 * qm_unmount_quotas and therefore rely on qm_unmount to release the
 	 * quota inodes.
 	 */
-	cancel_delayed_work_sync(&mp->m_reclaim_work);
-	xfs_reclaim_inodes(mp);
-	xfs_health_unmount(mp);
+	xfs_unmount_flush_inodes(mp);
  out_log_dealloc:
-	mp->m_flags |= XFS_MOUNT_UNMOUNTING;
 	xfs_log_mount_cancel(mp);
  out_fail_wait:
 	if (mp->m_logdev_targp && mp->m_logdev_targp != mp->m_ddev_targp)
@@ -1060,47 +1098,7 @@ xfs_unmountfs(
 	xfs_rtunmount_inodes(mp);
 	xfs_irele(mp->m_rootip);
 
-	/*
-	 * We can potentially deadlock here if we have an inode cluster
-	 * that has been freed has its buffer still pinned in memory because
-	 * the transaction is still sitting in a iclog. The stale inodes
-	 * on that buffer will be pinned to the buffer until the
-	 * transaction hits the disk and the callbacks run. Pushing the AIL will
-	 * skip the stale inodes and may never see the pinned buffer, so
-	 * nothing will push out the iclog and unpin the buffer. Hence we
-	 * need to force the log here to ensure all items are flushed into the
-	 * AIL before we go any further.
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
-	 * Reclaim all inodes. At this point there should be no dirty inodes and
-	 * none should be pinned or locked. Stop background inode reclaim here
-	 * if it is still running.
-	 */
-	cancel_delayed_work_sync(&mp->m_reclaim_work);
-	xfs_reclaim_inodes(mp);
-	xfs_health_unmount(mp);
+	xfs_unmount_flush_inodes(mp);
 
 	xfs_qm_unmount(mp);
 


