Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CDBD58691E
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 13:57:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232619AbiHAL5P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 07:57:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232871AbiHAL4J (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 07:56:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A33E3E749;
        Mon,  1 Aug 2022 04:51:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C2AFCB81170;
        Mon,  1 Aug 2022 11:51:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 334BCC433C1;
        Mon,  1 Aug 2022 11:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659354696;
        bh=TBaPcf8ji5KmfeLiWir8lhWYb1nLLVbFM9xBxGqqqEg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q33VbcDRVlUfhqeRrKfkipOV83MpcFYpiv2HJtRLfOnAcrIdvv1/JcxG5ungOo1t1
         s925BjZ/mf7EPtnDQ9EBHNDIVHJikibN36KpN1rivGkWVFc3dK1ZKOAOZIbouif3XO
         nA4O/DB3C0FOZz36Djtmt/VphkRfy+GPbRhYeaNw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Brian Foster <bfoster@redhat.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 5.10 53/65] xfs: refactor xfs_file_fsync
Date:   Mon,  1 Aug 2022 13:47:10 +0200
Message-Id: <20220801114135.892518156@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220801114133.641770326@linuxfoundation.org>
References: <20220801114133.641770326@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit f22c7f87777361f94aa17f746fbadfa499248dc8 upstream.

[backported for dependency]

Factor out the log syncing logic into two helpers to make the code easier
to read and more maintainable.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_file.c |   81 +++++++++++++++++++++++++++++++++---------------------
 1 file changed, 50 insertions(+), 31 deletions(-)

--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -118,6 +118,54 @@ xfs_dir_fsync(
 	return xfs_log_force_inode(ip);
 }
 
+static xfs_lsn_t
+xfs_fsync_lsn(
+	struct xfs_inode	*ip,
+	bool			datasync)
+{
+	if (!xfs_ipincount(ip))
+		return 0;
+	if (datasync && !(ip->i_itemp->ili_fsync_fields & ~XFS_ILOG_TIMESTAMP))
+		return 0;
+	return ip->i_itemp->ili_last_lsn;
+}
+
+/*
+ * All metadata updates are logged, which means that we just have to flush the
+ * log up to the latest LSN that touched the inode.
+ *
+ * If we have concurrent fsync/fdatasync() calls, we need them to all block on
+ * the log force before we clear the ili_fsync_fields field. This ensures that
+ * we don't get a racing sync operation that does not wait for the metadata to
+ * hit the journal before returning.  If we race with clearing ili_fsync_fields,
+ * then all that will happen is the log force will do nothing as the lsn will
+ * already be on disk.  We can't race with setting ili_fsync_fields because that
+ * is done under XFS_ILOCK_EXCL, and that can't happen because we hold the lock
+ * shared until after the ili_fsync_fields is cleared.
+ */
+static  int
+xfs_fsync_flush_log(
+	struct xfs_inode	*ip,
+	bool			datasync,
+	int			*log_flushed)
+{
+	int			error = 0;
+	xfs_lsn_t		lsn;
+
+	xfs_ilock(ip, XFS_ILOCK_SHARED);
+	lsn = xfs_fsync_lsn(ip, datasync);
+	if (lsn) {
+		error = xfs_log_force_lsn(ip->i_mount, lsn, XFS_LOG_SYNC,
+					  log_flushed);
+
+		spin_lock(&ip->i_itemp->ili_lock);
+		ip->i_itemp->ili_fsync_fields = 0;
+		spin_unlock(&ip->i_itemp->ili_lock);
+	}
+	xfs_iunlock(ip, XFS_ILOCK_SHARED);
+	return error;
+}
+
 STATIC int
 xfs_file_fsync(
 	struct file		*file,
@@ -125,13 +173,10 @@ xfs_file_fsync(
 	loff_t			end,
 	int			datasync)
 {
-	struct inode		*inode = file->f_mapping->host;
-	struct xfs_inode	*ip = XFS_I(inode);
-	struct xfs_inode_log_item *iip = ip->i_itemp;
+	struct xfs_inode	*ip = XFS_I(file->f_mapping->host);
 	struct xfs_mount	*mp = ip->i_mount;
 	int			error = 0;
 	int			log_flushed = 0;
-	xfs_lsn_t		lsn = 0;
 
 	trace_xfs_file_fsync(ip);
 
@@ -155,33 +200,7 @@ xfs_file_fsync(
 	else if (mp->m_logdev_targp != mp->m_ddev_targp)
 		xfs_blkdev_issue_flush(mp->m_ddev_targp);
 
-	/*
-	 * All metadata updates are logged, which means that we just have to
-	 * flush the log up to the latest LSN that touched the inode. If we have
-	 * concurrent fsync/fdatasync() calls, we need them to all block on the
-	 * log force before we clear the ili_fsync_fields field. This ensures
-	 * that we don't get a racing sync operation that does not wait for the
-	 * metadata to hit the journal before returning. If we race with
-	 * clearing the ili_fsync_fields, then all that will happen is the log
-	 * force will do nothing as the lsn will already be on disk. We can't
-	 * race with setting ili_fsync_fields because that is done under
-	 * XFS_ILOCK_EXCL, and that can't happen because we hold the lock shared
-	 * until after the ili_fsync_fields is cleared.
-	 */
-	xfs_ilock(ip, XFS_ILOCK_SHARED);
-	if (xfs_ipincount(ip)) {
-		if (!datasync ||
-		    (iip->ili_fsync_fields & ~XFS_ILOG_TIMESTAMP))
-			lsn = iip->ili_last_lsn;
-	}
-
-	if (lsn) {
-		error = xfs_log_force_lsn(mp, lsn, XFS_LOG_SYNC, &log_flushed);
-		spin_lock(&iip->ili_lock);
-		iip->ili_fsync_fields = 0;
-		spin_unlock(&iip->ili_lock);
-	}
-	xfs_iunlock(ip, XFS_ILOCK_SHARED);
+	error = xfs_fsync_flush_log(ip, datasync, &log_flushed);
 
 	/*
 	 * If we only have a single device, and the log force about was


