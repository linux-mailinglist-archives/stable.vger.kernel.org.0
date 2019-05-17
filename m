Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74F562182F
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 14:32:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728434AbfEQMcP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 May 2019 08:32:15 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:44911 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728365AbfEQMcO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 May 2019 08:32:14 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id C67F846A;
        Fri, 17 May 2019 08:32:13 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Fri, 17 May 2019 08:32:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=TnOTCg
        eIQ9T6sj247YlxCYEQ/y/Smaixn2SNWICtC60=; b=7pZ+rAPPbvH/uLUjHXJdrb
        +J1pN6/cUaFe5FWvwKxhoKAzL4YUpU0L533GItMAO2i869RgcNEDQETXsTG/zx4X
        QhLyOcgpOXip0lwruy8EhwwE4gnkQMgl9rd2IB8mVin/US6GFOcMLwMkuQUvI6ql
        dwyXBK2/slNImL0QfFRKxahsGLdoGpIrOYhF7pTBkZt8ZdBnUAt0bo/eqs2krkio
        8Du1lVrWI06qHJBq+oSy+nTYMnvjPxgGWRdCzrX6QL9DNIK9vB28XaQPLlN7FAGN
        tg/nrFl7LXI7av2L5rTAKj1kv67Vd6MPPBGr9cGggb/2lq17mL5oPI62eUUbdsXA
        ==
X-ME-Sender: <xms:zaneXMIzjn4g0VDBo_TNd3qejn1n008uQ9gH5bKZ4-6i8xEsW58gxg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddtvddgheegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepvd
X-ME-Proxy: <xmx:zaneXGO1MeqaB7x70cKMfOosy1yzwmPOOQKGfoff-IQEuTQVCIlDuA>
    <xmx:zaneXMmIP-VIsrdceXjdHOU8i6lJyiQEx1c31unUoz4CeJXDo9WPkw>
    <xmx:zaneXK7OpqZGIj04pP5ZXwZydDUNK7BxlFrVwfls3qjFFbCMW2DW-A>
    <xmx:zaneXNWDDZ0-GPJaYcl-zqnBSg5ozhrWHGLgTn0sdK_MgV7o24PhOQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id CDDAB8005B;
        Fri, 17 May 2019 08:32:12 -0400 (EDT)
Subject: FAILED: patch "[PATCH] crypto: ccm - fix incompatibility between "ccm" and" failed to apply to 4.19-stable tree
To:     ebiggers@google.com, herbert@gondor.apana.org.au
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 17 May 2019 14:32:08 +0200
Message-ID: <15580963282342@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 6a1faa4a43f5fabf9cbeaa742d916e7b5e73120f Mon Sep 17 00:00:00 2001
From: Eric Biggers <ebiggers@google.com>
Date: Thu, 18 Apr 2019 14:44:27 -0700
Subject: [PATCH] crypto: ccm - fix incompatibility between "ccm" and
 "ccm_base"

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

diff --git a/crypto/ccm.c b/crypto/ccm.c
index 3d036df0f4d4..c1ef9d0b4271 100644
--- a/crypto/ccm.c
+++ b/crypto/ccm.c
@@ -458,7 +458,6 @@ static void crypto_ccm_free(struct aead_instance *inst)
 
 static int crypto_ccm_create_common(struct crypto_template *tmpl,
 				    struct rtattr **tb,
-				    const char *full_name,
 				    const char *ctr_name,
 				    const char *mac_name)
 {
@@ -486,7 +485,8 @@ static int crypto_ccm_create_common(struct crypto_template *tmpl,
 
 	mac = __crypto_hash_alg_common(mac_alg);
 	err = -EINVAL;
-	if (mac->digestsize != 16)
+	if (strncmp(mac->base.cra_name, "cbcmac(", 7) != 0 ||
+	    mac->digestsize != 16)
 		goto out_put_mac;
 
 	inst = kzalloc(sizeof(*inst) + sizeof(*ictx), GFP_KERNEL);
@@ -509,23 +509,27 @@ static int crypto_ccm_create_common(struct crypto_template *tmpl,
 
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
@@ -567,7 +571,6 @@ static int crypto_ccm_create(struct crypto_template *tmpl, struct rtattr **tb)
 	const char *cipher_name;
 	char ctr_name[CRYPTO_MAX_ALG_NAME];
 	char mac_name[CRYPTO_MAX_ALG_NAME];
-	char full_name[CRYPTO_MAX_ALG_NAME];
 
 	cipher_name = crypto_attr_alg_name(tb[1]);
 	if (IS_ERR(cipher_name))
@@ -581,35 +584,24 @@ static int crypto_ccm_create(struct crypto_template *tmpl, struct rtattr **tb)
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
 
 static int crypto_ccm_base_create(struct crypto_template *tmpl,
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
 
 static int crypto_rfc4309_setkey(struct crypto_aead *parent, const u8 *key,

