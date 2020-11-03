Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52B282A53AF
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:03:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730980AbgKCVDd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:03:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:41096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387818AbgKCVDa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 16:03:30 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 027FB20658;
        Tue,  3 Nov 2020 21:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437409;
        bh=9sQhSG0xyslubacE7T16nzPw00O1ZLpdQlGzB3EEB7M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JELU0DY50fty1yTzasYyYIds6tfx6KquCEyayBo+jsngkKQ2Q2HMLldPDeN3IeVxu
         CZEk5u9dBQyCNSPvC76LzOfcLUadYstqsX+iw9g69bHRyaN/z+Q4UW9Pm8rwqbO4Wh
         D1stG7a7unlA1H01NqzPTm9rpTPhAFfIcY+opTOM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Chandan Babu R <chandanrlinux@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 064/191] xfs: fix realtime bitmap/summary file truncation when growing rt volume
Date:   Tue,  3 Nov 2020 21:35:56 +0100
Message-Id: <20201103203240.572728083@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203232.656475008@linuxfoundation.org>
References: <20201103203232.656475008@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

[ Upstream commit f4c32e87de7d66074d5612567c5eac7325024428 ]

The realtime bitmap and summary files are regular files that are hidden
away from the directory tree.  Since they're regular files, inode
inactivation will try to purge what it thinks are speculative
preallocations beyond the incore size of the file.  Unfortunately,
xfs_growfs_rt forgets to update the incore size when it resizes the
inodes, with the result that inactivating the rt inodes at unmount time
will cause their contents to be truncated.

Fix this by updating the incore size when we change the ondisk size as
part of updating the superblock.  Note that we don't do this when we're
allocating blocks to the rt inodes because we actually want those blocks
to get purged if the growfs fails.

This fixes corruption complaints from the online rtsummary checker when
running xfs/233.  Since that test requires rmap, one can also trigger
this by growing an rt volume, cycling the mount, and creating rt files.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_rtalloc.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 08da48b662358..280965fc9bbd4 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -998,10 +998,13 @@ xfs_growfs_rt(
 		xfs_ilock(mp->m_rbmip, XFS_ILOCK_EXCL);
 		xfs_trans_ijoin(tp, mp->m_rbmip, XFS_ILOCK_EXCL);
 		/*
-		 * Update the bitmap inode's size.
+		 * Update the bitmap inode's size ondisk and incore.  We need
+		 * to update the incore size so that inode inactivation won't
+		 * punch what it thinks are "posteof" blocks.
 		 */
 		mp->m_rbmip->i_d.di_size =
 			nsbp->sb_rbmblocks * nsbp->sb_blocksize;
+		i_size_write(VFS_I(mp->m_rbmip), mp->m_rbmip->i_d.di_size);
 		xfs_trans_log_inode(tp, mp->m_rbmip, XFS_ILOG_CORE);
 		/*
 		 * Get the summary inode into the transaction.
@@ -1009,9 +1012,12 @@ xfs_growfs_rt(
 		xfs_ilock(mp->m_rsumip, XFS_ILOCK_EXCL);
 		xfs_trans_ijoin(tp, mp->m_rsumip, XFS_ILOCK_EXCL);
 		/*
-		 * Update the summary inode's size.
+		 * Update the summary inode's size.  We need to update the
+		 * incore size so that inode inactivation won't punch what it
+		 * thinks are "posteof" blocks.
 		 */
 		mp->m_rsumip->i_d.di_size = nmp->m_rsumsize;
+		i_size_write(VFS_I(mp->m_rsumip), mp->m_rsumip->i_d.di_size);
 		xfs_trans_log_inode(tp, mp->m_rsumip, XFS_ILOG_CORE);
 		/*
 		 * Copy summary data from old to new sizes.
-- 
2.27.0



