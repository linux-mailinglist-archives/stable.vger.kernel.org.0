Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D384A3D2F41
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 23:38:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231607AbhGVU5x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 16:57:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:44308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231403AbhGVU5x (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 16:57:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3859F60EB4;
        Thu, 22 Jul 2021 21:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626989907;
        bh=bm5WDXY9wNdHfBu/81MjETjpHVC7Lmm6b1AwzdqotIk=;
        h=Date:From:To:Subject:From;
        b=lg1pl4yXt/JenADUICOZmy9gttDL+GKduL94+E1v5V6ilgUoeyxhlFyE4qbqPGeHI
         u9AX3OO9vSGYBTTuZzr0eAYqOeNIVPCdJvp2V1HDWyVImJ7Hkvu/U+JgPD57OkUGj4
         hC4/f1DG3r8FGrH8Tn+Ds5zO09RnlRsHCqtqBcnU=
Date:   Thu, 22 Jul 2021 14:38:26 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        piaojun@huawei.com, mark@fasheh.com, joseph.qi@linux.alibaba.com,
        jlbec@evilplan.org, ghe@suse.com, gechangwei@live.cn,
        junxiao.bi@oracle.com
Subject:  + ocfs2-issue-zeroout-to-eof-blocks.patch added to -mm tree
Message-ID: <20210722213826.c71ve%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: ocfs2: issue zeroout to EOF blocks
has been added to the -mm tree.  Its filename is
     ocfs2-issue-zeroout-to-eof-blocks.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ocfs2-issue-zeroout-to-eof-blocks.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-issue-zeroout-to-eof-blocks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Junxiao Bi <junxiao.bi@oracle.com>
Subject: ocfs2: issue zeroout to EOF blocks

For punch holes in EOF blocks, fallocate used buffer write to zero the EOF
blocks in last cluster.  But since ->writepage will ignore EOF pages,
those zeros will not be flushed.

This "looks" ok as commit 6bba4471f0cc ("ocfs2: fix data corruption by
fallocate") will zero the EOF blocks when extend the file size, but it
isn't.  The problem happened on those EOF pages, before writeback, those
pages had DIRTY flag set and all buffer_head in them also had DIRTY flag
set, when writeback run by write_cache_pages(), DIRTY flag on the page was
cleared, but DIRTY flag on the buffer_head not.

When next write happened to those EOF pages, since buffer_head already had
DIRTY flag set, it would not mark page DIRTY again.  That made writeback
ignore them forever.  That will cause data corruption.  Even directio
write can't work because it will fail when trying to drop pages caches
before direct io, as it found the buffer_head for those pages still had
DIRTY flag set, then it will fall back to buffer io mode.

To make a summary of the issue, as writeback ingores EOF pages, once any
EOF page is generated, any write to it will only go to the page cache, it
will never be flushed to disk even file size extends and that page is not
EOF page any more.  The fix is to avoid zero EOF blocks with buffer write.

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
---

 fs/ocfs2/file.c |   99 +++++++++++++++++++++++++++-------------------
 1 file changed, 60 insertions(+), 39 deletions(-)

--- a/fs/ocfs2/file.c~ocfs2-issue-zeroout-to-eof-blocks
+++ a/fs/ocfs2/file.c
@@ -1529,6 +1529,45 @@ static void ocfs2_truncate_cluster_pages
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
@@ -1538,6 +1577,7 @@ static int ocfs2_zero_partial_clusters(s
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	unsigned int csize = osb->s_clustersize;
 	handle_t *handle;
+	loff_t isize = i_size_read(inode);
 
 	/*
 	 * The "start" and "end" values are NOT necessarily part of
@@ -1558,6 +1598,26 @@ static int ocfs2_zero_partial_clusters(s
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
@@ -1856,45 +1916,6 @@ out:
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
_

Patches currently in -mm which might be from junxiao.bi@oracle.com are

ocfs2-fix-zero-out-valid-data.patch
ocfs2-issue-zeroout-to-eof-blocks.patch

