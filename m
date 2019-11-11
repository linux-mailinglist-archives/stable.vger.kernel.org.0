Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4334F7F01
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 20:08:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728104AbfKKSiq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:38:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:57752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728482AbfKKSiq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:38:46 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B335421655;
        Mon, 11 Nov 2019 18:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573497524;
        bh=LbnEZgm2BvH2olWHVKKrQ0U9lIl1aIiEKSTyer5PYJc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nZxg0NgmBu8K/qvbuMGOt6GlRYr42zJcncVe/EuuUgdimfpqcZUcXReowhB1wORsz
         1yY1yH+wagZp+E2EGdFCKTrrjBonMsu77NHhfH4QXiW2NcQodkhz9R59PCghm+KpmJ
         p+QKm+rNET55SX/IiAS1yD69ofj6z73X67wVyJKo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4.14 044/105] configfs: provide exclusion between IO and removals
Date:   Mon, 11 Nov 2019 19:28:14 +0100
Message-Id: <20191111181441.059913770@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181421.390326245@linuxfoundation.org>
References: <20191111181421.390326245@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

commit b0841eefd9693827afb9888235e26ddd098f9cef upstream.

Make sure that attribute methods are not called after the item
has been removed from the tree.  To do so, we
	* at the point of no return in removals, grab ->frag_sem
exclusive and mark the fragment dead.
	* call the methods of attributes with ->frag_sem taken
shared and only after having verified that the fragment is still
alive.

	The main benefit is for method instances - they are
guaranteed that the objects they are accessing *and* all ancestors
are still there.  Another win is that we don't need to bother
with extra refcount on config_item when opening a file -
the item will be alive for as long as it stays in the tree, and
we won't touch it/attributes/any associated data after it's
been removed from the tree.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/configfs/dir.c  |   23 ++++++++++++++++
 fs/configfs/file.c |   75 ++++++++++++++++++++++++++++++++++++++++-------------
 2 files changed, 80 insertions(+), 18 deletions(-)

--- a/fs/configfs/dir.c
+++ b/fs/configfs/dir.c
@@ -1474,6 +1474,7 @@ static int configfs_rmdir(struct inode *
 	struct config_item *item;
 	struct configfs_subsystem *subsys;
 	struct configfs_dirent *sd;
+	struct configfs_fragment *frag;
 	struct module *subsys_owner = NULL, *dead_item_owner = NULL;
 	int ret;
 
@@ -1531,6 +1532,16 @@ static int configfs_rmdir(struct inode *
 		}
 	} while (ret == -EAGAIN);
 
+	frag = sd->s_frag;
+	if (down_write_killable(&frag->frag_sem)) {
+		spin_lock(&configfs_dirent_lock);
+		configfs_detach_rollback(dentry);
+		spin_unlock(&configfs_dirent_lock);
+		return -EINTR;
+	}
+	frag->frag_dead = true;
+	up_write(&frag->frag_sem);
+
 	/* Get a working ref for the duration of this function */
 	item = configfs_get_config_item(dentry);
 
