Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A249340C03
	for <lists+stable@lfdr.de>; Thu, 18 Mar 2021 18:42:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbhCRRmT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Mar 2021 13:42:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230442AbhCRRl6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Mar 2021 13:41:58 -0400
Received: from mail-wr1-x449.google.com (mail-wr1-x449.google.com [IPv6:2a00:1450:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F98EC06175F
        for <stable@vger.kernel.org>; Thu, 18 Mar 2021 10:41:58 -0700 (PDT)
Received: by mail-wr1-x449.google.com with SMTP id p15so20266792wre.13
        for <stable@vger.kernel.org>; Thu, 18 Mar 2021 10:41:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=ntc30WV4GSBivpKXAO0fv9xRX/AwV5t/Z4pOy4QLsWI=;
        b=KYtRYvcj2Cxv3+iUqa5Sz3mmqq6AOQvslOqGQXKVPTOKmmyb+2hIbHioq0Nr9FdMal
         mLrLr6F4j3PYCduhOvyZ35fzJnnwv5iEmmkMr73FZWV06P10PUu8rQ6GSSQLynh0wPkG
         7/I+aUsH1r2UeU0K8YP9hNg7Mui2hg8iNGm7pCYllyaFQgQvR4vnayDF+KW4px5DQK1L
         IYpIKjcow6RgOSvOgPkEeDyX6r7rJKfp8TwuCxEsBWtr652+pnoqydK52207d4lpDkjI
         1XPXswXwubD1tBSoTad7bH4+Dv3orpsNfcjTT0JR0Nfd+B5fX//U41ZbjwOy5rxX3D+3
         VJ+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=ntc30WV4GSBivpKXAO0fv9xRX/AwV5t/Z4pOy4QLsWI=;
        b=lSiWvY2xY3xriXrJaBP7vwz5TCaB3IbfrOpeOycefjNobleulDEsmfCQ0LRbdXnnft
         EH0TorD8UlNwBh8g4YFGMkf6o8vUOnnEiDxERBzyNFbc5qqjpPK7Mt36J9rk32CsLRkZ
         4tAIeHTBk1Gw/oEnGW/oIHK/zweV5ePjzE85bfdYcpJ+HEO5lCcuelTzN3XYyUjkP2eG
         6g0VknvrRX7nuOCrS4wAjdCebvq+C3naTB6mcWJwYVaeGNpLAqpPkFk+OIpGumXmo5NV
         NeO7VBqqNpQQoqqbuetUL46vHYQbO020QChkE8XPcZtq4bw0qASyqLZkh0WQTDNilg5+
         3cdQ==
X-Gm-Message-State: AOAM5332jHec2XTFHtO/u8r3zByMfbtt1dmfw1FNDWpkGjQ95OT29nQv
        PGyBo/S6MuHyj8KHjltSW4GqrjuO/81kim/dTy65nNmnglvjCso4sP2GwH6kLYZzZTkoQpPU/0D
        xbyxc7yxDaZMVsQl1CUhEEM+sDvx774QvKbJeN1QnHZbWv9XGsLuZQX0n
X-Google-Smtp-Source: ABdhPJx5rKkvaKRfg/4ogkG9nqQ337eo80EUEkVXr/atS4jsc38hUerjTVFL3Ez4vSXacsmeD/uhrIfP
X-Received: from palermo.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:118a])
 (user=ardb job=sendgmr) by 2002:a05:600c:3650:: with SMTP id
 y16mr291597wmq.182.1616089315378; Thu, 18 Mar 2021 10:41:55 -0700 (PDT)
Date:   Thu, 18 Mar 2021 17:41:51 +0000
Message-Id: <20210318174151.2164335-1-ardb@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
Subject: [PATCH for-stable-5.4] crypto: x86/aes-ni-xts - use direct calls to
 and 4-way stride
From:   Ard Biesheuvel <ardb@google.com>
To:     stable@vger.kernel.org
Cc:     linux-crypto@vger.kernel.org, tmb@tmb.nu, sashal@kernel.org,
        Ard Biesheuvel <ardb@kernel.org>,
        Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

Upstream commit 86ad60a65f29dd862a11c22bb4b5be28d6c5cef1

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
[ardb: rebase onto stable/linux-5.4.y]
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---

Please apply on top of backports of

9c1e8836edbb crypto: x86 - Regularize glue function prototypes
032d049ea0f4 crypto: aesni - Use TEST %reg,%reg instead of CMP $0,%reg

 arch/x86/crypto/aesni-intel_asm.S  | 115 ++++++++++++++++++-----------
 arch/x86/crypto/aesni-intel_glue.c |  25 ++++---
 2 files changed, 84 insertions(+), 56 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_asm.S b/arch/x86/crypto/aesni-intel_asm.S
