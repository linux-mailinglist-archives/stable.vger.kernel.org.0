Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65B111574E0
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:38:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727803AbgBJMge (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:36:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:55878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728429AbgBJMge (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:36:34 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C3DEB20661;
        Mon, 10 Feb 2020 12:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338193;
        bh=io37CtxpcxYVCGqUBrxjjsavdxhBcKnT/OpkX6gQAJk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C3yS6g8XY8k9x6FUae+SNSrf4KdA/n6ypBECEWb6rcj3oYS1Okb16UOCFMKcV+pSS
         O8xREiaU0n+6E6SJqpJFOPSsHUSTFGSed5u1wjlAWm1+hVVmUqJGEp0NEbhwQ4y74t
         QM6h5cehbgArDbn4mEAO4idL0edUBFF+25O5/qks=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        Anand Jain <anand.jain@oracle.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 177/195] btrfs: use bool argument in free_root_pointers()
Date:   Mon, 10 Feb 2020 04:33:55 -0800
Message-Id: <20200210122322.455191783@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122305.731206734@linuxfoundation.org>
References: <20200210122305.731206734@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anand Jain <anand.jain@oracle.com>

[ Upstream commit 4273eaff9b8d5e141113a5bdf9628c02acf3afe5 ]

We don't need int argument bool shall do in free_root_pointers().  And
rename the argument as it confused two people.

Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/disk-io.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 15212e835e02c..d296ea329bd4e 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2031,7 +2031,7 @@ static void free_root_extent_buffers(struct btrfs_root *root)
 }
 
 /* helper to cleanup tree roots */
-static void free_root_pointers(struct btrfs_fs_info *info, int chunk_root)
+static void free_root_pointers(struct btrfs_fs_info *info, bool free_chunk_root)
 {
 	free_root_extent_buffers(info->tree_root);
 
@@ -2040,7 +2040,7 @@ static void free_root_pointers(struct btrfs_fs_info *info, int chunk_root)
 	free_root_extent_buffers(info->csum_root);
 	free_root_extent_buffers(info->quota_root);
 	free_root_extent_buffers(info->uuid_root);
-	if (chunk_root)
+	if (free_chunk_root)
 		free_root_extent_buffers(info->chunk_root);
 	free_root_extent_buffers(info->free_space_root);
 }
@@ -3273,7 +3273,7 @@ int open_ctree(struct super_block *sb,
 	btrfs_put_block_group_cache(fs_info);
 
 fail_tree_roots:
-	free_root_pointers(fs_info, 1);
+	free_root_pointers(fs_info, true);
 	invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
 
 fail_sb_buffer:
@@ -3301,7 +3301,7 @@ int open_ctree(struct super_block *sb,
 	if (!btrfs_test_opt(fs_info, USEBACKUPROOT))
 		goto fail_tree_roots;
 
-	free_root_pointers(fs_info, 0);
+	free_root_pointers(fs_info, false);
 
 	/* don't use the log in recovery mode, it won't be valid */
 	btrfs_set_super_log_root(disk_super, 0);
@@ -3986,7 +3986,7 @@ void close_ctree(struct btrfs_fs_info *fs_info)
 	btrfs_free_block_groups(fs_info);
 
 	clear_bit(BTRFS_FS_OPEN, &fs_info->flags);
-	free_root_pointers(fs_info, 1);
+	free_root_pointers(fs_info, true);
 
 	iput(fs_info->btree_inode);
 
-- 
2.20.1



