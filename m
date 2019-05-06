Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 938E014D81
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 16:53:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727127AbfEFOvu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:51:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:49656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729526AbfEFOsu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:48:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 949AF216C8;
        Mon,  6 May 2019 14:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557154130;
        bh=aSyAWG8LsqQfGujCDwDQLGJGjglE3ZS5g8PrN4g0IvI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cunBraeAQ/QBf4mTaPliKhNsisu/C9clktfTB6HnC9sRFVvbauRL3pdh1u9M2ypv5
         BFhaidS2tmmN1k/1nKUeibxq+JEgocfbhjhYGRjjKybR3Vfqm0Del7X7CZ4ymZYSqq
         c0CPd3KOhZrdn2TCHbqG2JxxWkqdNlYoeP8oDPxw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Kravetz <mike.kravetz@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yufen Yu <yuyufen@huawei.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 49/62] hugetlbfs: fix memory leak for resv_map
Date:   Mon,  6 May 2019 16:33:20 +0200
Message-Id: <20190506143055.514093182@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143051.102535767@linuxfoundation.org>
References: <20190506143051.102535767@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 58b6e5e8f1addd44583d61b0a03c0f5519527e35 ]

When mknod is used to create a block special file in hugetlbfs, it will
allocate an inode and kmalloc a 'struct resv_map' via resv_map_alloc().
inode->i_mapping->private_data will point the newly allocated resv_map.
However, when the device special file is opened bd_acquire() will set
inode->i_mapping to bd_inode->i_mapping.  Thus the pointer to the
allocated resv_map is lost and the structure is leaked.

Programs to reproduce:
        mount -t hugetlbfs nodev hugetlbfs
        mknod hugetlbfs/dev b 0 0
        exec 30<> hugetlbfs/dev
        umount hugetlbfs/

resv_map structures are only needed for inodes which can have associated
page allocations.  To fix the leak, only allocate resv_map for those
inodes which could possibly be associated with page allocations.

Link: http://lkml.kernel.org/r/20190401213101.16476-1-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Yufen Yu <yuyufen@huawei.com>
Suggested-by: Yufen Yu <yuyufen@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/hugetlbfs/inode.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 001487b230b5..4acc677ac8fb 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -746,11 +746,17 @@ static struct inode *hugetlbfs_get_inode(struct super_block *sb,
 					umode_t mode, dev_t dev)
 {
 	struct inode *inode;
-	struct resv_map *resv_map;
+	struct resv_map *resv_map = NULL;
 
-	resv_map = resv_map_alloc();
-	if (!resv_map)
-		return NULL;
+	/*
+	 * Reserve maps are only needed for inodes that can have associated
+	 * page allocations.
+	 */
+	if (S_ISREG(mode) || S_ISLNK(mode)) {
+		resv_map = resv_map_alloc();
+		if (!resv_map)
+			return NULL;
+	}
 
 	inode = new_inode(sb);
 	if (inode) {
@@ -782,8 +788,10 @@ static struct inode *hugetlbfs_get_inode(struct super_block *sb,
 			break;
 		}
 		lockdep_annotate_inode_mutex_key(inode);
-	} else
-		kref_put(&resv_map->refs, resv_map_release);
+	} else {
+		if (resv_map)
+			kref_put(&resv_map->refs, resv_map_release);
+	}
 
 	return inode;
 }
-- 
2.20.1



