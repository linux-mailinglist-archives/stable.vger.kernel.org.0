Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 428423EB8AA
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 17:26:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242248AbhHMPPJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 11:15:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:56440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242438AbhHMPOP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Aug 2021 11:14:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC4C6604D7;
        Fri, 13 Aug 2021 15:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628867621;
        bh=apZ7JI6t18Dk9E8UZ7ds1lftjlIElmDNvOQWGCuShF0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MAYAhtZjQ8zsghdER8U0WvXLVOWmzS9RpBPshrmPugAU+NspuuoLEbxBtanwe8Y1J
         EYmW5NLrovSw4K8UBvGf8/dY6TIKEnW3lgQMBREC3XCSFLA6wa7VUoEuqyHXHVE5jx
         lnLns9wzpGbLZ9vwg819zBLDU66FUOuztc804VDY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH 5.4 25/27] btrfs: qgroup: dont commit transaction when we already hold the handle
Date:   Fri, 13 Aug 2021 17:07:23 +0200
Message-Id: <20210813150524.221417812@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210813150523.364549385@linuxfoundation.org>
References: <20210813150523.364549385@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

commit 6f23277a49e68f8a9355385c846939ad0b1261e7 upstream

[BUG]
When running the following script, btrfs will trigger an ASSERT():

  #/bin/bash
  mkfs.btrfs -f $dev
  mount $dev $mnt
  xfs_io -f -c "pwrite 0 1G" $mnt/file
  sync
  btrfs quota enable $mnt
  btrfs quota rescan -w $mnt

  # Manually set the limit below current usage
  btrfs qgroup limit 512M $mnt $mnt

  # Crash happens
  touch $mnt/file

The dmesg looks like this:

  assertion failed: refcount_read(&trans->use_count) == 1, in fs/btrfs/transaction.c:2022
  ------------[ cut here ]------------
  kernel BUG at fs/btrfs/ctree.h:3230!
  invalid opcode: 0000 [#1] SMP PTI
  RIP: 0010:assertfail.constprop.0+0x18/0x1a [btrfs]
   btrfs_commit_transaction.cold+0x11/0x5d [btrfs]
   try_flush_qgroup+0x67/0x100 [btrfs]
   __btrfs_qgroup_reserve_meta+0x3a/0x60 [btrfs]
   btrfs_delayed_update_inode+0xaa/0x350 [btrfs]
   btrfs_update_inode+0x9d/0x110 [btrfs]
   btrfs_dirty_inode+0x5d/0xd0 [btrfs]
   touch_atime+0xb5/0x100
   iterate_dir+0xf1/0x1b0
   __x64_sys_getdents64+0x78/0x110
   do_syscall_64+0x33/0x80
   entry_SYSCALL_64_after_hwframe+0x44/0xa9
  RIP: 0033:0x7fb5afe588db

[CAUSE]
In try_flush_qgroup(), we assume we don't hold a transaction handle at
all.  This is true for data reservation and mostly true for metadata.
Since data space reservation always happens before we start a
transaction, and for most metadata operation we reserve space in
start_transaction().

But there is an exception, btrfs_delayed_inode_reserve_metadata().
It holds a transaction handle, while still trying to reserve extra
metadata space.

When we hit EDQUOT inside btrfs_delayed_inode_reserve_metadata(), we
will join current transaction and commit, while we still have
transaction handle from qgroup code.

[FIX]
Let's check current->journal before we join the transaction.

If current->journal is unset or BTRFS_SEND_TRANS_STUB, it means
we are not holding a transaction, thus are able to join and then commit
transaction.

If current->journal is a valid transaction handle, we avoid committing
transaction and just end it

This is less effective than committing current transaction, as it won't
free metadata reserved space, but we may still free some data space
before new data writes.

Bugzilla: https://bugzilla.suse.com/show_bug.cgi?id=1178634
Fixes: c53e9653605d ("btrfs: qgroup: try to flush qgroup space when we get -EDQUOT")
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/qgroup.c |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -3502,6 +3502,7 @@ static int try_flush_qgroup(struct btrfs
 {
 	struct btrfs_trans_handle *trans;
 	int ret;
+	bool can_commit = true;
 
 	/*
 	 * We don't want to run flush again and again, so if there is a running
@@ -3513,6 +3514,20 @@ static int try_flush_qgroup(struct btrfs
 		return 0;
 	}
 
+	/*
+	 * If current process holds a transaction, we shouldn't flush, as we
+	 * assume all space reservation happens before a transaction handle is
+	 * held.
+	 *
+	 * But there are cases like btrfs_delayed_item_reserve_metadata() where
+	 * we try to reserve space with one transction handle already held.
+	 * In that case we can't commit transaction, but at least try to end it
+	 * and hope the started data writes can free some space.
+	 */
+	if (current->journal_info &&
+	    current->journal_info != BTRFS_SEND_TRANS_STUB)
+		can_commit = false;
+
 	ret = btrfs_start_delalloc_snapshot(root);
 	if (ret < 0)
 		goto out;
@@ -3524,7 +3539,10 @@ static int try_flush_qgroup(struct btrfs
 		goto out;
 	}
 
-	ret = btrfs_commit_transaction(trans);
+	if (can_commit)
+		ret = btrfs_commit_transaction(trans);
+	else
+		ret = btrfs_end_transaction(trans);
 out:
 	clear_bit(BTRFS_ROOT_QGROUP_FLUSHING, &root->state);
 	wake_up(&root->qgroup_flush_wait);


