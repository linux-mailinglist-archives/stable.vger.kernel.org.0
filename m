Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25BA1261A79
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 20:36:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731736AbgIHSgG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 14:36:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:53450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731351AbgIHQJN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:09:13 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A49A224171;
        Tue,  8 Sep 2020 15:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599580160;
        bh=8zvpcl6toyUsWQBCfpbR+A65ytO5PdnPF2ek3AtYh+g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W9n15n7qymnBxDNi9369KAsGIZzBf+L8W7RVf0BUi4wwwwfnhUHDGHY74Ds3LXVDS
         c2uKWChjTSe3xU44htN/nu5luidHjMr1sN9aIZxgM1IkMPPAFoGL4w/zT9yQmnfC7r
         AiPNjsfPLHThLqKa/qO4ZYZIjbRkmitmrhwKSwp8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 4.19 54/88] btrfs: drop path before adding new uuid tree entry
Date:   Tue,  8 Sep 2020 17:25:55 +0200
Message-Id: <20200908152223.825528369@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152221.082184905@linuxfoundation.org>
References: <20200908152221.082184905@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

commit 9771a5cf937129307d9f58922d60484d58ababe7 upstream.

With the conversion of the tree locks to rwsem I got the following
lockdep splat:

  ======================================================
  WARNING: possible circular locking dependency detected
  5.8.0-rc7-00167-g0d7ba0c5b375-dirty #925 Not tainted
  ------------------------------------------------------
  btrfs-uuid/7955 is trying to acquire lock:
  ffff88bfbafec0f8 (btrfs-root-00){++++}-{3:3}, at: __btrfs_tree_read_lock+0x39/0x180

  but task is already holding lock:
  ffff88bfbafef2a8 (btrfs-uuid-00){++++}-{3:3}, at: __btrfs_tree_read_lock+0x39/0x180

  which lock already depends on the new lock.

  the existing dependency chain (in reverse order) is:

  -> #1 (btrfs-uuid-00){++++}-{3:3}:
	 down_read_nested+0x3e/0x140
	 __btrfs_tree_read_lock+0x39/0x180
	 __btrfs_read_lock_root_node+0x3a/0x50
	 btrfs_search_slot+0x4bd/0x990
	 btrfs_uuid_tree_add+0x89/0x2d0
	 btrfs_uuid_scan_kthread+0x330/0x390
	 kthread+0x133/0x150
	 ret_from_fork+0x1f/0x30

  -> #0 (btrfs-root-00){++++}-{3:3}:
	 __lock_acquire+0x1272/0x2310
	 lock_acquire+0x9e/0x360
	 down_read_nested+0x3e/0x140
	 __btrfs_tree_read_lock+0x39/0x180
	 __btrfs_read_lock_root_node+0x3a/0x50
	 btrfs_search_slot+0x4bd/0x990
	 btrfs_find_root+0x45/0x1b0
	 btrfs_read_tree_root+0x61/0x100
	 btrfs_get_root_ref.part.50+0x143/0x630
	 btrfs_uuid_tree_iterate+0x207/0x314
	 btrfs_uuid_rescan_kthread+0x12/0x50
	 kthread+0x133/0x150
	 ret_from_fork+0x1f/0x30

  other info that might help us debug this:

   Possible unsafe locking scenario:

	 CPU0                    CPU1
	 ----                    ----
    lock(btrfs-uuid-00);
				 lock(btrfs-root-00);
				 lock(btrfs-uuid-00);
    lock(btrfs-root-00);

   *** DEADLOCK ***

  1 lock held by btrfs-uuid/7955:
   #0: ffff88bfbafef2a8 (btrfs-uuid-00){++++}-{3:3}, at: __btrfs_tree_read_lock+0x39/0x180

  stack backtrace:
  CPU: 73 PID: 7955 Comm: btrfs-uuid Kdump: loaded Not tainted 5.8.0-rc7-00167-g0d7ba0c5b375-dirty #925
  Hardware name: Quanta Tioga Pass Single Side 01-0030993006/Tioga Pass Single Side, BIOS F08_3A18 12/20/2018
  Call Trace:
   dump_stack+0x78/0xa0
   check_noncircular+0x165/0x180
   __lock_acquire+0x1272/0x2310
   lock_acquire+0x9e/0x360
   ? __btrfs_tree_read_lock+0x39/0x180
   ? btrfs_root_node+0x1c/0x1d0
   down_read_nested+0x3e/0x140
   ? __btrfs_tree_read_lock+0x39/0x180
   __btrfs_tree_read_lock+0x39/0x180
   __btrfs_read_lock_root_node+0x3a/0x50
   btrfs_search_slot+0x4bd/0x990
   btrfs_find_root+0x45/0x1b0
   btrfs_read_tree_root+0x61/0x100
   btrfs_get_root_ref.part.50+0x143/0x630
   btrfs_uuid_tree_iterate+0x207/0x314
   ? btree_readpage+0x20/0x20
   btrfs_uuid_rescan_kthread+0x12/0x50
   kthread+0x133/0x150
   ? kthread_create_on_node+0x60/0x60
   ret_from_fork+0x1f/0x30

This problem exists because we have two different rescan threads,
btrfs_uuid_scan_kthread which creates the uuid tree, and
btrfs_uuid_tree_iterate that goes through and updates or deletes any out
of date roots.  The problem is they both do things in different order.
btrfs_uuid_scan_kthread() reads the tree_root, and then inserts entries
into the uuid_root.  btrfs_uuid_tree_iterate() scans the uuid_root, but
then does a btrfs_get_fs_root() which can read from the tree_root.

It's actually easy enough to not be holding the path in
btrfs_uuid_scan_kthread() when we add a uuid entry, as we already drop
it further down and re-start the search when we loop.  So simply move
the path release before we add our entry to the uuid tree.

This also fixes a problem where we're holding a path open after we do
btrfs_end_transaction(), which has it's own problems.

CC: stable@vger.kernel.org # 4.4+
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/volumes.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4172,6 +4172,7 @@ static int btrfs_uuid_scan_kthread(void
 			goto skip;
 		}
 update_tree:
+		btrfs_release_path(path);
 		if (!btrfs_is_empty_uuid(root_item.uuid)) {
 			ret = btrfs_uuid_tree_add(trans, root_item.uuid,
 						  BTRFS_UUID_KEY_SUBVOL,
@@ -4196,6 +4197,7 @@ update_tree:
 		}
 
 skip:
+		btrfs_release_path(path);
 		if (trans) {
 			ret = btrfs_end_transaction(trans);
 			trans = NULL;
@@ -4203,7 +4205,6 @@ skip:
 				break;
 		}
 
-		btrfs_release_path(path);
 		if (key.offset < (u64)-1) {
 			key.offset++;
 		} else if (key.type < BTRFS_ROOT_ITEM_KEY) {


