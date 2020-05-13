Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E5821D0DC7
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 11:56:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388314AbgEMJzs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:55:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:59114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388309AbgEMJzr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:55:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB630206D6;
        Wed, 13 May 2020 09:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363746;
        bh=EDXeL6oqEL9cv7saDgUeYcWyf2Pk+Mcs4wIQvIsDdks=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tmt2i5HoXkGwNyr5VEVgfWCK55zGFiy7josdK/ttvuchjXZDZaAgyMzqSieut4J55
         t6olKb1nWs6mHIcobdU9R3YGr0Ap7rMT5zma0DjZ+tLs8ZmXFqPLk/zi97lYJlLQSk
         x5x1UEYpoQXOnd1A2GTAYUlrehot25WZOJ07G740=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.6 070/118] crypto: arch/lib - limit simd usage to 4k chunks
Date:   Wed, 13 May 2020 11:44:49 +0200
Message-Id: <20200513094423.915208762@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513094417.618129545@linuxfoundation.org>
References: <20200513094417.618129545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason A. Donenfeld <Jason@zx2c4.com>

commit 706024a52c614b478b63f7728d202532ce6591a9 upstream.

The initial Zinc patchset, after some mailing list discussion, contained
code to ensure that kernel_fpu_enable would not be kept on for more than
a 4k chunk, since it disables preemption. The choice of 4k isn't totally
scientific, but it's not a bad guess either, and it's what's used in
both the x86 poly1305, blake2s, and nhpoly1305 code already (in the form
of PAGE_SIZE, which this commit corrects to be explicitly 4k for the
former two).

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
Fixes: ed0356eda153 ("crypto: blake2s - x86_64 SIMD implementation")
Cc: Eric Biggers <ebiggers@google.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: stable@vger.kernel.org
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/crypto/chacha-glue.c        |   14 +++++++++++---
 arch/arm/crypto/poly1305-glue.c      |   15 +++++++++++----
 arch/arm64/crypto/chacha-neon-glue.c |   14 +++++++++++---
 arch/arm64/crypto/poly1305-glue.c    |   15 +++++++++++----
 arch/x86/crypto/blake2s-glue.c       |   10 ++++------
 arch/x86/crypto/chacha_glue.c        |   14 +++++++++++---
 arch/x86/crypto/poly1305_glue.c      |   13 ++++++-------
 7 files changed, 65 insertions(+), 30 deletions(-)

--- a/arch/arm/crypto/chacha-glue.c
+++ b/arch/arm/crypto/chacha-glue.c
@@ -91,9 +91,17 @@ void chacha_crypt_arch(u32 *state, u8 *d
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
 
--- a/arch/arm/crypto/poly1305-glue.c
+++ b/arch/arm/crypto/poly1305-glue.c
@@ -160,13 +160,20 @@ void poly1305_update_arch(struct poly130
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
 
--- a/arch/arm64/crypto/chacha-neon-glue.c
+++ b/arch/arm64/crypto/chacha-neon-glue.c
@@ -87,9 +87,17 @@ void chacha_crypt_arch(u32 *state, u8 *d
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
 
--- a/arch/arm64/crypto/poly1305-glue.c
+++ b/arch/arm64/crypto/poly1305-glue.c
@@ -143,13 +143,20 @@ void poly1305_update_arch(struct poly130
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
 
--- a/arch/x86/crypto/blake2s-glue.c
+++ b/arch/x86/crypto/blake2s-glue.c
@@ -32,16 +32,16 @@ void blake2s_compress_arch(struct blake2
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
@@ -52,10 +52,8 @@ void blake2s_compress_arch(struct blake2
 		kernel_fpu_end();
 
 		nblocks -= blocks;
-		if (!nblocks)
-			break;
 		block += blocks * BLAKE2S_BLOCK_SIZE;
-	}
+	} while (nblocks);
 }
 EXPORT_SYMBOL(blake2s_compress_arch);
 
--- a/arch/x86/crypto/chacha_glue.c
+++ b/arch/x86/crypto/chacha_glue.c
@@ -154,9 +154,17 @@ void chacha_crypt_arch(u32 *state, u8 *d
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
 
--- a/arch/x86/crypto/poly1305_glue.c
+++ b/arch/x86/crypto/poly1305_glue.c
@@ -91,8 +91,8 @@ static void poly1305_simd_blocks(void *c
 	struct poly1305_arch_internal *state = ctx;
 
 	/* SIMD disables preemption, so relax after processing each page. */
-	BUILD_BUG_ON(PAGE_SIZE < POLY1305_BLOCK_SIZE ||
-		     PAGE_SIZE % POLY1305_BLOCK_SIZE);
+	BUILD_BUG_ON(SZ_4K < POLY1305_BLOCK_SIZE ||
+		     SZ_4K % POLY1305_BLOCK_SIZE);
 
 	if (!IS_ENABLED(CONFIG_AS_AVX) || !static_branch_likely(&poly1305_use_avx) ||
 	    (len < (POLY1305_BLOCK_SIZE * 18) && !state->is_base2_26) ||
@@ -102,8 +102,8 @@ static void poly1305_simd_blocks(void *c
 		return;
 	}
 
-	for (;;) {
-		const size_t bytes = min_t(size_t, len, PAGE_SIZE);
+	do {
+		const size_t bytes = min_t(size_t, len, SZ_4K);
 
 		kernel_fpu_begin();
 		if (IS_ENABLED(CONFIG_AS_AVX512) && static_branch_likely(&poly1305_use_avx512))
@@ -113,11 +113,10 @@ static void poly1305_simd_blocks(void *c
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


