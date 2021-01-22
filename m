Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48223300EF9
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 22:35:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729778AbhAVVec (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 16:34:32 -0500
Received: from lilium.sigma-star.at ([109.75.188.150]:32916 "EHLO
        lilium.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729300AbhAVVcA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jan 2021 16:32:00 -0500
Received: from localhost (localhost [127.0.0.1])
        by lilium.sigma-star.at (Postfix) with ESMTP id 09420181CBE0E;
        Fri, 22 Jan 2021 22:22:36 +0100 (CET)
Received: from lilium.sigma-star.at ([127.0.0.1])
        by localhost (lilium.sigma-star.at [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id QOALdkXGjvJJ; Fri, 22 Jan 2021 22:22:35 +0100 (CET)
Received: from lilium.sigma-star.at ([127.0.0.1])
        by localhost (lilium.sigma-star.at [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id lq2PuT6KfwIP; Fri, 22 Jan 2021 22:22:34 +0100 (CET)
From:   Richard Weinberger <richard@nod.at>
To:     linux-mtd@lists.infradead.org
Cc:     david@sigma-star.at, richard@nod.at, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH 2/4] ubifs: Don't add fscrypt context to xattrs
Date:   Fri, 22 Jan 2021 22:22:27 +0100
Message-Id: <20210122212229.17072-3-richard@nod.at>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210122212229.17072-1-richard@nod.at>
References: <20210122212229.17072-1-richard@nod.at>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In UBIFS xattrs are inodes too, make sure that these inodes
don't get a fscrypt context.
Otherwise we will end up with undeletable xattrs which will
waste memory on the flash.

Cc: stable@vger.kernel.org
Fixes: d475a507457b ("ubifs: Add skeleton for fscrypto")
Signed-off-by: Richard Weinberger <richard@nod.at>
---
 fs/ubifs/dir.c   | 23 +++++++++++++----------
 fs/ubifs/ubifs.h |  2 +-
 fs/ubifs/xattr.c |  2 +-
 3 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/fs/ubifs/dir.c b/fs/ubifs/dir.c
index 04912dedca48..8a34e0118ee9 100644
--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -68,13 +68,14 @@ static int inherit_flags(const struct inode *dir, umo=
de_t mode)
  * @c: UBIFS file-system description object
  * @dir: parent directory inode
  * @mode: inode mode flags
+ * @omit_fscrypt_ctx: Don't create a fscrypt context for this inode
  *
  * This function finds an unused inode number, allocates new inode and
  * initializes it. Returns new inode in case of success and an error cod=
e in
  * case of failure.
  */
 struct inode *ubifs_new_inode(struct ubifs_info *c, struct inode *dir,
-			      umode_t mode)
+			      umode_t mode, int omit_fscrypt_ctx)
 {
 	int err;
 	struct inode *inode;
@@ -99,10 +100,12 @@ struct inode *ubifs_new_inode(struct ubifs_info *c, =
struct inode *dir,
 			 current_time(inode);
 	inode->i_mapping->nrpages =3D 0;
=20
-	err =3D fscrypt_prepare_new_inode(dir, inode, &encrypted);
-	if (err) {
-		ubifs_err(c, "fscrypt_prepare_new_inode failed: %i", err);
-		goto out_iput;
+	if (!omit_fscrypt_ctx) {
+		err =3D fscrypt_prepare_new_inode(dir, inode, &encrypted);
+		if (err) {
+			ubifs_err(c, "fscrypt_prepare_new_inode failed: %i", err);
+			goto out_iput;
+		}
 	}
=20
 	switch (mode & S_IFMT) {
@@ -309,7 +312,7 @@ static int ubifs_create(struct inode *dir, struct den=
try *dentry, umode_t mode,
=20
 	sz_change =3D CALC_DENT_SIZE(fname_len(&nm));
=20
-	inode =3D ubifs_new_inode(c, dir, mode);
+	inode =3D ubifs_new_inode(c, dir, mode, 0);
 	if (IS_ERR(inode)) {
 		err =3D PTR_ERR(inode);
 		goto out_fname;
@@ -385,7 +388,7 @@ static int do_tmpfile(struct inode *dir, struct dentr=
y *dentry,
 		return err;
 	}
=20
-	inode =3D ubifs_new_inode(c, dir, mode);
+	inode =3D ubifs_new_inode(c, dir, mode, 0);
 	if (IS_ERR(inode)) {
 		err =3D PTR_ERR(inode);
 		goto out_budg;
@@ -971,7 +974,7 @@ static int ubifs_mkdir(struct inode *dir, struct dent=
ry *dentry, umode_t mode)
=20
 	sz_change =3D CALC_DENT_SIZE(fname_len(&nm));
=20
-	inode =3D ubifs_new_inode(c, dir, S_IFDIR | mode);
+	inode =3D ubifs_new_inode(c, dir, S_IFDIR | mode, 0);
 	if (IS_ERR(inode)) {
 		err =3D PTR_ERR(inode);
 		goto out_fname;
@@ -1058,7 +1061,7 @@ static int ubifs_mknod(struct inode *dir, struct de=
ntry *dentry,
=20
 	sz_change =3D CALC_DENT_SIZE(fname_len(&nm));
=20
-	inode =3D ubifs_new_inode(c, dir, mode);
+	inode =3D ubifs_new_inode(c, dir, mode, 0);
 	if (IS_ERR(inode)) {
 		kfree(dev);
 		err =3D PTR_ERR(inode);
@@ -1140,7 +1143,7 @@ static int ubifs_symlink(struct inode *dir, struct =
dentry *dentry,
=20
 	sz_change =3D CALC_DENT_SIZE(fname_len(&nm));
=20
-	inode =3D ubifs_new_inode(c, dir, S_IFLNK | S_IRWXUGO);
+	inode =3D ubifs_new_inode(c, dir, S_IFLNK | S_IRWXUGO, 0);
 	if (IS_ERR(inode)) {
 		err =3D PTR_ERR(inode);
 		goto out_fname;
diff --git a/fs/ubifs/ubifs.h b/fs/ubifs/ubifs.h
index fc2cdde3b549..dc9b6ba41e77 100644
--- a/fs/ubifs/ubifs.h
+++ b/fs/ubifs/ubifs.h
@@ -1994,7 +1994,7 @@ int ubifs_update_time(struct inode *inode, struct t=
imespec64 *time, int flags);
=20
 /* dir.c */
 struct inode *ubifs_new_inode(struct ubifs_info *c, struct inode *dir,
-			      umode_t mode);
+			      umode_t mode, int omit_fscrypt_ctx);
 int ubifs_getattr(const struct path *path, struct kstat *stat,
 		  u32 request_mask, unsigned int flags);
 int ubifs_check_dir_empty(struct inode *dir);
diff --git a/fs/ubifs/xattr.c b/fs/ubifs/xattr.c
index a0b9b349efe6..430abe9e56af 100644
--- a/fs/ubifs/xattr.c
+++ b/fs/ubifs/xattr.c
@@ -110,7 +110,7 @@ static int create_xattr(struct ubifs_info *c, struct =
inode *host,
 	if (err)
 		return err;
=20
-	inode =3D ubifs_new_inode(c, host, S_IFREG | S_IRWXUGO);
+	inode =3D ubifs_new_inode(c, host, S_IFREG | S_IRWXUGO, 1);
 	if (IS_ERR(inode)) {
 		err =3D PTR_ERR(inode);
 		goto out_budg;
--=20
2.26.2

