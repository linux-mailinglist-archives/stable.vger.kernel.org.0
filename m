Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA4685FB54C
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 16:53:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230061AbiJKOxJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 10:53:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230062AbiJKOwU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 10:52:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F42159A9E3;
        Tue, 11 Oct 2022 07:51:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF271611C1;
        Tue, 11 Oct 2022 14:51:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C587C433B5;
        Tue, 11 Oct 2022 14:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665499862;
        bh=jw6kVGx12KhxtP8Erz7CrOz0ABEzDOjQ3XnV4ZUu7jM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U6cTMEgs8/MRyjaedKuvFlmQK3Z7heJbJVa3JQyrgg6SoULYR8rE9nVTAzr5r/NLB
         XVOMEfhpfYY7URegniua5MR3ijRYUxaAkiNhm02MpKKDqWYO7r/lSaFRZovT1HpF2+
         uNJ0Y8baV4GPSlFnbbNt9lmyjpsW90T4rPMZk9s+U/5m00XjOKbcF59vRLosRazkLZ
         /4dmWhmpjYU55KofDUOR1RxtAhsy7EzzNOROprnx6CjM6o/L4jxnScocZaIdUSJJin
         Q2wUUi743gc/Wdd81W89BCCc4gt2ir+nTxN0nh6Dwjs9k9k6RWuVTqGk1mYdhuJAvG
         VPCruJ7ZdX5Dg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ioannis Angelakopoulos <iangelak@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, clm@fb.com,
        linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 29/46] btrfs: change the lockdep class of free space inode's invalidate_lock
Date:   Tue, 11 Oct 2022 10:49:57 -0400
Message-Id: <20221011145015.1622882-29-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221011145015.1622882-1-sashal@kernel.org>
References: <20221011145015.1622882-1-sashal@kernel.org>
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
index 85404c62a1c2..835071fa39a9 100644
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

