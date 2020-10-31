Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E6832A1AF8
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 23:10:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726055AbgJaWJ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 18:09:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:39728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725782AbgJaWJx (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 18:09:53 -0400
Received: from sol.attlocal.net (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2AE0720756;
        Sat, 31 Oct 2020 22:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604182193;
        bh=rU+aQd863qXgTgg3hGulWwJk5oa2mDPQJIsHKpV+I4Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e1RoOPYelXSZ+AeuHj9scyBO5qXxK2jxeYhbsL/NiBv3vNV9nOTCebeosJXxl38YT
         De2GY8ARKf+e56sw+mOSN+YyuSw26uHLylHg/WRRj8tL0Whln2bQ1Gb6H8xhliiebv
         lECfHcuHEfgxuzrBFZu86pIB3fkSxiH/oiCMaq8w=
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org, Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 4.19 2/5] fscrypt: fix race allowing rename() and link() of ciphertext dentries
Date:   Sat, 31 Oct 2020 15:05:50 -0700
Message-Id: <20201031220553.1085782-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201031220553.1085782-1-ebiggers@kernel.org>
References: <20201031220553.1085782-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit 968dd6d0c6d6b6a989c6ddb9e2584a031b83e7b5 upstream.

Close some race conditions where fscrypt allowed rename() and link() on
ciphertext dentries that had been looked up just prior to the key being
concurrently added.  It's better to return -ENOKEY in this case.

This avoids doing the nonsensical thing of encrypting the names a second
time when searching for the actual on-disk dir entries.  It also
guarantees that DCACHE_ENCRYPTED_NAME dentries are never rename()d, so
the dcache won't have support all possible combinations of moving
DCACHE_ENCRYPTED_NAME around during __d_move().

Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/crypto/hooks.c               | 12 +++++++++++-
 include/linux/fscrypt.h         |  2 +-
 include/linux/fscrypt_notsupp.h |  4 ++--
 include/linux/fscrypt_supp.h    |  3 ++-
 4 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/fs/crypto/hooks.c b/fs/crypto/hooks.c
index a9492f75bbe13..2e7498a821a48 100644
--- a/fs/crypto/hooks.c
+++ b/fs/crypto/hooks.c
@@ -49,7 +49,8 @@ int fscrypt_file_open(struct inode *inode, struct file *filp)
 }
 EXPORT_SYMBOL_GPL(fscrypt_file_open);
 
-int __fscrypt_prepare_link(struct inode *inode, struct inode *dir)
+int __fscrypt_prepare_link(struct inode *inode, struct inode *dir,
+			   struct dentry *dentry)
 {
 	int err;
 
@@ -57,6 +58,10 @@ int __fscrypt_prepare_link(struct inode *inode, struct inode *dir)
 	if (err)
 		return err;
 
+	/* ... in case we looked up ciphertext name before key was added */
+	if (dentry->d_flags & DCACHE_ENCRYPTED_NAME)
+		return -ENOKEY;
+
 	if (!fscrypt_has_permitted_context(dir, inode))
 		return -EXDEV;
 
@@ -78,6 +83,11 @@ int __fscrypt_prepare_rename(struct inode *old_dir, struct dentry *old_dentry,
 	if (err)
 		return err;
 
+	/* ... in case we looked up ciphertext name(s) before key was added */
+	if ((old_dentry->d_flags | new_dentry->d_flags) &
+	    DCACHE_ENCRYPTED_NAME)
+		return -ENOKEY;
+
 	if (old_dir != new_dir) {
 		if (IS_ENCRYPTED(new_dir) &&
 		    !fscrypt_has_permitted_context(new_dir,
diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
index c83e4dc55c062..af52a240c7399 100644
--- a/include/linux/fscrypt.h
+++ b/include/linux/fscrypt.h
@@ -97,7 +97,7 @@ static inline int fscrypt_prepare_link(struct dentry *old_dentry,
 				       struct dentry *dentry)
 {
 	if (IS_ENCRYPTED(dir))
-		return __fscrypt_prepare_link(d_inode(old_dentry), dir);
+		return __fscrypt_prepare_link(d_inode(old_dentry), dir, dentry);
 	return 0;
 }
 
diff --git a/include/linux/fscrypt_notsupp.h b/include/linux/fscrypt_notsupp.h
index ee8b43e4c15a6..15bbbd7c52b8b 100644
--- a/include/linux/fscrypt_notsupp.h
+++ b/include/linux/fscrypt_notsupp.h
@@ -183,8 +183,8 @@ static inline int fscrypt_file_open(struct inode *inode, struct file *filp)
 	return 0;
 }
 
-static inline int __fscrypt_prepare_link(struct inode *inode,
-					 struct inode *dir)
+static inline int __fscrypt_prepare_link(struct inode *inode, struct inode *dir,
+					 struct dentry *dentry)
 {
 	return -EOPNOTSUPP;
 }
diff --git a/include/linux/fscrypt_supp.h b/include/linux/fscrypt_supp.h
index 6456c6b2005f4..b8443a2e47dc4 100644
--- a/include/linux/fscrypt_supp.h
+++ b/include/linux/fscrypt_supp.h
@@ -184,7 +184,8 @@ extern int fscrypt_zeroout_range(const struct inode *, pgoff_t, sector_t,
 
 /* hooks.c */
 extern int fscrypt_file_open(struct inode *inode, struct file *filp);
-extern int __fscrypt_prepare_link(struct inode *inode, struct inode *dir);
+extern int __fscrypt_prepare_link(struct inode *inode, struct inode *dir,
+				  struct dentry *dentry);
 extern int __fscrypt_prepare_rename(struct inode *old_dir,
 				    struct dentry *old_dentry,
 				    struct inode *new_dir,
-- 
2.29.1

