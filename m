Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DB5F119861
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:39:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730163AbfLJVfD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:35:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:40546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730159AbfLJVfC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:35:02 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5CB9A2465A;
        Tue, 10 Dec 2019 21:35:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576013702;
        bh=KBWIotveJbh6YphD+kZjOybEOo+u4bqZz69XmnGL6ew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=StbrdHMGG8VZTwEK6qaaRkPmMSwpw/bKCkUvUqmkWO1VMZ+1jlgzRvNahKhENcY9C
         KGsPMP3YUiKayfAcBkjbptqeaOfkVc9dTKP9ggN1fsK8/yYF3K2PPwNgwvXn6+ak6b
         /2XaS9gbfq5NRJQn4tBj9N5OipoK7EnnQsXtNqjI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 131/177] crypto: atmel - Fix authenc support when it is set to m
Date:   Tue, 10 Dec 2019 16:31:35 -0500
Message-Id: <20191210213221.11921-131-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210213221.11921-1-sashal@kernel.org>
References: <20191210213221.11921-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 801aeab5ab1e6..e659c3d9c2e4f 100644
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
 
@@ -489,13 +489,13 @@ static inline bool atmel_aes_is_encrypt(const struct atmel_aes_dev *dd)
 	return (dd->flags & AES_FLAGS_ENCRYPT);
 }
 
-#ifdef CONFIG_CRYPTO_DEV_ATMEL_AUTHENC
+#if IS_ENABLED(CONFIG_CRYPTO_DEV_ATMEL_AUTHENC)
 static void atmel_aes_authenc_complete(struct atmel_aes_dev *dd, int err);
 #endif
 
 static inline int atmel_aes_complete(struct atmel_aes_dev *dd, int err)
 {
-#ifdef CONFIG_CRYPTO_DEV_ATMEL_AUTHENC
+#if IS_ENABLED(CONFIG_CRYPTO_DEV_ATMEL_AUTHENC)
 	if (dd->ctx->is_aead)
 		atmel_aes_authenc_complete(dd, err);
 #endif
@@ -1976,7 +1976,7 @@ static struct crypto_alg aes_xts_alg = {
 	}
 };
 
-#ifdef CONFIG_CRYPTO_DEV_ATMEL_AUTHENC
+#if IS_ENABLED(CONFIG_CRYPTO_DEV_ATMEL_AUTHENC)
 /* authenc aead functions */
 
 static int atmel_aes_authenc_start(struct atmel_aes_dev *dd);
@@ -2463,7 +2463,7 @@ static void atmel_aes_unregister_algs(struct atmel_aes_dev *dd)
 {
 	int i;
 
-#ifdef CONFIG_CRYPTO_DEV_ATMEL_AUTHENC
+#if IS_ENABLED(CONFIG_CRYPTO_DEV_ATMEL_AUTHENC)
 	if (dd->caps.has_authenc)
 		for (i = 0; i < ARRAY_SIZE(aes_authenc_algs); i++)
 			crypto_unregister_aead(&aes_authenc_algs[i]);
@@ -2510,7 +2510,7 @@ static int atmel_aes_register_algs(struct atmel_aes_dev *dd)
 			goto err_aes_xts_alg;
 	}
 
-#ifdef CONFIG_CRYPTO_DEV_ATMEL_AUTHENC
+#if IS_ENABLED(CONFIG_CRYPTO_DEV_ATMEL_AUTHENC)
 	if (dd->caps.has_authenc) {
 		for (i = 0; i < ARRAY_SIZE(aes_authenc_algs); i++) {
 			err = crypto_register_aead(&aes_authenc_algs[i]);
@@ -2522,7 +2522,7 @@ static int atmel_aes_register_algs(struct atmel_aes_dev *dd)
 
 	return 0;
 
-#ifdef CONFIG_CRYPTO_DEV_ATMEL_AUTHENC
+#if IS_ENABLED(CONFIG_CRYPTO_DEV_ATMEL_AUTHENC)
 	/* i = ARRAY_SIZE(aes_authenc_algs); */
 err_aes_authenc_alg:
 	for (j = 0; j < i; j++)
@@ -2713,7 +2713,7 @@ static int atmel_aes_probe(struct platform_device *pdev)
 
 	atmel_aes_get_cap(aes_dd);
 
-#ifdef CONFIG_CRYPTO_DEV_ATMEL_AUTHENC
+#if IS_ENABLED(CONFIG_CRYPTO_DEV_ATMEL_AUTHENC)
 	if (aes_dd->caps.has_authenc && !atmel_sha_authenc_is_ready()) {
 		err = -EPROBE_DEFER;
 		goto iclk_unprepare;
diff --git a/drivers/crypto/atmel-authenc.h b/drivers/crypto/atmel-authenc.h
index 2a60d1224143a..7f6742d35dd5a 100644
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
index 8a19df2fba6a3..ef125d4be8fc4 100644
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

