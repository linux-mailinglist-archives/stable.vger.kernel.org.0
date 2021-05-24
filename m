Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D25038EBCB
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:07:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234168AbhEXPIR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:08:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:40002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234999AbhEXPFl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:05:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 85B566162E;
        Mon, 24 May 2021 14:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867861;
        bh=Dv1gPJz98h71tKkFr3ikWvxAKFWRsMK+BBbWvj2Tgjc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CxAPNmHALSt0YJPpik/+NzkL9ky97cRVprRMtynzsajjYeR89PkfxDr9IJFNyN7Eb
         TZjya69jwd3/rfnrJWC+wuMFKmWkltu8FyDRQMJBqCq0GWlV8ZnlWjoCtVlCThoMSQ
         hGj0FHCMj+Ax6BBWRF3aiQajs8YYDqS5x8DHIwj3ZdhEyiR+LVT8vBc+s2yAN9xXUf
         nrUrEAvkFTi6oBJiDo+Fn9HHSlsfLEswfIalZQ/qeVtsyCp0aK56q0rLE+scIRwMq+
         0sQhrirfQWpHB3kTipP8WmGBBZ7kR2IFI2Ib13v/Cr8SiRV8kFgpu/Ot3ZCTcbBBHI
         n913eoClgMXig==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 17/21] btrfs: do not BUG_ON in link_to_fixup_dir
Date:   Mon, 24 May 2021 10:50:36 -0400
Message-Id: <20210524145040.2499322-17-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524145040.2499322-1-sashal@kernel.org>
References: <20210524145040.2499322-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 91df99a6eb50d5a1bc70fff4a09a0b7ae6aab96d ]

While doing error injection testing I got the following panic

  kernel BUG at fs/btrfs/tree-log.c:1862!
  invalid opcode: 0000 [#1] SMP NOPTI
  CPU: 1 PID: 7836 Comm: mount Not tainted 5.13.0-rc1+ #305
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.13.0-2.fc32 04/01/2014
  RIP: 0010:link_to_fixup_dir+0xd5/0xe0
  RSP: 0018:ffffb5800180fa30 EFLAGS: 00010216
  RAX: fffffffffffffffb RBX: 00000000fffffffb RCX: ffff8f595287faf0
  RDX: ffffb5800180fa37 RSI: ffff8f5954978800 RDI: 0000000000000000
  RBP: ffff8f5953af9450 R08: 0000000000000019 R09: 0000000000000001
  R10: 000151f408682970 R11: 0000000120021001 R12: ffff8f5954978800
  R13: ffff8f595287faf0 R14: ffff8f5953c77dd0 R15: 0000000000000065
  FS:  00007fc5284c8c40(0000) GS:ffff8f59bbd00000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 00007fc5287f47c0 CR3: 000000011275e002 CR4: 0000000000370ee0
  Call Trace:
   replay_one_buffer+0x409/0x470
   ? btree_read_extent_buffer_pages+0xd0/0x110
   walk_up_log_tree+0x157/0x1e0
   walk_log_tree+0xa6/0x1d0
   btrfs_recover_log_trees+0x1da/0x360
   ? replay_one_extent+0x7b0/0x7b0
   open_ctree+0x1486/0x1720
   btrfs_mount_root.cold+0x12/0xea
   ? __kmalloc_track_caller+0x12f/0x240
   legacy_get_tree+0x24/0x40
   vfs_get_tree+0x22/0xb0
   vfs_kern_mount.part.0+0x71/0xb0
   btrfs_mount+0x10d/0x380
   ? vfs_parse_fs_string+0x4d/0x90
   legacy_get_tree+0x24/0x40
   vfs_get_tree+0x22/0xb0
   path_mount+0x433/0xa10
   __x64_sys_mount+0xe3/0x120
   do_syscall_64+0x3d/0x80
   entry_SYSCALL_64_after_hwframe+0x44/0xae

We can get -EIO or any number of legitimate errors from
btrfs_search_slot(), panicing here is not the appropriate response.  The
error path for this code handles errors properly, simply return the
error.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/tree-log.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index e40c27aec949..035a2e2be156 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -1629,8 +1629,6 @@ static noinline int link_to_fixup_dir(struct btrfs_trans_handle *trans,
 		ret = btrfs_update_inode(trans, root, inode);
 	} else if (ret == -EEXIST) {
 		ret = 0;
-	} else {
-		BUG(); /* Logic Error */
 	}
 	iput(inode);
 
-- 
2.30.2

