Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9304A7456E
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 07:42:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390867AbfGYFme (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 01:42:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:57488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390887AbfGYFmd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jul 2019 01:42:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5BDF521880;
        Thu, 25 Jul 2019 05:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564033352;
        bh=YqGJ0BX4iLvQallmPfEFrfLOKKycy36qzETEF5cw9g0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eNJ8e8bYv4BEJ98xQsBaU59y1lGt02CG5g/w9s33+NgKgH9yJxUb58Hdp1cC5I9xb
         SwH7vFfeJH8KKOeOcsrQih/5r/XxtMZS+0M5Lxm3GEwD9AmlUpuuHDumNP62LZrM39
         98N9iGmpyvjw23N+jfLCeU9CfGkriHWxuao8nnWc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@kernel.org>,
        Christian Lamparter <chunkeey@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4.19 179/271] crypto: crypto4xx - block ciphers should only accept complete blocks
Date:   Wed, 24 Jul 2019 21:20:48 +0200
Message-Id: <20190724191710.485598091@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191655.268628197@linuxfoundation.org>
References: <20190724191655.268628197@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Lamparter <chunkeey@gmail.com>

commit 0f7a81374060828280fcfdfbaa162cb559017f9f upstream.

The hardware automatically zero pads incomplete block ciphers
blocks without raising any errors. This is a screw-up. This
was noticed by CONFIG_CRYPTO_MANAGER_EXTRA_TESTS tests that
sent a incomplete blocks and expect them to fail.

This fixes:
cbc-aes-ppc4xx encryption unexpectedly succeeded on test vector
"random: len=2409 klen=32"; expected_error=-22, cfg="random:
may_sleep use_digest src_divs=[96.90%@+2295, 2.34%@+4066,
0.32%@alignmask+12, 0.34%@+4087, 0.9%@alignmask+1787, 0.1%@+3767]
iv_offset=6"

ecb-aes-ppc4xx encryption unexpectedly succeeded on test vector
"random: len=1011 klen=32"; expected_error=-22, cfg="random:
may_sleep use_digest src_divs=[100.0%@alignmask+20]
dst_divs=[3.12%@+3001, 96.88%@+4070]"

Cc: Eric Biggers <ebiggers@kernel.org>
Cc: stable@vger.kernel.org [4.19, 5.0 and 5.1]
Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/amcc/crypto4xx_alg.c  |   36 ++++++++++++++++++++++++-----------
 drivers/crypto/amcc/crypto4xx_core.c |   16 +++++++--------
 drivers/crypto/amcc/crypto4xx_core.h |   10 +++++----
 3 files changed, 39 insertions(+), 23 deletions(-)

--- a/drivers/crypto/amcc/crypto4xx_alg.c
+++ b/drivers/crypto/amcc/crypto4xx_alg.c
@@ -76,12 +76,16 @@ static void set_dynamic_sa_command_1(str
 }
 
 static inline int crypto4xx_crypt(struct skcipher_request *req,
-				  const unsigned int ivlen, bool decrypt)
+				  const unsigned int ivlen, bool decrypt,
+				  bool check_blocksize)
 {
 	struct crypto_skcipher *cipher = crypto_skcipher_reqtfm(req);
 	struct crypto4xx_ctx *ctx = crypto_skcipher_ctx(cipher);
 	__le32 iv[AES_IV_SIZE];
 
+	if (check_blocksize && !IS_ALIGNED(req->cryptlen, AES_BLOCK_SIZE))
+		return -EINVAL;
+
 	if (ivlen)
 		crypto4xx_memcpy_to_le32(iv, req->iv, ivlen);
 
@@ -90,24 +94,34 @@ static inline int crypto4xx_crypt(struct
 		ctx->sa_len, 0, NULL);
 }
 
-int crypto4xx_encrypt_noiv(struct skcipher_request *req)
+int crypto4xx_encrypt_noiv_block(struct skcipher_request *req)
+{
+	return crypto4xx_crypt(req, 0, false, true);
+}
+
+int crypto4xx_encrypt_iv_stream(struct skcipher_request *req)
+{
+	return crypto4xx_crypt(req, AES_IV_SIZE, false, false);
+}
+
+int crypto4xx_decrypt_noiv_block(struct skcipher_request *req)
 {
-	return crypto4xx_crypt(req, 0, false);
+	return crypto4xx_crypt(req, 0, true, true);
 }
 
-int crypto4xx_encrypt_iv(struct skcipher_request *req)
+int crypto4xx_decrypt_iv_stream(struct skcipher_request *req)
 {
-	return crypto4xx_crypt(req, AES_IV_SIZE, false);
+	return crypto4xx_crypt(req, AES_IV_SIZE, true, false);
 }
 
-int crypto4xx_decrypt_noiv(struct skcipher_request *req)
+int crypto4xx_encrypt_iv_block(struct skcipher_request *req)
 {
-	return crypto4xx_crypt(req, 0, true);
+	return crypto4xx_crypt(req, AES_IV_SIZE, false, true);
 }
 
