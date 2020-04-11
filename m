Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A05E91A51BB
	for <lists+stable@lfdr.de>; Sat, 11 Apr 2020 14:27:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbgDKMNx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 08:13:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:47086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726760AbgDKMNx (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 08:13:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7C2A20787;
        Sat, 11 Apr 2020 12:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586607233;
        bh=9c6myMWkd4h7/ocSo5vbM6bKiCYcPp3c6Q2ajw1OyE0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dfafy8LKEb9MNFx4B7qHMBVSe2menaH2y1MIUt2tyJ+V7Kz5XTv1V2S1Vz+giJ6qC
         jTCUR6Ndpe6Cl8l6Uq9tu55YEA8myK3Ldj1TGmIOeoDrknIQks3k1L9FcmAPWBX9VH
         hMWvNxVvI+0COisWyDCuv/1pDTzewBTeJl95ajao=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+98704a51af8e3d9425a9@syzkaller.appspotmail.com,
        Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@kernel.org>,
        Luis Henriques <lhenriques@suse.com>
Subject: [PATCH 4.14 28/38] ceph: canonicalize server path in place
Date:   Sat, 11 Apr 2020 14:09:12 +0200
Message-Id: <20200411115440.691983233@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200411115437.795556138@linuxfoundation.org>
References: <20200411115437.795556138@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilya Dryomov <idryomov@gmail.com>

commit b27a939e8376a3f1ed09b9c33ef44d20f18ec3d0 upstream.

syzbot reported that 4fbc0c711b24 ("ceph: remove the extra slashes in
the server path") had caused a regression where an allocation could be
done under a spinlock -- compare_mount_options() is called by sget_fc()
with sb_lock held.

We don't really need the supplied server path, so canonicalize it
in place and compare it directly.  To make this work, the leading
slash is kept around and the logic in ceph_real_mount() to skip it
is restored.  CEPH_MSG_CLIENT_SESSION now reports the same (i.e.
canonicalized) path, with the leading slash of course.

Fixes: 4fbc0c711b24 ("ceph: remove the extra slashes in the server path")
Reported-by: syzbot+98704a51af8e3d9425a9@syzkaller.appspotmail.com
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Luis Henriques <lhenriques@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/super.c |  118 ++++++++++++--------------------------------------------
 fs/ceph/super.h |    2 
 2 files changed, 28 insertions(+), 92 deletions(-)

--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -188,6 +188,26 @@ static match_table_t fsopt_tokens = {
 	{-1, NULL}
 };
 
+/*
+ * Remove adjacent slashes and then the trailing slash, unless it is
+ * the only remaining character.
+ *
+ * E.g. "//dir1////dir2///" --> "/dir1/dir2", "///" --> "/".
+ */
+static void canonicalize_path(char *path)
+{
+	int i, j = 0;
+
+	for (i = 0; path[i] != '\0'; i++) {
+		if (path[i] != '/' || j < 1 || path[j - 1] != '/')
+			path[j++] = path[i];
+	}
+
+	if (j > 1 && path[j - 1] == '/')
+		j--;
+	path[j] = '\0';
+}
+
 static int parse_fsopt_token(char *c, void *private)
 {
 	struct ceph_mount_options *fsopt = private;
@@ -373,73 +393,6 @@ static int strcmp_null(const char *s1, c
 	return strcmp(s1, s2);
 }
 
-/**
- * path_remove_extra_slash - Remove the extra slashes in the server path
- * @server_path: the server path and could be NULL
- *
- * Return NULL if the path is NULL or only consists of "/", or a string
- * without any extra slashes including the leading slash(es) and the
- * slash(es) at the end of the server path, such as:
- * "//dir1////dir2///" --> "dir1/dir2"
- */
-static char *path_remove_extra_slash(const char *server_path)
-{
-	const char *path = server_path;
-	const char *cur, *end;
-	char *buf, *p;
-	int len;
-
-	/* if the server path is omitted */
-	if (!path)
-		return NULL;
-
-	/* remove all the leading slashes */
-	while (*path == '/')
-		path++;
-
-	/* if the server path only consists of slashes */
-	if (*path == '\0')
-		return NULL;
-
-	len = strlen(path);
-
-	buf = kmalloc(len + 1, GFP_KERNEL);
-	if (!buf)
-		return ERR_PTR(-ENOMEM);
-
-	end = path + len;
-	p = buf;
-	do {
-		cur = strchr(path, '/');
-		if (!cur)
-			cur = end;
-
-		len = cur - path;
-
-		/* including one '/' */
-		if (cur != end)
-			len += 1;
-
-		memcpy(p, path, len);
-		p += len;
-
-		while (cur <= end && *cur == '/')
-			cur++;
-		path = cur;
-	} while (path < end);
-
-	*p = '\0';
-
-	/*
-	 * remove the last slash if there has and just to make sure that
-	 * we will get something like "dir1/dir2"
-	 */
-	if (*(--p) == '/')
-		*p = '\0';
-
-	return buf;
-}
-
 static int compare_mount_options(struct ceph_mount_options *new_fsopt,
 				 struct ceph_options *new_opt,
 				 struct ceph_fs_client *fsc)
@@ -447,7 +400,6 @@ static int compare_mount_options(struct
 	struct ceph_mount_options *fsopt1 = new_fsopt;
 	struct ceph_mount_options *fsopt2 = fsc->mount_options;
 	int ofs = offsetof(struct ceph_mount_options, snapdir_name);
-	char *p1, *p2;
 	int ret;
 
 	ret = memcmp(fsopt1, fsopt2, ofs);
@@ -457,21 +409,12 @@ static int compare_mount_options(struct
 	ret = strcmp_null(fsopt1->snapdir_name, fsopt2->snapdir_name);
 	if (ret)
 		return ret;
+
 	ret = strcmp_null(fsopt1->mds_namespace, fsopt2->mds_namespace);
 	if (ret)
 		return ret;
 
-	p1 = path_remove_extra_slash(fsopt1->server_path);
-	if (IS_ERR(p1))
-		return PTR_ERR(p1);
-	p2 = path_remove_extra_slash(fsopt2->server_path);
-	if (IS_ERR(p2)) {
-		kfree(p1);
-		return PTR_ERR(p2);
-	}
-	ret = strcmp_null(p1, p2);
-	kfree(p1);
-	kfree(p2);
+	ret = strcmp_null(fsopt1->server_path, fsopt2->server_path);
 	if (ret)
 		return ret;
 
@@ -539,6 +482,8 @@ static int parse_mount_options(struct ce
 			err = -ENOMEM;
 			goto out;
 		}
+
+		canonicalize_path(fsopt->server_path);
 	} else {
 		dev_name_end = dev_name + strlen(dev_name);
 	}
@@ -938,7 +883,9 @@ static struct dentry *ceph_real_mount(st
 	mutex_lock(&fsc->client->mount_mutex);
 
 	if (!fsc->sb->s_root) {
-		const char *path, *p;
+		const char *path = fsc->mount_options->server_path ?
+				     fsc->mount_options->server_path + 1 : "";
+
 		err = __ceph_open_session(fsc->client, started);
 		if (err < 0)
 			goto out;
@@ -950,16 +897,6 @@ static struct dentry *ceph_real_mount(st
 				goto out;
 		}
 
-		p = path_remove_extra_slash(fsc->mount_options->server_path);
-		if (IS_ERR(p)) {
-			err = PTR_ERR(p);
-			goto out;
-		}
-		/* if the server path is omitted or just consists of '/' */
-		if (!p)
-			path = "";
-		else
-			path = p;
 		dout("mount opening path '%s'\n", path);
 
 		err = ceph_fs_debugfs_init(fsc);
@@ -967,7 +904,6 @@ static struct dentry *ceph_real_mount(st
 			goto out;
 
 		root = open_root_dentry(fsc, path, started);
-		kfree(p);
 		if (IS_ERR(root)) {
 			err = PTR_ERR(root);
 			goto out;
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -85,7 +85,7 @@ struct ceph_mount_options {
 
 	char *snapdir_name;   /* default ".snap" */
 	char *mds_namespace;  /* default NULL */
-	char *server_path;    /* default  "/" */
+	char *server_path;    /* default NULL (means "/") */
 	char *fscache_uniq;   /* default NULL */
 };
 


