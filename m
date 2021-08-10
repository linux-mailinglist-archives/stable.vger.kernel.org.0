Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 747C63DD790
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 15:46:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234066AbhHBNqU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 09:46:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:55812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234091AbhHBNqP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:46:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2517E60FA0;
        Mon,  2 Aug 2021 13:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627911965;
        bh=JGo8fr8J4PQnzy1Kw3NRruxHvTSGqbnqGnH3HE7tgLQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2ptIAtkYZkue3uCGNwND+c/t98hEq9Xzg49daLDC7k6Xl4tB8sbYRxl18F+6CCRm5
         op9ZHQMr8kJZaqp5wEKGmWOXMRcgZ8wQ3QIFKOwb0YKUJnEqEHLDIREw6W8dgDywrO
         jbgfrtYMm3qmvPwUo0ipx2urCR0WquNxq+/xhTmY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Junxiao Bi <junxiao.bi@oracle.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Mark Fasheh <mark@fasheh.com>,
        Joel Becker <jlbec@evilplan.org>,
        Changwei Ge <gechangwei@live.cn>, Gang He <ghe@suse.com>,
        Jun Piao <piaojun@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.4 14/26] ocfs2: issue zeroout to EOF blocks
Date:   Mon,  2 Aug 2021 15:44:24 +0200
Message-Id: <20210802134332.495813950@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134332.033552261@linuxfoundation.org>
References: <20210802134332.033552261@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Junxiao Bi <junxiao.bi@oracle.com>

commit 9449ad33be8480f538b11a593e2dda2fb33ca06d upstream.

For punch holes in EOF blocks, fallocate used buffer write to zero the
EOF blocks in last cluster.  But since ->writepage will ignore EOF
pages, those zeros will not be flushed.

