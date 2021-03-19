Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFD92341C99
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 13:22:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231453AbhCSMVs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 08:21:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:60248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231352AbhCSMVW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Mar 2021 08:21:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1CB6864F70;
        Fri, 19 Mar 2021 12:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616156481;
        bh=r/bVGHenP7XBqQv+m6bF6cw2Ci3EIukOx+aKQItQ/7A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=omkAoBdpl5TxhgwfLfPPUyC++hEQD1YnfpVmrzGHtdUCzlsg2px50FQIXKj/MNU8w
         osFr76iNr0aEuOUwLEj294dxdYIR/l+CzOwezfbJmSsQ6d2HQ6RvR+1xYW+39HrSQo
         Qs3veh9A1AMVOkAZ3nBJ7foy6RViVTRdsdhcde68=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@google.com>
Subject: [PATCH 5.11 31/31] crypto: x86/aes-ni-xts - use direct calls to and 4-way stride
Date:   Fri, 19 Mar 2021 13:19:25 +0100
Message-Id: <20210319121748.211622571@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210319121747.203523570@linuxfoundation.org>
References: <20210319121747.203523570@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

commit 86ad60a65f29dd862a11c22bb4b5be28d6c5cef1 upstream.

The XTS asm helper arrangement is a bit odd: the 8-way stride helper
consists of back-to-back calls to the 4-way core transforms, which
are called indirectly, based on a boolean that indicates whether we
are performing encryption or decryption.

Given how costly indirect calls are on x86, let's switch to direct
calls, and given how the 8-way stride doesn't really add anything
substantial, use a 4-way stride instead, and make the asm core
routine deal with any multiple of 4 blocks. Since 512 byte sectors
or 4 KB blocks are the typical quantities XTS operates on, increase
the stride exported to the glue helper to 512 bytes as well.

As a result, the number of indirect calls is reduced from 3 per 64 bytes
of in/output to 1 per 512 bytes of in/output, which produces a 65% speedup
when operating on 1 KB blocks (measured on a Intel(R) Core(TM) i7-8650U CPU)

Fixes: 9697fa39efd3f ("x86/retpoline/crypto: Convert crypto assembler indirect jumps")
Tested-by: Eric Biggers <ebiggers@google.com> # x86_64
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/crypto/aesni-intel_asm.S  |  115 ++++++++++++++++++++++---------------
 arch/x86/crypto/aesni-intel_glue.c |   25 ++++----
 2 files changed, 84 insertions(+), 56 deletions(-)

--- a/arch/x86/crypto/aesni-intel_asm.S
+++ b/arch/x86/crypto/aesni-intel_asm.S
@@ -2715,25 +2715,18 @@ SYM_FUNC_END(aesni_ctr_enc)
 	pxor CTR, IV;
 
 /*
- * void aesni_xts_crypt8(const struct crypto_aes_ctx *ctx, u8 *dst,
- *			 const u8 *src, bool enc, le128 *iv)
+ * void aesni_xts_encrypt(const struct crypto_aes_ctx *ctx, u8 *dst,
+ *			  const u8 *src, unsigned int len, le128 *iv)
  */
-SYM_FUNC_START(aesni_xts_crypt8)
+SYM_FUNC_START(aesni_xts_encrypt)
 	FRAME_BEGIN
-	testb %cl, %cl
-	movl $0, %ecx
-	movl $240, %r10d
-	leaq _aesni_enc4, %r11
-	leaq _aesni_dec4, %rax
-	cmovel %r10d, %ecx
-	cmoveq %rax, %r11
 
 	movdqa .Lgf128mul_x_ble_mask, GF128MUL_MASK
 	movups (IVP), IV
 
 	mov 480(KEYP), KLEN
-	addq %rcx, KEYP
 
+.Lxts_enc_loop4:
 	movdqa IV, STATE1
 	movdqu 0x00(INP), INC
 	pxor INC, STATE1
@@ -2757,71 +2750,103 @@ SYM_FUNC_START(aesni_xts_crypt8)
 	pxor INC, STATE4
 	movdqu IV, 0x30(OUTP)
 
