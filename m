Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC12427CAED
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730003AbgI2MXK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:23:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:50310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729784AbgI2LfK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:35:10 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E5F7723D22;
        Tue, 29 Sep 2020 11:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378962;
        bh=C4qFLAwNdpjh9f7UNEdMDeMXdEoFSVGD+a8VN+/fVqk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FmhLq/j021qgQU7wPIsZQAzZL8P6zP48fEcXyahIHZkElYvEG8V5sIFYtJx/pQv+2
         OsBuEj/RAL9qzV3gyUIqhRsoz3/JtA+X8vcwBlJ5eoyIjCtg93aUpOhvDRGA/6jaWN
         xN5LpJc1fu0JDF9o8kDhSIg4ncPfy1S2aNocV+Sg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 201/245] btrfs: qgroup: fix data leak caused by race between writeback and truncate
Date:   Tue, 29 Sep 2020 13:00:52 +0200
Message-Id: <20200929105956.755890675@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105946.978650816@linuxfoundation.org>
References: <20200929105946.978650816@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit fa91e4aa1716004ea8096d5185ec0451e206aea0 ]

[BUG]
When running tests like generic/013 on test device with btrfs quota
enabled, it can normally lead to data leak, detected at unmount time:

  BTRFS warning (device dm-3): qgroup 0/5 has unreleased space, type 0 rsv 4096
  ------------[ cut here ]------------
  WARNING: CPU: 11 PID: 16386 at fs/btrfs/disk-io.c:4142 close_ctree+0x1dc/0x323 [btrfs]
  RIP: 0010:close_ctree+0x1dc/0x323 [btrfs]
  Call Trace:
   btrfs_put_super+0x15/0x17 [btrfs]
   generic_shutdown_super+0x72/0x110
   kill_anon_super+0x18/0x30
   btrfs_kill_super+0x17/0x30 [btrfs]
   deactivate_locked_super+0x3b/0xa0
   deactivate_super+0x40/0x50
   cleanup_mnt+0x135/0x190
   __cleanup_mnt+0x12/0x20
   task_work_run+0x64/0xb0
   __prepare_exit_to_usermode+0x1bc/0x1c0
   __syscall_return_slowpath+0x47/0x230
   do_syscall_64+0x64/0xb0
   entry_SYSCALL_64_after_hwframe+0x44/0xa9
  ---[ end trace caf08beafeca2392 ]---
  BTRFS error (device dm-3): qgroup reserved space leaked

[CAUSE]
In the offending case, the offending operations are:
2/6: writev f2X[269 1 0 0 0 0] [1006997,67,288] 0
2/7: truncate f2X[269 1 0 0 48 1026293] 18388 0

The following sequence of events could happen after the writev():
	CPU1 (writeback)		|		CPU2 (truncate)
-----------------------------------------------------------------
btrfs_writepages()			|
|- extent_write_cache_pages()		|
   |- Got page for 1003520		|
   |  1003520 is Dirty, no writeback	|
   |  So (!clear_page_dirty_for_io())   |
   |  gets called for it		|
   |- Now page 1003520 is Clean.	|
   |					| btrfs_setattr()
   |					| |- btrfs_setsize()
   |					|    |- truncate_setsize()
   |					|       New i_size is 18388
   |- __extent_writepage()		|
   |  |- page_offset() > i_size		|
      |- btrfs_invalidatepage()		|
	 |- Page is clean, so no qgroup |
	    callback executed

This means, the qgroup reserved data space is not properly released in
btrfs_invalidatepage() as the page is Clean.

[FIX]
Instead of checking the dirty bit of a page, call
btrfs_qgroup_free_data() unconditionally in btrfs_invalidatepage().

As qgroup rsv are completely bound to the QGROUP_RESERVED bit of
io_tree, not bound to page status, thus we won't cause double freeing
anyway.

Fixes: 0b34c261e235 ("btrfs: qgroup: Prevent qgroup->reserved from going subzero")
CC: stable@vger.kernel.org # 4.14+
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/inode.c | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index bdfe159a60da6..64d459ca76d06 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8913,20 +8913,17 @@ again:
 	/*
 	 * Qgroup reserved space handler
 	 * Page here will be either
-	 * 1) Already written to disk
-	 *    In this case, its reserved space is released from data rsv map
-	 *    and will be freed by delayed_ref handler finally.
-	 *    So even we call qgroup_free_data(), it won't decrease reserved
-	 *    space.
-	 * 2) Not written to disk
-	 *    This means the reserved space should be freed here. However,
-	 *    if a truncate invalidates the page (by clearing PageDirty)
-	 *    and the page is accounted for while allocating extent
-	 *    in btrfs_check_data_free_space() we let delayed_ref to
-	 *    free the entire extent.
+	 * 1) Already written to disk or ordered extent already submitted
+	 *    Then its QGROUP_RESERVED bit in io_tree is already cleaned.
+	 *    Qgroup will be handled by its qgroup_record then.
+	 *    btrfs_qgroup_free_data() call will do nothing here.
+	 *
+	 * 2) Not written to disk yet
+	 *    Then btrfs_qgroup_free_data() call will clear the QGROUP_RESERVED
+	 *    bit of its io_tree, and free the qgroup reserved data space.
+	 *    Since the IO will never happen for this page.
 	 */
-	if (PageDirty(page))
-		btrfs_qgroup_free_data(inode, NULL, page_start, PAGE_SIZE);
+	btrfs_qgroup_free_data(inode, NULL, page_start, PAGE_SIZE);
 	if (!inode_evicting) {
 		clear_extent_bit(tree, page_start, page_end,
 				 EXTENT_LOCKED | EXTENT_DIRTY |
-- 
2.25.1



