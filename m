Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B53582F87A8
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 22:28:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726081AbhAOV1C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 16:27:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726063AbhAOV1A (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jan 2021 16:27:00 -0500
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 702EAC061757
        for <stable@vger.kernel.org>; Fri, 15 Jan 2021 13:26:20 -0800 (PST)
Received: by mail-qk1-x732.google.com with SMTP id 143so13086099qke.10
        for <stable@vger.kernel.org>; Fri, 15 Jan 2021 13:26:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VDhKbcgV/65GAMkqB69WL7wDM9iWs5UNRt7RJ3NENx4=;
        b=CHT8B6mGyLv8lEEblqEMjBBW5K3OoOuaNpI705I7mrReU5m86FQyHRCbRHfH3yTXPw
         +S3LCQS4jKg1ZqYAKA9GymPmaeLOU0Rz/DGFaZ7aubrkj+klIT+ZMnV+1Vy2j15hsX5L
         cKiKYCsD1JAbReCUtiGQKnW0tvNpW7tAoiZTVQkLlNRQIVCg1jV9sQas2KrqJ7V8l6yq
         jsV8yAiHN2pXyrEzxxL/EoFjd2XPzniCiXFO1nbJg34dSg+LhRSWyiREWzPiN4pS9Te2
         KHf2y18q5ULf0gEbDA9QU9ETivkwDzqFOe1MHDD/RdAVqWD/eogWwPzHfdXNzKZWObuY
         LwKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VDhKbcgV/65GAMkqB69WL7wDM9iWs5UNRt7RJ3NENx4=;
        b=J94EXTmM7f95hoZZgSElSFcHYBN6lvEBd3nimBj/yXIAhw37K8DeTaYZuf0K3aPdZT
         F0fZinWu9XC71/TRNg+x8RGaonZ7JlZxRnvqrmbLxDzMYE+kKaXX9y1BEUPMhdsy9JrN
         whrLJCLZaKURjWCCS2uKoNCynhtyZq+uBlccNMQskfzBbeA6/wZm1ek7+hveDK2spwEM
         ggLyRcbNiHDkHfOFgTpjnGj1UQ8U4jn63en75V+Ozlnz0xHK2b8Y1Wx6cx9/ufIGB6Xd
         umcg8WmOKe4rLXp7B+bYI40dzKB2lEtdPVRPX+D7xgSfcbqlt0k0qM7XA7Gcs3J3D506
         AN0g==
X-Gm-Message-State: AOAM531PvlCmRqgEp5sbO8BexBhZmQQ7UCB7Tfm7CsxG9wNBMc9ln90K
        5PbQ+a3Co14D9phjUFhAAQPdTw==
X-Google-Smtp-Source: ABdhPJzNVdr8BHicNx9Y0BIHIJQpizCJF3LcWD4mX9s6ttErcvO5fMQNrMsskY+b+oAMpPokpS1CsQ==
X-Received: by 2002:a37:5203:: with SMTP id g3mr14780618qkb.196.1610745979492;
        Fri, 15 Jan 2021 13:26:19 -0800 (PST)
Received: from localhost (cpe-174-109-172-136.nc.res.rr.com. [174.109.172.136])
        by smtp.gmail.com with ESMTPSA id r190sm5977524qka.54.2021.01.15.13.26.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 13:26:18 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Cc:     stable@vger.kernel.org
Subject: [PATCH v3] btrfs: fix possible free space tree corruption with online conversion
Date:   Fri, 15 Jan 2021 16:26:17 -0500
Message-Id: <c3b7d56951de1a9163b96a8ce90ef71b3532ec71.1610745887.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

While running btrfs/011 in a loop I would often ASSERT() while trying to
add a new free space entry that already existed, or get an -EEXIST while
adding a new block to the extent tree, which is another indication of
double allocation.

This occurs because when we do the free space tree population, we create
the new root and then populate the tree and commit the transaction.
The problem is when you create a new root, the root node and commit root
node are the same.  During this initial transaction commit we will run
all of the delayed refs that were paused during the free space tree
generation, and thus begin to cache block groups.  While caching block
groups the caching thread will be reading from the main root for the
free space tree, so as we make allocations we'll be changing the free
space tree, which can cause us to add the same range twice which results
in either the ASSERT(ret != -EEXIST); in __btrfs_add_free_space, or in a
variety of different errors when running delayed refs because of a
double allocation.

Fix this by marking the fs_info as unsafe to load the free space tree,
and fall back on the old slow method.  We could be smarter than this,
for example caching the block group while we're populating the free
space tree, but since this is a serious problem I've opted for the
simplest solution.

CC: stable@vger.kernel.org # 4.5+
Fixes: a5ed91828518 ("Btrfs: implement the free space B-tree")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
v2->v3:
- Updated the changelog to be more specific about the scenario that the problem
  happens under.
- Fixed the stable tag as well.

v1->v2:
- Dropped the UNTRUSTED bit on abort.

 fs/btrfs/block-group.c     | 11 ++++++++++-
 fs/btrfs/ctree.h           |  3 +++
 fs/btrfs/free-space-tree.c | 10 +++++++++-
 3 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 0886e81e5540..290f05e87a6b 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -673,7 +673,16 @@ static noinline void caching_thread(struct btrfs_work *work)
 		wake_up(&caching_ctl->wait);
 	}
 
