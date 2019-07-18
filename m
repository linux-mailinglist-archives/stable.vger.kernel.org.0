Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 140AC6D712
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 01:07:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391655AbfGRXG1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 19:06:27 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:45893 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728524AbfGRXG1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jul 2019 19:06:27 -0400
Received: by mail-pl1-f196.google.com with SMTP id y8so14621011plr.12;
        Thu, 18 Jul 2019 16:06:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jI9RSC+Ajgq24i5IppYuO6Qi2kQaROT+33IGQt5erpE=;
        b=J+yT08ZfXreqX9QGx2EWfiNYtF9m5Ty4hb/7tvPpR95BRRju6Q1DLbdlax4+sCqXbe
         5/WaTXJJuIrT8pQik8lJTydyjcYPNa2sT/gbVudYAfzOpbRi6URdvFUzTtk6Kk0gSERH
         7MNjr0uz+SKi3ilwwxKJqxCphjdO4C1Y7vdZBIQberojDLxlqEToUi2cjYqyw/6yL02L
         0IeSiTsDRFt8Vr0+tCkfVIaav+JUX2ZvgQnRYNQ95PWXUwotrrVne7EY7PNOXWDDQOXj
         hCet+KMvUg7NoBkpIlcVndYakkG2NAGM8zvKUbX2/dAWBt4wL0hy+g6AJQoyPiGyXXJo
         p8kQ==
X-Gm-Message-State: APjAAAX5ImXASEbBvNzLP7I0TvX9Ypv1oQ6FX/T2y3wJiP54bElNSRVn
        OgDsuu2piq5co26tiD8iOS0=
X-Google-Smtp-Source: APXvYqw71sGo/ZCt33Ffm9D8/mmcZVl9xhDXLGCM5KhnphvKalhWRtwOMeaN/7286BF5PAT2fYKrxg==
X-Received: by 2002:a17:902:ff05:: with SMTP id f5mr51364609plj.116.1563491185985;
        Thu, 18 Jul 2019 16:06:25 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id b24sm26453839pfd.98.2019.07.18.16.06.19
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 18 Jul 2019 16:06:19 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id 2981840619; Thu, 18 Jul 2019 23:06:19 +0000 (UTC)
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     linux-xfs@vger.kernel.org, gregkh@linuxfoundation.org,
        Alexander.Levin@microsoft.com
Cc:     stable@vger.kernel.org, amir73il@gmail.com, hch@infradead.org,
        zlang@redhat.com, Dave Chinner <dchinner@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH 2/9] xfs: flush removing page cache in xfs_reflink_remap_prep
Date:   Thu, 18 Jul 2019 23:06:10 +0000
Message-Id: <20190718230617.7439-3-mcgrof@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190718230617.7439-1-mcgrof@kernel.org>
References: <20190718230617.7439-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

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

