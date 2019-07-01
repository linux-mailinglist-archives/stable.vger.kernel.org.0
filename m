Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02090F7C2
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 14:02:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728954AbfD3Lov (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:44:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:56610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730270AbfD3Lou (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:44:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 97ED821707;
        Tue, 30 Apr 2019 11:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624690;
        bh=9WWqTf8S241NksPDWAxQdu6ZeSXtiS7q+7BIE6qqmbg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TEtSIYSCc0g33fYxEyNSTceZnZLdSQ69H8ivT5/Iz0Z+Pl3iF5z6VwULLAEkn8Mks
         JtsnRGUf4gRKvbx8rj/If3MNooqyFjWeh//B/grCNi2J3mHxUPInt4r1/GSrtNuE/L
         xLx36Jz9Pbw7cAsKg++6oECQlvnw6wDIhp58a9WE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben England <bengland@redhat.com>,
        Jeff Layton <jlayton@kernel.org>,
        "Yan, Zheng" <zyan@redhat.com>, Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 4.19 035/100] ceph: only use d_name directly when parent is locked
Date:   Tue, 30 Apr 2019 13:38:04 +0200
Message-Id: <20190430113610.420894026@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430113608.616903219@linuxfoundation.org>
References: <20190430113608.616903219@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

commit 1bcb344086f3ecf8d6705f6d708441baa823beb3 upstream.

Ben reported tripping the BUG_ON in create_request_message during some
performance testing. Analysis of the vmcore showed that the length of
the r_dentry->d_name string changed after we allocated the buffer, but
before we encoded it.

build_dentry_path returns pointers to d_name in the common case of
non-snapped dentries, but this optimization isn't safe unless the parent
directory is locked. When it isn't, have the code make a copy of the
d_name while holding the d_lock.

Cc: stable@vger.kernel.org
Reported-by: Ben England <bengland@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: "Yan, Zheng" <zyan@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ceph/mds_client.c |   61 +++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 50 insertions(+), 11 deletions(-)

--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -1945,10 +1945,39 @@ retry:
 	return path;
 }
 
+/* Duplicate the dentry->d_name.name safely */
+static int clone_dentry_name(struct dentry *dentry, const char **ppath,
+			     int *ppathlen)
+{
+	u32 len;
+	char *name;
+
+retry:
+	len = READ_ONCE(dentry->d_name.len);
+	name = kmalloc(len + 1, GFP_NOFS);
+	if (!name)
+		return -ENOMEM;
+
+	spin_lock(&dentry->d_lock);
+	if (dentry->d_name.len != len) {
+		spin_unlock(&dentry->d_lock);
+		kfree(name);
+		goto retry;
+	}
+	memcpy(name, dentry->d_name.name, len);
+	spin_unlock(&dentry->d_lock);
+
+	name[len] = '\0';
+	*ppath = name;
+	*ppathlen = len;
+	return 0;
+}
+
 static int build_dentry_path(struct dentry *dentry, struct inode *dir,
 			     const char **ppath, int *ppathlen, u64 *pino,
-			     int *pfreepath)
+			     bool *pfreepath, bool parent_locked)
 {
+	int ret;
 	char *path;
 
 	rcu_read_lock();
@@ -1957,8 +1986,15 @@ static int build_dentry_path(struct dent
 	if (dir && ceph_snap(dir) == CEPH_NOSNAP) {
 		*pino = ceph_ino(dir);
 		rcu_read_unlock();
-		*ppath = dentry->d_name.name;
-		*ppathlen = dentry->d_name.len;
+		if (parent_locked) {
+			*ppath = dentry->d_name.name;
+			*ppathlen = dentry->d_name.len;
+		} else {
+			ret = clone_dentry_name(dentry, ppath, ppathlen);
+			if (ret)
+				return ret;
+			*pfreepath = true;
+		}
 		return 0;
 	}
 	rcu_read_unlock();
@@ -1966,13 +2002,13 @@ static int build_dentry_path(struct dent
 	if (IS_ERR(path))
 		return PTR_ERR(path);
 	*ppath = path;
-	*pfreepath = 1;
+	*pfreepath = true;
 	return 0;
 }
 
 static int build_inode_path(struct inode *inode,
 			    const char **ppath, int *ppathlen, u64 *pino,
-			    int *pfreepath)
+			    bool *pfreepath)
 {
 	struct dentry *dentry;
 	char *path;
@@ -1988,7 +2024,7 @@ static int build_inode_path(struct inode
 	if (IS_ERR(path))
 		return PTR_ERR(path);
 	*ppath = path;
-	*pfreepath = 1;
+	*pfreepath = true;
 	return 0;
 }
 
@@ -1999,7 +2035,7 @@ static int build_inode_path(struct inode
 static int set_request_path_attr(struct inode *rinode, struct dentry *rdentry,
 				  struct inode *rdiri, const char *rpath,
 				  u64 rino, const char **ppath, int *pathlen,
-				  u64 *ino, int *freepath)
+				  u64 *ino, bool *freepath, bool parent_locked)
 {
 	int r = 0;
 
@@ -2009,7 +2045,7 @@ static int set_request_path_attr(struct
 		     ceph_snap(rinode));
 	} else if (rdentry) {
 		r = build_dentry_path(rdentry, rdiri, ppath, pathlen, ino,
-					freepath);
+					freepath, parent_locked);
 		dout(" dentry %p %llx/%.*s\n", rdentry, *ino, *pathlen,
 		     *ppath);
 	} else if (rpath || rino) {
@@ -2035,7 +2071,7 @@ static struct ceph_msg *create_request_m
 	const char *path2 = NULL;
 	u64 ino1 = 0, ino2 = 0;
 	int pathlen1 = 0, pathlen2 = 0;
-	int freepath1 = 0, freepath2 = 0;
+	bool freepath1 = false, freepath2 = false;
 	int len;
 	u16 releases;
 	void *p, *end;
@@ -2043,16 +2079,19 @@ static struct ceph_msg *create_request_m
 
 	ret = set_request_path_attr(req->r_inode, req->r_dentry,
 			      req->r_parent, req->r_path1, req->r_ino1.ino,
-			      &path1, &pathlen1, &ino1, &freepath1);
+			      &path1, &pathlen1, &ino1, &freepath1,
+			      test_bit(CEPH_MDS_R_PARENT_LOCKED,
+					&req->r_req_flags));
 	if (ret < 0) {
 		msg = ERR_PTR(ret);
 		goto out;
 	}
 
+	/* If r_old_dentry is set, then assume that its parent is locked */
 	ret = set_request_path_attr(NULL, req->r_old_dentry,
 			      req->r_old_dentry_dir,
 			      req->r_path2, req->r_ino2.ino,
-			      &path2, &pathlen2, &ino2, &freepath2);
+			      &path2, &pathlen2, &ino2, &freepath2, true);
 	if (ret < 0) {
 		msg = ERR_PTR(ret);
 		goto out_free1;


