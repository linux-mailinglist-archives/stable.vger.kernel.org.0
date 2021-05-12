Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 321CC37CC2D
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:03:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236280AbhELQnT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:43:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:56992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242874AbhELQgD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:36:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F065D61E07;
        Wed, 12 May 2021 15:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835195;
        bh=6acTxuvXipWB1slW6C5+bhnmpKycUrc6qpQHV8Xe/0U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xx9D7NXSJTo8kVJUrC0rFY6IHW0aoe4Th9w5uR/5qA+Kl+rIgEmNqEVHfo9a98rJS
         44Re8C9xJvNv7avaq6vrD9Vkg3a2Wc0gB6P3xeDlywrQoZtdePlO7gWCnve1UmTq8Q
         250PvNgG8YzCtdk21GUY+b+0NXa92o2D62Fh3lj0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Ard Biesheuvel <ardb@kernel.org>,
        Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 246/677] crypto: poly1305 - fix poly1305_core_setkey() declaration
Date:   Wed, 12 May 2021 16:44:52 +0200
Message-Id: <20210512144845.406161993@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 8d195e7a8ada68928f2aedb2c18302a4518fe68e ]

gcc-11 points out a mismatch between the declaration and the definition
of poly1305_core_setkey():

lib/crypto/poly1305-donna32.c:13:67: error: argument 2 of type ‘const u8[16]’ {aka ‘const unsigned char[16]’} with mismatched bound [-Werror=array-parameter=]
   13 | void poly1305_core_setkey(struct poly1305_core_key *key, const u8 raw_key[16])
      |                                                          ~~~~~~~~~^~~~~~~~~~~
In file included from lib/crypto/poly1305-donna32.c:11:
include/crypto/internal/poly1305.h:21:68: note: previously declared as ‘const u8 *’ {aka ‘const unsigned char *’}
   21 | void poly1305_core_setkey(struct poly1305_core_key *key, const u8 *raw_key);

This is harmless in principle, as the calling conventions are the same,
but the more specific prototype allows better type checking in the
caller.

Change the declaration to match the actual function definition.
The poly1305_simd_init() is a bit suspicious here, as it previously
had a 32-byte argument type, but looks like it needs to take the
16-byte POLY1305_BLOCK_SIZE array instead.

Fixes: 1c08a104360f ("crypto: poly1305 - add new 32 and 64-bit generic versions")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/crypto/poly1305-glue.c    | 2 +-
 arch/arm64/crypto/poly1305-glue.c  | 2 +-
 arch/mips/crypto/poly1305-glue.c   | 2 +-
 arch/x86/crypto/poly1305_glue.c    | 6 +++---
 include/crypto/internal/poly1305.h | 3 ++-
 include/crypto/poly1305.h          | 6 ++++--
 lib/crypto/poly1305-donna32.c      | 3 ++-
 lib/crypto/poly1305-donna64.c      | 3 ++-
 lib/crypto/poly1305.c              | 3 ++-
 9 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/arch/arm/crypto/poly1305-glue.c b/arch/arm/crypto/poly1305-glue.c
index 3023c1acfa19..c31bd8f7c092 100644
--- a/arch/arm/crypto/poly1305-glue.c
+++ b/arch/arm/crypto/poly1305-glue.c
@@ -29,7 +29,7 @@ void __weak poly1305_blocks_neon(void *state, const u8 *src, u32 len, u32 hibit)
 
 static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_neon);
 
-void poly1305_init_arch(struct poly1305_desc_ctx *dctx, const u8 *key)
+void poly1305_init_arch(struct poly1305_desc_ctx *dctx, const u8 key[POLY1305_KEY_SIZE])
 {
 	poly1305_init_arm(&dctx->h, key);
 	dctx->s[0] = get_unaligned_le32(key + 16);
diff --git a/arch/arm64/crypto/poly1305-glue.c b/arch/arm64/crypto/poly1305-glue.c
index 683de671741a..9c3d86e397bf 100644
--- a/arch/arm64/crypto/poly1305-glue.c
+++ b/arch/arm64/crypto/poly1305-glue.c
@@ -25,7 +25,7 @@ asmlinkage void poly1305_emit(void *state, u8 *digest, const u32 *nonce);
 
 static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_neon);
 
