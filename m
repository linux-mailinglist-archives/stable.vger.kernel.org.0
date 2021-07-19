Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 427C33CE346
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:18:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236123AbhGSPhF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:37:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:57394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241716AbhGSPck (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:32:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F0D46142C;
        Mon, 19 Jul 2021 16:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711041;
        bh=Utn1J4kvZ3wz9rkSIBurFAyr8UiE6oFhQGgo5pnFAYI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XjieKRuPGx4w2ooxBPYl/ATDoNSYWWg2s/A7dOC9soJ88rIFnsyTXqN4xaeI6S3QD
         6bp9wx12jofhn7kwOWFlVAdy/rXf7gMRVd5xbW6ejZJOj+zukoEykxDwlpIwI6wzi5
         LnjmfXsZePHbQhjV1sIrocsQ7D9Cq1xYKrRmqjws=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 171/351] fuse: fix illegal access to inode with reused nodeid
Date:   Mon, 19 Jul 2021 16:51:57 +0200
Message-Id: <20210719144950.627485896@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amir Goldstein <amir73il@gmail.com>

[ Upstream commit 15db16837a35d8007cb8563358787412213db25e ]

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

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/dir.c     | 2 +-
 fs/fuse/fuse_i.h  | 7 +++++++
 fs/fuse/inode.c   | 4 ++--
 fs/fuse/readdir.c | 7 +++++--
 4 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 3fa8604c21d5..d296b0d19c27 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -252,7 +252,7 @@ static int fuse_dentry_revalidate(struct dentry *entry, unsigned int flags)
 		if (ret == -ENOMEM)
 			goto out;
 		if (ret || fuse_invalid_attr(&outarg.attr) ||
-		    inode_wrong_type(inode, outarg.attr.mode))
+		    fuse_stale_inode(inode, outarg.generation, &outarg.attr))
 			goto invalid;
 
 		forget_all_cached_acls(inode);
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index f48dd7ff32af..120f9c5908d1 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -870,6 +870,13 @@ static inline u64 fuse_get_attr_version(struct fuse_conn *fc)
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
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 93d28dc1f572..cf16d6d3a603 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -350,8 +350,8 @@ retry:
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
diff --git a/fs/fuse/readdir.c b/fs/fuse/readdir.c
index 277f7041d55a..bc267832310c 100644
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
-- 
2.30.2



