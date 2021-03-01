Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 166803289B5
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:03:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239211AbhCASDb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:03:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:52490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237577AbhCAR4t (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:56:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3439C65253;
        Mon,  1 Mar 2021 17:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619683;
        bh=IcTdTKUdRz82ut84jVSWQPuXkYg+kRy4McALB7/uNfU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a5ZVgaGKDHntvlCeW6C1WHW/fDdh2PdCKpqistL6vOWdYcAWqRreL5+ptNonjNH0o
         auFWnXl9FGVL9hKsJwogn2MzOHCcOEJRbTaFVg5P0ZBuvnbo2OFWXqFkITKBk6vlQK
         TSHKX+Pzfou8qBbJ5Cbt52mavCx+9nX5Ar92m87A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.10 543/663] crypto: aesni - prevent misaligned buffers on the stack
Date:   Mon,  1 Mar 2021 17:13:11 +0100
Message-Id: <20210301161208.736501888@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

commit a13ed1d15b07a04b1f74b2df61ff7a5e47f45dd8 upstream.

The GCM mode driver uses 16 byte aligned buffers on the stack to pass
the IV to the asm helpers, but unfortunately, the x86 port does not
guarantee that the stack pointer is 16 byte aligned upon entry in the
first place. Since the compiler is not aware of this, it will not emit
the additional stack realignment sequence that is needed, and so the
alignment is not guaranteed to be more than 8 bytes.

So instead, allocate some padding on the stack, and realign the IV
pointer by hand.

Cc: <stable@vger.kernel.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/crypto/aesni-intel_glue.c |   28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -686,7 +686,8 @@ static int gcmaes_crypt_by_sg(bool enc,
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	unsigned long auth_tag_len = crypto_aead_authsize(tfm);
 	const struct aesni_gcm_tfm_s *gcm_tfm = aesni_gcm_tfm;
-	struct gcm_context_data data AESNI_ALIGN_ATTR;
+	u8 databuf[sizeof(struct gcm_context_data) + (AESNI_ALIGN - 8)] __aligned(8);
+	struct gcm_context_data *data = PTR_ALIGN((void *)databuf, AESNI_ALIGN);
 	struct scatter_walk dst_sg_walk = {};
 	unsigned long left = req->cryptlen;
 	unsigned long len, srclen, dstlen;
@@ -735,8 +736,7 @@ static int gcmaes_crypt_by_sg(bool enc,
 	}
 
 	kernel_fpu_begin();
-	gcm_tfm->init(aes_ctx, &data, iv,
-		hash_subkey, assoc, assoclen);
+	gcm_tfm->init(aes_ctx, data, iv, hash_subkey, assoc, assoclen);
 	if (req->src != req->dst) {
 		while (left) {
 			src = scatterwalk_map(&src_sg_walk);
@@ -746,10 +746,10 @@ static int gcmaes_crypt_by_sg(bool enc,
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
@@ -767,10 +767,10 @@ static int gcmaes_crypt_by_sg(bool enc,
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
@@ -779,7 +779,7 @@ static int gcmaes_crypt_by_sg(bool enc,
 			scatterwalk_done(&src_sg_walk, 1, left);
 		}
 	}
-	gcm_tfm->finalize(aes_ctx, &data, authTag, auth_tag_len);
+	gcm_tfm->finalize(aes_ctx, data, authTag, auth_tag_len);
 	kernel_fpu_end();
 
 	if (!assocmem)
@@ -828,7 +828,8 @@ static int helper_rfc4106_encrypt(struct
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	struct aesni_rfc4106_gcm_ctx *ctx = aesni_rfc4106_gcm_ctx_get(tfm);
 	void *aes_ctx = &(ctx->aes_key_expanded);
-	u8 iv[16] __attribute__ ((__aligned__(AESNI_ALIGN)));
+	u8 ivbuf[16 + (AESNI_ALIGN - 8)] __aligned(8);
+	u8 *iv = PTR_ALIGN(&ivbuf[0], AESNI_ALIGN);
 	unsigned int i;
 	__be32 counter = cpu_to_be32(1);
 
@@ -855,7 +856,8 @@ static int helper_rfc4106_decrypt(struct
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	struct aesni_rfc4106_gcm_ctx *ctx = aesni_rfc4106_gcm_ctx_get(tfm);
 	void *aes_ctx = &(ctx->aes_key_expanded);
-	u8 iv[16] __attribute__ ((__aligned__(AESNI_ALIGN)));
+	u8 ivbuf[16 + (AESNI_ALIGN - 8)] __aligned(8);
+	u8 *iv = PTR_ALIGN(&ivbuf[0], AESNI_ALIGN);
 	unsigned int i;
 
 	if (unlikely(req->assoclen != 16 && req->assoclen != 20))
@@ -985,7 +987,8 @@ static int generic_gcmaes_encrypt(struct
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	struct generic_gcmaes_ctx *ctx = generic_gcmaes_ctx_get(tfm);
 	void *aes_ctx = &(ctx->aes_key_expanded);
-	u8 iv[16] __attribute__ ((__aligned__(AESNI_ALIGN)));
+	u8 ivbuf[16 + (AESNI_ALIGN - 8)] __aligned(8);
+	u8 *iv = PTR_ALIGN(&ivbuf[0], AESNI_ALIGN);
 	__be32 counter = cpu_to_be32(1);
 
 	memcpy(iv, req->iv, 12);
@@ -1001,7 +1004,8 @@ static int generic_gcmaes_decrypt(struct
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	struct generic_gcmaes_ctx *ctx = generic_gcmaes_ctx_get(tfm);
 	void *aes_ctx = &(ctx->aes_key_expanded);
-	u8 iv[16] __attribute__ ((__aligned__(AESNI_ALIGN)));
+	u8 ivbuf[16 + (AESNI_ALIGN - 8)] __aligned(8);
+	u8 *iv = PTR_ALIGN(&ivbuf[0], AESNI_ALIGN);
 
 	memcpy(iv, req->iv, 12);
 	*((__be32 *)(iv+12)) = counter;


