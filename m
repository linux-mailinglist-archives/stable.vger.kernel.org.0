Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84ADA25182C
	for <lists+stable@lfdr.de>; Tue, 25 Aug 2020 14:06:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729436AbgHYMGI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Aug 2020 08:06:08 -0400
Received: from mx2.suse.de ([195.135.220.15]:42086 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729188AbgHYMGF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Aug 2020 08:06:05 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 8810DAFC5;
        Tue, 25 Aug 2020 12:06:34 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 19F9E1E06E9; Tue, 25 Aug 2020 14:05:59 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     <linux-fsdevel@vger.kernel.org>
Cc:     yebin <yebin10@huawei.com>, Christoph Hellwig <hch@infradead.org>,
        <linux-block@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Jan Kara <jack@suse.cz>, stable@vger.kernel.org
Subject: [PATCH RFC 1/2] fs: Don't invalidate page buffers in block_write_full_page()
Date:   Tue, 25 Aug 2020 14:05:53 +0200
Message-Id: <20200825120554.13070-2-jack@suse.cz>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200825120554.13070-1-jack@suse.cz>
References: <20200825120554.13070-1-jack@suse.cz>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/buffer.c | 16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 061dd202979d..163c2c0b9aa3 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2771,16 +2771,6 @@ int nobh_writepage(struct page *page, get_block_t *get_block,
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
@@ -2975,12 +2965,6 @@ int block_write_full_page(struct page *page, get_block_t *get_block,
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
-- 
2.16.4

