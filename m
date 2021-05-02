Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 218F5370C9B
	for <lists+stable@lfdr.de>; Sun,  2 May 2021 16:06:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232798AbhEBOGu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 May 2021 10:06:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:52140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232747AbhEBOGN (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 2 May 2021 10:06:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C460613F0;
        Sun,  2 May 2021 14:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619964321;
        bh=vghtU1qhtsAXmBFbBaQXNQQSDouEcEgzsMAdO2jecvM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a6xCtAhn7Kw9tvBCHLAzs+xMCmNTQHKtG4nufDFRmXmcncmDkmo0LGJG/YHakfa28
         ytjMhUf22zFqXgZaD75X/ta3XpcDEQpgtVXGsq6RHbNw1s95yCfEmJm3mRKffY/bC0
         mCYhmcC/uNNCLuj9QeJmZBh6fAlTtVTN3H3qLmi2i3IM9ywnvA8CQL8doMRu+d0P40
         m14TEBnZCz+8pY7xDodCkcH0lPI0nnn3WRQeNNK5A7is+Os5Nv9JgwkOURuCiusrDU
         Jp0NAGzj/MhWkmjTyGR4SC7CvRUzeJ2zTHigzXX+rKBN9B4kCJcbJPKGIbBBmO+QJJ
         cSNyJkkU88FWw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        syzbot+12cf5fbfdeba210a89dd@syzkaller.appspotmail.com,
        Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 02/21] crypto: api - check for ERR pointers in crypto_destroy_tfm()
Date:   Sun,  2 May 2021 10:04:58 -0400
Message-Id: <20210502140517.2719912-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210502140517.2719912-1-sashal@kernel.org>
References: <20210502140517.2719912-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

[ Upstream commit 83681f2bebb34dbb3f03fecd8f570308ab8b7c2c ]

Given that crypto_alloc_tfm() may return ERR pointers, and to avoid
crashes on obscure error paths where such pointers are presented to
crypto_destroy_tfm() (such as [0]), add an ERR_PTR check there
before dereferencing the second argument as a struct crypto_tfm
pointer.

[0] https://lore.kernel.org/linux-crypto/000000000000de949705bc59e0f6@google.com/

Reported-by: syzbot+12cf5fbfdeba210a89dd@syzkaller.appspotmail.com
Reviewed-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/api.c               | 2 +-
 include/crypto/acompress.h | 2 ++
 include/crypto/aead.h      | 2 ++
 include/crypto/akcipher.h  | 2 ++
 include/crypto/hash.h      | 4 ++++
 include/crypto/kpp.h       | 2 ++
 include/crypto/rng.h       | 2 ++
 include/crypto/skcipher.h  | 2 ++
 8 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/crypto/api.c b/crypto/api.c
