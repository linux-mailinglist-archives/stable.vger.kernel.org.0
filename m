Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAF242ED270
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 15:37:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729539AbhAGOdQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 09:33:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:47182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729532AbhAGOdP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Jan 2021 09:33:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A752B22EBF;
        Thu,  7 Jan 2021 14:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610029954;
        bh=dRgogoMBQxpyN/QgqZofoKxZiszHZW/Jah+hknoM61Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uIANNGTT1l8jD98zbcRWzdT9ZwfLCTTcxsHLayxyal3603c5z7smkV7i5axPIoAcl
         anqwU5vMCHXs/QIO7SA575R5o8WarFD0rP9Kr4i2uN+LsgEFvDYN7e4tYqbiBbi2CB
         5WXdFePuZ0KLLqB66Xwf8QBJLKZpD19sxispwIdQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+f427adf9324b92652ccc@syzkaller.appspotmail.com,
        Miklos Szeredi <mszeredi@redhat.com>, Jan Kara <jack@suse.cz>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 08/13] fuse: fix bad inode
Date:   Thu,  7 Jan 2021 15:33:27 +0100
Message-Id: <20210107143051.042684000@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210107143049.929352526@linuxfoundation.org>
References: <20210107143049.929352526@linuxfoundation.org>
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
index ee190119f45cc..60378f3baaae1 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -201,7 +201,7 @@ static int fuse_dentry_revalidate(struct dentry *entry, unsigned int flags)
 	int ret;
 
 	inode = d_inode_rcu(entry);
