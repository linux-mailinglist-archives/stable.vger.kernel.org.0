Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A87A31D3BCE
	for <lists+stable@lfdr.de>; Thu, 14 May 2020 21:06:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728256AbgENTFX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 May 2020 15:05:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:53978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728958AbgENSyJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 May 2020 14:54:09 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 05B1C2065F;
        Thu, 14 May 2020 18:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589482448;
        bh=fBpP8X/WaYW2HyxOaplXw8jXhd39XlGZggiJ4YE3d/8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bd5Y9axaUgqo8oVcs3hCDHSqV5K2IZ5dJWt3rnYDz0tAmEsPg/92Sg/GQmOO5+Imy
         e9f6vx4C/lRaKzay7eFo3B25KEHHY3VcoHcMPIcWAzOvp3MZ30RMEuQ4+zAXPMSM2v
         gufRdkQ85bp6Fl6Ge2RcbcyW1QcUKZP+WYu01j5M=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 47/49] crypto: lrw - simplify error handling in create()
Date:   Thu, 14 May 2020 14:53:08 -0400
Message-Id: <20200514185311.20294-47-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200514185311.20294-1-sashal@kernel.org>
References: <20200514185311.20294-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

[ Upstream commit d57063103332b95eac9c118900f35700a491da08 ]

Simplify the error handling in the LRW template's ->create() function by
taking advantage of crypto_drop_skcipher() now accepting (as a no-op) a
spawn that hasn't been grabbed yet.

Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/lrw.c | 28 +++++++++++-----------------
 1 file changed, 11 insertions(+), 17 deletions(-)

diff --git a/crypto/lrw.c b/crypto/lrw.c
index be829f6afc8e5..fda9414890865 100644
--- a/crypto/lrw.c
+++ b/crypto/lrw.c
@@ -344,15 +344,15 @@ static int create(struct crypto_template *tmpl, struct rtattr **tb)
 
 	err = -EINVAL;
 	if (alg->base.cra_blocksize != LRW_BLOCK_SIZE)
-		goto err_drop_spawn;
+		goto err_free_inst;
 
 	if (crypto_skcipher_alg_ivsize(alg))
-		goto err_drop_spawn;
+		goto err_free_inst;
 
 	err = crypto_inst_setname(skcipher_crypto_instance(inst), "lrw",
 				  &alg->base);
 	if (err)
-		goto err_drop_spawn;
+		goto err_free_inst;
 
 	err = -EINVAL;
 	cipher_name = alg->base.cra_name;
@@ -365,20 +365,20 @@ static int create(struct crypto_template *tmpl, struct rtattr **tb)
 
 		len = strlcpy(ecb_name, cipher_name + 4, sizeof(ecb_name));
 		if (len < 2 || len >= sizeof(ecb_name))
-			goto err_drop_spawn;
+			goto err_free_inst;
 
 		if (ecb_name[len - 1] != ')')
-			goto err_drop_spawn;
+			goto err_free_inst;
 
 		ecb_name[len - 1] = 0;
 
 		if (snprintf(inst->alg.base.cra_name, CRYPTO_MAX_ALG_NAME,
 			     "lrw(%s)", ecb_name) >= CRYPTO_MAX_ALG_NAME) {
 			err = -ENAMETOOLONG;
-			goto err_drop_spawn;
+			goto err_free_inst;
 		}
 	} else
-		goto err_drop_spawn;
+		goto err_free_inst;
 
 	inst->alg.base.cra_flags = alg->base.cra_flags & CRYPTO_ALG_ASYNC;
 	inst->alg.base.cra_priority = alg->base.cra_priority;
@@ -404,17 +404,11 @@ static int create(struct crypto_template *tmpl, struct rtattr **tb)
 	inst->free = free;
 
 	err = skcipher_register_instance(tmpl, inst);
-	if (err)
-		goto err_drop_spawn;
-
-out:
-	return err;
-
-err_drop_spawn:
-	crypto_drop_skcipher(spawn);
+	if (err) {
 err_free_inst:
-	kfree(inst);
-	goto out;
+		free(inst);
+	}
+	return err;
 }
 
 static struct crypto_template crypto_tmpl = {
-- 
2.20.1

