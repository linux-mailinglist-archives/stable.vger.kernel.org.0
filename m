Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A5892D85A0
	for <lists+stable@lfdr.de>; Sat, 12 Dec 2020 11:04:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438541AbgLLKDT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Dec 2020 05:03:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:58834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407230AbgLLJy2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 12 Dec 2020 04:54:28 -0500
From:   Ard Biesheuvel <ardb@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        stable@vger.kernel.org
Subject: [PATCH 1/4] crypto: x86/gcm-aes-ni - prevent misaligned IV buffers on the stack
Date:   Sat, 12 Dec 2020 10:16:57 +0100
Message-Id: <20201212091700.11776-2-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201212091700.11776-1-ardb@kernel.org>
References: <20201212091700.11776-1-ardb@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The GCM mode driver uses 16 byte aligned buffers on the stack to pass
the IV and other data to the asm helpers, but unfortunately, the x86
port does not guarantee that the stack pointer is 16 byte aligned upon
entry in the first place. Since the compiler is not aware of this, it
will not emit the additional stack realignment sequence that is needed,
and so the alignment is not guaranteed to be more than 8 bytes.

So instead, allocate some padding on the stack, and realign the IV and
data pointers by hand.

Cc: <stable@vger.kernel.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/crypto/aesni-intel_glue.c | 28 +++++++++++---------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index 8bfc2bbc877d..223670feaffa 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -803,7 +803,8 @@ static int gcmaes_crypt_by_sg(bool enc, struct aead_request *req,
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	unsigned long auth_tag_len = crypto_aead_authsize(tfm);
 	const struct aesni_gcm_tfm_s *gcm_tfm = aesni_gcm_tfm;
-	struct gcm_context_data data AESNI_ALIGN_ATTR;
+	u8 databuf[sizeof(struct gcm_context_data) + (AESNI_ALIGN - 8)] __aligned(8);
+	struct gcm_context_data *data = PTR_ALIGN((void *)databuf, AESNI_ALIGN);
 	struct scatter_walk dst_sg_walk = {};
 	unsigned long left = req->cryptlen;
 	unsigned long len, srclen, dstlen;
@@ -852,8 +853,7 @@ static int gcmaes_crypt_by_sg(bool enc, struct aead_request *req,
 	}
 
 	kernel_fpu_begin();
-	gcm_tfm->init(aes_ctx, &data, iv,
-		hash_subkey, assoc, assoclen);
+	gcm_tfm->init(aes_ctx, data, iv, hash_subkey, assoc, assoclen);
 	if (req->src != req->dst) {
 		while (left) {
 			src = scatterwalk_map(&src_sg_walk);
@@ -863,10 +863,10 @@ static int gcmaes_crypt_by_sg(bool enc, struct aead_request *req,
 			len = min(srclen, dstlen);
 			if (len) {
 				if (enc)
-					gcm_tfm->enc_update(aes_ctx, &data,
+					gcm_tfm->enc_update(aes_ctx, data,
 							     dst, src, len);
 				else
-					gcm_tfm->dec_update(aes_ctx, &data,
+					gcm_tfm->dec_update(aes_ctx, data,
 							     dst, src, len);
 			}
 			left -= len;
@@ -884,10 +884,10 @@ static int gcmaes_crypt_by_sg(bool enc, struct aead_request *req,
 			len = scatterwalk_clamp(&src_sg_walk, left);
 			if (len) {
 				if (enc)
-					gcm_tfm->enc_update(aes_ctx, &data,
+					gcm_tfm->enc_update(aes_ctx, data,
 							     src, src, len);
 				else
-					gcm_tfm->dec_update(aes_ctx, &data,
+					gcm_tfm->dec_update(aes_ctx, data,
 							     src, src, len);
 			}
 			left -= len;
@@ -896,7 +896,7 @@ static int gcmaes_crypt_by_sg(bool enc, struct aead_request *req,
 			scatterwalk_done(&src_sg_walk, 1, left);
 		}
 	}
-	gcm_tfm->finalize(aes_ctx, &data, authTag, auth_tag_len);
+	gcm_tfm->finalize(aes_ctx, data, authTag, auth_tag_len);
 	kernel_fpu_end();
 
 	if (!assocmem)
@@ -945,7 +945,8 @@ static int helper_rfc4106_encrypt(struct aead_request *req)
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	struct aesni_rfc4106_gcm_ctx *ctx = aesni_rfc4106_gcm_ctx_get(tfm);
 	void *aes_ctx = &(ctx->aes_key_expanded);
-	u8 iv[16] __attribute__ ((__aligned__(AESNI_ALIGN)));
+	u8 ivbuf[16 + (AESNI_ALIGN - 8)] __aligned(8);
+	u8 *iv = PTR_ALIGN(&ivbuf[0], AESNI_ALIGN);
 	unsigned int i;
 	__be32 counter = cpu_to_be32(1);
 
@@ -972,7 +973,8 @@ static int helper_rfc4106_decrypt(struct aead_request *req)
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	struct aesni_rfc4106_gcm_ctx *ctx = aesni_rfc4106_gcm_ctx_get(tfm);
 	void *aes_ctx = &(ctx->aes_key_expanded);
-	u8 iv[16] __attribute__ ((__aligned__(AESNI_ALIGN)));
+	u8 ivbuf[16 + (AESNI_ALIGN - 8)] __aligned(8);
+	u8 *iv = PTR_ALIGN(&ivbuf[0], AESNI_ALIGN);
 	unsigned int i;
 
 	if (unlikely(req->assoclen != 16 && req->assoclen != 20))
@@ -1119,7 +1121,8 @@ static int generic_gcmaes_encrypt(struct aead_request *req)
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	struct generic_gcmaes_ctx *ctx = generic_gcmaes_ctx_get(tfm);
 	void *aes_ctx = &(ctx->aes_key_expanded);
-	u8 iv[16] __attribute__ ((__aligned__(AESNI_ALIGN)));
+	u8 ivbuf[16 + (AESNI_ALIGN - 8)] __aligned(8);
+	u8 *iv = PTR_ALIGN(&ivbuf[0], AESNI_ALIGN);
 	__be32 counter = cpu_to_be32(1);
 
 	memcpy(iv, req->iv, 12);
@@ -1135,7 +1138,8 @@ static int generic_gcmaes_decrypt(struct aead_request *req)
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	struct generic_gcmaes_ctx *ctx = generic_gcmaes_ctx_get(tfm);
 	void *aes_ctx = &(ctx->aes_key_expanded);
-	u8 iv[16] __attribute__ ((__aligned__(AESNI_ALIGN)));
+	u8 ivbuf[16 + (AESNI_ALIGN - 8)] __aligned(8);
+	u8 *iv = PTR_ALIGN(&ivbuf[0], AESNI_ALIGN);
 
 	memcpy(iv, req->iv, 12);
 	*((__be32 *)(iv+12)) = counter;
-- 
2.17.1

