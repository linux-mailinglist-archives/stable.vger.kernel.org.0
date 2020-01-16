Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13B1713FFAE
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:45:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391025AbgAPXX3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:23:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:51826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390998AbgAPXX2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:23:28 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B0F0F2082F;
        Thu, 16 Jan 2020 23:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217008;
        bh=Hx96LwSpJ0kZdmM/bnhqVzAezg/2L1hS4DvMKc21bpo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g1WpCDe7vusnK8EFXSlbG73nIOyOHRSHPLniwu4rR4iofI7PwPkczEshZXlzq5KrX
         1omBVTAkVq+4SGPnLTjt/7NxvfAM7aCBYQOnu13+vm7KxYNBXrjFi6jqnoZ1pJpBF5
         Xkv5HoojhIz7mPJSh9Pgo1SozzVxT3EXSnpFx8e0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 5.4 102/203] crypto: algif_skcipher - Use chunksize instead of blocksize
Date:   Fri, 17 Jan 2020 00:16:59 +0100
Message-Id: <20200116231754.501628362@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>

commit 5b0fe9552336338acb52756daf65dd7a4eeca73f upstream.

When algif_skcipher does a partial operation it always process data
that is a multiple of blocksize.  However, for algorithms such as
CTR this is wrong because even though it can process any number of
bytes overall, the partial block must come at the very end and not
in the middle.

This is exactly what chunksize is meant to describe so this patch
changes blocksize to chunksize.

Fixes: 8ff590903d5f ("crypto: algif_skcipher - User-space...")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 crypto/algif_skcipher.c            |    2 +-
 include/crypto/internal/skcipher.h |   30 ------------------------------
 include/crypto/skcipher.h          |   30 ++++++++++++++++++++++++++++++
 3 files changed, 31 insertions(+), 31 deletions(-)

--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -56,7 +56,7 @@ static int _skcipher_recvmsg(struct sock
 	struct alg_sock *pask = alg_sk(psk);
 	struct af_alg_ctx *ctx = ask->private;
 	struct crypto_skcipher *tfm = pask->private;
-	unsigned int bs = crypto_skcipher_blocksize(tfm);
+	unsigned int bs = crypto_skcipher_chunksize(tfm);
 	struct af_alg_async_req *areq;
 	int err = 0;
 	size_t len = 0;
--- a/include/crypto/internal/skcipher.h
+++ b/include/crypto/internal/skcipher.h
@@ -205,19 +205,6 @@ static inline unsigned int crypto_skciph
 	return alg->max_keysize;
 }
 
-static inline unsigned int crypto_skcipher_alg_chunksize(
-	struct skcipher_alg *alg)
-{
-	if ((alg->base.cra_flags & CRYPTO_ALG_TYPE_MASK) ==
-	    CRYPTO_ALG_TYPE_BLKCIPHER)
-		return alg->base.cra_blocksize;
-
-	if (alg->base.cra_ablkcipher.encrypt)
-		return alg->base.cra_blocksize;
-
-	return alg->chunksize;
-}
-
 static inline unsigned int crypto_skcipher_alg_walksize(
 	struct skcipher_alg *alg)
 {
@@ -232,23 +219,6 @@ static inline unsigned int crypto_skciph
 }
 
 /**
- * crypto_skcipher_chunksize() - obtain chunk size
- * @tfm: cipher handle
- *
- * The block size is set to one for ciphers such as CTR.  However,
- * you still need to provide incremental updates in multiples of
- * the underlying block size as the IV does not have sub-block
- * granularity.  This is known in this API as the chunk size.
- *
- * Return: chunk size in bytes
- */
-static inline unsigned int crypto_skcipher_chunksize(
-	struct crypto_skcipher *tfm)
-{
-	return crypto_skcipher_alg_chunksize(crypto_skcipher_alg(tfm));
-}
-
-/**
  * crypto_skcipher_walksize() - obtain walk size
  * @tfm: cipher handle
  *
--- a/include/crypto/skcipher.h
+++ b/include/crypto/skcipher.h
@@ -304,6 +304,36 @@ static inline unsigned int crypto_skciph
 	return crypto_tfm_alg_blocksize(crypto_skcipher_tfm(tfm));
 }
 
+static inline unsigned int crypto_skcipher_alg_chunksize(
+	struct skcipher_alg *alg)
+{
+	if ((alg->base.cra_flags & CRYPTO_ALG_TYPE_MASK) ==
+	    CRYPTO_ALG_TYPE_BLKCIPHER)
+		return alg->base.cra_blocksize;
+
+	if (alg->base.cra_ablkcipher.encrypt)
+		return alg->base.cra_blocksize;
+
+	return alg->chunksize;
+}
+
+/**
+ * crypto_skcipher_chunksize() - obtain chunk size
+ * @tfm: cipher handle
+ *
+ * The block size is set to one for ciphers such as CTR.  However,
+ * you still need to provide incremental updates in multiples of
+ * the underlying block size as the IV does not have sub-block
+ * granularity.  This is known in this API as the chunk size.
+ *
+ * Return: chunk size in bytes
+ */
+static inline unsigned int crypto_skcipher_chunksize(
+	struct crypto_skcipher *tfm)
+{
+	return crypto_skcipher_alg_chunksize(crypto_skcipher_alg(tfm));
+}
+
 static inline unsigned int crypto_sync_skcipher_blocksize(
 	struct crypto_sync_skcipher *tfm)
 {


