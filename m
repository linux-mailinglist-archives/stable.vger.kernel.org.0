Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 773BF330DBE
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 13:32:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbhCHMcJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 07:32:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:40878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231463AbhCHMbn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Mar 2021 07:31:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F1D90651CC;
        Mon,  8 Mar 2021 12:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615206702;
        bh=K/OWNp/x+jjNoOkiiHtvtszhaligIt73oStFgQ4+0S0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XPm5hujd8bncWdc58zoOdE4XsobcOurE33GneJOUCk5rnFrI1pWk6VSRWZoUdvD8a
         8l/2wbXSdVMO8y6TwA176CLL6Q5Iv181BsbmdL0CwDrOjNXYmqQboGTYU0+aX8Wc/u
         m8Y6MmZZx4zboX5Cfdf0buBXwht5T17b+dZgU+18=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Casey Schaufler <casey@schaufler-ca.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.4 08/22] btrfs: fix warning when creating a directory with smack enabled
Date:   Mon,  8 Mar 2021 13:30:25 +0100
Message-Id: <20210308122714.801040210@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210308122714.391917404@linuxfoundation.org>
References: <20210308122714.391917404@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit fd57a98d6f0c98fa295813087f13afb26c224e73 upstream.

When we have smack enabled, during the creation of a directory smack may
attempt to add a "smack transmute" xattr on the inode, which results in
the following warning and trace:

  WARNING: CPU: 3 PID: 2548 at fs/btrfs/transaction.c:537 start_transaction+0x489/0x4f0
  Modules linked in: nft_objref nf_conntrack_netbios_ns (...)
  CPU: 3 PID: 2548 Comm: mkdir Not tainted 5.9.0-rc2smack+ #81
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.13.0-2.fc32 04/01/2014
  RIP: 0010:start_transaction+0x489/0x4f0
  Code: e9 be fc ff ff (...)
  RSP: 0018:ffffc90001887d10 EFLAGS: 00010202
  RAX: ffff88816f1e0000 RBX: 0000000000000201 RCX: 0000000000000003
  RDX: 0000000000000201 RSI: 0000000000000002 RDI: ffff888177849000
  RBP: ffff888177849000 R08: 0000000000000001 R09: 0000000000000004
  R10: ffffffff825e8f7a R11: 0000000000000003 R12: ffffffffffffffe2
  R13: 0000000000000000 R14: ffff88803d884270 R15: ffff8881680d8000
  FS:  00007f67317b8440(0000) GS:ffff88817bcc0000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 00007f67247a22a8 CR3: 000000004bfbc002 CR4: 0000000000370ee0
  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
  Call Trace:
   ? slab_free_freelist_hook+0xea/0x1b0
   ? trace_hardirqs_on+0x1c/0xe0
   btrfs_setxattr_trans+0x3c/0xf0
   __vfs_setxattr+0x63/0x80
   smack_d_instantiate+0x2d3/0x360
   security_d_instantiate+0x29/0x40
   d_instantiate_new+0x38/0x90
   btrfs_mkdir+0x1cf/0x1e0
   vfs_mkdir+0x14f/0x200
   do_mkdirat+0x6d/0x110
   do_syscall_64+0x2d/0x40
   entry_SYSCALL_64_after_hwframe+0x44/0xa9
  RIP: 0033:0x7f673196ae6b
  Code: 8b 05 11 (...)
  RSP: 002b:00007ffc3c679b18 EFLAGS: 00000246 ORIG_RAX: 0000000000000053
  RAX: ffffffffffffffda RBX: 00000000000001ff RCX: 00007f673196ae6b
  RDX: 0000000000000000 RSI: 00000000000001ff RDI: 00007ffc3c67a30d
  RBP: 00007ffc3c67a30d R08: 00000000000001ff R09: 0000000000000000
  R10: 000055d3e39fe930 R11: 0000000000000246 R12: 0000000000000000
  R13: 00007ffc3c679cd8 R14: 00007ffc3c67a30d R15: 00007ffc3c679ce0
  irq event stamp: 11029
  hardirqs last  enabled at (11037): [<ffffffff81153fe6>] console_unlock+0x486/0x670
  hardirqs last disabled at (11044): [<ffffffff81153c01>] console_unlock+0xa1/0x670
  softirqs last  enabled at (8864): [<ffffffff81e0102f>] asm_call_on_stack+0xf/0x20
  softirqs last disabled at (8851): [<ffffffff81e0102f>] asm_call_on_stack+0xf/0x20

