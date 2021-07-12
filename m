Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E21A43C55E6
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:56:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350412AbhGLIMh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:12:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:56278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354040AbhGLIDZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 04:03:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 471B0611ED;
        Mon, 12 Jul 2021 07:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076782;
        bh=JiV23D7s319bQuMgVN3/RSbx9xSUP3/IuO9DjcHrKo4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YAnFOy+j5Xk96wj7U36+N13bYpURJPoj9io5jBw9VeO/8zmQHT5ZWDeZpCpAYwlTY
         /K53MMjzf/oxlkpR2lA6MV7O7PdghALyB6J4wtsuH7ahd0OE16z2yqq8Qv+TuseExN
         saslbaNEgaG2nMziOj2t5Zbuio4OL6GOPan1TPs8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@google.com>
Subject: [PATCH 5.13 790/800] fscrypt: fix derivation of SipHash keys on big endian CPUs
Date:   Mon, 12 Jul 2021 08:13:33 +0200
Message-Id: <20210712061050.798858264@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit 2fc2b430f559fdf32d5d1dd5ceaa40e12fb77bdf upstream.

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
Link: https://lore.kernel.org/r/20210605075033.54424-1-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/crypto/keysetup.c |   40 ++++++++++++++++++++++++++++++++--------
 1 file changed, 32 insertions(+), 8 deletions(-)

--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -210,15 +210,40 @@ out_unlock:
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
@@ -253,10 +278,9 @@ static int fscrypt_setup_iv_ino_lblk_32_
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


