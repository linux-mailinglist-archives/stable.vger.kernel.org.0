Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D5F32ABC99
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:39:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731138AbgKINjK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:39:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:56462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730275AbgKINDl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:03:41 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6552C2223F;
        Mon,  9 Nov 2020 13:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927009;
        bh=oJJKmzFsOhg7PmwtUppYWcX6J/AGaHtV9CnB1axJTDs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BcksoBAm5XdM6sNw0hYLrTx0g7NQcsyyzMmHXZImdNq4s3O5iRobOFLQWxG6pazMQ
         0Vo+lVCvr7s/8Gw/NQDv3q4M1jbrMWgaZPWOXbVRo2b2j1j36tIzHe6zi7SnnzhZwP
         NZ8Cc5miY4If4Pw4BNNW5y1HTDBY7C+5HA4O0JVw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ye Bin <yebin10@huawei.com>,
        Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4.9 049/117] fs: Dont invalidate page buffers in block_write_full_page()
Date:   Mon,  9 Nov 2020 13:54:35 +0100
Message-Id: <20201109125027.995782201@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125025.630721781@linuxfoundation.org>
References: <20201109125025.630721781@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

commit 6dbf7bb555981fb5faf7b691e8f6169fc2b2e63b upstream.

If block_write_full_page() is called for a page that is beyond current
inode size, it will truncate page buffers for the page and return 0.
This logic has been added in 2.5.62 in commit 81eb69062588 ("fix ext3
BUG due to race with truncate") in history.git tree to fix a problem
with ext3 in data=ordered mode. This particular problem doesn't exist
anymore because ext3 is long gone and ext4 handles ordered data
differently. Also normally buffers are invalidated by truncate code and
there's no need to specially handle this in ->writepage() code.

This invalidation of page buffers in block_write_full_page() is causing
issues to filesystems (e.g. ext4 or ocfs2) when block device is shrunk
under filesystem's hands and metadata buffers get discarded while being
tracked by the journalling layer. Although it is obviously "not
supported" it can cause kernel crashes like:

[ 7986.689400] BUG: unable to handle kernel NULL pointer dereference at
+0000000000000008
[ 7986.697197] PGD 0 P4D 0
[ 7986.699724] Oops: 0002 [#1] SMP PTI
[ 7986.703200] CPU: 4 PID: 203778 Comm: jbd2/dm-3-8 Kdump: loaded Tainted: G
+O     --------- -  - 4.18.0-147.5.0.5.h126.eulerosv2r9.x86_64 #1
[ 7986.716438] Hardware name: Huawei RH2288H V3/BC11HGSA0, BIOS 1.57 08/11/2015
[ 7986.723462] RIP: 0010:jbd2_journal_grab_journal_head+0x1b/0x40 [jbd2]
...
[ 7986.810150] Call Trace:
[ 7986.812595]  __jbd2_journal_insert_checkpoint+0x23/0x70 [jbd2]
[ 7986.818408]  jbd2_journal_commit_transaction+0x155f/0x1b60 [jbd2]
[ 7986.836467]  kjournald2+0xbd/0x270 [jbd2]

which is not great. The crash happens because bh->b_private is suddently
NULL although BH_JBD flag is still set (this is because
block_invalidatepage() cleared BH_Mapped flag and subsequent bh lookup
found buffer without BH_Mapped set, called init_page_buffers() which has
rewritten bh->b_private). So just remove the invalidation in
block_write_full_page().

Note that the buffer cache invalidation when block device changes size
is already careful to avoid similar problems by using
invalidate_mapping_pages() which skips busy buffers so it was only this
odd block_write_full_page() behavior that could tear down bdev buffers
under filesystem's hands.

Reported-by: Ye Bin <yebin10@huawei.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christoph Hellwig <hch@lst.de>
CC: stable@vger.kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/buffer.c |   16 ----------------
 1 file changed, 16 deletions(-)

--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2753,16 +2753,6 @@ int nobh_writepage(struct page *page, ge
 	/* Is the page fully outside i_size? (truncate in progress) */
 	offset = i_size & (PAGE_SIZE-1);
 	if (page->index >= end_index+1 || !offset) {
-		/*
-		 * The page may have dirty, unmapped buffers.  For example,
-		 * they may have been added in ext3_writepage().  Make them
-		 * freeable here, so the page does not leak.
-		 */
-#if 0
-		/* Not really sure about this  - do we need this ? */
-		if (page->mapping->a_ops->invalidatepage)
-			page->mapping->a_ops->invalidatepage(page, offset);
-#endif
 		unlock_page(page);
 		return 0; /* don't care */
 	}
@@ -2957,12 +2947,6 @@ int block_write_full_page(struct page *p
 	/* Is the page fully outside i_size? (truncate in progress) */
 	offset = i_size & (PAGE_SIZE-1);
 	if (page->index >= end_index+1 || !offset) {
-		/*
-		 * The page may have dirty, unmapped buffers.  For example,
-		 * they may have been added in ext3_writepage().  Make them
-		 * freeable here, so the page does not leak.
-		 */
-		do_invalidatepage(page, 0, PAGE_SIZE);
 		unlock_page(page);
 		return 0; /* don't care */
 	}