-	if (btrfs_fs_compat_ro(fs_info, FREE_SPACE_TREE))
+	/*
+	 * If we are in the transaction that populated the free space tree we
+	 * can't actually cache from the free space tree as our commit root and
+	 * real root are the same, so we could change the contents of the blocks
+	 * while caching.  Instead do the slow caching in this case, and after
+	 * the transaction has committed we will be safe.
+	 */
+	if (btrfs_fs_compat_ro(fs_info, FREE_SPACE_TREE) &&
+	    !(test_bit(BTRFS_FS_FREE_SPACE_TREE_UNTRUSTED,
+		       &fs_info->flags)))
 		ret = load_free_space_tree(caching_ctl);
 	else
 		ret = load_extent_tree_free(caching_ctl);
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 1bd416e5a731..1fdb5dbe5287 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -563,6 +563,9 @@ enum {
 
 	/* Indicate that we need to cleanup space cache v1 */
 	BTRFS_FS_CLEANUP_SPACE_CACHE_V1,
+
+	/* Indicate that we can't trust the free space tree for caching yet. */
+	BTRFS_FS_FREE_SPACE_TREE_UNTRUSTED,
 };
 
 /*
diff --git a/fs/btrfs/free-space-tree.c b/fs/btrfs/free-space-tree.c
index e33a65bd9a0c..a33bca94d133 100644
--- a/fs/btrfs/free-space-tree.c
+++ b/fs/btrfs/free-space-tree.c
@@ -1150,6 +1150,7 @@ int btrfs_create_free_space_tree(struct btrfs_fs_info *fs_info)
 		return PTR_ERR(trans);
 
 	set_bit(BTRFS_FS_CREATING_FREE_SPACE_TREE, &fs_info->flags);
+	set_bit(BTRFS_FS_FREE_SPACE_TREE_UNTRUSTED, &fs_info->flags);
 	free_space_root = btrfs_create_tree(trans,
 					    BTRFS_FREE_SPACE_TREE_OBJECTID);
 	if (IS_ERR(free_space_root)) {
@@ -1171,11 +1172,18 @@ int btrfs_create_free_space_tree(struct btrfs_fs_info *fs_info)
 	btrfs_set_fs_compat_ro(fs_info, FREE_SPACE_TREE);
 	btrfs_set_fs_compat_ro(fs_info, FREE_SPACE_TREE_VALID);
 	clear_bit(BTRFS_FS_CREATING_FREE_SPACE_TREE, &fs_info->flags);
+	ret = btrfs_commit_transaction(trans);
 
-	return btrfs_commit_transaction(trans);
+	/*
+	 * Now that we've committed the transaction any reading of our commit
+	 * root will be safe, so we can cache from the free space tree now.
+	 */
+	clear_bit(BTRFS_FS_FREE_SPACE_TREE_UNTRUSTED, &fs_info->flags);
+	return ret;
 
 abort:
 	clear_bit(BTRFS_FS_CREATING_FREE_SPACE_TREE, &fs_info->flags);
+	clear_bit(BTRFS_FS_FREE_SPACE_TREE_UNTRUSTED, &fs_info->flags);
 	btrfs_abort_transaction(trans, ret);
 	btrfs_end_transaction(trans);
 	return ret;
-- 
2.26.2

