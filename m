Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2EA21A1F51
	for <lists+stable@lfdr.de>; Wed,  8 Apr 2020 12:58:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728372AbgDHK6d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Apr 2020 06:58:33 -0400
Received: from mx2.suse.de ([195.135.220.15]:36128 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728137AbgDHK6d (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Apr 2020 06:58:33 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id D258EACA1;
        Wed,  8 Apr 2020 10:58:28 +0000 (UTC)
From:   Luis Henriques <lhenriques@suse.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        stable@vger.kernel.org,
        syzbot+98704a51af8e3d9425a9@syzkaller.appspotmail.com,
        Luis Henriques <lhenriques@suse.com>
Subject: [PATCH 5.4 2/2] ceph: canonicalize server path in place
Date:   Wed,  8 Apr 2020 11:58:44 +0100
Message-Id: <20200408105844.21840-7-lhenriques@suse.com>
In-Reply-To: <20200408105844.21840-1-lhenriques@suse.com>
References: <20200408105844.21840-1-lhenriques@suse.com>
MIME-Version: 1.0
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
---
 fs/ceph/super.c | 118 +++++++++++-------------------------------------
 fs/ceph/super.h |   2 +-
 2 files changed, 28 insertions(+), 92 deletions(-)

diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 54b50452ec1e..d40658d5e808 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -214,6 +214,26 @@ static match_table_t fsopt_tokens = {
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
@@ -429,73 +449,6 @@ static int strcmp_null(const char *s1, const char *s2)
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
@@ -503,7 +456,6 @@ static int compare_mount_options(struct ceph_mount_options *new_fsopt,
 	struct ceph_mount_options *fsopt1 = new_fsopt;
 	struct ceph_mount_options *fsopt2 = fsc->mount_options;
 	int ofs = offsetof(struct ceph_mount_options, snapdir_name);
-	char *p1, *p2;
 	int ret;
 
 	ret = memcmp(fsopt1, fsopt2, ofs);
@@ -513,21 +465,12 @@ static int compare_mount_options(struct ceph_mount_options *new_fsopt,
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
 
@@ -595,6 +538,8 @@ static int parse_mount_options(struct ceph_mount_options **pfsopt,
 			err = -ENOMEM;
 			goto out;
 		}
+
+		canonicalize_path(fsopt->server_path);
 	} else {
 		dev_name_end = dev_name + strlen(dev_name);
 	}
@@ -1022,7 +967,9 @@ static struct dentry *ceph_real_mount(struct ceph_fs_client *fsc)
 	mutex_lock(&fsc->client->mount_mutex);
 
 	if (!fsc->sb->s_root) {
-		const char *path, *p;
+		const char *path = fsc->mount_options->server_path ?
+				     fsc->mount_options->server_path + 1 : "";
+
 		err = __ceph_open_session(fsc->client, started);
 		if (err < 0)
 			goto out;
@@ -1034,22 +981,11 @@ static struct dentry *ceph_real_mount(struct ceph_fs_client *fsc)
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
 
 		ceph_fs_debugfs_init(fsc);
 
 		root = open_root_dentry(fsc, path, started);
-		kfree(p);
 		if (IS_ERR(root)) {
 			err = PTR_ERR(root);
 			goto out;
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index f98d9247f9cb..bb12c9f3a218 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -92,7 +92,7 @@ struct ceph_mount_options {
 
 	char *snapdir_name;   /* default ".snap" */
 	char *mds_namespace;  /* default NULL */
-	char *server_path;    /* default  "/" */
+	char *server_path;    /* default NULL (means "/") */
 	char *fscache_uniq;   /* default NULL */
 };
 
