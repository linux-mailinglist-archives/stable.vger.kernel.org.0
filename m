Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2454233DA
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:41:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730727AbfETMUk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:20:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:34102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388026AbfETMUk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:20:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE60021479;
        Mon, 20 May 2019 12:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558354839;
        bh=JSpRtVrQfqcSTyU5q2HUJokVCkqDhJxFKC/Xsx9ZprU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VzoaTwVdAro96XotUYZb2/DLH8tIIuWVE8OdmJPASv5qn2HorE+B5qXQwqnQ0ivmI
         3v/NcO45RIkvoq3/0JA+y+qqsAMENd9u9D/UWcbeRF72M2uDYTvdoY+OLf2XtmIjb0
         QugB2kkhtK9cn82UIcWkvu5opPJlQ6lnNOkqxufs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4.14 22/63] crypto: gcm - fix incompatibility between "gcm" and "gcm_base"
Date:   Mon, 20 May 2019 14:14:01 +0200
Message-Id: <20190520115233.518758551@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115231.137981521@linuxfoundation.org>
References: <20190520115231.137981521@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit f699594d436960160f6d5ba84ed4a222f20d11cd upstream.

GCM instances can be created by either the "gcm" template, which only
allows choosing the block cipher, e.g. "gcm(aes)"; or by "gcm_base",
which allows choosing the ctr and ghash implementations, e.g.
"gcm_base(ctr(aes-generic),ghash-generic)".

However, a "gcm_base" instance prevents a "gcm" instance from being
registered using the same implementations.  Nor will the instance be
found by lookups of "gcm".  This can be used as a denial of service.
Moreover, "gcm_base" instances are never tested by the crypto
self-tests, even if there are compatible "gcm" tests.

The root cause of these problems is that instances of the two templates
use different cra_names.  Therefore, fix these problems by making
"gcm_base" instances set the same cra_name as "gcm" instances, e.g.
"gcm(aes)" instead of "gcm_base(ctr(aes-generic),ghash-generic)".

This requires extracting the block cipher name from the name of the ctr
algorithm.  It also requires starting to verify that the algorithms are
really ctr and ghash, not something else entirely.  But it would be
bizarre if anyone were actually using non-gcm-compatible algorithms with
gcm_base, so this shouldn't break anyone in practice.

Fixes: d00aa19b507b ("[CRYPTO] gcm: Allow block cipher parameter")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 crypto/gcm.c |   34 +++++++++++-----------------------
 1 file changed, 11 insertions(+), 23 deletions(-)

--- a/crypto/gcm.c
+++ b/crypto/gcm.c
@@ -616,7 +616,6 @@ static void crypto_gcm_free(struct aead_
 
 static int crypto_gcm_create_common(struct crypto_template *tmpl,
 				    struct rtattr **tb,
-				    const char *full_name,
 				    const char *ctr_name,
 				    const char *ghash_name)
 {
@@ -657,7 +656,8 @@ static int crypto_gcm_create_common(stru
 		goto err_free_inst;
 
 	err = -EINVAL;
-	if (ghash->digestsize != 16)
+	if (strcmp(ghash->base.cra_name, "ghash") != 0 ||
+	    ghash->digestsize != 16)
 		goto err_drop_ghash;
 
 	crypto_set_skcipher_spawn(&ctx->ctr, aead_crypto_instance(inst));
@@ -669,24 +669,24 @@ static int crypto_gcm_create_common(stru
 
 	ctr = crypto_spawn_skcipher_alg(&ctx->ctr);
 
-	/* We only support 16-byte blocks. */
+	/* The skcipher algorithm must be CTR mode, using 16-byte blocks. */
 	err = -EINVAL;
-	if (crypto_skcipher_alg_ivsize(ctr) != 16)
+	if (strncmp(ctr->base.cra_name, "ctr(", 4) != 0 ||
+	    crypto_skcipher_alg_ivsize(ctr) != 16 ||
+	    ctr->base.cra_blocksize != 1)
 		goto out_put_ctr;
 
-	/* Not a stream cipher? */
-	if (ctr->base.cra_blocksize != 1)
+	err = -ENAMETOOLONG;
+	if (snprintf(inst->alg.base.cra_name, CRYPTO_MAX_ALG_NAME,
+		     "gcm(%s", ctr->base.cra_name + 4) >= CRYPTO_MAX_ALG_NAME)
 		goto out_put_ctr;
 
-	err = -ENAMETOOLONG;
 	if (snprintf(inst->alg.base.cra_driver_name, CRYPTO_MAX_ALG_NAME,
 		     "gcm_base(%s,%s)", ctr->base.cra_driver_name,
 		     ghash_alg->cra_driver_name) >=
 	    CRYPTO_MAX_ALG_NAME)
 		goto out_put_ctr;
 
-	memcpy(inst->alg.base.cra_name, full_name, CRYPTO_MAX_ALG_NAME);
-
 	inst->alg.base.cra_flags = (ghash->base.cra_flags |
 				    ctr->base.cra_flags) & CRYPTO_ALG_ASYNC;
 	inst->alg.base.cra_priority = (ghash->base.cra_priority +
@@ -728,7 +728,6 @@ static int crypto_gcm_create(struct cryp
 {
 	const char *cipher_name;
 	char ctr_name[CRYPTO_MAX_ALG_NAME];
-	char full_name[CRYPTO_MAX_ALG_NAME];
 
 	cipher_name = crypto_attr_alg_name(tb[1]);
 	if (IS_ERR(cipher_name))
@@ -738,12 +737,7 @@ static int crypto_gcm_create(struct cryp
 	    CRYPTO_MAX_ALG_NAME)
 		return -ENAMETOOLONG;
 
-	if (snprintf(full_name, CRYPTO_MAX_ALG_NAME, "gcm(%s)", cipher_name) >=
-	    CRYPTO_MAX_ALG_NAME)
-		return -ENAMETOOLONG;
-
-	return crypto_gcm_create_common(tmpl, tb, full_name,
-					ctr_name, "ghash");
+	return crypto_gcm_create_common(tmpl, tb, ctr_name, "ghash");
 }
 
 static struct crypto_template crypto_gcm_tmpl = {
@@ -757,7 +751,6 @@ static int crypto_gcm_base_create(struct
 {
 	const char *ctr_name;
 	const char *ghash_name;
-	char full_name[CRYPTO_MAX_ALG_NAME];
 
 	ctr_name = crypto_attr_alg_name(tb[1]);
 	if (IS_ERR(ctr_name))
@@ -767,12 +760,7 @@ static int crypto_gcm_base_create(struct
 	if (IS_ERR(ghash_name))
 		return PTR_ERR(ghash_name);
 
-	if (snprintf(full_name, CRYPTO_MAX_ALG_NAME, "gcm_base(%s,%s)",
-		     ctr_name, ghash_name) >= CRYPTO_MAX_ALG_NAME)
-		return -ENAMETOOLONG;
-
-	return crypto_gcm_create_common(tmpl, tb, full_name,
-					ctr_name, ghash_name);
+	return crypto_gcm_create_common(tmpl, tb, ctr_name, ghash_name);
 }
 
 static struct crypto_template crypto_gcm_base_tmpl = {


