Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 006CDA704E
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:39:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730898AbfICQiA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:38:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:47316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730151AbfICQ0Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:26:25 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E955D23950;
        Tue,  3 Sep 2019 16:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567527984;
        bh=UkABqeVisaqgrxZN86IYbyP7ntuQZtygLb/rJADdP10=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uLjYCPntUQ/eNj9zwq/smjKcmxjhdC8UOUW5aov/wUdNOa22FnOSy4MyldVnHZdC1
         D/TrzIkGRbwFEwq1PYDpWnTkTG3kVlDSF8Id+9uwljMAoJT3fh1B7SVZxD9CG7k3qx
         VSVYLLJBypwe4NKH4UobdumIyEjVaiuM5Xhof9u8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 039/167] btrfs: Fix error handling in btrfs_cleanup_ordered_extents
Date:   Tue,  3 Sep 2019 12:23:11 -0400
Message-Id: <20190903162519.7136-39-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903162519.7136-1-sashal@kernel.org>
References: <20190903162519.7136-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikolay Borisov <nborisov@suse.com>

[ Upstream commit d1051d6ebf8ef3517a5a3cf82bba8436d190f1c2 ]

Running btrfs/124 in a loop hung up on me sporadically with the
following call trace:

	btrfs           D    0  5760   5324 0x00000000
	Call Trace:
	 ? __schedule+0x243/0x800
	 schedule+0x33/0x90
	 btrfs_start_ordered_extent+0x10c/0x1b0 [btrfs]
	 ? wait_woken+0xa0/0xa0
	 btrfs_wait_ordered_range+0xbb/0x100 [btrfs]
	 btrfs_relocate_block_group+0x1ff/0x230 [btrfs]
	 btrfs_relocate_chunk+0x49/0x100 [btrfs]
	 btrfs_balance+0xbeb/0x1740 [btrfs]
	 btrfs_ioctl_balance+0x2ee/0x380 [btrfs]
	 btrfs_ioctl+0x1691/0x3110 [btrfs]
	 ? lockdep_hardirqs_on+0xed/0x180
	 ? __handle_mm_fault+0x8e7/0xfb0
	 ? _raw_spin_unlock+0x24/0x30
	 ? __handle_mm_fault+0x8e7/0xfb0
	 ? do_vfs_ioctl+0xa5/0x6e0
	 ? btrfs_ioctl_get_supported_features+0x30/0x30 [btrfs]
	 do_vfs_ioctl+0xa5/0x6e0
	 ? entry_SYSCALL_64_after_hwframe+0x3e/0xbe
	 ksys_ioctl+0x3a/0x70
	 __x64_sys_ioctl+0x16/0x20
	 do_syscall_64+0x60/0x1b0
	 entry_SYSCALL_64_after_hwframe+0x49/0xbe

This happens because during page writeback it's valid for
writepage_delalloc to instantiate a delalloc range which doesn't belong
to the page currently being written back.

The reason this case is valid is due to find_lock_delalloc_range
returning any available range after the passed delalloc_start and
ignoring whether the page under writeback is within that range.

In turn ordered extents (OE) are always created for the returned range
from find_lock_delalloc_range. If, however, a failure occurs while OE
are being created then the clean up code in btrfs_cleanup_ordered_extents
will be called.

Unfortunately the code in btrfs_cleanup_ordered_extents doesn't consider
the case of such 'foreign' range being processed and instead it always
assumes that the range OE are created for belongs to the page. This
leads to the first page of such foregin range to not be cleaned up since
it's deliberately missed and skipped by the current cleaning up code.

Fix this by correctly checking whether the current page belongs to the
range being instantiated and if so adjsut the range parameters passed
for cleaning up. If it doesn't, then just clean the whole OE range
directly.

Fixes: 524272607e88 ("btrfs: Handle delalloc error correctly to avoid ordered extent hang")
CC: stable@vger.kernel.org # 4.14+
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/inode.c | 29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index bfacce295ef1e..98c535ae038da 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -110,17 +110,17 @@ static void __endio_write_update_ordered(struct inode *inode,
  * extent_clear_unlock_delalloc() to clear both the bits EXTENT_DO_ACCOUNTING
  * and EXTENT_DELALLOC simultaneously, because that causes the reserved metadata
  * to be released, which we want to happen only when finishing the ordered
- * extent (btrfs_finish_ordered_io()). Also note that the caller of
- * btrfs_run_delalloc_range already does proper cleanup for the first page of
- * the range, that is, it invokes the callback writepage_end_io_hook() for the
- * range of the first page.
+ * extent (btrfs_finish_ordered_io()).
  */
 static inline void btrfs_cleanup_ordered_extents(struct inode *inode,
-						 const u64 offset,
-						 const u64 bytes)
+						 struct page *locked_page,
+						 u64 offset, u64 bytes)
 {
 	unsigned long index = offset >> PAGE_SHIFT;
 	unsigned long end_index = (offset + bytes - 1) >> PAGE_SHIFT;
+	u64 page_start = page_offset(locked_page);
+	u64 page_end = page_start + PAGE_SIZE - 1;
+
 	struct page *page;
 
 	while (index <= end_index) {
@@ -131,8 +131,18 @@ static inline void btrfs_cleanup_ordered_extents(struct inode *inode,
 		ClearPagePrivate2(page);
 		put_page(page);
 	}
-	return __endio_write_update_ordered(inode, offset + PAGE_SIZE,
-					    bytes - PAGE_SIZE, false);
+
+	/*
+	 * In case this page belongs to the delalloc range being instantiated
+	 * then skip it, since the first page of a range is going to be
+	 * properly cleaned up by the caller of run_delalloc_range
+	 */
+	if (page_start >= offset && page_end <= (offset + bytes - 1)) {
+		offset += PAGE_SIZE;
+		bytes -= PAGE_SIZE;
+	}
+
+	return __endio_write_update_ordered(inode, offset, bytes, false);
 }
 
 static int btrfs_dirty_inode(struct inode *inode);
@@ -1629,7 +1639,8 @@ int btrfs_run_delalloc_range(void *private_data, struct page *locked_page,
 					   write_flags);
 	}
 	if (ret)
-		btrfs_cleanup_ordered_extents(inode, start, end - start + 1);
+		btrfs_cleanup_ordered_extents(inode, locked_page, start,
+					      end - start + 1);
 	return ret;
 }
 
-- 
2.20.1

