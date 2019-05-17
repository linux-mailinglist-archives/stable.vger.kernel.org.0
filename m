Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18BD02183B
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 14:37:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728789AbfEQMha (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 May 2019 08:37:30 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:48887 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728387AbfEQMha (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 May 2019 08:37:30 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 684D1423;
        Fri, 17 May 2019 08:37:29 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Fri, 17 May 2019 08:37:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=sRn1Ne
        wZVLYe6SpwwyWqHeqvYI7fT9dUowiQesuJsxI=; b=TXVyjhaPAbK5fr2HLZtxXK
        zMYc/rBxdpJ6tqkDD8ooSPvp9V3WFvsnl+TLUvD6Kpi0wv9SRI/T2SZokuzHcnts
        CHQWG/eCkvMyAbJwcUKVO22iEloKac2f6AEKpovRKIlez5gwWODDplq044dL7O2x
        iqizt4ckX1MzyprTvkD1sAv5PPzb2yb8Y5TnCmA8J1b2REYeK6mokCbiW6cImTZ0
        UqgJ9S7798e/YMz5BP7sBbFDwrD4yy9/OubmhEbvyKf76EGvWp3agbl7wHnKvmb0
        YU9IOSFknw5C9bwzoCAIUWJwpzzECeOuzlQa5V6/LjDbW/bSCKukVO6e17hXd+dw
        ==
X-ME-Sender: <xms:CKveXCZSS_5aQm270wNefKTKmpnuIaNYGgKl-sC02u83CdFVjI0dpQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddtvddgheehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepud
X-ME-Proxy: <xmx:CKveXJXdnjwh_xZBXakmVYsQLXQ6ETEJEZxszawX8_1Fo1odYpl7Gw>
    <xmx:CKveXBjtCgrj4mpkoZA15dJY-YpuBfoS9ZO-Iyf7Dmu9uy3SbMUN7w>
    <xmx:CKveXMmMcI9fm058LmB80Nuj7LqCqbmFuk2dkVp7hPHE0sC8GqMMrA>
    <xmx:CaveXEOiP6OPxayuMaxg1OX4nPRoauF0CjFlcd9nFEDACs9ExH2XmQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 528C380061;
        Fri, 17 May 2019 08:37:28 -0400 (EDT)
Subject: FAILED: patch "[PATCH] crypto: gcm - fix incompatibility between "gcm" and" failed to apply to 4.4-stable tree
To:     ebiggers@google.com, herbert@gondor.apana.org.au
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 17 May 2019 14:37:18 +0200
Message-ID: <155809663838222@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f699594d436960160f6d5ba84ed4a222f20d11cd Mon Sep 17 00:00:00 2001
From: Eric Biggers <ebiggers@google.com>
Date: Thu, 18 Apr 2019 14:43:02 -0700
Subject: [PATCH] crypto: gcm - fix incompatibility between "gcm" and
 "gcm_base"

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

diff --git a/crypto/gcm.c b/crypto/gcm.c
index ff498411b43f..33f45a980967 100644
--- a/crypto/gcm.c
+++ b/crypto/gcm.c
@@ -597,7 +597,6 @@ static void crypto_gcm_free(struct aead_instance *inst)
 
 static int crypto_gcm_create_common(struct crypto_template *tmpl,
 				    struct rtattr **tb,
-				    const char *full_name,
 				    const char *ctr_name,
 				    const char *ghash_name)
 {
@@ -638,7 +637,8 @@ static int crypto_gcm_create_common(struct crypto_template *tmpl,
 		goto err_free_inst;
 
 	err = -EINVAL;
-	if (ghash->digestsize != 16)
+	if (strcmp(ghash->base.cra_name, "ghash") != 0 ||
+	    ghash->digestsize != 16)
 		goto err_drop_ghash;
 
 	crypto_set_skcipher_spawn(&ctx->ctr, aead_crypto_instance(inst));
@@ -650,24 +650,24 @@ static int crypto_gcm_create_common(struct crypto_template *tmpl,
 
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
@@ -709,7 +709,6 @@ static int crypto_gcm_create(struct crypto_template *tmpl, struct rtattr **tb)
 {
 	const char *cipher_name;
 	char ctr_name[CRYPTO_MAX_ALG_NAME];
-	char full_name[CRYPTO_MAX_ALG_NAME];
 
 	cipher_name = crypto_attr_alg_name(tb[1]);
 	if (IS_ERR(cipher_name))
@@ -719,12 +718,7 @@ static int crypto_gcm_create(struct crypto_template *tmpl, struct rtattr **tb)
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
 
 static int crypto_gcm_base_create(struct crypto_template *tmpl,
@@ -732,7 +726,6 @@ static int crypto_gcm_base_create(struct crypto_template *tmpl,
 {
 	const char *ctr_name;
 	const char *ghash_name;
-	char full_name[CRYPTO_MAX_ALG_NAME];
 
 	ctr_name = crypto_attr_alg_name(tb[1]);
 	if (IS_ERR(ctr_name))
@@ -742,12 +735,7 @@ static int crypto_gcm_base_create(struct crypto_template *tmpl,
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
 
 static int crypto_rfc4106_setkey(struct crypto_aead *parent, const u8 *key,

