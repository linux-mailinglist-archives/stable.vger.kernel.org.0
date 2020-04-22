Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AED681B4DF0
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 22:04:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726201AbgDVUED (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 16:04:03 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:38701 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725779AbgDVUED (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 16:04:03 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 61659f37;
        Wed, 22 Apr 2020 19:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=xTSCmSNDbHYYybm8zrBKAkhBJ
        kw=; b=Zc/6MAGLTyNiY7+Wma+ETAW7L7AxKuuJhiRC0YIPh50PalDYQATC2jqIN
        aA/wcZZMMLZS+P6jQxFYo0Yo8ufjSNbeGp1pnN7Wk0y5ZcRNn3KrdWhvz2fip++w
        0CPgJOIVrJjQLECwG7pqtlizg/ZuHgiRrnr9XFFrJOnxUTrXgrAhWBgsvR6pYgS8
        hBqzBIOKTlgfv770htcXY0hFTMwVd/w4Jo06Eu6Kw+rU6v/aPOArPR8das4UC10a
        6LqHyaYdUKETLINpS+eMaCZO0F9G1G+jJDmnUSafLDUFHDVjE12LoKKPmArITuB1
        wASGin6u98wuES6oBbnDJSXNaDoZQ==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 93510734 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Wed, 22 Apr 2020 19:53:07 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Eric Biggers <ebiggers@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        stable@vger.kernel.org
Subject: [PATCH crypto-stable v2] crypto: arch - limit simd usage to 4k chunks
Date:   Wed, 22 Apr 2020 14:03:44 -0600
Message-Id: <20200422200344.239462-1-Jason@zx2c4.com>
In-Reply-To: <20200420075711.2385190-1-Jason@zx2c4.com>
References: <20200420075711.2385190-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The initial Zinc patchset, after some mailing list discussion, contained
code to ensure that kernel_fpu_enable would not be kept on for more than
a 4k chunk, since it disables preemption. The choice of 4k isn't totally
scientific, but it's not a bad guess either, and it's what's used in
both the x86 poly1305, blake2s, and nhpoly1305 code already (in the form
of PAGE_SIZE, which this commit corrects to be explicitly 4k).

Ard did some back of the envelope calculations and found that
at 5 cycles/byte (overestimate) on a 1ghz processor (pretty slow), 4k
means we have a maximum preemption disabling of 20us, which Sebastian
confirmed was probably a good limit.

Unfortunately the chunking appears to have been left out of the final
patchset that added the glue code. So, this commit adds it back in.

Fixes: 84e03fa39fbe ("crypto: x86/chacha - expose SIMD ChaCha routine as library function")
Fixes: b3aad5bad26a ("crypto: arm64/chacha - expose arm64 ChaCha routine as library function")
Fixes: a44a3430d71b ("crypto: arm/chacha - expose ARM ChaCha routine as library function")
Fixes: d7d7b8535662 ("crypto: x86/poly1305 - wire up faster implementations for kernel")
Fixes: f569ca164751 ("crypto: arm64/poly1305 - incorporate OpenSSL/CRYPTOGAMS NEON implementation")
Fixes: a6b803b3ddc7 ("crypto: arm/poly1305 - incorporate OpenSSL/CRYPTOGAMS NEON implementation")
Fixes: 0f961f9f670e ("crypto: x86/nhpoly1305 - add AVX2 accelerated NHPoly1305")
Fixes: 012c82388c03 ("crypto: x86/nhpoly1305 - add SSE2 accelerated NHPoly1305")
Fixes: a00fa0c88774 ("crypto: arm64/nhpoly1305 - add NEON-accelerated NHPoly1305")
Fixes: 16aae3595a9d ("crypto: arm/nhpoly1305 - add NEON-accelerated NHPoly1305")
Fixes: ed0356eda153 ("crypto: blake2s - x86_64 SIMD implementation")
Cc: Eric Biggers <ebiggers@google.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: stable@vger.kernel.org
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
Changes v1->v2:
 - [Ard] Use explicit 4k chunks instead of PAGE_SIZE.
 - [Eric] Prefer do-while over for (;;).

 arch/arm/crypto/chacha-glue.c            | 14 +++++++++++---
 arch/arm/crypto/nhpoly1305-neon-glue.c   |  2 +-
 arch/arm/crypto/poly1305-glue.c          | 15 +++++++++++----
 arch/arm64/crypto/chacha-neon-glue.c     | 14 +++++++++++---
 arch/arm64/crypto/nhpoly1305-neon-glue.c |  2 +-
 arch/arm64/crypto/poly1305-glue.c        | 15 +++++++++++----
 arch/x86/crypto/blake2s-glue.c           | 10 ++++------
 arch/x86/crypto/chacha_glue.c            | 14 +++++++++++---
 arch/x86/crypto/nhpoly1305-avx2-glue.c   |  2 +-
 arch/x86/crypto/nhpoly1305-sse2-glue.c   |  2 +-
 arch/x86/crypto/poly1305_glue.c          | 13 ++++++-------
 11 files changed, 69 insertions(+), 34 deletions(-)

diff --git a/arch/arm/crypto/chacha-glue.c b/arch/arm/crypto/chacha-glue.c
index 6fdb0ac62b3d..59da6c0b63b6 100644
--- a/arch/arm/crypto/chacha-glue.c
+++ b/arch/arm/crypto/chacha-glue.c
@@ -91,9 +91,17 @@ void chacha_crypt_arch(u32 *state, u8 *dst, const u8 *src, unsigned int bytes,
 		return;
 	}
 
-	kernel_neon_begin();
-	chacha_doneon(state, dst, src, bytes, nrounds);
-	kernel_neon_end();
+	do {
+		unsigned int todo = min_t(unsigned int, bytes, SZ_4K);
+
+		kernel_neon_begin();
+		chacha_doneon(state, dst, src, todo, nrounds);
+		kernel_neon_end();
+
+		bytes -= todo;
+		src += todo;
+		dst += todo;
+	} while (bytes);
 }
 EXPORT_SYMBOL(chacha_crypt_arch);
 
diff --git a/arch/arm/crypto/nhpoly1305-neon-glue.c b/arch/arm/crypto/nhpoly1305-neon-glue.c
index ae5aefc44a4d..ffa8d73fe722 100644
--- a/arch/arm/crypto/nhpoly1305-neon-glue.c
+++ b/arch/arm/crypto/nhpoly1305-neon-glue.c
@@ -30,7 +30,7 @@ static int nhpoly1305_neon_update(struct shash_desc *desc,
 		return crypto_nhpoly1305_update(desc, src, srclen);
 
 	do {
-		unsigned int n = min_t(unsigned int, srclen, PAGE_SIZE);
+		unsigned int n = min_t(unsigned int, srclen, SZ_4K);
 
 		kernel_neon_begin();
 		crypto_nhpoly1305_update_helper(desc, src, n, _nh_neon);
diff --git a/arch/arm/crypto/poly1305-glue.c b/arch/arm/crypto/poly1305-glue.c
index ceec04ec2f40..13cfef4ae22e 100644
--- a/arch/arm/crypto/poly1305-glue.c
+++ b/arch/arm/crypto/poly1305-glue.c
@@ -160,13 +160,20 @@ void poly1305_update_arch(struct poly1305_desc_ctx *dctx, const u8 *src,
 		unsigned int len = round_down(nbytes, POLY1305_BLOCK_SIZE);
 
 		if (static_branch_likely(&have_neon) && do_neon) {
-			kernel_neon_begin();
-			poly1305_blocks_neon(&dctx->h, src, len, 1);
-			kernel_neon_end();
+			do {
+				unsigned int todo = min_t(unsigned int, len, SZ_4K);
+
+				kernel_neon_begin();
+				poly1305_blocks_neon(&dctx->h, src, todo, 1);
+				kernel_neon_end();
+
+				len -= todo;
+				src += todo;
+			} while (len);
 		} else {
 			poly1305_blocks_arm(&dctx->h, src, len, 1);
+			src += len;
 		}
-		src += len;
 		nbytes %= POLY1305_BLOCK_SIZE;
 	}
 
diff --git a/arch/arm64/crypto/chacha-neon-glue.c b/arch/arm64/crypto/chacha-neon-glue.c
index 37ca3e889848..af2bbca38e70 100644
--- a/arch/arm64/crypto/chacha-neon-glue.c
+++ b/arch/arm64/crypto/chacha-neon-glue.c
@@ -87,9 +87,17 @@ void chacha_crypt_arch(u32 *state, u8 *dst, const u8 *src, unsigned int bytes,
 	    !crypto_simd_usable())
 		return chacha_crypt_generic(state, dst, src, bytes, nrounds);
 
-	kernel_neon_begin();
-	chacha_doneon(state, dst, src, bytes, nrounds);
-	kernel_neon_end();
+	do {
+		unsigned int todo = min_t(unsigned int, bytes, SZ_4K);
+
+		kernel_neon_begin();
+		chacha_doneon(state, dst, src, todo, nrounds);
+		kernel_neon_end();
+
+		bytes -= todo;
+		src += todo;
+		dst += todo;
+	} while (bytes);
 }
 EXPORT_SYMBOL(chacha_crypt_arch);
 
diff --git a/arch/arm64/crypto/nhpoly1305-neon-glue.c b/arch/arm64/crypto/nhpoly1305-neon-glue.c
index 895d3727c1fb..c5405e6a6db7 100644
--- a/arch/arm64/crypto/nhpoly1305-neon-glue.c
+++ b/arch/arm64/crypto/nhpoly1305-neon-glue.c
@@ -30,7 +30,7 @@ static int nhpoly1305_neon_update(struct shash_desc *desc,
 		return crypto_nhpoly1305_update(desc, src, srclen);
 
 	do {
-		unsigned int n = min_t(unsigned int, srclen, PAGE_SIZE);
+		unsigned int n = min_t(unsigned int, srclen, SZ_4K);
 
 		kernel_neon_begin();
 		crypto_nhpoly1305_update_helper(desc, src, n, _nh_neon);
diff --git a/arch/arm64/crypto/poly1305-glue.c b/arch/arm64/crypto/poly1305-glue.c
index e97b092f56b8..f33ada70c4ed 100644
--- a/arch/arm64/crypto/poly1305-glue.c
+++ b/arch/arm64/crypto/poly1305-glue.c
@@ -143,13 +143,20 @@ void poly1305_update_arch(struct poly1305_desc_ctx *dctx, const u8 *src,
 		unsigned int len = round_down(nbytes, POLY1305_BLOCK_SIZE);
 
 		if (static_branch_likely(&have_neon) && crypto_simd_usable()) {
-			kernel_neon_begin();
-			poly1305_blocks_neon(&dctx->h, src, len, 1);
-			kernel_neon_end();
+			do {
+				unsigned int todo = min_t(unsigned int, len, SZ_4K);
+
+				kernel_neon_begin();
+				poly1305_blocks_neon(&dctx->h, src, todo, 1);
+				kernel_neon_end();
+
+				len -= todo;
+				src += todo;
+			} while (len);
 		} else {
 			poly1305_blocks(&dctx->h, src, len, 1);
+			src += len;
 		}
-		src += len;
 		nbytes %= POLY1305_BLOCK_SIZE;
 	}
 
diff --git a/arch/x86/crypto/blake2s-glue.c b/arch/x86/crypto/blake2s-glue.c
index 06ef2d4a4701..6737bcea1fa1 100644
--- a/arch/x86/crypto/blake2s-glue.c
+++ b/arch/x86/crypto/blake2s-glue.c
@@ -32,16 +32,16 @@ void blake2s_compress_arch(struct blake2s_state *state,
 			   const u32 inc)
 {
 	/* SIMD disables preemption, so relax after processing each page. */
-	BUILD_BUG_ON(PAGE_SIZE / BLAKE2S_BLOCK_SIZE < 8);
+	BUILD_BUG_ON(SZ_4K / BLAKE2S_BLOCK_SIZE < 8);
 
 	if (!static_branch_likely(&blake2s_use_ssse3) || !crypto_simd_usable()) {
 		blake2s_compress_generic(state, block, nblocks, inc);
 		return;
 	}
 
-	for (;;) {
+	do {
 		const size_t blocks = min_t(size_t, nblocks,
-					    PAGE_SIZE / BLAKE2S_BLOCK_SIZE);
+					    SZ_4K / BLAKE2S_BLOCK_SIZE);
 
 		kernel_fpu_begin();
 		if (IS_ENABLED(CONFIG_AS_AVX512) &&
@@ -52,10 +52,8 @@ void blake2s_compress_arch(struct blake2s_state *state,
 		kernel_fpu_end();
 
 		nblocks -= blocks;
-		if (!nblocks)
-			break;
 		block += blocks * BLAKE2S_BLOCK_SIZE;
-	}
+	} while (nblocks);
 }
 EXPORT_SYMBOL(blake2s_compress_arch);
 
diff --git a/arch/x86/crypto/chacha_glue.c b/arch/x86/crypto/chacha_glue.c
index b412c21ee06e..22250091cdbe 100644
--- a/arch/x86/crypto/chacha_glue.c
+++ b/arch/x86/crypto/chacha_glue.c
@@ -153,9 +153,17 @@ void chacha_crypt_arch(u32 *state, u8 *dst, const u8 *src, unsigned int bytes,
 	    bytes <= CHACHA_BLOCK_SIZE)
 		return chacha_crypt_generic(state, dst, src, bytes, nrounds);
 
-	kernel_fpu_begin();
-	chacha_dosimd(state, dst, src, bytes, nrounds);
-	kernel_fpu_end();
+	do {
+		unsigned int todo = min_t(unsigned int, bytes, SZ_4K);
+
+		kernel_fpu_begin();
+		chacha_dosimd(state, dst, src, todo, nrounds);
+		kernel_fpu_end();
+
+		bytes -= todo;
+		src += todo;
+		dst += todo;
+	} while (bytes);
 }
 EXPORT_SYMBOL(chacha_crypt_arch);
 
diff --git a/arch/x86/crypto/nhpoly1305-avx2-glue.c b/arch/x86/crypto/nhpoly1305-avx2-glue.c
index f7567cbd35b6..80fcb85736e1 100644
--- a/arch/x86/crypto/nhpoly1305-avx2-glue.c
+++ b/arch/x86/crypto/nhpoly1305-avx2-glue.c
@@ -29,7 +29,7 @@ static int nhpoly1305_avx2_update(struct shash_desc *desc,
 		return crypto_nhpoly1305_update(desc, src, srclen);
 
 	do {
-		unsigned int n = min_t(unsigned int, srclen, PAGE_SIZE);
+		unsigned int n = min_t(unsigned int, srclen, SZ_4K);
 
 		kernel_fpu_begin();
 		crypto_nhpoly1305_update_helper(desc, src, n, _nh_avx2);
diff --git a/arch/x86/crypto/nhpoly1305-sse2-glue.c b/arch/x86/crypto/nhpoly1305-sse2-glue.c
index a661ede3b5cf..cc6b7c1a2705 100644
--- a/arch/x86/crypto/nhpoly1305-sse2-glue.c
+++ b/arch/x86/crypto/nhpoly1305-sse2-glue.c
@@ -29,7 +29,7 @@ static int nhpoly1305_sse2_update(struct shash_desc *desc,
 		return crypto_nhpoly1305_update(desc, src, srclen);
 
 	do {
-		unsigned int n = min_t(unsigned int, srclen, PAGE_SIZE);
+		unsigned int n = min_t(unsigned int, srclen, SZ_4K);
 
 		kernel_fpu_begin();
 		crypto_nhpoly1305_update_helper(desc, src, n, _nh_sse2);
diff --git a/arch/x86/crypto/poly1305_glue.c b/arch/x86/crypto/poly1305_glue.c
index 6dfec19f7d57..dfe921efa9b2 100644
--- a/arch/x86/crypto/poly1305_glue.c
+++ b/arch/x86/crypto/poly1305_glue.c
@@ -91,8 +91,8 @@ static void poly1305_simd_blocks(void *ctx, const u8 *inp, size_t len,
 	struct poly1305_arch_internal *state = ctx;
 
 	/* SIMD disables preemption, so relax after processing each page. */
-	BUILD_BUG_ON(PAGE_SIZE < POLY1305_BLOCK_SIZE ||
-		     PAGE_SIZE % POLY1305_BLOCK_SIZE);
+	BUILD_BUG_ON(SZ_4K < POLY1305_BLOCK_SIZE ||
+		     SZ_4K % POLY1305_BLOCK_SIZE);
 
 	if (!static_branch_likely(&poly1305_use_avx) ||
 	    (len < (POLY1305_BLOCK_SIZE * 18) && !state->is_base2_26) ||
@@ -102,8 +102,8 @@ static void poly1305_simd_blocks(void *ctx, const u8 *inp, size_t len,
 		return;
 	}
 
-	for (;;) {
-		const size_t bytes = min_t(size_t, len, PAGE_SIZE);
+	do {
+		const size_t bytes = min_t(size_t, len, SZ_4K);
 
 		kernel_fpu_begin();
 		if (IS_ENABLED(CONFIG_AS_AVX512) && static_branch_likely(&poly1305_use_avx512))
@@ -113,11 +113,10 @@ static void poly1305_simd_blocks(void *ctx, const u8 *inp, size_t len,
 		else
 			poly1305_blocks_avx(ctx, inp, bytes, padbit);
 		kernel_fpu_end();
+
 		len -= bytes;
-		if (!len)
-			break;
 		inp += bytes;
-	}
+	} while (len);
 }
 
 static void poly1305_simd_emit(void *ctx, u8 mac[POLY1305_DIGEST_SIZE],
-- 
2.26.2

