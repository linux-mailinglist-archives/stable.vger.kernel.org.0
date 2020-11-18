Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 535252B77B2
	for <lists+stable@lfdr.de>; Wed, 18 Nov 2020 09:00:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727200AbgKRH5m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Nov 2020 02:57:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:35626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727095AbgKRH5l (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Nov 2020 02:57:41 -0500
Received: from sol.attlocal.net (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A66B020872;
        Wed, 18 Nov 2020 07:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605686260;
        bh=FigGyYGVqyexbkViWFXWCBw61iVGnXUSTYihGGdmkRE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eRCSgvfsCg1QTVP5X/naFr2Dfarwmp41S1fV43iSP/OjrT5qpwoEiibmVfG5qqCO1
         Od3miTUeHxuE84xOTJx12qGLmh570Us2zeO5b5g/bqB7xJYav4yunwirLCZJXForrW
         Q7EW77lq7oHivyoQyvlOM136mx+VhyJg8ZMYengk=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH 1/5] fscrypt: add fscrypt_is_nokey_name()
Date:   Tue, 17 Nov 2020 23:56:05 -0800
Message-Id: <20201118075609.120337-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201118075609.120337-1-ebiggers@kernel.org>
References: <20201118075609.120337-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

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
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/hooks.c       |  5 +++--
 include/linux/fscrypt.h | 34 ++++++++++++++++++++++++++++++++++
 2 files changed, 37 insertions(+), 2 deletions(-)

diff --git a/fs/crypto/hooks.c b/fs/crypto/hooks.c
index 20b0df47fe6a..061418be4b08 100644
--- a/fs/crypto/hooks.c
+++ b/fs/crypto/hooks.c
@@ -61,7 +61,7 @@ int __fscrypt_prepare_link(struct inode *inode, struct inode *dir,
 		return err;
 
 	/* ... in case we looked up no-key name before key was added */
-	if (dentry->d_flags & DCACHE_NOKEY_NAME)
+	if (fscrypt_is_nokey_name(dentry))
 		return -ENOKEY;
 
 	if (!fscrypt_has_permitted_context(dir, inode))
@@ -86,7 +86,8 @@ int __fscrypt_prepare_rename(struct inode *old_dir, struct dentry *old_dentry,
 		return err;
 
 	/* ... in case we looked up no-key name(s) before key was added */
-	if ((old_dentry->d_flags | new_dentry->d_flags) & DCACHE_NOKEY_NAME)
+	if (fscrypt_is_nokey_name(old_dentry) ||
+	    fscrypt_is_nokey_name(new_dentry))
 		return -ENOKEY;
 
 	if (old_dir != new_dir) {
diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
index a8f7a43f031b..8e1d31c959bf 100644
--- a/include/linux/fscrypt.h
+++ b/include/linux/fscrypt.h
@@ -111,6 +111,35 @@ static inline void fscrypt_handle_d_move(struct dentry *dentry)
 	dentry->d_flags &= ~DCACHE_NOKEY_NAME;
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
+	return dentry->d_flags & DCACHE_NOKEY_NAME;
+}
+
 /* crypto.c */
 void fscrypt_enqueue_decrypt_work(struct work_struct *);
 
@@ -244,6 +273,11 @@ static inline void fscrypt_handle_d_move(struct dentry *dentry)
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

