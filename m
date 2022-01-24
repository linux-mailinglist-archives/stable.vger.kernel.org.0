Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD2F9498361
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 16:17:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238634AbiAXPRV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 10:17:21 -0500
Received: from maynard.decadent.org.uk ([95.217.213.242]:42122 "EHLO
        maynard.decadent.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238469AbiAXPRV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 10:17:21 -0500
Received: from 168.7-181-91.adsl-dyn.isp.belgacom.be ([91.181.7.168] helo=deadeye)
        by maynard with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1nC15r-0006bu-Ea; Mon, 24 Jan 2022 16:17:19 +0100
Received: from ben by deadeye with local (Exim 4.95)
        (envelope-from <ben@decadent.org.uk>)
        id 1nC15q-009sFK-RX;
        Mon, 24 Jan 2022 16:17:18 +0100
Date:   Mon, 24 Jan 2022 16:17:18 +0100
From:   Ben Hutchings <ben@decadent.org.uk>
To:     stable@vger.kernel.org
Cc:     Miklos Szeredi <mszeredi@redhat.com>, Jan Kara <jack@suse.cz>
Subject: [PATCH 4.14,4.19 1/2] fuse: fix bad inode
Message-ID: <Ye7C/r2HAXqKeg/7@decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="cfWSSGGaDaPFIpqR"
Content-Disposition: inline
X-SA-Exim-Connect-IP: 91.181.7.168
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--cfWSSGGaDaPFIpqR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

=46rom: Miklos Szeredi <mszeredi@redhat.com>

commit 5d069dbe8aaf2a197142558b6fb2978189ba3454 upstream.

Jan Kara's analysis of the syzbot report (edited):

  The reproducer opens a directory on FUSE filesystem, it then attaches
  dnotify mark to the open directory.  After that a fuse_do_getattr() call
  finds that attributes returned by the server are inconsistent, and calls
  make_bad_inode() which, among other things does:

          inode->i_mode =3D S_IFREG;

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
---
 fs/fuse/acl.c    |  6 ++++++
 fs/fuse/dir.c    | 40 +++++++++++++++++++++++++++++++++++-----
 fs/fuse/file.c   | 27 ++++++++++++++++++---------
 fs/fuse/fuse_i.h | 12 ++++++++++++
 fs/fuse/inode.c  |  2 +-
 fs/fuse/xattr.c  |  9 +++++++++
 6 files changed, 81 insertions(+), 15 deletions(-)

diff --git a/fs/fuse/acl.c b/fs/fuse/acl.c
index ec85765502f1..990529da5354 100644
--- a/fs/fuse/acl.c
+++ b/fs/fuse/acl.c
@@ -19,6 +19,9 @@ struct posix_acl *fuse_get_acl(struct inode *inode, int t=
ype)
 	void *value =3D NULL;
 	struct posix_acl *acl;
=20
+	if (fuse_is_bad(inode))
+		return ERR_PTR(-EIO);
+
 	if (!fc->posix_acl || fc->no_getxattr)
 		return NULL;
=20
@@ -53,6 +56,9 @@ int fuse_set_acl(struct inode *inode, struct posix_acl *a=
cl, int type)
 	const char *name;
 	int ret;
=20
+	if (fuse_is_bad(inode))
+		return -EIO;
+
 	if (!fc->posix_acl || fc->no_setxattr)
 		return -EOPNOTSUPP;
=20
diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index b8d13b69583c..94ecc67292c7 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -187,7 +187,7 @@ static int fuse_dentry_revalidate(struct dentry *entry,=
 unsigned int flags)
 	int ret;
=20
 	inode =3D d_inode_rcu(entry);
-	if (inode && is_bad_inode(inode))
+	if (inode && fuse_is_bad(inode))
 		goto invalid;
 	else if (time_before64(fuse_dentry_time(entry), get_jiffies_64()) ||
 		 (flags & LOOKUP_REVAL)) {
@@ -364,6 +364,9 @@ static struct dentry *fuse_lookup(struct inode *dir, st=
ruct dentry *entry,
 	bool outarg_valid =3D true;
 	bool locked;
=20
+	if (fuse_is_bad(dir))
+		return ERR_PTR(-EIO);
+
 	locked =3D fuse_lock_inode(dir);
 	err =3D fuse_lookup_name(dir->i_sb, get_node_id(dir), &entry->d_name,
 			       &outarg, &inode);
@@ -504,6 +507,9 @@ static int fuse_atomic_open(struct inode *dir, struct d=
entry *entry,
 	struct fuse_conn *fc =3D get_fuse_conn(dir);
 	struct dentry *res =3D NULL;
=20
+	if (fuse_is_bad(dir))
+		return -EIO;
+
 	if (d_in_lookup(entry)) {
 		res =3D fuse_lookup(dir, entry, 0);
 		if (IS_ERR(res))
@@ -551,6 +557,9 @@ static int create_new_entry(struct fuse_conn *fc, struc=
t fuse_args *args,
 	int err;
 	struct fuse_forget_link *forget;
=20
+	if (fuse_is_bad(dir))
+		return -EIO;
+
 	forget =3D fuse_alloc_forget();
 	if (!forget)
 		return -ENOMEM;
@@ -672,6 +681,9 @@ static int fuse_unlink(struct inode *dir, struct dentry=
 *entry)
 	struct fuse_conn *fc =3D get_fuse_conn(dir);
 	FUSE_ARGS(args);
=20
+	if (fuse_is_bad(dir))
+		return -EIO;
+
 	args.in.h.opcode =3D FUSE_UNLINK;
 	args.in.h.nodeid =3D get_node_id(dir);
 	args.in.numargs =3D 1;
@@ -708,6 +720,9 @@ static int fuse_rmdir(struct inode *dir, struct dentry =
*entry)
 	struct fuse_conn *fc =3D get_fuse_conn(dir);
 	FUSE_ARGS(args);
=20
+	if (fuse_is_bad(dir))
+		return -EIO;
+
 	args.in.h.opcode =3D FUSE_RMDIR;
 	args.in.h.nodeid =3D get_node_id(dir);
 	args.in.numargs =3D 1;
@@ -786,6 +801,9 @@ static int fuse_rename2(struct inode *olddir, struct de=
ntry *oldent,
 	struct fuse_conn *fc =3D get_fuse_conn(olddir);
 	int err;
=20
+	if (fuse_is_bad(olddir))
+		return -EIO;
+
 	if (flags & ~(RENAME_NOREPLACE | RENAME_EXCHANGE))
 		return -EINVAL;
=20
@@ -921,7 +939,7 @@ static int fuse_do_getattr(struct inode *inode, struct =
kstat *stat,
 	if (!err) {
 		if (fuse_invalid_attr(&outarg.attr) ||
 		    (inode->i_mode ^ outarg.attr.mode) & S_IFMT) {
-			make_bad_inode(inode);
+			fuse_make_bad(inode);
 			err =3D -EIO;
 		} else {
 			fuse_change_attributes(inode, &outarg.attr,
@@ -1110,6 +1128,9 @@ static int fuse_permission(struct inode *inode, int m=
ask)
 	bool refreshed =3D false;
 	int err =3D 0;
=20
+	if (fuse_is_bad(inode))
+		return -EIO;
+
 	if (!fuse_allow_current_process(fc))
 		return -EACCES;
=20
@@ -1247,7 +1268,7 @@ static int fuse_direntplus_link(struct file *file,
 			dput(dentry);
 			goto retry;
 		}
-		if (is_bad_inode(inode)) {
+		if (fuse_is_bad(inode)) {
 			dput(dentry);
 			return -EIO;
 		}
@@ -1345,7 +1366,7 @@ static int fuse_readdir(struct file *file, struct dir=
_context *ctx)
 	u64 attr_version =3D 0;
 	bool locked;
=20
-	if (is_bad_inode(inode))
+	if (fuse_is_bad(inode))
 		return -EIO;
=20
 	req =3D fuse_get_req(fc, 1);
@@ -1405,6 +1426,9 @@ static const char *fuse_get_link(struct dentry *dentr=
y,
 	if (!dentry)
 		return ERR_PTR(-ECHILD);
=20
+	if (fuse_is_bad(inode))
+		return ERR_PTR(-EIO);
+
 	link =3D kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!link)
 		return ERR_PTR(-ENOMEM);
@@ -1703,7 +1727,7 @@ int fuse_do_setattr(struct dentry *dentry, struct iat=
tr *attr,
=20
 	if (fuse_invalid_attr(&outarg.attr) ||
 	    (inode->i_mode ^ outarg.attr.mode) & S_IFMT) {
-		make_bad_inode(inode);
+		fuse_make_bad(inode);
 		err =3D -EIO;
 		goto error;
 	}
@@ -1759,6 +1783,9 @@ static int fuse_setattr(struct dentry *entry, struct =
iattr *attr)
 	struct file *file =3D (attr->ia_valid & ATTR_FILE) ? attr->ia_file : NULL;
 	int ret;
=20
+	if (fuse_is_bad(inode))
+		return -EIO;
+
 	if (!fuse_allow_current_process(get_fuse_conn(inode)))
 		return -EACCES;
=20
@@ -1817,6 +1844,9 @@ static int fuse_getattr(const struct path *path, stru=
ct kstat *stat,
 	struct inode *inode =3D d_inode(path->dentry);
 	struct fuse_conn *fc =3D get_fuse_conn(inode);
=20
+	if (fuse_is_bad(inode))
+		return -EIO;
+
 	if (!fuse_allow_current_process(fc))
 		return -EACCES;
=20
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 4238939af2fe..5f5da2911cea 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -206,6 +206,9 @@ int fuse_open_common(struct inode *inode, struct file *=
file, bool isdir)
 			  fc->atomic_o_trunc &&
 			  fc->writeback_cache;
=20
+	if (fuse_is_bad(inode))
+		return -EIO;
+
 	err =3D generic_file_open(inode, file);
 	if (err)
 		return err;
@@ -407,7 +410,7 @@ static int fuse_flush(struct file *file, fl_owner_t id)
 	struct fuse_flush_in inarg;
 	int err;
=20
-	if (is_bad_inode(inode))
+	if (fuse_is_bad(inode))
 		return -EIO;
=20
 	if (fc->no_flush)
@@ -455,7 +458,7 @@ int fuse_fsync_common(struct file *file, loff_t start, =
loff_t end,
 	struct fuse_fsync_in inarg;
 	int err;
=20
-	if (is_bad_inode(inode))
+	if (fuse_is_bad(inode))
 		return -EIO;
=20
 	inode_lock(inode);
@@ -770,7 +773,7 @@ static int fuse_readpage(struct file *file, struct page=
 *page)
 	int err;
=20
 	err =3D -EIO;
-	if (is_bad_inode(inode))
+	if (fuse_is_bad(inode))
 		goto out;
=20
 	err =3D fuse_do_readpage(file, page);
@@ -897,7 +900,7 @@ static int fuse_readpages(struct file *file, struct add=
ress_space *mapping,
 	int nr_alloc =3D min_t(unsigned, nr_pages, FUSE_MAX_PAGES_PER_REQ);
=20
 	err =3D -EIO;
-	if (is_bad_inode(inode))
+	if (fuse_is_bad(inode))
 		goto out;
=20
 	data.file =3D file;
@@ -927,6 +930,9 @@ static ssize_t fuse_file_read_iter(struct kiocb *iocb, =
struct iov_iter *to)
 	struct inode *inode =3D iocb->ki_filp->f_mapping->host;
 	struct fuse_conn *fc =3D get_fuse_conn(inode);
=20
+	if (fuse_is_bad(inode))
+		return -EIO;
+
 	/*
 	 * In auto invalidate mode, always update attributes on read.
 	 * Otherwise, only update if we attempt to read past EOF (to ensure
@@ -1127,7 +1133,7 @@ static ssize_t fuse_perform_write(struct kiocb *iocb,
 	int err =3D 0;
 	ssize_t res =3D 0;
=20
-	if (is_bad_inode(inode))
+	if (fuse_is_bad(inode))
 		return -EIO;
=20
 	if (inode->i_size < pos + iov_iter_count(ii))
@@ -1184,6 +1190,9 @@ static ssize_t fuse_file_write_iter(struct kiocb *ioc=
b, struct iov_iter *from)
 	ssize_t err;
 	loff_t endbyte =3D 0;
=20
+	if (fuse_is_bad(inode))
+		return -EIO;
+
 	if (get_fuse_conn(inode)->writeback_cache) {
 		/* Update size (EOF optimization) and mode (SUID clearing) */
 		err =3D fuse_update_attributes(mapping->host, file);
@@ -1420,7 +1429,7 @@ static ssize_t __fuse_direct_read(struct fuse_io_priv=
 *io,
 	ssize_t res;
 	struct inode *inode =3D file_inode(io->iocb->ki_filp);
=20
-	if (is_bad_inode(inode))
+	if (fuse_is_bad(inode))
 		return -EIO;
=20
 	res =3D fuse_direct_io(io, iter, ppos, 0);
@@ -1442,7 +1451,7 @@ static ssize_t fuse_direct_write_iter(struct kiocb *i=
ocb, struct iov_iter *from)
 	struct fuse_io_priv io =3D FUSE_IO_PRIV_SYNC(iocb);
 	ssize_t res;
=20
-	if (is_bad_inode(inode))
+	if (fuse_is_bad(inode))
 		return -EIO;
=20
 	/* Don't allow parallel writes to the same file */
@@ -1916,7 +1925,7 @@ static int fuse_writepages(struct address_space *mapp=
ing,
 	int err;
=20
 	err =3D -EIO;
-	if (is_bad_inode(inode))
+	if (fuse_is_bad(inode))
 		goto out;
=20
 	data.inode =3D inode;
@@ -2701,7 +2710,7 @@ long fuse_ioctl_common(struct file *file, unsigned in=
t cmd,
 	if (!fuse_allow_current_process(fc))
 		return -EACCES;
=20
-	if (is_bad_inode(inode))
+	if (fuse_is_bad(inode))
 		return -EIO;
=20
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
=20
 struct fuse_conn;
@@ -687,6 +689,16 @@ static inline u64 get_node_id(struct inode *inode)
 	return get_fuse_inode(inode)->nodeid;
 }
=20
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
=20
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index ffb61787d77a..747f7a710fb9 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -317,7 +317,7 @@ struct inode *fuse_iget(struct super_block *sb, u64 nod=
eid,
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
@@ -113,6 +113,9 @@ ssize_t fuse_listxattr(struct dentry *entry, char *list=
, size_t size)
 	struct fuse_getxattr_out outarg;
 	ssize_t ret;
=20
+	if (fuse_is_bad(inode))
+		return -EIO;
+
 	if (!fuse_allow_current_process(fc))
 		return -EACCES;
=20
@@ -178,6 +181,9 @@ static int fuse_xattr_get(const struct xattr_handler *h=
andler,
 			 struct dentry *dentry, struct inode *inode,
 			 const char *name, void *value, size_t size)
 {
+	if (fuse_is_bad(inode))
+		return -EIO;
+
 	return fuse_getxattr(inode, name, value, size);
 }
=20
@@ -186,6 +192,9 @@ static int fuse_xattr_set(const struct xattr_handler *h=
andler,
 			  const char *name, const void *value, size_t size,
 			  int flags)
 {
+	if (fuse_is_bad(inode))
+		return -EIO;
+
 	if (!value)
 		return fuse_removexattr(inode, name);
=20


--cfWSSGGaDaPFIpqR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmHuwvUACgkQ57/I7JWG
EQmnTQ//eysug1kxaVZhMflJeA1wCz2WUm28ZDtMeDcL7quUUKp75jCXiMDqsxfe
3IOEjpOlsoPy52v15sZ9smfKLbPY3VEKfoKD3jN9K4j19YHUWJuioCGZ+MqgKM3U
iz8hbVLrF60ZRA6XmuLVvgYOHgBfLFCEDsuxVVDrx05jOQWzS2bHVbqZ/cN+jPgV
Tvu8pDrzl3uISkPwDOIVoTJiigU968IEmfbxNAQADNgk5ghZQNBjL/Pv68lWX/ic
jIeOqxHEoCE4A9BmouFBDesyH1QRiOSzXXOl4FK7qqyLbvUZdz9Y7Ko4k0N/bP+6
YbyUFZ5xKQiqIJb2Lu4X572Rb93QuSR6RueKq+68Ut3vN7Jxbv+JeT4poyQ4jswA
Bgz0m67R84k1dxlrkyW/I6oftbnSg1bQmq3knC2I7FHcOwnYKUSXYVzMmeSMnmSL
kwyQ3BdefOSU97CYGHaSdxOwso1wzm6QuyzC4l3ANzgEXRAlnN0YBYKkWVfaui+w
w3RIgyrPt8So2KNXabkfgbmlc7PUASC0G4gn7IiLP8Fq4gFI46XBq207yqm0R3tb
52xaYYBKO+1uD8CHiJYIOkxUJkcHtLQD2uqY9IE8TVhNzox4ySj1qaulde/2tvOE
jg/sGMzSkQOJxrsiDLD0i00zXVvCHhfQKKazhk2rrsWIOqTk+UQ=
=aXDm
-----END PGP SIGNATURE-----

--cfWSSGGaDaPFIpqR--
