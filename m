Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6A9129B8F1
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:10:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802111AbgJ0Ppi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:45:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:46412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1799142AbgJ0P34 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:29:56 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B7F422202;
        Tue, 27 Oct 2020 15:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812596;
        bh=uP0mFmsBuucW/wXdwa2/U/lYha58qUUdDJG37uDy85E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Otdr5KrNf+trahKh68KDE7PZ5ZpBzs+p/JLoceBM+ChUBe8wYj0x1COaRFYD5L4Uz
         MbggdRXsnCuCl/4XNh/REVHBUGtUJlvjsqdp68BLfOs7SIYGy8y52b+tJcGbnWZIvr
         rR3egII4MG3zbd+VIzg6R/pUZeEJxU3BxPmMWAPQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 264/757] xfs: force the log after remapping a synchronous-writes file
Date:   Tue, 27 Oct 2020 14:48:34 +0100
Message-Id: <20201027135502.958259080@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

[ Upstream commit 5ffce3cc22a0e89813ed0c7162a68b639aef9ab6 ]

Commit 5833112df7e9 tried to make it so that a remap operation would
force the log out to disk if the filesystem is mounted with mandatory
synchronous writes.  Unfortunately, that commit failed to handle the
case where the inode or the file descriptor require mandatory
synchronous writes.

Refactor the check into into a helper that will look for all three
conditions, and now we can treat reflink just like any other synchronous
write.

Fixes: 5833112df7e9 ("xfs: reflink should force the log out if mounted with wsync")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_file.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index a29f78a663ca5..3d1b951247440 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1008,6 +1008,21 @@ xfs_file_fadvise(
 	return ret;
 }
 
+/* Does this file, inode, or mount want synchronous writes? */
+static inline bool xfs_file_sync_writes(struct file *filp)
+{
+	struct xfs_inode	*ip = XFS_I(file_inode(filp));
+
+	if (ip->i_mount->m_flags & XFS_MOUNT_WSYNC)
+		return true;
+	if (filp->f_flags & (__O_SYNC | O_DSYNC))
+		return true;
+	if (IS_SYNC(file_inode(filp)))
+		return true;
+
+	return false;
+}
+
 STATIC loff_t
 xfs_file_remap_range(
 	struct file		*file_in,
@@ -1065,7 +1080,7 @@ xfs_file_remap_range(
 	if (ret)
 		goto out_unlock;
 
-	if (mp->m_flags & XFS_MOUNT_WSYNC)
+	if (xfs_file_sync_writes(file_in) || xfs_file_sync_writes(file_out))
 		xfs_log_force_inode(dest);
 out_unlock:
 	xfs_iunlock2_io_mmap(src, dest);
-- 
2.25.1



