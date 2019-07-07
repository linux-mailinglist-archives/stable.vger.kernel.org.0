Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 788CD6172C
	for <lists+stable@lfdr.de>; Sun,  7 Jul 2019 21:46:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728429AbfGGTp4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Jul 2019 15:45:56 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57020 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727504AbfGGTiF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Jul 2019 15:38:05 -0400
Received: from 94.197.121.43.threembb.co.uk ([94.197.121.43] helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz3-0006f6-6W; Sun, 07 Jul 2019 20:38:01 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz1-0005Yb-Fc; Sun, 07 Jul 2019 20:37:59 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Herbert Xu" <herbert@gondor.apana.org.au>,
        "Eric Biggers" <ebiggers@google.com>
Date:   Sun, 07 Jul 2019 17:54:17 +0100
Message-ID: <lsq.1562518457.714655390@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 029/129] crypto: hash - set CRYPTO_TFM_NEED_KEY if
 ->setkey() fails
In-Reply-To: <lsq.1562518456.876074874@decadent.org.uk>
X-SA-Exim-Connect-IP: 94.197.121.43
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.70-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@google.com>

commit ba7d7433a0e998c902132bd47330e355a1eaa894 upstream.

Some algorithms have a ->setkey() method that is not atomic, in the
sense that setting a key can fail after changes were already made to the
tfm context.  In this case, if a key was already set the tfm can end up
in a state that corresponds to neither the old key nor the new key.

It's not feasible to make all ->setkey() methods atomic, especially ones
that have to key multiple sub-tfms.  Therefore, make the crypto API set
CRYPTO_TFM_NEED_KEY if ->setkey() fails and the algorithm requires a
key, to prevent the tfm from being used until a new key is set.

Note: we can't set CRYPTO_TFM_NEED_KEY for OPTIONAL_KEY algorithms, so
->setkey() for those must nevertheless be atomic.  That's fine for now
since only the crc32 and crc32c algorithms set OPTIONAL_KEY, and it's
not intended that OPTIONAL_KEY be used much.

[Cc stable mainly because when introducing the NEED_KEY flag I changed
 AF_ALG to rely on it; and unlike in-kernel crypto API users, AF_ALG
 previously didn't have this problem.  So these "incompletely keyed"
 states became theoretically accessible via AF_ALG -- though, the
 opportunities for causing real mischief seem pretty limited.]

Fixes: 9fa68f620041 ("crypto: hash - prevent using keyed hashes without setting key")
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 crypto/ahash.c | 28 +++++++++++++++++++---------
 crypto/shash.c | 18 +++++++++++++-----
 2 files changed, 32 insertions(+), 14 deletions(-)

--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -200,6 +200,21 @@ static int ahash_setkey_unaligned(struct
 	return ret;
 }
 
+static int ahash_nosetkey(struct crypto_ahash *tfm, const u8 *key,
+			  unsigned int keylen)
+{
+	return -ENOSYS;
+}
+
+static void ahash_set_needkey(struct crypto_ahash *tfm)
+{
+	const struct hash_alg_common *alg = crypto_hash_alg_common(tfm);
+
+	if (tfm->setkey != ahash_nosetkey &&
+	    !(alg->base.cra_flags & CRYPTO_ALG_OPTIONAL_KEY))
+		crypto_ahash_set_flags(tfm, CRYPTO_TFM_NEED_KEY);
+}
+
 int crypto_ahash_setkey(struct crypto_ahash *tfm, const u8 *key,
 			unsigned int keylen)
 {
@@ -211,20 +226,16 @@ int crypto_ahash_setkey(struct crypto_ah
 	else
 		err = tfm->setkey(tfm, key, keylen);
 
-	if (err)
+	if (unlikely(err)) {
+		ahash_set_needkey(tfm);
 		return err;
+	}
 
 	crypto_ahash_clear_flags(tfm, CRYPTO_TFM_NEED_KEY);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(crypto_ahash_setkey);
 
-static int ahash_nosetkey(struct crypto_ahash *tfm, const u8 *key,
-			  unsigned int keylen)
-{
-	return -ENOSYS;
-}
-
 static inline unsigned int ahash_align_buffer_size(unsigned len,
 						   unsigned long mask)
 {
@@ -493,8 +504,7 @@ static int crypto_ahash_init_tfm(struct
 
 	if (alg->setkey) {
 		hash->setkey = alg->setkey;
-		if (!(alg->halg.base.cra_flags & CRYPTO_ALG_OPTIONAL_KEY))
-			crypto_ahash_set_flags(hash, CRYPTO_TFM_NEED_KEY);
+		ahash_set_needkey(hash);
 	}
 	if (alg->export)
 		hash->export = alg->export;
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -52,6 +52,13 @@ static int shash_setkey_unaligned(struct
 	return err;
 }
 
+static void shash_set_needkey(struct crypto_shash *tfm, struct shash_alg *alg)
+{
+	if (crypto_shash_alg_has_setkey(alg) &&
+	    !(alg->base.cra_flags & CRYPTO_ALG_OPTIONAL_KEY))
+		crypto_shash_set_flags(tfm, CRYPTO_TFM_NEED_KEY);
+}
+
 int crypto_shash_setkey(struct crypto_shash *tfm, const u8 *key,
 			unsigned int keylen)
 {
@@ -64,8 +71,10 @@ int crypto_shash_setkey(struct crypto_sh
 	else
 		err = shash->setkey(tfm, key, keylen);
 
-	if (err)
+	if (unlikely(err)) {
+		shash_set_needkey(tfm, shash);
 		return err;
+	}
 
 	crypto_shash_clear_flags(tfm, CRYPTO_TFM_NEED_KEY);
 	return 0;
@@ -367,7 +376,8 @@ int crypto_init_shash_ops_async(struct c
 	crt->final = shash_async_final;
 	crt->finup = shash_async_finup;
 	crt->digest = shash_async_digest;
-	crt->setkey = shash_async_setkey;
+	if (crypto_shash_alg_has_setkey(alg))
+		crt->setkey = shash_async_setkey;
 
 	crypto_ahash_set_flags(crt, crypto_shash_get_flags(shash) &
 				    CRYPTO_TFM_NEED_KEY);
@@ -534,9 +544,7 @@ static int crypto_shash_init_tfm(struct
 
 	hash->descsize = alg->descsize;
 
-	if (crypto_shash_alg_has_setkey(alg) &&
-	    !(alg->base.cra_flags & CRYPTO_ALG_OPTIONAL_KEY))
-		crypto_shash_set_flags(hash, CRYPTO_TFM_NEED_KEY);
+	shash_set_needkey(hash, alg);
 
 	return 0;
 }

