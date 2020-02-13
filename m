Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C38015C551
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:55:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728033AbgBMPZp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:25:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:42106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729057AbgBMPZo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:25:44 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C15824691;
        Thu, 13 Feb 2020 15:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607544;
        bh=kGnr0UPs6HCowlTJYhTUMKgPTlFQR+OJVfe8UPgCiM0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eo5CAcIheaefnYRPg70Xktrk5YF7a8j+ajdFXxjb1t3szKveeqstZfp2rdlEoX91w
         8vub3EMDKOVmoqj2hlKHIjMQXu1Zwa6frgNtHgc/HN2BjbhEno0QRbTTHf2H1R5bKA
         pOSGpw58r1cc/+bnALN/6Ll4Gnc1Sg+Esi/9LiB8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 123/173] btrfs: free block groups after freeing fs trees
Date:   Thu, 13 Feb 2020 07:20:26 -0800
Message-Id: <20200213152003.320157962@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151931.677980430@linuxfoundation.org>
References: <20200213151931.677980430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 4e19443da1941050b346f8fc4c368aa68413bc88 ]

Sometimes when running generic/475 we would trip the
WARN_ON(cache->reserved) check when free'ing the block groups on umount.
This is because sometimes we don't commit the transaction because of IO
errors and thus do not cleanup the tree logs until at umount time.

These blocks are still reserved until they are cleaned up, but they
aren't cleaned up until _after_ we do the free block groups work.  Fix
this by moving the free after free'ing the fs roots, that way all of the
tree logs are cleaned up and we have a properly cleaned fs.  A bunch of
loops of generic/475 confirmed this fixes the problem.

CC: stable@vger.kernel.org # 4.9+
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/disk-io.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index e5b0a027c213c..6c6c15fdeef71 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3761,11 +3761,18 @@ void close_ctree(struct btrfs_fs_info *fs_info)
 	invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
 	btrfs_stop_all_workers(fs_info);
 
-	btrfs_free_block_groups(fs_info);
-
 	clear_bit(BTRFS_FS_OPEN, &fs_info->flags);
 	free_root_pointers(fs_info, true);
 
+	/*
+	 * We must free the block groups after dropping the fs_roots as we could
+	 * have had an IO error and have left over tree log blocks that aren't
+	 * cleaned up until the fs roots are freed.  This makes the block group
+	 * accounting appear to be wrong because there's pending reserved bytes,
+	 * so make sure we do the block group cleanup afterwards.
+	 */
+	btrfs_free_block_groups(fs_info);
+
 	iput(fs_info->btree_inode);
 
 #ifdef CONFIG_BTRFS_FS_CHECK_INTEGRITY
-- 
2.20.1



