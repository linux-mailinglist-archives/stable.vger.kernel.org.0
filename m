Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17B5B43D371
	for <lists+stable@lfdr.de>; Wed, 27 Oct 2021 23:02:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236912AbhJ0VEr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Oct 2021 17:04:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:53420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234360AbhJ0VEr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Oct 2021 17:04:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2C80D60231;
        Wed, 27 Oct 2021 21:02:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1635368541;
        bh=XoeUEZ02lw4m/gTt39mM2esIy6PnQRd18e0ZUgNWjGQ=;
        h=Date:From:To:Subject:From;
        b=pMF6LFsMhsqoR8I2JNpoAhQwWHsM516VELU8gENlfClVsx/FeOPbmBQDMCW7zfeZb
         o1K9PP7RK5jAk5yeKjOQjR86m39ROXJxVI3jIuiNWIlsb1agTzAldCdo/umK8aHVU9
         jml1yGMi+YnPp5ylR8ORNynX5gr3rYBfoGuiFYUo=
Date:   Wed, 27 Oct 2021 14:02:20 -0700
From:   akpm@linux-foundation.org
To:     gechangwei@live.cn, ghe@suse.com, jack@suse.cz,
        jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com,
        mark@fasheh.com, mm-commits@vger.kernel.org, piaojun@huawei.com,
        stable@vger.kernel.org
Subject:  + ocfs2-fix-data-corruption-on-truncate.patch added to
 -mm tree
Message-ID: <20211027210220.MdcTJqmu-%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: ocfs2: fix data corruption on truncate
has been added to the -mm tree.  Its filename is
     ocfs2-fix-data-corruption-on-truncate.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ocfs2-fix-data-corruption-on-truncate.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-fix-data-corruption-on-truncate.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
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

Patches currently in -mm which might be from jack@suse.cz are

ocfs2-fix-data-corruption-on-truncate.patch
ocfs2-do-not-zero-pages-beyond-i_size.patch