-	CALL_NOSPEC r11
+	call _aesni_enc4
 
 	movdqu 0x00(OUTP), INC
 	pxor INC, STATE1
 	movdqu STATE1, 0x00(OUTP)
 
-	_aesni_gf128mul_x_ble()
-	movdqa IV, STATE1
-	movdqu 0x40(INP), INC
-	pxor INC, STATE1
-	movdqu IV, 0x40(OUTP)
-
 	movdqu 0x10(OUTP), INC
 	pxor INC, STATE2
 	movdqu STATE2, 0x10(OUTP)
 
-	_aesni_gf128mul_x_ble()
-	movdqa IV, STATE2
-	movdqu 0x50(INP), INC
-	pxor INC, STATE2
-	movdqu IV, 0x50(OUTP)
-
 	movdqu 0x20(OUTP), INC
 	pxor INC, STATE3
 	movdqu STATE3, 0x20(OUTP)
 
-	_aesni_gf128mul_x_ble()
-	movdqa IV, STATE3
-	movdqu 0x60(INP), INC
-	pxor INC, STATE3
-	movdqu IV, 0x60(OUTP)
-
 	movdqu 0x30(OUTP), INC
 	pxor INC, STATE4
 	movdqu STATE4, 0x30(OUTP)
 
 	_aesni_gf128mul_x_ble()
-	movdqa IV, STATE4
-	movdqu 0x70(INP), INC
-	pxor INC, STATE4
-	movdqu IV, 0x70(OUTP)
 
-	_aesni_gf128mul_x_ble()
+	add $64, INP
+	add $64, OUTP
+	sub $64, LEN
+	ja .Lxts_enc_loop4
+
 	movups IV, (IVP)
 
-	CALL_NOSPEC r11
+	FRAME_END
+	ret
+SYM_FUNC_END(aesni_xts_encrypt)
+
+/*
+ * void aesni_xts_decrypt(const struct crypto_aes_ctx *ctx, u8 *dst,
+ *			  const u8 *src, unsigned int len, le128 *iv)
+ */
+SYM_FUNC_START(aesni_xts_decrypt)
+	FRAME_BEGIN
+
+	movdqa .Lgf128mul_x_ble_mask, GF128MUL_MASK
+	movups (IVP), IV
+
+	mov 480(KEYP), KLEN
+	add $240, KEYP
+
+.Lxts_dec_loop4:
+	movdqa IV, STATE1
+	movdqu 0x00(INP), INC
+	pxor INC, STATE1
+	movdqu IV, 0x00(OUTP)
+
+	_aesni_gf128mul_x_ble()
+	movdqa IV, STATE2
+	movdqu 0x10(INP), INC
+	pxor INC, STATE2
+	movdqu IV, 0x10(OUTP)
+
+	_aesni_gf128mul_x_ble()
+	movdqa IV, STATE3
+	movdqu 0x20(INP), INC
+	pxor INC, STATE3
+	movdqu IV, 0x20(OUTP)
+
+	_aesni_gf128mul_x_ble()
+	movdqa IV, STATE4
+	movdqu 0x30(INP), INC
+	pxor INC, STATE4
+	movdqu IV, 0x30(OUTP)
+
+	call _aesni_dec4
 
-	movdqu 0x40(OUTP), INC
+	movdqu 0x00(OUTP), INC
 	pxor INC, STATE1
-	movdqu STATE1, 0x40(OUTP)
+	movdqu STATE1, 0x00(OUTP)
 
-	movdqu 0x50(OUTP), INC
+	movdqu 0x10(OUTP), INC
 	pxor INC, STATE2
-	movdqu STATE2, 0x50(OUTP)
+	movdqu STATE2, 0x10(OUTP)
 
-	movdqu 0x60(OUTP), INC
+	movdqu 0x20(OUTP), INC
 	pxor INC, STATE3
-	movdqu STATE3, 0x60(OUTP)
+	movdqu STATE3, 0x20(OUTP)
 
