Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12ABD6BB1CB
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:30:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232621AbjCOMat (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:30:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232441AbjCOM3k (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:29:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87DF295E1E
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:28:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E1FEB61ABD
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:28:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00C88C4339B;
        Wed, 15 Mar 2023 12:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883308;
        bh=qx0MY83mQC+jeSsJHwSIXz3zc/4twZaR9UaVDbhxRmI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jGUjqnWeWDrJ/NusRICY6E5I6MBnsD8ld2wFIMZRKpzjABUUYhIEQAu5HkiX4AXCQ
         aY8RhKcxImQh8sJr49IS5KiFjps+7LqhNhC6aSSMfEaNMLnGWPXPxOEfDFanwv/A77
         10j44PRkD2FWi+F7iZEHcRJCNanybTEOcDhXbV1w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Christian Brauner <brauner@kernel.org>,
        Amir Goldstein <amir73il@gmail.com>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 094/145] xfs: use setattr_copy to set vfs inode attributes
Date:   Wed, 15 Mar 2023 13:12:40 +0100
Message-Id: <20230315115742.072177117@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115738.951067403@linuxfoundation.org>
References: <20230315115738.951067403@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

commit e014f37db1a2d109afa750042ac4d69cf3e3d88e upsream.

Filipe Manana pointed out that XFS' behavior w.r.t. setuid/setgid
revocation isn't consistent with btrfs[1] or ext4.  Those two
filesystems use the VFS function setattr_copy to convey certain
attributes from struct iattr into the VFS inode structure.

Andrey Zhadchenko reported[2] that XFS uses the wrong user namespace to
decide if it should clear setgid and setuid on a file attribute update.
This is a second symptom of the problem that Filipe noticed.

XFS, on the other hand, open-codes setattr_copy in xfs_setattr_mode,
xfs_setattr_nonsize, and xfs_setattr_time.  Regrettably, setattr_copy is
/not/ a simple copy function; it contains additional logic to clear the
setgid bit when setting the mode, and XFS' version no longer matches.

The VFS implements its own setuid/setgid stripping logic, which
establishes consistent behavior.  It's a tad unfortunate that it's
scattered across notify_change, should_remove_suid, and setattr_copy but
XFS should really follow the Linux VFS.  Adapt XFS to use the VFS
functions and get rid of the old functions.

[1] https://lore.kernel.org/fstests/CAL3q7H47iNQ=Wmk83WcGB-KBJVOEtR9+qGczzCeXJ9Y2KCV25Q@mail.gmail.com/
[2] https://lore.kernel.org/linux-xfs/20220221182218.748084-1-andrey.zhadchenko@virtuozzo.com/

Fixes: 7fa294c8991c ("userns: Allow chown and setgid preservation")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Tested-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_iops.c | 56 +++--------------------------------------------
 fs/xfs/xfs_pnfs.c |  3 ++-
 2 files changed, 5 insertions(+), 54 deletions(-)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index a607d6aca5c4d..1eb71275e5b09 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -634,37 +634,6 @@ xfs_vn_getattr(
 	return 0;
 }
 
-static void
-xfs_setattr_mode(
-	struct xfs_inode	*ip,
-	struct iattr		*iattr)
-{
-	struct inode		*inode = VFS_I(ip);
-	umode_t			mode = iattr->ia_mode;
-
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
-
-	inode->i_mode &= S_IFMT;
-	inode->i_mode |= mode & ~S_IFMT;
-}
-
-void
-xfs_setattr_time(
-	struct xfs_inode	*ip,
-	struct iattr		*iattr)
-{
-	struct inode		*inode = VFS_I(ip);
-
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
-
-	if (iattr->ia_valid & ATTR_ATIME)
-		inode->i_atime = iattr->ia_atime;
-	if (iattr->ia_valid & ATTR_CTIME)
-		inode->i_ctime = iattr->ia_ctime;
-	if (iattr->ia_valid & ATTR_MTIME)
-		inode->i_mtime = iattr->ia_mtime;
-}
-
 static int
 xfs_vn_change_ok(
 	struct user_namespace	*mnt_userns,
@@ -763,16 +732,6 @@ xfs_setattr_nonsize(
 		gid = (mask & ATTR_GID) ? iattr->ia_gid : igid;
 		uid = (mask & ATTR_UID) ? iattr->ia_uid : iuid;
 
-		/*
-		 * CAP_FSETID overrides the following restrictions:
-		 *
-		 * The set-user-ID and set-group-ID bits of a file will be
-		 * cleared upon successful return from chown()
-		 */
-		if ((inode->i_mode & (S_ISUID|S_ISGID)) &&
-		    !capable(CAP_FSETID))
-			inode->i_mode &= ~(S_ISUID|S_ISGID);
-
 		/*
 		 * Change the ownerships and register quota modifications
 		 * in the transaction.
@@ -784,7 +743,6 @@ xfs_setattr_nonsize(
 				olddquot1 = xfs_qm_vop_chown(tp, ip,
 							&ip->i_udquot, udqp);
 			}
-			inode->i_uid = uid;
 		}
 		if (!gid_eq(igid, gid)) {
 			if (XFS_IS_GQUOTA_ON(mp)) {
@@ -795,15 +753,10 @@ xfs_setattr_nonsize(
 				olddquot2 = xfs_qm_vop_chown(tp, ip,
 							&ip->i_gdquot, gdqp);
 			}
-			inode->i_gid = gid;
 		}
 	}
 
-	if (mask & ATTR_MODE)
-		xfs_setattr_mode(ip, iattr);
-	if (mask & (ATTR_ATIME|ATTR_CTIME|ATTR_MTIME))
-		xfs_setattr_time(ip, iattr);
-
+	setattr_copy(mnt_userns, inode, iattr);
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
 	XFS_STATS_INC(mp, xs_ig_attrchg);
@@ -1028,11 +981,8 @@ xfs_setattr_size(
 		xfs_inode_clear_eofblocks_tag(ip);
 	}
 
-	if (iattr->ia_valid & ATTR_MODE)
-		xfs_setattr_mode(ip, iattr);
-	if (iattr->ia_valid & (ATTR_ATIME|ATTR_CTIME|ATTR_MTIME))
-		xfs_setattr_time(ip, iattr);
-
+	ASSERT(!(iattr->ia_valid & (ATTR_UID | ATTR_GID)));
+	setattr_copy(mnt_userns, inode, iattr);
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
 	XFS_STATS_INC(mp, xs_ig_attrchg);
diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index 5e1d29d8b2e73..8865f7d4404ae 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -283,7 +283,8 @@ xfs_fs_commit_blocks(
 	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
-	xfs_setattr_time(ip, iattr);
+	ASSERT(!(iattr->ia_valid & (ATTR_UID | ATTR_GID)));
+	setattr_copy(&init_user_ns, inode, iattr);
 	if (update_isize) {
 		i_size_write(inode, iattr->ia_size);
 		ip->i_disk_size = iattr->ia_size;
-- 
2.39.2