This happens because at btrfs_mkdir() we call d_instantiate_new() while
holding a transaction handle, which results in the following call chain:

  btrfs_mkdir()
     trans = btrfs_start_transaction(root, 5);

     d_instantiate_new()
        smack_d_instantiate()
            __vfs_setxattr()
                btrfs_setxattr_trans()
                   btrfs_start_transaction()
                      start_transaction()
                         WARN_ON()
                           --> a tansaction start has TRANS_EXTWRITERS
                               set in its type
                         h->orig_rsv = h->block_rsv
                         h->block_rsv = NULL

     btrfs_end_transaction(trans)

Besides the warning triggered at start_transaction, we set the handle's
block_rsv to NULL which may cause some surprises later on.

So fix this by making btrfs_setxattr_trans() not start a transaction when
we already have a handle on one, stored in current->journal_info, and use
that handle. We are good to use the handle because at btrfs_mkdir() we did
reserve space for the xattr and the inode item.

Reported-by: Casey Schaufler <casey@schaufler-ca.com>
CC: stable@vger.kernel.org # 5.4+
Acked-by: Casey Schaufler <casey@schaufler-ca.com>
Tested-by: Casey Schaufler <casey@schaufler-ca.com>
Link: https://lore.kernel.org/linux-btrfs/434d856f-bd7b-4889-a6ec-e81aaebfa735@schaufler-ca.com/
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/xattr.c |   31 +++++++++++++++++++++++++++----
 1 file changed, 27 insertions(+), 4 deletions(-)

--- a/fs/btrfs/xattr.c
+++ b/fs/btrfs/xattr.c
@@ -227,11 +227,33 @@ int btrfs_setxattr_trans(struct inode *i
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_trans_handle *trans;
+	const bool start_trans = (current->journal_info == NULL);
 	int ret;
 
-	trans = btrfs_start_transaction(root, 2);
-	if (IS_ERR(trans))
-		return PTR_ERR(trans);
+	if (start_trans) {
+		/*
+		 * 1 unit for inserting/updating/deleting the xattr
+		 * 1 unit for the inode item update
+		 */
+		trans = btrfs_start_transaction(root, 2);
+		if (IS_ERR(trans))
+			return PTR_ERR(trans);
+	} else {
+		/*
+		 * This can happen when smack is enabled and a directory is being
+		 * created. It happens through d_instantiate_new(), which calls
+		 * smack_d_instantiate(), which in turn calls __vfs_setxattr() to
+		 * set the transmute xattr (XATTR_NAME_SMACKTRANSMUTE) on the
+		 * inode. We have already reserved space for the xattr and inode
+		 * update at btrfs_mkdir(), so just use the transaction handle.
+		 * We don't join or start a transaction, as that will reset the
+		 * block_rsv of the handle and trigger a warning for the start
+		 * case.
+		 */
+		ASSERT(strncmp(name, XATTR_SECURITY_PREFIX,
+			       XATTR_SECURITY_PREFIX_LEN) == 0);
+		trans = current->journal_info;
+	}
 
 	ret = btrfs_setxattr(trans, inode, name, value, size, flags);
 	if (ret)
@@ -242,7 +264,8 @@ int btrfs_setxattr_trans(struct inode *i
 	ret = btrfs_update_inode(trans, root, inode);
 	BUG_ON(ret);
 out:
-	btrfs_end_transaction(trans);
+	if (start_trans)
+		btrfs_end_transaction(trans);
 	return ret;
 }
 


