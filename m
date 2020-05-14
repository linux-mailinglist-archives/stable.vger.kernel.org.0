Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 415041D3CA1
	for <lists+stable@lfdr.de>; Thu, 14 May 2020 21:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728316AbgENTIv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 May 2020 15:08:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:52024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728568AbgENSxF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 May 2020 14:53:05 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F1B0E206DC;
        Thu, 14 May 2020 18:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589482384;
        bh=asT13lXLqrmQ9DkSvcmPjMnK3Y0L+jOZqMCgAppTv88=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qbSK0XTnpPnglzj4KycwzvtVqoPDJ+PQwvA4GMpH7runCOesbWwKUSa69ZGp6oJzd
         AvHqi+mSJ8hrzdpN/tjFufGd+RzuEAN4Foq+xqaR9wKDNUjLeE62Sjslcgbn1I0IkZ
         HfFQbWz5fEu9ZhZBR4YzC9axGqRt+Hn6RUTuI+O0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 61/62] crypto: xts - simplify error handling in ->create()
Date:   Thu, 14 May 2020 14:51:46 -0400
Message-Id: <20200514185147.19716-61-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200514185147.19716-1-sashal@kernel.org>
References: <20200514185147.19716-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

[ Upstream commit 732e540953477083082e999ff553622c59cffd5f ]

Simplify the error handling in the XTS template's ->create() function by
taking advantage of crypto_drop_skcipher() now accepting (as a no-op) a
spawn that hasn't been grabbed yet.

Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/xts.c | 28 +++++++++++-----------------
 1 file changed, 11 insertions(+), 17 deletions(-)

diff --git a/crypto/xts.c b/crypto/xts.c
index 29efa15f14954..dbdd8af629e69 100644
--- a/crypto/xts.c
+++ b/crypto/xts.c
@@ -379,15 +379,15 @@ static int create(struct crypto_template *tmpl, struct rtattr **tb)
 
 	err = -EINVAL;
 	if (alg->base.cra_blocksize != XTS_BLOCK_SIZE)
-		goto err_drop_spawn;
+		goto err_free_inst;
 
 	if (crypto_skcipher_alg_ivsize(alg))
-		goto err_drop_spawn;
+		goto err_free_inst;
 
 	err = crypto_inst_setname(skcipher_crypto_instance(inst), "xts",
 				  &alg->base);
 	if (err)
-		goto err_drop_spawn;
+		goto err_free_inst;
 
 	err = -EINVAL;
 	cipher_name = alg->base.cra_name;
@@ -400,20 +400,20 @@ static int create(struct crypto_template *tmpl, struct rtattr **tb)
 
 		len = strlcpy(ctx->name, cipher_name + 4, sizeof(ctx->name));
 		if (len < 2 || len >= sizeof(ctx->name))
-			goto err_drop_spawn;
+			goto err_free_inst;
 
 		if (ctx->name[len - 1] != ')')
-			goto err_drop_spawn;
+			goto err_free_inst;
 
 		ctx->name[len - 1] = 0;
 
 		if (snprintf(inst->alg.base.cra_name, CRYPTO_MAX_ALG_NAME,
 			     "xts(%s)", ctx->name) >= CRYPTO_MAX_ALG_NAME) {
 			err = -ENAMETOOLONG;
-			goto err_drop_spawn;
+			goto err_free_inst;
 		}
 	} else
-		goto err_drop_spawn;
+		goto err_free_inst;
 
 	inst->alg.base.cra_flags = alg->base.cra_flags & CRYPTO_ALG_ASYNC;
 	inst->alg.base.cra_priority = alg->base.cra_priority;
@@ -437,17 +437,11 @@ static int create(struct crypto_template *tmpl, struct rtattr **tb)
 	inst->free = free;
 
 	err = skcipher_register_instance(tmpl, inst);
-	if (err)
-		goto err_drop_spawn;
-
-out:
-	return err;
-
-err_drop_spawn:
-	crypto_drop_skcipher(&ctx->spawn);
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