-void poly1305_init_arch(struct poly1305_desc_ctx *dctx, const u8 *key)
+void poly1305_init_arch(struct poly1305_desc_ctx *dctx, const u8 key[POLY1305_KEY_SIZE])
 {
 	poly1305_init_arm64(&dctx->h, key);
 	dctx->s[0] = get_unaligned_le32(key + 16);
diff --git a/arch/mips/crypto/poly1305-glue.c b/arch/mips/crypto/poly1305-glue.c
index fc881b46d911..bc6110fb98e0 100644
--- a/arch/mips/crypto/poly1305-glue.c
+++ b/arch/mips/crypto/poly1305-glue.c
@@ -17,7 +17,7 @@ asmlinkage void poly1305_init_mips(void *state, const u8 *key);
 asmlinkage void poly1305_blocks_mips(void *state, const u8 *src, u32 len, u32 hibit);
 asmlinkage void poly1305_emit_mips(void *state, u8 *digest, const u32 *nonce);
 
-void poly1305_init_arch(struct poly1305_desc_ctx *dctx, const u8 *key)
+void poly1305_init_arch(struct poly1305_desc_ctx *dctx, const u8 key[POLY1305_KEY_SIZE])
 {
 	poly1305_init_mips(&dctx->h, key);
 	dctx->s[0] = get_unaligned_le32(key + 16);
diff --git a/arch/x86/crypto/poly1305_glue.c b/arch/x86/crypto/poly1305_glue.c
index 646da46e8d10..1dfb8af48a3c 100644
--- a/arch/x86/crypto/poly1305_glue.c
+++ b/arch/x86/crypto/poly1305_glue.c
@@ -16,7 +16,7 @@
 #include <asm/simd.h>
 
 asmlinkage void poly1305_init_x86_64(void *ctx,
-				     const u8 key[POLY1305_KEY_SIZE]);
+				     const u8 key[POLY1305_BLOCK_SIZE]);
 asmlinkage void poly1305_blocks_x86_64(void *ctx, const u8 *inp,
 				       const size_t len, const u32 padbit);
 asmlinkage void poly1305_emit_x86_64(void *ctx, u8 mac[POLY1305_DIGEST_SIZE],
@@ -81,7 +81,7 @@ static void convert_to_base2_64(void *ctx)
 	state->is_base2_26 = 0;
 }
 
-static void poly1305_simd_init(void *ctx, const u8 key[POLY1305_KEY_SIZE])
+static void poly1305_simd_init(void *ctx, const u8 key[POLY1305_BLOCK_SIZE])
 {
 	poly1305_init_x86_64(ctx, key);
 }
@@ -129,7 +129,7 @@ static void poly1305_simd_emit(void *ctx, u8 mac[POLY1305_DIGEST_SIZE],
 		poly1305_emit_avx(ctx, mac, nonce);
 }
 
-void poly1305_init_arch(struct poly1305_desc_ctx *dctx, const u8 *key)
+void poly1305_init_arch(struct poly1305_desc_ctx *dctx, const u8 key[POLY1305_KEY_SIZE])
 {
 	poly1305_simd_init(&dctx->h, key);
 	dctx->s[0] = get_unaligned_le32(&key[16]);
diff --git a/include/crypto/internal/poly1305.h b/include/crypto/internal/poly1305.h
index 064e52ca5248..196aa769f296 100644
--- a/include/crypto/internal/poly1305.h
+++ b/include/crypto/internal/poly1305.h
@@ -18,7 +18,8 @@
  * only the ε-almost-∆-universal hash function (not the full MAC) is computed.
  */
 
-void poly1305_core_setkey(struct poly1305_core_key *key, const u8 *raw_key);
+void poly1305_core_setkey(struct poly1305_core_key *key,
+			  const u8 raw_key[POLY1305_BLOCK_SIZE]);
 static inline void poly1305_core_init(struct poly1305_state *state)
 {
 	*state = (struct poly1305_state){};
diff --git a/include/crypto/poly1305.h b/include/crypto/poly1305.h
index f1f67fc749cf..090692ec3bc7 100644
--- a/include/crypto/poly1305.h
+++ b/include/crypto/poly1305.h
@@ -58,8 +58,10 @@ struct poly1305_desc_ctx {
 	};
 };
 
-void poly1305_init_arch(struct poly1305_desc_ctx *desc, const u8 *key);
-void poly1305_init_generic(struct poly1305_desc_ctx *desc, const u8 *key);
+void poly1305_init_arch(struct poly1305_desc_ctx *desc,
+			const u8 key[POLY1305_KEY_SIZE]);
+void poly1305_init_generic(struct poly1305_desc_ctx *desc,
+			   const u8 key[POLY1305_KEY_SIZE]);
 
 static inline void poly1305_init(struct poly1305_desc_ctx *desc, const u8 *key)
 {
diff --git a/lib/crypto/poly1305-donna32.c b/lib/crypto/poly1305-donna32.c
index 3cc77d94390b..7fb71845cc84 100644
--- a/lib/crypto/poly1305-donna32.c
+++ b/lib/crypto/poly1305-donna32.c
@@ -10,7 +10,8 @@
 #include <asm/unaligned.h>
 #include <crypto/internal/poly1305.h>
 
-void poly1305_core_setkey(struct poly1305_core_key *key, const u8 raw_key[16])
+void poly1305_core_setkey(struct poly1305_core_key *key,
+			  const u8 raw_key[POLY1305_BLOCK_SIZE])
 {
 	/* r &= 0xffffffc0ffffffc0ffffffc0fffffff */
 	key->key.r[0] = (get_unaligned_le32(&raw_key[0])) & 0x3ffffff;
diff --git a/lib/crypto/poly1305-donna64.c b/lib/crypto/poly1305-donna64.c
index 6ae181bb4345..d34cf4053668 100644
--- a/lib/crypto/poly1305-donna64.c
+++ b/lib/crypto/poly1305-donna64.c
@@ -12,7 +12,8 @@
 
 typedef __uint128_t u128;
 
-void poly1305_core_setkey(struct poly1305_core_key *key, const u8 raw_key[16])
+void poly1305_core_setkey(struct poly1305_core_key *key,
+			  const u8 raw_key[POLY1305_BLOCK_SIZE])
 {
 	u64 t0, t1;
 
diff --git a/lib/crypto/poly1305.c b/lib/crypto/poly1305.c
index 9d2d14df0fee..26d87fc3823e 100644
--- a/lib/crypto/poly1305.c
+++ b/lib/crypto/poly1305.c
@@ -12,7 +12,8 @@
 #include <linux/module.h>
 #include <asm/unaligned.h>
 
-void poly1305_init_generic(struct poly1305_desc_ctx *desc, const u8 *key)
+void poly1305_init_generic(struct poly1305_desc_ctx *desc,
+			   const u8 key[POLY1305_KEY_SIZE])
 {
 	poly1305_core_setkey(&desc->core_r, key);
 	desc->s[0] = get_unaligned_le32(key + 16);
-- 
2.30.2



