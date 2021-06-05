Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 237B639C6AD
	for <lists+stable@lfdr.de>; Sat,  5 Jun 2021 09:51:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbhFEHxP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Jun 2021 03:53:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:46184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230026AbhFEHxN (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 5 Jun 2021 03:53:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6659261042;
        Sat,  5 Jun 2021 07:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622879486;
        bh=oU7rLWlDtRnK5OqhhwuLiZAyphz7z0h1gnj2095cQ6I=;
        h=From:To:Cc:Subject:Date:From;
        b=mxwCu6VYqyEjqlKtghQAP7PY6VGEj1y1vow00zcCuVswe9XHCAT1vSXlSfqG5Pf9j
         q4+Eq+S7y/6Mo+hGQGPm8yB6eGJms+1wBM3XrAPbrVm6vIt0ChyGFubUig2hkJ7BCu
         GAjOh1kDH36YqLxqYiydv4EuSjqivVWgqiSUoZyatLA9toVGzX2CsTORZfIfU1ysRQ
         WCIGZemvg3C+qhFlVvdoJJtQuLUiNebiDqiSmb1LbrwCeXHBnby99/y5D2HNR5m+Yj
         vz1FklyBBFCFwcqLGlnrdgsqgH9raF95XqmkuI+UpGGo8qCMswub/ls32E75CR1dfp
         M2LxfUXgsR1gw==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        Daniel Rosenberg <drosen@google.com>, stable@vger.kernel.org
Subject: [PATCH v2] fscrypt: fix derivation of SipHash keys on big endian CPUs
Date:   Sat,  5 Jun 2021 00:50:33 -0700
Message-Id: <20210605075033.54424-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Typically, the cryptographic APIs that fscrypt uses take keys as byte
arrays, which avoids endianness issues.  However, siphash_key_t is an
exception.  It is defined as 'u64 key[2];', i.e. the 128-bit key is
expected to be given directly as two 64-bit words in CPU endianness.

fscrypt_derive_dirhash_key() and fscrypt_setup_iv_ino_lblk_32_key()
forgot to take this into account.  Therefore, the SipHash keys used to
index encrypted+casefolded directories differ on big endian vs. little
endian platforms, as do the SipHash keys used to hash inode numbers for
IV_INO_LBLK_32-encrypted directories.  This makes such directories
non-portable between these platforms.

Fix this by always using the little endian order.  This is a breaking
change for big endian platforms, but this should be fine in practice
since these features (encrypt+casefold support, and the IV_INO_LBLK_32
flag) aren't known to actually be used on any big endian platforms yet.

Fixes: aa408f835d02 ("fscrypt: derive dirhash key for casefolded directories")
Fixes: e3b1078bedd3 ("fscrypt: add support for IV_INO_LBLK_32 policies")
Cc: <stable@vger.kernel.org> # v5.6+
Signed-off-by: Eric Biggers <ebiggers@google.com>
---

v2: Fixed fscrypt_setup_iv_ino_lblk_32_key() too, not just
    fscrypt_derive_dirhash_key().

 fs/crypto/keysetup.c | 40 ++++++++++++++++++++++++++++++++--------
 1 file changed, 32 insertions(+), 8 deletions(-)

diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index 261293fb70974..bca9c6658a7c5 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -210,15 +210,40 @@ static int setup_per_mode_enc_key(struct fscrypt_info *ci,
 	return err;
 }
 
+/*
+ * Derive a SipHash key from the given fscrypt master key and the given
+ * application-specific information string.
+ *
+ * Note that the KDF produces a byte array, but the SipHash APIs expect the key
+ * as a pair of 64-bit words.  Therefore, on big endian CPUs we have to do an
+ * endianness swap in order to get the same results as on little endian CPUs.
+ */
+static int fscrypt_derive_siphash_key(const struct fscrypt_master_key *mk,
+				      u8 context, const u8 *info,
+				      unsigned int infolen, siphash_key_t *key)
+{
+	int err;
+
+	err = fscrypt_hkdf_expand(&mk->mk_secret.hkdf, context, info, infolen,
+				  (u8 *)key, sizeof(*key));
+	if (err)
+		return err;
+
+	BUILD_BUG_ON(sizeof(*key) != 16);
+	BUILD_BUG_ON(ARRAY_SIZE(key->key) != 2);
+	le64_to_cpus(&key->key[0]);
+	le64_to_cpus(&key->key[1]);
+	return 0;
+}
+
 int fscrypt_derive_dirhash_key(struct fscrypt_info *ci,
 			       const struct fscrypt_master_key *mk)
 {
 	int err;
 
-	err = fscrypt_hkdf_expand(&mk->mk_secret.hkdf, HKDF_CONTEXT_DIRHASH_KEY,
-				  ci->ci_nonce, FSCRYPT_FILE_NONCE_SIZE,
-				  (u8 *)&ci->ci_dirhash_key,
-				  sizeof(ci->ci_dirhash_key));
+	err = fscrypt_derive_siphash_key(mk, HKDF_CONTEXT_DIRHASH_KEY,
+					 ci->ci_nonce, FSCRYPT_FILE_NONCE_SIZE,
+					 &ci->ci_dirhash_key);
 	if (err)
 		return err;
 	ci->ci_dirhash_key_initialized = true;
@@ -253,10 +278,9 @@ static int fscrypt_setup_iv_ino_lblk_32_key(struct fscrypt_info *ci,
 		if (mk->mk_ino_hash_key_initialized)
 			goto unlock;
 
-		err = fscrypt_hkdf_expand(&mk->mk_secret.hkdf,
-					  HKDF_CONTEXT_INODE_HASH_KEY, NULL, 0,
-					  (u8 *)&mk->mk_ino_hash_key,
-					  sizeof(mk->mk_ino_hash_key));
+		err = fscrypt_derive_siphash_key(mk,
+						 HKDF_CONTEXT_INODE_HASH_KEY,
+						 NULL, 0, &mk->mk_ino_hash_key);
 		if (err)
 			goto unlock;
 		/* pairs with smp_load_acquire() above */

base-commit: 77f30bfcfcf484da7208affd6a9e63406420bf91
-- 
2.31.1

