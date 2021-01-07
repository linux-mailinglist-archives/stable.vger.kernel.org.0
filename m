Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FA0E2ED29E
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 15:38:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728096AbhAGOex (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 09:34:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:47970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728466AbhAGOdy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Jan 2021 09:33:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5095423343;
        Thu,  7 Jan 2021 14:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610029992;
        bh=XKaF01rtmpJ9PGRq4iodmGS/YyQAQhgJaP7IiiBpG+A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LaN5uahqFWSq2h6O7reZCHc7QwypWvyzTki6n1q3K1QDPWIykU0/FBHyCqCpGR7yM
         Ut3qgJ4Y1KaBplD9VG1rU3KA3yFwVIQjQ9E7E+SSGUqzPOUkn8u+atOAWlPg01fLPb
         mXdXW6om222mB7m+8bE/vWdsAz0hM78HQr189aak=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+f427adf9324b92652ccc@syzkaller.appspotmail.com,
        Miklos Szeredi <mszeredi@redhat.com>, Jan Kara <jack@suse.cz>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 15/20] fuse: fix bad inode
Date:   Thu,  7 Jan 2021 15:34:10 +0100
Message-Id: <20210107143054.525881691@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210107143052.392839477@linuxfoundation.org>
References: <20210107143052.392839477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miklos Szeredi <mszeredi@redhat.com>

[ Upstream commit 5d069dbe8aaf2a197142558b6fb2978189ba3454 ]

Jan Kara's analysis of the syzbot report (edited):

  The reproducer opens a directory on FUSE filesystem, it then attaches
  dnotify mark to the open directory.  After that a fuse_do_getattr() call
  finds that attributes returned by the server are inconsistent, and calls
  make_bad_inode() which, among other things does:

          inode->i_mode = S_IFREG;

  This then confuses dnotify which doesn't tear down its structures
  properly and eventually crashes.

Avoid calling make_bad_inode() on a live inode: switch to a private flag on
the fuse inode.  Also add the test to ops which the bad_inode_ops would
have caught.

This bug goes back to the initial merge of fuse in 2.6.14...

Reported-by: syzbot+f427adf9324b92652ccc@syzkaller.appspotmail.com
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Tested-by: Jan Kara <jack@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/acl.c     |  6 ++++++
 fs/fuse/dir.c     | 37 ++++++++++++++++++++++++++++++++-----
 fs/fuse/file.c    | 19 +++++++++++--------
 fs/fuse/fuse_i.h  | 12 ++++++++++++
 fs/fuse/inode.c   |  4 ++--
 fs/fuse/readdir.c |  4 ++--
 fs/fuse/xattr.c   |  9 +++++++++
 7 files changed, 74 insertions(+), 17 deletions(-)

diff --git a/fs/fuse/acl.c b/fs/fuse/acl.c
index 5a48cee6d7d33..f529075a2ce87 100644
--- a/fs/fuse/acl.c
+++ b/fs/fuse/acl.c
@@ -19,6 +19,9 @@ struct posix_acl *fuse_get_acl(struct inode *inode, int type)
 	void *value = NULL;
 	struct posix_acl *acl;
 
+	if (fuse_is_bad(inode))
+		return ERR_PTR(-EIO);
+
 	if (!fc->posix_acl || fc->no_getxattr)
 		return NULL;
 
@@ -53,6 +56,9 @@ int fuse_set_acl(struct inode *inode, struct posix_acl *acl, int type)
 	const char *name;
 	int ret;
 
+	if (fuse_is_bad(inode))
+		return -EIO;
+
 	if (!fc->posix_acl || fc->no_setxattr)
 		return -EOPNOTSUPP;
 
diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index ff7dbeb16f88d..ffa031fe52933 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -202,7 +202,7 @@ static int fuse_dentry_revalidate(struct dentry *entry, unsigned int flags)
 	int ret;
 
 	inode = d_inode_rcu(entry);
