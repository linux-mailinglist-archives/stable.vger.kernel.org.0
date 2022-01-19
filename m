Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD75E493207
	for <lists+stable@lfdr.de>; Wed, 19 Jan 2022 01:52:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347779AbiASAwo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 19:52:44 -0500
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:60339 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235175AbiASAwo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 19:52:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1642553564; x=1674089564;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=p/t43c+xzeMycQKoe5GBajzbXqCFPT5CuYnyB/4IRRM=;
  b=G5C711WgnLEolbm1tk4ZOQGSiGHdGvOsr7VT4ctRYVMeGBp2jdOMphRP
   SWm/GH66pVfS75MOxw7+GLIRKvf7npKJVlLLfkZRsjrKqYWu+n3mj+07Q
   IA/rcq8fp1hRFjeVvuhmWCtyIDKr48RIPT4UNIm/gpmuoficqYx+LmeER
   I=;
X-IronPort-AV: E=Sophos;i="5.88,298,1635206400"; 
   d="scan'208";a="166736747"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2c-b09ea7fa.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP; 19 Jan 2022 00:52:43 +0000
Received: from EX13MTAUWA001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2c-b09ea7fa.us-west-2.amazon.com (Postfix) with ESMTPS id A0D794181F;
        Wed, 19 Jan 2022 00:52:42 +0000 (UTC)
Received: from EX13D01UWA002.ant.amazon.com (10.43.160.74) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.58) with Microsoft SMTP Server (TLS)
 id 15.0.1497.28; Wed, 19 Jan 2022 00:52:40 +0000
Received: from u46989501580c5c.ant.amazon.com (10.43.160.17) by
 EX13d01UWA002.ant.amazon.com (10.43.160.74) with Microsoft SMTP Server (TLS)
 id 15.0.1497.28; Wed, 19 Jan 2022 00:52:40 +0000
From:   Samuel Mendoza-Jonas <samjonas@amazon.com>
To:     <stable@vger.kernel.org>
CC:     Miklos Szeredi <mszeredi@redhat.com>,
        Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 4.14 1/2] fuse: fix bad inode
Date:   Tue, 18 Jan 2022 16:52:00 -0800
Message-ID: <20220119005201.130738-1-samjonas@amazon.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.17]
X-ClientProxiedBy: EX13D17UWB004.ant.amazon.com (10.43.161.132) To
 EX13d01UWA002.ant.amazon.com (10.43.160.74)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miklos Szeredi <mszeredi@redhat.com>

commit 5d069dbe8aaf2a197142558b6fb2978189ba3454 upstream.

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
[adjusted for missing fs/fuse/readdir.c and changes in fuse_evict_inode() in 4.14]
Signed-off-by: Samuel Mendoza-Jonas <samjonas@amazon.com>
---
 fs/fuse/acl.c    |  6 ++++++
 fs/fuse/dir.c    | 37 ++++++++++++++++++++++++++++++++-----
 fs/fuse/file.c   | 21 +++++++++++++++------
 fs/fuse/fuse_i.h | 12 ++++++++++++
 fs/fuse/inode.c  |  2 +-
 fs/fuse/xattr.c  |  9 +++++++++
 6 files changed, 75 insertions(+), 12 deletions(-)

diff --git a/fs/fuse/acl.c b/fs/fuse/acl.c
index ec85765502f1..990529da5354 100644
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
index b8d13b69583c..e7220fbd2d41 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -187,7 +187,7 @@ static int fuse_dentry_revalidate(struct dentry *entry, unsigned int flags)
 	int ret;
 
 	inode = d_inode_rcu(entry);
