Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDAE6535FC3
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 13:43:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351705AbiE0LmB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 07:42:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351644AbiE0Llf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 07:41:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3117212E30A;
        Fri, 27 May 2022 04:40:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A92C7B82466;
        Fri, 27 May 2022 11:40:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19EC5C385A9;
        Fri, 27 May 2022 11:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653651601;
        bh=NzqBYf1oWTkP3+Jz5oCdF4IdTChcFs0VlDKxh8xzaw8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wMevKOm0Dc3A8wnspwAfaRcMBpAiIAutQy2T+nqAJD0yp6QIb5IE0QsLbocXQdBgA
         IUpJWUWYoG7JmhvI5Z/5MkyKHLVfbPB3TX84G2oAryAH1nTG4HBUMUfqTWliuA8tHk
         S6ynOiWQAgbXli56o3y1V932eyLxPTbCJNXwwDCQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miles Chen <miles.chen@mediatek.com>,
        Nathan Chancellor <nathan@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Eric Biggers <ebiggers@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.10 028/163] lib/crypto: blake2s: avoid indirect calls to compression function for Clang CFI
Date:   Fri, 27 May 2022 10:48:28 +0200
Message-Id: <20220527084832.120522142@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220527084828.156494029@linuxfoundation.org>
References: <20220527084828.156494029@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

commit d2a02e3c8bb6b347818518edff5a4b40ff52d6d8 upstream.

blake2s_compress_generic is weakly aliased by blake2s_compress. The
current harness for function selection uses a function pointer, which is
ordinarily inlined and resolved at compile time. But when Clang's CFI is
enabled, CFI still triggers when making an indirect call via a weak
symbol. This seems like a bug in Clang's CFI, as though it's bucketing
weak symbols and strong symbols differently. It also only seems to
trigger when "full LTO" mode is used, rather than "thin LTO".

[    0.000000][    T0] Kernel panic - not syncing: CFI failure (target: blake2s_compress_generic+0x0/0x1444)
[    0.000000][    T0] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.16.0-mainline-06981-g076c855b846e #1
[    0.000000][    T0] Hardware name: MT6873 (DT)
[    0.000000][    T0] Call trace:
[    0.000000][    T0]  dump_backtrace+0xfc/0x1dc
[    0.000000][    T0]  dump_stack_lvl+0xa8/0x11c
[    0.000000][    T0]  panic+0x194/0x464
[    0.000000][    T0]  __cfi_check_fail+0x54/0x58
[    0.000000][    T0]  __cfi_slowpath_diag+0x354/0x4b0
[    0.000000][    T0]  blake2s_update+0x14c/0x178
[    0.000000][    T0]  _extract_entropy+0xf4/0x29c
[    0.000000][    T0]  crng_initialize_primary+0x24/0x94
[    0.000000][    T0]  rand_initialize+0x2c/0x6c
[    0.000000][    T0]  start_kernel+0x2f8/0x65c
[    0.000000][    T0]  __primary_switched+0xc4/0x7be4
[    0.000000][    T0] Rebooting in 5 seconds..

Nonetheless, the function pointer method isn't so terrific anyway, so
this patch replaces it with a simple boolean, which also gets inlined
away. This successfully works around the Clang bug.

In general, I'm not too keen on all of the indirection involved here; it
clearly does more harm than good. Hopefully the whole thing can get
cleaned up down the road when lib/crypto is overhauled more
comprehensively. But for now, we go with a simple bandaid.

Fixes: 6048fdcc5f26 ("lib/crypto: blake2s: include as built-in")
Link: https://github.com/ClangBuiltLinux/linux/issues/1567
Reported-by: Miles Chen <miles.chen@mediatek.com>
Tested-by: Miles Chen <miles.chen@mediatek.com>
Tested-by: Nathan Chancellor <nathan@kernel.org>
Tested-by: John Stultz <john.stultz@linaro.org>
Acked-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/crypto/blake2s-shash.c   |    4 +--
 crypto/blake2s_generic.c          |    4 +--
 include/crypto/internal/blake2s.h |   40 +++++++++++++++++++++++---------------
 lib/crypto/blake2s.c              |    4 +--
 4 files changed, 31 insertions(+), 21 deletions(-)

--- a/arch/x86/crypto/blake2s-shash.c
+++ b/arch/x86/crypto/blake2s-shash.c
@@ -18,12 +18,12 @@
 static int crypto_blake2s_update_x86(struct shash_desc *desc,
 				     const u8 *in, unsigned int inlen)
 {
-	return crypto_blake2s_update(desc, in, inlen, blake2s_compress);
+	return crypto_blake2s_update(desc, in, inlen, false);
 }
 
 static int crypto_blake2s_final_x86(struct shash_desc *desc, u8 *out)
 {
-	return crypto_blake2s_final(desc, out, blake2s_compress);
+	return crypto_blake2s_final(desc, out, false);
 }
 
 #define BLAKE2S_ALG(name, driver_name, digest_size)			\
