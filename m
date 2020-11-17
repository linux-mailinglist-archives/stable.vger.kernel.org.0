Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F31F2B62FD
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:34:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732125AbgKQNd7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:33:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:44188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731620AbgKQNdz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:33:55 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 30EE92078E;
        Tue, 17 Nov 2020 13:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620035;
        bh=7Ta/HP6YerJpzCoffSQvd1lfvwwCyIhHLaRkTXE8yJA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wz5aN1dgF19YPDfAmLP9z8RWSnfv4xhaJ9bebYzHJsNfJIeaPXLtzU6xTmrLQz82x
         na7n0vGvHY06yS1t04aEIhE4TOIaUoXi5DLKJxxujVmOPIiyHUi7HANgdNvkLy0x4D
         8iW/C2j/ygo8uuKTRpOrl86La3kdmqmBWDoDVkCE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 059/255] xfs: fix missing CoW blocks writeback conversion retry
Date:   Tue, 17 Nov 2020 14:03:19 +0100
Message-Id: <20201117122141.826247136@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

[ Upstream commit c2f09217a4305478c55adc9a98692488dd19cd32 ]

In commit 7588cbeec6df, we tried to fix a race stemming from the lack of
coordination between higher level code that wants to allocate and remap
CoW fork extents into the data fork.  Christoph cites as examples the
always_cow mode, and a directio write completion racing with writeback.

According to the comments before the goto retry, we want to restart the
lookup to catch the extent in the data fork, but we don't actually reset
whichfork or cow_fsb, which means the second try executes using stale
information.  Up until now I think we've gotten lucky that either
there's something left in the CoW fork to cause cow_fsb to be reset, or
either data/cow fork sequence numbers have advanced enough to force a
fresh lookup from the data fork.  However, if we reach the retry with an
empty stable CoW fork and a stable data fork, neither of those things
happens.  The retry foolishly re-calls xfs_convert_blocks on the CoW
fork which fails again.  This time, we toss the write.

I've recently been working on extending reflink to the realtime device.
When the realtime extent size is larger than a single block, we have to
force the page cache to CoW the entire rt extent if a write (or
fallocate) are not aligned with the rt extent size.  The strategy I've
chosen to deal with this is derived from Dave's blocksize > pagesize
series: dirtying around the write range, and ensuring that writeback
always starts mapping on an rt extent boundary.  This has brought this
race front and center, since generic/522 blows up immediately.

However, I'm pretty sure this is a bug outright, independent of that.

Fixes: 7588cbeec6df ("xfs: retry COW fork delalloc conversion when no extent was found")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_aops.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index b35611882ff9c..e4210779cd79e 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -346,8 +346,8 @@ xfs_map_blocks(
 	ssize_t			count = i_blocksize(inode);
 	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, offset);
 	xfs_fileoff_t		end_fsb = XFS_B_TO_FSB(mp, offset + count);
-	xfs_fileoff_t		cow_fsb = NULLFILEOFF;
-	int			whichfork = XFS_DATA_FORK;
+	xfs_fileoff_t		cow_fsb;
+	int			whichfork;
 	struct xfs_bmbt_irec	imap;
 	struct xfs_iext_cursor	icur;
 	int			retries = 0;
@@ -381,6 +381,8 @@ xfs_map_blocks(
 	 * landed in a hole and we skip the block.
 	 */
 retry:
+	cow_fsb = NULLFILEOFF;
+	whichfork = XFS_DATA_FORK;
 	xfs_ilock(ip, XFS_ILOCK_SHARED);
 	ASSERT(ip->i_df.if_format != XFS_DINODE_FMT_BTREE ||
 	       (ip->i_df.if_flags & XFS_IFEXTENTS));
-- 
2.27.0



