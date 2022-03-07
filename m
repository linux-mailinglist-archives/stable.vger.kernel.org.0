Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09B474CF2AE
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 08:36:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235792AbiCGHhb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 02:37:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbiCGHhb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 02:37:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 582AF5F4F8
        for <stable@vger.kernel.org>; Sun,  6 Mar 2022 23:36:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E453E60AF6
        for <stable@vger.kernel.org>; Mon,  7 Mar 2022 07:36:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4D69C340EF;
        Mon,  7 Mar 2022 07:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646638596;
        bh=l3ueuCiNYG6fXv3kuzgnkKm713+R2eKfjOK6uS0zJm4=;
        h=Subject:To:Cc:From:Date:From;
        b=JZlheCNEEQ0+ERind11gLvffZ6KhAFjxkxKaCG+mFixh0jhsama4gc9N0WYRWga+A
         u/vj+94dQtokBVpYc0C/6rDT9yF8PcaTjWI1DyYvx8N6eYYaTcNpk/Afoo8Y6MLW1X
         ghoo6OjQ82exZAiXiCVBqEF2YecpmzHi5VWf1OtU=
Subject: FAILED: patch "[PATCH] btrfs: tree-checker: use u64 for item data end to avoid" failed to apply to 4.19-stable tree
To:     l@damenly.su, dsterba@suse.com, wenqingliu0120@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 07 Mar 2022 08:36:33 +0100
Message-ID: <164663859314532@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a6ab66eb8541d61b0a11d70980f07b4c2dfeddc5 Mon Sep 17 00:00:00 2001
From: Su Yue <l@damenly.su>
Date: Tue, 22 Feb 2022 16:42:07 +0800
Subject: [PATCH] btrfs: tree-checker: use u64 for item data end to avoid
 overflow

User reported there is an array-index-out-of-bounds access while
mounting the crafted image:

  [350.411942 ] loop0: detected capacity change from 0 to 262144
  [350.427058 ] BTRFS: device fsid a62e00e8-e94e-4200-8217-12444de93c2e devid 1 transid 8 /dev/loop0 scanned by systemd-udevd (1044)
  [350.428564 ] BTRFS info (device loop0): disk space caching is enabled
  [350.428568 ] BTRFS info (device loop0): has skinny extents
  [350.429589 ]
  [350.429619 ] UBSAN: array-index-out-of-bounds in fs/btrfs/struct-funcs.c:161:1
  [350.429636 ] index 1048096 is out of range for type 'page *[16]'
  [350.429650 ] CPU: 0 PID: 9 Comm: kworker/u8:1 Not tainted 5.16.0-rc4
  [350.429652 ] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.13.0-1ubuntu1.1 04/01/2014
  [350.429653 ] Workqueue: btrfs-endio-meta btrfs_work_helper [btrfs]
  [350.429772 ] Call Trace:
  [350.429774 ]  <TASK>
  [350.429776 ]  dump_stack_lvl+0x47/0x5c
  [350.429780 ]  ubsan_epilogue+0x5/0x50
  [350.429786 ]  __ubsan_handle_out_of_bounds+0x66/0x70
  [350.429791 ]  btrfs_get_16+0xfd/0x120 [btrfs]
  [350.429832 ]  check_leaf+0x754/0x1a40 [btrfs]
  [350.429874 ]  ? filemap_read+0x34a/0x390
  [350.429878 ]  ? load_balance+0x175/0xfc0
  [350.429881 ]  validate_extent_buffer+0x244/0x310 [btrfs]
  [350.429911 ]  btrfs_validate_metadata_buffer+0xf8/0x100 [btrfs]
  [350.429935 ]  end_bio_extent_readpage+0x3af/0x850 [btrfs]
  [350.429969 ]  ? newidle_balance+0x259/0x480
  [350.429972 ]  end_workqueue_fn+0x29/0x40 [btrfs]
  [350.429995 ]  btrfs_work_helper+0x71/0x330 [btrfs]
  [350.430030 ]  ? __schedule+0x2fb/0xa40
  [350.430033 ]  process_one_work+0x1f6/0x400
  [350.430035 ]  ? process_one_work+0x400/0x400
  [350.430036 ]  worker_thread+0x2d/0x3d0
  [350.430037 ]  ? process_one_work+0x400/0x400
  [350.430038 ]  kthread+0x165/0x190
  [350.430041 ]  ? set_kthread_struct+0x40/0x40
  [350.430043 ]  ret_from_fork+0x1f/0x30
  [350.430047 ]  </TASK>
  [350.430047 ]
  [350.430077 ] BTRFS warning (device loop0): bad eb member start: ptr 0xffe20f4e start 20975616 member offset 4293005178 size 2