-int crypto4xx_decrypt_iv(struct skcipher_request *req)
+int crypto4xx_decrypt_iv_block(struct skcipher_request *req)
 {
-	return crypto4xx_crypt(req, AES_IV_SIZE, true);
+	return crypto4xx_crypt(req, AES_IV_SIZE, true, true);
 }
 
 /**
@@ -278,8 +292,8 @@ crypto4xx_ctr_crypt(struct skcipher_requ
 		return ret;
 	}
 
-	return encrypt ? crypto4xx_encrypt_iv(req)
-		       : crypto4xx_decrypt_iv(req);
+	return encrypt ? crypto4xx_encrypt_iv_stream(req)
+		       : crypto4xx_decrypt_iv_stream(req);
 }
 
 static int crypto4xx_sk_setup_fallback(struct crypto4xx_ctx *ctx,
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -1153,8 +1153,8 @@ static struct crypto4xx_alg_common crypt
 		.max_keysize = AES_MAX_KEY_SIZE,
 		.ivsize	= AES_IV_SIZE,
 		.setkey = crypto4xx_setkey_aes_cbc,
-		.encrypt = crypto4xx_encrypt_iv,
-		.decrypt = crypto4xx_decrypt_iv,
+		.encrypt = crypto4xx_encrypt_iv_block,
+		.decrypt = crypto4xx_decrypt_iv_block,
 		.init = crypto4xx_sk_init,
 		.exit = crypto4xx_sk_exit,
 	} },
@@ -1173,8 +1173,8 @@ static struct crypto4xx_alg_common crypt
 		.max_keysize = AES_MAX_KEY_SIZE,
 		.ivsize	= AES_IV_SIZE,
 		.setkey	= crypto4xx_setkey_aes_cfb,
-		.encrypt = crypto4xx_encrypt_iv,
-		.decrypt = crypto4xx_decrypt_iv,
+		.encrypt = crypto4xx_encrypt_iv_stream,
+		.decrypt = crypto4xx_decrypt_iv_stream,
 		.init = crypto4xx_sk_init,
 		.exit = crypto4xx_sk_exit,
 	} },
@@ -1233,8 +1233,8 @@ static struct crypto4xx_alg_common crypt
 		.min_keysize = AES_MIN_KEY_SIZE,
 		.max_keysize = AES_MAX_KEY_SIZE,
 		.setkey	= crypto4xx_setkey_aes_ecb,
-		.encrypt = crypto4xx_encrypt_noiv,
-		.decrypt = crypto4xx_decrypt_noiv,
+		.encrypt = crypto4xx_encrypt_noiv_block,
+		.decrypt = crypto4xx_decrypt_noiv_block,
 		.init = crypto4xx_sk_init,
 		.exit = crypto4xx_sk_exit,
 	} },
@@ -1253,8 +1253,8 @@ static struct crypto4xx_alg_common crypt
 		.max_keysize = AES_MAX_KEY_SIZE,
 		.ivsize	= AES_IV_SIZE,
 		.setkey	= crypto4xx_setkey_aes_ofb,
-		.encrypt = crypto4xx_encrypt_iv,
-		.decrypt = crypto4xx_decrypt_iv,
+		.encrypt = crypto4xx_encrypt_iv_stream,
+		.decrypt = crypto4xx_decrypt_iv_stream,
 		.init = crypto4xx_sk_init,
 		.exit = crypto4xx_sk_exit,
 	} },
--- a/drivers/crypto/amcc/crypto4xx_core.h
+++ b/drivers/crypto/amcc/crypto4xx_core.h
@@ -179,10 +179,12 @@ int crypto4xx_setkey_rfc3686(struct cryp
 			     const u8 *key, unsigned int keylen);
 int crypto4xx_encrypt_ctr(struct skcipher_request *req);
 int crypto4xx_decrypt_ctr(struct skcipher_request *req);
-int crypto4xx_encrypt_iv(struct skcipher_request *req);
-int crypto4xx_decrypt_iv(struct skcipher_request *req);
-int crypto4xx_encrypt_noiv(struct skcipher_request *req);
-int crypto4xx_decrypt_noiv(struct skcipher_request *req);
+int crypto4xx_encrypt_iv_stream(struct skcipher_request *req);
+int crypto4xx_decrypt_iv_stream(struct skcipher_request *req);
+int crypto4xx_encrypt_iv_block(struct skcipher_request *req);
+int crypto4xx_decrypt_iv_block(struct skcipher_request *req);
+int crypto4xx_encrypt_noiv_block(struct skcipher_request *req);
+int crypto4xx_decrypt_noiv_block(struct skcipher_request *req);
 int crypto4xx_rfc3686_encrypt(struct skcipher_request *req);
 int crypto4xx_rfc3686_decrypt(struct skcipher_request *req);
 int crypto4xx_sha1_alg_init(struct crypto_tfm *tfm);


