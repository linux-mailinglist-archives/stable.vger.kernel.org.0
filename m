Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 896F01482D6
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:31:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389694AbgAXLbI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:31:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:49344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404350AbgAXLbI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:31:08 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4309A2075D;
        Fri, 24 Jan 2020 11:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865468;
        bh=qBy10GwiHxxrTchsy5KGZbQHHllW6jypUlDAg+wW/i8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bdwBluFXubPN03ozewsWl+FJMMlywaWi61X2FS6YbSlWv1YuZSmIvL7vWt1pY8u1F
         1LJ0TUsW2oK3S2wT1Kua2wJucb87LrXS0sQuWnQ7EG6GckqF6VylSHfOHvin3EsP9C
         d9091ACcC6+B3sEHLSiZJspClAQ2m5jnVwg3wXnA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 554/639] Btrfs: fix inode cache waiters hanging on failure to start caching thread
Date:   Fri, 24 Jan 2020 10:32:04 +0100
Message-Id: <20200124093158.625955797@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index b3bd270706176..7c4d0107c6fb9 100644
--- a/fs/btrfs/inode-map.c
+++ b/fs/btrfs/inode-map.c
@@ -12,6 +12,19 @@
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
@@ -164,11 +177,8 @@ static void start_caching(struct btrfs_root *root)
 
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
@@ -186,11 +196,14 @@ again:
 
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



