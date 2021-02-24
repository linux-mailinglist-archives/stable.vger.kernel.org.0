Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F4F9323DA6
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 14:19:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236190AbhBXNOI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 08:14:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:58408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235793AbhBXNG6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 08:06:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7187164F87;
        Wed, 24 Feb 2021 12:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171263;
        bh=YTCBPefOUoG89KtBq5r6rrPr10r8HCEbcZB1j4fUuLo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DQrgssfRQlBJBh7yORUs7Lx6rYYxwzaRTA+1WqXvZflZJh3+rZeLNDPDH9iCnA0yD
         su/9ClXWfNqufFqI4ppugiG4SUImQKtWpAi0odbZNfRf0PVMrXdxD1aM3bXjE86xtV
         USaTVYaa2GYskn2I9EcuGUSzIVAkvQjgQ6hI+nPj8JHINEnH+WgXgvXLpUC87c71cN
         BC78utZei6VhCTtYZuXOMGpJGUSMjevpohlmbt3AITG8c6wPA1Uk/qznq9hLxN9maG
         aag6PD2B+19EU2yuLg2/ou8WPY6idLmrLGhHMdJwf8O5zSPq1dIklkOMNAjkl27SkR
         kYlD/VaJO4hFA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 32/40] btrfs: fix error handling in commit_fs_roots
Date:   Wed, 24 Feb 2021 07:53:32 -0500
Message-Id: <20210224125340.483162-32-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210224125340.483162-1-sashal@kernel.org>
References: <20210224125340.483162-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 4f4317c13a40194940acf4a71670179c4faca2b5 ]

While doing error injection I would sometimes get a corrupt file system.
This is because I was injecting errors at btrfs_search_slot, but would
only do it one time per stack.  This uncovered a problem in
commit_fs_roots, where if we get an error we would just break.  However
we're in a nested loop, the first loop being a loop to find all the
dirty fs roots, and then subsequent root updates would succeed clearing
the error value.

This isn't likely to happen in real scenarios, however we could
potentially get a random ENOMEM once and then not again, and we'd end up
with a corrupted file system.  Fix this by moving the error checking
around a bit to the main loop, as this is the only place where something
will fail, and return the error as soon as it occurs.

With this patch my reproducer no longer corrupts the file system.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/transaction.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index c346ee7ec18d4..aca6c467d7761 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1212,7 +1212,6 @@ static noinline int commit_fs_roots(struct btrfs_trans_handle *trans)
 	struct btrfs_root *gang[8];
 	int i;
 	int ret;
-	int err = 0;
 
 	spin_lock(&fs_info->fs_roots_radix_lock);
 	while (1) {
@@ -1224,6 +1223,8 @@ static noinline int commit_fs_roots(struct btrfs_trans_handle *trans)
 			break;
 		for (i = 0; i < ret; i++) {
 			struct btrfs_root *root = gang[i];
+			int ret2;
+
 			radix_tree_tag_clear(&fs_info->fs_roots_radix,
 					(unsigned long)root->root_key.objectid,
 					BTRFS_ROOT_TRANS_TAG);
@@ -1245,17 +1246,17 @@ static noinline int commit_fs_roots(struct btrfs_trans_handle *trans)
 						    root->node);
 			}
 
-			err = btrfs_update_root(trans, fs_info->tree_root,
+			ret2 = btrfs_update_root(trans, fs_info->tree_root,
 						&root->root_key,
 						&root->root_item);
+			if (ret2)
+				return ret2;
 			spin_lock(&fs_info->fs_roots_radix_lock);
-			if (err)
-				break;
 			btrfs_qgroup_free_meta_all_pertrans(root);
 		}
 	}
 	spin_unlock(&fs_info->fs_roots_radix_lock);
-	return err;
+	return 0;
 }
 
 /*
-- 
2.27.0

