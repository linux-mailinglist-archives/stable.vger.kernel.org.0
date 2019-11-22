Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF69D106A22
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 11:32:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727568AbfKVKcH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:32:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:53082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727547AbfKVKcG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:32:06 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7BC7A20714;
        Fri, 22 Nov 2019 10:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574418726;
        bh=E5zs1M/0RJADfTrN7tYc7NV9NtH57DlhyBb+rh5cvug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y2a30h9DWjss9qzeow5N6ca2haNWhGtsmgIpbnsNEsfM4m0RnaGAIaK4NII5949yO
         fpJHQaR4ayrj6kbQQXUcLIbmDwU377VYHLRl+BmoFW7j3HtV/fOkXguJJKlxuYkRUD
         kiSO0xpQEg850unP37P3ixsk5UnE61tsfpP9G3d8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 4.4 007/159] ecryptfs_lookup_interpose(): lower_dentry->d_parent is not stable either
Date:   Fri, 22 Nov 2019 11:26:38 +0100
Message-Id: <20191122100710.798333925@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100704.194776704@linuxfoundation.org>
References: <20191122100704.194776704@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

commit 762c69685ff7ad5ad7fee0656671e20a0c9c864d upstream.

We need to get the underlying dentry of parent; sure, absent the races
it is the parent of underlying dentry, but there's nothing to prevent
losing a timeslice to preemtion in the middle of evaluation of
lower_dentry->d_parent->d_inode, having another process move lower_dentry
around and have its (ex)parent not pinned anymore and freed on memory
pressure.  Then we regain CPU and try to fetch ->d_inode from memory
that is freed by that point.

dentry->d_parent *is* stable here - it's an argument of ->lookup() and
we are guaranteed that it won't be moved anywhere until we feed it
to d_add/d_splice_alias.  So we safely go that way to get to its
underlying dentry.

Cc: stable@vger.kernel.org # since 2009 or so
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ecryptfs/inode.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -330,9 +330,9 @@ static int ecryptfs_lookup_interpose(str
 				     struct dentry *lower_dentry,
 				     struct inode *dir_inode)
 {
+	struct path *path = ecryptfs_dentry_to_lower_path(dentry->d_parent);
 	struct inode *inode, *lower_inode;
 	struct ecryptfs_dentry_info *dentry_info;
-	struct vfsmount *lower_mnt;
 	int rc = 0;
 
 	dentry_info = kmem_cache_alloc(ecryptfs_dentry_info_cache, GFP_KERNEL);
@@ -344,12 +344,11 @@ static int ecryptfs_lookup_interpose(str
 		return -ENOMEM;
 	}
 
-	lower_mnt = mntget(ecryptfs_dentry_to_lower_mnt(dentry->d_parent));
-	fsstack_copy_attr_atime(dir_inode, d_inode(lower_dentry->d_parent));
+	fsstack_copy_attr_atime(dir_inode, d_inode(path->dentry));
 	BUG_ON(!d_count(lower_dentry));
 
 	ecryptfs_set_dentry_private(dentry, dentry_info);
-	dentry_info->lower_path.mnt = lower_mnt;
+	dentry_info->lower_path.mnt = mntget(path->mnt);
 	dentry_info->lower_path.dentry = lower_dentry;
 
 	/*


