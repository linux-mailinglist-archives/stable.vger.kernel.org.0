Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF3902F586
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:48:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728526AbfE3DLY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:11:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:50644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728513AbfE3DLY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:11:24 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76ABF244CB;
        Thu, 30 May 2019 03:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185883;
        bh=i5fi8eeImd4CC6+5pIfflGo+RRsZPt9AiRTjEx8MsPo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=giPeEqskh41+gTVYac5Rur+jz02r6VWf95eA19Q73dCMpjVsK1GAVhg2rrq5qj4qp
         hHxqEa6J8CwKw1KXsdBTiYJrq65tqwrhOve/0S8quTHaYHt51RuGmKGKAR4WmPA1yh
         6Bn3qFvrrPeyUZ64nkQT15VmfN2UpFQcEZwi+9yw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Theodore Tso <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 192/405] fscrypt: use READ_ONCE() to access ->i_crypt_info
Date:   Wed, 29 May 2019 20:03:10 -0700
Message-Id: <20190530030550.721489349@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit e37a784d8b6a1e726de5ddc7b4809c086a08db09 ]

->i_crypt_info starts out NULL and may later be locklessly set to a
non-NULL value by the cmpxchg() in fscrypt_get_encryption_info().

But ->i_crypt_info is used directly, which technically is incorrect.
It's a data race, and it doesn't include the data dependency barrier
needed to safely dereference the pointer on at least one architecture.

Fix this by using READ_ONCE() instead.  Note: we don't need to use
smp_load_acquire(), since dereferencing the pointer only requires a data
dependency barrier, which is already included in READ_ONCE().  We also
don't need READ_ONCE() in places where ->i_crypt_info is unconditionally
dereferenced, since it must have already been checked.

Also downgrade the cmpxchg() to cmpxchg_release(), since RELEASE
semantics are sufficient on the write side.

Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/crypto/crypto.c      | 2 +-
 fs/crypto/fname.c       | 4 ++--
 fs/crypto/keyinfo.c     | 4 ++--
 fs/crypto/policy.c      | 6 +++---
 include/linux/fscrypt.h | 3 ++-
 5 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
index 4dc788e3bc96b..fe38b53060454 100644
--- a/fs/crypto/crypto.c
+++ b/fs/crypto/crypto.c
@@ -334,7 +334,7 @@ static int fscrypt_d_revalidate(struct dentry *dentry, unsigned int flags)
 	spin_lock(&dentry->d_lock);
 	cached_with_key = dentry->d_flags & DCACHE_ENCRYPTED_WITH_KEY;
 	spin_unlock(&dentry->d_lock);
-	dir_has_key = (d_inode(dir)->i_crypt_info != NULL);
+	dir_has_key = fscrypt_has_encryption_key(d_inode(dir));
 	dput(dir);
 
 	/*
diff --git a/fs/crypto/fname.c b/fs/crypto/fname.c
index 7ff40a73dbece..050384c79f40e 100644
--- a/fs/crypto/fname.c
+++ b/fs/crypto/fname.c
@@ -269,7 +269,7 @@ int fscrypt_fname_disk_to_usr(struct inode *inode,
 	if (iname->len < FS_CRYPTO_BLOCK_SIZE)
 		return -EUCLEAN;
 
-	if (inode->i_crypt_info)
+	if (fscrypt_has_encryption_key(inode))
 		return fname_decrypt(inode, iname, oname);
 
 	if (iname->len <= FSCRYPT_FNAME_MAX_UNDIGESTED_SIZE) {
@@ -336,7 +336,7 @@ int fscrypt_setup_filename(struct inode *dir, const struct qstr *iname,
 	if (ret)
 		return ret;
 
-	if (dir->i_crypt_info) {
+	if (fscrypt_has_encryption_key(dir)) {
 		if (!fscrypt_fname_encrypted_size(dir, iname->len,
 						  dir->i_sb->s_cop->max_namelen,
 						  &fname->crypto_buf.len))
diff --git a/fs/crypto/keyinfo.c b/fs/crypto/keyinfo.c
index 322ce9686bdba..bf291c10c682f 100644
--- a/fs/crypto/keyinfo.c
+++ b/fs/crypto/keyinfo.c
@@ -509,7 +509,7 @@ int fscrypt_get_encryption_info(struct inode *inode)
 	u8 *raw_key = NULL;
 	int res;
 
-	if (inode->i_crypt_info)
+	if (fscrypt_has_encryption_key(inode))
 		return 0;
 
 	res = fscrypt_initialize(inode->i_sb->s_cop->flags);
@@ -573,7 +573,7 @@ int fscrypt_get_encryption_info(struct inode *inode)
 	if (res)
 		goto out;
 
-	if (cmpxchg(&inode->i_crypt_info, NULL, crypt_info) == NULL)
+	if (cmpxchg_release(&inode->i_crypt_info, NULL, crypt_info) == NULL)
 		crypt_info = NULL;
 out:
 	if (res == -ENOKEY)
diff --git a/fs/crypto/policy.c b/fs/crypto/policy.c
index bd7eaf9b3f003..d536889ac31bf 100644
--- a/fs/crypto/policy.c
+++ b/fs/crypto/policy.c
@@ -194,8 +194,8 @@ int fscrypt_has_permitted_context(struct inode *parent, struct inode *child)
 	res = fscrypt_get_encryption_info(child);
 	if (res)
 		return 0;
-	parent_ci = parent->i_crypt_info;
-	child_ci = child->i_crypt_info;
+	parent_ci = READ_ONCE(parent->i_crypt_info);
+	child_ci = READ_ONCE(child->i_crypt_info);
 
 	if (parent_ci && child_ci) {
 		return memcmp(parent_ci->ci_master_key_descriptor,
@@ -246,7 +246,7 @@ int fscrypt_inherit_context(struct inode *parent, struct inode *child,
 	if (res < 0)
 		return res;
 
-	ci = parent->i_crypt_info;
+	ci = READ_ONCE(parent->i_crypt_info);
 	if (ci == NULL)
 		return -ENOKEY;
 
diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
index e5194fc3983e9..08246f068fd89 100644
--- a/include/linux/fscrypt.h
+++ b/include/linux/fscrypt.h
@@ -79,7 +79,8 @@ struct fscrypt_ctx {
 
 static inline bool fscrypt_has_encryption_key(const struct inode *inode)
 {
-	return (inode->i_crypt_info != NULL);
+	/* pairs with cmpxchg_release() in fscrypt_get_encryption_info() */
+	return READ_ONCE(inode->i_crypt_info) != NULL;
 }
 
 static inline bool fscrypt_dummy_context_enabled(struct inode *inode)
-- 
2.20.1



