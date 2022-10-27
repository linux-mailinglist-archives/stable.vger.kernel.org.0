Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7036660FEF8
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 19:10:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236981AbiJ0RKM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 13:10:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237107AbiJ0RKK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 13:10:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 362234AD56
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 10:10:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C776362369
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 17:10:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCBD1C433C1;
        Thu, 27 Oct 2022 17:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666890608;
        bh=F2UJkgs05Ppl/TINGlI7KTsm0sSTdQ+1Cf5x1RGfonU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T4Uqw1mKRtxAiQ0D1pm6JNEtX0leKZMP/IK8LwNLdFXXtyKMg58TiMtOhih60v3Iy
         pHoitN8nrwDnNCMBoEKu4VTFYK5YdFFOybvogBsZY4KtCM5H7XpQXQwTlzQHqh/DMd
         qsUOZBEd7zhJBrNGWPsnZQOGj6YE/w1zcV1C613c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Chandan Babu R <chandan.babu@oracle.com>
Subject: [PATCH 5.4 25/53] xfs: move inode flush to the sync workqueue
Date:   Thu, 27 Oct 2022 18:56:13 +0200
Message-Id: <20221027165050.776938434@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165049.817124510@linuxfoundation.org>
References: <20221027165049.817124510@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit f0f7a674d4df1510d8ca050a669e1420cf7d7fab upstream.

[ Modify fs/xfs/xfs_super.c to include the changes at locations suitable for
 5.4-lts kernel ]

Move the inode dirty data flushing to a workqueue so that multiple
threads can take advantage of a single thread's flushing work.  The
ratelimiting technique used in bdd4ee4 was not successful, because
threads that skipped the inode flush scan due to ratelimiting would
ENOSPC early, which caused occasional (but noticeable) changes in
behavior and sporadic fstest regressions.

Therefore, make all the writer threads wait on a single inode flush,
which eliminates both the stampeding hordes of flushers and the small
window in which a write could fail with ENOSPC because it lost the
ratelimit race after even another thread freed space.

Fixes: c6425702f21e ("xfs: ratelimit inode flush on buffered write ENOSPC")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_mount.h |    5 +++++
 fs/xfs/xfs_super.c |   28 +++++++++++++++++++++++-----
 2 files changed, 28 insertions(+), 5 deletions(-)

--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -179,6 +179,11 @@ typedef struct xfs_mount {
 	struct xfs_error_cfg	m_error_cfg[XFS_ERR_CLASS_MAX][XFS_ERR_ERRNO_MAX];
 	struct xstats		m_stats;	/* per-fs stats */
 
+	/*
+	 * Workqueue item so that we can coalesce multiple inode flush attempts
+	 * into a single flush.
+	 */
+	struct work_struct	m_flush_inodes_work;
 	struct workqueue_struct *m_buf_workqueue;
 	struct workqueue_struct	*m_unwritten_workqueue;
 	struct workqueue_struct	*m_cil_workqueue;
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -840,6 +840,20 @@ xfs_destroy_mount_workqueues(
 	destroy_workqueue(mp->m_buf_workqueue);
 }
 
+static void
+xfs_flush_inodes_worker(
+	struct work_struct	*work)
+{
+	struct xfs_mount	*mp = container_of(work, struct xfs_mount,
+						   m_flush_inodes_work);
+	struct super_block	*sb = mp->m_super;
+
+	if (down_read_trylock(&sb->s_umount)) {
+		sync_inodes_sb(sb);
+		up_read(&sb->s_umount);
+	}
+}
+
 /*
  * Flush all dirty data to disk. Must not be called while holding an XFS_ILOCK
  * or a page lock. We use sync_inodes_sb() here to ensure we block while waiting
@@ -850,12 +864,15 @@ void
 xfs_flush_inodes(
 	struct xfs_mount	*mp)
 {
-	struct super_block	*sb = mp->m_super;
+	/*
+	 * If flush_work() returns true then that means we waited for a flush
+	 * which was already in progress.  Don't bother running another scan.
+	 */
+	if (flush_work(&mp->m_flush_inodes_work))
+		return;
 
-	if (down_read_trylock(&sb->s_umount)) {
-		sync_inodes_sb(sb);
-		up_read(&sb->s_umount);
-	}
+	queue_work(mp->m_sync_workqueue, &mp->m_flush_inodes_work);
+	flush_work(&mp->m_flush_inodes_work);
 }
 
 /* Catch misguided souls that try to use this interface on XFS */
@@ -1532,6 +1549,7 @@ xfs_mount_alloc(
 	spin_lock_init(&mp->m_perag_lock);
 	mutex_init(&mp->m_growlock);
 	atomic_set(&mp->m_active_trans, 0);
+	INIT_WORK(&mp->m_flush_inodes_work, xfs_flush_inodes_worker);
 	INIT_DELAYED_WORK(&mp->m_reclaim_work, xfs_reclaim_worker);
 	INIT_DELAYED_WORK(&mp->m_eofblocks_work, xfs_eofblocks_worker);
 	INIT_DELAYED_WORK(&mp->m_cowblocks_work, xfs_cowblocks_worker);


