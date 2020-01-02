Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E2C112EC2C
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:16:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727609AbgABWP6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:15:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:57464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728167AbgABWP5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:15:57 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4015222314;
        Thu,  2 Jan 2020 22:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003356;
        bh=XZ1U8JnRfsOdge9C/Nkv34u0lxhGTLvWnD34+oshmKE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TVk4Zdk9OylCB9BbYjLIMwFbgCkdH+5uz4lSC8Y/b/r1beS8WD9hG8uH5YpWMsiYI
         pZwxsNnycnpAKEqO4Px79T7/RfSNCJjfRBE9OCyOav2+PDosnkY1fTZ9Fzjd271g4s
         tz7ppgenYsV3B/hvXu8EyXpCLQY8NOu94NBo9mjo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chengguang Xu <cgxu519@mykernel.net>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        David Howells <dhowells@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 127/191] mm/hugetlbfs: fix error handling when setting up mounts
Date:   Thu,  2 Jan 2020 23:06:49 +0100
Message-Id: <20200102215843.357330718@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102215829.911231638@linuxfoundation.org>
References: <20200102215829.911231638@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Kravetz <mike.kravetz@oracle.com>

[ Upstream commit 8fc312b32b25c6b0a8b46fab4df8c68df5af1223 ]

It is assumed that the hugetlbfs_vfsmount[] array will contain either a
valid vfsmount pointer or NULL for each hstate after initialization.
Changes made while converting to use fs_context broke this assumption.

While fixing the hugetlbfs_vfsmount issue, it was discovered that
init_hugetlbfs_fs never did correctly clean up when encountering a vfs
mount error.

It was found during code inspection.  A small memory allocation failure
would be the most likely cause of taking a error path with the bug.
This is unlikely to happen as this is early init code.

Link: http://lkml.kernel.org/r/94b6244d-2c24-e269-b12c-e3ba694b242d@oracle.com
Reported-by: Chengguang Xu <cgxu519@mykernel.net>
Fixes: 32021982a324 ("hugetlbfs: Convert to fs_context")
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/hugetlbfs/inode.c | 31 ++++++++++++++++++++++---------
 1 file changed, 22 insertions(+), 9 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index a478df035651..26e3906c18fe 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -1461,28 +1461,41 @@ static int __init init_hugetlbfs_fs(void)
 					sizeof(struct hugetlbfs_inode_info),
 					0, SLAB_ACCOUNT, init_once);
 	if (hugetlbfs_inode_cachep == NULL)
-		goto out2;
+		goto out;
 
 	error = register_filesystem(&hugetlbfs_fs_type);
 	if (error)
-		goto out;
+		goto out_free;
 
+	/* default hstate mount is required */
+	mnt = mount_one_hugetlbfs(&hstates[default_hstate_idx]);
+	if (IS_ERR(mnt)) {
+		error = PTR_ERR(mnt);
+		goto out_unreg;
+	}
+	hugetlbfs_vfsmount[default_hstate_idx] = mnt;
+
+	/* other hstates are optional */
 	i = 0;
 	for_each_hstate(h) {
+		if (i == default_hstate_idx)
+			continue;
+
 		mnt = mount_one_hugetlbfs(h);
-		if (IS_ERR(mnt) && i == 0) {
-			error = PTR_ERR(mnt);
-			goto out;
-		}
-		hugetlbfs_vfsmount[i] = mnt;
+		if (IS_ERR(mnt))
+			hugetlbfs_vfsmount[i] = NULL;
+		else
+			hugetlbfs_vfsmount[i] = mnt;
 		i++;
 	}
 
 	return 0;
 
- out:
+ out_unreg:
+	(void)unregister_filesystem(&hugetlbfs_fs_type);
+ out_free:
 	kmem_cache_destroy(hugetlbfs_inode_cachep);
- out2:
+ out:
 	return error;
 }
 fs_initcall(init_hugetlbfs_fs)
-- 
2.20.1



