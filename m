Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B63D13E0AF
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 17:45:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729496AbgAPQpA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:45:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:53462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729033AbgAPQo7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:44:59 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C3F11207FF;
        Thu, 16 Jan 2020 16:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193098;
        bh=RQF1PiCG7acveFNY9DlVnizY1ykU/sDhUTklWAECA98=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LBU+8vbTjYVq5Onb+sbj4PhL8vdZbWlbuBUaZw17awrH8DWt/abxdz3Hv4PQsIPPj
         ga8LpdLxj3pi7KmQo9xbdLOa6AMtWpqgUTI2zLJYkCecNVU8Gn/nQFhXky++Oo8Z6r
         jOL8ngyJ48B+843LyjD7ri536MK5oWzqD8oSteLU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 024/205] crypto: algif_skcipher - Use chunksize instead of blocksize
Date:   Thu, 16 Jan 2020 11:39:59 -0500
Message-Id: <20200116164300.6705-24-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 5b0fe9552336338acb52756daf65dd7a4eeca73f ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/algif_skcipher.c            |  2 +-
 include/crypto/internal/skcipher.h | 30 ------------------------------
 include/crypto/skcipher.h          | 30 ++++++++++++++++++++++++++++++
 3 files changed, 31 insertions(+), 31 deletions(-)

diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index c1601edd70e3..e2c8ab408bed 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -56,7 +56,7 @@ static int _skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
 	struct alg_sock *pask = alg_sk(psk);
 	struct af_alg_ctx *ctx = ask->private;
 	struct crypto_skcipher *tfm = pask->private;
-	unsigned int bs = crypto_skcipher_blocksize(tfm);
+	unsigned int bs = crypto_skcipher_chunksize(tfm);
 	struct af_alg_async_req *areq;
 	int err = 0;
 	size_t len = 0;
diff --git a/include/crypto/internal/skcipher.h b/include/crypto/internal/skcipher.h
index 734b6f7081b8..3175dfeaed2c 100644
--- a/include/crypto/internal/skcipher.h
+++ b/include/crypto/internal/skcipher.h
@@ -205,19 +205,6 @@ static inline unsigned int crypto_skcipher_alg_max_keysize(
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
@@ -231,23 +218,6 @@ static inline unsigned int crypto_skcipher_alg_walksize(
 	return alg->walksize;
 }
 
-/**
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
 /**
  * crypto_skcipher_walksize() - obtain walk size
  * @tfm: cipher handle
diff --git a/include/crypto/skcipher.h b/include/crypto/skcipher.h
index 37c164234d97..aada87916918 100644
--- a/include/crypto/skcipher.h
+++ b/include/crypto/skcipher.h
@@ -304,6 +304,36 @@ static inline unsigned int crypto_skcipher_blocksize(
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
-- 
2.20.1

