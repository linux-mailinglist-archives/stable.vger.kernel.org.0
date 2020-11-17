Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66F3A2B64FD
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:54:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731665AbgKQN06 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:26:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:34662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730546AbgKQN04 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:26:56 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B0C08246A4;
        Tue, 17 Nov 2020 13:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619616;
        bh=XOfjNhLuUK1+CIGjPXn3xW4zAAVzCA5p+rv2AJnkpgE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L8U929ExqTgMnBdbbr0zKezts+4QZn+bKz/rmpXRU/pVREor/aic5aVcdOC/EPAHl
         mFRHyzp51GT8qjk7pHP6WAv22r0fQijaqTz4HqooOEa3P0nG/61q9r1E5+YILFRIsc
         ynqv/ILTGIvxCK+xTBRwo7iUJnCjMTOejSZZhQOI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 098/151] xfs: fix rmap key and record comparison functions
Date:   Tue, 17 Nov 2020 14:05:28 +0100
Message-Id: <20201117122126.178386399@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122121.381905960@linuxfoundation.org>
References: <20201117122121.381905960@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

[ Upstream commit 6ff646b2ceb0eec916101877f38da0b73e3a5b7f ]

Keys for extent interval records in the reverse mapping btree are
supposed to be computed as follows:

(physical block, owner, fork, is_btree, is_unwritten, offset)

This provides users the ability to look up a reverse mapping from a bmbt
record -- start with the physical block; then if there are multiple
records for the same block, move on to the owner; then the inode fork
type; and so on to the file offset.

However, the key comparison functions incorrectly remove the
fork/btree/unwritten information that's encoded in the on-disk offset.
This means that lookup comparisons are only done with:

(physical block, owner, offset)

This means that queries can return incorrect results.  On consistent
filesystems this hasn't been an issue because blocks are never shared
between forks or with bmbt blocks; and are never unwritten.  However,
this bug means that online repair cannot always detect corruption in the
key information in internal rmapbt nodes.

Found by fuzzing keys[1].attrfork = ones on xfs/371.

Fixes: 4b8ed67794fe ("xfs: add rmap btree operations")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/libxfs/xfs_rmap_btree.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index fc78efa52c94e..3780609c7860c 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -243,8 +243,8 @@ xfs_rmapbt_key_diff(
 	else if (y > x)
 		return -1;
 
-	x = XFS_RMAP_OFF(be64_to_cpu(kp->rm_offset));
-	y = rec->rm_offset;
+	x = be64_to_cpu(kp->rm_offset);
+	y = xfs_rmap_irec_offset_pack(rec);
 	if (x > y)
 		return 1;
 	else if (y > x)
@@ -275,8 +275,8 @@ xfs_rmapbt_diff_two_keys(
 	else if (y > x)
 		return -1;
 
-	x = XFS_RMAP_OFF(be64_to_cpu(kp1->rm_offset));
-	y = XFS_RMAP_OFF(be64_to_cpu(kp2->rm_offset));
+	x = be64_to_cpu(kp1->rm_offset);
+	y = be64_to_cpu(kp2->rm_offset);
 	if (x > y)
 		return 1;
 	else if (y > x)
@@ -390,8 +390,8 @@ xfs_rmapbt_keys_inorder(
 		return 1;
 	else if (a > b)
 		return 0;
-	a = XFS_RMAP_OFF(be64_to_cpu(k1->rmap.rm_offset));
-	b = XFS_RMAP_OFF(be64_to_cpu(k2->rmap.rm_offset));
+	a = be64_to_cpu(k1->rmap.rm_offset);
+	b = be64_to_cpu(k2->rmap.rm_offset);
 	if (a <= b)
 		return 1;
 	return 0;
@@ -420,8 +420,8 @@ xfs_rmapbt_recs_inorder(
 		return 1;
 	else if (a > b)
 		return 0;
-	a = XFS_RMAP_OFF(be64_to_cpu(r1->rmap.rm_offset));
-	b = XFS_RMAP_OFF(be64_to_cpu(r2->rmap.rm_offset));
+	a = be64_to_cpu(r1->rmap.rm_offset);
+	b = be64_to_cpu(r2->rmap.rm_offset);
 	if (a <= b)
 		return 1;
 	return 0;
-- 
2.27.0



