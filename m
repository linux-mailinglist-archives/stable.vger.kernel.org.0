Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C792012C72A
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:55:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732719AbfL2Ryf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:54:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:42564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732716AbfL2Ryf (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:54:35 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 29BCE21744;
        Sun, 29 Dec 2019 17:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577642074;
        bh=987a2c0lwekyvqx+mWEoY/ULcA9NIGxcTr8tGTB/pq8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QTtTGIEi5tZD70IqXWaS+lyQld8iGWvWnnhZsNmm1MozjindSjcXfrJBu5Tq3s3rs
         W3gmDR8vHkJBtA7KW6NMoZx7ji+xvMajR65wOHy9GrRIJGOf17VELp4lCYnzGLhf7+
         sWkJ/vDq9B4V4SeDIfRQCz+5tbolaoixCD4+W8vw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 278/434] crypto: atmel - Fix authenc support when it is set to m
Date:   Sun, 29 Dec 2019 18:25:31 +0100
Message-Id: <20191229172720.408858302@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
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
index 00920a2b95ce..db99cee1991c 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -145,7 +145,7 @@ struct atmel_aes_xts_ctx {
 	u32			key2[AES_KEYSIZE_256 / sizeof(u32)];
 };
 
-#ifdef CONFIG_CRYPTO_DEV_ATMEL_AUTHENC
+#if IS_ENABLED(CONFIG_CRYPTO_DEV_ATMEL_AUTHENC)
 struct atmel_aes_authenc_ctx {
 	struct atmel_aes_base_ctx	base;
 	struct atmel_sha_authenc_ctx	*auth;
@@ -157,7 +157,7 @@ struct atmel_aes_reqctx {
 	u32			lastc[AES_BLOCK_SIZE / sizeof(u32)];
 };
 
-#ifdef CONFIG_CRYPTO_DEV_ATMEL_AUTHENC
+#if IS_ENABLED(CONFIG_CRYPTO_DEV_ATMEL_AUTHENC)
 struct atmel_aes_authenc_reqctx {
 	struct atmel_aes_reqctx	base;
 
@@ -486,7 +486,7 @@ static inline bool atmel_aes_is_encrypt(const struct atmel_aes_dev *dd)
 	return (dd->flags & AES_FLAGS_ENCRYPT);
 }
 
-#ifdef CONFIG_CRYPTO_DEV_ATMEL_AUTHENC
+#if IS_ENABLED(CONFIG_CRYPTO_DEV_ATMEL_AUTHENC)
 static void atmel_aes_authenc_complete(struct atmel_aes_dev *dd, int err);
 #endif
 
@@ -515,7 +515,7 @@ static void atmel_aes_set_iv_as_last_ciphertext_block(struct atmel_aes_dev *dd)
 
 static inline int atmel_aes_complete(struct atmel_aes_dev *dd, int err)
 {
-#ifdef CONFIG_CRYPTO_DEV_ATMEL_AUTHENC
+#if IS_ENABLED(CONFIG_CRYPTO_DEV_ATMEL_AUTHENC)
 	if (dd->ctx->is_aead)
 		atmel_aes_authenc_complete(dd, err);
 #endif
@@ -1980,7 +1980,7 @@ static struct crypto_alg aes_xts_alg = {
 	}
 };
 
-#ifdef CONFIG_CRYPTO_DEV_ATMEL_AUTHENC
+#if IS_ENABLED(CONFIG_CRYPTO_DEV_ATMEL_AUTHENC)
 /* authenc aead functions */
 
 static int atmel_aes_authenc_start(struct atmel_aes_dev *dd);
@@ -2467,7 +2467,7 @@ static void atmel_aes_unregister_algs(struct atmel_aes_dev *dd)
 {
 	int i;
 
-#ifdef CONFIG_CRYPTO_DEV_ATMEL_AUTHENC
+#if IS_ENABLED(CONFIG_CRYPTO_DEV_ATMEL_AUTHENC)
 	if (dd->caps.has_authenc)
 		for (i = 0; i < ARRAY_SIZE(aes_authenc_algs); i++)
 			crypto_unregister_aead(&aes_authenc_algs[i]);
@@ -2514,7 +2514,7 @@ static int atmel_aes_register_algs(struct atmel_aes_dev *dd)
 			goto err_aes_xts_alg;
 	}
 
-#ifdef CONFIG_CRYPTO_DEV_ATMEL_AUTHENC
+#if IS_ENABLED(CONFIG_CRYPTO_DEV_ATMEL_AUTHENC)
 	if (dd->caps.has_authenc) {
 		for (i = 0; i < ARRAY_SIZE(aes_authenc_algs); i++) {
 			err = crypto_register_aead(&aes_authenc_algs[i]);
@@ -2526,7 +2526,7 @@ static int atmel_aes_register_algs(struct atmel_aes_dev *dd)
 
 	return 0;
 
-#ifdef CONFIG_CRYPTO_DEV_ATMEL_AUTHENC
+#if IS_ENABLED(CONFIG_CRYPTO_DEV_ATMEL_AUTHENC)
 	/* i = ARRAY_SIZE(aes_authenc_algs); */
 err_aes_authenc_alg:
 	for (j = 0; j < i; j++)
@@ -2716,7 +2716,7 @@ static int atmel_aes_probe(struct platform_device *pdev)
 
 	atmel_aes_get_cap(aes_dd);
 
-#ifdef CONFIG_CRYPTO_DEV_ATMEL_AUTHENC
+#if IS_ENABLED(CONFIG_CRYPTO_DEV_ATMEL_AUTHENC)
 	if (aes_dd->caps.has_authenc && !atmel_sha_authenc_is_ready()) {
 		err = -EPROBE_DEFER;
 		goto iclk_unprepare;
diff --git a/drivers/crypto/atmel-authenc.h b/drivers/crypto/atmel-authenc.h
index cbd37a2edada..d6de810df44f 100644
--- a/drivers/crypto/atmel-authenc.h
+++ b/drivers/crypto/atmel-authenc.h
@@ -12,7 +12,7 @@
 #ifndef __ATMEL_AUTHENC_H__
 #define __ATMEL_AUTHENC_H__
 
-#ifdef CONFIG_CRYPTO_DEV_ATMEL_AUTHENC
+#if IS_ENABLED(CONFIG_CRYPTO_DEV_ATMEL_AUTHENC)
 
 #include <crypto/authenc.h>
 #include <crypto/hash.h>
diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
index 84cb8748a795..d32626458e67 100644
--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -2212,7 +2212,7 @@ static struct ahash_alg sha_hmac_algs[] = {
 },
 };
 
-#ifdef CONFIG_CRYPTO_DEV_ATMEL_AUTHENC
+#if IS_ENABLED(CONFIG_CRYPTO_DEV_ATMEL_AUTHENC)
 /* authenc functions */
 
 static int atmel_sha_authenc_init2(struct atmel_sha_dev *dd);
-- 
2.20.1



