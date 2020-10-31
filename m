Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C96602A1AF2
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 23:09:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726034AbgJaWJ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 18:09:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:39780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725987AbgJaWJz (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 18:09:55 -0400
Received: from sol.attlocal.net (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 14EAA2087D;
        Sat, 31 Oct 2020 22:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604182194;
        bh=h5WQJtjt5zTZXweJPPfFpyJmc4zP6790ScuzhS0XOx4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r3hV+UZUmTOPOpWsgflPC/6WEWqjvE4H/ygGj1T0FRzpTDq//z+ZvEsOsQF4LaOky
         +olGvBWChmPMCJqljgtxMTIl+Ojq0TVT9CEgju/ZobPkPa4qF5qKprQGzGAIqDPLek
         zdOXY5HTiaNIOvvWSz2NGeuGaAi0nrqVclSVLrwk=
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org, Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 4.19 5/5] fscrypt: fix race where ->lookup() marks plaintext dentry as ciphertext
Date:   Sat, 31 Oct 2020 15:05:53 -0700
Message-Id: <20201031220553.1085782-6-ebiggers@kernel.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201031220553.1085782-1-ebiggers@kernel.org>
References: <20201031220553.1085782-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit b01531db6cec2aa330dbc91bfbfaaef4a0d387a4 upstream.

->lookup() in an encrypted directory begins as follows:

1. fscrypt_prepare_lookup():
    a. Try to load the directory's encryption key.
    b. If the key is unavailable, mark the dentry as a ciphertext name
       via d_flags.
2. fscrypt_setup_filename():
    a. Try to load the directory's encryption key.
    b. If the key is available, encrypt the name (treated as a plaintext
       name) to get the on-disk name.  Otherwise decode the name
       (treated as a ciphertext name) to get the on-disk name.

But if the key is concurrently added, it may be found at (2a) but not at
(1a).  In this case, the dentry will be wrongly marked as a ciphertext
name even though it was actually treated as plaintext.

This will cause the dentry to be wrongly invalidated on the next lookup,
potentially causing problems.  For example, if the racy ->lookup() was
part of sys_mount(), then the new mount will be detached when anything
tries to access it.  This is despite the mountpoint having a plaintext
path, which should remain valid now that the key was added.

Of course, this is only possible if there's a userspace race.  Still,
the additional kernel-side race is confusing and unexpected.

Close the kernel-side race by changing fscrypt_prepare_lookup() to also
set the on-disk filename (step 2b), consistent with the d_flags update.

Fixes: 28b4c263961c ("ext4 crypto: revalidate dentry after adding or removing the key")
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/crypto/fname.c               |  1 +
 fs/crypto/hooks.c               | 11 ++---
 fs/ext4/ext4.h                  | 62 ++++++++++++++++++++-------
 fs/ext4/namei.c                 | 76 ++++++++++++++++++++++-----------
 fs/f2fs/namei.c                 | 17 +++++---
 fs/ubifs/dir.c                  |  8 ++--
 include/linux/fscrypt.h         | 22 +++++++---
 include/linux/fscrypt_notsupp.h |  5 ++-
 include/linux/fscrypt_supp.h    |  3 +-
 9 files changed, 139 insertions(+), 66 deletions(-)

diff --git a/fs/crypto/fname.c b/fs/crypto/fname.c
index d7a0f682ca122..17bb9a3fc0b01 100644
--- a/fs/crypto/fname.c
+++ b/fs/crypto/fname.c
@@ -354,6 +354,7 @@ int fscrypt_setup_filename(struct inode *dir, const struct qstr *iname,
 	}
 	if (!lookup)
 		return -ENOKEY;
+	fname->is_ciphertext_name = true;
 
 	/*
 	 * We don't have the key and we are doing a lookup; decode the
diff --git a/fs/crypto/hooks.c b/fs/crypto/hooks.c
index 9d8910e86ee5d..042d5b44f4ed9 100644
--- a/fs/crypto/hooks.c
+++ b/fs/crypto/hooks.c
@@ -104,20 +104,21 @@ int __fscrypt_prepare_rename(struct inode *old_dir, struct dentry *old_dentry,
 }
 EXPORT_SYMBOL_GPL(__fscrypt_prepare_rename);
 
-int __fscrypt_prepare_lookup(struct inode *dir, struct dentry *dentry)
+int __fscrypt_prepare_lookup(struct inode *dir, struct dentry *dentry,
+			     struct fscrypt_name *fname)
 {
-	int err = fscrypt_get_encryption_info(dir);
+	int err = fscrypt_setup_filename(dir, &dentry->d_name, 1, fname);
 
-	if (err)
+	if (err && err != -ENOENT)
 		return err;
 
-	if (!fscrypt_has_encryption_key(dir)) {
+	if (fname->is_ciphertext_name) {
 		spin_lock(&dentry->d_lock);
 		dentry->d_flags |= DCACHE_ENCRYPTED_NAME;
 		spin_unlock(&dentry->d_lock);
 		d_set_d_op(dentry, &fscrypt_d_ops);
 	}
-	return 0;
+	return err;
 }
 EXPORT_SYMBOL_GPL(__fscrypt_prepare_lookup);
 
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 0a4461ac4225f..19109c04710ee 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2326,23 +2326,47 @@ static inline bool ext4_encrypted_inode(struct inode *inode)
 }
 
 #ifdef CONFIG_EXT4_FS_ENCRYPTION
+static inline void ext4_fname_from_fscrypt_name(struct ext4_filename *dst,
+						const struct fscrypt_name *src)
+{
+	memset(dst, 0, sizeof(*dst));
+
+	dst->usr_fname = src->usr_fname;
+	dst->disk_name = src->disk_name;
+	dst->hinfo.hash = src->hash;
+	dst->hinfo.minor_hash = src->minor_hash;
+	dst->crypto_buf = src->crypto_buf;
+}
+
 static inline int ext4_fname_setup_filename(struct inode *dir,
-			const struct qstr *iname,
-			int lookup, struct ext4_filename *fname)
+					    const struct qstr *iname,
+					    int lookup,
+					    struct ext4_filename *fname)
 {
 	struct fscrypt_name name;
 	int err;
 
-	memset(fname, 0, sizeof(struct ext4_filename));
-
 	err = fscrypt_setup_filename(dir, iname, lookup, &name);
+	if (err)
+		return err;
 
-	fname->usr_fname = name.usr_fname;
-	fname->disk_name = name.disk_name;
-	fname->hinfo.hash = name.hash;
-	fname->hinfo.minor_hash = name.minor_hash;
-	fname->crypto_buf = name.crypto_buf;
-	return err;
+	ext4_fname_from_fscrypt_name(fname, &name);
+	return 0;
+}
+
+static inline int ext4_fname_prepare_lookup(struct inode *dir,
+					    struct dentry *dentry,
+					    struct ext4_filename *fname)
+{
+	struct fscrypt_name name;
+	int err;
+
+	err = fscrypt_prepare_lookup(dir, dentry, &name);
+	if (err)
+		return err;
+
+	ext4_fname_from_fscrypt_name(fname, &name);
+	return 0;
 }
 
 static inline void ext4_fname_free_filename(struct ext4_filename *fname)
@@ -2356,19 +2380,27 @@ static inline void ext4_fname_free_filename(struct ext4_filename *fname)
 	fname->usr_fname = NULL;
 	fname->disk_name.name = NULL;
 }
-#else
+#else /* !CONFIG_EXT4_FS_ENCRYPTION */
 static inline int ext4_fname_setup_filename(struct inode *dir,
-		const struct qstr *iname,
-		int lookup, struct ext4_filename *fname)
+					    const struct qstr *iname,
+					    int lookup,
+					    struct ext4_filename *fname)
 {
 	fname->usr_fname = iname;
 	fname->disk_name.name = (unsigned char *) iname->name;
 	fname->disk_name.len = iname->len;
 	return 0;
 }