-	if (inode && is_bad_inode(inode))
+	if (inode && fuse_is_bad(inode))
 		goto invalid;
 	else if (time_before64(fuse_dentry_time(entry), get_jiffies_64()) ||
 		 (flags & LOOKUP_REVAL)) {
@@ -364,6 +364,9 @@ static struct dentry *fuse_lookup(struct inode *dir, struct dentry *entry,
 	bool outarg_valid = true;
 	bool locked;
 
+	if (fuse_is_bad(dir))
+		return ERR_PTR(-EIO);
+
 	locked = fuse_lock_inode(dir);
 	err = fuse_lookup_name(dir->i_sb, get_node_id(dir), &entry->d_name,
 			       &outarg, &inode);
@@ -504,6 +507,9 @@ static int fuse_atomic_open(struct inode *dir, struct dentry *entry,
 	struct fuse_conn *fc = get_fuse_conn(dir);
 	struct dentry *res = NULL;
 
+	if (fuse_is_bad(dir))
+		return -EIO;
+
 	if (d_in_lookup(entry)) {
 		res = fuse_lookup(dir, entry, 0);
 		if (IS_ERR(res))
@@ -551,6 +557,9 @@ static int create_new_entry(struct fuse_conn *fc, struct fuse_args *args,
 	int err;
 	struct fuse_forget_link *forget;
 
+	if (fuse_is_bad(dir))
+		return -EIO;
+
 	forget = fuse_alloc_forget();
 	if (!forget)
 		return -ENOMEM;
@@ -672,6 +681,9 @@ static int fuse_unlink(struct inode *dir, struct dentry *entry)
 	struct fuse_conn *fc = get_fuse_conn(dir);
 	FUSE_ARGS(args);
 
+	if (fuse_is_bad(dir))
+		return -EIO;
+
 	args.in.h.opcode = FUSE_UNLINK;
 	args.in.h.nodeid = get_node_id(dir);
 	args.in.numargs = 1;
@@ -708,6 +720,9 @@ static int fuse_rmdir(struct inode *dir, struct dentry *entry)
 	struct fuse_conn *fc = get_fuse_conn(dir);
 	FUSE_ARGS(args);
 
+	if (fuse_is_bad(dir))
+		return -EIO;
+
 	args.in.h.opcode = FUSE_RMDIR;
 	args.in.h.nodeid = get_node_id(dir);
 	args.in.numargs = 1;
@@ -786,6 +801,9 @@ static int fuse_rename2(struct inode *olddir, struct dentry *oldent,
 	struct fuse_conn *fc = get_fuse_conn(olddir);
 	int err;
 
+	if (fuse_is_bad(olddir))
+		return -EIO;
+
 	if (flags & ~(RENAME_NOREPLACE | RENAME_EXCHANGE))
 		return -EINVAL;
 
@@ -921,7 +939,7 @@ static int fuse_do_getattr(struct inode *inode, struct kstat *stat,
 	if (!err) {
 		if (fuse_invalid_attr(&outarg.attr) ||
 		    (inode->i_mode ^ outarg.attr.mode) & S_IFMT) {
-			make_bad_inode(inode);
+			fuse_make_bad(inode);
 			err = -EIO;
 		} else {
 			fuse_change_attributes(inode, &outarg.attr,
@@ -1110,6 +1128,9 @@ static int fuse_permission(struct inode *inode, int mask)
 	bool refreshed = false;
 	int err = 0;
 
+	if (fuse_is_bad(inode))
+		return -EIO;
+
 	if (!fuse_allow_current_process(fc))
 		return -EACCES;
 
@@ -1247,7 +1268,7 @@ static int fuse_direntplus_link(struct file *file,
 			dput(dentry);
 			goto retry;
 		}
-		if (is_bad_inode(inode)) {
+		if (fuse_is_bad(inode)) {
 			dput(dentry);
 			return -EIO;
 		}
@@ -1345,7 +1366,7 @@ static int fuse_readdir(struct file *file, struct dir_context *ctx)
 	u64 attr_version = 0;
 	bool locked;
 
-	if (is_bad_inode(inode))
+	if (fuse_is_bad(inode))
 		return -EIO;
 
 	req = fuse_get_req(fc, 1);
@@ -1703,7 +1724,7 @@ int fuse_do_setattr(struct dentry *dentry, struct iattr *attr,
 
 	if (fuse_invalid_attr(&outarg.attr) ||
 	    (inode->i_mode ^ outarg.attr.mode) & S_IFMT) {
-		make_bad_inode(inode);
+		fuse_make_bad(inode);
 		err = -EIO;
 		goto error;
 	}
@@ -1759,6 +1780,9 @@ static int fuse_setattr(struct dentry *entry, struct iattr *attr)
 	struct file *file = (attr->ia_valid & ATTR_FILE) ? attr->ia_file : NULL;
 	int ret;
 
+	if (fuse_is_bad(inode))
+		return -EIO;
+
 	if (!fuse_allow_current_process(get_fuse_conn(inode)))
 		return -EACCES;
 
@@ -1817,6 +1841,9 @@ static int fuse_getattr(const struct path *path, struct kstat *stat,
 	struct inode *inode = d_inode(path->dentry);
 	struct fuse_conn *fc = get_fuse_conn(inode);
 
+	if (fuse_is_bad(inode))
+		return -EIO;
+
 	if (!fuse_allow_current_process(fc))
 		return -EACCES;
 
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 4238939af2fe..0fb5466d5b09 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -206,6 +206,9 @@ int fuse_open_common(struct inode *inode, struct file *file, bool isdir)
 			  fc->atomic_o_trunc &&
 			  fc->writeback_cache;
 
+	if (fuse_is_bad(inode))
+		return -EIO;
+
 	err = generic_file_open(inode, file);
 	if (err)
 		return err;
@@ -407,7 +410,7 @@ static int fuse_flush(struct file *file, fl_owner_t id)
 	struct fuse_flush_in inarg;
 	int err;
 
-	if (is_bad_inode(inode))
+	if (fuse_is_bad(inode))
 		return -EIO;
 
 	if (fc->no_flush)
@@ -455,7 +458,7 @@ int fuse_fsync_common(struct file *file, loff_t start, loff_t end,
 	struct fuse_fsync_in inarg;
 	int err;
 
-	if (is_bad_inode(inode))
+	if (fuse_is_bad(inode))
 		return -EIO;
 
 	inode_lock(inode);
@@ -770,7 +773,7 @@ static int fuse_readpage(struct file *file, struct page *page)
 	int err;
 
 	err = -EIO;
-	if (is_bad_inode(inode))
+	if (fuse_is_bad(inode))
 		goto out;
 
 	err = fuse_do_readpage(file, page);
@@ -897,7 +900,7 @@ static int fuse_readpages(struct file *file, struct address_space *mapping,
 	int nr_alloc = min_t(unsigned, nr_pages, FUSE_MAX_PAGES_PER_REQ);
 
 	err = -EIO;
-	if (is_bad_inode(inode))
+	if (fuse_is_bad(inode))
 		goto out;
 
 	data.file = file;
@@ -927,6 +930,9 @@ static ssize_t fuse_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 	struct inode *inode = iocb->ki_filp->f_mapping->host;
 	struct fuse_conn *fc = get_fuse_conn(inode);
 
+	if (fuse_is_bad(inode))
+		return -EIO;
+
 	/*
 	 * In auto invalidate mode, always update attributes on read.
 	 * Otherwise, only update if we attempt to read past EOF (to ensure
@@ -1184,6 +1190,9 @@ static ssize_t fuse_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	ssize_t err;
 	loff_t endbyte = 0;
 
+	if (fuse_is_bad(inode))
+		return -EIO;
+
 	if (get_fuse_conn(inode)->writeback_cache) {
 		/* Update size (EOF optimization) and mode (SUID clearing) */
 		err = fuse_update_attributes(mapping->host, file);
@@ -1916,7 +1925,7 @@ static int fuse_writepages(struct address_space *mapping,
 	int err;
 
 	err = -EIO;
-	if (is_bad_inode(inode))
+	if (fuse_is_bad(inode))
 		goto out;
 
 	data.inode = inode;
@@ -2701,7 +2710,7 @@ long fuse_ioctl_common(struct file *file, unsigned int cmd,
 	if (!fuse_allow_current_process(fc))
 		return -EACCES;
 
-	if (is_bad_inode(inode))
+	if (fuse_is_bad(inode))
 		return -EIO;
 
 	return fuse_do_ioctl(file, cmd, arg, flags);
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 338aa5e266d6..220960c9b96d 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -117,6 +117,8 @@ enum {
 	FUSE_I_INIT_RDPLUS,
 	/** An operation changing file size is in progress  */
 	FUSE_I_SIZE_UNSTABLE,
+	/* Bad inode */
+	FUSE_I_BAD,
 };
 
 struct fuse_conn;
@@ -687,6 +689,16 @@ static inline u64 get_node_id(struct inode *inode)
 	return get_fuse_inode(inode)->nodeid;
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
index ffb61787d77a..747f7a710fb9 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -317,7 +317,7 @@ struct inode *fuse_iget(struct super_block *sb, u64 nodeid,
 		unlock_new_inode(inode);
 	} else if ((inode->i_mode ^ attr->mode) & S_IFMT) {
 		/* Inode has changed type, any I/O on the old should fail */
-		make_bad_inode(inode);
+		fuse_make_bad(inode);
 		iput(inode);
 		goto retry;
 	}
diff --git a/fs/fuse/xattr.c b/fs/fuse/xattr.c
index 3caac46b08b0..134bbc432ae6 100644
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
2.25.1