-	if (inode && is_bad_inode(inode))
+	if (inode && fuse_is_bad(inode))
 		goto invalid;
 	else if (time_before64(fuse_dentry_time(entry), get_jiffies_64()) ||
 		 (flags & LOOKUP_REVAL)) {
@@ -386,6 +386,9 @@ static struct dentry *fuse_lookup(struct inode *dir, struct dentry *entry,
 	bool outarg_valid = true;
 	bool locked;
 
+	if (fuse_is_bad(dir))
+		return ERR_PTR(-EIO);
+
 	locked = fuse_lock_inode(dir);
 	err = fuse_lookup_name(dir->i_sb, get_node_id(dir), &entry->d_name,
 			       &outarg, &inode);
@@ -529,6 +532,9 @@ static int fuse_atomic_open(struct inode *dir, struct dentry *entry,
 	struct fuse_conn *fc = get_fuse_conn(dir);
 	struct dentry *res = NULL;
 
+	if (fuse_is_bad(dir))
+		return -EIO;
+
 	if (d_in_lookup(entry)) {
 		res = fuse_lookup(dir, entry, 0);
 		if (IS_ERR(res))
@@ -577,6 +583,9 @@ static int create_new_entry(struct fuse_conn *fc, struct fuse_args *args,
 	int err;
 	struct fuse_forget_link *forget;
 
+	if (fuse_is_bad(dir))
+		return -EIO;
+
 	forget = fuse_alloc_forget();
 	if (!forget)
 		return -ENOMEM;
@@ -704,6 +713,9 @@ static int fuse_unlink(struct inode *dir, struct dentry *entry)
 	struct fuse_conn *fc = get_fuse_conn(dir);
 	FUSE_ARGS(args);
 
+	if (fuse_is_bad(dir))
+		return -EIO;
+
 	args.opcode = FUSE_UNLINK;
 	args.nodeid = get_node_id(dir);
 	args.in_numargs = 1;
@@ -740,6 +752,9 @@ static int fuse_rmdir(struct inode *dir, struct dentry *entry)
 	struct fuse_conn *fc = get_fuse_conn(dir);
 	FUSE_ARGS(args);
 
+	if (fuse_is_bad(dir))
+		return -EIO;
+
 	args.opcode = FUSE_RMDIR;
 	args.nodeid = get_node_id(dir);
 	args.in_numargs = 1;
@@ -818,6 +833,9 @@ static int fuse_rename2(struct inode *olddir, struct dentry *oldent,
 	struct fuse_conn *fc = get_fuse_conn(olddir);
 	int err;
 
+	if (fuse_is_bad(olddir))
+		return -EIO;
+
 	if (flags & ~(RENAME_NOREPLACE | RENAME_EXCHANGE))
 		return -EINVAL;
 
@@ -953,7 +971,7 @@ static int fuse_do_getattr(struct inode *inode, struct kstat *stat,
 	if (!err) {
 		if (fuse_invalid_attr(&outarg.attr) ||
 		    (inode->i_mode ^ outarg.attr.mode) & S_IFMT) {
-			make_bad_inode(inode);
+			fuse_make_bad(inode);
 			err = -EIO;
 		} else {
 			fuse_change_attributes(inode, &outarg.attr,
@@ -1155,6 +1173,9 @@ static int fuse_permission(struct inode *inode, int mask)
 	bool refreshed = false;
 	int err = 0;
 
+	if (fuse_is_bad(inode))
+		return -EIO;
+
 	if (!fuse_allow_current_process(fc))
 		return -EACCES;
 
@@ -1250,7 +1271,7 @@ static const char *fuse_get_link(struct dentry *dentry, struct inode *inode,
 	int err;
 
 	err = -EIO;
-	if (is_bad_inode(inode))
+	if (fuse_is_bad(inode))
 		goto out_err;
 
 	if (fc->cache_symlinks)
@@ -1298,7 +1319,7 @@ static int fuse_dir_fsync(struct file *file, loff_t start, loff_t end,
 	struct fuse_conn *fc = get_fuse_conn(inode);
 	int err;
 
-	if (is_bad_inode(inode))
+	if (fuse_is_bad(inode))
 		return -EIO;
 
 	if (fc->no_fsyncdir)
@@ -1575,7 +1596,7 @@ int fuse_do_setattr(struct dentry *dentry, struct iattr *attr,
 
 	if (fuse_invalid_attr(&outarg.attr) ||
 	    (inode->i_mode ^ outarg.attr.mode) & S_IFMT) {
-		make_bad_inode(inode);
+		fuse_make_bad(inode);
 		err = -EIO;
 		goto error;
 	}
@@ -1631,6 +1652,9 @@ static int fuse_setattr(struct dentry *entry, struct iattr *attr)
 	struct file *file = (attr->ia_valid & ATTR_FILE) ? attr->ia_file : NULL;
 	int ret;
 
+	if (fuse_is_bad(inode))
+		return -EIO;
+
 	if (!fuse_allow_current_process(get_fuse_conn(inode)))
 		return -EACCES;
 
@@ -1689,6 +1713,9 @@ static int fuse_getattr(const struct path *path, struct kstat *stat,
 	struct inode *inode = d_inode(path->dentry);
 	struct fuse_conn *fc = get_fuse_conn(inode);
 
+	if (fuse_is_bad(inode))
+		return -EIO;
+
 	if (!fuse_allow_current_process(fc))
 		return -EACCES;
 
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index ab4fc1255aca8..1e1aef1bc20b3 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -222,6 +222,9 @@ int fuse_open_common(struct inode *inode, struct file *file, bool isdir)
 			  fc->atomic_o_trunc &&
 			  fc->writeback_cache;
 
+	if (fuse_is_bad(inode))
+		return -EIO;
+
 	err = generic_file_open(inode, file);
 	if (err)
 		return err;
@@ -443,7 +446,7 @@ static int fuse_flush(struct file *file, fl_owner_t id)
 	FUSE_ARGS(args);
 	int err;
 
-	if (is_bad_inode(inode))
+	if (fuse_is_bad(inode))
 		return -EIO;
 
 	if (fc->no_flush)
@@ -506,7 +509,7 @@ static int fuse_fsync(struct file *file, loff_t start, loff_t end,
 	struct fuse_conn *fc = get_fuse_conn(inode);
 	int err;
 
-	if (is_bad_inode(inode))
+	if (fuse_is_bad(inode))
 		return -EIO;
 
 	inode_lock(inode);
@@ -830,7 +833,7 @@ static int fuse_readpage(struct file *file, struct page *page)
 	int err;
 
 	err = -EIO;
-	if (is_bad_inode(inode))
+	if (fuse_is_bad(inode))
 		goto out;
 
 	err = fuse_do_readpage(file, page);
@@ -973,7 +976,7 @@ static int fuse_readpages(struct file *file, struct address_space *mapping,
 	int err;
 
 	err = -EIO;
-	if (is_bad_inode(inode))
+	if (fuse_is_bad(inode))
 		goto out;
 
 	data.file = file;
@@ -1569,7 +1572,7 @@ static ssize_t fuse_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 	struct file *file = iocb->ki_filp;
 	struct fuse_file *ff = file->private_data;
 
-	if (is_bad_inode(file_inode(file)))
+	if (fuse_is_bad(file_inode(file)))
 		return -EIO;
 
 	if (!(ff->open_flags & FOPEN_DIRECT_IO))
@@ -1583,7 +1586,7 @@ static ssize_t fuse_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	struct file *file = iocb->ki_filp;
 	struct fuse_file *ff = file->private_data;
 
-	if (is_bad_inode(file_inode(file)))
+	if (fuse_is_bad(file_inode(file)))
 		return -EIO;
 
 	if (!(ff->open_flags & FOPEN_DIRECT_IO))
@@ -2133,7 +2136,7 @@ static int fuse_writepages(struct address_space *mapping,
 	int err;
 
 	err = -EIO;
-	if (is_bad_inode(inode))
+	if (fuse_is_bad(inode))
 		goto out;
 
 	data.inode = inode;
@@ -2911,7 +2914,7 @@ long fuse_ioctl_common(struct file *file, unsigned int cmd,
 	if (!fuse_allow_current_process(fc))
 		return -EACCES;
 
-	if (is_bad_inode(inode))
+	if (fuse_is_bad(inode))
 		return -EIO;
 
 	return fuse_do_ioctl(file, cmd, arg, flags);
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index d7cde216fc871..e3688312e9f1b 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -158,6 +158,8 @@ enum {
 	FUSE_I_INIT_RDPLUS,
 	/** An operation changing file size is in progress  */
 	FUSE_I_SIZE_UNSTABLE,
+	/* Bad inode */
+	FUSE_I_BAD,
 };
 
 struct fuse_conn;
@@ -787,6 +789,16 @@ static inline u64 fuse_get_attr_version(struct fuse_conn *fc)
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
index f58ab84b09fb3..aa1d5cf1bc3a4 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -115,7 +115,7 @@ static void fuse_evict_inode(struct inode *inode)
 		fuse_queue_forget(fc, fi->forget, fi->nodeid, fi->nlookup);
 		fi->forget = NULL;
 	}
-	if (S_ISREG(inode->i_mode) && !is_bad_inode(inode)) {
+	if (S_ISREG(inode->i_mode) && !fuse_is_bad(inode)) {
 		WARN_ON(!list_empty(&fi->write_files));
 		WARN_ON(!list_empty(&fi->queued_writes));
 	}
@@ -306,7 +306,7 @@ struct inode *fuse_iget(struct super_block *sb, u64 nodeid,
 		unlock_new_inode(inode);
 	} else if ((inode->i_mode ^ attr->mode) & S_IFMT) {
 		/* Inode has changed type, any I/O on the old should fail */
-		make_bad_inode(inode);
+		fuse_make_bad(inode);
 		iput(inode);
 		goto retry;
 	}
diff --git a/fs/fuse/readdir.c b/fs/fuse/readdir.c
index 6a40f75a0d25e..70f685b61e3a5 100644
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
index 20d052e08b3be..28fed52957707 100644
--- a/fs/fuse/xattr.c
+++ b/fs/fuse/xattr.c
@@ -113,6 +113,9 @@ ssize_t fuse_listxattr(struct dentry *entry, char *list, size_t size)
 	struct fuse_getxattr_out outarg;
 	ssize_t ret;
 
+	if (fuse_is_bad(inode))
+		return -EIO;
+
 	if (!fuse_allow_current_process(fc))
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



