Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 358A274605
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 07:48:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391315AbfGYFpn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 01:45:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:33096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391343AbfGYFpn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jul 2019 01:45:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 70CCA22BEB;
        Thu, 25 Jul 2019 05:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564033541;
        bh=BfcvyyEqgZ0haWLW3WSXCjTmnYLZA2nFFR5ItJSZOOE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B3qGXY9CoNx1/1cX9Yg71greW16GmCcpYRCIT32DHOP9ufpP+gnuRiR/qZzx4OrrH
         /MHaTHS8FSMT768S9W/2mzCx5yq9lvHQv9+pGUcsVlrOtoG/AOXtIYtDHRXYeJjEf/
         pvBYhb99XFTjoUWMc9FPZ+s4JQeKFwbMtipYMAGg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Chinner <dchinner@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 243/271] xfs: flush removing page cache in xfs_reflink_remap_prep
Date:   Wed, 24 Jul 2019 21:21:52 +0200
Message-Id: <20190724191716.000899611@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191655.268628197@linuxfoundation.org>
References: <20190724191655.268628197@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 2c307174ab77e34645e75e12827646e044d273c3 upstream.

On a sub-page block size filesystem, fsx is failing with a data
corruption after a series of operations involving copying a file
with the destination offset beyond EOF of the destination of the file:

8093(157 mod 256): TRUNCATE DOWN        from 0x7a120 to 0x50000 ******WWWW
8094(158 mod 256): INSERT 0x25000 thru 0x25fff  (0x1000 bytes)
8095(159 mod 256): COPY 0x18000 thru 0x1afff    (0x3000 bytes) to 0x2f400
8096(160 mod 256): WRITE    0x5da00 thru 0x651ff        (0x7800 bytes) HOLE
8097(161 mod 256): COPY 0x2000 thru 0x5fff      (0x4000 bytes) to 0x6fc00

The second copy here is beyond EOF, and it is to sub-page (4k) but
block aligned (1k) offset. The clone runs the EOF zeroing, landing
in a pre-existing post-eof delalloc extent. This zeroes the post-eof
extents in the page cache just fine, dirtying the pages correctly.

The problem is that xfs_reflink_remap_prep() now truncates the page
cache over the range that it is copying it to, and rounds that down
to cover the entire start page. This removes the dirty page over the
delalloc extent from the page cache without having written it back.
Hence later, when the page cache is flushed, the page at offset
0x6f000 has not been written back and hence exposes stale data,
which fsx trips over less than 10 operations later.

Fix this by changing xfs_reflink_remap_prep() to use
xfs_flush_unmap_range().

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_bmap_util.c |  2 +-
 fs/xfs/xfs_bmap_util.h |  2 ++
 fs/xfs/xfs_reflink.c   | 17 +++++++++++++----
 3 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 211b06e4702e..41ad9eaab6ce 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1080,7 +1080,7 @@ xfs_adjust_extent_unmap_boundaries(
 	return 0;
 }
 
-static int
+int
 xfs_flush_unmap_range(
 	struct xfs_inode	*ip,
 	xfs_off_t		offset,
diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
index 87363d136bb6..9c73d012f56a 100644
--- a/fs/xfs/xfs_bmap_util.h
+++ b/fs/xfs/xfs_bmap_util.h
@@ -76,6 +76,8 @@ int	xfs_swap_extents(struct xfs_inode *ip, struct xfs_inode *tip,
 xfs_daddr_t xfs_fsb_to_db(struct xfs_inode *ip, xfs_fsblock_t fsb);
 
 xfs_extnum_t xfs_bmap_count_leaves(struct xfs_ifork *ifp, xfs_filblks_t *count);
+int   xfs_flush_unmap_range(struct xfs_inode *ip, xfs_off_t offset,
+			    xfs_off_t len);
 int xfs_bmap_count_blocks(struct xfs_trans *tp, struct xfs_inode *ip,
 			  int whichfork, xfs_extnum_t *nextents,
 			  xfs_filblks_t *count);
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 38ea08a3dd1d..f3c393f309e1 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1368,10 +1368,19 @@ xfs_reflink_remap_prep(
 	if (ret)
 		goto out_unlock;
 
-	/* Zap any page cache for the destination file's range. */
-	truncate_inode_pages_range(&inode_out->i_data,
-			round_down(pos_out, PAGE_SIZE),
-			round_up(pos_out + *len, PAGE_SIZE) - 1);
+	/*
+	 * If pos_out > EOF, we may have dirtied blocks between EOF and
+	 * pos_out. In that case, we need to extend the flush and unmap to cover
+	 * from EOF to the end of the copy length.
+	 */
+	if (pos_out > XFS_ISIZE(dest)) {
+		loff_t	flen = *len + (pos_out - XFS_ISIZE(dest));
+		ret = xfs_flush_unmap_range(dest, XFS_ISIZE(dest), flen);
+	} else {
+		ret = xfs_flush_unmap_range(dest, pos_out, *len);
+	}
+	if (ret)
+		goto out_unlock;
 
 	/* If we're altering the file contents... */
 	if (!is_dedupe) {
-- 
2.20.1



