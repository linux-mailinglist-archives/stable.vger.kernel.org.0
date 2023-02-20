Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C04FD69CD70
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:49:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232397AbjBTNtX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:49:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232395AbjBTNtW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:49:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB3441E5D4
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:49:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 88922B80D1F
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:49:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFAD2C4339E;
        Mon, 20 Feb 2023 13:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676900943;
        bh=bO9tk2O6Ds6dPv3/exzNEz2Is8co/RwC5mnOg6Uj+LQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GRwHaUJDoCyGwFDDUKa0IsKwLWq9uI253Flaubnrh5HsjdyrGMqLmcGXTa0u0qYez
         gyZAdNztJ8qiu66eriAP6SpG8kTvz7K2vWwHV/2AHJeVeI7VnqHb/k1Yw33vysppLA
         2jcvgLs9jIPgqhJ2BgrhvH1TtpzgTQoIosz9jfCA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Brian Foster <bfoster@redhat.com>,
        Gao Xiang <hsiangkao@redhat.com>,
        Allison Henderson <allison.henderson@oracle.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Bill ODonnell <billodo@redhat.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Chandan Babu R <chandan.babu@oracle.com>
Subject: [PATCH 5.4 126/156] xfs: sync lazy sb accounting on quiesce of read-only mounts
Date:   Mon, 20 Feb 2023 14:36:10 +0100
Message-Id: <20230220133607.839612832@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133602.515342638@linuxfoundation.org>
References: <20230220133602.515342638@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian Foster <bfoster@redhat.com>

commit 50d25484bebe94320c49dd1347d3330c7063bbdb upstream.

[ Modify xfs_log_unmount_write() to return zero when the log is in a read-only
state ]

xfs_log_sbcount() syncs the superblock specifically to accumulate
the in-core percpu superblock counters and commit them to disk. This
is required to maintain filesystem consistency across quiesce
(freeze, read-only mount/remount) or unmount when lazy superblock
accounting is enabled because individual transactions do not update
the superblock directly.

This mechanism works as expected for writable mounts, but
xfs_log_sbcount() skips the update for read-only mounts. Read-only
mounts otherwise still allow log recovery and write out an unmount
record during log quiesce. If a read-only mount performs log
recovery, it can modify the in-core superblock counters and write an
unmount record when the filesystem unmounts without ever syncing the
in-core counters. This leaves the filesystem with a clean log but in
an inconsistent state with regard to lazy sb counters.

Update xfs_log_sbcount() to use the same logic
xfs_log_unmount_write() uses to determine when to write an unmount
record. This ensures that lazy accounting is always synced before
the log is cleaned. Refactor this logic into a new helper to
distinguish between a writable filesystem and a writable log.
Specifically, the log is writable unless the filesystem is mounted
with the norecovery mount option, the underlying log device is
read-only, or the filesystem is shutdown. Drop the freeze state
check because the update is already allowed during the freezing
process and no context calls this function on an already frozen fs.
Also, retain the shutdown check in xfs_log_unmount_write() to catch
the case where the preceding log force might have triggered a
shutdown.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Gao Xiang <hsiangkao@redhat.com>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Bill O'Donnell <billodo@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_log.c   |   28 ++++++++++++++++++++--------
 fs/xfs/xfs_log.h   |    1 +
 fs/xfs/xfs_mount.c |    3 +--
 3 files changed, 22 insertions(+), 10 deletions(-)

--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -369,6 +369,25 @@ xlog_tic_add_region(xlog_ticket_t *tic,
 	tic->t_res_num++;
 }
 
+bool
+xfs_log_writable(
+	struct xfs_mount	*mp)
+{
+	/*
+	 * Never write to the log on norecovery mounts, if the block device is
+	 * read-only, or if the filesystem is shutdown. Read-only mounts still
+	 * allow internal writes for log recovery and unmount purposes, so don't
+	 * restrict that case here.
+	 */
+	if (mp->m_flags & XFS_MOUNT_NORECOVERY)
+		return false;
+	if (xfs_readonly_buftarg(mp->m_log->l_targ))
+		return false;
+	if (XFS_FORCED_SHUTDOWN(mp))
+		return false;
+	return true;
+}
+
 /*
  * Replenish the byte reservation required by moving the grant write head.
  */
@@ -895,15 +914,8 @@ xfs_log_unmount_write(xfs_mount_t *mp)
 #endif
 	int		 error;
 
-	/*
-	 * Don't write out unmount record on norecovery mounts or ro devices.
-	 * Or, if we are doing a forced umount (typically because of IO errors).
-	 */
-	if (mp->m_flags & XFS_MOUNT_NORECOVERY ||
-	    xfs_readonly_buftarg(log->l_targ)) {
-		ASSERT(mp->m_flags & XFS_MOUNT_RDONLY);
+	if (!xfs_log_writable(mp))
 		return 0;
-	}
 
 	error = xfs_log_force(mp, XFS_LOG_SYNC);
 	ASSERT(error || !(XLOG_FORCED_SHUTDOWN(log)));
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -132,6 +132,7 @@ int	  xfs_log_reserve(struct xfs_mount *
 int	  xfs_log_regrant(struct xfs_mount *mp, struct xlog_ticket *tic);
 void      xfs_log_unmount(struct xfs_mount *mp);
 int	  xfs_log_force_umount(struct xfs_mount *mp, int logerror);
+bool	xfs_log_writable(struct xfs_mount *mp);
 
 struct xlog_ticket *xfs_log_ticket_get(struct xlog_ticket *ticket);
 void	  xfs_log_ticket_put(struct xlog_ticket *ticket);
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1218,8 +1218,7 @@ xfs_fs_writable(
 int
 xfs_log_sbcount(xfs_mount_t *mp)
 {
-	/* allow this to proceed during the freeze sequence... */
-	if (!xfs_fs_writable(mp, SB_FREEZE_COMPLETE))
+	if (!xfs_log_writable(mp))
 		return 0;
 
 	/*


