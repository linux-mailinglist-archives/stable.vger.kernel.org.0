Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CAF02A577E
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:43:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731738AbgKCUzP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:55:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:55420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732242AbgKCUzN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:55:13 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F8582053B;
        Tue,  3 Nov 2020 20:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436913;
        bh=wq5DBJCkBhOeDeG63sfmtQYCwTQmAJnj0LNi+e1pePk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CX/+naJ02vbiLTYwGN0eLd+7RwzrjU7LhEJ+bLq0sSoOgHWRWWdXXa/WyODAKtHTG
         4p6i/rZABz+CHpo9Uomin+aYjM3PzacR/GFDPAjJuF0vOv+XcD0LM/mFgktHnfO/3v
         AZln3Q5YAlbZeuxkZJwVovDqNIxC0/ELll/KxFWA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Dave Chinner <dchinner@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 064/214] xfs: dont free rt blocks when were doing a REMAP bunmapi call
Date:   Tue,  3 Nov 2020 21:35:12 +0100
Message-Id: <20201103203256.377202168@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203249.448706377@linuxfoundation.org>
References: <20201103203249.448706377@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

[ Upstream commit 8df0fa39bdd86ca81a8d706a6ed9d33cc65ca625 ]

When callers pass XFS_BMAPI_REMAP into xfs_bunmapi, they want the extent
to be unmapped from the given file fork without the extent being freed.
We do this for non-rt files, but we forgot to do this for realtime
files.  So far this isn't a big deal since nobody makes a bunmapi call
to a rt file with the REMAP flag set, but don't leave a logic bomb.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index f8db3fe616df9..c114d24be6193 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4985,20 +4985,25 @@ xfs_bmap_del_extent_real(
 
 	flags = XFS_ILOG_CORE;
 	if (whichfork == XFS_DATA_FORK && XFS_IS_REALTIME_INODE(ip)) {
-		xfs_fsblock_t	bno;
 		xfs_filblks_t	len;
 		xfs_extlen_t	mod;
 
-		bno = div_u64_rem(del->br_startblock, mp->m_sb.sb_rextsize,
-				  &mod);
-		ASSERT(mod == 0);
 		len = div_u64_rem(del->br_blockcount, mp->m_sb.sb_rextsize,
 				  &mod);
 		ASSERT(mod == 0);
 
-		error = xfs_rtfree_extent(tp, bno, (xfs_extlen_t)len);
-		if (error)
-			goto done;
+		if (!(bflags & XFS_BMAPI_REMAP)) {
+			xfs_fsblock_t	bno;
+
+			bno = div_u64_rem(del->br_startblock,
+					mp->m_sb.sb_rextsize, &mod);
+			ASSERT(mod == 0);
+
+			error = xfs_rtfree_extent(tp, bno, (xfs_extlen_t)len);
+			if (error)
+				goto done;
+		}
+
 		do_fx = 0;
 		nblks = len * mp->m_sb.sb_rextsize;
 		qfield = XFS_TRANS_DQ_RTBCOUNT;
-- 
2.27.0



