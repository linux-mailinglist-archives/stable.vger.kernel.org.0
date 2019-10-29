Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9278CE9302
	for <lists+stable@lfdr.de>; Tue, 29 Oct 2019 23:24:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726364AbfJ2WYy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Oct 2019 18:24:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:56826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725830AbfJ2WYy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Oct 2019 18:24:54 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9AF3620717;
        Tue, 29 Oct 2019 22:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572387891;
        bh=POQ9+cGttHVQimeZd/9E8M4ZDWL/RPoHrVU/G2sj+K8=;
        h=Date:From:To:Subject:From;
        b=gOajdKj6RkJ+W1fmexVjrrSfS8KgSgjDXf5jYtxMgBq9wxhLtWXKWgTgPBgs9TkzI
         hh74BNrarChS0lo4cesUKIk70kD7Uhq+/uvnwTXGlAt5TmC2iHLfeUt/1wnFFkBNf3
         F42oqj1VE5NVxMaDh6llRzMzBA34QQJj9BV+ICGo=
Date:   Tue, 29 Oct 2019 15:24:51 -0700
From:   akpm@linux-foundation.org
To:     cgxu519@mykernel.net, dhowells@redhat.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, stable@vger.kernel.org,
        viro@zeniv.linux.org.uk
Subject:  +
 mm-hugetlbfs-fix-error-handling-when-setting-up-mounts.patch added to -mm
 tree
Message-ID: <20191029222451.CUrFrcx_e%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/hugetlbfs: fix error handling when setting up mounts
has been added to the -mm tree.  Its filename is
     mm-hugetlbfs-fix-error-handling-when-setting-up-mounts.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlbfs-fix-error-handling-when-setting-up-mounts.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlbfs-fix-error-handling-when-setting-up-mounts.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: mm/hugetlbfs: fix error handling when setting up mounts

It is assumed that the hugetlbfs_vfsmount[] array will contain either a
valid vfsmount pointer or NULL for each hstate after initialization. 
Changes made while converting to use fs_context broke this assumption.

While fixing the hugetlbfs_vfsmount issue, it was discovered that
init_hugetlbfs_fs never did correctly clean up when encountering a vfs
mount error.

Link: http://lkml.kernel.org/r/94b6244d-2c24-e269-b12c-e3ba694b242d@oracle.com
Reported-by: Chengguang Xu <cgxu519@mykernel.net>
Fixes: 32021982a324 ("hugetlbfs: Convert to fs_context")
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |   31 ++++++++++++++++++++++---------
 1 file changed, 22 insertions(+), 9 deletions(-)

--- a/fs/hugetlbfs/inode.c~mm-hugetlbfs-fix-error-handling-when-setting-up-mounts
+++ a/fs/hugetlbfs/inode.c
@@ -1461,28 +1461,41 @@ static int __init init_hugetlbfs_fs(void
 					sizeof(struct hugetlbfs_inode_info),
 					0, SLAB_ACCOUNT, init_once);
 	if (hugetlbfs_inode_cachep == NULL)
-		goto out2;
+		goto out;
 
 	error = register_filesystem(&hugetlbfs_fs_type);
 	if (error)
-		goto out;
+		goto out_free;
+
+	/* default hstate mount is required */
+	mnt = mount_one_hugetlbfs(&hstates[default_hstate_idx]);
+	if (IS_ERR(mnt)) {
+		error = PTR_ERR(mnt);
+		goto out_unreg;
+	}
+	hugetlbfs_vfsmount[default_hstate_idx] = mnt;
 
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
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

mm-hugetlbfs-fix-error-handling-when-setting-up-mounts.patch
hugetlbfs-hugetlb_fault_mutex_hash-cleanup.patch

