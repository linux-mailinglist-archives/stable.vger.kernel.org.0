Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB5E25FB5C2
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 16:57:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230101AbiJKO5e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 10:57:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiJKO4b (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 10:56:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C888B9C7D9;
        Tue, 11 Oct 2022 07:52:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 84E4F61166;
        Tue, 11 Oct 2022 14:52:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35A3AC433B5;
        Tue, 11 Oct 2022 14:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665499930;
        bh=56MpE/2gqJCki0xuTIRAy8hj5fU5wmOZT9wlOM39ins=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UDXCioXfWLrF39PmX9LR7vtuFCbHHJbFREqo/RMD8o5u/I6Nh3UOixQpVhvki3mBL
         Q1f+/Civ+Uq3qxuCtCaNCTuF3qSKADRQOcmlOMbpgkwnWdDEvasVvUeHl8IpxOCzjJ
         f+GpcunnBCdS02YbGV6XQQZH59h5LgeMUtZJSCY7P0G7BNU548UegRUEai7SUZCwAZ
         UyAoqBEWGc0xRqYxiLDc7jU/cEcOuDmqKDz2LTdsL7G0PUFiYcCBWSIyJP4kPcBAIE
         Zc1AOKhcnmcI9CbMmLlOmD7C3LL95XvuCyftWtb6x9bOJgLatQI9eRRica9fRXV3A9
         sNKLcqPCILh0Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ioannis Angelakopoulos <iangelak@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, clm@fb.com,
        linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 25/40] btrfs: change the lockdep class of free space inode's invalidate_lock
Date:   Tue, 11 Oct 2022 10:51:14 -0400
Message-Id: <20221011145129.1623487-25-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221011145129.1623487-1-sashal@kernel.org>
References: <20221011145129.1623487-1-sashal@kernel.org>
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
index 16710d4571da..d9577f822ba5 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -920,6 +920,8 @@ static int copy_free_space_cache(struct btrfs_block_group *block_group,
 	return ret;
 }
 
+static struct lock_class_key btrfs_free_space_inode_key;
+
 int load_free_space_cache(struct btrfs_block_group *block_group)
 {
 	struct btrfs_fs_info *fs_info = block_group->fs_info;
@@ -989,6 +991,14 @@ int load_free_space_cache(struct btrfs_block_group *block_group)
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

