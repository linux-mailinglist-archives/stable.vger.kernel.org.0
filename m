Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E404C216FFA
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728349AbgGGPOH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:14:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:53266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728346AbgGGPOH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:14:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4923220663;
        Tue,  7 Jul 2020 15:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594134846;
        bh=3mbvT9HzVHW218yxXDm/nZ4vmbiwkca2u22CcSJXKYc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AyXlJmmdnHkoGD2k3+kwrpvCft+kVaFniHbhBX22J1Sv1Nsb2OVw8DkR+wvUzaHVq
         fRcN+OAaQw6WAUkBrvvL4tAQ1O3cy4I82xeGDhBnr8b97qxwFpukNaJWLS3cLmlSrp
         VwUW6kKCRzRbjOYzZHPwcy3337u+llzhq+SVmyVg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anand Jain <anand.jain@oracle.com>,
        Nikolay Borisov <nborisov@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 02/24] btrfs: cow_file_range() num_bytes and disk_num_bytes are same
Date:   Tue,  7 Jul 2020 17:13:34 +0200
Message-Id: <20200707145749.070771994@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145748.952502272@linuxfoundation.org>
References: <20200707145748.952502272@linuxfoundation.org>
User-Agent: quilt/0.66
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
index c425443c31fea..6d63050abe214 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -947,7 +947,6 @@ static noinline int cow_file_range(struct inode *inode,
 	u64 alloc_hint = 0;
 	u64 num_bytes;
 	unsigned long ram_size;
-	u64 disk_num_bytes;
 	u64 cur_alloc_size;
 	u64 blocksize = root->sectorsize;
 	struct btrfs_key ins;
@@ -963,7 +962,6 @@ static noinline int cow_file_range(struct inode *inode,
 
 	num_bytes = ALIGN(end - start + 1, blocksize);
 	num_bytes = max(blocksize,  num_bytes);
-	disk_num_bytes = num_bytes;
 
 	/* if this is a small write inside eof, kick off defrag */
 	if (num_bytes < SZ_64K &&
@@ -992,16 +990,15 @@ static noinline int cow_file_range(struct inode *inode,
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
 		ret = btrfs_reserve_extent(root, cur_alloc_size, cur_alloc_size,
 					   root->sectorsize, 0, alloc_hint,
 					   &ins, 1, 1);
@@ -1058,7 +1055,7 @@ static noinline int cow_file_range(struct inode *inode,
 
 		btrfs_dec_block_group_reservations(root->fs_info, ins.objectid);
 
-		if (disk_num_bytes < cur_alloc_size)
+		if (num_bytes < cur_alloc_size)
 			break;
 
 		/* we're not doing compressed IO, don't unlock the first
@@ -1076,8 +1073,10 @@ static noinline int cow_file_range(struct inode *inode,
 					     delalloc_end, locked_page,
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



