Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53BFF1B038B
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 09:57:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725959AbgDTH52 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 03:57:28 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:60873 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725865AbgDTH51 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Apr 2020 03:57:27 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id f1d5d349;
        Mon, 20 Apr 2020 07:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:mime-version:content-transfer-encoding;
         s=mail; bh=0Z8VrEBoEqZW0fKOw8SFpT75CtM=; b=LEZN2u8UUIfHMWZ/6gzr
        jda7Lan1GDm6qALfJit0LKgKlxjjh4TxYIysBvtXR8xoofnLuvZf0ZOJOhfuaIrb
        QG+/BQ8XGxyixgk0GenBb+sDPPZlb7M6Y0B+yWGhA36cMrONeEZn/Eq0oI6WS977
        l273zcfyJMyGuW8AMOzRM2IATs2s4pNzL0mYyKKimqFyIkBD1vFeMrYYJNbL/T1b
        ufUeBxO2b+0c9kBdhT2buCza4PHsNFN9S3DcUJ+4sOCsqgnbtVgIwICISOoc3EDp
        8PE3jm9sjwWS2TKvsZa7vVpbQK9f0TynAlNhBfOpBwTqg5qRYSKYTFXC6URD9Eru
        cQ==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 111377eb (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Mon, 20 Apr 2020 07:46:50 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, ebiggers@google.com, ardb@kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>, stable@vger.kernel.org
Subject: [PATCH crypto-stable] crypto: arch/lib - limit simd usage to PAGE_SIZE chunks
Date:   Mon, 20 Apr 2020 01:57:11 -0600
Message-Id: <20200420075711.2385190-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The initial Zinc patchset, after some mailing list discussion, contained
code to ensure that kernel_fpu_enable would not be kept on for more than
a PAGE_SIZE chunk, since it disables preemption. The choice of PAGE_SIZE
isn't totally scientific, but it's not a bad guess either, and it's
what's used in both the x86 poly1305 and blake2s library code already.
Unfortunately it appears to have been left out of the final patchset
that actually added the glue code. So, this commit adds back the
PAGE_SIZE chunking.

Fixes: 84e03fa39fbe ("crypto: x86/chacha - expose SIMD ChaCha routine as library function")
Fixes: b3aad5bad26a ("crypto: arm64/chacha - expose arm64 ChaCha routine as library function")
Fixes: a44a3430d71b ("crypto: arm/chacha - expose ARM ChaCha routine as library function")
Fixes: f569ca164751 ("crypto: arm64/poly1305 - incorporate OpenSSL/CRYPTOGAMS NEON implementation")
Fixes: a6b803b3ddc7 ("crypto: arm/poly1305 - incorporate OpenSSL/CRYPTOGAMS NEON implementation")
Cc: Eric Biggers <ebiggers@google.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
Eric, Ard - I'm wondering if this was in fact just an oversight in Ard's
patches, or if there was actually some later discussion in which we
concluded that the PAGE_SIZE chunking wasn't required, perhaps because
of FPU changes. If that's the case, please do let me know, in which case
I'll submit a _different_ patch that removes the chunking from x86 poly
and blake. I can't find any emails that would indicate that, but I might
be mistaken.

 arch/arm/crypto/chacha-glue.c        | 16 +++++++++++++---
 arch/arm/crypto/poly1305-glue.c      | 17 +++++++++++++----
 arch/arm64/crypto/chacha-neon-glue.c | 16 +++++++++++++---
 arch/arm64/crypto/poly1305-glue.c    | 17 +++++++++++++----
 arch/x86/crypto/chacha_glue.c        | 16 +++++++++++++---
 5 files changed, 65 insertions(+), 17 deletions(-)

diff --git a/arch/arm/crypto/chacha-glue.c b/arch/arm/crypto/chacha-glue.c
index 6fdb0ac62b3d..0e29ebac95fd 100644
--- a/arch/arm/crypto/chacha-glue.c
+++ b/arch/arm/crypto/chacha-glue.c
@@ -91,9 +91,19 @@ void chacha_crypt_arch(u32 *state, u8 *dst, const u8 *src, unsigned int bytes,
 		return;
 	}
 
-	kernel_neon_begin();
-	chacha_doneon(state, dst, src, bytes, nrounds);
-	kernel_neon_end();
+	for (;;) {
+		unsigned int todo = min_t(unsigned int, PAGE_SIZE, bytes);
+
+		kernel_neon_begin();
+		chacha_doneon(state, dst, src, todo, nrounds);
+		kernel_neon_end();
+
+		bytes -= todo;
+		if (!bytes)
+			break;
+		src += todo;
+		dst += todo;
+	}
 }
 EXPORT_SYMBOL(chacha_crypt_arch);
 
