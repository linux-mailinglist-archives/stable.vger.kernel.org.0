Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 034FF23756
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 15:18:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388825AbfETMYZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:24:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:39206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388821AbfETMYY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:24:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D51720675;
        Mon, 20 May 2019 12:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355063;
        bh=Cw6AfNVwd6J7h6gKJMpXsWrvyEHcG2I1ykekQ3qiNXA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z1r79jQ3DJl+k3KxOyJaPd5e4zFZre0SyxtplqCudzo3+VnXEGRZcmU4l/U7aF7FC
         7lp3wbN5a8mqKC7J1C3EdQD63yaM8FFcT/DGDhGkhyqjarc1xdIiRDZp0VDANqXUTj
         d9jEKODGu3BQuMq+OD3ZTYutkagalAgi0phyiq7k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4.19 082/105] crypto: ccm - fix incompatibility between "ccm" and "ccm_base"
Date:   Mon, 20 May 2019 14:14:28 +0200
Message-Id: <20190520115252.923979601@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115247.060821231@linuxfoundation.org>
References: <20190520115247.060821231@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit 6a1faa4a43f5fabf9cbeaa742d916e7b5e73120f upstream.

CCM instances can be created by either the "ccm" template, which only
allows choosing the block cipher, e.g. "ccm(aes)"; or by "ccm_base",
which allows choosing the ctr and cbcmac implementations, e.g.
"ccm_base(ctr(aes-generic),cbcmac(aes-generic))".

However, a "ccm_base" instance prevents a "ccm" instance from being
registered using the same implementations.  Nor will the instance be
found by lookups of "ccm".  This can be used as a denial of service.
Moreover, "ccm_base" instances are never tested by the crypto
self-tests, even if there are compatible "ccm" tests.

The root cause of these problems is that instances of the two templates
use different cra_names.  Therefore, fix these problems by making
"ccm_base" instances set the same cra_name as "ccm" instances, e.g.
"ccm(aes)" instead of "ccm_base(ctr(aes-generic),cbcmac(aes-generic))".

This requires extracting the block cipher name from the name of the ctr
and cbcmac algorithms.  It also requires starting to verify that the
algorithms are really ctr and cbcmac using the same block cipher, not
something else entirely.  But it would be bizarre if anyone were
actually using non-ccm-compatible algorithms with ccm_base, so this
shouldn't break anyone in practice.

Fixes: 4a49b499dfa0 ("[CRYPTO] ccm: Added CCM mode")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 crypto/ccm.c |   44 ++++++++++++++++++--------------------------
 1 file changed, 18 insertions(+), 26 deletions(-)

