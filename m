Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A2F5F7EB4
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 20:06:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728788AbfKKTE1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 14:04:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:34136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727892AbfKKSmz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:42:55 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E176E21783;
        Mon, 11 Nov 2019 18:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573497773;
        bh=DF2XagEljl5TZRagMPSj2QJvEvvc3sLNxi3EckVbH7M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CJ01nVZnogI5o9SEYhlLiihIlopX57aMLAJDKDNs6FeGS1KUZDCMQ3LfjH/v066t2
         dL0gZRQXOpA14edqlg0K4rj4vjs4WcWl+H5qrYcP3CSJ+kRKt8tgHgxAC8gjwOJZfc
         KX/CBqNEpr+kflXDJv/RJ9x4HhViuxMXqxm9vFGA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4.19 054/125] configfs: new object reprsenting tree fragments
Date:   Mon, 11 Nov 2019 19:28:13 +0100
Message-Id: <20191111181447.508626825@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181438.945353076@linuxfoundation.org>
References: <20191111181438.945353076@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

commit 47320fbe11a6059ae502c9c16b668022fdb4cf76 upstream.

Refcounted, hangs of configfs_dirent, created by operations that add
fragments to configfs tree (mkdir and configfs_register_{subsystem,group}).
Will be used in the next commit to provide exclusion between fragment
removal and ->show/->store calls.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/configfs/configfs_internal.h |   15 ++++-
 fs/configfs/dir.c               |  105 +++++++++++++++++++++++++++++++---------
 fs/configfs/file.c              |    4 -
 3 files changed, 97 insertions(+), 27 deletions(-)

--- a/fs/configfs/configfs_internal.h
+++ b/fs/configfs/configfs_internal.h
@@ -34,6 +34,15 @@
 #include <linux/list.h>
 #include <linux/spinlock.h>
 
