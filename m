Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 315E81FF585
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 16:48:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731059AbgFROrV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jun 2020 10:47:21 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:52291 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731055AbgFROrT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jun 2020 10:47:19 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 7771A69B;
        Thu, 18 Jun 2020 10:47:18 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Thu, 18 Jun 2020 10:47:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=31MhiL
        WrmdZJAdoKmmCH1JPDam8/9mWzG8IFXIPMZTI=; b=ZGb1elOoMGmFp/v3+r5abD
        aaodmpiUkYZU9n92BEqeUlLQri/1jslfdNqvw06fWbmwcI+LmWQRxscA1//Ip0Fw
        fqniXwsWNRaJYo0r92mMy2gkJXI5eRclX93fokJaycZXVEyBr4zXelQrtEaD0sD5
        Z2UIAfZ2k4wpv568WLpwb4RDXkzoRI4cLT+f08qgeAYqhXqWhx8YS69TPrcmuEhI
        Uz8xNP19naEqQs3LIcN4EIPyWXS40455T7y+GViVbgpu+XmFfKHk7uIdEV19Qyf0
        AnMAeyW2tUiXYFqakxxyAT9vslStg0S1bsQVFv+5RpfEqVGMAdqPT7icJbFvB7oA
        ==
X-ME-Sender: <xms:dX7rXhr89qAgrKVuLfMhuVLciQDbTTB7Bi86Q3ZjdUI4nFzAw8ht9w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudejgedgkedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepfeetteehueetheekueevhfefveejheegtdeiudehue
    ekheeijeefgfeuhfeigefhnecuffhomhgrihhnpehqvghmuhdrohhrghenucfkphepkeef
    rdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepheenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:dn7rXjrPlqsem2oqdIMsIwi2xC96So2OVCsBiZ0OAz0hrLC1Y6tPpA>
    <xmx:dn7rXuOvPNrCIoNMmhIQ3gP3BG7AQJPN6uURYfbxZmefpw0gJZAsLg>
    <xmx:dn7rXs5BBLYJgBQwSX8CgUwZrM5Hum6zA0lM4Y1gtX12Q7BbfWIPDw>
    <xmx:dn7rXlXvSzLn0ZJtkXM7mwko2DAyKawSuoSKDHcmnacn_tByMmCQplDjL0U>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 91B6A328005E;
        Thu, 18 Jun 2020 10:47:17 -0400 (EDT)
Subject: FAILED: patch "[PATCH] btrfs: fix corrupt log due to concurrent fsync of inodes with" failed to apply to 4.9-stable tree
To:     fdmanana@suse.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 18 Jun 2020 16:47:10 +0200
Message-ID: <159249163021493@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From e289f03ea79bbc6574b78ac25682555423a91cbb Mon Sep 17 00:00:00 2001
From: Filipe Manana <fdmanana@suse.com>
Date: Mon, 18 May 2020 12:14:50 +0100
Subject: [PATCH] btrfs: fix corrupt log due to concurrent fsync of inodes with
 shared extents

When we have extents shared amongst different inodes in the same subvolume,
if we fsync them in parallel we can end up with checksum items in the log
tree that represent ranges which overlap.

For example, consider we have inodes A and B, both sharing an extent that
covers the logical range from X to X + 64KiB:

1) Task A starts an fsync on inode A;

2) Task B starts an fsync on inode B;

3) Task A calls btrfs_csum_file_blocks(), and the first search in the
   log tree, through btrfs_lookup_csum(), returns -EFBIG because it
   finds an existing checksum item that covers the range from X - 64KiB
   to X;

4) Task A checks that the checksum item has not reached the maximum
   possible size (MAX_CSUM_ITEMS) and then releases the search path
   before it does another path search for insertion (through a direct
   call to btrfs_search_slot());

5) As soon as task A releases the path and before it does the search
   for insertion, task B calls btrfs_csum_file_blocks() and gets -EFBIG
   too, because there is an existing checksum item that has an end
   offset that matches the start offset (X) of the checksum range we want
   to log;

6) Task B releases the path;

7) Task A does the path search for insertion (through btrfs_search_slot())
   and then verifies that the checksum item that ends at offset X still
   exists and extends its size to insert the checksums for the range from
   X to X + 64KiB;

8) Task A releases the path and returns from btrfs_csum_file_blocks(),
   having inserted the checksums into an existing checksum item that got
   its size extended. At this point we have one checksum item in the log
   tree that covers the logical range from X - 64KiB to X + 64KiB;