This "looks" ok as commit 6bba4471f0cc ("ocfs2: fix data corruption by
fallocate") will zero the EOF blocks when extend the file size, but it
isn't.  The problem happened on those EOF pages, before writeback, those
pages had DIRTY flag set and all buffer_head in them also had DIRTY flag
set, when writeback run by write_cache_pages(), DIRTY flag on the page
was cleared, but DIRTY flag on the buffer_head not.

When next write happened to those EOF pages, since buffer_head already
had DIRTY flag set, it would not mark page DIRTY again.  That made
writeback ignore them forever.  That will cause data corruption.  Even
directio write can't work because it will fail when trying to drop pages
caches before direct io, as it found the buffer_head for those pages
still had DIRTY flag set, then it will fall back to buffer io mode.

To make a summary of the issue, as writeback ingores EOF pages, once any
EOF page is generated, any write to it will only go to the page cache,
it will never be flushed to disk even file size extends and that page is
not EOF page any more.  The fix is to avoid zero EOF blocks with buffer
write.

The following code snippet from qemu-img could trigger the corruption.

  656   open("6b3711ae-3306-4bdd-823c-cf1c0060a095.conv.2", O_RDWR|O_DIRECT|O_CLOEXEC) = 11
  ...
  660   fallocate(11, FALLOC_FL_KEEP_SIZE|FALLOC_FL_PUNCH_HOLE, 2275868672, 327680 <unfinished ...>
  660   fallocate(11, 0, 2275868672, 327680) = 0
  658   pwrite64(11, "

Link: https://lkml.kernel.org/r/20210722054923.24389-2-junxiao.bi@oracle.com
Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/file.c |   99 +++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 60 insertions(+), 39 deletions(-)

--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1532,6 +1532,45 @@ static void ocfs2_truncate_cluster_pages
 	}
 }
 
+/*
+ * zero out partial blocks of one cluster.
+ *
+ * start: file offset where zero starts, will be made upper block aligned.
+ * len: it will be trimmed to the end of current cluster if "start + len"
+ *      is bigger than it.
+ */
+static int ocfs2_zeroout_partial_cluster(struct inode *inode,
+					u64 start, u64 len)
+{
+	int ret;
+	u64 start_block, end_block, nr_blocks;
+	u64 p_block, offset;
+	u32 cluster, p_cluster, nr_clusters;
+	struct super_block *sb = inode->i_sb;
+	u64 end = ocfs2_align_bytes_to_clusters(sb, start);
+
+	if (start + len < end)
+		end = start + len;
+
+	start_block = ocfs2_blocks_for_bytes(sb, start);
+	end_block = ocfs2_blocks_for_bytes(sb, end);
+	nr_blocks = end_block - start_block;
+	if (!nr_blocks)
+		return 0;
+
+	cluster = ocfs2_bytes_to_clusters(sb, start);
+	ret = ocfs2_get_clusters(inode, cluster, &p_cluster,
+				&nr_clusters, NULL);
+	if (ret)
+		return ret;
+	if (!p_cluster)
+		return 0;
+
+	offset = start_block - ocfs2_clusters_to_blocks(sb, cluster);
+	p_block = ocfs2_clusters_to_blocks(sb, p_cluster) + offset;
+	return sb_issue_zeroout(sb, p_block, nr_blocks, GFP_NOFS);
+}
+
 static int ocfs2_zero_partial_clusters(struct inode *inode,
 				       u64 start, u64 len)
 {
@@ -1541,6 +1580,7 @@ static int ocfs2_zero_partial_clusters(s
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	unsigned int csize = osb->s_clustersize;
 	handle_t *handle;
+	loff_t isize = i_size_read(inode);
 
 	/*
 	 * The "start" and "end" values are NOT necessarily part of
@@ -1561,6 +1601,26 @@ static int ocfs2_zero_partial_clusters(s
 	if ((start & (csize - 1)) == 0 && (end & (csize - 1)) == 0)
 		goto out;
 
+	/* No page cache for EOF blocks, issue zero out to disk. */
+	if (end > isize) {
+		/*
+		 * zeroout eof blocks in last cluster starting from
+		 * "isize" even "start" > "isize" because it is
+		 * complicated to zeroout just at "start" as "start"
+		 * may be not aligned with block size, buffer write
+		 * would be required to do that, but out of eof buffer
+		 * write is not supported.
+		 */
+		ret = ocfs2_zeroout_partial_cluster(inode, isize,
+					end - isize);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+		if (start >= isize)
+			goto out;
+		end = isize;
+	}
 	handle = ocfs2_start_trans(osb, OCFS2_INODE_UPDATE_CREDITS);
 	if (IS_ERR(handle)) {
 		ret = PTR_ERR(handle);
@@ -1860,45 +1920,6 @@ out:
 }
 
 /*
- * zero out partial blocks of one cluster.
- *
- * start: file offset where zero starts, will be made upper block aligned.
- * len: it will be trimmed to the end of current cluster if "start + len"
- *      is bigger than it.
- */
-static int ocfs2_zeroout_partial_cluster(struct inode *inode,
-					u64 start, u64 len)
-{
-	int ret;
-	u64 start_block, end_block, nr_blocks;
-	u64 p_block, offset;
-	u32 cluster, p_cluster, nr_clusters;
-	struct super_block *sb = inode->i_sb;
-	u64 end = ocfs2_align_bytes_to_clusters(sb, start);
-
-	if (start + len < end)
-		end = start + len;
-
-	start_block = ocfs2_blocks_for_bytes(sb, start);
-	end_block = ocfs2_blocks_for_bytes(sb, end);
-	nr_blocks = end_block - start_block;
-	if (!nr_blocks)
-		return 0;
-
-	cluster = ocfs2_bytes_to_clusters(sb, start);
-	ret = ocfs2_get_clusters(inode, cluster, &p_cluster,
-				&nr_clusters, NULL);
-	if (ret)
-		return ret;
-	if (!p_cluster)
-		return 0;
-
-	offset = start_block - ocfs2_clusters_to_blocks(sb, cluster);
-	p_block = ocfs2_clusters_to_blocks(sb, p_cluster) + offset;
-	return sb_issue_zeroout(sb, p_block, nr_blocks, GFP_NOFS);
-}
-
-/*
  * Parts of this function taken from xfs_change_file_space()
  */
 static int __ocfs2_change_file_space(struct file *file, struct inode *inode,


