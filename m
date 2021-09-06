Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7FDC401BB2
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 14:57:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242929AbhIFM6x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Sep 2021 08:58:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:35462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242933AbhIFM60 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 Sep 2021 08:58:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 53B886103D;
        Mon,  6 Sep 2021 12:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630933041;
        bh=PQRmfGTaV5yBSF7Zayrd3gqnXik1sdjwlMeSAP3iGOQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w2kcBD2rpw/yzDwg8JUKA4IRLWAV8C7JTZVgGdovBLZNeRc4gPEoLoIX1GuQZxsn1
         Qywe5UzrhnVSIvlbaXjrnM0s7C5SSJ7UNpo/JUcjpnsLHEWRN5fFtw4J4yROP1Rxpg
         t1S2mNzq0TZxs6sVY4DkPiiq3OKEC4NZMUYo4czU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.10 28/29] fuse: fix illegal access to inode with reused nodeid
Date:   Mon,  6 Sep 2021 14:55:43 +0200
Message-Id: <20210906125450.717001154@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210906125449.756437409@linuxfoundation.org>
References: <20210906125449.756437409@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amir Goldstein <amir73il@gmail.com>

commit 15db16837a35d8007cb8563358787412213db25e upstream.

Server responds to LOOKUP and other ops (READDIRPLUS/CREATE/MKNOD/...)
with ourarg containing nodeid and generation.

If a fuse inode is found in inode cache with the same nodeid but different
generation, the existing fuse inode should be unhashed and marked "bad" and
a new inode with the new generation should be hashed instead.

This can happen, for example, with passhrough fuse filesystem that returns
the real filesystem ino/generation on lookup and where real inode numbers
can get recycled due to real files being unlinked not via the fuse
passthrough filesystem.

With current code, this situation will not be detected and an old fuse
dentry that used to point to an older generation real inode, can be used to
access a completely new inode, which should be accessed only via the new
dentry.

Note that because the FORGET message carries the nodeid w/o generation, the
server should wait to get FORGET counts for the nlookup counts of the old
and reused inodes combined, before it can free the resources associated to
that nodeid.

Stable backport notes:
* This is not a regression. The bug has been in fuse forever, but only
  a certain class of low level fuse filesystems can trigger this bug
* Because there is no way to check if this fix is applied in runtime,
  libfuse test_examples.py tests this fix with hardcoded check for
  kernel version >= 5.14
* After backport to stable kernel(s), the libfuse test can be updated
  to also check minimal stable kernel version(s)
* Depends on "fuse: fix bad inode" which is already applied to stable
  kernels v5.4.y and v5.10.y
* Required backporting helper inode_wrong_type()

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/linux-fsdevel/CAOQ4uxi8DymG=JO_sAU+wS8akFdzh+PuXwW3Ebgahd2Nwnh7zA@mail.gmail.com/
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/fuse/dir.c     |    2 +-
 fs/fuse/fuse_i.h  |    7 +++++++
 fs/fuse/inode.c   |    4 ++--
 fs/fuse/readdir.c |    7 +++++--
 4 files changed, 15 insertions(+), 5 deletions(-)

--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -252,7 +252,7 @@ static int fuse_dentry_revalidate(struct
 		if (ret == -ENOMEM)
 			goto out;
 		if (ret || fuse_invalid_attr(&outarg.attr) ||
-		    inode_wrong_type(inode, outarg.attr.mode))
+		    fuse_stale_inode(inode, outarg.generation, &outarg.attr))
 			goto invalid;
 
 		forget_all_cached_acls(inode);
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -860,6 +860,13 @@ static inline u64 fuse_get_attr_version(
 	return atomic64_read(&fc->attr_version);
 }
 
+static inline bool fuse_stale_inode(const struct inode *inode, int generation,
+				    struct fuse_attr *attr)
+{
+	return inode->i_generation != generation ||
+		inode_wrong_type(inode, attr->mode);
+}
+
 static inline void fuse_make_bad(struct inode *inode)
 {
 	remove_inode_hash(inode);
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -340,8 +340,8 @@ retry:
 		inode->i_generation = generation;
 		fuse_init_inode(inode, attr);
 		unlock_new_inode(inode);
-	} else if (inode_wrong_type(inode, attr->mode)) {
-		/* Inode has changed type, any I/O on the old should fail */
+	} else if (fuse_stale_inode(inode, generation, attr)) {
+		/* nodeid was reused, any I/O on the old inode should fail */
 		fuse_make_bad(inode);
 		iput(inode);
 		goto retry;
--- a/fs/fuse/readdir.c
+++ b/fs/fuse/readdir.c
@@ -200,9 +200,12 @@ retry:
 	if (!d_in_lookup(dentry)) {
 		struct fuse_inode *fi;
 		inode = d_inode(dentry);
+		if (inode && get_node_id(inode) != o->nodeid)
+			inode = NULL;
 		if (!inode ||
-		    get_node_id(inode) != o->nodeid ||
-		    inode_wrong_type(inode, o->attr.mode)) {
+		    fuse_stale_inode(inode, o->generation, &o->attr)) {
+			if (inode)
+				fuse_make_bad(inode);
 			d_invalidate(dentry);
 			dput(dentry);
 			goto retry;


