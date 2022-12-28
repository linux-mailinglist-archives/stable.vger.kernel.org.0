Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A14D0658082
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:18:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234599AbiL1QSF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:18:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234716AbiL1QRT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:17:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EA5A1869A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:15:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B08D96156C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:15:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF1CBC433D2;
        Wed, 28 Dec 2022 16:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244136;
        bh=+4Zvaa0MdZ8E7XuqalKiyLuNju0/wJug6N0636E/LTI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Eb/ypVkMsBxFK4AMOyp22qxwRIdrOrxPhjevkgl+Lc5LaKD2uzLdHJcvz4Rkgqk5f
         xQQ9xwWOnBSWERZNOXps4shpTUsQFiOgdWcHJHcYMcshA6a4IEzQX4yyfgo5Tu3YOA
         H2T26JBP4YIIV7zG1iZyPUQvj/xmxqLOtUcB8r1U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0617/1146] crypto: cryptd - Use request context instead of stack for sub-request
Date:   Wed, 28 Dec 2022 15:35:56 +0100
Message-Id: <20221228144346.928267123@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 3a58c231172537f7b0e19d93ed33decd04f80eab ]

cryptd is buggy as it tries to use sync_skcipher without going
through the proper sync_skcipher interface.  In fact it doesn't
even need sync_skcipher since it's already a proper skcipher and
can easily access the request context instead of using something
off the stack.

Fixes: 36b3875a97b8 ("crypto: cryptd - Remove VLA usage of skcipher")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/cryptd.c | 36 +++++++++++++++++++-----------------
 1 file changed, 19 insertions(+), 17 deletions(-)

diff --git a/crypto/cryptd.c b/crypto/cryptd.c
index 668095eca0fa..ca3a40fc7da9 100644
--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -68,11 +68,12 @@ struct aead_instance_ctx {
 
 struct cryptd_skcipher_ctx {
 	refcount_t refcnt;
-	struct crypto_sync_skcipher *child;
+	struct crypto_skcipher *child;
 };
 
 struct cryptd_skcipher_request_ctx {
 	crypto_completion_t complete;
+	struct skcipher_request req;
 };
 
 struct cryptd_hash_ctx {
@@ -227,13 +228,13 @@ static int cryptd_skcipher_setkey(struct crypto_skcipher *parent,
 				  const u8 *key, unsigned int keylen)
 {
 	struct cryptd_skcipher_ctx *ctx = crypto_skcipher_ctx(parent);
-	struct crypto_sync_skcipher *child = ctx->child;
+	struct crypto_skcipher *child = ctx->child;
 
-	crypto_sync_skcipher_clear_flags(child, CRYPTO_TFM_REQ_MASK);
-	crypto_sync_skcipher_set_flags(child,
-				       crypto_skcipher_get_flags(parent) &
-					 CRYPTO_TFM_REQ_MASK);
-	return crypto_sync_skcipher_setkey(child, key, keylen);
+	crypto_skcipher_clear_flags(child, CRYPTO_TFM_REQ_MASK);
+	crypto_skcipher_set_flags(child,
+				  crypto_skcipher_get_flags(parent) &
+				  CRYPTO_TFM_REQ_MASK);
+	return crypto_skcipher_setkey(child, key, keylen);
 }
 
 static void cryptd_skcipher_complete(struct skcipher_request *req, int err)
@@ -258,13 +259,13 @@ static void cryptd_skcipher_encrypt(struct crypto_async_request *base,
 	struct cryptd_skcipher_request_ctx *rctx = skcipher_request_ctx(req);
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct cryptd_skcipher_ctx *ctx = crypto_skcipher_ctx(tfm);
-	struct crypto_sync_skcipher *child = ctx->child;
-	SYNC_SKCIPHER_REQUEST_ON_STACK(subreq, child);
+	struct skcipher_request *subreq = &rctx->req;
+	struct crypto_skcipher *child = ctx->child;
 
 	if (unlikely(err == -EINPROGRESS))
 		goto out;
 
-	skcipher_request_set_sync_tfm(subreq, child);
+	skcipher_request_set_tfm(subreq, child);
 	skcipher_request_set_callback(subreq, CRYPTO_TFM_REQ_MAY_SLEEP,
 				      NULL, NULL);
 	skcipher_request_set_crypt(subreq, req->src, req->dst, req->cryptlen,
@@ -286,13 +287,13 @@ static void cryptd_skcipher_decrypt(struct crypto_async_request *base,
 	struct cryptd_skcipher_request_ctx *rctx = skcipher_request_ctx(req);
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct cryptd_skcipher_ctx *ctx = crypto_skcipher_ctx(tfm);
-	struct crypto_sync_skcipher *child = ctx->child;
-	SYNC_SKCIPHER_REQUEST_ON_STACK(subreq, child);
+	struct skcipher_request *subreq = &rctx->req;
+	struct crypto_skcipher *child = ctx->child;
 
 	if (unlikely(err == -EINPROGRESS))
 		goto out;
 
-	skcipher_request_set_sync_tfm(subreq, child);
+	skcipher_request_set_tfm(subreq, child);
 	skcipher_request_set_callback(subreq, CRYPTO_TFM_REQ_MAY_SLEEP,
 				      NULL, NULL);
 	skcipher_request_set_crypt(subreq, req->src, req->dst, req->cryptlen,
@@ -343,9 +344,10 @@ static int cryptd_skcipher_init_tfm(struct crypto_skcipher *tfm)
 	if (IS_ERR(cipher))
 		return PTR_ERR(cipher);
 
-	ctx->child = (struct crypto_sync_skcipher *)cipher;
+	ctx->child = cipher;
 	crypto_skcipher_set_reqsize(
-		tfm, sizeof(struct cryptd_skcipher_request_ctx));
+		tfm, sizeof(struct cryptd_skcipher_request_ctx) +
+		     crypto_skcipher_reqsize(cipher));
 	return 0;
 }
 
@@ -353,7 +355,7 @@ static void cryptd_skcipher_exit_tfm(struct crypto_skcipher *tfm)
 {
 	struct cryptd_skcipher_ctx *ctx = crypto_skcipher_ctx(tfm);
 
-	crypto_free_sync_skcipher(ctx->child);
+	crypto_free_skcipher(ctx->child);
 }
 
 static void cryptd_skcipher_free(struct skcipher_instance *inst)
@@ -931,7 +933,7 @@ struct crypto_skcipher *cryptd_skcipher_child(struct cryptd_skcipher *tfm)
 {
 	struct cryptd_skcipher_ctx *ctx = crypto_skcipher_ctx(&tfm->base);
 
-	return &ctx->child->base;
+	return ctx->child;
 }
 EXPORT_SYMBOL_GPL(cryptd_skcipher_child);
 
-- 
2.35.1



