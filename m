Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D99F2E6A34
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 19:56:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728860AbgL1S4M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 13:56:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:39480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728862AbgL1S4J (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 13:56:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 82A2A229EF;
        Mon, 28 Dec 2020 18:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609181728;
        bh=3QtK26oljYaFaN7x1voE+S5ExJ3xhJwHdd8ZnwQ1urc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qgn6NBoEXuOmDSwjgKIqSR2zWDHnr75C88qo0hEPcxZ0CwpcQRLEjnE/4wQycoIrc
         JtvC+X5w0W9HtrdqrMrrsUQiTrHqDqq5rF+cic32/wAY6Baoyo+s4MHpN54x6uwNl8
         GsFNRtvvvG7S1D/QioTbuXD0YlbNAnBGaodfOY6bq+pSHZoMoYFztqpFoCe/yQ/qpg
         YSj/2ih13maPL8KoXVL69ClpsfT/Ew9jTbsVnCawwl7603geqJv09RQzlhIy2+vvpK
         FNfqBuIzTu/hJdE6GxODk4gLTnIe6tR6ksNw/uwJBZrS5f4Cv5Ge/tHMq1kOTagjta
         LeibZv519dxgQ==
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org
Subject: [PATCH 5.4 1/4] fscrypt: add fscrypt_is_nokey_name()
Date:   Mon, 28 Dec 2020 10:54:30 -0800
Message-Id: <20201228185433.61129-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228185433.61129-1-ebiggers@kernel.org>
References: <20201228185433.61129-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit 159e1de201b6fca10bfec50405a3b53a561096a8 upstream.

It's possible to create a duplicate filename in an encrypted directory
by creating a file concurrently with adding the encryption key.

Specifically, sys_open(O_CREAT) (or sys_mkdir(), sys_mknod(), or
sys_symlink()) can lookup the target filename while the directory's
encryption key hasn't been added yet, resulting in a negative no-key
dentry.  The VFS then calls ->create() (or ->mkdir(), ->mknod(), or
->symlink()) because the dentry is negative.  Normally, ->create() would
return -ENOKEY due to the directory's key being unavailable.  However,
if the key was added between the dentry lookup and ->create(), then the
filesystem will go ahead and try to create the file.

If the target filename happens to already exist as a normal name (not a
no-key name), a duplicate filename may be added to the directory.

In order to fix this, we need to fix the filesystems to prevent
->create(), ->mkdir(), ->mknod(), and ->symlink() on no-key names.
(->rename() and ->link() need it too, but those are already handled
correctly by fscrypt_prepare_rename() and fscrypt_prepare_link().)

In preparation for this, add a helper function fscrypt_is_nokey_name()
that filesystems can use to do this check.  Use this helper function for
the existing checks that fs/crypto/ does for rename and link.

Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20201118075609.120337-2-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/hooks.c       | 10 +++++-----
 include/linux/fscrypt.h | 34 ++++++++++++++++++++++++++++++++++
 2 files changed, 39 insertions(+), 5 deletions(-)

diff --git a/fs/crypto/hooks.c b/fs/crypto/hooks.c
index bb3b7fcfdd48a..a5a40a76b8ed7 100644
--- a/fs/crypto/hooks.c
+++ b/fs/crypto/hooks.c
@@ -58,8 +58,8 @@ int __fscrypt_prepare_link(struct inode *inode, struct inode *dir,
 	if (err)
 		return err;
 
-	/* ... in case we looked up ciphertext name before key was added */
-	if (dentry->d_flags & DCACHE_ENCRYPTED_NAME)
+	/* ... in case we looked up no-key name before key was added */
+	if (fscrypt_is_nokey_name(dentry))
 		return -ENOKEY;
 
 	if (!fscrypt_has_permitted_context(dir, inode))
@@ -83,9 +83,9 @@ int __fscrypt_prepare_rename(struct inode *old_dir, struct dentry *old_dentry,
 	if (err)
 		return err;
 
-	/* ... in case we looked up ciphertext name(s) before key was added */
-	if ((old_dentry->d_flags | new_dentry->d_flags) &
-	    DCACHE_ENCRYPTED_NAME)
+	/* ... in case we looked up no-key name(s) before key was added */
+	if (fscrypt_is_nokey_name(old_dentry) ||
+	    fscrypt_is_nokey_name(new_dentry))
 		return -ENOKEY;
 
 	if (old_dir != new_dir) {
diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
index f622f7460ed8c..032e5bcf97012 100644
--- a/include/linux/fscrypt.h
+++ b/include/linux/fscrypt.h
@@ -100,6 +100,35 @@ static inline void fscrypt_handle_d_move(struct dentry *dentry)
 	dentry->d_flags &= ~DCACHE_ENCRYPTED_NAME;
 }
 
+/**
+ * fscrypt_is_nokey_name() - test whether a dentry is a no-key name
+ * @dentry: the dentry to check
+ *
+ * This returns true if the dentry is a no-key dentry.  A no-key dentry is a
+ * dentry that was created in an encrypted directory that hasn't had its
+ * encryption key added yet.  Such dentries may be either positive or negative.
+ *
+ * When a filesystem is asked to create a new filename in an encrypted directory
+ * and the new filename's dentry is a no-key dentry, it must fail the operation
+ * with ENOKEY.  This includes ->create(), ->mkdir(), ->mknod(), ->symlink(),
+ * ->rename(), and ->link().  (However, ->rename() and ->link() are already
+ * handled by fscrypt_prepare_rename() and fscrypt_prepare_link().)
+ *
+ * This is necessary because creating a filename requires the directory's
+ * encryption key, but just checking for the key on the directory inode during
+ * the final filesystem operation doesn't guarantee that the key was available
+ * during the preceding dentry lookup.  And the key must have already been
+ * available during the dentry lookup in order for it to have been checked
+ * whether the filename already exists in the directory and for the new file's
+ * dentry not to be invalidated due to it incorrectly having the no-key flag.
+ *
+ * Return: %true if the dentry is a no-key name
+ */
+static inline bool fscrypt_is_nokey_name(const struct dentry *dentry)
+{
+	return dentry->d_flags & DCACHE_ENCRYPTED_NAME;
+}
+
 /* crypto.c */
 extern void fscrypt_enqueue_decrypt_work(struct work_struct *);
 extern struct fscrypt_ctx *fscrypt_get_ctx(gfp_t);
@@ -290,6 +319,11 @@ static inline void fscrypt_handle_d_move(struct dentry *dentry)
 {
 }
 
+static inline bool fscrypt_is_nokey_name(const struct dentry *dentry)
+{
+	return false;
+}
+
 /* crypto.c */
 static inline void fscrypt_enqueue_decrypt_work(struct work_struct *work)
 {
-- 
2.29.2

