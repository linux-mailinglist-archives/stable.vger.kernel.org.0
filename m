Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AF16F7F4B
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 20:10:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728060AbfKKSc5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:32:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:50318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727122AbfKKSc5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:32:57 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 038772184C;
        Mon, 11 Nov 2019 18:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573497175;
        bh=JMJu/ISpO+Ofu3e9o07t2yxI0gvmIbFGoKPqbXSo4y0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AsBME0Qd05dnormaUKD/q6WTyJoBUghTMmQkXSro1aDGTAkC3dg3uLoqIH+OAYndn
         YfboH4xseE26QV1HC2Fc6B7qnJRP9idjfji05XRLK7Yf510zWoCbe96d1IlCQaqGlL
         9QXCUsZNcgwEXZcrXg6ON6H7X504drITjfxbFu2Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4.9 28/65] configfs: stash the data we need into configfs_buffer at open time
Date:   Mon, 11 Nov 2019 19:28:28 +0100
Message-Id: <20191111181346.248477260@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181331.917659011@linuxfoundation.org>
References: <20191111181331.917659011@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

commit ff4dd081977da56566a848f071aed8fa92d604a1 upstream.

simplifies the ->read()/->write()/->release() instances nicely

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/configfs/file.c |  229 +++++++++++++++++++++--------------------------------
 1 file changed, 95 insertions(+), 134 deletions(-)

--- a/fs/configfs/file.c
+++ b/fs/configfs/file.c
@@ -53,24 +53,18 @@ struct configfs_buffer {
 	bool			write_in_progress;
 	char			*bin_buffer;
 	int			bin_buffer_size;
+	int			cb_max_size;
+	struct config_item	*item;
+	struct module		*owner;
+	union {
+		struct configfs_attribute	*attr;
+		struct configfs_bin_attribute	*bin_attr;
+	};
 };
 
 
