Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73597216FBE
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:10:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728297AbgGGPK2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:10:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:51172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727079AbgGGPK2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:10:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B7D0C2065D;
        Tue,  7 Jul 2020 15:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594134627;
        bh=GL5nhFaRBauCRdVfxtFt481dnkBXq785LVUnOEJ2fbU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=unekjo5WJ5jtAHmc0BJHYS2nrU9SEqaQ44nQ0lWyzKMbe8YvzAdHc194rKRzcDQzu
         AiZu8o2Bskcn2T0/UVydiKuzE678WWYLeSJ3/be8cGu5V7Ya3ztZB/Jli2XypnMy4A
         MKS4302bN6P6VfQRgZUq6BrV0nzq6R+NZi9N0ong=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anand Jain <anand.jain@oracle.com>,
        Nikolay Borisov <nborisov@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 01/19] btrfs: cow_file_range() num_bytes and disk_num_bytes are same
Date:   Tue,  7 Jul 2020 17:10:04 +0200
Message-Id: <20200707145747.560292041@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145747.493710555@linuxfoundation.org>
References: <20200707145747.493710555@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anand Jain <Anand.Jain@oracle.com>

[ Upstream commit 3752d22fcea160cc2493e34f5e0e41cdd7fdd921 ]

This patch deletes local variable disk_num_bytes as its value
is same as num_bytes in the function cow_file_range().

Signed-off-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/inode.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 972475eeb2dd0..ef8ed0cd8075a 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -926,7 +926,6 @@ static noinline int cow_file_range(struct inode *inode,
 	u64 alloc_hint = 0;
 	u64 num_bytes;
 	unsigned long ram_size;
-	u64 disk_num_bytes;
 	u64 cur_alloc_size;
 	u64 blocksize = root->sectorsize;
 	struct btrfs_key ins;
@@ -942,7 +941,6 @@ static noinline int cow_file_range(struct inode *inode,
 
 	num_bytes = ALIGN(end - start + 1, blocksize);
 	num_bytes = max(blocksize,  num_bytes);
-	disk_num_bytes = num_bytes;
 
 	/* if this is a small write inside eof, kick off defrag */
 	if (num_bytes < 64 * 1024 &&
@@ -969,16 +967,15 @@ static noinline int cow_file_range(struct inode *inode,
 		}
 	}
 
-	BUG_ON(disk_num_bytes >
-	       btrfs_super_total_bytes(root->fs_info->super_copy));
+	BUG_ON(num_bytes > btrfs_super_total_bytes(root->fs_info->super_copy));
 
 	alloc_hint = get_extent_allocation_hint(inode, start, num_bytes);
 	btrfs_drop_extent_cache(inode, start, start + num_bytes - 1, 0);
 
-	while (disk_num_bytes > 0) {
+	while (num_bytes > 0) {
 		unsigned long op;
 
-		cur_alloc_size = disk_num_bytes;
+		cur_alloc_size = num_bytes;
 		ret = btrfs_reserve_extent(root, cur_alloc_size,
 					   root->sectorsize, 0, alloc_hint,
 					   &ins, 1, 1);
@@ -1033,7 +1030,7 @@ static noinline int cow_file_range(struct inode *inode,
 				goto out_drop_extent_cache;
 		}
 
-		if (disk_num_bytes < cur_alloc_size)
+		if (num_bytes < cur_alloc_size)
 			break;
 
 		/* we're not doing compressed IO, don't unlock the first
@@ -1050,8 +1047,10 @@ static noinline int cow_file_range(struct inode *inode,
 					     start + ram_size - 1, locked_page,
 					     EXTENT_LOCKED | EXTENT_DELALLOC,
 					     op);
-		disk_num_bytes -= cur_alloc_size;
-		num_bytes -= cur_alloc_size;
+		if (num_bytes < cur_alloc_size)
+			num_bytes = 0;
+		else
+			num_bytes -= cur_alloc_size;
 		alloc_hint = ins.objectid + ins.offset;
 		start += cur_alloc_size;
 	}
-- 
2.25.1



