Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81B1C21FB75
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 21:02:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730780AbgGNS7I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 14:59:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:57586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731067AbgGNS7C (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:59:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93ACE229CA;
        Tue, 14 Jul 2020 18:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594753142;
        bh=/SwL4lhyb9H479yrYfVEdAQXaqBeWOFBvjRzYCTP14M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NYPk0qNhqoNvX2WHbor0HWuhyARbH8n5oGNT8GcV1RL661+k+GKTyEMzApIN44oXA
         pDm3GbozZbUZJpymm65mSXTvJi+jltUu2myfQ2r1OniGuWOkATcseGbKD0zpYC9roO
         63TZRCl+Jjf0xvVnbcqR5tpciPkd+Q9lBfsb1zpY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marcos Paulo de Souza <mpdesouza@suse.com>,
        Anand Jain <anand.jain@oracle.com>, Qu Wenruo <wqu@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.7 136/166] btrfs: discard: add missing put when grabbing block group from unused list
Date:   Tue, 14 Jul 2020 20:45:01 +0200
Message-Id: <20200714184122.344961940@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184115.844176932@linuxfoundation.org>
References: <20200714184115.844176932@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

commit 04e484c5973ed0f9234c97685c3c5e1ebf0d6eb6 upstream.

[BUG]
The following small test script can trigger ASSERT() at unmount time:

  mkfs.btrfs -f $dev
  mount $dev $mnt
  mount -o remount,discard=async $mnt
  umount $mnt

The call trace:
  assertion failed: atomic_read(&block_group->count) == 1, in fs/btrfs/block-group.c:3431
  ------------[ cut here ]------------
  kernel BUG at fs/btrfs/ctree.h:3204!
  invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
  CPU: 4 PID: 10389 Comm: umount Tainted: G           O      5.8.0-rc3-custom+ #68
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
  Call Trace:
   btrfs_free_block_groups.cold+0x22/0x55 [btrfs]
   close_ctree+0x2cb/0x323 [btrfs]
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

The code:
                ASSERT(atomic_read(&block_group->count) == 1);
                btrfs_put_block_group(block_group);

[CAUSE]
Obviously it's some btrfs_get_block_group() call doesn't get its put
call.

The offending btrfs_get_block_group() happens here:

  void btrfs_mark_bg_unused(struct btrfs_block_group *bg)
  {
  	if (list_empty(&bg->bg_list)) {
  		btrfs_get_block_group(bg);
		list_add_tail(&bg->bg_list, &fs_info->unused_bgs);
  	}
  }

So every call sites removing the block group from unused_bgs list should
reduce the ref count of that block group.

However for async discard, it didn't follow the call convention:

  void btrfs_discard_punt_unused_bgs_list(struct btrfs_fs_info *fs_info)
  {
  	list_for_each_entry_safe(block_group, next, &fs_info->unused_bgs,
  				 bg_list) {
  		list_del_init(&block_group->bg_list);
  		btrfs_discard_queue_work(&fs_info->discard_ctl, block_group);
  	}
  }

And in btrfs_discard_queue_work(), it doesn't call
btrfs_put_block_group() either.

[FIX]
Fix the problem by reducing the reference count when we grab the block
group from unused_bgs list.

Reported-by: Marcos Paulo de Souza <mpdesouza@suse.com>
Fixes: 6e80d4f8c422 ("btrfs: handle empty block_group removal for async discard")
CC: stable@vger.kernel.org # 5.6+
Tested-by: Marcos Paulo de Souza <mpdesouza@suse.com>
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/discard.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/btrfs/discard.c
+++ b/fs/btrfs/discard.c
@@ -619,6 +619,7 @@ void btrfs_discard_punt_unused_bgs_list(
 	list_for_each_entry_safe(block_group, next, &fs_info->unused_bgs,
 				 bg_list) {
 		list_del_init(&block_group->bg_list);
+		btrfs_put_block_group(block_group);
 		btrfs_discard_queue_work(&fs_info->discard_ctl, block_group);
 	}
 	spin_unlock(&fs_info->unused_bgs_lock);


