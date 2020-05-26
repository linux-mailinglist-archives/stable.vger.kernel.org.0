Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CE1D1A1F4C
	for <lists+stable@lfdr.de>; Wed,  8 Apr 2020 12:58:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728359AbgDHK6b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Apr 2020 06:58:31 -0400
Received: from mx2.suse.de ([195.135.220.15]:36076 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728339AbgDHK6b (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Apr 2020 06:58:31 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 995D5ACED;
        Wed,  8 Apr 2020 10:58:26 +0000 (UTC)
From:   Luis Henriques <lhenriques@suse.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        stable@vger.kernel.org, Xiubo Li <xiubli@redhat.com>,
        Luis Henriques <lhenriques@suse.com>
Subject: [PATCH 4.14,4.19 1/2] ceph: remove the extra slashes in the server path
Date:   Wed,  8 Apr 2020 11:58:41 +0100
Message-Id: <20200408105844.21840-4-lhenriques@suse.com>
In-Reply-To: <20200408105844.21840-1-lhenriques@suse.com>
References: <20200408105844.21840-1-lhenriques@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

commit 4fbc0c711b2464ee1551850b85002faae0b775d5 upstream.

It's possible to pass the mount helper a server path that has more
than one contiguous slash character. For example:

  $ mount -t ceph 192.168.195.165:40176:/// /mnt/cephfs/

In the MDS server side the extra slashes of the server path will be
treated as snap dir, and then we can get the following debug logs:

  ceph:  mount opening path //
  ceph:  open_root_inode opening '//'
  ceph:  fill_trace 0000000059b8a3bc is_dentry 0 is_target 1
  ceph:  alloc_inode 00000000dc4ca00b
  ceph:  get_inode created new inode 00000000dc4ca00b 1.ffffffffffffffff ino 1
  ceph:  get_inode on 1=1.ffffffffffffffff got 00000000dc4ca00b

And then when creating any new file or directory under the mount
point, we can hit the following BUG_ON in ceph_fill_trace():

  BUG_ON(ceph_snap(dir) != dvino.snap);

Have the client ignore the extra slashes in the server path when
mounting. This will also canonicalize the path, so that identical mounts
can be consilidated.

1) "//mydir1///mydir//"
2) "/mydir1/mydir"
3) "/mydir1/mydir/"

Regardless of the internal treatment of these paths, the kernel still
stores the original string including the leading '/' for presentation
to userland.

URL: https://tracker.ceph.com/issues/42771
Signed-off-by: Xiubo Li <xiubli@redhat.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Luis Henriques <lhenriques@suse.com>
---
 fs/ceph/super.c | 120 ++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 101 insertions(+), 19 deletions(-)

diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index c4314f449240..712e4a15cb3e 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -105,7 +105,6 @@ static int ceph_statfs(struct dentry *dentry, struct kstatfs *buf)
 	return 0;
 }
 
-
 static int ceph_sync_fs(struct super_block *sb, int wait)
 {
 	struct ceph_fs_client *fsc = ceph_sb_to_client(sb);
@@ -399,6 +398,73 @@ static int strcmp_null(const char *s1, const char *s2)
 	return strcmp(s1, s2);
 }
 
+/**
+ * path_remove_extra_slash - Remove the extra slashes in the server path
+ * @server_path: the server path and could be NULL
+ *
+ * Return NULL if the path is NULL or only consists of "/", or a string
+ * without any extra slashes including the leading slash(es) and the
+ * slash(es) at the end of the server path, such as:
+ * "//dir1////dir2///" --> "dir1/dir2"
+ */
+static char *path_remove_extra_slash(const char *server_path)
+{
+	const char *path = server_path;
+	const char *cur, *end;
+	char *buf, *p;
+	int len;
+
+	/* if the server path is omitted */
+	if (!path)
+		return NULL;
+
+	/* remove all the leading slashes */
+	while (*path == '/')
+		path++;
+
+	/* if the server path only consists of slashes */
+	if (*path == '\0')
+		return NULL;
+
+	len = strlen(path);
+
+	buf = kmalloc(len + 1, GFP_KERNEL);
+	if (!buf)
+		return ERR_PTR(-ENOMEM);
+
+	end = path + len;
+	p = buf;
+	do {
+		cur = strchr(path, '/');
+		if (!cur)
+			cur = end;
+
+		len = cur - path;
+
+		/* including one '/' */
+		if (cur != end)
+			len += 1;
+
+		memcpy(p, path, len);
+		p += len;
+
+		while (cur <= end && *cur == '/')
+			cur++;
+		path = cur;
+	} while (path < end);
+
+	*p = '\0';
+
+	/*
+	 * remove the last slash if there has and just to make sure that
+	 * we will get something like "dir1/dir2"
+	 */
+	if (*(--p) == '/')
+		*p = '\0';
+
+	return buf;
+}
+
 static int compare_mount_options(struct ceph_mount_options *new_fsopt,
 				 struct ceph_options *new_opt,
 				 struct ceph_fs_client *fsc)