diff --git a/arch/arm/crypto/poly1305-glue.c b/arch/arm/crypto/poly1305-glue.c
index ceec04ec2f40..536a4a943ebe 100644
--- a/arch/arm/crypto/poly1305-glue.c
+++ b/arch/arm/crypto/poly1305-glue.c
@@ -160,13 +160,22 @@ void poly1305_update_arch(struct poly1305_desc_ctx *dctx, const u8 *src,
 		unsigned int len = round_down(nbytes, POLY1305_BLOCK_SIZE);
 
 		if (static_branch_likely(&have_neon) && do_neon) {
-			kernel_neon_begin();
-			poly1305_blocks_neon(&dctx->h, src, len, 1);
-			kernel_neon_end();
+			for (;;) {
+				unsigned int todo = min_t(unsigned int, PAGE_SIZE, len);
+
+				kernel_neon_begin();
+				poly1305_blocks_neon(&dctx->h, src, todo, 1);
+				kernel_neon_end();
+
+				len -= todo;
+				if (!len)
+					break;
+				src += todo;
+			}
 		} else {
 			poly1305_blocks_arm(&dctx->h, src, len, 1);
+			src += len;
 		}
-		src += len;
 		nbytes %= POLY1305_BLOCK_SIZE;
 	}
 
diff --git a/arch/arm64/crypto/chacha-neon-glue.c b/arch/arm64/crypto/chacha-neon-glue.c
index 37ca3e889848..3eff767f4f77 100644
--- a/arch/arm64/crypto/chacha-neon-glue.c
+++ b/arch/arm64/crypto/chacha-neon-glue.c
@@ -87,9 +87,19 @@ void chacha_crypt_arch(u32 *state, u8 *dst, const u8 *src, unsigned int bytes,
 	    !crypto_simd_usable())
 		return chacha_crypt_generic(state, dst, src, bytes, nrounds);
 
-	kernel_neon_begin();
-	chacha_doneon(state, dst, src, bytes, nrounds);
-	kernel_neon_end();
+	for (;;) {
+		unsigned int todo = min_t(unsigned int, PAGE_SIZE, bytes);
+
+		kernel_neon_begin();
+		chacha_doneon(state, dst, src, todo, nrounds);
+		kernel_neon_end();
+
+		bytes -= todo;
+		if (!bytes)
+			break;
+		src += todo;
+		dst += todo;
+	}
 }
 EXPORT_SYMBOL(chacha_crypt_arch);
 
diff --git a/arch/arm64/crypto/poly1305-glue.c b/arch/arm64/crypto/poly1305-glue.c
index e97b092f56b8..616134bef02c 100644
--- a/arch/arm64/crypto/poly1305-glue.c
+++ b/arch/arm64/crypto/poly1305-glue.c
@@ -143,13 +143,22 @@ void poly1305_update_arch(struct poly1305_desc_ctx *dctx, const u8 *src,
 		unsigned int len = round_down(nbytes, POLY1305_BLOCK_SIZE);
 
 		if (static_branch_likely(&have_neon) && crypto_simd_usable()) {
-			kernel_neon_begin();
-			poly1305_blocks_neon(&dctx->h, src, len, 1);
-			kernel_neon_end();
+			for (;;) {
+				unsigned int todo = min_t(unsigned int, PAGE_SIZE, len);
+
+				kernel_neon_begin();
+				poly1305_blocks_neon(&dctx->h, src, todo, 1);
+				kernel_neon_end();
+
+				len -= todo;
+				if (!len)
+					break;
+				src += todo;
+			}
 		} else {
 			poly1305_blocks(&dctx->h, src, len, 1);
+			src += len;
 		}
-		src += len;
 		nbytes %= POLY1305_BLOCK_SIZE;
 	}
 
diff --git a/arch/x86/crypto/chacha_glue.c b/arch/x86/crypto/chacha_glue.c
index b412c21ee06e..10733035b81c 100644
--- a/arch/x86/crypto/chacha_glue.c
+++ b/arch/x86/crypto/chacha_glue.c
@@ -153,9 +153,19 @@ void chacha_crypt_arch(u32 *state, u8 *dst, const u8 *src, unsigned int bytes,
 	    bytes <= CHACHA_BLOCK_SIZE)
 		return chacha_crypt_generic(state, dst, src, bytes, nrounds);
 
-	kernel_fpu_begin();
-	chacha_dosimd(state, dst, src, bytes, nrounds);
-	kernel_fpu_end();
+	for (;;) {
+		unsigned int todo = min_t(unsigned int, PAGE_SIZE, bytes);
+
+		kernel_fpu_begin();
+		chacha_dosimd(state, dst, src, todo, nrounds);
+		kernel_fpu_end();
+
+		bytes -= todo;
+		if (!bytes)
+			break;
+		src += todo;
+		dst += todo;
+	}
 }
 EXPORT_SYMBOL(chacha_crypt_arch);
 
-- 
2.26.1

