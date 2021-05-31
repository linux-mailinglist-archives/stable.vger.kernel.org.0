Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD55C39698B
	for <lists+stable@lfdr.de>; Tue,  1 Jun 2021 00:07:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231708AbhEaWJd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 18:09:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:52756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231305AbhEaWJd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 18:09:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C2A35610E7;
        Mon, 31 May 2021 22:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1622498872;
        bh=ASh2aCUCOotb5nFuB+1kM4/b9E8KAlizeh7bFVGZAr4=;
        h=Date:From:To:Subject:From;
        b=OhiczRUCLpnvXicMLFCL8PquZw8SbB4oaEc6TjKYwDLdqDspedJH3c7SOAwe6nAlu
         aCr8UZBGZnlNzEKYenchs250C3ew2D5JbH038R1+u78m438rHjKd+1Y8zrrlQAJSNC
         Dqf9fAxm9ytfNMsEwv++4vtdb1Y57dTDqB6eG4/8=
Date:   Mon, 31 May 2021 15:07:51 -0700
From:   akpm@linux-foundation.org
To:     gechangwei@live.cn, ghe@suse.com, jack@suse.cz, jlbec@evilplan.org,
        joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com,
        mark@fasheh.com, mm-commits@vger.kernel.org, piaojun@huawei.com,
        stable@vger.kernel.org
Subject:  + ocfs2-fix-data-corruption-by-fallocate.patch added to
 -mm tree
Message-ID: <20210531220751.wp6zM2ghS%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: ocfs2: fix data corruption by fallocate
has been added to the -mm tree.  Its filename is
     ocfs2-fix-data-corruption-by-fallocate.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ocfs2-fix-data-corruption-by-fallocate.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-fix-data-corruption-by-fallocate.patch

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
Subject: ocfs2: fix data corruption by fallocate

When fallocate punches holes out of inode size, if original isize is in
the middle of last cluster, then the part from isize to the end of the
cluster will be zeroed with buffer write, at that time isize is not yet
updated to match the new size, if writeback is kicked in, it will invoke
ocfs2_writepage()->block_write_full_page() where the pages out of inode
size will be dropped.  That will cause file corruption.  Fix this by zero
out eof blocks when extending the inode size.

Running the following command with qemu-image 4.2.1 can get a corrupted
coverted image file easily.

    qemu-img convert -p -t none -T none -f qcow2 $qcow_image \
             -O qcow2 -o compat=1.1 $qcow_image.conv

The usage of fallocate in qemu is like this, it first punches holes out of
inode size, then extend the inode size.

    fallocate(11, FALLOC_FL_KEEP_SIZE|FALLOC_FL_PUNCH_HOLE, 2276196352, 65536) = 0
    fallocate(11, 0, 2276196352, 65536) = 0

v1: https://www.spinics.net/lists/linux-fsdevel/msg193999.html
v2: https://lore.kernel.org/linux-fsdevel/20210525093034.GB4112@quack2.suse.cz/T/

Link: https://lkml.kernel.org/r/20210528210648.9124-1-junxiao.bi@oracle.com
Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/file.c |   55 +++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 50 insertions(+), 5 deletions(-)

--- a/fs/ocfs2/file.c~ocfs2-fix-data-corruption-by-fallocate
+++ a/fs/ocfs2/file.c
@@ -1856,6 +1856,45 @@ out:
 }
 
 /*
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
+/*
  * Parts of this function taken from xfs_change_file_space()
  */
 static int __ocfs2_change_file_space(struct file *file, struct inode *inode,
@@ -1865,7 +1904,7 @@ static int __ocfs2_change_file_space(str
 {
 	int ret;
 	s64 llen;
-	loff_t size;
+	loff_t size, orig_isize;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	struct buffer_head *di_bh = NULL;
 	handle_t *handle;
@@ -1896,6 +1935,7 @@ static int __ocfs2_change_file_space(str
 		goto out_inode_unlock;
 	}
 
+	orig_isize = i_size_read(inode);
 	switch (sr->l_whence) {
 	case 0: /*SEEK_SET*/
 		break;
@@ -1903,7 +1943,7 @@ static int __ocfs2_change_file_space(str
 		sr->l_start += f_pos;
 		break;
 	case 2: /*SEEK_END*/
-		sr->l_start += i_size_read(inode);
+		sr->l_start += orig_isize;
 		break;
 	default:
 		ret = -EINVAL;
@@ -1957,6 +1997,14 @@ static int __ocfs2_change_file_space(str
 	default:
 		ret = -EINVAL;
 	}
+
+	/* zeroout eof blocks in the cluster. */
+	if (!ret && change_size && orig_isize < size) {
+		ret = ocfs2_zeroout_partial_cluster(inode, orig_isize,
+					size - orig_isize);
+		if (!ret)
+			i_size_write(inode, size);
+	}
 	up_write(&OCFS2_I(inode)->ip_alloc_sem);
 	if (ret) {
 		mlog_errno(ret);
@@ -1973,9 +2021,6 @@ static int __ocfs2_change_file_space(str
 		goto out_inode_unlock;
 	}
 
-	if (change_size && i_size_read(inode) < size)
-		i_size_write(inode, size);
-
 	inode->i_ctime = inode->i_mtime = current_time(inode);
 	ret = ocfs2_mark_inode_dirty(handle, inode, di_bh);
 	if (ret < 0)
_

Patches currently in -mm which might be from junxiao.bi@oracle.com are

ocfs2-fix-data-corruption-by-fallocate.patch

