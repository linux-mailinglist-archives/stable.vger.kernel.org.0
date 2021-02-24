Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3A80323D02
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 14:06:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235239AbhBXNBk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 08:01:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:51042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235393AbhBXMzQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 07:55:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7EC0664F25;
        Wed, 24 Feb 2021 12:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171099;
        bh=shqryU7hJ2qNSrXUSFc9Fi45Y5aWIOG2FZ+KPuQFMdg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KN0XJlo6452PByZVm/rHG+gK7M/CbBWUTc4NHv0nZ1+OjCipcuGZAAqb9WBKWLj7m
         NIpiZLG74NjDBtHAoJJigtnBKg0GoGwENoKnH9hJwpjEoEOTF2f6S0egfggJR5CBIs
         MnNRZYkEvzQhBZjX696JiC1NffZpvqiz7H8MmQuuj7EPWY0RS9ffKsdp/sTsj5PZMm
         hJ7wuHLbOgbwtTxZolmOceIFR4aQFUeTtkDZEx+AvTKa0ND9ufxq9Uo7BNArryBA6X
         xpUGeS8J+dlZNG++59DfBDtLtwtfkEAFLI4HbznSrsje8dFNhGdf2dvcANl+2zS7DM
         7PwxiIfJrViAg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 54/67] btrfs: make btrfs_start_delalloc_root's nr argument a long
Date:   Wed, 24 Feb 2021 07:50:12 -0500
Message-Id: <20210224125026.481804-54-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210224125026.481804-1-sashal@kernel.org>
References: <20210224125026.481804-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikolay Borisov <nborisov@suse.com>

[ Upstream commit 9db4dc241e87fccd8301357d5ef908f40b50f2e3 ]

It's currently u64 which gets instantly translated either to LONG_MAX
(if U64_MAX is passed) or cast to an unsigned long (which is in fact,
wrong because writeback_control::nr_to_write is a signed, long type).

Just convert the function's argument to be long time which obviates the
need to manually convert u64 value to a long. Adjust all call sites
which pass U64_MAX to pass LONG_MAX. Finally ensure that in
shrink_delalloc the u64 is converted to a long without overflowing,
resulting in a negative number.

Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ctree.h       | 2 +-
 fs/btrfs/dev-replace.c | 2 +-
 fs/btrfs/inode.c       | 6 +++---
 fs/btrfs/ioctl.c       | 2 +-
 fs/btrfs/space-info.c  | 3 ++-
 5 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 4debdbdde2abb..81fde2d0327df 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3100,7 +3100,7 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 			       u32 min_type);
 
 int btrfs_start_delalloc_snapshot(struct btrfs_root *root);
-int btrfs_start_delalloc_roots(struct btrfs_fs_info *fs_info, u64 nr,
+int btrfs_start_delalloc_roots(struct btrfs_fs_info *fs_info, long nr,
 			       bool in_reclaim_context);
 int btrfs_set_extent_delalloc(struct btrfs_inode *inode, u64 start, u64 end,
 			      unsigned int extra_bits,
diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 324f646d6e5e2..bc73f798ce3a8 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -715,7 +715,7 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 	 * flush all outstanding I/O and inode extent mappings before the
 	 * copy operation is declared as being finished
 	 */
-	ret = btrfs_start_delalloc_roots(fs_info, U64_MAX, false);
+	ret = btrfs_start_delalloc_roots(fs_info, LONG_MAX, false);
 	if (ret) {
 		mutex_unlock(&dev_replace->lock_finishing_cancel_unmount);
 		return ret;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index a8e0a6b038d3e..3a02b17f76eb7 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9486,11 +9486,11 @@ int btrfs_start_delalloc_snapshot(struct btrfs_root *root)
 	return start_delalloc_inodes(root, &wbc, true, false);
 }
 
-int btrfs_start_delalloc_roots(struct btrfs_fs_info *fs_info, u64 nr,
+int btrfs_start_delalloc_roots(struct btrfs_fs_info *fs_info, long nr,
 			       bool in_reclaim_context)
 {
 	struct writeback_control wbc = {
-		.nr_to_write = (nr == U64_MAX) ? LONG_MAX : (unsigned long)nr,
+		.nr_to_write = nr,
 		.sync_mode = WB_SYNC_NONE,
 		.range_start = 0,
 		.range_end = LLONG_MAX,
@@ -9512,7 +9512,7 @@ int btrfs_start_delalloc_roots(struct btrfs_fs_info *fs_info, u64 nr,
 		 * Reset nr_to_write here so we know that we're doing a full
 		 * flush.
 		 */
-		if (nr == U64_MAX)
+		if (nr == LONG_MAX)
 			wbc.nr_to_write = LONG_MAX;
 
 		root = list_first_entry(&splice, struct btrfs_root,
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index dde49a791f3e2..e26df790988ba 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4951,7 +4951,7 @@ long btrfs_ioctl(struct file *file, unsigned int
 	case BTRFS_IOC_SYNC: {
 		int ret;
 
-		ret = btrfs_start_delalloc_roots(fs_info, U64_MAX, false);
+		ret = btrfs_start_delalloc_roots(fs_info, LONG_MAX, false);
 		if (ret)
 			return ret;
 		ret = btrfs_sync_fs(inode->i_sb, 1);
diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
index e8347461c8ddd..84fb94e78a8ff 100644
--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -532,7 +532,8 @@ static void shrink_delalloc(struct btrfs_fs_info *fs_info,
 
 	loops = 0;
 	while ((delalloc_bytes || dio_bytes) && loops < 3) {
-		u64 nr_pages = min(delalloc_bytes, to_reclaim) >> PAGE_SHIFT;
+		u64 temp = min(delalloc_bytes, to_reclaim) >> PAGE_SHIFT;
+		long nr_pages = min_t(u64, temp, LONG_MAX);
 
 		btrfs_start_delalloc_roots(fs_info, nr_pages, true);
 
-- 
2.27.0

