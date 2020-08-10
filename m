Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAB12240DFD
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 21:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728920AbgHJTKV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 15:10:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:37536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728852AbgHJTKU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 15:10:20 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4CA4120885;
        Mon, 10 Aug 2020 19:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597086620;
        bh=w2i6sfdM3RBvqRfsaE8X5skoAf93suubT65n4mRzRRw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qsJXyvaB68taQkd+Nk/G0hKgdIj0iBf0NZf8EROgVkl1doYqnZ+J8Mljnp6N9TTXe
         oW7qOYSGuNdg3TcHJbrMiUP+VgOKHWPFmpCcAgd2CyL2IDFRizbpSfuJQCEQt/WPUq
         fKyEb/LYm02beeJaOHj1hUNA34+GReHR5gIA38uY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 59/64] btrfs: qgroup: free per-trans reserved space when a subvolume gets dropped
Date:   Mon, 10 Aug 2020 15:08:54 -0400
Message-Id: <20200810190859.3793319-59-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200810190859.3793319-1-sashal@kernel.org>
References: <20200810190859.3793319-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