-	movdqu 0x70(OUTP), INC
+	movdqu 0x30(OUTP), INC
 	pxor INC, STATE4
-	movdqu STATE4, 0x70(OUTP)
+	movdqu STATE4, 0x30(OUTP)
+
+	_aesni_gf128mul_x_ble()
+
+	add $64, INP
+	add $64, OUTP
+	sub $64, LEN
+	ja .Lxts_dec_loop4
+
+	movups IV, (IVP)
 
 	FRAME_END
 	ret
-SYM_FUNC_END(aesni_xts_crypt8)
+SYM_FUNC_END(aesni_xts_decrypt)
 
 #endif
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -97,6 +97,12 @@ asmlinkage void aesni_cbc_dec(struct cry
 #define AVX_GEN2_OPTSIZE 640
 #define AVX_GEN4_OPTSIZE 4096
 
+asmlinkage void aesni_xts_encrypt(const struct crypto_aes_ctx *ctx, u8 *out,
+				  const u8 *in, unsigned int len, u8 *iv);
+
+asmlinkage void aesni_xts_decrypt(const struct crypto_aes_ctx *ctx, u8 *out,
+				  const u8 *in, unsigned int len, u8 *iv);
+
 #ifdef CONFIG_X86_64
 
 static void (*aesni_ctr_enc_tfm)(struct crypto_aes_ctx *ctx, u8 *out,
@@ -104,9 +110,6 @@ static void (*aesni_ctr_enc_tfm)(struct
 asmlinkage void aesni_ctr_enc(struct crypto_aes_ctx *ctx, u8 *out,
 			      const u8 *in, unsigned int len, u8 *iv);
 
-asmlinkage void aesni_xts_crypt8(const struct crypto_aes_ctx *ctx, u8 *out,
-				 const u8 *in, bool enc, le128 *iv);
-
 /* asmlinkage void aesni_gcm_enc()
  * void *ctx,  AES Key schedule. Starts on a 16 byte boundary.
  * struct gcm_context_data.  May be uninitialized.
@@ -547,14 +550,14 @@ static void aesni_xts_dec(const void *ct
 	glue_xts_crypt_128bit_one(ctx, dst, src, iv, aesni_dec);
 }
 
-static void aesni_xts_enc8(const void *ctx, u8 *dst, const u8 *src, le128 *iv)
+static void aesni_xts_enc32(const void *ctx, u8 *dst, const u8 *src, le128 *iv)
 {
-	aesni_xts_crypt8(ctx, dst, src, true, iv);
+	aesni_xts_encrypt(ctx, dst, src, 32 * AES_BLOCK_SIZE, (u8 *)iv);
 }
 
-static void aesni_xts_dec8(const void *ctx, u8 *dst, const u8 *src, le128 *iv)
+static void aesni_xts_dec32(const void *ctx, u8 *dst, const u8 *src, le128 *iv)
 {
-	aesni_xts_crypt8(ctx, dst, src, false, iv);
+	aesni_xts_decrypt(ctx, dst, src, 32 * AES_BLOCK_SIZE, (u8 *)iv);
 }
 
 static const struct common_glue_ctx aesni_enc_xts = {
@@ -562,8 +565,8 @@ static const struct common_glue_ctx aesn
 	.fpu_blocks_limit = 1,
 
 	.funcs = { {
-		.num_blocks = 8,
-		.fn_u = { .xts = aesni_xts_enc8 }
+		.num_blocks = 32,
+		.fn_u = { .xts = aesni_xts_enc32 }
 	}, {
 		.num_blocks = 1,
 		.fn_u = { .xts = aesni_xts_enc }
@@ -575,8 +578,8 @@ static const struct common_glue_ctx aesn
 	.fpu_blocks_limit = 1,
 
 	.funcs = { {
-		.num_blocks = 8,
-		.fn_u = { .xts = aesni_xts_dec8 }
+		.num_blocks = 32,
+		.fn_u = { .xts = aesni_xts_dec32 }
 	}, {
 		.num_blocks = 1,
 		.fn_u = { .xts = aesni_xts_dec }