-/**
- *	fill_read_buffer - allocate and fill buffer from item.
- *	@dentry:	dentry pointer.
- *	@buffer:	data buffer for file.
- *
- *	Allocate @buffer->page, if it hasn't been already, then call the
- *	config_item's show() method to fill the buffer with this attribute's
- *	data.
- *	This is called only once, on the file's first read.
- */
-static int fill_read_buffer(struct dentry * dentry, struct configfs_buffer * buffer)
+static int fill_read_buffer(struct configfs_buffer * buffer)
 {
-	struct configfs_attribute * attr = to_attr(dentry);
-	struct config_item * item = to_item(dentry->d_parent);
-	int ret = 0;
 	ssize_t count;
 
 	if (!buffer->page)
@@ -78,15 +72,15 @@ static int fill_read_buffer(struct dentr
 	if (!buffer->page)
 		return -ENOMEM;
 
-	count = attr->show(item, buffer->page);
+	count = buffer->attr->show(buffer->item, buffer->page);
+	if (count < 0)
+		return count;
+	if (WARN_ON_ONCE(count > (ssize_t)SIMPLE_ATTR_SIZE))
+		return -EIO;
 
-	BUG_ON(count > (ssize_t)SIMPLE_ATTR_SIZE);
-	if (count >= 0) {
-		buffer->needs_read_fill = 0;
-		buffer->count = count;
-	} else
-		ret = count;
-	return ret;
+	buffer->needs_read_fill = 0;
+	buffer->count = count;
+	return 0;
 }
 
 /**
@@ -111,12 +105,13 @@ static int fill_read_buffer(struct dentr
 static ssize_t
 configfs_read_file(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 {
-	struct configfs_buffer * buffer = file->private_data;
+	struct configfs_buffer *buffer = file->private_data;
 	ssize_t retval = 0;
 
 	mutex_lock(&buffer->mutex);
 	if (buffer->needs_read_fill) {
-		if ((retval = fill_read_buffer(file->f_path.dentry,buffer)))
+		retval = fill_read_buffer(buffer);
+		if (retval)
 			goto out;
 	}
 	pr_debug("%s: count = %zd, ppos = %lld, buf = %s\n",
@@ -153,9 +148,6 @@ configfs_read_bin_file(struct file *file
 		       size_t count, loff_t *ppos)
 {
 	struct configfs_buffer *buffer = file->private_data;
-	struct dentry *dentry = file->f_path.dentry;
-	struct config_item *item = to_item(dentry->d_parent);
-	struct configfs_bin_attribute *bin_attr = to_bin_attr(dentry);
 	ssize_t retval = 0;
 	ssize_t len = min_t(size_t, count, PAGE_SIZE);
 
@@ -170,14 +162,14 @@ configfs_read_bin_file(struct file *file
 
 	if (buffer->needs_read_fill) {
 		/* perform first read with buf == NULL to get extent */
-		len = bin_attr->read(item, NULL, 0);
+		len = buffer->bin_attr->read(buffer->item, NULL, 0);
 		if (len <= 0) {
 			retval = len;
 			goto out;
 		}
 
 		/* do not exceed the maximum value */
-		if (bin_attr->cb_max_size && len > bin_attr->cb_max_size) {
+		if (buffer->cb_max_size && len > buffer->cb_max_size) {
 			retval = -EFBIG;
 			goto out;
 		}
@@ -190,7 +182,8 @@ configfs_read_bin_file(struct file *file
 		buffer->bin_buffer_size = len;
 
 		/* perform second read to fill buffer */
-		len = bin_attr->read(item, buffer->bin_buffer, len);
+		len = buffer->bin_attr->read(buffer->item,
+					     buffer->bin_buffer, len);
 		if (len < 0) {
 			retval = len;
 			vfree(buffer->bin_buffer);
@@ -240,25 +233,10 @@ fill_write_buffer(struct configfs_buffer
 	return error ? -EFAULT : count;
 }
 
-
-/**
- *	flush_write_buffer - push buffer to config_item.
- *	@dentry:	dentry to the attribute
- *	@buffer:	data buffer for file.
- *	@count:		number of bytes
- *
- *	Get the correct pointers for the config_item and the attribute we're
- *	dealing with, then call the store() method for the attribute,
- *	passing the buffer that we acquired in fill_write_buffer().
- */
-
 static int
-flush_write_buffer(struct dentry * dentry, struct configfs_buffer * buffer, size_t count)
+flush_write_buffer(struct configfs_buffer *buffer, size_t count)
 {
-	struct configfs_attribute * attr = to_attr(dentry);
-	struct config_item * item = to_item(dentry->d_parent);
-
-	return attr->store(item, buffer->page, count);
+	return buffer->attr->store(buffer->item, buffer->page, count);
 }
 
 
@@ -282,13 +260,13 @@ flush_write_buffer(struct dentry * dentr
 static ssize_t
 configfs_write_file(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
 {
-	struct configfs_buffer * buffer = file->private_data;
+	struct configfs_buffer *buffer = file->private_data;
 	ssize_t len;
 
 	mutex_lock(&buffer->mutex);
 	len = fill_write_buffer(buffer, buf, count);
 	if (len > 0)
-		len = flush_write_buffer(file->f_path.dentry, buffer, len);
+		len = flush_write_buffer(buffer, len);
 	if (len > 0)
 		*ppos += len;
 	mutex_unlock(&buffer->mutex);
@@ -313,8 +291,6 @@ configfs_write_bin_file(struct file *fil
 			size_t count, loff_t *ppos)
 {
 	struct configfs_buffer *buffer = file->private_data;
-	struct dentry *dentry = file->f_path.dentry;
-	struct configfs_bin_attribute *bin_attr = to_bin_attr(dentry);
 	void *tbuf = NULL;
 	ssize_t len;
 
@@ -330,8 +306,8 @@ configfs_write_bin_file(struct file *fil
 	/* buffer grows? */
 	if (*ppos + count > buffer->bin_buffer_size) {
 
-		if (bin_attr->cb_max_size &&
-			*ppos + count > bin_attr->cb_max_size) {
+		if (buffer->cb_max_size &&
+			*ppos + count > buffer->cb_max_size) {
 			len = -EFBIG;
 			goto out;
 		}
@@ -363,31 +339,45 @@ out:
 	return len;
 }
 
-static int check_perm(struct inode * inode, struct file * file, int type)
+static int __configfs_open_file(struct inode *inode, struct file *file, int type)
 {
-	struct config_item *item = configfs_get_config_item(file->f_path.dentry->d_parent);
-	struct configfs_attribute * attr = to_attr(file->f_path.dentry);
-	struct configfs_bin_attribute *bin_attr = NULL;
-	struct configfs_buffer * buffer;
-	struct configfs_item_operations * ops = NULL;
-	int error = 0;
+	struct dentry *dentry = file->f_path.dentry;
+	struct configfs_attribute *attr;
+	struct configfs_buffer *buffer;
+	int error;
 
-	if (!item || !attr)
-		goto Einval;
+	error = -ENOMEM;
+	buffer = kzalloc(sizeof(struct configfs_buffer), GFP_KERNEL);
+	if (!buffer)
+		goto out;
 
-	if (type & CONFIGFS_ITEM_BIN_ATTR)
-		bin_attr = to_bin_attr(file->f_path.dentry);
+	error = -EINVAL;
+	buffer->item = configfs_get_config_item(dentry->d_parent);
+	if (!buffer->item)
+		goto out_free_buffer;
+
+	attr = to_attr(dentry);
+	if (!attr)
+		goto out_put_item;
+
+	if (type & CONFIGFS_ITEM_BIN_ATTR) {
+		buffer->bin_attr = to_bin_attr(dentry);
+		buffer->cb_max_size = buffer->bin_attr->cb_max_size;
+	} else {
+		buffer->attr = attr;
+	}
 
+	buffer->owner = attr->ca_owner;
 	/* Grab the module reference for this attribute if we have one */
-	if (!try_module_get(attr->ca_owner)) {
-		error = -ENODEV;
-		goto Done;
-	}
+	error = -ENODEV;
+	if (!try_module_get(buffer->owner))
+		goto out_put_item;
 
-	if (item->ci_type)
-		ops = item->ci_type->ct_item_ops;
-	else
-		goto Eaccess;
+	error = -EACCES;
+	if (!buffer->item->ci_type)
+		goto out_put_module;
+
+	buffer->ops = buffer->item->ci_type->ct_item_ops;
 
 	/* File needs write support.
 	 * The inode's perms must say it's ok,
@@ -395,13 +385,11 @@ static int check_perm(struct inode * ino
 	 */
 	if (file->f_mode & FMODE_WRITE) {
 		if (!(inode->i_mode & S_IWUGO))
-			goto Eaccess;
-
+			goto out_put_module;
 		if ((type & CONFIGFS_ITEM_ATTR) && !attr->store)
-			goto Eaccess;
-
-		if ((type & CONFIGFS_ITEM_BIN_ATTR) && !bin_attr->write)
-			goto Eaccess;
+			goto out_put_module;
+		if ((type & CONFIGFS_ITEM_BIN_ATTR) && !buffer->bin_attr->write)
+			goto out_put_module;
 	}
 
 	/* File needs read support.
@@ -410,90 +398,65 @@ static int check_perm(struct inode * ino
 	 */
 	if (file->f_mode & FMODE_READ) {
 		if (!(inode->i_mode & S_IRUGO))
-			goto Eaccess;
-
+			goto out_put_module;
 		if ((type & CONFIGFS_ITEM_ATTR) && !attr->show)
-			goto Eaccess;
-
-		if ((type & CONFIGFS_ITEM_BIN_ATTR) && !bin_attr->read)
-			goto Eaccess;
+			goto out_put_module;
+		if ((type & CONFIGFS_ITEM_BIN_ATTR) && !buffer->bin_attr->read)
+			goto out_put_module;
 	}
 
-	/* No error? Great, allocate a buffer for the file, and store it
-	 * it in file->private_data for easy access.
-	 */
-	buffer = kzalloc(sizeof(struct configfs_buffer),GFP_KERNEL);
-	if (!buffer) {
-		error = -ENOMEM;
-		goto Enomem;
-	}
 	mutex_init(&buffer->mutex);
 	buffer->needs_read_fill = 1;
 	buffer->read_in_progress = false;
 	buffer->write_in_progress = false;
-	buffer->ops = ops;
 	file->private_data = buffer;
-	goto Done;
+	return 0;
 
- Einval:
-	error = -EINVAL;
-	goto Done;
- Eaccess:
-	error = -EACCES;
- Enomem:
-	module_put(attr->ca_owner);
- Done:
-	if (error && item)
-		config_item_put(item);
+out_put_module:
+	module_put(buffer->owner);
+out_put_item:
+	config_item_put(buffer->item);
+out_free_buffer:
+	kfree(buffer);
+out:
 	return error;
 }
 
 static int configfs_release(struct inode *inode, struct file *filp)
 {
-	struct config_item * item = to_item(filp->f_path.dentry->d_parent);
-	struct configfs_attribute * attr = to_attr(filp->f_path.dentry);
-	struct module * owner = attr->ca_owner;
-	struct configfs_buffer * buffer = filp->private_data;
-
-	if (item)
-		config_item_put(item);
-	/* After this point, attr should not be accessed. */
-	module_put(owner);
-
-	if (buffer) {
-		if (buffer->page)
-			free_page((unsigned long)buffer->page);
-		mutex_destroy(&buffer->mutex);
-		kfree(buffer);
-	}
+	struct configfs_buffer *buffer = filp->private_data;
+
+	if (buffer->item)
+		config_item_put(buffer->item);
+	module_put(buffer->owner);
+	if (buffer->page)
+		free_page((unsigned long)buffer->page);
+	mutex_destroy(&buffer->mutex);
+	kfree(buffer);
 	return 0;
 }
 
 static int configfs_open_file(struct inode *inode, struct file *filp)
 {
-	return check_perm(inode, filp, CONFIGFS_ITEM_ATTR);
+	return __configfs_open_file(inode, filp, CONFIGFS_ITEM_ATTR);
 }
 
 static int configfs_open_bin_file(struct inode *inode, struct file *filp)
 {
-	return check_perm(inode, filp, CONFIGFS_ITEM_BIN_ATTR);
+	return __configfs_open_file(inode, filp, CONFIGFS_ITEM_BIN_ATTR);
 }
 
-static int configfs_release_bin_file(struct inode *inode, struct file *filp)
+static int configfs_release_bin_file(struct inode *inode, struct file *file)
 {
-	struct configfs_buffer *buffer = filp->private_data;
-	struct dentry *dentry = filp->f_path.dentry;
-	struct config_item *item = to_item(dentry->d_parent);
-	struct configfs_bin_attribute *bin_attr = to_bin_attr(dentry);
-	ssize_t len = 0;
-	int ret;
+	struct configfs_buffer *buffer = file->private_data;
 
 	buffer->read_in_progress = false;
 
 	if (buffer->write_in_progress) {
 		buffer->write_in_progress = false;
 
-		len = bin_attr->write(item, buffer->bin_buffer,
+		/* result of ->release() is ignored */
+		buffer->bin_attr->write(buffer->item, buffer->bin_buffer,
 				buffer->bin_buffer_size);
 
 		/* vfree on NULL is safe */
@@ -503,10 +466,8 @@ static int configfs_release_bin_file(str
 		buffer->needs_read_fill = 1;
 	}
 
-	ret = configfs_release(inode, filp);
-	if (len < 0)
-		return len;
-	return ret;
+	configfs_release(inode, file);
+	return 0;
 }
 
 