btrfs check reports:
  corrupt leaf: root=3 block=20975616 physical=20975616 slot=1, unexpected
  item end, have 4294971193 expect 3897

The first slot item offset is 4293005033 and the size is 1966160.
In check_leaf, we use btrfs_item_end() to check item boundary versus
extent_buffer data size. However, return type of btrfs_item_end() is u32.
(u32)(4293005033 + 1966160) == 3897, overflow happens and the result 3897
equals to leaf data size reasonably.

Fix it by use u64 variable to store item data end in check_leaf() to
avoid u32 overflow.

This commit does solve the invalid memory access showed by the stack
trace.  However, its metadata profile is DUP and another copy of the
leaf is fine.  So the image can be mounted successfully. But when umount
is called, the ASSERT btrfs_mark_buffer_dirty() will be triggered
because the only node in extent tree has 0 item and invalid owner. It's
solved by another commit
"btrfs: check extent buffer owner against the owner rootid".

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=215299
Reported-by: Wenqing Liu <wenqingliu0120@gmail.com>
CC: stable@vger.kernel.org # 4.19+
Signed-off-by: Su Yue <l@damenly.su>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 9fd145f1c4bc..aae5697dde32 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -1682,6 +1682,7 @@ static int check_leaf(struct extent_buffer *leaf, bool check_item_data)
 	 */
 	for (slot = 0; slot < nritems; slot++) {
 		u32 item_end_expected;
+		u64 item_data_end;
 		int ret;
 
 		btrfs_item_key_to_cpu(leaf, &key, slot);
@@ -1696,6 +1697,8 @@ static int check_leaf(struct extent_buffer *leaf, bool check_item_data)
 			return -EUCLEAN;
 		}
 
+		item_data_end = (u64)btrfs_item_offset(leaf, slot) +
+				btrfs_item_size(leaf, slot);
 		/*
 		 * Make sure the offset and ends are right, remember that the
 		 * item data starts at the end of the leaf and grows towards the
@@ -1706,11 +1709,10 @@ static int check_leaf(struct extent_buffer *leaf, bool check_item_data)
 		else
 			item_end_expected = btrfs_item_offset(leaf,
 								 slot - 1);
-		if (unlikely(btrfs_item_data_end(leaf, slot) != item_end_expected)) {
+		if (unlikely(item_data_end != item_end_expected)) {
 			generic_err(leaf, slot,
-				"unexpected item end, have %u expect %u",
-				btrfs_item_data_end(leaf, slot),
-				item_end_expected);
+				"unexpected item end, have %llu expect %u",
+				item_data_end, item_end_expected);
 			return -EUCLEAN;
 		}
 
@@ -1719,12 +1721,10 @@ static int check_leaf(struct extent_buffer *leaf, bool check_item_data)
 		 * just in case all the items are consistent to each other, but
 		 * all point outside of the leaf.
 		 */
-		if (unlikely(btrfs_item_data_end(leaf, slot) >
-			     BTRFS_LEAF_DATA_SIZE(fs_info))) {
+		if (unlikely(item_data_end > BTRFS_LEAF_DATA_SIZE(fs_info))) {
 			generic_err(leaf, slot,
-			"slot end outside of leaf, have %u expect range [0, %u]",
-				btrfs_item_data_end(leaf, slot),
-				BTRFS_LEAF_DATA_SIZE(fs_info));
+			"slot end outside of leaf, have %llu expect range [0, %u]",
+				item_data_end, BTRFS_LEAF_DATA_SIZE(fs_info));
 			return -EUCLEAN;
 		}
 