-static inline void ext4_fname_free_filename(struct ext4_filename *fname) { }
 
-#endif
+static inline int ext4_fname_prepare_lookup(struct inode *dir,
+					    struct dentry *dentry,
+					    struct ext4_filename *fname)
+{
+	return ext4_fname_setup_filename(dir, &dentry->d_name, 1, fname);
+}
+
+static inline void ext4_fname_free_filename(struct ext4_filename *fname) { }
+#endif /* !CONFIG_EXT4_FS_ENCRYPTION */
 
 /* dir.c */
 extern int __ext4_check_dir_entry(const char *, unsigned int, struct inode *,
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 186a2dd05bd87..4191552880bd7 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1343,7 +1343,7 @@ static int is_dx_internal_node(struct inode *dir, ext4_lblk_t block,
 }
 
 /*
- *	ext4_find_entry()
+ *	__ext4_find_entry()
  *
  * finds an entry in the specified directory with the wanted name. It
  * returns the cache buffer in which the entry was found, and the entry
@@ -1353,39 +1353,32 @@ static int is_dx_internal_node(struct inode *dir, ext4_lblk_t block,
  * The returned buffer_head has ->b_count elevated.  The caller is expected
  * to brelse() it when appropriate.
  */
-static struct buffer_head * ext4_find_entry (struct inode *dir,
-					const struct qstr *d_name,
-					struct ext4_dir_entry_2 **res_dir,
-					int *inlined)
+static struct buffer_head *__ext4_find_entry(struct inode *dir,
+					     struct ext4_filename *fname,
+					     struct ext4_dir_entry_2 **res_dir,
+					     int *inlined)
 {
 	struct super_block *sb;
 	struct buffer_head *bh_use[NAMEI_RA_SIZE];
 	struct buffer_head *bh, *ret = NULL;
 	ext4_lblk_t start, block;
-	const u8 *name = d_name->name;
+	const u8 *name = fname->usr_fname->name;
 	size_t ra_max = 0;	/* Number of bh's in the readahead
 				   buffer, bh_use[] */
 	size_t ra_ptr = 0;	/* Current index into readahead
 				   buffer */
 	ext4_lblk_t  nblocks;
 	int i, namelen, retval;
-	struct ext4_filename fname;
 
 	*res_dir = NULL;
 	sb = dir->i_sb;
-	namelen = d_name->len;
+	namelen = fname->usr_fname->len;
 	if (namelen > EXT4_NAME_LEN)
 		return NULL;
 
-	retval = ext4_fname_setup_filename(dir, d_name, 1, &fname);
-	if (retval == -ENOENT)
-		return NULL;
-	if (retval)
-		return ERR_PTR(retval);
-
 	if (ext4_has_inline_data(dir)) {
 		int has_inline_data = 1;
-		ret = ext4_find_inline_entry(dir, &fname, res_dir,
+		ret = ext4_find_inline_entry(dir, fname, res_dir,
 					     &has_inline_data);
 		if (has_inline_data) {
 			if (inlined)
@@ -1405,7 +1398,7 @@ static struct buffer_head * ext4_find_entry (struct inode *dir,
 		goto restart;
 	}
 	if (is_dx(dir)) {
-		ret = ext4_dx_find_entry(dir, &fname, res_dir);
+		ret = ext4_dx_find_entry(dir, fname, res_dir);
 		/*
 		 * On success, or if the error was file not found,
 		 * return.  Otherwise, fall back to doing a search the
@@ -1470,7 +1463,7 @@ static struct buffer_head * ext4_find_entry (struct inode *dir,
 			goto cleanup_and_exit;
 		}
 		set_buffer_verified(bh);
-		i = search_dirblock(bh, dir, &fname,
+		i = search_dirblock(bh, dir, fname,
 			    block << EXT4_BLOCK_SIZE_BITS(sb), res_dir);
 		if (i == 1) {
 			EXT4_I(dir)->i_dir_start_lookup = block;
@@ -1501,10 +1494,50 @@ static struct buffer_head * ext4_find_entry (struct inode *dir,
 	/* Clean up the read-ahead blocks */
 	for (; ra_ptr < ra_max; ra_ptr++)
 		brelse(bh_use[ra_ptr]);
-	ext4_fname_free_filename(&fname);
 	return ret;
 }
 
+static struct buffer_head *ext4_find_entry(struct inode *dir,
+					   const struct qstr *d_name,
+					   struct ext4_dir_entry_2 **res_dir,
+					   int *inlined)
+{
+	int err;
+	struct ext4_filename fname;
+	struct buffer_head *bh;
+
+	err = ext4_fname_setup_filename(dir, d_name, 1, &fname);
+	if (err == -ENOENT)
+		return NULL;
+	if (err)
+		return ERR_PTR(err);
+
+	bh = __ext4_find_entry(dir, &fname, res_dir, inlined);
+
+	ext4_fname_free_filename(&fname);
+	return bh;
+}
+
+static struct buffer_head *ext4_lookup_entry(struct inode *dir,
+					     struct dentry *dentry,
+					     struct ext4_dir_entry_2 **res_dir)
+{
+	int err;
+	struct ext4_filename fname;
+	struct buffer_head *bh;
+
+	err = ext4_fname_prepare_lookup(dir, dentry, &fname);
+	if (err == -ENOENT)
+		return NULL;
+	if (err)
+		return ERR_PTR(err);
+
+	bh = __ext4_find_entry(dir, &fname, res_dir, NULL);
+
+	ext4_fname_free_filename(&fname);
+	return bh;
+}
+
 static struct buffer_head * ext4_dx_find_entry(struct inode *dir,
 			struct ext4_filename *fname,
 			struct ext4_dir_entry_2 **res_dir)
@@ -1563,16 +1596,11 @@ static struct dentry *ext4_lookup(struct inode *dir, struct dentry *dentry, unsi
 	struct inode *inode;
 	struct ext4_dir_entry_2 *de;
 	struct buffer_head *bh;
-	int err;
-
-	err = fscrypt_prepare_lookup(dir, dentry, flags);
-	if (err)
-		return ERR_PTR(err);
 
 	if (dentry->d_name.len > EXT4_NAME_LEN)
 		return ERR_PTR(-ENAMETOOLONG);
 
-	bh = ext4_find_entry(dir, &dentry->d_name, &de, NULL);
+	bh = ext4_lookup_entry(dir, dentry, &de);
 	if (IS_ERR(bh))
 		return (struct dentry *) bh;
 	inode = NULL;
diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index 4f0cc0c79d1ee..8617e742d0878 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -432,19 +432,23 @@ static struct dentry *f2fs_lookup(struct inode *dir, struct dentry *dentry,
 	nid_t ino = -1;
 	int err = 0;
 	unsigned int root_ino = F2FS_ROOT_INO(F2FS_I_SB(dir));
+	struct fscrypt_name fname;
 
 	trace_f2fs_lookup_start(dir, dentry, flags);
 
-	err = fscrypt_prepare_lookup(dir, dentry, flags);
-	if (err)
-		goto out;
-
 	if (dentry->d_name.len > F2FS_NAME_LEN) {
 		err = -ENAMETOOLONG;
 		goto out;
 	}
 
-	de = f2fs_find_entry(dir, &dentry->d_name, &page);
+	err = fscrypt_prepare_lookup(dir, dentry, &fname);
+	if (err == -ENOENT)
+		goto out_splice;
+	if (err)
+		goto out;
+	de = __f2fs_find_entry(dir, &fname, &page);
+	fscrypt_free_filename(&fname);
+
 	if (!de) {
 		if (IS_ERR(page)) {
 			err = PTR_ERR(page);
@@ -484,8 +488,7 @@ static struct dentry *f2fs_lookup(struct inode *dir, struct dentry *dentry,
 	}
 out_splice:
 	new = d_splice_alias(inode, dentry);
-	if (IS_ERR(new))
-		err = PTR_ERR(new);
+	err = PTR_ERR_OR_ZERO(new);
 	trace_f2fs_lookup_end(dir, dentry, ino, err);
 	return new;
 out_iput:
diff --git a/fs/ubifs/dir.c b/fs/ubifs/dir.c
index d7c0aa0626cd7..10aab5dccaee4 100644
--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -220,11 +220,9 @@ static struct dentry *ubifs_lookup(struct inode *dir, struct dentry *dentry,
 
 	dbg_gen("'%pd' in dir ino %lu", dentry, dir->i_ino);
 
-	err = fscrypt_prepare_lookup(dir, dentry, flags);
-	if (err)
-		return ERR_PTR(err);
-
-	err = fscrypt_setup_filename(dir, &dentry->d_name, 1, &nm);
+	err = fscrypt_prepare_lookup(dir, dentry, &nm);
+	if (err == -ENOENT)
+		return d_splice_alias(NULL, dentry);
 	if (err)
 		return ERR_PTR(err);
 
diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
index af52a240c7399..c1e4a615bd1cb 100644
--- a/include/linux/fscrypt.h
+++ b/include/linux/fscrypt.h
@@ -32,6 +32,7 @@ struct fscrypt_name {
 	u32 hash;
 	u32 minor_hash;
 	struct fscrypt_str crypto_buf;
+	bool is_ciphertext_name;
 };
 
 #define FSTR_INIT(n, l)		{ .name = n, .len = l }
@@ -138,25 +139,32 @@ static inline int fscrypt_prepare_rename(struct inode *old_dir,
  * fscrypt_prepare_lookup - prepare to lookup a name in a possibly-encrypted directory
  * @dir: directory being searched
  * @dentry: filename being looked up
- * @flags: lookup flags
+ * @fname: (output) the name to use to search the on-disk directory
  *
- * Prepare for ->lookup() in a directory which may be encrypted.  Lookups can be
- * done with or without the directory's encryption key; without the key,
+ * Prepare for ->lookup() in a directory which may be encrypted by determining
+ * the name that will actually be used to search the directory on-disk.  Lookups
+ * can be done with or without the directory's encryption key; without the key,
  * filenames are presented in encrypted form.  Therefore, we'll try to set up
  * the directory's encryption key, but even without it the lookup can continue.
  *
  * This also installs a custom ->d_revalidate() method which will invalidate the
  * dentry if it was created without the key and the key is later added.
  *
- * Return: 0 on success, -errno if a problem occurred while setting up the
- * encryption key
+ * Return: 0 on success; -ENOENT if key is unavailable but the filename isn't a
+ * correctly formed encoded ciphertext name, so a negative dentry should be
+ * created; or another -errno code.
  */
 static inline int fscrypt_prepare_lookup(struct inode *dir,
 					 struct dentry *dentry,
-					 unsigned int flags)
+					 struct fscrypt_name *fname)
 {
 	if (IS_ENCRYPTED(dir))
-		return __fscrypt_prepare_lookup(dir, dentry);
+		return __fscrypt_prepare_lookup(dir, dentry, fname);
+
+	memset(fname, 0, sizeof(*fname));
+	fname->usr_fname = &dentry->d_name;
+	fname->disk_name.name = (unsigned char *)dentry->d_name.name;
+	fname->disk_name.len = dentry->d_name.len;
 	return 0;
 }
 
diff --git a/include/linux/fscrypt_notsupp.h b/include/linux/fscrypt_notsupp.h
index 15bbbd7c52b8b..24b261e49dc14 100644
--- a/include/linux/fscrypt_notsupp.h
+++ b/include/linux/fscrypt_notsupp.h
@@ -112,7 +112,7 @@ static inline int fscrypt_setup_filename(struct inode *dir,
 	if (IS_ENCRYPTED(dir))
 		return -EOPNOTSUPP;
 
-	memset(fname, 0, sizeof(struct fscrypt_name));
+	memset(fname, 0, sizeof(*fname));
 	fname->usr_fname = iname;
 	fname->disk_name.name = (unsigned char *)iname->name;
 	fname->disk_name.len = iname->len;
@@ -199,7 +199,8 @@ static inline int __fscrypt_prepare_rename(struct inode *old_dir,
 }
 
 static inline int __fscrypt_prepare_lookup(struct inode *dir,
-					   struct dentry *dentry)
+					   struct dentry *dentry,
+					   struct fscrypt_name *fname)
 {
 	return -EOPNOTSUPP;
 }
diff --git a/include/linux/fscrypt_supp.h b/include/linux/fscrypt_supp.h
index b8443a2e47dc4..8641e20694ce9 100644
--- a/include/linux/fscrypt_supp.h
+++ b/include/linux/fscrypt_supp.h
@@ -191,7 +191,8 @@ extern int __fscrypt_prepare_rename(struct inode *old_dir,
 				    struct inode *new_dir,
 				    struct dentry *new_dentry,
 				    unsigned int flags);
-extern int __fscrypt_prepare_lookup(struct inode *dir, struct dentry *dentry);
+extern int __fscrypt_prepare_lookup(struct inode *dir, struct dentry *dentry,
+				    struct fscrypt_name *fname);
 extern int __fscrypt_prepare_symlink(struct inode *dir, unsigned int len,
 				     unsigned int max_len,
 				     struct fscrypt_str *disk_link);
-- 
2.29.1

