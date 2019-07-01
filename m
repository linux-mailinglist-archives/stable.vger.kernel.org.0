Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B5CC288C3
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:41:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391796AbfEWT2e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:28:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:41228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391787AbfEWT2e (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:28:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 82B47206BA;
        Thu, 23 May 2019 19:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558639713;
        bh=HDV0V+3q18n4NciByt+kY8RlDLe68ZzcqfT7OotFAPw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c36DSOnfRQiUlNfQHxuxAmKDbc+TfTwSIBlY5UqvFoZAJtcAQ+0L8g+vvdrM/I200
         F3hH7Wi7ONlMYSpPajzObd1Z0VWnWLCc6QVDYvjm5yKPNluipr2fvEzYD2YG/EUpUg
         oPkWQAmDWKMcRRwmT3yvTGdzBMc1pu5NVNNcLUsg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 5.1 041/122] dcache: sort the freeing-without-RCU-delay mess for good.
Date:   Thu, 23 May 2019 21:06:03 +0200
Message-Id: <20190523181710.170606860@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181705.091418060@linuxfoundation.org>
References: <20190523181705.091418060@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

commit 5467a68cbf6884c9a9d91e2a89140afb1839c835 upstream.

For lockless accesses to dentries we don't have pinned we rely
(among other things) upon having an RCU delay between dropping
the last reference and actually freeing the memory.

On the other hand, for things like pipes and sockets we neither
do that kind of lockless access, nor want to deal with the
overhead of an RCU delay every time a socket gets closed.

So delay was made optional - setting DCACHE_RCUACCESS in ->d_flags
made sure it would happen.  We tried to avoid setting it unless
we knew we need it.  Unfortunately, that had led to recurring
class of bugs, in which we missed the need to set it.

We only really need it for dentries that are created by
d_alloc_pseudo(), so let's not bother with trying to be smart -
just make having an RCU delay the default.  The ones that do
*not* get it set the replacement flag (DCACHE_NORCU) and we'd
better use that sparingly.  d_alloc_pseudo() is the only
such user right now.

FWIW, the race that finally prompted that switch had been
between __lock_parent() of immediate subdirectory of what's
currently the root of a disconnected tree (e.g. from
open-by-handle in progress) racing with d_splice_alias()
elsewhere picking another alias for the same inode, either
on outright corrupted fs image, or (in case of open-by-handle
on NFS) that subdirectory having been just moved on server.
It's not easy to hit, so the sky is not falling, but that's
not the first race on similar missed cases and the logics
for settinf DCACHE_RCUACCESS has gotten ridiculously
convoluted.

Cc: stable@vger.kernel.org
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/filesystems/porting |    5 +++++
 fs/dcache.c                       |   24 +++++++++++++-----------
 fs/nsfs.c                         |    3 +--
 include/linux/dcache.h            |    2 +-
 4 files changed, 20 insertions(+), 14 deletions(-)

--- a/Documentation/filesystems/porting
+++ b/Documentation/filesystems/porting
@@ -638,3 +638,8 @@ in your dentry operations instead.
 	inode to d_splice_alias() will also do the right thing (equivalent of
 	d_add(dentry, NULL); return NULL;), so that kind of special cases
 	also doesn't need a separate treatment.
+--
+[mandatory]
+	DCACHE_RCUACCESS is gone; having an RCU delay on dentry freeing is the
+	default.  DCACHE_NORCU opts out, and only d_alloc_pseudo() has any
+	business doing so.
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -344,7 +344,7 @@ static void dentry_free(struct dentry *d
 		}
 	}
 	/* if dentry was never visible to RCU, immediate free is OK */
-	if (!(dentry->d_flags & DCACHE_RCUACCESS))
+	if (dentry->d_flags & DCACHE_NORCU)
 		__d_free(&dentry->d_u.d_rcu);
 	else
 		call_rcu(&dentry->d_u.d_rcu, __d_free);
