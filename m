Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A7072601AE
	for <lists+stable@lfdr.de>; Mon,  7 Sep 2020 19:11:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730725AbgIGRK4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Sep 2020 13:10:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:46556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730648AbgIGQcm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Sep 2020 12:32:42 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 65F5420757;
        Mon,  7 Sep 2020 16:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599496362;
        bh=jFs0Sz+sEpFY5xXgoP8wsxu+kifj4dt4TaFrRZotE2Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=184lH6oShkwTMZZ469s+AeANSWEMQEpW/pBwpE4+17E8K3HHlTQ/LDjmtDisGB+o2
         42JIfmnggbCRrUvOCFFrcrEYCFfKnvcH+CryoLCt/y/4hB1gRyikH1KQKbkj2IOdli
         Hwc+IWQdeLwE5kX7KevomDffKZneZLecQDCJL50Q=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Brian Foster <bfoster@redhat.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-xfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 16/53] xfs: fix off-by-one in inode alloc block reservation calculation
Date:   Mon,  7 Sep 2020 12:31:42 -0400
Message-Id: <20200907163220.1280412-16-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200907163220.1280412-1-sashal@kernel.org>
References: <20200907163220.1280412-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian Foster <bfoster@redhat.com>

[ Upstream commit 657f101930bc6c5b41bd7d6c22565c4302a80d33 ]

The inode chunk allocation transaction reserves inobt_maxlevels-1
blocks to accommodate a full split of the inode btree. A full split
requires an allocation for every existing level and a new root
block, which means inobt_maxlevels is the worst case block
requirement for a transaction that inserts to the inobt. This can
lead to a transaction block reservation overrun when tmpfile
creation allocates an inode chunk and expands the inobt to its
maximum depth. This problem has been observed in conjunction with
overlayfs, which makes frequent use of tmpfiles internally.

The existing reservation code goes back as far as the Linux git repo
history (v2.6.12). It was likely never observed as a problem because
the traditional file/directory creation transactions also include
worst case block reservation for directory modifications, which most
likely is able to make up for a single block deficiency in the inode
allocation portion of the calculation. tmpfile support is relatively
more recent (v3.15), less heavily used, and only includes the inode
allocation block reservation as tmpfiles aren't linked into the
directory tree on creation.

Fix up the inode alloc block reservation macro and a couple of the
block allocator minleft parameters that enforce an allocation to
leave enough free blocks in the AG for a full inobt split.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/libxfs/xfs_ialloc.c      | 4 ++--
 fs/xfs/libxfs/xfs_trans_space.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 7fcf62b324b0d..8c1a7cc484b65 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -688,7 +688,7 @@ xfs_ialloc_ag_alloc(
 		args.minalignslop = igeo->cluster_align - 1;
 
 		/* Allow space for the inode btree to split. */
-		args.minleft = igeo->inobt_maxlevels - 1;
+		args.minleft = igeo->inobt_maxlevels;
 		if ((error = xfs_alloc_vextent(&args)))
 			return error;
 
@@ -736,7 +736,7 @@ xfs_ialloc_ag_alloc(
 		/*
 		 * Allow space for the inode btree to split.
 		 */
-		args.minleft = igeo->inobt_maxlevels - 1;
+		args.minleft = igeo->inobt_maxlevels;
 		if ((error = xfs_alloc_vextent(&args)))
 			return error;
 	}
diff --git a/fs/xfs/libxfs/xfs_trans_space.h b/fs/xfs/libxfs/xfs_trans_space.h
index c6df01a2a1585..7ad3659c5d2a9 100644
--- a/fs/xfs/libxfs/xfs_trans_space.h
+++ b/fs/xfs/libxfs/xfs_trans_space.h
@@ -58,7 +58,7 @@
 #define	XFS_IALLOC_SPACE_RES(mp)	\
 	(M_IGEO(mp)->ialloc_blks + \
 	 ((xfs_sb_version_hasfinobt(&mp->m_sb) ? 2 : 1) * \
-	  (M_IGEO(mp)->inobt_maxlevels - 1)))
+	  M_IGEO(mp)->inobt_maxlevels))
 
 /*
  * Space reservation values for various transactions.
-- 
2.25.1

