Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E39639081
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 17:52:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730266AbfFGPwb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 11:52:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:35014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729840AbfFGPtO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Jun 2019 11:49:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 904B721479;
        Fri,  7 Jun 2019 15:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559922554;
        bh=NfX41XI9Es+4ZE21iYxnILt4QktB0am3Y2wMaYW7D6I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gynZx0ggFtxJvUSIxVhzPxDtB4M3De5WkVOCuhOjqLvcjDpuvezIPSvtz92RNgN9A
         s/19sTTX0Iw+TEYr7cuc3pEJhZhcnRlfQFfeHBrkdFKvBIrofSQBqjfUzhrihGTvZ6
         /6Rs2SQwRmgiSfO1dCn63kTdll4pOOBQbVkyANGY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.1 27/85] btrfs: reloc: Also queue orphan reloc tree for cleanup to avoid BUG_ON()
Date:   Fri,  7 Jun 2019 17:39:12 +0200
Message-Id: <20190607153852.619151834@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190607153849.101321647@linuxfoundation.org>
References: <20190607153849.101321647@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

commit 30d40577e322b670551ad7e2faa9570b6e23eb2b upstream.

[BUG]
When a fs has orphan reloc tree along with unfinished balance:
  ...
        item 16 key (TREE_RELOC ROOT_ITEM FS_TREE) itemoff 12090 itemsize 439
                generation 12 root_dirid 256 bytenr 300400640 level 1 refs 0 <<<
                lastsnap 8 byte_limit 0 bytes_used 1359872 flags 0x0(none)
                uuid 7c48d938-33a3-4aae-ab19-6e5c9d406e46
        item 17 key (BALANCE TEMPORARY_ITEM 0) itemoff 11642 itemsize 448
                temporary item objectid BALANCE offset 0
                balance status flags 14

Then at mount time, we can hit the following kernel BUG_ON():
  BTRFS info (device dm-3): relocating block group 298844160 flags metadata|dup
  ------------[ cut here ]------------
  kernel BUG at fs/btrfs/relocation.c:1413!
  invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
  CPU: 1 PID: 897 Comm: btrfs-balance Tainted: G           O      5.2.0-rc1-custom #15
  RIP: 0010:create_reloc_root+0x1eb/0x200 [btrfs]
  Call Trace:
   btrfs_init_reloc_root+0x96/0xb0 [btrfs]
   record_root_in_trans+0xb2/0xe0 [btrfs]
   btrfs_record_root_in_trans+0x55/0x70 [btrfs]
   select_reloc_root+0x7e/0x230 [btrfs]
   do_relocation+0xc4/0x620 [btrfs]
   relocate_tree_blocks+0x592/0x6a0 [btrfs]
   relocate_block_group+0x47b/0x5d0 [btrfs]
   btrfs_relocate_block_group+0x183/0x2f0 [btrfs]
   btrfs_relocate_chunk+0x4e/0xe0 [btrfs]
   btrfs_balance+0x864/0xfa0 [btrfs]
   balance_kthread+0x3b/0x50 [btrfs]
   kthread+0x123/0x140
   ret_from_fork+0x27/0x50

[CAUSE]
In btrfs, reloc trees are used to record swapped tree blocks during
balance.
Reloc tree either get merged (replace old tree blocks of its parent
subvolume) in next transaction if its ref is 1 (fresh).
Or is already merged and will be cleaned up if its ref is 0 (orphan).

After commit d2311e698578 ("btrfs: relocation: Delay reloc tree deletion
after merge_reloc_roots"), reloc tree cleanup is delayed until one block
group is balanced.

Since fresh reloc roots are recorded during merge, as long as there
is no power loss, those orphan reloc roots converted from fresh ones are
handled without problem.

However when power loss happens, orphan reloc roots can be recorded
on-disk, thus at next mount time, we will have orphan reloc roots from
on-disk data directly, and ignored by clean_dirty_subvols() routine.

Then when background balance starts to balance another block group, and
needs to create new reloc root for the same root, btrfs_insert_item()
returns -EEXIST, and trigger that BUG_ON().

[FIX]
For orphan reloc roots, also queue them to rc->dirty_subvol_roots, so
all reloc roots no matter orphan or not, can be cleaned up properly and
avoid above BUG_ON().

And to cooperate with above change, clean_dirty_subvols() will check if
the queued root is a reloc root or a subvol root.
For a subvol root, do the old work, and for a orphan reloc root, clean it
up.

Fixes: d2311e698578 ("btrfs: relocation: Delay reloc tree deletion after merge_reloc_roots")
CC: stable@vger.kernel.org # 5.1
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/relocation.c |   31 +++++++++++++++++++++----------
 1 file changed, 21 insertions(+), 10 deletions(-)

--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -2161,22 +2161,30 @@ static int clean_dirty_subvols(struct re
 	struct btrfs_root *root;
 	struct btrfs_root *next;
 	int ret = 0;
+	int ret2;
 
 	list_for_each_entry_safe(root, next, &rc->dirty_subvol_roots,
 				 reloc_dirty_list) {
-		struct btrfs_root *reloc_root = root->reloc_root;
-
-		clear_bit(BTRFS_ROOT_DEAD_RELOC_TREE, &root->state);
-		list_del_init(&root->reloc_dirty_list);
-		root->reloc_root = NULL;
-		if (reloc_root) {
-			int ret2;
-
-			ret2 = btrfs_drop_snapshot(reloc_root, NULL, 0, 1);
+		if (root->root_key.objectid != BTRFS_TREE_RELOC_OBJECTID) {
+			/* Merged subvolume, cleanup its reloc root */
+			struct btrfs_root *reloc_root = root->reloc_root;
+
+			clear_bit(BTRFS_ROOT_DEAD_RELOC_TREE, &root->state);
+			list_del_init(&root->reloc_dirty_list);
+			root->reloc_root = NULL;
+			if (reloc_root) {
+
+				ret2 = btrfs_drop_snapshot(reloc_root, NULL, 0, 1);
+				if (ret2 < 0 && !ret)
+					ret = ret2;
+			}
+			btrfs_put_fs_root(root);
+		} else {
+			/* Orphan reloc tree, just clean it up */
+			ret2 = btrfs_drop_snapshot(root, NULL, 0, 1);
 			if (ret2 < 0 && !ret)
 				ret = ret2;
 		}
-		btrfs_put_fs_root(root);
 	}
 	return ret;
 }
@@ -2464,6 +2472,9 @@ again:
 			}
 		} else {
 			list_del_init(&reloc_root->root_list);
+			/* Don't forget to queue this reloc root for cleanup */
+			list_add_tail(&reloc_root->reloc_dirty_list,
+				      &rc->dirty_subvol_roots);
 		}
 	}
 