@@ -1701,7 +1701,6 @@ struct dentry *d_alloc(struct dentry * p
 	struct dentry *dentry = __d_alloc(parent->d_sb, name);
 	if (!dentry)
 		return NULL;
-	dentry->d_flags |= DCACHE_RCUACCESS;
 	spin_lock(&parent->d_lock);
 	/*
 	 * don't need child lock because it is not subject
@@ -1726,7 +1725,7 @@ struct dentry *d_alloc_cursor(struct den
 {
 	struct dentry *dentry = d_alloc_anon(parent->d_sb);
 	if (dentry) {
-		dentry->d_flags |= DCACHE_RCUACCESS | DCACHE_DENTRY_CURSOR;
+		dentry->d_flags |= DCACHE_DENTRY_CURSOR;
 		dentry->d_parent = dget(parent);
 	}
 	return dentry;
@@ -1739,10 +1738,17 @@ struct dentry *d_alloc_cursor(struct den
  *
  * For a filesystem that just pins its dentries in memory and never
  * performs lookups at all, return an unhashed IS_ROOT dentry.
+ * This is used for pipes, sockets et.al. - the stuff that should
+ * never be anyone's children or parents.  Unlike all other
+ * dentries, these will not have RCU delay between dropping the
+ * last reference and freeing them.
  */
 struct dentry *d_alloc_pseudo(struct super_block *sb, const struct qstr *name)
 {
-	return __d_alloc(sb, name);
+	struct dentry *dentry = __d_alloc(sb, name);
+	if (likely(dentry))
+		dentry->d_flags |= DCACHE_NORCU;
+	return dentry;
 }
 EXPORT_SYMBOL(d_alloc_pseudo);
 
@@ -1911,12 +1917,10 @@ struct dentry *d_make_root(struct inode
 
 	if (root_inode) {
 		res = d_alloc_anon(root_inode->i_sb);
-		if (res) {
-			res->d_flags |= DCACHE_RCUACCESS;
+		if (res)
 			d_instantiate(res, root_inode);
-		} else {
+		else
 			iput(root_inode);
-		}
 	}
 	return res;
 }
@@ -2781,9 +2785,7 @@ static void __d_move(struct dentry *dent
 		copy_name(dentry, target);
 		target->d_hash.pprev = NULL;
 		dentry->d_parent->d_lockref.count++;
-		if (dentry == old_parent)
-			dentry->d_flags |= DCACHE_RCUACCESS;
-		else
+		if (dentry != old_parent) /* wasn't IS_ROOT */
 			WARN_ON(!--old_parent->d_lockref.count);
 	} else {
 		target->d_parent = old_parent;
--- a/fs/nsfs.c
+++ b/fs/nsfs.c
@@ -85,13 +85,12 @@ slow:
 	inode->i_fop = &ns_file_operations;
 	inode->i_private = ns;
 
-	dentry = d_alloc_pseudo(mnt->mnt_sb, &empty_name);
+	dentry = d_alloc_anon(mnt->mnt_sb);
 	if (!dentry) {
 		iput(inode);
 		return ERR_PTR(-ENOMEM);
 	}
 	d_instantiate(dentry, inode);
-	dentry->d_flags |= DCACHE_RCUACCESS;
 	dentry->d_fsdata = (void *)ns->ops;
 	d = atomic_long_cmpxchg(&ns->stashed, 0, (unsigned long)dentry);
 	if (d) {
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -176,7 +176,6 @@ struct dentry_operations {
       * typically using d_splice_alias. */
 
 #define DCACHE_REFERENCED		0x00000040 /* Recently used, don't discard. */
-#define DCACHE_RCUACCESS		0x00000080 /* Entry has ever been RCU-visible */
 
 #define DCACHE_CANT_MOUNT		0x00000100
 #define DCACHE_GENOCIDE			0x00000200
@@ -217,6 +216,7 @@ struct dentry_operations {
 
 #define DCACHE_PAR_LOOKUP		0x10000000 /* being looked up (with parent locked shared) */
 #define DCACHE_DENTRY_CURSOR		0x20000000
+#define DCACHE_NORCU			0x40000000 /* No RCU delay for freeing */
 
 extern seqlock_t rename_lock;
 


