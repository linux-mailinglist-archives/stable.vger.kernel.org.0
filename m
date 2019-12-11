Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 581A111B7CE
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 17:10:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731061AbfLKQKa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 11:10:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:60892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730484AbfLKPL5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:11:57 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 39D64208C3;
        Wed, 11 Dec 2019 15:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077116;
        bh=g76r3pWVsvMwFc0wtP2LIwJHp4VNZA4aXnmYsT/bYy8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DAOEAG+2oiSCGJ5SdHDq2qujOGv68WmkiZgsWtAZ7C4FXi1U/3aYWT6aBrZfn7h0S
         LWEYa/5DM9uo1pmUGGj3IOv/KoJWIUU5r7i8hUEGcsh/bftopjBNZep7+trX0mrYZC
         r8LHWTE2+mLFsw0tkTqWUe8Yoa/X1qHqV1SgYux4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 023/105] ecryptfs: fix unlink and rmdir in face of underlying fs modifications
Date:   Wed, 11 Dec 2019 16:05:12 +0100
Message-Id: <20191211150227.804875989@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150221.153659747@linuxfoundation.org>
References: <20191211150221.153659747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit bcf0d9d4b76976f892154efdfc509b256fd898e8 ]

A problem similar to the one caught in commit 74dd7c97ea2a ("ecryptfs_rename():
verify that lower dentries are still OK after lock_rename()") exists for
unlink/rmdir as well.

Instead of playing with dget_parent() of underlying dentry of victim
and hoping it's the same as underlying dentry of our directory,
do the following:
        * find the underlying dentry of victim
        * find the underlying directory of victim's parent (stable
since the victim is ecryptfs dentry and inode of its parent is
held exclusive by the caller).
        * lock the inode of dentry underlying the victim's parent
        * check that underlying dentry of victim is still hashed and
has the right parent - it can be moved, but it can't be moved to/from
the directory we are holding exclusive.  So while ->d_parent itself
might not be stable, the result of comparison is.

If the check passes, everything is fine - underlying directory is locked,
underlying victim is still a child of that directory and we can go ahead
and feed them to vfs_unlink().  As in the current mainline we need to
pin the underlying dentry of victim, so that it wouldn't go negative under
us, but that's the only temporary reference that needs to be grabbed there.
Underlying dentry of parent won't go away (it's pinned by the parent,
which is held by caller), so there's no need to grab it.

The same problem (with the same solution) exists for rmdir.  Moreover,
rename gets simpler and more robust with the same "don't bother with
dget_parent()" approach.

Fixes: 74dd7c97ea2 "ecryptfs_rename(): verify that lower dentries are still OK after lock_rename()"
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ecryptfs/inode.c | 65 ++++++++++++++++++++++++++++-----------------
 1 file changed, 40 insertions(+), 25 deletions(-)

diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index 0c7ea4596202a..e23752d9a79f3 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -128,13 +128,20 @@ static int ecryptfs_do_unlink(struct inode *dir, struct dentry *dentry,
 			      struct inode *inode)
 {
 	struct dentry *lower_dentry = ecryptfs_dentry_to_lower(dentry);
-	struct inode *lower_dir_inode = ecryptfs_inode_to_lower(dir);
 	struct dentry *lower_dir_dentry;
+	struct inode *lower_dir_inode;
 	int rc;
 
-	dget(lower_dentry);
-	lower_dir_dentry = lock_parent(lower_dentry);
-	rc = vfs_unlink(lower_dir_inode, lower_dentry, NULL);
+	lower_dir_dentry = ecryptfs_dentry_to_lower(dentry->d_parent);
+	lower_dir_inode = d_inode(lower_dir_dentry);
+	inode_lock_nested(lower_dir_inode, I_MUTEX_PARENT);
+	dget(lower_dentry);	// don't even try to make the lower negative
+	if (lower_dentry->d_parent != lower_dir_dentry)
+		rc = -EINVAL;
+	else if (d_unhashed(lower_dentry))
+		rc = -EINVAL;
+	else
+		rc = vfs_unlink(lower_dir_inode, lower_dentry, NULL);
 	if (rc) {
 		printk(KERN_ERR "Error in vfs_unlink; rc = [%d]\n", rc);
 		goto out_unlock;
@@ -142,10 +149,11 @@ static int ecryptfs_do_unlink(struct inode *dir, struct dentry *dentry,
 	fsstack_copy_attr_times(dir, lower_dir_inode);
 	set_nlink(inode, ecryptfs_inode_to_lower(inode)->i_nlink);
 	inode->i_ctime = dir->i_ctime;
-	d_drop(dentry);
 out_unlock:
-	unlock_dir(lower_dir_dentry);
 	dput(lower_dentry);
+	inode_unlock(lower_dir_inode);
+	if (!rc)
+		d_drop(dentry);
 	return rc;
 }
 
@@ -519,22 +527,30 @@ static int ecryptfs_rmdir(struct inode *dir, struct dentry *dentry)
 {
 	struct dentry *lower_dentry;
 	struct dentry *lower_dir_dentry;
+	struct inode *lower_dir_inode;
 	int rc;
 
 	lower_dentry = ecryptfs_dentry_to_lower(dentry);
-	dget(dentry);
-	lower_dir_dentry = lock_parent(lower_dentry);
-	dget(lower_dentry);
-	rc = vfs_rmdir(d_inode(lower_dir_dentry), lower_dentry);
-	dput(lower_dentry);
-	if (!rc && d_really_is_positive(dentry))
+	lower_dir_dentry = ecryptfs_dentry_to_lower(dentry->d_parent);
+	lower_dir_inode = d_inode(lower_dir_dentry);
+
+	inode_lock_nested(lower_dir_inode, I_MUTEX_PARENT);
+	dget(lower_dentry);	// don't even try to make the lower negative
+	if (lower_dentry->d_parent != lower_dir_dentry)
+		rc = -EINVAL;
+	else if (d_unhashed(lower_dentry))
+		rc = -EINVAL;
+	else
+		rc = vfs_rmdir(lower_dir_inode, lower_dentry);
+	if (!rc) {
 		clear_nlink(d_inode(dentry));
-	fsstack_copy_attr_times(dir, d_inode(lower_dir_dentry));
-	set_nlink(dir, d_inode(lower_dir_dentry)->i_nlink);
-	unlock_dir(lower_dir_dentry);
+		fsstack_copy_attr_times(dir, lower_dir_inode);
+		set_nlink(dir, lower_dir_inode->i_nlink);
+	}
+	dput(lower_dentry);
+	inode_unlock(lower_dir_inode);
 	if (!rc)
 		d_drop(dentry);
-	dput(dentry);
 	return rc;
 }
 
@@ -572,20 +588,22 @@ ecryptfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	struct dentry *lower_new_dentry;
 	struct dentry *lower_old_dir_dentry;
 	struct dentry *lower_new_dir_dentry;
-	struct dentry *trap = NULL;
+	struct dentry *trap;
 	struct inode *target_inode;
 
 	if (flags)
 		return -EINVAL;
 
+	lower_old_dir_dentry = ecryptfs_dentry_to_lower(old_dentry->d_parent);
+	lower_new_dir_dentry = ecryptfs_dentry_to_lower(new_dentry->d_parent);
+
 	lower_old_dentry = ecryptfs_dentry_to_lower(old_dentry);
 	lower_new_dentry = ecryptfs_dentry_to_lower(new_dentry);
-	dget(lower_old_dentry);
-	dget(lower_new_dentry);
-	lower_old_dir_dentry = dget_parent(lower_old_dentry);
-	lower_new_dir_dentry = dget_parent(lower_new_dentry);
+
 	target_inode = d_inode(new_dentry);
+
 	trap = lock_rename(lower_old_dir_dentry, lower_new_dir_dentry);
+	dget(lower_new_dentry);
 	rc = -EINVAL;
 	if (lower_old_dentry->d_parent != lower_old_dir_dentry)
 		goto out_lock;
@@ -613,11 +631,8 @@ ecryptfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	if (new_dir != old_dir)
 		fsstack_copy_attr_all(old_dir, d_inode(lower_old_dir_dentry));
 out_lock:
-	unlock_rename(lower_old_dir_dentry, lower_new_dir_dentry);
-	dput(lower_new_dir_dentry);
-	dput(lower_old_dir_dentry);
 	dput(lower_new_dentry);
-	dput(lower_old_dentry);
+	unlock_rename(lower_old_dir_dentry, lower_new_dir_dentry);
 	return rc;
 }
 
-- 
2.20.1