index 1909195b2c70..5efd4d6e6312 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -571,7 +571,7 @@ void crypto_destroy_tfm(void *mem, struct crypto_tfm *tfm)
 {
 	struct crypto_alg *alg;
 
-	if (unlikely(!mem))
+	if (IS_ERR_OR_NULL(mem))
 		return;
 
 	alg = tfm->__crt_alg;
diff --git a/include/crypto/acompress.h b/include/crypto/acompress.h
index e328b52425a8..1ff78365607c 100644
--- a/include/crypto/acompress.h
+++ b/include/crypto/acompress.h
@@ -152,6 +152,8 @@ static inline struct crypto_acomp *crypto_acomp_reqtfm(struct acomp_req *req)
  * crypto_free_acomp() -- free ACOMPRESS tfm handle
  *
  * @tfm:	ACOMPRESS tfm handle allocated with crypto_alloc_acomp()
+ *
+ * If @tfm is a NULL or error pointer, this function does nothing.
  */
 static inline void crypto_free_acomp(struct crypto_acomp *tfm)
 {
diff --git a/include/crypto/aead.h b/include/crypto/aead.h
index 1e26f790b03f..c69c545ba39a 100644
--- a/include/crypto/aead.h
+++ b/include/crypto/aead.h
@@ -187,6 +187,8 @@ static inline struct crypto_tfm *crypto_aead_tfm(struct crypto_aead *tfm)
 /**
  * crypto_free_aead() - zeroize and free aead handle
  * @tfm: cipher handle to be freed
+ *
+ * If @tfm is a NULL or error pointer, this function does nothing.
  */
 static inline void crypto_free_aead(struct crypto_aead *tfm)
 {
diff --git a/include/crypto/akcipher.h b/include/crypto/akcipher.h
index b5e11de4d497..9817f2e5bff8 100644
--- a/include/crypto/akcipher.h
+++ b/include/crypto/akcipher.h
@@ -174,6 +174,8 @@ static inline struct crypto_akcipher *crypto_akcipher_reqtfm(
  * crypto_free_akcipher() - free AKCIPHER tfm handle
  *
  * @tfm: AKCIPHER tfm handle allocated with crypto_alloc_akcipher()
+ *
+ * If @tfm is a NULL or error pointer, this function does nothing.
  */
 static inline void crypto_free_akcipher(struct crypto_akcipher *tfm)
 {
diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index 76e432cab75d..552517dcf9e4 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -257,6 +257,8 @@ static inline struct crypto_tfm *crypto_ahash_tfm(struct crypto_ahash *tfm)
 /**
  * crypto_free_ahash() - zeroize and free the ahash handle
  * @tfm: cipher handle to be freed
+ *
+ * If @tfm is a NULL or error pointer, this function does nothing.
  */
 static inline void crypto_free_ahash(struct crypto_ahash *tfm)
 {
@@ -692,6 +694,8 @@ static inline struct crypto_tfm *crypto_shash_tfm(struct crypto_shash *tfm)
 /**
  * crypto_free_shash() - zeroize and free the message digest handle
  * @tfm: cipher handle to be freed
+ *
+ * If @tfm is a NULL or error pointer, this function does nothing.
  */
 static inline void crypto_free_shash(struct crypto_shash *tfm)
 {
diff --git a/include/crypto/kpp.h b/include/crypto/kpp.h
index 1bde0a6514fa..1a34630fc371 100644
--- a/include/crypto/kpp.h
+++ b/include/crypto/kpp.h
@@ -159,6 +159,8 @@ static inline void crypto_kpp_set_flags(struct crypto_kpp *tfm, u32 flags)
  * crypto_free_kpp() - free KPP tfm handle
  *
  * @tfm: KPP tfm handle allocated with crypto_alloc_kpp()
+ *
+ * If @tfm is a NULL or error pointer, this function does nothing.
  */
 static inline void crypto_free_kpp(struct crypto_kpp *tfm)
 {
diff --git a/include/crypto/rng.h b/include/crypto/rng.h
index b95ede354a66..a788c1e5a121 100644
--- a/include/crypto/rng.h
+++ b/include/crypto/rng.h
@@ -116,6 +116,8 @@ static inline struct rng_alg *crypto_rng_alg(struct crypto_rng *tfm)
 /**
  * crypto_free_rng() - zeroize and free RNG handle
  * @tfm: cipher handle to be freed
+ *
+ * If @tfm is a NULL or error pointer, this function does nothing.
  */
 static inline void crypto_free_rng(struct crypto_rng *tfm)
 {
diff --git a/include/crypto/skcipher.h b/include/crypto/skcipher.h
index 2f327f090c3e..c7553f8b1bb6 100644
--- a/include/crypto/skcipher.h
+++ b/include/crypto/skcipher.h
@@ -206,6 +206,8 @@ static inline struct crypto_tfm *crypto_skcipher_tfm(
 /**
  * crypto_free_skcipher() - zeroize and free cipher handle
  * @tfm: cipher handle to be freed
+ *
+ * If @tfm is a NULL or error pointer, this function does nothing.
  */
 static inline void crypto_free_skcipher(struct crypto_skcipher *tfm)
 {
-- 
2.30.2

