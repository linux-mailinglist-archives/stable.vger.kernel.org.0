Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADFE6370CCA
	for <lists+stable@lfdr.de>; Sun,  2 May 2021 16:10:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233550AbhEBOH2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 May 2021 10:07:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:50986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233597AbhEBOGu (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 2 May 2021 10:06:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 60B6E613BB;
        Sun,  2 May 2021 14:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619964348;
        bh=AOTqmLP8aL5U9MlZAQni2Y63nMN1LwdxJr41+d9ftns=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iBNeMiY1CCyfRq3DJ25GfjYKaKPqrKK242DhsWaeP3pG8t81UinGa2T7KvcqN3rer
         uagUoUJajKJqOLG04rNzFGqut1vRv9YbFuV9CIMQMI9J4YacAtAsdNWcT47G5zth6E
         4cCi+dAoaRDrR/hdeFa4BfnWUoOeZ+BiXkycaa5Wr5UsgeSuHP5wzVESJVxcZKF1K3
         eVXL278aQ80pGGGXR95zfx+1Tiz6/IQE+V89nrW7PNgqu9bm8bVcRdmVsgi+iYEieT
         pEwqLs2BTuv9LMZ+10qfEDH0eRcSgXmzcPBg0awBb5zg+kI2HgCOPWGbxfvBlcsR8t
         lWBA/Ax1+kRhg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        syzbot+12cf5fbfdeba210a89dd@syzkaller.appspotmail.com,
        Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 02/16] crypto: api - check for ERR pointers in crypto_destroy_tfm()
Date:   Sun,  2 May 2021 10:05:30 -0400
Message-Id: <20210502140544.2720138-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210502140544.2720138-1-sashal@kernel.org>
References: <20210502140544.2720138-1-sashal@kernel.org>
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
index 187795a6687d..99bd438fa4a4 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -567,7 +567,7 @@ void crypto_destroy_tfm(void *mem, struct crypto_tfm *tfm)
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
index 03b97629442c..0e257ebf12cc 100644
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
index 74827781593c..493ed025f0ca 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -253,6 +253,8 @@ static inline struct crypto_tfm *crypto_ahash_tfm(struct crypto_ahash *tfm)
 /**
  * crypto_free_ahash() - zeroize and free the ahash handle
  * @tfm: cipher handle to be freed
+ *
+ * If @tfm is a NULL or error pointer, this function does nothing.
  */
 static inline void crypto_free_ahash(struct crypto_ahash *tfm)
 {
@@ -689,6 +691,8 @@ static inline struct crypto_tfm *crypto_shash_tfm(struct crypto_shash *tfm)
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
index 562001cb412b..32aca5f4e4f0 100644
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

