Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C38EA39097
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 17:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730217AbfFGPxN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 11:53:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:33296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731718AbfFGPsM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Jun 2019 11:48:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 738EB2146E;
        Fri,  7 Jun 2019 15:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559922492;
        bh=rSQyGOMQ6OMJje46NqgsQ88DSyiCPqA1B4v+M1aEzs0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jYmY0hNBi07TXMo6vZ4vknjitJaEbsNVEnKMnENXhgx9++Gi2Qhdily+U6JKtkxp1
         GQzsaIo8x4u0REnzZiTcLMuqLgs5uZdyzQkfcgDsi1Sy11VZaqtPeE7z1bqSXswM5l
         oQ889Mml28WewkwS7J8YeG3RO9MC6jGWvaQtI9ws=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juan Erbes <jerbes@gmail.com>,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>
Subject: [PATCH 5.1 25/85] btrfs: qgroup: Check bg while resuming relocation to avoid NULL pointer dereference
Date:   Fri,  7 Jun 2019 17:39:10 +0200
Message-Id: <20190607153852.354385547@linuxfoundation.org>
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

commit 57949d033a09c57d77be218b5bec07af6878ab32 upstream.

[BUG]
When mounting a fs with reloc tree and has qgroup enabled, it can cause
NULL pointer dereference at mount time:

  BUG: kernel NULL pointer dereference, address: 00000000000000a8
  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page
  PGD 0 P4D 0
  Oops: 0000 [#1] PREEMPT SMP NOPTI
  RIP: 0010:btrfs_qgroup_add_swapped_blocks+0x186/0x300 [btrfs]
  Call Trace:
   replace_path.isra.23+0x685/0x900 [btrfs]
   merge_reloc_root+0x26e/0x5f0 [btrfs]
   merge_reloc_roots+0x10a/0x1a0 [btrfs]
   btrfs_recover_relocation+0x3cd/0x420 [btrfs]
   open_ctree+0x1bc8/0x1ed0 [btrfs]
   btrfs_mount_root+0x544/0x680 [btrfs]
   legacy_get_tree+0x34/0x60
   vfs_get_tree+0x2d/0xf0
   fc_mount+0x12/0x40
   vfs_kern_mount.part.12+0x61/0xa0
   vfs_kern_mount+0x13/0x20
   btrfs_mount+0x16f/0x860 [btrfs]
   legacy_get_tree+0x34/0x60
   vfs_get_tree+0x2d/0xf0
   do_mount+0x81f/0xac0
   ksys_mount+0xbf/0xe0
   __x64_sys_mount+0x25/0x30
   do_syscall_64+0x65/0x240
   entry_SYSCALL_64_after_hwframe+0x49/0xbe

[CAUSE]
In btrfs_recover_relocation(), we don't have enough info to determine
which block group we're relocating, but only to merge existing reloc
trees.

Thus in btrfs_recover_relocation(), rc->block_group is NULL.
btrfs_qgroup_add_swapped_blocks() hasn't taken this into consideration,
and causes a NULL pointer dereference.

The bug is introduced by commit 3d0174f78e72 ("btrfs: qgroup: Only trace
data extents in leaves if we're relocating data block group"), and
later qgroup refactoring still keeps this optimization.

[FIX]
Thankfully in the context of btrfs_recover_relocation(), there is no
other progress can modify tree blocks, thus those swapped tree blocks
pair will never affect qgroup numbers, no matter whatever we set for
block->trace_leaf.

So we only need to check if @bg is NULL before accessing @bg->flags.

Reported-by: Juan Erbes <jerbes@gmail.com>
Link: https://bugzilla.opensuse.org/show_bug.cgi?id=1134806
Fixes: 3d0174f78e72 ("btrfs: qgroup: Only trace data extents in leaves if we're relocating data block group")
CC: stable@vger.kernel.org # 4.20+
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/qgroup.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -3831,7 +3831,13 @@ int btrfs_qgroup_add_swapped_blocks(stru
 							    subvol_slot);
 	block->last_snapshot = last_snapshot;
 	block->level = level;
-	if (bg->flags & BTRFS_BLOCK_GROUP_DATA)
+
+	/*
+	 * If we have bg == NULL, we're called from btrfs_recover_relocation(),
+	 * no one else can modify tree blocks thus we qgroup will not change
+	 * no matter the value of trace_leaf.
+	 */
+	if (bg && bg->flags & BTRFS_BLOCK_GROUP_DATA)
 		block->trace_leaf = true;
 	else
 		block->trace_leaf = false;