index f10f044c887c..dd954d8db629 100644
--- a/arch/x86/crypto/aesni-intel_asm.S
+++ b/arch/x86/crypto/aesni-intel_asm.S
@@ -2726,25 +2726,18 @@ ENDPROC(aesni_ctr_enc)
 	pxor CTR, IV;
 
 /*
- * void aesni_xts_crypt8(const struct crypto_aes_ctx *ctx, u8 *dst,
- *			 const u8 *src, bool enc, le128 *iv)
+ * void aesni_xts_encrypt(const struct crypto_aes_ctx *ctx, u8 *dst,
+ *			  const u8 *src, unsigned int len, le128 *iv)
  */
-ENTRY(aesni_xts_crypt8)
+ENTRY(aesni_xts_encrypt)
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
@@ -2768,71 +2761,103 @@ ENTRY(aesni_xts_crypt8)
 	pxor INC, STATE4
 	movdqu IV, 0x30(OUTP)
 
-	CALL_NOSPEC %r11
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
 
-	CALL_NOSPEC %r11
+	FRAME_END
+	ret
+ENDPROC(aesni_xts_encrypt)
+
+/*
+ * void aesni_xts_decrypt(const struct crypto_aes_ctx *ctx, u8 *dst,
+ *			  const u8 *src, unsigned int len, le128 *iv)
+ */
+ENTRY(aesni_xts_decrypt)
+	FRAME_BEGIN
+
+	movdqa .Lgf128mul_x_ble_mask, GF128MUL_MASK
+	movups (IVP), IV
+
+	mov 480(KEYP), KLEN
+	add $240, KEYP
 
-	movdqu 0x40(OUTP), INC
+.Lxts_dec_loop4:
+	movdqa IV, STATE1
+	movdqu 0x00(INP), INC
 	pxor INC, STATE1
-	movdqu STATE1, 0x40(OUTP)
+	movdqu IV, 0x00(OUTP)
 
-	movdqu 0x50(OUTP), INC
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
+
+	movdqu 0x00(OUTP), INC
+	pxor INC, STATE1
+	movdqu STATE1, 0x00(OUTP)
+
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
-ENDPROC(aesni_xts_crypt8)
+ENDPROC(aesni_xts_decrypt)
 
 #endif
diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index f795310d3da7..18cfb76daa23 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -97,6 +97,12 @@ asmlinkage void aesni_cbc_dec(struct crypto_aes_ctx *ctx, u8 *out,
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
@@ -104,9 +110,6 @@ static void (*aesni_ctr_enc_tfm)(struct crypto_aes_ctx *ctx, u8 *out,
 asmlinkage void aesni_ctr_enc(struct crypto_aes_ctx *ctx, u8 *out,
 			      const u8 *in, unsigned int len, u8 *iv);
 
-asmlinkage void aesni_xts_crypt8(const struct crypto_aes_ctx *ctx, u8 *out,
-				 const u8 *in, bool enc, le128 *iv);
-
 /* asmlinkage void aesni_gcm_enc()
  * void *ctx,  AES Key schedule. Starts on a 16 byte boundary.
  * struct gcm_context_data.  May be uninitialized.
@@ -558,14 +561,14 @@ static void aesni_xts_dec(const void *ctx, u8 *dst, const u8 *src, le128 *iv)
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
@@ -573,8 +576,8 @@ static const struct common_glue_ctx aesni_enc_xts = {
 	.fpu_blocks_limit = 1,
 
 	.funcs = { {
-		.num_blocks = 8,
-		.fn_u = { .xts = aesni_xts_enc8 }
+		.num_blocks = 32,
+		.fn_u = { .xts = aesni_xts_enc32 }
 	}, {
 		.num_blocks = 1,
 		.fn_u = { .xts = aesni_xts_enc }
@@ -586,8 +589,8 @@ static const struct common_glue_ctx aesni_dec_xts = {
 	.fpu_blocks_limit = 1,
 
 	.funcs = { {
-		.num_blocks = 8,
-		.fn_u = { .xts = aesni_xts_dec8 }
+		.num_blocks = 32,
+		.fn_u = { .xts = aesni_xts_dec32 }
 	}, {
 		.num_blocks = 1,
 		.fn_u = { .xts = aesni_xts_dec }
-- 
2.31.0.rc2.261.g7f71774620-goog

