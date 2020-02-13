Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD1FB15C559
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:55:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387502AbgBMPy7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:54:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:42172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729056AbgBMPZo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:25:44 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7828724690;
        Thu, 13 Feb 2020 15:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607543;
        bh=zP+adKrei6jHibZpmHN03lLdIxC8j7nYlluJFloj5Z0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=On6lAxxeTLRKVJxpip3JOZHMHDRE1yAYr09twffUOwCyRI8TAZ5ec0AAqns5mX8Tm
         yOK1FRZajjQLgTqMr7HwgKY35iojugXS0/auavVeKEb86SVgXiTXrTG6jnSESLUiJX
         PQECYHguPzrUEoLM6J96U18+kCHUdtGn9okUwwqs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        Anand Jain <anand.jain@oracle.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 122/173] btrfs: use bool argument in free_root_pointers()
Date:   Thu, 13 Feb 2020 07:20:25 -0800
Message-Id: <20200213152003.104418292@linuxfoundation.org>
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
index a8ea56218d6b6..e5b0a027c213c 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2051,7 +2051,7 @@ static void free_root_extent_buffers(struct btrfs_root *root)
 }
 
 /* helper to cleanup tree roots */
-static void free_root_pointers(struct btrfs_fs_info *info, int chunk_root)
+static void free_root_pointers(struct btrfs_fs_info *info, bool free_chunk_root)
 {
 	free_root_extent_buffers(info->tree_root);
 
@@ -2060,7 +2060,7 @@ static void free_root_pointers(struct btrfs_fs_info *info, int chunk_root)
 	free_root_extent_buffers(info->csum_root);
 	free_root_extent_buffers(info->quota_root);
 	free_root_extent_buffers(info->uuid_root);
-	if (chunk_root)
+	if (free_chunk_root)
 		free_root_extent_buffers(info->chunk_root);
 	free_root_extent_buffers(info->free_space_root);
 }
@@ -3069,7 +3069,7 @@ int open_ctree(struct super_block *sb,
 	btrfs_put_block_group_cache(fs_info);
 
 fail_tree_roots:
-	free_root_pointers(fs_info, 1);
+	free_root_pointers(fs_info, true);
 	invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
 
 fail_sb_buffer:
@@ -3097,7 +3097,7 @@ int open_ctree(struct super_block *sb,
 	if (!btrfs_test_opt(fs_info, USEBACKUPROOT))
 		goto fail_tree_roots;
 
-	free_root_pointers(fs_info, 0);
+	free_root_pointers(fs_info, false);
 
 	/* don't use the log in recovery mode, it won't be valid */
 	btrfs_set_super_log_root(disk_super, 0);
@@ -3764,7 +3764,7 @@ void close_ctree(struct btrfs_fs_info *fs_info)
 	btrfs_free_block_groups(fs_info);
 
 	clear_bit(BTRFS_FS_OPEN, &fs_info->flags);
-	free_root_pointers(fs_info, 1);
+	free_root_pointers(fs_info, true);
 
 	iput(fs_info->btree_inode);
 
-- 
2.20.1



