Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 735C723566
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:44:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391020AbfETMe5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:34:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:52700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390429AbfETMe5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:34:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2989920645;
        Mon, 20 May 2019 12:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355696;
        bh=es8lMOwirZXOqgXARB7EySiRYY3aTh7cJ0AXeydOw6Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1LDsPZl40TPz9Q1c9Vbyy9WBipt6liSaNrmtVrI9sjJzvLsr+9WZXODXsj29W7I6K
         YggAh2xMuwqli1E9v1sqnnnHfgS2ynPqmoAcFbHaGElnRX16UA/j/zVQ3eBi1BROT4
         HzB43mvFr02/l05315MV67X1oBFjDgJ9xEVx71pU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yoon Jungyeon <jungyeon@gatech.edu>,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>
Subject: [PATCH 5.1 092/128] btrfs: Check the first key and level for cached extent buffer
Date:   Mon, 20 May 2019 14:14:39 +0200
Message-Id: <20190520115255.555608426@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115249.449077487@linuxfoundation.org>
References: <20190520115249.449077487@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

commit 448de471cd4cab0cedd15770082567a69a784a11 upstream.

[BUG]
When reading a file from a fuzzed image, kernel can panic like:

  BTRFS warning (device loop0): csum failed root 5 ino 270 off 0 csum 0x98f94189 expected csum 0x00000000 mirror 1
  assertion failed: !memcmp_extent_buffer(b, &disk_key, offsetof(struct btrfs_leaf, items[0].key), sizeof(disk_key)), file: fs/btrfs/ctree.c, line: 2544
  ------------[ cut here ]------------
  kernel BUG at fs/btrfs/ctree.h:3500!
  invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
  RIP: 0010:btrfs_search_slot.cold.24+0x61/0x63 [btrfs]
  Call Trace:
   btrfs_lookup_csum+0x52/0x150 [btrfs]
   __btrfs_lookup_bio_sums+0x209/0x640 [btrfs]
   btrfs_submit_bio_hook+0x103/0x170 [btrfs]
   submit_one_bio+0x59/0x80 [btrfs]
   extent_read_full_page+0x58/0x80 [btrfs]
   generic_file_read_iter+0x2f6/0x9d0
   __vfs_read+0x14d/0x1a0
   vfs_read+0x8d/0x140
   ksys_read+0x52/0xc0
   do_syscall_64+0x60/0x210
   entry_SYSCALL_64_after_hwframe+0x49/0xbe

[CAUSE]
The fuzzed image has a corrupted leaf whose first key doesn't match its
parent:

  checksum tree key (CSUM_TREE ROOT_ITEM 0)
  node 29741056 level 1 items 14 free 107 generation 19 owner CSUM_TREE
  fs uuid 3381d111-94a3-4ac7-8f39-611bbbdab7e6
  chunk uuid 9af1c3c7-2af5-488b-8553-530bd515f14c
  	...
          key (EXTENT_CSUM EXTENT_CSUM 79691776) block 29761536 gen 19

  leaf 29761536 items 1 free space 1726 generation 19 owner CSUM_TREE
  leaf 29761536 flags 0x1(WRITTEN) backref revision 1
  fs uuid 3381d111-94a3-4ac7-8f39-611bbbdab7e6
  chunk uuid 9af1c3c7-2af5-488b-8553-530bd515f14c
          item 0 key (EXTENT_CSUM EXTENT_CSUM 8798638964736) itemoff 1751 itemsize 2244
                  range start 8798638964736 end 8798641262592 length 2297856

When reading the above tree block, we have extent_buffer->refs = 2 in
the context:

- initial one from __alloc_extent_buffer()
  alloc_extent_buffer()
  |- __alloc_extent_buffer()
     |- atomic_set(&eb->refs, 1)

- one being added to fs_info->buffer_radix
  alloc_extent_buffer()
  |- check_buffer_tree_ref()
     |- atomic_inc(&eb->refs)

So if even we call free_extent_buffer() in read_tree_block or other
similar situation, we only decrease the refs by 1, it doesn't reach 0
and won't be freed right now.

The staled eb and its corrupted content will still be kept cached.

Furthermore, we have several extra cases where we either don't do first
key check or the check is not proper for all callers:

- scrub
  We just don't have first key in this context.

- shared tree block
  One tree block can be shared by several snapshot/subvolume trees.
  In that case, the first key check for one subvolume doesn't apply to
  another.

So for the above reasons, a corrupted extent buffer can sneak into the
buffer cache.

[FIX]
Call verify_level_key in read_block_for_search to do another
verification. For that purpose the function is exported.

Due to above reasons, although we can free corrupted extent buffer from
cache, we still need the check in read_block_for_search(), for scrub and
shared tree blocks.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=202755
Link: https://bugzilla.kernel.org/show_bug.cgi?id=202757
Link: https://bugzilla.kernel.org/show_bug.cgi?id=202759
Link: https://bugzilla.kernel.org/show_bug.cgi?id=202761
Link: https://bugzilla.kernel.org/show_bug.cgi?id=202767
Link: https://bugzilla.kernel.org/show_bug.cgi?id=202769
Reported-by: Yoon Jungyeon <jungyeon@gatech.edu>
CC: stable@vger.kernel.org # 4.19+
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/ctree.c   |   10 ++++++++++
 fs/btrfs/disk-io.c |   10 +++++-----
 fs/btrfs/disk-io.h |    3 +++
 3 files changed, 18 insertions(+), 5 deletions(-)

--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -2416,6 +2416,16 @@ read_block_for_search(struct btrfs_root
 	if (tmp) {
 		/* first we do an atomic uptodate check */
 		if (btrfs_buffer_uptodate(tmp, gen, 1) > 0) {
+			/*
+			 * Do extra check for first_key, eb can be stale due to
+			 * being cached, read from scrub, or have multiple
+			 * parents (shared tree blocks).
+			 */
+			if (btrfs_verify_level_key(fs_info, tmp,
+					parent_level - 1, &first_key, gen)) {
+				free_extent_buffer(tmp);
+				return -EUCLEAN;
+			}
 			*eb_ret = tmp;
 			return 0;
 		}
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -414,9 +414,9 @@ static int btrfs_check_super_csum(struct
 	return ret;
 }
 
-static int verify_level_key(struct btrfs_fs_info *fs_info,
-			    struct extent_buffer *eb, int level,
-			    struct btrfs_key *first_key, u64 parent_transid)
+int btrfs_verify_level_key(struct btrfs_fs_info *fs_info,
+			   struct extent_buffer *eb, int level,
+			   struct btrfs_key *first_key, u64 parent_transid)
 {
 	int found_level;
 	struct btrfs_key found_key;
@@ -493,8 +493,8 @@ static int btree_read_extent_buffer_page
 			if (verify_parent_transid(io_tree, eb,
 						   parent_transid, 0))
 				ret = -EIO;
-			else if (verify_level_key(fs_info, eb, level,
-						  first_key, parent_transid))
+			else if (btrfs_verify_level_key(fs_info, eb, level,
+						first_key, parent_transid))
 				ret = -EUCLEAN;
 			else
 				break;
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -39,6 +39,9 @@ static inline u64 btrfs_sb_offset(int mi
 struct btrfs_device;
 struct btrfs_fs_devices;
 
+int btrfs_verify_level_key(struct btrfs_fs_info *fs_info,
+			   struct extent_buffer *eb, int level,
+			   struct btrfs_key *first_key, u64 parent_transid);
 struct extent_buffer *read_tree_block(struct btrfs_fs_info *fs_info, u64 bytenr,
 				      u64 parent_transid, int level,
 				      struct btrfs_key *first_key);