-	if (inode && is_bad_inode(inode))
+	if (inode && fuse_is_bad(inode))
 		goto invalid;
 	else if (time_before64(fuse_dentry_time(entry), get_jiffies_64()) ||
 		 (flags & LOOKUP_REVAL)) {
@@ -463,6 +463,9 @@ static struct dentry *fuse_lookup(struct inode *dir, struct dentry *entry,
 	bool outarg_valid = true;
 	bool locked;
 
+	if (fuse_is_bad(dir))
+		return ERR_PTR(-EIO);
+
 	locked = fuse_lock_inode(dir);
 	err = fuse_lookup_name(dir->i_sb, get_node_id(dir), &entry->d_name,
 			       &outarg, &inode);
@@ -606,6 +609,9 @@ static int fuse_atomic_open(struct inode *dir, struct dentry *entry,
 	struct fuse_conn *fc = get_fuse_conn(dir);
 	struct dentry *res = NULL;
 
+	if (fuse_is_bad(dir))
+		return -EIO;
+
 	if (d_in_lookup(entry)) {
 		res = fuse_lookup(dir, entry, 0);
 		if (IS_ERR(res))
@@ -654,6 +660,9 @@ static int create_new_entry(struct fuse_mount *fm, struct fuse_args *args,
 	int err;
 	struct fuse_forget_link *forget;
 
+	if (fuse_is_bad(dir))
+		return -EIO;
+
 	forget = fuse_alloc_forget();
 	if (!forget)
 		return -ENOMEM;
@@ -781,6 +790,9 @@ static int fuse_unlink(struct inode *dir, struct dentry *entry)
 	struct fuse_mount *fm = get_fuse_mount(dir);
 	FUSE_ARGS(args);
 
+	if (fuse_is_bad(dir))
+		return -EIO;
+
 	args.opcode = FUSE_UNLINK;
 	args.nodeid = get_node_id(dir);
 	args.in_numargs = 1;
@@ -817,6 +829,9 @@ static int fuse_rmdir(struct inode *dir, struct dentry *entry)
 	struct fuse_mount *fm = get_fuse_mount(dir);
 	FUSE_ARGS(args);
 
+	if (fuse_is_bad(dir))
+		return -EIO;
+
 	args.opcode = FUSE_RMDIR;
 	args.nodeid = get_node_id(dir);
 	args.in_numargs = 1;
@@ -895,6 +910,9 @@ static int fuse_rename2(struct inode *olddir, struct dentry *oldent,
 	struct fuse_conn *fc = get_fuse_conn(olddir);
 	int err;
 
+	if (fuse_is_bad(olddir))
+		return -EIO;
+
 	if (flags & ~(RENAME_NOREPLACE | RENAME_EXCHANGE | RENAME_WHITEOUT))
 		return -EINVAL;
 
@@ -1030,7 +1048,7 @@ static int fuse_do_getattr(struct inode *inode, struct kstat *stat,
 	if (!err) {
 		if (fuse_invalid_attr(&outarg.attr) ||
 		    (inode->i_mode ^ outarg.attr.mode) & S_IFMT) {
-			make_bad_inode(inode);
+			fuse_make_bad(inode);
 			err = -EIO;
 		} else {
 			fuse_change_attributes(inode, &outarg.attr,
@@ -1232,6 +1250,9 @@ static int fuse_permission(struct inode *inode, int mask)
 	bool refreshed = false;
 	int err = 0;
 
+	if (fuse_is_bad(inode))
+		return -EIO;
+
 	if (!fuse_allow_current_process(fc))
 		return -EACCES;
 
@@ -1327,7 +1348,7 @@ static const char *fuse_get_link(struct dentry *dentry, struct inode *inode,
 	int err;
 
 	err = -EIO;
-	if (is_bad_inode(inode))
+	if (fuse_is_bad(inode))
 		goto out_err;
 
 	if (fc->cache_symlinks)
@@ -1375,7 +1396,7 @@ static int fuse_dir_fsync(struct file *file, loff_t start, loff_t end,
 	struct fuse_conn *fc = get_fuse_conn(inode);
 	int err;
 
-	if (is_bad_inode(inode))
+	if (fuse_is_bad(inode))
 		return -EIO;
 
 	if (fc->no_fsyncdir)
@@ -1664,7 +1685,7 @@ int fuse_do_setattr(struct dentry *dentry, struct iattr *attr,
 
 	if (fuse_invalid_attr(&outarg.attr) ||
 	    (inode->i_mode ^ outarg.attr.mode) & S_IFMT) {
-		make_bad_inode(inode);
+		fuse_make_bad(inode);
 		err = -EIO;
 		goto error;
 	}
@@ -1727,6 +1748,9 @@ static int fuse_setattr(struct dentry *entry, struct iattr *attr)
 	struct file *file = (attr->ia_valid & ATTR_FILE) ? attr->ia_file : NULL;
 	int ret;
 
+	if (fuse_is_bad(inode))
+		return -EIO;
+
 	if (!fuse_allow_current_process(get_fuse_conn(inode)))
 		return -EACCES;
 
@@ -1785,6 +1809,9 @@ static int fuse_getattr(const struct path *path, struct kstat *stat,
 	struct inode *inode = d_inode(path->dentry);
 	struct fuse_conn *fc = get_fuse_conn(inode);
 
+	if (fuse_is_bad(inode))
+		return -EIO;
+
 	if (!fuse_allow_current_process(fc)) {
 		if (!request_mask) {
 			/*
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index c03034e8c1529..8b306005453cc 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -226,6 +226,9 @@ int fuse_open_common(struct inode *inode, struct file *file, bool isdir)
 	bool dax_truncate = (file->f_flags & O_TRUNC) &&
 			  fc->atomic_o_trunc && FUSE_IS_DAX(inode);
 
+	if (fuse_is_bad(inode))
+		return -EIO;
+
 	err = generic_file_open(inode, file);
 	if (err)
 		return err;
@@ -463,7 +466,7 @@ static int fuse_flush(struct file *file, fl_owner_t id)
 	FUSE_ARGS(args);
 	int err;
 
-	if (is_bad_inode(inode))
+	if (fuse_is_bad(inode))
 		return -EIO;
 
 	err = write_inode_now(inode, 1);
@@ -535,7 +538,7 @@ static int fuse_fsync(struct file *file, loff_t start, loff_t end,
 	struct fuse_conn *fc = get_fuse_conn(inode);
 	int err;
 
-	if (is_bad_inode(inode))
+	if (fuse_is_bad(inode))
 		return -EIO;
 
 	inode_lock(inode);
@@ -859,7 +862,7 @@ static int fuse_readpage(struct file *file, struct page *page)
 	int err;
 
 	err = -EIO;
-	if (is_bad_inode(inode))
+	if (fuse_is_bad(inode))
 		goto out;
 
 	err = fuse_do_readpage(file, page);
@@ -952,7 +955,7 @@ static void fuse_readahead(struct readahead_control *rac)
 	struct fuse_conn *fc = get_fuse_conn(inode);
 	unsigned int i, max_pages, nr_pages = 0;
 
-	if (is_bad_inode(inode))
+	if (fuse_is_bad(inode))
 		return;
 
 	max_pages = min_t(unsigned int, fc->max_pages,
@@ -1555,7 +1558,7 @@ static ssize_t fuse_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 	struct fuse_file *ff = file->private_data;
 	struct inode *inode = file_inode(file);
 
-	if (is_bad_inode(inode))
+	if (fuse_is_bad(inode))
 		return -EIO;
 
 	if (FUSE_IS_DAX(inode))
@@ -1573,7 +1576,7 @@ static ssize_t fuse_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	struct fuse_file *ff = file->private_data;
 	struct inode *inode = file_inode(file);
 
-	if (is_bad_inode(inode))
+	if (fuse_is_bad(inode))
 		return -EIO;
 
 	if (FUSE_IS_DAX(inode))
@@ -2172,7 +2175,7 @@ static int fuse_writepages(struct address_space *mapping,
 	int err;
 
 	err = -EIO;
-	if (is_bad_inode(inode))
+	if (fuse_is_bad(inode))
 		goto out;
 
 	data.inode = inode;
@@ -2954,7 +2957,7 @@ long fuse_ioctl_common(struct file *file, unsigned int cmd,
 	if (!fuse_allow_current_process(fc))
 		return -EACCES;
 
-	if (is_bad_inode(inode))
+	if (fuse_is_bad(inode))
 		return -EIO;
 
 	return fuse_do_ioctl(file, cmd, arg, flags);
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index d51598017d133..404d66f01e8d7 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -172,6 +172,8 @@ enum {
 	FUSE_I_INIT_RDPLUS,
 	/** An operation changing file size is in progress  */
 	FUSE_I_SIZE_UNSTABLE,
+	/* Bad inode */
+	FUSE_I_BAD,
 };
 
 struct fuse_conn;
@@ -858,6 +860,16 @@ static inline u64 fuse_get_attr_version(struct fuse_conn *fc)
 	return atomic64_read(&fc->attr_version);
 }
 
+static inline void fuse_make_bad(struct inode *inode)
+{
+	set_bit(FUSE_I_BAD, &get_fuse_inode(inode)->state);
+}
+
+static inline bool fuse_is_bad(struct inode *inode)
+{
+	return unlikely(test_bit(FUSE_I_BAD, &get_fuse_inode(inode)->state));
+}
+
 /** Device operations */
 extern const struct file_operations fuse_dev_operations;
 
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 1a47afc95f800..f94b0bb57619c 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -132,7 +132,7 @@ static void fuse_evict_inode(struct inode *inode)
 			fi->forget = NULL;
 		}
 	}
-	if (S_ISREG(inode->i_mode) && !is_bad_inode(inode)) {
+	if (S_ISREG(inode->i_mode) && !fuse_is_bad(inode)) {
 		WARN_ON(!list_empty(&fi->write_files));
 		WARN_ON(!list_empty(&fi->queued_writes));
 	}
@@ -342,7 +342,7 @@ retry:
 		unlock_new_inode(inode);
 	} else if ((inode->i_mode ^ attr->mode) & S_IFMT) {
 		/* Inode has changed type, any I/O on the old should fail */
-		make_bad_inode(inode);
+		fuse_make_bad(inode);
 		iput(inode);
 		goto retry;
 	}
diff --git a/fs/fuse/readdir.c b/fs/fuse/readdir.c
index 3b5e91045871a..3441ffa740f3d 100644
--- a/fs/fuse/readdir.c
+++ b/fs/fuse/readdir.c
@@ -207,7 +207,7 @@ retry:
 			dput(dentry);
 			goto retry;
 		}
-		if (is_bad_inode(inode)) {
+		if (fuse_is_bad(inode)) {
 			dput(dentry);
 			return -EIO;
 		}
@@ -568,7 +568,7 @@ int fuse_readdir(struct file *file, struct dir_context *ctx)
 	struct inode *inode = file_inode(file);
 	int err;
 
-	if (is_bad_inode(inode))
+	if (fuse_is_bad(inode))
 		return -EIO;
 
 	mutex_lock(&ff->readdir.lock);
diff --git a/fs/fuse/xattr.c b/fs/fuse/xattr.c
index 371bdcbc72337..cdea18de94f7e 100644
--- a/fs/fuse/xattr.c
+++ b/fs/fuse/xattr.c
@@ -113,6 +113,9 @@ ssize_t fuse_listxattr(struct dentry *entry, char *list, size_t size)
 	struct fuse_getxattr_out outarg;
 	ssize_t ret;
 
+	if (fuse_is_bad(inode))
+		return -EIO;
+
 	if (!fuse_allow_current_process(fm->fc))
 		return -EACCES;
 
@@ -178,6 +181,9 @@ static int fuse_xattr_get(const struct xattr_handler *handler,
 			 struct dentry *dentry, struct inode *inode,
 			 const char *name, void *value, size_t size)
 {
+	if (fuse_is_bad(inode))
+		return -EIO;
+
 	return fuse_getxattr(inode, name, value, size);
 }
 
@@ -186,6 +192,9 @@ static int fuse_xattr_set(const struct xattr_handler *handler,
 			  const char *name, const void *value, size_t size,
 			  int flags)
 {
+	if (fuse_is_bad(inode))
+		return -EIO;
+
 	if (!value)
 		return fuse_removexattr(inode, name);
 
-- 
2.27.0



