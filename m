Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 673B015C775
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 17:14:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727988AbgBMQKt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 11:10:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:60002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727965AbgBMPWd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:22:33 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A0529246B3;
        Thu, 13 Feb 2020 15:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607350;
        bh=7iRLkMqeUOIng/6kDFjMOUlzItOiz44rI7yMpIfPZKs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ERxc6ygM5DESoGtqsL4EfYyGyzETYaAuBUbsps3jsA//WfWAJ1Nj6IBwm0nmpT+x8
         tVIDeyyTJFPVZuG6RogXsL7FI9rj30OKNNVEwoUAmDGk6FcgUbuRi5+0jpSHP/I5rs
         meu+muUK45CcLFuhI1fZ+Nw0LxzIS0+WGB08+WLU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 4.4 31/91] btrfs: set trans->drity in btrfs_commit_transaction
Date:   Thu, 13 Feb 2020 07:19:48 -0800
Message-Id: <20200213151833.609714922@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151821.384445454@linuxfoundation.org>
References: <20200213151821.384445454@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

commit d62b23c94952e78211a383b7d90ef0afbd9a3717 upstream.

If we abort a transaction we have the following sequence

if (!trans->dirty && list_empty(&trans->new_bgs))
	return;
WRITE_ONCE(trans->transaction->aborted, err);

The idea being if we didn't modify anything with our trans handle then
we don't really need to abort the whole transaction, maybe the other
trans handles are fine and we can carry on.

However in the case of create_snapshot we add a pending_snapshot object
to our transaction and then commit the transaction.  We don't actually
modify anything.  sync() behaves the same way, attach to an existing
transaction and commit it.  This means that if we have an IO error in
the right places we could abort the committing transaction with our
trans->dirty being not set and thus not set transaction->aborted.

This is a problem because in the create_snapshot() case we depend on
pending->error being set to something, or btrfs_commit_transaction
returning an error.

If we are not the trans handle that gets to commit the transaction, and
we're waiting on the commit to happen we get our return value from
cur_trans->aborted.  If this was not set to anything because sync() hit
an error in the transaction commit before it could modify anything then
cur_trans->aborted would be 0.  Thus we'd return 0 from
btrfs_commit_transaction() in create_snapshot.

This is a problem because we then try to do things with
pending_snapshot->snap, which will be NULL because we didn't create the
snapshot, and then we'll get a NULL pointer dereference like the
following

"BUG: kernel NULL pointer dereference, address: 00000000000001f0"
RIP: 0010:btrfs_orphan_cleanup+0x2d/0x330
Call Trace:
 ? btrfs_mksubvol.isra.31+0x3f2/0x510
 btrfs_mksubvol.isra.31+0x4bc/0x510
 ? __sb_start_write+0xfa/0x200
 ? mnt_want_write_file+0x24/0x50
 btrfs_ioctl_snap_create_transid+0x16c/0x1a0
 btrfs_ioctl_snap_create_v2+0x11e/0x1a0
 btrfs_ioctl+0x1534/0x2c10
 ? free_debug_processing+0x262/0x2a3
 do_vfs_ioctl+0xa6/0x6b0
 ? do_sys_open+0x188/0x220
 ? syscall_trace_enter+0x1f8/0x330
 ksys_ioctl+0x60/0x90
 __x64_sys_ioctl+0x16/0x20
 do_syscall_64+0x4a/0x1b0

In order to fix this we need to make sure anybody who calls
commit_transaction has trans->dirty set so that they properly set the
trans->transaction->aborted value properly so any waiters know bad
things happened.

This was found while I was running generic/475 with my modified
fsstress, it reproduced within a few runs.  I ran with this patch all
night and didn't see the problem again.

CC: stable@vger.kernel.org # 4.4+
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/transaction.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1814,6 +1814,14 @@ int btrfs_commit_transaction(struct btrf
 	struct btrfs_inode *btree_ino = BTRFS_I(root->fs_info->btree_inode);
 	int ret;
 
+	/*
+	 * Some places just start a transaction to commit it.  We need to make
+	 * sure that if this commit fails that the abort code actually marks the
+	 * transaction as failed, so set trans->dirty to make the abort code do
+	 * the right thing.
+	 */
+	trans->dirty = true;
+
 	/* Stop the commit early if ->aborted is set */
 	if (unlikely(ACCESS_ONCE(cur_trans->aborted))) {
 		ret = cur_trans->aborted;


