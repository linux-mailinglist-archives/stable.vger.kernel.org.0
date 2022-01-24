Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CC86498D0F
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:33:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351548AbiAXT1b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:27:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350724AbiAXTZP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:25:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEC7BC035456;
        Mon, 24 Jan 2022 11:12:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5F49E60B7B;
        Mon, 24 Jan 2022 19:12:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D9CBC340E5;
        Mon, 24 Jan 2022 19:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643051523;
        bh=5RZ9WtbsNu4ngDHibzgmK3WAbxLu15ey04ekx3+nA28=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=joRNgGHjv55+soiWtZJ3NpdedFTQ39L909UuyoVJlahvTe1AatjnNJLLhKAWYicFN
         I6DLwsqRglIcSTu/91Nc91Oheoz6t31QAkXBh6wAv/a2iJ6y/STlJtyEvqBCaGu/Ip
         OLwJhm4FtNM5w2cP5PgHi+nnVTO5wuc80bGs3fvQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        syzbot+f427adf9324b92652ccc@syzkaller.appspotmail.com,
        Miklos Szeredi <mszeredi@redhat.com>, Jan Kara <jack@suse.cz>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.14 182/186] fuse: fix bad inode
Date:   Mon, 24 Jan 2022 19:44:17 +0100
Message-Id: <20220124183942.958109575@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183937.101330125@linuxfoundation.org>
References: <20220124183937.101330125@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
[bwh: Backported to 4.19:
 - Drop changes in fuse_dir_fsync(), fuse_readahead(), fuse_evict_inode()
 - In fuse_get_link(), return ERR_PTR(-EIO) for bad inodes
 - Convert some additional calls to is_bad_inode()
 - Adjust filename, context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/acl.c    |    6 ++++++
 fs/fuse/dir.c    |   40 +++++++++++++++++++++++++++++++++++-----
 fs/fuse/file.c   |   27 ++++++++++++++++++---------
 fs/fuse/fuse_i.h |   12 ++++++++++++
 fs/fuse/inode.c  |    2 +-
 fs/fuse/xattr.c  |    9 +++++++++
 6 files changed, 81 insertions(+), 15 deletions(-)

--- a/fs/fuse/acl.c
+++ b/fs/fuse/acl.c
@@ -19,6 +19,9 @@ struct posix_acl *fuse_get_acl(struct in
 	void *value = NULL;
 	struct posix_acl *acl;
 
+	if (fuse_is_bad(inode))
+		return ERR_PTR(-EIO);
+
 	if (!fc->posix_acl || fc->no_getxattr)
 		return NULL;
 
@@ -53,6 +56,9 @@ int fuse_set_acl(struct inode *inode, st
 	const char *name;
 	int ret;
 
+	if (fuse_is_bad(inode))
+		return -EIO;
+
 	if (!fc->posix_acl || fc->no_setxattr)
 		return -EOPNOTSUPP;
 
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -187,7 +187,7 @@ static int fuse_dentry_revalidate(struct
 	int ret;
 
 	inode = d_inode_rcu(entry);
-	if (inode && is_bad_inode(inode))
+	if (inode && fuse_is_bad(inode))
 		goto invalid;
 	else if (time_before64(fuse_dentry_time(entry), get_jiffies_64()) ||
 		 (flags & LOOKUP_REVAL)) {
@@ -364,6 +364,9 @@ static struct dentry *fuse_lookup(struct
 	bool outarg_valid = true;
 	bool locked;
 
+	if (fuse_is_bad(dir))
+		return ERR_PTR(-EIO);
+
 	locked = fuse_lock_inode(dir);
 	err = fuse_lookup_name(dir->i_sb, get_node_id(dir), &entry->d_name,
 			       &outarg, &inode);
@@ -504,6 +507,9 @@ static int fuse_atomic_open(struct inode
 	struct fuse_conn *fc = get_fuse_conn(dir);
 	struct dentry *res = NULL;
 
+	if (fuse_is_bad(dir))
+		return -EIO;
+
 	if (d_in_lookup(entry)) {
 		res = fuse_lookup(dir, entry, 0);
 		if (IS_ERR(res))
@@ -551,6 +557,9 @@ static int create_new_entry(struct fuse_
 	int err;
 	struct fuse_forget_link *forget;
 
+	if (fuse_is_bad(dir))
+		return -EIO;
+
 	forget = fuse_alloc_forget();
 	if (!forget)
 		return -ENOMEM;
@@ -672,6 +681,9 @@ static int fuse_unlink(struct inode *dir
 	struct fuse_conn *fc = get_fuse_conn(dir);
 	FUSE_ARGS(args);
 
+	if (fuse_is_bad(dir))
+		return -EIO;
+
 	args.in.h.opcode = FUSE_UNLINK;
 	args.in.h.nodeid = get_node_id(dir);
 	args.in.numargs = 1;
@@ -708,6 +720,9 @@ static int fuse_rmdir(struct inode *dir,
 	struct fuse_conn *fc = get_fuse_conn(dir);
 	FUSE_ARGS(args);
 
+	if (fuse_is_bad(dir))
+		return -EIO;
+
 	args.in.h.opcode = FUSE_RMDIR;
 	args.in.h.nodeid = get_node_id(dir);
 	args.in.numargs = 1;
@@ -786,6 +801,9 @@ static int fuse_rename2(struct inode *ol
 	struct fuse_conn *fc = get_fuse_conn(olddir);
 	int err;
 
+	if (fuse_is_bad(olddir))
+		return -EIO;
+
 	if (flags & ~(RENAME_NOREPLACE | RENAME_EXCHANGE))
 		return -EINVAL;
 
@@ -921,7 +939,7 @@ static int fuse_do_getattr(struct inode
 	if (!err) {
 		if (fuse_invalid_attr(&outarg.attr) ||
 		    (inode->i_mode ^ outarg.attr.mode) & S_IFMT) {
-			make_bad_inode(inode);
+			fuse_make_bad(inode);
 			err = -EIO;
 		} else {
 			fuse_change_attributes(inode, &outarg.attr,
@@ -1110,6 +1128,9 @@ static int fuse_permission(struct inode
 	bool refreshed = false;
 	int err = 0;
 
+	if (fuse_is_bad(inode))
+		return -EIO;
+
 	if (!fuse_allow_current_process(fc))
 		return -EACCES;
 
@@ -1247,7 +1268,7 @@ retry:
 			dput(dentry);
 			goto retry;
 		}
-		if (is_bad_inode(inode)) {
+		if (fuse_is_bad(inode)) {
 			dput(dentry);
 			return -EIO;
 		}
@@ -1345,7 +1366,7 @@ static int fuse_readdir(struct file *fil
 	u64 attr_version = 0;
 	bool locked;
 
-	if (is_bad_inode(inode))
+	if (fuse_is_bad(inode))
 		return -EIO;
 
 	req = fuse_get_req(fc, 1);
@@ -1405,6 +1426,9 @@ static const char *fuse_get_link(struct
 	if (!dentry)
 		return ERR_PTR(-ECHILD);
 
+	if (fuse_is_bad(inode))
+		return ERR_PTR(-EIO);
+
 	link = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!link)
 		return ERR_PTR(-ENOMEM);
@@ -1703,7 +1727,7 @@ int fuse_do_setattr(struct dentry *dentr
 
 	if (fuse_invalid_attr(&outarg.attr) ||
 	    (inode->i_mode ^ outarg.attr.mode) & S_IFMT) {
-		make_bad_inode(inode);
+		fuse_make_bad(inode);
 		err = -EIO;
 		goto error;
 	}
@@ -1759,6 +1783,9 @@ static int fuse_setattr(struct dentry *e
 	struct file *file = (attr->ia_valid & ATTR_FILE) ? attr->ia_file : NULL;
 	int ret;
 
+	if (fuse_is_bad(inode))
+		return -EIO;
+
 	if (!fuse_allow_current_process(get_fuse_conn(inode)))
 		return -EACCES;
 
@@ -1817,6 +1844,9 @@ static int fuse_getattr(const struct pat
 	struct inode *inode = d_inode(path->dentry);
 	struct fuse_conn *fc = get_fuse_conn(inode);
 
+	if (fuse_is_bad(inode))
+		return -EIO;
+
 	if (!fuse_allow_current_process(fc))
 		return -EACCES;
 
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -206,6 +206,9 @@ int fuse_open_common(struct inode *inode
 			  fc->atomic_o_trunc &&
 			  fc->writeback_cache;
 
+	if (fuse_is_bad(inode))
+		return -EIO;
+
 	err = generic_file_open(inode, file);
 	if (err)
 		return err;
@@ -407,7 +410,7 @@ static int fuse_flush(struct file *file,
 	struct fuse_flush_in inarg;
 	int err;
 
-	if (is_bad_inode(inode))
+	if (fuse_is_bad(inode))
 		return -EIO;
 
 	if (fc->no_flush)
@@ -455,7 +458,7 @@ int fuse_fsync_common(struct file *file,
 	struct fuse_fsync_in inarg;
 	int err;
 
-	if (is_bad_inode(inode))
+	if (fuse_is_bad(inode))
 		return -EIO;
 
 	inode_lock(inode);
@@ -770,7 +773,7 @@ static int fuse_readpage(struct file *fi
 	int err;
 
 	err = -EIO;
-	if (is_bad_inode(inode))
+	if (fuse_is_bad(inode))
 		goto out;
 
 	err = fuse_do_readpage(file, page);
@@ -897,7 +900,7 @@ static int fuse_readpages(struct file *f
 	int nr_alloc = min_t(unsigned, nr_pages, FUSE_MAX_PAGES_PER_REQ);
 
 	err = -EIO;
-	if (is_bad_inode(inode))
+	if (fuse_is_bad(inode))
 		goto out;
 
 	data.file = file;
@@ -927,6 +930,9 @@ static ssize_t fuse_file_read_iter(struc
 	struct inode *inode = iocb->ki_filp->f_mapping->host;
 	struct fuse_conn *fc = get_fuse_conn(inode);
 
+	if (fuse_is_bad(inode))
+		return -EIO;
+
 	/*
 	 * In auto invalidate mode, always update attributes on read.
 	 * Otherwise, only update if we attempt to read past EOF (to ensure
@@ -1127,7 +1133,7 @@ static ssize_t fuse_perform_write(struct
 	int err = 0;
 	ssize_t res = 0;
 
-	if (is_bad_inode(inode))
+	if (fuse_is_bad(inode))
 		return -EIO;
 
 	if (inode->i_size < pos + iov_iter_count(ii))
@@ -1184,6 +1190,9 @@ static ssize_t fuse_file_write_iter(stru
 	ssize_t err;
 	loff_t endbyte = 0;
 
+	if (fuse_is_bad(inode))
+		return -EIO;
+
 	if (get_fuse_conn(inode)->writeback_cache) {
 		/* Update size (EOF optimization) and mode (SUID clearing) */
 		err = fuse_update_attributes(mapping->host, file);
@@ -1420,7 +1429,7 @@ static ssize_t __fuse_direct_read(struct
 	ssize_t res;
 	struct inode *inode = file_inode(io->iocb->ki_filp);
 
-	if (is_bad_inode(inode))
+	if (fuse_is_bad(inode))
 		return -EIO;
 
 	res = fuse_direct_io(io, iter, ppos, 0);
@@ -1442,7 +1451,7 @@ static ssize_t fuse_direct_write_iter(st
 	struct fuse_io_priv io = FUSE_IO_PRIV_SYNC(iocb);
 	ssize_t res;
 
-	if (is_bad_inode(inode))
+	if (fuse_is_bad(inode))
 		return -EIO;
 
 	/* Don't allow parallel writes to the same file */
@@ -1916,7 +1925,7 @@ static int fuse_writepages(struct addres
 	int err;
 
 	err = -EIO;
-	if (is_bad_inode(inode))
+	if (fuse_is_bad(inode))
 		goto out;
 
 	data.inode = inode;
@@ -2701,7 +2710,7 @@ long fuse_ioctl_common(struct file *file
 	if (!fuse_allow_current_process(fc))
 		return -EACCES;
 
-	if (is_bad_inode(inode))
+	if (fuse_is_bad(inode))
 		return -EIO;
 
 	return fuse_do_ioctl(file, cmd, arg, flags);
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
@@ -687,6 +689,16 @@ static inline u64 get_node_id(struct ino
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
 
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -317,7 +317,7 @@ struct inode *fuse_iget(struct super_blo
 		unlock_new_inode(inode);
 	} else if ((inode->i_mode ^ attr->mode) & S_IFMT) {
 		/* Inode has changed type, any I/O on the old should fail */
-		make_bad_inode(inode);
+		fuse_make_bad(inode);
 		iput(inode);
 		goto retry;
 	}
--- a/fs/fuse/xattr.c
+++ b/fs/fuse/xattr.c
@@ -113,6 +113,9 @@ ssize_t fuse_listxattr(struct dentry *en
 	struct fuse_getxattr_out outarg;
 	ssize_t ret;
 
+	if (fuse_is_bad(inode))
+		return -EIO;
+
 	if (!fuse_allow_current_process(fc))
 		return -EACCES;
 
@@ -178,6 +181,9 @@ static int fuse_xattr_get(const struct x
 			 struct dentry *dentry, struct inode *inode,
 			 const char *name, void *value, size_t size)
 {
+	if (fuse_is_bad(inode))
+		return -EIO;
+
 	return fuse_getxattr(inode, name, value, size);
 }
 
@@ -186,6 +192,9 @@ static int fuse_xattr_set(const struct x
 			  const char *name, const void *value, size_t size,
 			  int flags)
 {
+	if (fuse_is_bad(inode))
+		return -EIO;
+
 	if (!value)
 		return fuse_removexattr(inode, name);
 