+struct configfs_fragment {
+	atomic_t frag_count;
+	struct rw_semaphore frag_sem;
+	bool frag_dead;
+};
+
+void put_fragment(struct configfs_fragment *);
+struct configfs_fragment *get_fragment(struct configfs_fragment *);
+
 struct configfs_dirent {
 	atomic_t		s_count;
 	int			s_dependent_count;
@@ -48,6 +57,7 @@ struct configfs_dirent {
 #ifdef CONFIG_LOCKDEP
 	int			s_depth;
 #endif
+	struct configfs_fragment *s_frag;
 };
 
 #define CONFIGFS_ROOT		0x0001
@@ -75,8 +85,8 @@ extern int configfs_create(struct dentry
 extern int configfs_create_file(struct config_item *, const struct configfs_attribute *);
 extern int configfs_create_bin_file(struct config_item *,
 				    const struct configfs_bin_attribute *);
-extern int configfs_make_dirent(struct configfs_dirent *,
-				struct dentry *, void *, umode_t, int);
+extern int configfs_make_dirent(struct configfs_dirent *, struct dentry *,
+				void *, umode_t, int, struct configfs_fragment *);
 extern int configfs_dirent_is_ready(struct configfs_dirent *);
 
 extern void configfs_hash_and_remove(struct dentry * dir, const char * name);
@@ -151,6 +161,7 @@ static inline void release_configfs_dire
 {
 	if (!(sd->s_type & CONFIGFS_ROOT)) {
 		kfree(sd->s_iattr);
+		put_fragment(sd->s_frag);
 		kmem_cache_free(configfs_dir_cachep, sd);
 	}
 }
--- a/fs/configfs/dir.c
+++ b/fs/configfs/dir.c
@@ -164,11 +164,38 @@ configfs_adjust_dir_dirent_depth_after_p
 
 #endif /* CONFIG_LOCKDEP */
 
+static struct configfs_fragment *new_fragment(void)
+{
+	struct configfs_fragment *p;
+
+	p = kmalloc(sizeof(struct configfs_fragment), GFP_KERNEL);
+	if (p) {
+		atomic_set(&p->frag_count, 1);
+		init_rwsem(&p->frag_sem);
+		p->frag_dead = false;
+	}
+	return p;
+}
+
+void put_fragment(struct configfs_fragment *frag)
+{
+	if (frag && atomic_dec_and_test(&frag->frag_count))
+		kfree(frag);
+}
+
+struct configfs_fragment *get_fragment(struct configfs_fragment *frag)
+{
+	if (likely(frag))
+		atomic_inc(&frag->frag_count);
+	return frag;
+}
+
 /*
  * Allocates a new configfs_dirent and links it to the parent configfs_dirent
  */
 static struct configfs_dirent *configfs_new_dirent(struct configfs_dirent *parent_sd,
-						   void *element, int type)
+						   void *element, int type,
+						   struct configfs_fragment *frag)
 {
 	struct configfs_dirent * sd;
 
@@ -188,6 +215,7 @@ static struct configfs_dirent *configfs_
 		kmem_cache_free(configfs_dir_cachep, sd);
 		return ERR_PTR(-ENOENT);
 	}
+	sd->s_frag = get_fragment(frag);
 	list_add(&sd->s_sibling, &parent_sd->s_children);
 	spin_unlock(&configfs_dirent_lock);
 
@@ -222,11 +250,11 @@ static int configfs_dirent_exists(struct
 
 int configfs_make_dirent(struct configfs_dirent * parent_sd,
 			 struct dentry * dentry, void * element,
-			 umode_t mode, int type)
+			 umode_t mode, int type, struct configfs_fragment *frag)
 {
 	struct configfs_dirent * sd;
 
-	sd = configfs_new_dirent(parent_sd, element, type);
+	sd = configfs_new_dirent(parent_sd, element, type, frag);
 	if (IS_ERR(sd))
 		return PTR_ERR(sd);
 
@@ -273,7 +301,8 @@ static void init_symlink(struct inode *
  *	until it is validated by configfs_dir_set_ready()
  */
 
-static int configfs_create_dir(struct config_item *item, struct dentry *dentry)
+static int configfs_create_dir(struct config_item *item, struct dentry *dentry,
+				struct configfs_fragment *frag)
 {
 	int error;
 	umode_t mode = S_IFDIR| S_IRWXU | S_IRUGO | S_IXUGO;
@@ -286,7 +315,8 @@ static int configfs_create_dir(struct co
 		return error;
 
 	error = configfs_make_dirent(p->d_fsdata, dentry, item, mode,
-				     CONFIGFS_DIR | CONFIGFS_USET_CREATING);
+				     CONFIGFS_DIR | CONFIGFS_USET_CREATING,
+				     frag);
 	if (unlikely(error))
 		return error;
 
@@ -351,9 +381,10 @@ int configfs_create_link(struct configfs
 {
 	int err = 0;
 	umode_t mode = S_IFLNK | S_IRWXUGO;
+	struct configfs_dirent *p = parent->d_fsdata;
 
-	err = configfs_make_dirent(parent->d_fsdata, dentry, sl, mode,
-				   CONFIGFS_ITEM_LINK);
+	err = configfs_make_dirent(p, dentry, sl, mode,
+				   CONFIGFS_ITEM_LINK, p->s_frag);
 	if (!err) {
 		err = configfs_create(dentry, mode, init_symlink);
 		if (err) {
@@ -612,7 +643,8 @@ static int populate_attrs(struct config_
 
 static int configfs_attach_group(struct config_item *parent_item,
 				 struct config_item *item,
-				 struct dentry *dentry);
+				 struct dentry *dentry,
+				 struct configfs_fragment *frag);
 static void configfs_detach_group(struct config_item *item);
 
 static void detach_groups(struct config_group *group)
@@ -660,7 +692,8 @@ static void detach_groups(struct config_
  * try using vfs_mkdir.  Just a thought.
  */
 static int create_default_group(struct config_group *parent_group,
-				struct config_group *group)
+				struct config_group *group,
+				struct configfs_fragment *frag)
 {
 	int ret;
 	struct configfs_dirent *sd;
@@ -676,7 +709,7 @@ static int create_default_group(struct c
 		d_add(child, NULL);
 
 		ret = configfs_attach_group(&parent_group->cg_item,
-					    &group->cg_item, child);
+					    &group->cg_item, child, frag);
 		if (!ret) {
 			sd = child->d_fsdata;
 			sd->s_type |= CONFIGFS_USET_DEFAULT;
@@ -690,13 +723,14 @@ static int create_default_group(struct c
 	return ret;
 }
 
-static int populate_groups(struct config_group *group)
+static int populate_groups(struct config_group *group,
+			   struct configfs_fragment *frag)
 {
 	struct config_group *new_group;
 	int ret = 0;
 
 	list_for_each_entry(new_group, &group->default_groups, group_entry) {
-		ret = create_default_group(group, new_group);
+		ret = create_default_group(group, new_group, frag);
 		if (ret) {
 			detach_groups(group);
 			break;
@@ -810,11 +844,12 @@ static void link_group(struct config_gro
  */
 static int configfs_attach_item(struct config_item *parent_item,
 				struct config_item *item,
-				struct dentry *dentry)
+				struct dentry *dentry,
+				struct configfs_fragment *frag)
 {
 	int ret;
 
-	ret = configfs_create_dir(item, dentry);
+	ret = configfs_create_dir(item, dentry, frag);
 	if (!ret) {
 		ret = populate_attrs(item);
 		if (ret) {
@@ -844,12 +879,13 @@ static void configfs_detach_item(struct
 
 static int configfs_attach_group(struct config_item *parent_item,
 				 struct config_item *item,
-				 struct dentry *dentry)
+				 struct dentry *dentry,
+				 struct configfs_fragment *frag)
 {
 	int ret;
 	struct configfs_dirent *sd;
 
-	ret = configfs_attach_item(parent_item, item, dentry);
+	ret = configfs_attach_item(parent_item, item, dentry, frag);
 	if (!ret) {
 		sd = dentry->d_fsdata;
 		sd->s_type |= CONFIGFS_USET_DIR;
@@ -865,7 +901,7 @@ static int configfs_attach_group(struct
 		 */
 		inode_lock_nested(d_inode(dentry), I_MUTEX_CHILD);
 		configfs_adjust_dir_dirent_depth_before_populate(sd);
-		ret = populate_groups(to_config_group(item));
+		ret = populate_groups(to_config_group(item), frag);
 		if (ret) {
 			configfs_detach_item(item);
 			d_inode(dentry)->i_flags |= S_DEAD;
@@ -1260,6 +1296,7 @@ static int configfs_mkdir(struct inode *
 	struct configfs_dirent *sd;
 	const struct config_item_type *type;
 	struct module *subsys_owner = NULL, *new_item_owner = NULL;
+	struct configfs_fragment *frag;
 	char *name;
 
 	sd = dentry->d_parent->d_fsdata;
@@ -1278,6 +1315,12 @@ static int configfs_mkdir(struct inode *
 		goto out;
 	}
 
+	frag = new_fragment();
+	if (!frag) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
 	/* Get a working ref for the duration of this function */
 	parent_item = configfs_get_config_item(dentry->d_parent);
 	type = parent_item->ci_type;
@@ -1380,9 +1423,9 @@ static int configfs_mkdir(struct inode *
 	spin_unlock(&configfs_dirent_lock);
 
 	if (group)
-		ret = configfs_attach_group(parent_item, item, dentry);
+		ret = configfs_attach_group(parent_item, item, dentry, frag);
 	else
-		ret = configfs_attach_item(parent_item, item, dentry);
+		ret = configfs_attach_item(parent_item, item, dentry, frag);
 
 	spin_lock(&configfs_dirent_lock);
 	sd->s_type &= ~CONFIGFS_USET_IN_MKDIR;
@@ -1419,6 +1462,7 @@ out_put:
 	 * reference.
 	 */
 	config_item_put(parent_item);
+	put_fragment(frag);
 
 out:
 	return ret;
@@ -1587,7 +1631,7 @@ static int configfs_dir_open(struct inod
 	 */
 	err = -ENOENT;
 	if (configfs_dirent_is_ready(parent_sd)) {
-		file->private_data = configfs_new_dirent(parent_sd, NULL, 0);
+		file->private_data = configfs_new_dirent(parent_sd, NULL, 0, NULL);
 		if (IS_ERR(file->private_data))
 			err = PTR_ERR(file->private_data);
 		else
@@ -1743,8 +1787,13 @@ int configfs_register_group(struct confi
 {
 	struct configfs_subsystem *subsys = parent_group->cg_subsys;
 	struct dentry *parent;
+	struct configfs_fragment *frag;
 	int ret;
 
+	frag = new_fragment();
+	if (!frag)
+		return -ENOMEM;
+
 	mutex_lock(&subsys->su_mutex);
 	link_group(parent_group, group);
 	mutex_unlock(&subsys->su_mutex);
@@ -1752,7 +1801,7 @@ int configfs_register_group(struct confi
 	parent = parent_group->cg_item.ci_dentry;
 
 	inode_lock_nested(d_inode(parent), I_MUTEX_PARENT);
-	ret = create_default_group(parent_group, group);
+	ret = create_default_group(parent_group, group, frag);
 	if (ret)
 		goto err_out;
 
@@ -1760,12 +1809,14 @@ int configfs_register_group(struct confi
 	configfs_dir_set_ready(group->cg_item.ci_dentry->d_fsdata);
 	spin_unlock(&configfs_dirent_lock);
 	inode_unlock(d_inode(parent));
+	put_fragment(frag);
 	return 0;
 err_out:
 	inode_unlock(d_inode(parent));
 	mutex_lock(&subsys->su_mutex);
 	unlink_group(group);
 	mutex_unlock(&subsys->su_mutex);
+	put_fragment(frag);
 	return ret;
 }
 EXPORT_SYMBOL(configfs_register_group);
@@ -1852,10 +1903,17 @@ int configfs_register_subsystem(struct c
 	struct dentry *dentry;
 	struct dentry *root;
 	struct configfs_dirent *sd;
+	struct configfs_fragment *frag;
+
+	frag = new_fragment();
+	if (!frag)
+		return -ENOMEM;
 
 	root = configfs_pin_fs();
-	if (IS_ERR(root))
+	if (IS_ERR(root)) {
+		put_fragment(frag);
 		return PTR_ERR(root);
+	}
 
 	if (!group->cg_item.ci_name)
 		group->cg_item.ci_name = group->cg_item.ci_namebuf;
@@ -1871,7 +1929,7 @@ int configfs_register_subsystem(struct c
 		d_add(dentry, NULL);
 
 		err = configfs_attach_group(sd->s_element, &group->cg_item,
-					    dentry);
+					    dentry, frag);
 		if (err) {
 			BUG_ON(d_inode(dentry));
 			d_drop(dentry);
@@ -1889,6 +1947,7 @@ int configfs_register_subsystem(struct c
 		unlink_group(group);
 		configfs_release_fs();
 	}
+	put_fragment(frag);
 
 	return err;
 }
--- a/fs/configfs/file.c
+++ b/fs/configfs/file.c
@@ -502,7 +502,7 @@ int configfs_create_file(struct config_i
 
 	inode_lock_nested(d_inode(dir), I_MUTEX_NORMAL);
 	error = configfs_make_dirent(parent_sd, NULL, (void *) attr, mode,
-				     CONFIGFS_ITEM_ATTR);
+				     CONFIGFS_ITEM_ATTR, parent_sd->s_frag);
 	inode_unlock(d_inode(dir));
 
 	return error;
@@ -524,7 +524,7 @@ int configfs_create_bin_file(struct conf
 
 	inode_lock_nested(dir->d_inode, I_MUTEX_NORMAL);
 	error = configfs_make_dirent(parent_sd, NULL, (void *) bin_attr, mode,
-				     CONFIGFS_ITEM_BIN_ATTR);
+				     CONFIGFS_ITEM_BIN_ATTR, parent_sd->s_frag);
 	inode_unlock(dir->d_inode);
 
 	return error;


