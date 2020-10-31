Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 990FE2A1AEE
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 23:09:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725991AbgJaWJ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 18:09:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:39712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725873AbgJaWJx (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 18:09:53 -0400
Received: from sol.attlocal.net (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D90472074F;
        Sat, 31 Oct 2020 22:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604182193;
        bh=ETc1hAsI21DxPn/WO/4X/v+Zw4fLrx5+MBVtfAE9MI0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kktZlfnvu1uGp15daVLW/mFuNQX1LBM0Whws5WfrdFaM1Z8/EhVam3xG+KJVJIjqL
         VM7MJUWP12O0nNUDpTqMkZVNzbH/QUx1T7gsc/L0ggUP6QVxDvoA+1KPCA0824oeqf
         MgNGOJztFj4kiQYAOijf1843ckUC3OjpCz8gh0y0=
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org, Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 4.19 1/5] fscrypt: clean up and improve dentry revalidation
Date:   Sat, 31 Oct 2020 15:05:49 -0700
Message-Id: <20201031220553.1085782-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201031220553.1085782-1-ebiggers@kernel.org>
References: <20201031220553.1085782-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit 6cc248684d3d23bbd073ae2fa73d3416c0558909 upstream.

Make various improvements to fscrypt dentry revalidation:

- Don't try to handle the case where the per-directory key is removed,
  as this can't happen without the inode (and dentries) being evicted.

- Flag ciphertext dentries rather than plaintext dentries, since it's
  ciphertext dentries that need the special handling.

- Avoid doing unnecessary work for non-ciphertext dentries.

- When revalidating ciphertext dentries, try to set up the directory's
  i_crypt_info to make sure the key is really still absent, rather than
  invalidating all negative dentries as the previous code did.  An old
  comment suggested we can't do this for locking reasons, but AFAICT
  this comment was outdated and it actually works fine.

Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/crypto/crypto.c      | 58 +++++++++++++++++++++--------------------
 fs/crypto/hooks.c       |  4 +--
 include/linux/dcache.h  |  2 +-
 include/linux/fscrypt.h |  6 ++---
 4 files changed, 35 insertions(+), 35 deletions(-)

diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
index c83ddff3ff4ac..04a3c2c92b21e 100644
--- a/fs/crypto/crypto.c
+++ b/fs/crypto/crypto.c
@@ -314,45 +314,47 @@ int fscrypt_decrypt_page(const struct inode *inode, struct page *page,
 EXPORT_SYMBOL(fscrypt_decrypt_page);
 
 /*
- * Validate dentries for encrypted directories to make sure we aren't
- * potentially caching stale data after a key has been added or
- * removed.
+ * Validate dentries in encrypted directories to make sure we aren't potentially
+ * caching stale dentries after a key has been added.
  */
 static int fscrypt_d_revalidate(struct dentry *dentry, unsigned int flags)
 {
 	struct dentry *dir;
-	int dir_has_key, cached_with_key;
+	int err;
+	int valid;
+
+	/*
+	 * Plaintext names are always valid, since fscrypt doesn't support
+	 * reverting to ciphertext names without evicting the directory's inode
+	 * -- which implies eviction of the dentries in the directory.
+	 */
+	if (!(dentry->d_flags & DCACHE_ENCRYPTED_NAME))
+		return 1;
+
+	/*
+	 * Ciphertext name; valid if the directory's key is still unavailable.
+	 *
+	 * Although fscrypt forbids rename() on ciphertext names, we still must
+	 * use dget_parent() here rather than use ->d_parent directly.  That's
+	 * because a corrupted fs image may contain directory hard links, which
+	 * the VFS handles by moving the directory's dentry tree in the dcache
+	 * each time ->lookup() finds the directory and it already has a dentry
+	 * elsewhere.  Thus ->d_parent can be changing, and we must safely grab
+	 * a reference to some ->d_parent to prevent it from being freed.
+	 */
 
 	if (flags & LOOKUP_RCU)
 		return -ECHILD;
 
 	dir = dget_parent(dentry);
-	if (!IS_ENCRYPTED(d_inode(dir))) {
-		dput(dir);
-		return 0;
-	}
-
-	spin_lock(&dentry->d_lock);
-	cached_with_key = dentry->d_flags & DCACHE_ENCRYPTED_WITH_KEY;
-	spin_unlock(&dentry->d_lock);
-	dir_has_key = (d_inode(dir)->i_crypt_info != NULL);
+	err = fscrypt_get_encryption_info(d_inode(dir));
+	valid = !fscrypt_has_encryption_key(d_inode(dir));
 	dput(dir);
 
-	/*
-	 * If the dentry was cached without the key, and it is a
-	 * negative dentry, it might be a valid name.  We can't check
-	 * if the key has since been made available due to locking
-	 * reasons, so we fail the validation so ext4_lookup() can do
-	 * this check.
-	 *
-	 * We also fail the validation if the dentry was created with
-	 * the key present, but we no longer have the key, or vice versa.
-	 */
-	if ((!cached_with_key && d_is_negative(dentry)) ||
-			(!cached_with_key && dir_has_key) ||
-			(cached_with_key && !dir_has_key))
-		return 0;
-	return 1;
+	if (err < 0)
+		return err;
+
+	return valid;
 }
 
 const struct dentry_operations fscrypt_d_ops = {
diff --git a/fs/crypto/hooks.c b/fs/crypto/hooks.c
index 56debb1fcf5eb..a9492f75bbe13 100644
--- a/fs/crypto/hooks.c
+++ b/fs/crypto/hooks.c
@@ -101,9 +101,9 @@ int __fscrypt_prepare_lookup(struct inode *dir, struct dentry *dentry)
 	if (err)
 		return err;
 
-	if (fscrypt_has_encryption_key(dir)) {
+	if (!fscrypt_has_encryption_key(dir)) {
 		spin_lock(&dentry->d_lock);
-		dentry->d_flags |= DCACHE_ENCRYPTED_WITH_KEY;
+		dentry->d_flags |= DCACHE_ENCRYPTED_NAME;
 		spin_unlock(&dentry->d_lock);
 	}
 
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index 0880baefd85f8..02b1b40fea5b1 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -210,7 +210,7 @@ struct dentry_operations {
 
 #define DCACHE_MAY_FREE			0x00800000
 #define DCACHE_FALLTHRU			0x01000000 /* Fall through to lower layer */
-#define DCACHE_ENCRYPTED_WITH_KEY	0x02000000 /* dir is encrypted with a valid key */
+#define DCACHE_ENCRYPTED_NAME		0x02000000 /* Encrypted name (dir key was unavailable) */
 #define DCACHE_OP_REAL			0x04000000
 
 #define DCACHE_PAR_LOOKUP		0x10000000 /* being looked up (with parent locked shared) */
diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
index 9fa48180a1f5f..c83e4dc55c062 100644
--- a/include/linux/fscrypt.h
+++ b/include/linux/fscrypt.h
@@ -145,10 +145,8 @@ static inline int fscrypt_prepare_rename(struct inode *old_dir,
  * filenames are presented in encrypted form.  Therefore, we'll try to set up
  * the directory's encryption key, but even without it the lookup can continue.
  *
- * To allow invalidating stale dentries if the directory's encryption key is
- * added later, we also install a custom ->d_revalidate() method and use the
- * DCACHE_ENCRYPTED_WITH_KEY flag to indicate whether a given dentry is a
- * plaintext name (flag set) or a ciphertext name (flag cleared).
+ * This also installs a custom ->d_revalidate() method which will invalidate the
+ * dentry if it was created without the key and the key is later added.
  *
  * Return: 0 on success, -errno if a problem occurred while setting up the
  * encryption key
-- 
2.29.1

