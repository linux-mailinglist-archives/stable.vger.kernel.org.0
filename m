Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBB131C27C5
	for <lists+stable@lfdr.de>; Sat,  2 May 2020 20:44:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728406AbgEBSo5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 May 2020 14:44:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:59838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728305AbgEBSo4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 2 May 2020 14:44:56 -0400
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D047A206CD;
        Sat,  2 May 2020 18:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588445096;
        bh=4peJgt1Iav+Dpu2dqFkh6Oa7dQk2GH6BpwyHPU7plkU=;
        h=From:To:Cc:Subject:Date:From;
        b=s/o4tWMbYiykEr/i2qdGq3YJbwDo2K5zU1RX+Yc5QALJCRP7yD7kHmLosYWA15Sgu
         Nk9z8pV+ggsL2rdIinxcLa9l7mX33AvEMZBvxXwi71CWreVTOcaQBDjyWfurmTQUYs
         6thcHQR6vXuuu8OrHkwOrBgVxWd2n/DhdDHwXsy8=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     stable@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH] crypto: lib/aes - move IRQ disabling into AES library
Date:   Sat,  2 May 2020 11:44:49 -0700
Message-Id: <20200502184449.139964-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

The AES library code (which originally came from crypto/aes_ti.c) is
supposed to be constant-time, to the extent possible for a C
implementation.  But the hardening measure of disabling interrupts while
the S-box is loaded into cache was not included in the library version;
it was left only in the crypto API wrapper in crypto/aes_ti.c.

Move this logic into the library version so that everyone gets it.

Fixes: e59c1c987456 ("crypto: aes - create AES library based on the fixed time AES code")
Cc: <stable@vger.kernel.org> # v5.4+
Cc: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/aes_ti.c  | 18 ------------------
 lib/crypto/aes.c | 18 ++++++++++++++++++
 2 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/crypto/aes_ti.c b/crypto/aes_ti.c
index 205c2c257d4926..121f36621d6dcf 100644
--- a/crypto/aes_ti.c
+++ b/crypto/aes_ti.c
@@ -20,33 +20,15 @@ static int aesti_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 static void aesti_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 {
 	const struct crypto_aes_ctx *ctx = crypto_tfm_ctx(tfm);
-	unsigned long flags;
-
-	/*
-	 * Temporarily disable interrupts to avoid races where cachelines are
-	 * evicted when the CPU is interrupted to do something else.
-	 */
-	local_irq_save(flags);
 
 	aes_encrypt(ctx, out, in);
-
-	local_irq_restore(flags);
 }
 
 static void aesti_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 {
 	const struct crypto_aes_ctx *ctx = crypto_tfm_ctx(tfm);
-	unsigned long flags;
-
-	/*
-	 * Temporarily disable interrupts to avoid races where cachelines are
-	 * evicted when the CPU is interrupted to do something else.
-	 */
-	local_irq_save(flags);
 
 	aes_decrypt(ctx, out, in);
-
-	local_irq_restore(flags);
 }
 
 static struct crypto_alg aes_alg = {
diff --git a/lib/crypto/aes.c b/lib/crypto/aes.c
index 827fe89922fff0..029d8d0eac1f6e 100644
--- a/lib/crypto/aes.c
+++ b/lib/crypto/aes.c
@@ -260,6 +260,7 @@ void aes_encrypt(const struct crypto_aes_ctx *ctx, u8 *out, const u8 *in)
 	const u32 *rkp = ctx->key_enc + 4;
 	int rounds = 6 + ctx->key_length / 4;
 	u32 st0[4], st1[4];
+	unsigned long flags;
 	int round;
 
 	st0[0] = ctx->key_enc[0] ^ get_unaligned_le32(in);
@@ -267,6 +268,12 @@ void aes_encrypt(const struct crypto_aes_ctx *ctx, u8 *out, const u8 *in)
 	st0[2] = ctx->key_enc[2] ^ get_unaligned_le32(in + 8);
 	st0[3] = ctx->key_enc[3] ^ get_unaligned_le32(in + 12);
 
+	/*
+	 * Temporarily disable interrupts to avoid races where cachelines are
+	 * evicted when the CPU is interrupted to do something else.
+	 */
+	local_irq_save(flags);
+
 	/*
 	 * Force the compiler to emit data independent Sbox references,
 	 * by xoring the input with Sbox values that are known to add up
@@ -297,6 +304,8 @@ void aes_encrypt(const struct crypto_aes_ctx *ctx, u8 *out, const u8 *in)
 	put_unaligned_le32(subshift(st1, 1) ^ rkp[5], out + 4);
 	put_unaligned_le32(subshift(st1, 2) ^ rkp[6], out + 8);
 	put_unaligned_le32(subshift(st1, 3) ^ rkp[7], out + 12);
+
+	local_irq_restore(flags);
 }
 EXPORT_SYMBOL(aes_encrypt);
 
@@ -311,6 +320,7 @@ void aes_decrypt(const struct crypto_aes_ctx *ctx, u8 *out, const u8 *in)
 	const u32 *rkp = ctx->key_dec + 4;
 	int rounds = 6 + ctx->key_length / 4;
 	u32 st0[4], st1[4];
+	unsigned long flags;
 	int round;
 
 	st0[0] = ctx->key_dec[0] ^ get_unaligned_le32(in);
@@ -318,6 +328,12 @@ void aes_decrypt(const struct crypto_aes_ctx *ctx, u8 *out, const u8 *in)
 	st0[2] = ctx->key_dec[2] ^ get_unaligned_le32(in + 8);
 	st0[3] = ctx->key_dec[3] ^ get_unaligned_le32(in + 12);
 
+	/*
+	 * Temporarily disable interrupts to avoid races where cachelines are
+	 * evicted when the CPU is interrupted to do something else.
+	 */
+	local_irq_save(flags);
+
 	/*
 	 * Force the compiler to emit data independent Sbox references,
 	 * by xoring the input with Sbox values that are known to add up
@@ -348,6 +364,8 @@ void aes_decrypt(const struct crypto_aes_ctx *ctx, u8 *out, const u8 *in)
 	put_unaligned_le32(inv_subshift(st1, 1) ^ rkp[5], out + 4);
 	put_unaligned_le32(inv_subshift(st1, 2) ^ rkp[6], out + 8);
 	put_unaligned_le32(inv_subshift(st1, 3) ^ rkp[7], out + 12);
+
+	local_irq_restore(flags);
 }
 EXPORT_SYMBOL(aes_decrypt);
 
-- 
2.26.2