--- a/crypto/ccm.c
+++ b/crypto/ccm.c
@@ -455,7 +455,6 @@ static void crypto_ccm_free(struct aead_
 
 static int crypto_ccm_create_common(struct crypto_template *tmpl,
 				    struct rtattr **tb,
-				    const char *full_name,
 				    const char *ctr_name,
 				    const char *mac_name)
 {
@@ -483,7 +482,8 @@ static int crypto_ccm_create_common(stru
 
 	mac = __crypto_hash_alg_common(mac_alg);
 	err = -EINVAL;
-	if (mac->digestsize != 16)
+	if (strncmp(mac->base.cra_name, "cbcmac(", 7) != 0 ||
+	    mac->digestsize != 16)
 		goto out_put_mac;
 
 	inst = kzalloc(sizeof(*inst) + sizeof(*ictx), GFP_KERNEL);
@@ -506,23 +506,27 @@ static int crypto_ccm_create_common(stru
 
 	ctr = crypto_spawn_skcipher_alg(&ictx->ctr);
 
-	/* Not a stream cipher? */
+	/* The skcipher algorithm must be CTR mode, using 16-byte blocks. */
 	err = -EINVAL;
-	if (ctr->base.cra_blocksize != 1)
+	if (strncmp(ctr->base.cra_name, "ctr(", 4) != 0 ||
+	    crypto_skcipher_alg_ivsize(ctr) != 16 ||
+	    ctr->base.cra_blocksize != 1)
 		goto err_drop_ctr;
 
-	/* We want the real thing! */
-	if (crypto_skcipher_alg_ivsize(ctr) != 16)
+	/* ctr and cbcmac must use the same underlying block cipher. */
+	if (strcmp(ctr->base.cra_name + 4, mac->base.cra_name + 7) != 0)
 		goto err_drop_ctr;
 
 	err = -ENAMETOOLONG;
+	if (snprintf(inst->alg.base.cra_name, CRYPTO_MAX_ALG_NAME,
+		     "ccm(%s", ctr->base.cra_name + 4) >= CRYPTO_MAX_ALG_NAME)
+		goto err_drop_ctr;
+
 	if (snprintf(inst->alg.base.cra_driver_name, CRYPTO_MAX_ALG_NAME,
 		     "ccm_base(%s,%s)", ctr->base.cra_driver_name,
 		     mac->base.cra_driver_name) >= CRYPTO_MAX_ALG_NAME)
 		goto err_drop_ctr;
 
-	memcpy(inst->alg.base.cra_name, full_name, CRYPTO_MAX_ALG_NAME);
-
 	inst->alg.base.cra_flags = ctr->base.cra_flags & CRYPTO_ALG_ASYNC;
 	inst->alg.base.cra_priority = (mac->base.cra_priority +
 				       ctr->base.cra_priority) / 2;
@@ -564,7 +568,6 @@ static int crypto_ccm_create(struct cryp
 	const char *cipher_name;
 	char ctr_name[CRYPTO_MAX_ALG_NAME];
 	char mac_name[CRYPTO_MAX_ALG_NAME];
-	char full_name[CRYPTO_MAX_ALG_NAME];
 
 	cipher_name = crypto_attr_alg_name(tb[1]);
 	if (IS_ERR(cipher_name))
@@ -578,12 +581,7 @@ static int crypto_ccm_create(struct cryp
 		     cipher_name) >= CRYPTO_MAX_ALG_NAME)
 		return -ENAMETOOLONG;
 
-	if (snprintf(full_name, CRYPTO_MAX_ALG_NAME, "ccm(%s)", cipher_name) >=
-	    CRYPTO_MAX_ALG_NAME)
-		return -ENAMETOOLONG;
-
-	return crypto_ccm_create_common(tmpl, tb, full_name, ctr_name,
-					mac_name);
+	return crypto_ccm_create_common(tmpl, tb, ctr_name, mac_name);
 }
 
 static struct crypto_template crypto_ccm_tmpl = {
@@ -596,23 +594,17 @@ static int crypto_ccm_base_create(struct
 				  struct rtattr **tb)
 {
 	const char *ctr_name;
-	const char *cipher_name;
-	char full_name[CRYPTO_MAX_ALG_NAME];
+	const char *mac_name;
 
 	ctr_name = crypto_attr_alg_name(tb[1]);
 	if (IS_ERR(ctr_name))
 		return PTR_ERR(ctr_name);
 
-	cipher_name = crypto_attr_alg_name(tb[2]);
-	if (IS_ERR(cipher_name))
-		return PTR_ERR(cipher_name);
-
-	if (snprintf(full_name, CRYPTO_MAX_ALG_NAME, "ccm_base(%s,%s)",
-		     ctr_name, cipher_name) >= CRYPTO_MAX_ALG_NAME)
-		return -ENAMETOOLONG;
+	mac_name = crypto_attr_alg_name(tb[2]);
+	if (IS_ERR(mac_name))
+		return PTR_ERR(mac_name);
 
-	return crypto_ccm_create_common(tmpl, tb, full_name, ctr_name,
-					cipher_name);
+	return crypto_ccm_create_common(tmpl, tb, ctr_name, mac_name);
 }
 
 static struct crypto_template crypto_ccm_base_tmpl = {


