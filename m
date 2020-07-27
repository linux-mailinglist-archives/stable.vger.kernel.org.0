Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B392E22EF26
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:14:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730433AbgG0ONw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:13:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:39002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730425AbgG0ONu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:13:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9FC9E2073E;
        Mon, 27 Jul 2020 14:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859229;
        bh=pZ9p5vYRMnQqpRbmmkgXAAt2K9yoZbNpms4wRamUaqY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oVDYxOHcPK+aEhyECOZ22AMDIPHbAWvNYL153NsZQAegWq+pabf2ZruQKu+GvDprT
         HAAZoCbcGFNrGrOrmosHjvexnAmoV+8xYuEQY8N1LRs82ESl4l+3xKK5PFXpz4Fwu8
         zD1NLHTH1S8nmoUw6XbtsgSgkaxFNMqVdhM6V3Zc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>
Subject: [PATCH 5.4 027/138] btrfs: reloc: fix reloc root leak and NULL pointer dereference
Date:   Mon, 27 Jul 2020 16:03:42 +0200
Message-Id: <20200727134926.726501281@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134925.228313570@linuxfoundation.org>
References: <20200727134925.228313570@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

commit 51415b6c1b117e223bc083e30af675cb5c5498f3 upstream.

[BUG]
When balance is canceled, there is a pretty high chance that unmounting
the fs can lead to lead the NULL pointer dereference:

  BTRFS warning (device dm-3): page private not zero on page 223158272
  ...
  BTRFS warning (device dm-3): page private not zero on page 223162368
  BTRFS error (device dm-3): leaked root 18446744073709551608-304 refcount 1
  BUG: kernel NULL pointer dereference, address: 0000000000000168
  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page
  PGD 0 P4D 0
  Oops: 0000 [#1] PREEMPT SMP NOPTI
  CPU: 2 PID: 5793 Comm: umount Tainted: G           O      5.7.0-rc5-custom+ #53
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
  RIP: 0010:__lock_acquire+0x5dc/0x24c0
  Call Trace:
   lock_acquire+0xab/0x390
   _raw_spin_lock+0x39/0x80
   btrfs_release_extent_buffer_pages+0xd7/0x200 [btrfs]
   release_extent_buffer+0xb2/0x170 [btrfs]
   free_extent_buffer+0x66/0xb0 [btrfs]
   btrfs_put_root+0x8e/0x130 [btrfs]
   btrfs_check_leaked_roots.cold+0x5/0x5d [btrfs]
   btrfs_free_fs_info+0xe5/0x120 [btrfs]
   btrfs_kill_super+0x1f/0x30 [btrfs]
   deactivate_locked_super+0x3b/0x80
   deactivate_super+0x3e/0x50
   cleanup_mnt+0x109/0x160
   __cleanup_mnt+0x12/0x20
   task_work_run+0x67/0xa0
   exit_to_usermode_loop+0xc5/0xd0
   syscall_return_slowpath+0x205/0x360
   do_syscall_64+0x6e/0xb0
   entry_SYSCALL_64_after_hwframe+0x49/0xb3
  RIP: 0033:0x7fd028ef740b

[CAUSE]
When balance is canceled, all reloc roots are marked as orphan, and
orphan reloc roots are going to be cleaned up.

However for orphan reloc roots and merged reloc roots, their lifespan
are quite different:

	Merged reloc roots	|	Orphan reloc roots by cancel
--------------------------------------------------------------------
create_reloc_root()		| create_reloc_root()
|- refs == 1			| |- refs == 1
				|
btrfs_grab_root(reloc_root);	| btrfs_grab_root(reloc_root);
|- refs == 2			| |- refs == 2
				|
root->reloc_root = reloc_root;	| root->reloc_root = reloc_root;
		>>> No difference so far <<<
				|
prepare_to_merge()		| prepare_to_merge()
|- btrfs_set_root_refs(item, 1);| |- if (!err) (err == -EINTR)
				|
merge_reloc_roots()		| merge_reloc_roots()
|- merge_reloc_root()		| |- Doing nothing to put reloc root
   |- insert_dirty_subvol()	| |- refs == 2
      |- __del_reloc_root()	|
         |- btrfs_put_root()	|
            |- refs == 1	|
		>>> Now orphan reloc roots still have refs 2 <<<
				|
clean_dirty_subvols()		| clean_dirty_subvols()
|- btrfs_drop_snapshot()	| |- btrfS_drop_snapshot()
   |- reloc_root get freed	|    |- reloc_root still has refs 2
				|	related ebs get freed, but
				|	reloc_root still recorded in
				|	allocated_roots
btrfs_check_leaked_roots()	| btrfs_check_leaked_roots()
|- No leaked roots		| |- Leaked reloc_roots detected
				| |- btrfs_put_root()
				|    |- free_extent_buffer(root->node);
				|       |- eb already freed, caused NULL
				|	   pointer dereference

[FIX]
The fix is to clear fs_root->reloc_root and put it at
merge_reloc_roots() time, so that we won't leak reloc roots.

Fixes: d2311e698578 ("btrfs: relocation: Delay reloc tree deletion after merge_reloc_roots")
CC: stable@vger.kernel.org # 5.1+
Tested-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
[Manually solve the conflicts due to no btrfs root refs rework]
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/relocation.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -2525,12 +2525,10 @@ again:
 		reloc_root = list_entry(reloc_roots.next,
 					struct btrfs_root, root_list);
 
+		root = read_fs_root(fs_info, reloc_root->root_key.offset);
 		if (btrfs_root_refs(&reloc_root->root_item) > 0) {
-			root = read_fs_root(fs_info,
-					    reloc_root->root_key.offset);
 			BUG_ON(IS_ERR(root));
 			BUG_ON(root->reloc_root != reloc_root);
-
 			ret = merge_reloc_root(rc, root);
 			if (ret) {
 				if (list_empty(&reloc_root->root_list))
@@ -2539,6 +2537,11 @@ again:
 				goto out;
 			}
 		} else {
+			if (!IS_ERR(root)) {
+				if (root->reloc_root == reloc_root)
+					root->reloc_root = NULL;
+			}
+
 			list_del_init(&reloc_root->root_list);
 			/* Don't forget to queue this reloc root for cleanup */
 			list_add_tail(&reloc_root->reloc_dirty_list,


