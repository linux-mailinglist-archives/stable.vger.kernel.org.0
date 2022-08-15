Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9ACA59483E
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:08:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242848AbiHOXWw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:22:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240822AbiHOXTE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:19:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A2E014A1C6;
        Mon, 15 Aug 2022 13:03:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2496B61089;
        Mon, 15 Aug 2022 20:03:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23159C433C1;
        Mon, 15 Aug 2022 20:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593834;
        bh=tR7DPSIp4Nw+YZPrGRHaKGiNk5UW/pvct4lAxpVCj08=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nrdL13bSKEznogFdPbVIvB+7s0hP+iIErED+ead6zkymWpW7e13NspikS6vjoHW/w
         ZeDuQpCIhe3Tq15QHvzxPwnzSZNPt+ILkkHEVTYAIbnePGTVBJveqx+qq22/B9mCYG
         YYgPg242FOfsubtbX7j8kc41y99HdBTCAWTjnKm4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        Naohiro Aota <naohiro.aota@wdc.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 1013/1095] btrfs: ensure pages are unlocked on cow_file_range() failure
Date:   Mon, 15 Aug 2022 20:06:52 +0200
Message-Id: <20220815180511.013269350@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naohiro Aota <naohiro.aota@wdc.com>

[ Upstream commit 9ce7466f372d83054c7494f6b3e4b9abaf3f0355 ]

There is a hung_task report on zoned btrfs like below.

https://github.com/naota/linux/issues/59

  [726.328648] INFO: task rocksdb:high0:11085 blocked for more than 241 seconds.
  [726.329839]       Not tainted 5.16.0-rc1+ #1
  [726.330484] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
  [726.331603] task:rocksdb:high0   state:D stack:    0 pid:11085 ppid: 11082 flags:0x00000000
  [726.331608] Call Trace:
  [726.331611]  <TASK>
  [726.331614]  __schedule+0x2e5/0x9d0
  [726.331622]  schedule+0x58/0xd0
  [726.331626]  io_schedule+0x3f/0x70
  [726.331629]  __folio_lock+0x125/0x200
  [726.331634]  ? find_get_entries+0x1bc/0x240
  [726.331638]  ? filemap_invalidate_unlock_two+0x40/0x40
  [726.331642]  truncate_inode_pages_range+0x5b2/0x770
  [726.331649]  truncate_inode_pages_final+0x44/0x50
  [726.331653]  btrfs_evict_inode+0x67/0x480
  [726.331658]  evict+0xd0/0x180
  [726.331661]  iput+0x13f/0x200
  [726.331664]  do_unlinkat+0x1c0/0x2b0
  [726.331668]  __x64_sys_unlink+0x23/0x30
  [726.331670]  do_syscall_64+0x3b/0xc0
  [726.331674]  entry_SYSCALL_64_after_hwframe+0x44/0xae
  [726.331677] RIP: 0033:0x7fb9490a171b
  [726.331681] RSP: 002b:00007fb943ffac68 EFLAGS: 00000246 ORIG_RAX: 0000000000000057
  [726.331684] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fb9490a171b
  [726.331686] RDX: 00007fb943ffb040 RSI: 000055a6bbe6ec20 RDI: 00007fb94400d300
  [726.331687] RBP: 00007fb943ffad00 R08: 0000000000000000 R09: 0000000000000000
  [726.331688] R10: 0000000000000031 R11: 0000000000000246 R12: 00007fb943ffb000
  [726.331690] R13: 00007fb943ffb040 R14: 0000000000000000 R15: 00007fb943ffd260
  [726.331693]  </TASK>

While we debug the issue, we found running fstests generic/551 on 5GB
non-zoned null_blk device in the emulated zoned mode also had a
similar hung issue.

Also, we can reproduce the same symptom with an error injected
cow_file_range() setup.

The hang occurs when cow_file_range() fails in the middle of
allocation. cow_file_range() called from do_allocation_zoned() can
split the give region ([start, end]) for allocation depending on
current block group usages. When btrfs can allocate bytes for one part
of the split regions but fails for the other region (e.g. because of
-ENOSPC), we return the error leaving the pages in the succeeded regions
locked. Technically, this occurs only when @unlock == 0. Otherwise, we
unlock the pages in an allocated region after creating an ordered
extent.

Considering the callers of cow_file_range(unlock=0) won't write out
the pages, we can unlock the pages on error exit from
cow_file_range(). So, we can ensure all the pages except @locked_page
are unlocked on error case.

In summary, cow_file_range now behaves like this:

- page_started == 1 (return value)
  - All the pages are unlocked. IO is started.
- unlock == 1
  - All the pages except @locked_page are unlocked in any case
- unlock == 0
  - On success, all the pages are locked for writing out them
  - On failure, all the pages except @locked_page are unlocked

