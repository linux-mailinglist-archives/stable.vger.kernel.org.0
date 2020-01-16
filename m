Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FA2C13EFAE
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:16:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390131AbgAPSQl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 13:16:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:41218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732131AbgAPR3Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:29:24 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C79BD246F8;
        Thu, 16 Jan 2020 17:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579195763;
        bh=6E0aL007KUO2++/022Cemxn4jgbFOFs5qPY3sv9tjLk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fRFkwl4NxDzCmwpL0CEFJWEQv42AL/OG4U2sWTA0RtXUUrGfB7mH5C93T1rsOm658
         Orf0K2VfMrDedScCXNz5t1lV5HlYMrhRq3XJwUMabMSsOKJGMZv1K11xN+BbVLCjjv
         dXgbHkcXX1I/R8VJ7qo2g/JzddqOKDoGQesIIUQM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Filipe Manana <fdmanana@suse.com>,
        Nikolay Borisov <nborisov@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 292/371] Btrfs: fix inode cache waiters hanging on failure to start caching thread
Date:   Thu, 16 Jan 2020 12:22:44 -0500
Message-Id: <20200116172403.18149-235-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116172403.18149-1-sashal@kernel.org>
References: <20200116172403.18149-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit a68ebe0790fc88b4314d17984a2cf99ce2361901 ]

If we fail to start the inode caching thread, we print an error message
and disable the inode cache, however we never wake up any waiters, so they
hang forever waiting for the caching to finish. Fix this by waking them
up and have them fallback to a call to btrfs_find_free_objectid().

Fixes: e60efa84252c05 ("Btrfs: avoid triggering bug_on() when we fail to start inode caching task")
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/inode-map.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/inode-map.c b/fs/btrfs/inode-map.c
index 7dc2923655d9..b1c3a4ec76c8 100644
--- a/fs/btrfs/inode-map.c
+++ b/fs/btrfs/inode-map.c
@@ -26,6 +26,19 @@
 #include "inode-map.h"
 #include "transaction.h"
 
+static void fail_caching_thread(struct btrfs_root *root)
+{
+	struct btrfs_fs_info *fs_info = root->fs_info;
+
+	btrfs_warn(fs_info, "failed to start inode caching task");
+	btrfs_clear_pending_and_info(fs_info, INODE_MAP_CACHE,
+				     "disabling inode map caching");
+	spin_lock(&root->ino_cache_lock);
+	root->ino_cache_state = BTRFS_CACHE_ERROR;
+	spin_unlock(&root->ino_cache_lock);
+	wake_up(&root->ino_cache_wait);
+}
+
 static int caching_kthread(void *data)
 {
 	struct btrfs_root *root = data;
@@ -178,11 +191,8 @@ static void start_caching(struct btrfs_root *root)
 
 	tsk = kthread_run(caching_kthread, root, "btrfs-ino-cache-%llu",
 			  root->root_key.objectid);
-	if (IS_ERR(tsk)) {
-		btrfs_warn(fs_info, "failed to start inode caching task");
-		btrfs_clear_pending_and_info(fs_info, INODE_MAP_CACHE,
-					     "disabling inode map caching");
-	}
+	if (IS_ERR(tsk))
+		fail_caching_thread(root);
 }
 
 int btrfs_find_free_ino(struct btrfs_root *root, u64 *objectid)
@@ -200,11 +210,14 @@ int btrfs_find_free_ino(struct btrfs_root *root, u64 *objectid)
 
 	wait_event(root->ino_cache_wait,
 		   root->ino_cache_state == BTRFS_CACHE_FINISHED ||
+		   root->ino_cache_state == BTRFS_CACHE_ERROR ||
 		   root->free_ino_ctl->free_space > 0);
 
 	if (root->ino_cache_state == BTRFS_CACHE_FINISHED &&
 	    root->free_ino_ctl->free_space == 0)
 		return -ENOSPC;
+	else if (root->ino_cache_state == BTRFS_CACHE_ERROR)
+		return btrfs_find_free_objectid(root, objectid);
 	else
 		goto again;
 }
-- 
2.20.1

