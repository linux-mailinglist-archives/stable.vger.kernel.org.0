Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E364920DB76
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:15:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732333AbgF2UG1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 16:06:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:40584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732965AbgF2Ta1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:30:27 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB9A3251F8;
        Mon, 29 Jun 2020 15:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444915;
        bh=GAFwoHC/HyW+i5lJKlhyT/lkP/qDkV54/eKdoBoi7tk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lrmzBSY9O7wHcKQLjAS0kjX8vJdGcvuxfEK3r/BpTcb5uQgXLJGA3zKm1uEuDXxpF
         MAUQyXLzNiRkg8CDGlgJfAHIr/20WuvkjVte98sf/zYDHjhd37Vse44VG/5yLFnpXd
         cowx00u/Tqp4EPgdEavNAqIs92u4cUiYOVPg7rVA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 011/131] btrfs: make caching_thread use btrfs_find_next_key
Date:   Mon, 29 Jun 2020 11:33:02 -0400
Message-Id: <20200629153502.2494656-12-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629153502.2494656-1-sashal@kernel.org>
References: <20200629153502.2494656-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.131-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.131-rc1
X-KernelTest-Deadline: 2020-07-01T15:34+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 6a9fb468f1152d6254f49fee6ac28c3cfa3367e5 ]

extent-tree.c has a find_next_key that just walks up the path to find
the next key, but it is used for both the caching stuff and the snapshot
delete stuff.  The snapshot deletion stuff is special so it can't really
use btrfs_find_next_key, but the caching thread stuff can.  We just need
to fix btrfs_find_next_key to deal with ->skip_locking and then it works
exactly the same as the private find_next_key helper.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ctree.c       | 4 ++--
 fs/btrfs/extent-tree.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index c9943d70e2cb2..d03944735ee42 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -5665,7 +5665,7 @@ int btrfs_find_next_key(struct btrfs_root *root, struct btrfs_path *path,
 	int slot;
 	struct extent_buffer *c;
 
-	WARN_ON(!path->keep_locks);
+	WARN_ON(!path->keep_locks && !path->skip_locking);
 	while (level < BTRFS_MAX_LEVEL) {
 		if (!path->nodes[level])
 			return 1;
@@ -5681,7 +5681,7 @@ int btrfs_find_next_key(struct btrfs_root *root, struct btrfs_path *path,
 			    !path->nodes[level + 1])
 				return 1;
 
-			if (path->locks[level + 1]) {
+			if (path->locks[level + 1] || path->skip_locking) {
 				level++;
 				continue;
 			}
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 271e70c45d5bd..954e558c4380f 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -436,7 +436,7 @@ static int load_extent_tree_free(struct btrfs_caching_control *caching_ctl)
 		if (path->slots[0] < nritems) {
 			btrfs_item_key_to_cpu(leaf, &key, path->slots[0]);
 		} else {
-			ret = find_next_key(path, 0, &key);
+			ret = btrfs_find_next_key(extent_root, path, &key, 0, 0);
 			if (ret)
 				break;
 
-- 
2.25.1

