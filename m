Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E918101908
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:12:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727695AbfKSFWP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:22:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:37542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727675AbfKSFWP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:22:15 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 015CF2231D;
        Tue, 19 Nov 2019 05:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574140934;
        bh=Y69w+Wxl3Sjz2eE/P5XuJWrEsWRl107Pl5midaVra10=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rq1sWXjW9uz4FMDvXRpo1vlxMngA5n8UWA0RaIcMsBFKciERqk6BzD5mwpvuE2KdF
         E5ExlFTPjSA0CnhkX6N5Wzwhvf4KyYy7+zGJxaUMPuB4X5noADu/I2inTpelss7p+v
         RTlUnU/sXIGKqAPTa/Bns8+BM3agFKiRhw8sNJmU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 5.3 35/48] ecryptfs_lookup_interpose(): lower_dentry->d_parent is not stable either
Date:   Tue, 19 Nov 2019 06:19:55 +0100
Message-Id: <20191119051015.048363503@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119050946.745015350@linuxfoundation.org>
References: <20191119050946.745015350@linuxfoundation.org>
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
@@ -311,9 +311,9 @@ static int ecryptfs_i_size_read(struct d
 static struct dentry *ecryptfs_lookup_interpose(struct dentry *dentry,
 				     struct dentry *lower_dentry)
 {
+	struct path *path = ecryptfs_dentry_to_lower_path(dentry->d_parent);
 	struct inode *inode, *lower_inode;
 	struct ecryptfs_dentry_info *dentry_info;
-	struct vfsmount *lower_mnt;
 	int rc = 0;
 
 	dentry_info = kmem_cache_alloc(ecryptfs_dentry_info_cache, GFP_KERNEL);
@@ -322,13 +322,12 @@ static struct dentry *ecryptfs_lookup_in
 		return ERR_PTR(-ENOMEM);
 	}
 
-	lower_mnt = mntget(ecryptfs_dentry_to_lower_mnt(dentry->d_parent));
 	fsstack_copy_attr_atime(d_inode(dentry->d_parent),
-				d_inode(lower_dentry->d_parent));
+				d_inode(path->dentry));
 	BUG_ON(!d_count(lower_dentry));
 
 	ecryptfs_set_dentry_private(dentry, dentry_info);
-	dentry_info->lower_path.mnt = lower_mnt;
+	dentry_info->lower_path.mnt = mntget(path->mnt);
 	dentry_info->lower_path.dentry = lower_dentry;
 
 	/*