@@ -406,6 +472,7 @@ static int compare_mount_options(struct ceph_mount_options *new_fsopt,
 	struct ceph_mount_options *fsopt1 = new_fsopt;
 	struct ceph_mount_options *fsopt2 = fsc->mount_options;
 	int ofs = offsetof(struct ceph_mount_options, snapdir_name);
+	char *p1, *p2;
 	int ret;
 
 	ret = memcmp(fsopt1, fsopt2, ofs);
@@ -418,9 +485,21 @@ static int compare_mount_options(struct ceph_mount_options *new_fsopt,
 	ret = strcmp_null(fsopt1->mds_namespace, fsopt2->mds_namespace);
 	if (ret)
 		return ret;
-	ret = strcmp_null(fsopt1->server_path, fsopt2->server_path);
+
+	p1 = path_remove_extra_slash(fsopt1->server_path);
+	if (IS_ERR(p1))
+		return PTR_ERR(p1);
+	p2 = path_remove_extra_slash(fsopt2->server_path);
+	if (IS_ERR(p2)) {
+		kfree(p1);
+		return PTR_ERR(p2);
+	}
+	ret = strcmp_null(p1, p2);
+	kfree(p1);
+	kfree(p2);
 	if (ret)
 		return ret;
+
 	ret = strcmp_null(fsopt1->fscache_uniq, fsopt2->fscache_uniq);
 	if (ret)
 		return ret;
@@ -476,12 +555,14 @@ static int parse_mount_options(struct ceph_mount_options **pfsopt,
 	 */
 	dev_name_end = strchr(dev_name, '/');
 	if (dev_name_end) {
-		if (strlen(dev_name_end) > 1) {
-			fsopt->server_path = kstrdup(dev_name_end, GFP_KERNEL);
-			if (!fsopt->server_path) {
-				err = -ENOMEM;
-				goto out;
-			}
+		/*
+		 * The server_path will include the whole chars from userland
+		 * including the leading '/'.
+		 */
+		fsopt->server_path = kstrdup(dev_name_end, GFP_KERNEL);
+		if (!fsopt->server_path) {
+			err = -ENOMEM;
+			goto out;
 		}
 	} else {
 		dev_name_end = dev_name + strlen(dev_name);
@@ -810,7 +891,6 @@ static void destroy_caches(void)
 	ceph_fscache_unregister();
 }
 
-
 /*
  * ceph_umount_begin - initiate forced umount.  Tear down down the
  * mount, skipping steps that may hang while waiting for server(s).
@@ -897,9 +977,6 @@ static struct dentry *open_root_dentry(struct ceph_fs_client *fsc,
 	return root;
 }
 
-
-
-
 /*
  * mount: join the ceph cluster, and open root directory.
  */
@@ -913,7 +990,7 @@ static struct dentry *ceph_real_mount(struct ceph_fs_client *fsc)
 	mutex_lock(&fsc->client->mount_mutex);
 
 	if (!fsc->sb->s_root) {
-		const char *path;
+		const char *path, *p;
 		err = __ceph_open_session(fsc->client, started);
 		if (err < 0)
 			goto out;
@@ -925,19 +1002,24 @@ static struct dentry *ceph_real_mount(struct ceph_fs_client *fsc)
 				goto out;
 		}
 
-		if (!fsc->mount_options->server_path) {
-			path = "";
-			dout("mount opening path \\t\n");
-		} else {
-			path = fsc->mount_options->server_path + 1;
-			dout("mount opening path %s\n", path);
+		p = path_remove_extra_slash(fsc->mount_options->server_path);
+		if (IS_ERR(p)) {
+			err = PTR_ERR(p);
+			goto out;
 		}
+		/* if the server path is omitted or just consists of '/' */
+		if (!p)
+			path = "";
+		else
+			path = p;
+		dout("mount opening path '%s'\n", path);
 
 		err = ceph_fs_debugfs_init(fsc);
 		if (err < 0)
 			goto out;
 
 		root = open_root_dentry(fsc, path, started);
+		kfree(p);
 		if (IS_ERR(root)) {
 			err = PTR_ERR(root);
 			goto out;
