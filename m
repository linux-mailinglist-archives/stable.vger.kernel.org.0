Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B69F26FFC
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 22:00:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730681AbfEVTXA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 15:23:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:43804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730677AbfEVTW7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 May 2019 15:22:59 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76737217D7;
        Wed, 22 May 2019 19:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558552978;
        bh=Nv5cGBCFnMfTv8Ai6NBu5Z5YCU0ScEgWsk8kly9DXlg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gEE10QKCic2vRrv9o00LjQzar9xLOJF40v5/ifLMpEPF72u1Kzu2iZmM2HILeHYlE
         qQH5SncL/pIAeplBWdaZwnrgjfELSJ87G5wFBsvuLgzBEkUU/N5Lb5n9ZZq7qj1TsP
         rCsmqJKQ3CQQB7ObWn+JunkaPDxJrhKGkFknnyH8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 058/375] btrfs: reloc: Fix NULL pointer dereference due to expanded reloc_root lifespan
Date:   Wed, 22 May 2019 15:15:58 -0400
Message-Id: <20190522192115.22666-58-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190522192115.22666-1-sashal@kernel.org>
References: <20190522192115.22666-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit 10995c0491204c861948c9850939a7f4e90760a4 ]

Commit d2311e698578 ("btrfs: relocation: Delay reloc tree deletion after
merge_reloc_roots()") expands the life span of root->reloc_root.

This breaks certain checs of fs_info->reloc_ctl.  Before that commit, if
we have a root with valid reloc_root, then it's ensured to have
fs_info->reloc_ctl.

But now since reloc_root doesn't always mean a valid fs_info->reloc_ctl,
such check is unreliable and can cause the following NULL pointer
dereference:

  BUG: unable to handle kernel NULL pointer dereference at 00000000000005c1
  IP: btrfs_reloc_pre_snapshot+0x20/0x50 [btrfs]
  PGD 0 P4D 0
  Oops: 0000 [#1] SMP PTI
  CPU: 0 PID: 10379 Comm: snapperd Not tainted
  Call Trace:
   create_pending_snapshot+0xd7/0xfc0 [btrfs]
   create_pending_snapshots+0x8e/0xb0 [btrfs]
   btrfs_commit_transaction+0x2ac/0x8f0 [btrfs]
   btrfs_mksubvol+0x561/0x570 [btrfs]
   btrfs_ioctl_snap_create_transid+0x189/0x190 [btrfs]
   btrfs_ioctl_snap_create_v2+0x102/0x150 [btrfs]
   btrfs_ioctl+0x5c9/0x1e60 [btrfs]
   do_vfs_ioctl+0x90/0x5f0
   SyS_ioctl+0x74/0x80
   do_syscall_64+0x7b/0x150
   entry_SYSCALL_64_after_hwframe+0x3d/0xa2
  RIP: 0033:0x7fd7cdab8467

Fix it by explicitly checking fs_info->reloc_ctl other than using the
implied root->reloc_root.

Fixes: d2311e698578 ("btrfs: relocation: Delay reloc tree deletion after merge_reloc_roots")
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/relocation.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 00c3dd92f088f..1d82ee4883eb3 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -4676,14 +4676,12 @@ int btrfs_reloc_cow_block(struct btrfs_trans_handle *trans,
 void btrfs_reloc_pre_snapshot(struct btrfs_pending_snapshot *pending,
 			      u64 *bytes_to_reserve)
 {
-	struct btrfs_root *root;
-	struct reloc_control *rc;
+	struct btrfs_root *root = pending->root;
+	struct reloc_control *rc = root->fs_info->reloc_ctl;
 
-	root = pending->root;
-	if (!root->reloc_root)
+	if (!root->reloc_root || !rc)
 		return;
 
-	rc = root->fs_info->reloc_ctl;
 	if (!rc->merge_reloc_tree)
 		return;
 
@@ -4712,10 +4710,10 @@ int btrfs_reloc_post_snapshot(struct btrfs_trans_handle *trans,
 	struct btrfs_root *root = pending->root;
 	struct btrfs_root *reloc_root;
 	struct btrfs_root *new_root;
-	struct reloc_control *rc;
+	struct reloc_control *rc = root->fs_info->reloc_ctl;
 	int ret;
 
-	if (!root->reloc_root)
+	if (!root->reloc_root || !rc)
 		return 0;
 
 	rc = root->fs_info->reloc_ctl;
-- 
2.20.1

