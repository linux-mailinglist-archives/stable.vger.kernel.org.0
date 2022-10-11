Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA6205FB747
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 17:32:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230458AbiJKPcA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 11:32:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230515AbiJKPbf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 11:31:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1790AAE214;
        Tue, 11 Oct 2022 08:21:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9DEE6B8160D;
        Tue, 11 Oct 2022 14:53:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F7AFC433D7;
        Tue, 11 Oct 2022 14:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665499980;
        bh=qCCQDJV4MDq7Ys5QWkmIcDTZEvK17HR7pBaG2uA5NDU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cMR8vrT5e2YYSVS+l9vUVIAdeC8kGDdW++MG5IeljrHM0+F3b2zSvL9GbyiRAMy1a
         pPn7hRxKeM5I4xGu37QjQy5sRiRxOdnal8FLxMKcMYIW2OCN15P5PXhv8lnh1CtgfP
         OFnqCV30m36wLHCK/IqP+LqiY5udFNsOzdx5ltR1TBXK1keRI6qA57QNfnr4VtK1eX
         F7n0xqgWE7RD3+ICvqRt2z8r6Ke4y34OKdre2iarf9hDfyIkZVBUHJmaaJJAIx6wYe
         OXym6NV0fjItcYJfqtIDFXG+tZAsZHMzGLZW8jDUYSxa9Lcrlz26xkYyn9ezlVnoEj
         Us1ICJwb+fQxQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ioannis Angelakopoulos <iangelak@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, clm@fb.com,
        linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 18/26] btrfs: change the lockdep class of free space inode's invalidate_lock
Date:   Tue, 11 Oct 2022 10:52:25 -0400
Message-Id: <20221011145233.1624013-18-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221011145233.1624013-1-sashal@kernel.org>
References: <20221011145233.1624013-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ioannis Angelakopoulos <iangelak@fb.com>

[ Upstream commit 9d7464c87b159bbf763c24faeb7a2dcaac96e4a1 ]

Reinitialize the class of the lockdep map for struct inode's
mapping->invalidate_lock in load_free_space_cache() function in
fs/btrfs/free-space-cache.c. This will prevent lockdep from producing
false positives related to execution paths that make use of free space
inodes and paths that make use of normal inodes.

Specifically, with this change lockdep will create separate lock
dependencies that include the invalidate_lock, in the case that free
space inodes are used and in the case that normal inodes are used.

The lockdep class for this lock was first initialized in
inode_init_always() in fs/inode.c.

Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Ioannis Angelakopoulos <iangelak@fb.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/free-space-cache.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 529907ea3825..456da08feccd 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -899,6 +899,8 @@ static int copy_free_space_cache(struct btrfs_block_group *block_group,
 	return ret;
 }
 
+static struct lock_class_key btrfs_free_space_inode_key;
+
 int load_free_space_cache(struct btrfs_block_group *block_group)
 {
 	struct btrfs_fs_info *fs_info = block_group->fs_info;
@@ -968,6 +970,14 @@ int load_free_space_cache(struct btrfs_block_group *block_group)
 	}
 	spin_unlock(&block_group->lock);
 
+	/*
+	 * Reinitialize the class of struct inode's mapping->invalidate_lock for
+	 * free space inodes to prevent false positives related to locks for normal
+	 * inodes.
+	 */
+	lockdep_set_class(&(&inode->i_data)->invalidate_lock,
+			  &btrfs_free_space_inode_key);
+
 	ret = __load_free_space_cache(fs_info->tree_root, inode, &tmp_ctl,
 				      path, block_group->start);
 	btrfs_free_path(path);
-- 
2.35.1

