Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF02F2A562D
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:26:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387564AbgKCVCQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:02:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:39218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387577AbgKCVCO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 16:02:14 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C7B0C206B5;
        Tue,  3 Nov 2020 21:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437333;
        bh=VKbr2do/Xb70jJsR2z/OGL/3FZyisH4oRDFQUWCYkn8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ir2GkHdFgEIx5I27Myjaaa689KDiGibqx+lzwKifYxdPwoCMFAs3hsaf9EsPfYRbb
         0oYqQKL9CVxmoCEjpNZiS7rv9tnqMiVH17rX/efwZ8M833UALmoJL0nHAGF+r0zot/
         oGLVQI+Ncjze0I653aCAB/qJoj6AscDC0xY+cQ9Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-mtd@lists.infradead.org,
        Theodore Tso" <tytso@mit.edu>, Eric Biggers <ebiggers@google.com>,
        Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 4.19 031/191] fscrypt: fix race allowing rename() and link() of ciphertext dentries
Date:   Tue,  3 Nov 2020 21:35:23 +0100
Message-Id: <20201103203236.750207039@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203232.656475008@linuxfoundation.org>
References: <20201103203232.656475008@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/crypto/hooks.c               |   12 +++++++++++-
 include/linux/fscrypt.h         |    2 +-
 include/linux/fscrypt_notsupp.h |    4 ++--
 include/linux/fscrypt_supp.h    |    3 ++-
 4 files changed, 16 insertions(+), 5 deletions(-)

--- a/fs/crypto/hooks.c
+++ b/fs/crypto/hooks.c
@@ -49,7 +49,8 @@ int fscrypt_file_open(struct inode *inod
 }
 EXPORT_SYMBOL_GPL(fscrypt_file_open);
 
-int __fscrypt_prepare_link(struct inode *inode, struct inode *dir)
+int __fscrypt_prepare_link(struct inode *inode, struct inode *dir,
+			   struct dentry *dentry)
 {
 	int err;
 
@@ -57,6 +58,10 @@ int __fscrypt_prepare_link(struct inode
 	if (err)
 		return err;
 
+	/* ... in case we looked up ciphertext name before key was added */
+	if (dentry->d_flags & DCACHE_ENCRYPTED_NAME)
+		return -ENOKEY;
+
 	if (!fscrypt_has_permitted_context(dir, inode))
 		return -EXDEV;
 
@@ -78,6 +83,11 @@ int __fscrypt_prepare_rename(struct inod
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
--- a/include/linux/fscrypt.h
+++ b/include/linux/fscrypt.h
@@ -97,7 +97,7 @@ static inline int fscrypt_prepare_link(s
 				       struct dentry *dentry)
 {
 	if (IS_ENCRYPTED(dir))
-		return __fscrypt_prepare_link(d_inode(old_dentry), dir);
+		return __fscrypt_prepare_link(d_inode(old_dentry), dir, dentry);
 	return 0;
 }
 
--- a/include/linux/fscrypt_notsupp.h
+++ b/include/linux/fscrypt_notsupp.h
@@ -183,8 +183,8 @@ static inline int fscrypt_file_open(stru
 	return 0;
 }
 
-static inline int __fscrypt_prepare_link(struct inode *inode,
-					 struct inode *dir)
+static inline int __fscrypt_prepare_link(struct inode *inode, struct inode *dir,
+					 struct dentry *dentry)
 {
 	return -EOPNOTSUPP;
 }
--- a/include/linux/fscrypt_supp.h
+++ b/include/linux/fscrypt_supp.h
@@ -184,7 +184,8 @@ extern int fscrypt_zeroout_range(const s
 
 /* hooks.c */
 extern int fscrypt_file_open(struct inode *inode, struct file *filp);
-extern int __fscrypt_prepare_link(struct inode *inode, struct inode *dir);
+extern int __fscrypt_prepare_link(struct inode *inode, struct inode *dir,
+				  struct dentry *dentry);
 extern int __fscrypt_prepare_rename(struct inode *old_dir,
 				    struct dentry *old_dentry,
 				    struct inode *new_dir,