@@ -1832,6 +1843,12 @@ void configfs_unregister_group(struct co
 	struct configfs_subsystem *subsys = group->cg_subsys;
 	struct dentry *dentry = group->cg_item.ci_dentry;
 	struct dentry *parent = group->cg_item.ci_parent->ci_dentry;
+	struct configfs_dirent *sd = dentry->d_fsdata;
+	struct configfs_fragment *frag = sd->s_frag;
+
+	down_write(&frag->frag_sem);
+	frag->frag_dead = true;
+	up_write(&frag->frag_sem);
 
 	inode_lock_nested(d_inode(parent), I_MUTEX_PARENT);
 	spin_lock(&configfs_dirent_lock);
@@ -1957,12 +1974,18 @@ void configfs_unregister_subsystem(struc
 	struct config_group *group = &subsys->su_group;
 	struct dentry *dentry = group->cg_item.ci_dentry;
 	struct dentry *root = dentry->d_sb->s_root;
+	struct configfs_dirent *sd = dentry->d_fsdata;
+	struct configfs_fragment *frag = sd->s_frag;
 
 	if (dentry->d_parent != root) {
 		pr_err("Tried to unregister non-subsystem!\n");
 		return;
 	}
 
+	down_write(&frag->frag_sem);
+	frag->frag_dead = true;
+	up_write(&frag->frag_sem);
+
 	inode_lock_nested(d_inode(root),
 			  I_MUTEX_PARENT);
 	inode_lock_nested(d_inode(dentry), I_MUTEX_CHILD);
--- a/fs/configfs/file.c
+++ b/fs/configfs/file.c
@@ -62,22 +62,32 @@ struct configfs_buffer {
 	};
 };
 
+static inline struct configfs_fragment *to_frag(struct file *file)
+{
+	struct configfs_dirent *sd = file->f_path.dentry->d_fsdata;
+
+	return sd->s_frag;
+}
 
-static int fill_read_buffer(struct configfs_buffer * buffer)
+static int fill_read_buffer(struct file *file, struct configfs_buffer *buffer)
 {
-	ssize_t count;
+	struct configfs_fragment *frag = to_frag(file);
+	ssize_t count = -ENOENT;
 
 	if (!buffer->page)
 		buffer->page = (char *) get_zeroed_page(GFP_KERNEL);
 	if (!buffer->page)
 		return -ENOMEM;
 
-	count = buffer->attr->show(buffer->item, buffer->page);
+	down_read(&frag->frag_sem);
+	if (!frag->frag_dead)
+		count = buffer->attr->show(buffer->item, buffer->page);
+	up_read(&frag->frag_sem);
+
 	if (count < 0)
 		return count;
 	if (WARN_ON_ONCE(count > (ssize_t)SIMPLE_ATTR_SIZE))
 		return -EIO;
-
 	buffer->needs_read_fill = 0;
 	buffer->count = count;
 	return 0;
@@ -110,7 +120,7 @@ configfs_read_file(struct file *file, ch
 
 	mutex_lock(&buffer->mutex);
 	if (buffer->needs_read_fill) {
-		retval = fill_read_buffer(buffer);
+		retval = fill_read_buffer(file, buffer);
 		if (retval)
 			goto out;
 	}
@@ -147,6 +157,7 @@ static ssize_t
 configfs_read_bin_file(struct file *file, char __user *buf,
 		       size_t count, loff_t *ppos)
 {
+	struct configfs_fragment *frag = to_frag(file);
 	struct configfs_buffer *buffer = file->private_data;
 	ssize_t retval = 0;
 	ssize_t len = min_t(size_t, count, PAGE_SIZE);
@@ -162,7 +173,12 @@ configfs_read_bin_file(struct file *file
 
 	if (buffer->needs_read_fill) {
 		/* perform first read with buf == NULL to get extent */
-		len = buffer->bin_attr->read(buffer->item, NULL, 0);
+		down_read(&frag->frag_sem);
+		if (!frag->frag_dead)
+			len = buffer->bin_attr->read(buffer->item, NULL, 0);
+		else
+			len = -ENOENT;
+		up_read(&frag->frag_sem);
 		if (len <= 0) {
 			retval = len;
 			goto out;
@@ -182,8 +198,13 @@ configfs_read_bin_file(struct file *file
 		buffer->bin_buffer_size = len;
 
 		/* perform second read to fill buffer */
-		len = buffer->bin_attr->read(buffer->item,
-					     buffer->bin_buffer, len);
+		down_read(&frag->frag_sem);
+		if (!frag->frag_dead)
+			len = buffer->bin_attr->read(buffer->item,
+						     buffer->bin_buffer, len);
+		else
+			len = -ENOENT;
+		up_read(&frag->frag_sem);
 		if (len < 0) {
 			retval = len;
 			vfree(buffer->bin_buffer);
@@ -234,9 +255,16 @@ fill_write_buffer(struct configfs_buffer
 }
 
 static int
-flush_write_buffer(struct configfs_buffer *buffer, size_t count)
+flush_write_buffer(struct file *file, struct configfs_buffer *buffer, size_t count)
 {
-	return buffer->attr->store(buffer->item, buffer->page, count);
+	struct configfs_fragment *frag = to_frag(file);
+	int res = -ENOENT;
+
+	down_read(&frag->frag_sem);
+	if (!frag->frag_dead)
+		res = buffer->attr->store(buffer->item, buffer->page, count);
+	up_read(&frag->frag_sem);
+	return res;
 }
 
 
@@ -266,7 +294,7 @@ configfs_write_file(struct file *file, c
 	mutex_lock(&buffer->mutex);
 	len = fill_write_buffer(buffer, buf, count);
 	if (len > 0)
-		len = flush_write_buffer(buffer, len);
+		len = flush_write_buffer(file, buffer, len);
 	if (len > 0)
 		*ppos += len;
 	mutex_unlock(&buffer->mutex);
@@ -342,6 +370,7 @@ out:
 static int __configfs_open_file(struct inode *inode, struct file *file, int type)
 {
 	struct dentry *dentry = file->f_path.dentry;
+	struct configfs_fragment *frag = to_frag(file);
 	struct configfs_attribute *attr;
 	struct configfs_buffer *buffer;
 	int error;
@@ -351,8 +380,13 @@ static int __configfs_open_file(struct i
 	if (!buffer)
 		goto out;
 
+	error = -ENOENT;
+	down_read(&frag->frag_sem);
+	if (unlikely(frag->frag_dead))
+		goto out_free_buffer;
+
 	error = -EINVAL;
-	buffer->item = configfs_get_config_item(dentry->d_parent);
+	buffer->item = to_item(dentry->d_parent);
 	if (!buffer->item)
 		goto out_free_buffer;
 
@@ -410,6 +444,7 @@ static int __configfs_open_file(struct i
 	buffer->read_in_progress = false;
 	buffer->write_in_progress = false;
 	file->private_data = buffer;
+	up_read(&frag->frag_sem);
 	return 0;
 
 out_put_module:
@@ -417,6 +452,7 @@ out_put_module:
 out_put_item:
 	config_item_put(buffer->item);
 out_free_buffer:
+	up_read(&frag->frag_sem);
 	kfree(buffer);
 out:
 	return error;
@@ -426,8 +462,6 @@ static int configfs_release(struct inode
 {
 	struct configfs_buffer *buffer = filp->private_data;
 
-	if (buffer->item)
-		config_item_put(buffer->item);
 	module_put(buffer->owner);
 	if (buffer->page)
 		free_page((unsigned long)buffer->page);
@@ -453,12 +487,17 @@ static int configfs_release_bin_file(str
 	buffer->read_in_progress = false;
 
 	if (buffer->write_in_progress) {
+		struct configfs_fragment *frag = to_frag(file);
 		buffer->write_in_progress = false;
 
-		/* result of ->release() is ignored */
-		buffer->bin_attr->write(buffer->item, buffer->bin_buffer,
-				buffer->bin_buffer_size);
-
+		down_read(&frag->frag_sem);
+		if (!frag->frag_dead) {
+			/* result of ->release() is ignored */
+			buffer->bin_attr->write(buffer->item,
+					buffer->bin_buffer,
+					buffer->bin_buffer_size);
+		}
+		up_read(&frag->frag_sem);
 		/* vfree on NULL is safe */
 		vfree(buffer->bin_buffer);
 		buffer->bin_buffer = NULL;


