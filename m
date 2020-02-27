Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58F31171C4B
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:10:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388161AbgB0OKv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:10:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:49108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388606AbgB0OKv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:10:51 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 24CEA20578;
        Thu, 27 Feb 2020 14:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812650;
        bh=4Ha7FMeopvq5rImbybGAUymlfZTN71ObR/RK0QDYoZ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ybt6upbornCMS1O8vdFEb2udIIaTLOCsYT1IBNo4EIS8hxdO82R8ftJ9dWEPjOYV5
         pY9c25SKydAqTp0B3ey/pvka7wk+V/LEcvmAj+sgBLwJdPaY7wHSvgHjYdkKMbp1Hi
         pvKAx4iBAV1uYpP2y208aGbvCnsE5Egz6A1ppTrQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Jones <davej@codemonkey.org.uk>,
        Filipe Manana <fdmanana@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.4 098/135] btrfs: dont set path->leave_spinning for truncate
Date:   Thu, 27 Feb 2020 14:37:18 +0100
Message-Id: <20200227132243.962862242@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132228.710492098@linuxfoundation.org>
References: <20200227132228.710492098@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

commit 52e29e331070cd7d52a64cbf1b0958212a340e28 upstream.

The only time we actually leave the path spinning is if we're truncating
a small amount and don't actually free an extent, which is not a common
occurrence.  We have to set the path blocking in order to add the
delayed ref anyway, so the first extent we find we set the path to
blocking and stay blocking for the duration of the operation.  With the
upcoming file extent map stuff there will be another case that we have
to have the path blocking, so just swap to blocking always.

Note: this patch also fixes a warning after 28553fa992cb ("Btrfs: fix
race between shrinking truncate and fiemap") got merged that inserts
extent locks around truncation so the path must not leave spinning locks
after btrfs_search_slot.

  [70.794783] BUG: sleeping function called from invalid context at mm/slab.h:565
  [70.794834] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 1141, name: rsync
  [70.794863] 5 locks held by rsync/1141:
  [70.794876]  #0: ffff888417b9c408 (sb_writers#17){.+.+}, at: mnt_want_write+0x20/0x50
  [70.795030]  #1: ffff888428de28e8 (&type->i_mutex_dir_key#13/1){+.+.}, at: lock_rename+0xf1/0x100
  [70.795051]  #2: ffff888417b9c608 (sb_internal#2){.+.+}, at: start_transaction+0x394/0x560
  [70.795124]  #3: ffff888403081768 (btrfs-fs-01){++++}, at: btrfs_try_tree_write_lock+0x2f/0x160
  [70.795203]  #4: ffff888403086568 (btrfs-fs-00){++++}, at: btrfs_try_tree_write_lock+0x2f/0x160
  [70.795222] CPU: 5 PID: 1141 Comm: rsync Not tainted 5.6.0-rc2-backup+ #2
  [70.795362] Call Trace:
  [70.795374]  dump_stack+0x71/0xa0
  [70.795445]  ___might_sleep.part.96.cold.106+0xa6/0xb6
  [70.795459]  kmem_cache_alloc+0x1d3/0x290
  [70.795471]  alloc_extent_state+0x22/0x1c0
  [70.795544]  __clear_extent_bit+0x3ba/0x580
  [70.795557]  ? _raw_spin_unlock_irq+0x24/0x30
  [70.795569]  btrfs_truncate_inode_items+0x339/0xe50
  [70.795647]  btrfs_evict_inode+0x269/0x540
  [70.795659]  ? dput.part.38+0x29/0x460
  [70.795671]  evict+0xcd/0x190
  [70.795682]  __dentry_kill+0xd6/0x180
  [70.795754]  dput.part.38+0x2ad/0x460
  [70.795765]  do_renameat2+0x3cb/0x540
  [70.795777]  __x64_sys_rename+0x1c/0x20

Reported-by: Dave Jones <davej@codemonkey.org.uk>
Fixes: 28553fa992cb ("Btrfs: fix race between shrinking truncate and fiemap")
CC: stable@vger.kernel.org # 4.4+
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
[ add note ]
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/inode.c |    2 --
 1 file changed, 2 deletions(-)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4791,7 +4791,6 @@ search_again:
 		goto out;
 	}
 
-	path->leave_spinning = 1;
 	ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
 	if (ret < 0)
 		goto out;
@@ -4943,7 +4942,6 @@ delete:
 		     root == fs_info->tree_root)) {
 			struct btrfs_ref ref = { 0 };
 
-			btrfs_set_path_blocking(path);
 			bytes_deleted += extent_num_bytes;
 
 			btrfs_init_generic_ref(&ref, BTRFS_DROP_DELAYED_REF,