--- a/crypto/blake2s_generic.c
+++ b/crypto/blake2s_generic.c
@@ -15,12 +15,12 @@
 static int crypto_blake2s_update_generic(struct shash_desc *desc,
 					 const u8 *in, unsigned int inlen)
 {
-	return crypto_blake2s_update(desc, in, inlen, blake2s_compress_generic);
+	return crypto_blake2s_update(desc, in, inlen, true);
 }
 
 static int crypto_blake2s_final_generic(struct shash_desc *desc, u8 *out)
 {
-	return crypto_blake2s_final(desc, out, blake2s_compress_generic);
+	return crypto_blake2s_final(desc, out, true);
 }
 
 #define BLAKE2S_ALG(name, driver_name, digest_size)			\
--- a/include/crypto/internal/blake2s.h
+++ b/include/crypto/internal/blake2s.h
@@ -24,14 +24,11 @@ static inline void blake2s_set_lastblock
 	state->f[0] = -1;
 }
 
-typedef void (*blake2s_compress_t)(struct blake2s_state *state,
-				   const u8 *block, size_t nblocks, u32 inc);
-
 /* Helper functions for BLAKE2s shared by the library and shash APIs */
 
-static inline void __blake2s_update(struct blake2s_state *state,
-				    const u8 *in, size_t inlen,
-				    blake2s_compress_t compress)
+static __always_inline void
+__blake2s_update(struct blake2s_state *state, const u8 *in, size_t inlen,
+		 bool force_generic)
 {
 	const size_t fill = BLAKE2S_BLOCK_SIZE - state->buflen;
 
@@ -39,7 +36,12 @@ static inline void __blake2s_update(stru
 		return;
 	if (inlen > fill) {
 		memcpy(state->buf + state->buflen, in, fill);
-		(*compress)(state, state->buf, 1, BLAKE2S_BLOCK_SIZE);
+		if (force_generic)
+			blake2s_compress_generic(state, state->buf, 1,
+						 BLAKE2S_BLOCK_SIZE);
+		else
+			blake2s_compress(state, state->buf, 1,
+					 BLAKE2S_BLOCK_SIZE);
 		state->buflen = 0;
 		in += fill;
 		inlen -= fill;
@@ -47,7 +49,12 @@ static inline void __blake2s_update(stru
 	if (inlen > BLAKE2S_BLOCK_SIZE) {
 		const size_t nblocks = DIV_ROUND_UP(inlen, BLAKE2S_BLOCK_SIZE);
 		/* Hash one less (full) block than strictly possible */
-		(*compress)(state, in, nblocks - 1, BLAKE2S_BLOCK_SIZE);
+		if (force_generic)
+			blake2s_compress_generic(state, in, nblocks - 1,
+						 BLAKE2S_BLOCK_SIZE);
+		else
+			blake2s_compress(state, in, nblocks - 1,
+					 BLAKE2S_BLOCK_SIZE);
 		in += BLAKE2S_BLOCK_SIZE * (nblocks - 1);
 		inlen -= BLAKE2S_BLOCK_SIZE * (nblocks - 1);
 	}
@@ -55,13 +62,16 @@ static inline void __blake2s_update(stru
 	state->buflen += inlen;
 }
 
-static inline void __blake2s_final(struct blake2s_state *state, u8 *out,
-				   blake2s_compress_t compress)
+static __always_inline void
+__blake2s_final(struct blake2s_state *state, u8 *out, bool force_generic)
 {
 	blake2s_set_lastblock(state);
 	memset(state->buf + state->buflen, 0,
 	       BLAKE2S_BLOCK_SIZE - state->buflen); /* Padding */
-	(*compress)(state, state->buf, 1, state->buflen);
+	if (force_generic)
+		blake2s_compress_generic(state, state->buf, 1, state->buflen);
+	else
+		blake2s_compress(state, state->buf, 1, state->buflen);
 	cpu_to_le32_array(state->h, ARRAY_SIZE(state->h));
 	memcpy(out, state->h, state->outlen);
 }
@@ -99,20 +109,20 @@ static inline int crypto_blake2s_init(st
 
 static inline int crypto_blake2s_update(struct shash_desc *desc,
 					const u8 *in, unsigned int inlen,
-					blake2s_compress_t compress)
+					bool force_generic)
 {
 	struct blake2s_state *state = shash_desc_ctx(desc);
 
-	__blake2s_update(state, in, inlen, compress);
+	__blake2s_update(state, in, inlen, force_generic);
 	return 0;
 }
 
 static inline int crypto_blake2s_final(struct shash_desc *desc, u8 *out,
-				       blake2s_compress_t compress)
+				       bool force_generic)
 {
 	struct blake2s_state *state = shash_desc_ctx(desc);
 
-	__blake2s_final(state, out, compress);
+	__blake2s_final(state, out, force_generic);
 	return 0;
 }
 
--- a/lib/crypto/blake2s.c
+++ b/lib/crypto/blake2s.c
@@ -18,14 +18,14 @@
 
 void blake2s_update(struct blake2s_state *state, const u8 *in, size_t inlen)
 {
-	__blake2s_update(state, in, inlen, blake2s_compress);
+	__blake2s_update(state, in, inlen, false);
 }
 EXPORT_SYMBOL(blake2s_update);
 
 void blake2s_final(struct blake2s_state *state, u8 *out)
 {
 	WARN_ON(IS_ENABLED(DEBUG) && !out);
-	__blake2s_final(state, out, blake2s_compress);
+	__blake2s_final(state, out, false);
 	memzero_explicit(state, sizeof(*state));
 }
 EXPORT_SYMBOL(blake2s_final);