9) Task B now does a search for insertion using btrfs_search_slot() too,
   but it finds that the previous checksum item no longer ends at the
   offset X, it now ends at an of offset X + 64KiB, so it leaves that item
   untouched.

   Then it releases the path and calls btrfs_insert_empty_item()
   that inserts a checksum item with a key offset corresponding to X and
   a size for inserting a single checksum (4 bytes in case of crc32c).
   Subsequent iterations end up extending this new checksum item so that
   it contains the checksums for the range from X to X + 64KiB.

   So after task B returns from btrfs_csum_file_blocks() we end up with
   two checksum items in the log tree that have overlapping ranges, one
   for the range from X - 64KiB to X + 64KiB, and another for the range
   from X to X + 64KiB.

Having checksum items that represent ranges which overlap, regardless of
being in the log tree or in the chekcsums tree, can lead to problems where
checksums for a file range end up not being found. This type of problem
has happened a few times in the past and the following commits fixed them
and explain in detail why having checksum items with overlapping ranges is
problematic:

  27b9a8122ff71a "Btrfs: fix csum tree corruption, duplicate and outdated checksums"
  b84b8390d6009c "Btrfs: fix file read corruption after extent cloning and fsync"
  40e046acbd2f36 "Btrfs: fix missing data checksums after replaying a log tree"

Since this specific instance of the problem can only happen when logging
inodes, because it is the only case where concurrent attempts to insert
checksums for the same range can happen, fix the issue by using an extent
io tree as a range lock to serialize checksum insertion during inode
logging.

This issue could often be reproduced by the test case generic/457 from
fstests. When it happens it produces the following trace:

 BTRFS critical (device dm-0): corrupt leaf: root=18446744073709551610 block=30625792 slot=42, csum end range (15020032) goes beyond the start range (15015936) of the next csum item
 BTRFS info (device dm-0): leaf 30625792 gen 7 total ptrs 49 free space 2402 owner 18446744073709551610
 BTRFS info (device dm-0): refs 1 lock (w:0 r:0 bw:0 br:0 sw:0 sr:0) lock_owner 0 current 15884
      item 0 key (18446744073709551606 128 13979648) itemoff 3991 itemsize 4
      item 1 key (18446744073709551606 128 13983744) itemoff 3987 itemsize 4
      item 2 key (18446744073709551606 128 13987840) itemoff 3983 itemsize 4
      item 3 key (18446744073709551606 128 13991936) itemoff 3979 itemsize 4
      item 4 key (18446744073709551606 128 13996032) itemoff 3975 itemsize 4
      item 5 key (18446744073709551606 128 14000128) itemoff 3971 itemsize 4
 (...)
 BTRFS error (device dm-0): block=30625792 write time tree block corruption detected
 ------------[ cut here ]------------
 WARNING: CPU: 1 PID: 15884 at fs/btrfs/disk-io.c:539 btree_csum_one_bio+0x268/0x2d0 [btrfs]
 Modules linked in: btrfs dm_thin_pool ...
 CPU: 1 PID: 15884 Comm: fsx Tainted: G        W         5.6.0-rc7-btrfs-next-58 #1
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
 RIP: 0010:btree_csum_one_bio+0x268/0x2d0 [btrfs]
 Code: c7 c7 ...
 RSP: 0018:ffffbb0109e6f8e0 EFLAGS: 00010296
 RAX: 0000000000000000 RBX: ffffe1c0847b6080 RCX: 0000000000000000
 RDX: 0000000000000000 RSI: ffffffffaa963988 RDI: 0000000000000001
 RBP: ffff956a4f4d2000 R08: 0000000000000000 R09: 0000000000000001
 R10: 0000000000000526 R11: 0000000000000000 R12: ffff956a5cd28bb0
 R13: 0000000000000000 R14: ffff956a649c9388 R15: 000000011ed82000
 FS:  00007fb419959e80(0000) GS:ffff956a7aa00000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 0000000000fe6d54 CR3: 0000000138696005 CR4: 00000000003606e0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
 Call Trace:
  btree_submit_bio_hook+0x67/0xc0 [btrfs]
  submit_one_bio+0x31/0x50 [btrfs]
  btree_write_cache_pages+0x2db/0x4b0 [btrfs]
  ? __filemap_fdatawrite_range+0xb1/0x110
  do_writepages+0x23/0x80
  __filemap_fdatawrite_range+0xd2/0x110
  btrfs_write_marked_extents+0x15e/0x180 [btrfs]
  btrfs_sync_log+0x206/0x10a0 [btrfs]
  ? kmem_cache_free+0x315/0x3b0
  ? btrfs_log_inode+0x1e8/0xf90 [btrfs]
  ? __mutex_unlock_slowpath+0x45/0x2a0
  ? lockref_put_or_lock+0x9/0x30
  ? dput+0x2d/0x580
  ? dput+0xb5/0x580
  ? btrfs_sync_file+0x464/0x4d0 [btrfs]
  btrfs_sync_file+0x464/0x4d0 [btrfs]
  do_fsync+0x38/0x60
  __x64_sys_fsync+0x10/0x20
  do_syscall_64+0x5c/0x280
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
 RIP: 0033:0x7fb41953a6d0
 Code: 48 3d ...
 RSP: 002b:00007ffcc86bd218 EFLAGS: 00000246 ORIG_RAX: 000000000000004a
 RAX: ffffffffffffffda RBX: 000000000000000d RCX: 00007fb41953a6d0
 RDX: 0000000000000009 RSI: 0000000000040000 RDI: 0000000000000003
 RBP: 0000000000040000 R08: 0000000000000001 R09: 0000000000000009
 R10: 0000000000000064 R11: 0000000000000246 R12: 0000556cf4b2c060
 R13: 0000000000000100 R14: 0000000000000000 R15: 0000556cf322b420
 irq event stamp: 0
 hardirqs last  enabled at (0): [<0000000000000000>] 0x0
 hardirqs last disabled at (0): [<ffffffffa96bdedf>] copy_process+0x74f/0x2020
 softirqs last  enabled at (0): [<ffffffffa96bdedf>] copy_process+0x74f/0x2020
 softirqs last disabled at (0): [<0000000000000000>] 0x0
 ---[ end trace d543fc76f5ad7fd8 ]---