Fixes: 42c011000963 ("btrfs: zoned: introduce dedicated data write path for zoned filesystems")
CC: stable@vger.kernel.org # 5.12+
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/inode.c | 72 ++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 64 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 5d15e374d032..54afa9e538c5 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1097,6 +1097,28 @@ static u64 get_extent_allocation_hint(struct btrfs_inode *inode, u64 start,
  * *page_started is set to one if we unlock locked_page and do everything
  * required to start IO on it.  It may be clean and already done with
  * IO when we return.
+ *
+ * When unlock == 1, we unlock the pages in successfully allocated regions.
+ * When unlock == 0, we leave them locked for writing them out.
+ *
+ * However, we unlock all the pages except @locked_page in case of failure.
+ *
+ * In summary, page locking state will be as follow:
+ *
+ * - page_started == 1 (return value)
+ *     - All the pages are unlocked. IO is started.
+ *     - Note that this can happen only on success
+ * - unlock == 1
+ *     - All the pages except @locked_page are unlocked in any case
+ * - unlock == 0
+ *     - On success, all the pages are locked for writing out them
+ *     - On failure, all the pages except @locked_page are unlocked
+ *
+ * When a failure happens in the second or later iteration of the
+ * while-loop, the ordered extents created in previous iterations are kept
+ * intact. So, the caller must clean them up by calling
+ * btrfs_cleanup_ordered_extents(). See btrfs_run_delalloc_range() for
+ * example.
  */
 static noinline int cow_file_range(struct btrfs_inode *inode,
 				   struct page *locked_page,
@@ -1106,6 +1128,7 @@ static noinline int cow_file_range(struct btrfs_inode *inode,
 	struct btrfs_root *root = inode->root;
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	u64 alloc_hint = 0;
+	u64 orig_start = start;
 	u64 num_bytes;
 	unsigned long ram_size;
 	u64 cur_alloc_size = 0;
@@ -1293,18 +1316,44 @@ static noinline int cow_file_range(struct btrfs_inode *inode,
 	btrfs_dec_block_group_reservations(fs_info, ins.objectid);
 	btrfs_free_reserved_extent(fs_info, ins.objectid, ins.offset, 1);
 out_unlock:
+	/*
+	 * Now, we have three regions to clean up:
+	 *
+	 * |-------(1)----|---(2)---|-------------(3)----------|
+	 * `- orig_start  `- start  `- start + cur_alloc_size  `- end
+	 *
+	 * We process each region below.
+	 */
+
 	clear_bits = EXTENT_LOCKED | EXTENT_DELALLOC | EXTENT_DELALLOC_NEW |
 		EXTENT_DEFRAG | EXTENT_CLEAR_META_RESV;
 	page_ops = PAGE_UNLOCK | PAGE_START_WRITEBACK | PAGE_END_WRITEBACK;
+
 	/*
-	 * If we reserved an extent for our delalloc range (or a subrange) and
-	 * failed to create the respective ordered extent, then it means that
-	 * when we reserved the extent we decremented the extent's size from
-	 * the data space_info's bytes_may_use counter and incremented the
-	 * space_info's bytes_reserved counter by the same amount. We must make
-	 * sure extent_clear_unlock_delalloc() does not try to decrement again
-	 * the data space_info's bytes_may_use counter, therefore we do not pass
-	 * it the flag EXTENT_CLEAR_DATA_RESV.
+	 * For the range (1). We have already instantiated the ordered extents
+	 * for this region. They are cleaned up by
+	 * btrfs_cleanup_ordered_extents() in e.g,
+	 * btrfs_run_delalloc_range(). EXTENT_LOCKED | EXTENT_DELALLOC are
+	 * already cleared in the above loop. And, EXTENT_DELALLOC_NEW |
+	 * EXTENT_DEFRAG | EXTENT_CLEAR_META_RESV are handled by the cleanup
+	 * function.
+	 *
+	 * However, in case of unlock == 0, we still need to unlock the pages
+	 * (except @locked_page) to ensure all the pages are unlocked.
+	 */
+	if (!unlock && orig_start < start)
+		extent_clear_unlock_delalloc(inode, orig_start, start - 1,
+					     locked_page, 0, page_ops);
+
+	/*
+	 * For the range (2). If we reserved an extent for our delalloc range
+	 * (or a subrange) and failed to create the respective ordered extent,
+	 * then it means that when we reserved the extent we decremented the
+	 * extent's size from the data space_info's bytes_may_use counter and
+	 * incremented the space_info's bytes_reserved counter by the same
+	 * amount. We must make sure extent_clear_unlock_delalloc() does not try
+	 * to decrement again the data space_info's bytes_may_use counter,
+	 * therefore we do not pass it the flag EXTENT_CLEAR_DATA_RESV.
 	 */
 	if (extent_reserved) {
 		extent_clear_unlock_delalloc(inode, start,
@@ -1316,6 +1365,13 @@ static noinline int cow_file_range(struct btrfs_inode *inode,
 		if (start >= end)
 			goto out;
 	}
+
+	/*
+	 * For the range (3). We never touched the region. In addition to the
+	 * clear_bits above, we add EXTENT_CLEAR_DATA_RESV to release the data
+	 * space_info's bytes_may_use counter, reserved in
+	 * btrfs_check_data_free_space().
+	 */
 	extent_clear_unlock_delalloc(inode, start, end, locked_page,
 				     clear_bits | EXTENT_CLEAR_DATA_RESV,
 				     page_ops);
-- 
2.35.1



