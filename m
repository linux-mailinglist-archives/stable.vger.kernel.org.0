Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 659F64469C6
	for <lists+stable@lfdr.de>; Fri,  5 Nov 2021 21:34:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231946AbhKEUhg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Nov 2021 16:37:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:60636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231288AbhKEUhg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Nov 2021 16:37:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0121661279;
        Fri,  5 Nov 2021 20:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144496;
        bh=OXcNBKV2broFZ2R+f4CXMqo8D5nn4AOws8wB04GUjkE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=aq5TiriTSiQUAQxt/aMCjx08b8hUq28tiYF/q/DYCygh9+Ca+LgEiOg3+c1v4t9CV
         y0ROTc0GcO+qIJirHv1uhsVRREL04uN53ZEo/BRbtiRU2CMh2jxnNG8lXpmsL5+km9
         VYwpYkaNXyMMMJJUD+5M+DPcJHrCWIcp6ipxtqTg=
Date:   Fri, 05 Nov 2021 13:34:55 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, gechangwei@live.cn, ghe@suse.com,
        jack@suse.cz, jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
        junxiao.bi@oracle.com, linux-mm@kvack.org, mark@fasheh.com,
        mm-commits@vger.kernel.org, piaojun@huawei.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 007/262] ocfs2: fix data corruption on truncate
Message-ID: <20211105203455.hOZux5v3f%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>
Subject: ocfs2: fix data corruption on truncate

Patch series "ocfs2: Truncate data corruption fix".

As further testing has shown, commit 5314454ea3f ("ocfs2: fix data
corruption after conversion from inline format") didn't fix all the data
corruption issues the customer started observing after 6dbf7bb55598 ("fs:
Don't invalidate page buffers in block_write_full_page()") This time I
have tracked them down to two bugs in ocfs2 truncation code.

One bug (truncating page cache before clearing tail cluster and setting
i_size) could cause data corruption even before 6dbf7bb55598, but before
that commit it needed a race with page fault, after 6dbf7bb55598 it
started to be pretty deterministic.

Another bug (zeroing pages beyond old i_size) used to be harmless
inefficiency before commit 6dbf7bb55598.  But after commit 6dbf7bb55598 in
combination with the first bug it resulted in deterministic data
corruption.

Although fixing only the first problem is needed to stop data corruption,
I've fixed both issues to make the code more robust.


This patch (of 2):

ocfs2_truncate_file() did unmap invalidate page cache pages before zeroing
partial tail cluster and setting i_size.  Thus some pages could be left
(and likely have left if the cluster zeroing happened) in the page cache
beyond i_size after truncate finished letting user possibly see stale data
once the file was extended again.  Also the tail cluster zeroing was not
guaranteed to finish before truncate finished causing possible stale data
exposure.  The problem started to be particularly easy to hit after commit
6dbf7bb55598 "fs: Don't invalidate page buffers in
block_write_full_page()" stopped invalidation of pages beyond i_size from
page writeback path.

Fix these problems by unmapping and invalidating pages in the page cache
after the i_size is reduced and tail cluster is zeroed out.

Link: https://lkml.kernel.org/r/20211025150008.29002-1-jack@suse.cz
Link: https://lkml.kernel.org/r/20211025151332.11301-1-jack@suse.cz
Fixes: ccd979bdbce9 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/file.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/fs/ocfs2/file.c~ocfs2-fix-data-corruption-on-truncate
+++ a/fs/ocfs2/file.c
@@ -476,10 +476,11 @@ int ocfs2_truncate_file(struct inode *in
 	 * greater than page size, so we have to truncate them
 	 * anyway.
 	 */
-	unmap_mapping_range(inode->i_mapping, new_i_size + PAGE_SIZE - 1, 0, 1);
-	truncate_inode_pages(inode->i_mapping, new_i_size);
 
 	if (OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL) {
+		unmap_mapping_range(inode->i_mapping,
+				    new_i_size + PAGE_SIZE - 1, 0, 1);
+		truncate_inode_pages(inode->i_mapping, new_i_size);
 		status = ocfs2_truncate_inline(inode, di_bh, new_i_size,
 					       i_size_read(inode), 1);
 		if (status)
@@ -498,6 +499,9 @@ int ocfs2_truncate_file(struct inode *in
 		goto bail_unlock_sem;
 	}
 
+	unmap_mapping_range(inode->i_mapping, new_i_size + PAGE_SIZE - 1, 0, 1);
+	truncate_inode_pages(inode->i_mapping, new_i_size);
+
 	status = ocfs2_commit_truncate(osb, inode, di_bh);
 	if (status < 0) {
 		mlog_errno(status);
_
