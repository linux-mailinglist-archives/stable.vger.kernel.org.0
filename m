Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AAFC11B611
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:58:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731622AbfLKP6h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:58:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:39390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731068AbfLKPOR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:14:17 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 55F082468F;
        Wed, 11 Dec 2019 15:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077256;
        bh=uoThELQ/DKhuovqEU3HxwbjI98SblmxIV9ZGX2S5Wz0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nQZnJS8yRZpPahhr+zzQ1LveMXtCgA6XmWQmDcKw2/v3jzqBjTRxYvumjAt7oWx46
         4etkHiH5wPc/MgqyGGPslxuA0SRfHsgW1LbC+Er06OhCt+UtB9ue9Dr5SinFMsz8bB
         N75fuCmmRT1OkHXoLiAWlnYxqhlxa4XtFED0ZHlo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mike Kravetz <mike.kravetz@oracle.com>,
        Chengguang Xu <cgxu519@mykernel.net>,
        David Howells <dhowells@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 132/134] mm/hugetlbfs: fix error handling when setting up mounts
Date:   Wed, 11 Dec 2019 10:11:48 -0500
Message-Id: <20191211151150.19073-132-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211151150.19073-1-sashal@kernel.org>
References: <20191211151150.19073-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index a478df0356517..26e3906c18fe9 100644
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

