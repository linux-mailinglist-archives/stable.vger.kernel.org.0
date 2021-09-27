Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3127F419A12
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:04:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235861AbhI0RG3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:06:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:44696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235952AbhI0RGF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:06:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 13AB360F46;
        Mon, 27 Sep 2021 17:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762267;
        bh=L1BwRkWCh+D41xV9oYfrE2FN2hjiwLsVZzlExGhamP8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lkb8FaiXUhCTJb2doRsc1RDfKIukj7JncoIrBpI6hSRzIj6DoNllbsDJAdBjTCdUL
         e0id+G81+oc94ASfeaGaMWXVsg16a1+00hPqpQm7XZQfwfkZz84mxADdl1P/m29fDT
         lqvLH7kF2pdsPFa+em2w8LYdWWr3M9NfTjXHxT28=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Markus Suvanto <markus.suvanto@gmail.com>,
        David Howells <dhowells@redhat.com>,
        linux-afs@lists.infradead.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 25/68] afs: Fix incorrect triggering of sillyrename on 3rd-party invalidation
Date:   Mon, 27 Sep 2021 19:02:21 +0200
Message-Id: <20210927170220.832277693@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170219.901812470@linuxfoundation.org>
References: <20210927170219.901812470@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit 63d49d843ef5fffeea069e0ffdfbd2bf40ba01c6 ]

The AFS filesystem is currently triggering the silly-rename cleanup from
afs_d_revalidate() when it sees that a dentry has been changed by a third
party[1].  It should not be doing this as the cleanup includes deleting the
silly-rename target file on iput.

Fix this by removing the places in the d_revalidate handling that validate
anything other than the directory and the dirent.  It probably should not
be looking to validate the target inode of the dentry also.

This includes removing the point in afs_d_revalidate() where the inode that
a dentry used to point to was marked as being deleted (AFS_VNODE_DELETED).
We don't know it got deleted.  It could have been renamed or it could have
hard links remaining.

This was reproduced by cloning a git repo onto an afs volume on one
machine, switching to another machine and doing "git status", then
switching back to the first and doing "git status".  The second status
would show weird output due to ".git/index" getting deleted by the above
mentioned mechanism.

A simpler way to do it is to do:

	machine 1: touch a
	machine 2: touch b; mv -f b a
	machine 1: stat a

on an afs volume.  The bug shows up as the stat failing with ENOENT and the
file server log showing that machine 1 deleted "a".

Fixes: 79ddbfa500b3 ("afs: Implement sillyrename for unlink and rename")
Reported-by: Markus Suvanto <markus.suvanto@gmail.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Tested-by: Markus Suvanto <markus.suvanto@gmail.com>
cc: linux-afs@lists.infradead.org
Link: https://bugzilla.kernel.org/show_bug.cgi?id=214217#c4 [1]
Link: https://lore.kernel.org/r/163111668100.283156.3851669884664475428.stgit@warthog.procyon.org.uk/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/dir.c | 46 +++++++---------------------------------------
 1 file changed, 7 insertions(+), 39 deletions(-)

diff --git a/fs/afs/dir.c b/fs/afs/dir.c
index e7494cd49ce7..8c39533d122a 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -977,9 +977,9 @@ static struct dentry *afs_lookup(struct inode *dir, struct dentry *dentry,
  */
 static int afs_d_revalidate_rcu(struct dentry *dentry)
 {
-	struct afs_vnode *dvnode, *vnode;
+	struct afs_vnode *dvnode;
 	struct dentry *parent;
-	struct inode *dir, *inode;
+	struct inode *dir;
 	long dir_version, de_version;
 
 	_enter("%p", dentry);
@@ -1009,18 +1009,6 @@ static int afs_d_revalidate_rcu(struct dentry *dentry)
 			return -ECHILD;
 	}
 
-	/* Check to see if the vnode referred to by the dentry still
-	 * has a callback.
-	 */
-	if (d_really_is_positive(dentry)) {
-		inode = d_inode_rcu(dentry);
-		if (inode) {
-			vnode = AFS_FS_I(inode);
-			if (!afs_check_validity(vnode))
-				return -ECHILD;
-		}
-	}
-
 	return 1; /* Still valid */
 }
 
@@ -1056,17 +1044,7 @@ static int afs_d_revalidate(struct dentry *dentry, unsigned int flags)
 	if (IS_ERR(key))
 		key = NULL;
 
-	if (d_really_is_positive(dentry)) {
-		inode = d_inode(dentry);
-		if (inode) {
-			vnode = AFS_FS_I(inode);
-			afs_validate(vnode, key);
-			if (test_bit(AFS_VNODE_DELETED, &vnode->flags))
-				goto out_bad;
-		}
-	}
-
-	/* lock down the parent dentry so we can peer at it */
+	/* Hold the parent dentry so we can peer at it */
 	parent = dget_parent(dentry);
 	dir = AFS_FS_I(d_inode(parent));
 
@@ -1075,7 +1053,7 @@ static int afs_d_revalidate(struct dentry *dentry, unsigned int flags)
 
 	if (test_bit(AFS_VNODE_DELETED, &dir->flags)) {
 		_debug("%pd: parent dir deleted", dentry);
-		goto out_bad_parent;
+		goto not_found;
 	}
 
 	/* We only need to invalidate a dentry if the server's copy changed
@@ -1101,12 +1079,12 @@ static int afs_d_revalidate(struct dentry *dentry, unsigned int flags)
 	case 0:
 		/* the filename maps to something */
 		if (d_really_is_negative(dentry))
-			goto out_bad_parent;
+			goto not_found;
 		inode = d_inode(dentry);
 		if (is_bad_inode(inode)) {
 			printk("kAFS: afs_d_revalidate: %pd2 has bad inode\n",
 			       dentry);
-			goto out_bad_parent;
+			goto not_found;
 		}
 
 		vnode = AFS_FS_I(inode);
@@ -1128,9 +1106,6 @@ static int afs_d_revalidate(struct dentry *dentry, unsigned int flags)
 			       dentry, fid.unique,
 			       vnode->fid.unique,
 			       vnode->vfs_inode.i_generation);
-			write_seqlock(&vnode->cb_lock);
-			set_bit(AFS_VNODE_DELETED, &vnode->flags);
-			write_sequnlock(&vnode->cb_lock);
 			goto not_found;
 		}
 		goto out_valid;
@@ -1145,7 +1120,7 @@ static int afs_d_revalidate(struct dentry *dentry, unsigned int flags)
 	default:
 		_debug("failed to iterate dir %pd: %d",
 		       parent, ret);
-		goto out_bad_parent;
+		goto not_found;
 	}
 
 out_valid:
@@ -1156,16 +1131,9 @@ static int afs_d_revalidate(struct dentry *dentry, unsigned int flags)
 	_leave(" = 1 [valid]");
 	return 1;
 
-	/* the dirent, if it exists, now points to a different vnode */
 not_found:
-	spin_lock(&dentry->d_lock);
-	dentry->d_flags |= DCACHE_NFSFS_RENAMED;
-	spin_unlock(&dentry->d_lock);
-
-out_bad_parent:
 	_debug("dropping dentry %pd2", dentry);
 	dput(parent);
-out_bad:
 	key_put(key);
 
 	_leave(" = 0 [bad]");
-- 
2.33.0