In that trace the tree checker detected the overlapping checksum items at
the time when we triggered writeback for the log tree when syncing the
log.

Another trace that can happen is due to BUG_ON() when deleting checksum
items while logging an inode:

 BTRFS critical (device dm-0): slot 81 key (18446744073709551606 128 13635584) new key (18446744073709551606 128 13635584)
 BTRFS info (device dm-0): leaf 30949376 gen 7 total ptrs 98 free space 8527 owner 18446744073709551610
 BTRFS info (device dm-0): refs 4 lock (w:1 r:0 bw:0 br:0 sw:1 sr:0) lock_owner 13473 current 13473
  item 0 key (257 1 0) itemoff 16123 itemsize 160
          inode generation 7 size 262144 mode 100600
  item 1 key (257 12 256) itemoff 16103 itemsize 20
  item 2 key (257 108 0) itemoff 16050 itemsize 53
          extent data disk bytenr 13631488 nr 4096
          extent data offset 0 nr 131072 ram 131072
 (...)
 ------------[ cut here ]------------
 kernel BUG at fs/btrfs/ctree.c:3153!
 invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC PTI
 CPU: 1 PID: 13473 Comm: fsx Not tainted 5.6.0-rc7-btrfs-next-58 #1
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
 RIP: 0010:btrfs_set_item_key_safe+0x1ea/0x270 [btrfs]
 Code: 0f b6 ...
 RSP: 0018:ffff95e3889179d0 EFLAGS: 00010282
 RAX: 0000000000000000 RBX: 0000000000000051 RCX: 0000000000000000
 RDX: 0000000000000000 RSI: ffffffffb7763988 RDI: 0000000000000001
 RBP: fffffffffffffff6 R08: 0000000000000000 R09: 0000000000000001
 R10: 00000000000009ef R11: 0000000000000000 R12: ffff8912a8ba5a08
 R13: ffff95e388917a06 R14: ffff89138dcf68c8 R15: ffff95e388917ace
 FS:  00007fe587084e80(0000) GS:ffff8913baa00000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 00007fe587091000 CR3: 0000000126dac005 CR4: 00000000003606e0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
 Call Trace:
  btrfs_del_csums+0x2f4/0x540 [btrfs]
  copy_items+0x4b5/0x560 [btrfs]
  btrfs_log_inode+0x910/0xf90 [btrfs]
  btrfs_log_inode_parent+0x2a0/0xe40 [btrfs]
  ? dget_parent+0x5/0x370
  btrfs_log_dentry_safe+0x4a/0x70 [btrfs]
  btrfs_sync_file+0x42b/0x4d0 [btrfs]
  __x64_sys_msync+0x199/0x200
  do_syscall_64+0x5c/0x280
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
 RIP: 0033:0x7fe586c65760
 Code: 00 f7 ...
 RSP: 002b:00007ffe250f98b8 EFLAGS: 00000246 ORIG_RAX: 000000000000001a
 RAX: ffffffffffffffda RBX: 00000000000040e1 RCX: 00007fe586c65760
 RDX: 0000000000000004 RSI: 0000000000006b51 RDI: 00007fe58708b000
 RBP: 0000000000006a70 R08: 0000000000000003 R09: 00007fe58700cb61
 R10: 0000000000000100 R11: 0000000000000246 R12: 00000000000000e1
 R13: 00007fe58708b000 R14: 0000000000006b51 R15: 0000558de021a420
 Modules linked in: dm_log_writes ...
 ---[ end trace c92a7f447a8515f5 ]---

