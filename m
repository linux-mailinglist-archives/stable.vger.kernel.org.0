Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 297B5121773
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:36:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729907AbfLPSHH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:07:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:47838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730091AbfLPSHG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:07:06 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 44758206EC;
        Mon, 16 Dec 2019 18:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519625;
        bh=8u+kKloouRp+fZXOBHVFwKcMa6g72kyl4ur9MdRpgTE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YQU/kz01YjuK5gbmA0/Xvfem8jsP9ZTOxGB8OTsyQCGkzTQbSCcI9/8LtJTOTUs8/
         495tjPM6iglQF0NAMFDEEllrE2cl21MWpaTMfuHtVY4/0n/dqhiv9LEhypokGUYLxH
         iaOmZl8yeW2Su2mrosfknupDOGrB+5k+y/mLcEFA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        yangerkun <yangerkun@huawei.com>, Jan Kara <jack@suse.cz>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 4.19 136/140] ext4: fix a bug in ext4_wait_for_tail_page_commit
Date:   Mon, 16 Dec 2019 18:50:04 +0100
Message-Id: <20191216174829.442597047@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174747.111154704@linuxfoundation.org>
References: <20191216174747.111154704@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: yangerkun <yangerkun@huawei.com>

commit 565333a1554d704789e74205989305c811fd9c7a upstream.

No need to wait for any commit once the page is fully truncated.
Besides, it may confuse e.g. concurrent ext4_writepage() with the page
still be dirty (will be cleared by truncate_pagecache() in
ext4_setattr()) but buffers has been freed; and then trigger a bug
show as below:

[   26.057508] ------------[ cut here ]------------
[   26.058531] kernel BUG at fs/ext4/inode.c:2134!
...
[   26.088130] Call trace:
[   26.088695]  ext4_writepage+0x914/0xb28
[   26.089541]  writeout.isra.4+0x1b4/0x2b8
[   26.090409]  move_to_new_page+0x3b0/0x568
[   26.091338]  __unmap_and_move+0x648/0x988
[   26.092241]  unmap_and_move+0x48c/0xbb8
[   26.093096]  migrate_pages+0x220/0xb28
[   26.093945]  kernel_mbind+0x828/0xa18
[   26.094791]  __arm64_sys_mbind+0xc8/0x138
[   26.095716]  el0_svc_common+0x190/0x490
[   26.096571]  el0_svc_handler+0x60/0xd0
[   26.097423]  el0_svc+0x8/0xc

Run the procedure (generate by syzkaller) parallel with ext3.

void main()
{
	int fd, fd1, ret;
	void *addr;
	size_t length = 4096;
	int flags;
	off_t offset = 0;
	char *str = "12345";

	fd = open("a", O_RDWR | O_CREAT);
	assert(fd >= 0);

	/* Truncate to 4k */
	ret = ftruncate(fd, length);
	assert(ret == 0);

	/* Journal data mode */
	flags = 0xc00f;
	ret = ioctl(fd, _IOW('f', 2, long), &flags);
	assert(ret == 0);

	/* Truncate to 0 */
	fd1 = open("a", O_TRUNC | O_NOATIME);
	assert(fd1 >= 0);

	addr = mmap(NULL, length, PROT_WRITE | PROT_READ,
					MAP_SHARED, fd, offset);
	assert(addr != (void *)-1);

	memcpy(addr, str, 5);
	mbind(addr, length, 0, 0, 0, MPOL_MF_MOVE);
}

And the bug will be triggered once we seen the below order.

reproduce1                         reproduce2

...                            |   ...
truncate to 4k                 |
change to journal data mode    |
                               |   memcpy(set page dirty)
truncate to 0:                 |
ext4_setattr:                  |
...                            |
ext4_wait_for_tail_page_commit |
                               |   mbind(trigger bug)
truncate_pagecache(clean dirty)|   ...
...                            |

mbind will call ext4_writepage() since the page still be dirty, and then
report the bug since the buffers has been free. Fix it by return
directly once offset equals to 0 which means the page has been fully
truncated.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: yangerkun <yangerkun@huawei.com>
Link: https://lore.kernel.org/r/20190919063508.1045-1-yangerkun@huawei.com
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/inode.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5459,11 +5459,15 @@ static void ext4_wait_for_tail_page_comm
 
 	offset = inode->i_size & (PAGE_SIZE - 1);
 	/*
-	 * All buffers in the last page remain valid? Then there's nothing to
-	 * do. We do the check mainly to optimize the common PAGE_SIZE ==
-	 * blocksize case
+	 * If the page is fully truncated, we don't need to wait for any commit
+	 * (and we even should not as __ext4_journalled_invalidatepage() may
+	 * strip all buffers from the page but keep the page dirty which can then
+	 * confuse e.g. concurrent ext4_writepage() seeing dirty page without
+	 * buffers). Also we don't need to wait for any commit if all buffers in
+	 * the page remain valid. This is most beneficial for the common case of
+	 * blocksize == PAGESIZE.
 	 */
-	if (offset > PAGE_SIZE - i_blocksize(inode))
+	if (!offset || offset > (PAGE_SIZE - i_blocksize(inode)))
 		return;
 	while (1) {
 		page = find_lock_page(inode->i_mapping,


