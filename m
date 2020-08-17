Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A6BB2476CF
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:42:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729619AbgHQPYb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:24:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:54452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729520AbgHQPYT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:24:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 354472312E;
        Mon, 17 Aug 2020 15:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597677858;
        bh=w2i6sfdM3RBvqRfsaE8X5skoAf93suubT65n4mRzRRw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zhhyQ7dxEpsCBFSiTDB9ZHf9+ZjG7ziDFKCUG1PJTGEf5mflGqPPTarxayKaXF8vb
         FAB3YPYqd+k2n0inMexC1LU2sjpEsH2W0CXr6KRAQSBlzwUA9HleAf+VvvnZ1Vy6EX
         lZ84vEM2LcfuC5gpdZLC6kSglZvxLjyxSdAe+nGE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 134/464] btrfs: qgroup: free per-trans reserved space when a subvolume gets dropped
Date:   Mon, 17 Aug 2020 17:11:27 +0200
Message-Id: <20200817143840.232957576@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit a3cf0e4342b6af9e6b34a4b913c630fbd03a82ea ]

[BUG]
Sometime fsstress could lead to qgroup warning for case like
generic/013:

  BTRFS warning (device dm-3): qgroup 0/259 has unreleased space, type 1 rsv 81920
  ------------[ cut here ]------------
  WARNING: CPU: 9 PID: 24535 at fs/btrfs/disk-io.c:4142 close_ctree+0x1dc/0x323 [btrfs]
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
  RIP: 0010:close_ctree+0x1dc/0x323 [btrfs]
  Call Trace:
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
  ---[ end trace 6c341cdf9b6cc3c1 ]---
  BTRFS error (device dm-3): qgroup reserved space leaked

While that subvolume 259 is no longer in that filesystem.

[CAUSE]
Normally per-trans qgroup reserved space is freed when a transaction is
committed, in commit_fs_roots().

However for completely dropped subvolume, that subvolume is completely
gone, thus is no longer in the fs_roots_radix, and its per-trans
reserved qgroup will never be freed.

Since the subvolume is already gone, leaked per-trans space won't cause
any trouble for end users.

[FIX]
Just call btrfs_qgroup_free_meta_all_pertrans() before a subvolume is
completely dropped.

Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent-tree.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index c0bc35f932bf7..96223813b6186 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5466,6 +5466,14 @@ int btrfs_drop_snapshot(struct btrfs_root *root, int update_ref, int for_reloc)
 		}
 	}
 
+	/*
+	 * This subvolume is going to be completely dropped, and won't be
+	 * recorded as dirty roots, thus pertrans meta rsv will not be freed at
+	 * commit transaction time.  So free it here manually.
+	 */
+	btrfs_qgroup_convert_reserved_meta(root, INT_MAX);
+	btrfs_qgroup_free_meta_all_pertrans(root);
+
 	if (test_bit(BTRFS_ROOT_IN_RADIX, &root->state))
 		btrfs_add_dropped_root(trans, root);
 	else
-- 
2.25.1



