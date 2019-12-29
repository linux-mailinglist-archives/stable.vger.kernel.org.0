Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56C1012C4DA
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:34:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728761AbfL2RdZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:33:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:35118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729439AbfL2RdZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:33:25 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22F7720409;
        Sun, 29 Dec 2019 17:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577640803;
        bh=LQaddwEJjmqCheloHLacykrjH4zIPHN5/rpLmmVcGnY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MtTsyEvflydSf9Jr8yRmJhvE5BB0Zq0cN97zl7Vi9g2r6SmSVjLHHbbeaQ2/YCotC
         gjQvOFnR9B5WDDFLEhmvYMCDSOMVcXnALTdM0V+OyvV5oZ80LYPSyGZpTPCpqrsagl
         3J/2TjzVGtQZQaK0GY9fvPYwclhyJKYWnWSy6o/I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 146/219] crypto: atmel - Fix authenc support when it is set to m
Date:   Sun, 29 Dec 2019 18:19:08 +0100
Message-Id: <20191229162530.338306076@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229162508.458551679@linuxfoundation.org>
References: <20191229162508.458551679@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 1520c72596dde7f22b8bd6bed3ef7df2b8b7ef39 ]

As it is if CONFIG_CRYPTO_DEV_ATMEL_AUTHENC is set to m it is in
effect disabled.  This patch fixes it by using IS_ENABLED instead
of ifdef.

Fixes: 89a82ef87e01 ("crypto: atmel-authenc - add support to...")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Reviewed-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/atmel-aes.c     | 18 +++++++++---------
 drivers/crypto/atmel-authenc.h |  2 +-
 drivers/crypto/atmel-sha.c     |  2 +-
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index f662914d87b8..53a78035381d 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -148,7 +148,7 @@ struct atmel_aes_xts_ctx {
 	u32			key2[AES_KEYSIZE_256 / sizeof(u32)];
 };
 
-#ifdef CONFIG_CRYPTO_DEV_ATMEL_AUTHENC
+#if IS_ENABLED(CONFIG_CRYPTO_DEV_ATMEL_AUTHENC)
 struct atmel_aes_authenc_ctx {
 	struct atmel_aes_base_ctx	base;
 	struct atmel_sha_authenc_ctx	*auth;
@@ -160,7 +160,7 @@ struct atmel_aes_reqctx {
 	u32			lastc[AES_BLOCK_SIZE / sizeof(u32)];
 };
 
-#ifdef CONFIG_CRYPTO_DEV_ATMEL_AUTHENC
+#if IS_ENABLED(CONFIG_CRYPTO_DEV_ATMEL_AUTHENC)
 struct atmel_aes_authenc_reqctx {
 	struct atmel_aes_reqctx	base;
 
@@ -489,7 +489,7 @@ static inline bool atmel_aes_is_encrypt(const struct atmel_aes_dev *dd)
 	return (dd->flags & AES_FLAGS_ENCRYPT);
 }
 
-#ifdef CONFIG_CRYPTO_DEV_ATMEL_AUTHENC
+#if IS_ENABLED(CONFIG_CRYPTO_DEV_ATMEL_AUTHENC)
 static void atmel_aes_authenc_complete(struct atmel_aes_dev *dd, int err);
 #endif
 
@@ -518,7 +518,7 @@ static void atmel_aes_set_iv_as_last_ciphertext_block(struct atmel_aes_dev *dd)
 
 static inline int atmel_aes_complete(struct atmel_aes_dev *dd, int err)
 {
-#ifdef CONFIG_CRYPTO_DEV_ATMEL_AUTHENC
+#if IS_ENABLED(CONFIG_CRYPTO_DEV_ATMEL_AUTHENC)
 	if (dd->ctx->is_aead)
 		atmel_aes_authenc_complete(dd, err);
 #endif
@@ -1983,7 +1983,7 @@ static struct crypto_alg aes_xts_alg = {
 	}
 };
 
-#ifdef CONFIG_CRYPTO_DEV_ATMEL_AUTHENC
+#if IS_ENABLED(CONFIG_CRYPTO_DEV_ATMEL_AUTHENC)
 /* authenc aead functions */
 
 static int atmel_aes_authenc_start(struct atmel_aes_dev *dd);
@@ -2470,7 +2470,7 @@ static void atmel_aes_unregister_algs(struct atmel_aes_dev *dd)
 {
 	int i;
 
-#ifdef CONFIG_CRYPTO_DEV_ATMEL_AUTHENC
+#if IS_ENABLED(CONFIG_CRYPTO_DEV_ATMEL_AUTHENC)
 	if (dd->caps.has_authenc)
 		for (i = 0; i < ARRAY_SIZE(aes_authenc_algs); i++)
 			crypto_unregister_aead(&aes_authenc_algs[i]);
@@ -2517,7 +2517,7 @@ static int atmel_aes_register_algs(struct atmel_aes_dev *dd)
 			goto err_aes_xts_alg;
 	}
 
-#ifdef CONFIG_CRYPTO_DEV_ATMEL_AUTHENC
+#if IS_ENABLED(CONFIG_CRYPTO_DEV_ATMEL_AUTHENC)
 	if (dd->caps.has_authenc) {
 		for (i = 0; i < ARRAY_SIZE(aes_authenc_algs); i++) {
 			err = crypto_register_aead(&aes_authenc_algs[i]);
@@ -2529,7 +2529,7 @@ static int atmel_aes_register_algs(struct atmel_aes_dev *dd)
 
 	return 0;
 
-#ifdef CONFIG_CRYPTO_DEV_ATMEL_AUTHENC
+#if IS_ENABLED(CONFIG_CRYPTO_DEV_ATMEL_AUTHENC)
 	/* i = ARRAY_SIZE(aes_authenc_algs); */
 err_aes_authenc_alg:
 	for (j = 0; j < i; j++)
@@ -2720,7 +2720,7 @@ static int atmel_aes_probe(struct platform_device *pdev)
 
 	atmel_aes_get_cap(aes_dd);
 
-#ifdef CONFIG_CRYPTO_DEV_ATMEL_AUTHENC
+#if IS_ENABLED(CONFIG_CRYPTO_DEV_ATMEL_AUTHENC)
 	if (aes_dd->caps.has_authenc && !atmel_sha_authenc_is_ready()) {
 		err = -EPROBE_DEFER;
 		goto iclk_unprepare;
diff --git a/drivers/crypto/atmel-authenc.h b/drivers/crypto/atmel-authenc.h
index 2a60d1224143..7f6742d35dd5 100644
--- a/drivers/crypto/atmel-authenc.h
+++ b/drivers/crypto/atmel-authenc.h
@@ -23,7 +23,7 @@
 #ifndef __ATMEL_AUTHENC_H__
 #define __ATMEL_AUTHENC_H__
 
-#ifdef CONFIG_CRYPTO_DEV_ATMEL_AUTHENC
+#if IS_ENABLED(CONFIG_CRYPTO_DEV_ATMEL_AUTHENC)
 
 #include <crypto/authenc.h>
 #include <crypto/hash.h>
diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
index 8a19df2fba6a..ef125d4be8fc 100644
--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -2215,7 +2215,7 @@ static struct ahash_alg sha_hmac_algs[] = {
 },
 };
 
-#ifdef CONFIG_CRYPTO_DEV_ATMEL_AUTHENC
+#if IS_ENABLED(CONFIG_CRYPTO_DEV_ATMEL_AUTHENC)
 /* authenc functions */
 
 static int atmel_sha_authenc_init2(struct atmel_sha_dev *dd);
-- 
2.20.1