CC: stable@vger.kernel.org # 4.4+
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 5afeb17a3f1a..30ce7039bc27 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1167,6 +1167,9 @@ struct btrfs_root {
 	/* Record pairs of swapped blocks for qgroup */
 	struct btrfs_qgroup_swapped_blocks swapped_blocks;
 
+	/* Used only by log trees, when logging csum items */
+	struct extent_io_tree log_csum_range;
+
 #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
 	u64 alloc_bytenr;
 #endif
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index f2f2864f5978..f8ec2d8606fd 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1133,9 +1133,12 @@ static void __setup_root(struct btrfs_root *root, struct btrfs_fs_info *fs_info,
 	root->log_transid = 0;
 	root->log_transid_committed = -1;
 	root->last_log_commit = 0;
-	if (!dummy)
+	if (!dummy) {
 		extent_io_tree_init(fs_info, &root->dirty_log_pages,
 				    IO_TREE_ROOT_DIRTY_LOG_PAGES, NULL);
+		extent_io_tree_init(fs_info, &root->log_csum_range,
+				    IO_TREE_LOG_CSUM_RANGE, NULL);
+	}
 
 	memset(&root->root_key, 0, sizeof(root->root_key));
 	memset(&root->root_item, 0, sizeof(root->root_item));
diff --git a/fs/btrfs/extent-io-tree.h b/fs/btrfs/extent-io-tree.h
index b4a7bad3e82e..b6561455b3c4 100644
--- a/fs/btrfs/extent-io-tree.h
+++ b/fs/btrfs/extent-io-tree.h
@@ -44,6 +44,7 @@ enum {
 	IO_TREE_TRANS_DIRTY_PAGES,
 	IO_TREE_ROOT_DIRTY_LOG_PAGES,
 	IO_TREE_INODE_FILE_EXTENT,
+	IO_TREE_LOG_CSUM_RANGE,
 	IO_TREE_SELFTEST,
 };
 
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 67fa7087f707..920cee312f4e 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3290,6 +3290,7 @@ static void free_log_tree(struct btrfs_trans_handle *trans,
 
 	clear_extent_bits(&log->dirty_log_pages, 0, (u64)-1,
 			  EXTENT_DIRTY | EXTENT_NEW | EXTENT_NEED_WAIT);
+	extent_io_tree_release(&log->log_csum_range);
 	btrfs_put_root(log);
 }
 
@@ -3903,8 +3904,20 @@ static int log_csums(struct btrfs_trans_handle *trans,
 		     struct btrfs_root *log_root,
 		     struct btrfs_ordered_sum *sums)
 {
+	const u64 lock_end = sums->bytenr + sums->len - 1;
+	struct extent_state *cached_state = NULL;
 	int ret;
 
+	/*
+	 * Serialize logging for checksums. This is to avoid racing with the
+	 * same checksum being logged by another task that is logging another
+	 * file which happens to refer to the same extent as well. Such races
+	 * can leave checksum items in the log with overlapping ranges.
+	 */
+	ret = lock_extent_bits(&log_root->log_csum_range, sums->bytenr,
+			       lock_end, &cached_state);
+	if (ret)
+		return ret;
 	/*
 	 * Due to extent cloning, we might have logged a csum item that covers a
 	 * subrange of a cloned extent, and later we can end up logging a csum
@@ -3915,10 +3928,13 @@ static int log_csums(struct btrfs_trans_handle *trans,
 	 * trim and adjust) any existing csum items in the log for this range.
 	 */
 	ret = btrfs_del_csums(trans, log_root, sums->bytenr, sums->len);
-	if (ret)
-		return ret;
+	if (!ret)
+		ret = btrfs_csum_file_blocks(trans, log_root, sums);
 
-	return btrfs_csum_file_blocks(trans, log_root, sums);
+	unlock_extent_cached(&log_root->log_csum_range, sums->bytenr, lock_end,
+			     &cached_state);
+
+	return ret;
 }
 
 static noinline int copy_items(struct btrfs_trans_handle *trans,
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index bcbc763b8814..360b0f9d2220 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -89,6 +89,7 @@ TRACE_DEFINE_ENUM(COMMIT_TRANS);
 		{ IO_TREE_TRANS_DIRTY_PAGES,	  "TRANS_DIRTY_PAGES" },       \
 		{ IO_TREE_ROOT_DIRTY_LOG_PAGES,	  "ROOT_DIRTY_LOG_PAGES" },    \
 		{ IO_TREE_INODE_FILE_EXTENT,	  "INODE_FILE_EXTENT" },       \
+		{ IO_TREE_LOG_CSUM_RANGE,	  "LOG_CSUM_RANGE" },          \
 		{ IO_TREE_SELFTEST,		  "SELFTEST" })
 
 #define BTRFS_GROUP_FLAGS	\

