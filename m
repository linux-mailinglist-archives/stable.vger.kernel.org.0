Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 920D02D4B7C
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 21:19:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388162AbgLIUSN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 15:18:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388192AbgLIUSM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Dec 2020 15:18:12 -0500
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40542C0613CF
        for <stable@vger.kernel.org>; Wed,  9 Dec 2020 12:17:32 -0800 (PST)
Received: by mail-qk1-x743.google.com with SMTP id 19so2561631qkm.8
        for <stable@vger.kernel.org>; Wed, 09 Dec 2020 12:17:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qu3JMv0vupZJs2S1Ty+ZOmfqDK5t5WOYD76k4nOTMzw=;
        b=SorrNaWZhBePFgRTpRj8CJ/KjtL/Lj988+BuIeCcAH1PRgjH9VbBYCFhLim7tC/OHz
         4uiGeTh7JCrn7Jf4ZNgxfISsHtZSnPg8iIaXjEcOho+rVVy3xvPBgAv7Qp56bLGjpKRa
         m8qgOJ7zQ+N/EPb/QwqoSyON7pGn+oA4dQ7rfA4ShXJ4C2J1ULbOdzQZAhTCi+mnfMtu
         bfFv7bCioWdP5d7f8oorCmqf9k8LgOfngdTfry6wOvIIcE4AcpOsTNf22dBD7W42T87I
         xVkU2HvEzDI4kSS9AHEJny9nKXod/B0yYP18+VFxbj9o/iWhqtQPWz5Q87CxBHtECP1+
         lWCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qu3JMv0vupZJs2S1Ty+ZOmfqDK5t5WOYD76k4nOTMzw=;
        b=OVg0nOrXU3xmpSXF69HGZfHEm6EQC9u+7uMTKQ6wT4LBdr9CYaTvZgPfxZf2gS4Ies
         tEq+xVKfkWwbP7NfHWkCB+gXjCFk80pQ7kngI9Bp/MIvQt6n5BeknLpe4EYNkX/uW0z/
         ILUM8MmuiJMZCI6CZLD8p5YTbEoKdRtjMeaaU9HA23UpdaWHrvoYTG1dKSohhQn6ipPW
         w/ftcrZgU27Fo9SZ5bsOAuQp+Xm9gMhfopmbCVdOznOcVfxWRCN9yUmR91rfSjsA/L4A
         dMCmKv7wUEW+Z57M6E9KwXMegHdsp+wSfbzGT1zN02VfZnyPIBrBEooTJWWnlSfM2w99
         NOfw==
X-Gm-Message-State: AOAM531rp9gGFPe74TT4V/OoL1w6YXoHEZi/sQNk40j5UqkOrqQKdBe3
        PWq+mKA/wOUOn/suo1Bj72UDzg==
X-Google-Smtp-Source: ABdhPJznVGDmZ9w+LUIdiJB6L3cB7i49loygudiEe3UQ3vyZiV+m33J/1eT10Rq4SlwG6hIqRikeiQ==
X-Received: by 2002:a37:b342:: with SMTP id c63mr4999354qkf.146.1607545051316;
        Wed, 09 Dec 2020 12:17:31 -0800 (PST)
Received: from localhost (cpe-174-109-172-136.nc.res.rr.com. [174.109.172.136])
        by smtp.gmail.com with ESMTPSA id n9sm1716565qti.75.2020.12.09.12.17.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Dec 2020 12:17:30 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Cc:     stable@vger.kernel.org
Subject: [PATCH] btrfs: fix possible free space tree corruption with online conversion
Date:   Wed,  9 Dec 2020 15:17:29 -0500
Message-Id: <0d49d6227962f3f3d34b6c7ccfd0c330f98517af.1607545035.git.josef@toxicpanda.com>
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
node are the same.  This means that caching a block group before the
transaction is committed can race with other operations modifying the
free space tree, and thus you can get double adds and other sort of
shenanigans.  This is only a problem for the first transaction, once
we've committed the transaction we created the free space tree in we're
OK to use the free space tree to cache block groups.

Fix this by marking the fs_info as unsafe to load the free space tree,
and fall back on the old slow method.  We could be smarter than this,
for example caching the block group while we're populating the free
space tree, but since this is a serious problem I've opted for the
simplest solution.

cc: stable@vger.kernel.org
Fixes: a5ed91828518 ("Btrfs: implement the free space B-tree")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/block-group.c     | 11 ++++++++++-
 fs/btrfs/ctree.h           |  3 +++
 fs/btrfs/free-space-tree.c |  9 ++++++++-
 3 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 52f2198d44c9..b8bbdd95743e 100644
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
index 3935d297d198..4a60d81da5cb 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -562,6 +562,9 @@ enum {
 
 	/* Indicate that we need to cleanup space cache v1 */
 	BTRFS_FS_CLEANUP_SPACE_CACHE_V1,
+
+	/* Indicate that we can't trust the free space tree for caching yet. */
+	BTRFS_FS_FREE_SPACE_TREE_UNTRUSTED,
 };
 
 /*
diff --git a/fs/btrfs/free-space-tree.c b/fs/btrfs/free-space-tree.c
index e33a65bd9a0c..8fbda221f4b5 100644
--- a/fs/btrfs/free-space-tree.c
+++ b/fs/btrfs/free-space-tree.c
@@ -1150,6 +1150,7 @@ int btrfs_create_free_space_tree(struct btrfs_fs_info *fs_info)
 		return PTR_ERR(trans);
 
 	set_bit(BTRFS_FS_CREATING_FREE_SPACE_TREE, &fs_info->flags);
+	set_bit(BTRFS_FS_FREE_SPACE_TREE_UNTRUSTED, &fs_info->flags);
 	free_space_root = btrfs_create_tree(trans,
 					    BTRFS_FREE_SPACE_TREE_OBJECTID);
 	if (IS_ERR(free_space_root)) {
@@ -1171,8 +1172,14 @@ int btrfs_create_free_space_tree(struct btrfs_fs_info *fs_info)
 	btrfs_set_fs_compat_ro(fs_info, FREE_SPACE_TREE);
 	btrfs_set_fs_compat_ro(fs_info, FREE_SPACE_TREE_VALID);
 	clear_bit(BTRFS_FS_CREATING_FREE_SPACE_TREE, &fs_info->flags);
+	ret = btrfs_commit_transaction(trans);
 
-	return btrfs_commit_transaction(trans);
+	/*
+	 * Now that we've committed the transaction any reading of our commit
+	 * root will be safe, so we can caching from the free space tree now.
+	 */
+	clear_bit(BTRFS_FS_FREE_SPACE_TREE_UNTRUSTED, &fs_info->flags);
+	return ret;
 
 abort:
 	clear_bit(BTRFS_FS_CREATING_FREE_SPACE_TREE, &fs_info->flags);
-- 
2.26.2

