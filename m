Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F56C5580B5
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 18:53:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232320AbiFWQxH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 12:53:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233821AbiFWQvm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 12:51:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB8684D601;
        Thu, 23 Jun 2022 09:49:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 839AE61FC0;
        Thu, 23 Jun 2022 16:49:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DBE4C3411B;
        Thu, 23 Jun 2022 16:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656002993;
        bh=kYMTaFkDMWwk9gVOcvZPuv0uIydDT1gtwhi25M/zY3w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AszVpB3JWvP4xE+iklCDAoc5Wn6n53dOmmzqaOxFlEwCXeFR4ibvBtPLRh0A5CIl+
         /paiXzvF84WF5i0hr4EzyQ1LkhhFB8onx00/9wmFMwuWJEhmVx/MwrHdaDwg55OI/2
         Lun+UryNDMlSpi+vDRKDX2VLp+U4ENWemCSZFWhI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Stephan=20M=C3=BCller?= <smueller@chronox.de>,
        Theodore Tso <tytso@mit.edu>,
        Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 095/264] crypto: chacha20 - Fix chacha20_block() keystream alignment (again)
Date:   Thu, 23 Jun 2022 18:41:28 +0200
Message-Id: <20220623164346.760209489@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164344.053938039@linuxfoundation.org>
References: <20220623164344.053938039@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

[ Upstream commit a5e9f557098e54af44ade5d501379be18435bfbf ]

In commit 9f480faec58c ("crypto: chacha20 - Fix keystream alignment for
chacha20_block()"), I had missed that chacha20_block() can be called
directly on the buffer passed to get_random_bytes(), which can have any
alignment.  So, while my commit didn't break anything, it didn't fully
solve the alignment problems.

Revert my solution and just update chacha20_block() to use
put_unaligned_le32(), so the output buffer need not be aligned.
This is simpler, and on many CPUs it's the same speed.

But, I kept the 'tmp' buffers in extract_crng_user() and
_get_random_bytes() 4-byte aligned, since that alignment is actually
needed for _crng_backtrack_protect() too.

Reported-by: Stephan Müller <smueller@chronox.de>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/chacha20_generic.c |    7 ++++---
 drivers/char/random.c     |   24 ++++++++++++------------
 include/crypto/chacha20.h |    3 +--
 lib/chacha20.c            |    6 +++---
 4 files changed, 20 insertions(+), 20 deletions(-)

--- a/crypto/chacha20_generic.c
+++ b/crypto/chacha20_generic.c
@@ -23,20 +23,21 @@ static inline u32 le32_to_cpuvp(const vo
 static void chacha20_docrypt(u32 *state, u8 *dst, const u8 *src,
 			     unsigned int bytes)
 {
-	u32 stream[CHACHA20_BLOCK_WORDS];
+	/* aligned to potentially speed up crypto_xor() */
+	u8 stream[CHACHA20_BLOCK_SIZE] __aligned(sizeof(long));
 
 	if (dst != src)
 		memcpy(dst, src, bytes);
 
 	while (bytes >= CHACHA20_BLOCK_SIZE) {
 		chacha20_block(state, stream);
-		crypto_xor(dst, (const u8 *)stream, CHACHA20_BLOCK_SIZE);
+		crypto_xor(dst, stream, CHACHA20_BLOCK_SIZE);
 		bytes -= CHACHA20_BLOCK_SIZE;
 		dst += CHACHA20_BLOCK_SIZE;
 	}
 	if (bytes) {
 		chacha20_block(state, stream);
-		crypto_xor(dst, (const u8 *)stream, bytes);
+		crypto_xor(dst, stream, bytes);
 	}
 }
 
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -486,9 +486,9 @@ static int crng_init_cnt = 0;
 static unsigned long crng_global_init_time = 0;
 #define CRNG_INIT_CNT_THRESH (2*CHACHA20_KEY_SIZE)
 static void _extract_crng(struct crng_state *crng,
-			  __u32 out[CHACHA20_BLOCK_WORDS]);
+			  __u8 out[CHACHA20_BLOCK_SIZE]);
 static void _crng_backtrack_protect(struct crng_state *crng,
-				    __u32 tmp[CHACHA20_BLOCK_WORDS], int used);
+				    __u8 tmp[CHACHA20_BLOCK_SIZE], int used);
 static void process_random_ready_list(void);
 static void _get_random_bytes(void *buf, int nbytes);
 
@@ -1038,7 +1038,7 @@ static void crng_reseed(struct crng_stat
 	unsigned long	flags;
 	int		i, num;
 	union {
-		__u32	block[CHACHA20_BLOCK_WORDS];
+		__u8	block[CHACHA20_BLOCK_SIZE];
 		__u32	key[8];
 	} buf;
 
@@ -1066,7 +1066,7 @@ static void crng_reseed(struct crng_stat
 }
 
 static void _extract_crng(struct crng_state *crng,
-			  __u32 out[CHACHA20_BLOCK_WORDS])
+			  __u8 out[CHACHA20_BLOCK_SIZE])
 {
 	unsigned long flags, init_time;
 
@@ -1084,7 +1084,7 @@ static void _extract_crng(struct crng_st
 	spin_unlock_irqrestore(&crng->lock, flags);
 }
 
-static void extract_crng(__u32 out[CHACHA20_BLOCK_WORDS])
+static void extract_crng(__u8 out[CHACHA20_BLOCK_SIZE])
 {
 	_extract_crng(select_crng(), out);
 }
@@ -1094,7 +1094,7 @@ static void extract_crng(__u32 out[CHACH
  * enough) to mutate the CRNG key to provide backtracking protection.
  */
 static void _crng_backtrack_protect(struct crng_state *crng,
-				    __u32 tmp[CHACHA20_BLOCK_WORDS], int used)
+				    __u8 tmp[CHACHA20_BLOCK_SIZE], int used)
 {
 	unsigned long	flags;
 	__u32		*s, *d;
@@ -1106,14 +1106,14 @@ static void _crng_backtrack_protect(stru
 		used = 0;
 	}
 	spin_lock_irqsave(&crng->lock, flags);
-	s = &tmp[used / sizeof(__u32)];
+	s = (__u32 *) &tmp[used];
 	d = &crng->state[4];
 	for (i=0; i < 8; i++)
 		*d++ ^= *s++;
 	spin_unlock_irqrestore(&crng->lock, flags);
 }
 
-static void crng_backtrack_protect(__u32 tmp[CHACHA20_BLOCK_WORDS], int used)
+static void crng_backtrack_protect(__u8 tmp[CHACHA20_BLOCK_SIZE], int used)
 {
 	_crng_backtrack_protect(select_crng(), tmp, used);
 }
@@ -1121,7 +1121,7 @@ static void crng_backtrack_protect(__u32
 static ssize_t extract_crng_user(void __user *buf, size_t nbytes)
 {
 	ssize_t ret = 0, i = CHACHA20_BLOCK_SIZE;
-	__u32 tmp[CHACHA20_BLOCK_WORDS];
+	__u8 tmp[CHACHA20_BLOCK_SIZE] __aligned(4);
 	int large_request = (nbytes > 256);
 
 	while (nbytes) {
@@ -1580,7 +1580,7 @@ static void _warn_unseeded_randomness(co
  */
 static void _get_random_bytes(void *buf, int nbytes)
 {
-	__u32 tmp[CHACHA20_BLOCK_WORDS];
+	__u8 tmp[CHACHA20_BLOCK_SIZE] __aligned(4);
 
 	trace_get_random_bytes(nbytes, _RET_IP_);
 
@@ -2167,7 +2167,7 @@ u64 get_random_u64(void)
 	batch = raw_cpu_ptr(&batched_entropy_u64);
 	spin_lock_irqsave(&batch->batch_lock, flags);
 	if (batch->position % ARRAY_SIZE(batch->entropy_u64) == 0) {
-		extract_crng((__u32 *)batch->entropy_u64);
+		extract_crng((u8 *)batch->entropy_u64);
 		batch->position = 0;
 	}
 	ret = batch->entropy_u64[batch->position++];
@@ -2191,7 +2191,7 @@ u32 get_random_u32(void)
 	batch = raw_cpu_ptr(&batched_entropy_u32);
 	spin_lock_irqsave(&batch->batch_lock, flags);
 	if (batch->position % ARRAY_SIZE(batch->entropy_u32) == 0) {
-		extract_crng(batch->entropy_u32);
+		extract_crng((u8 *)batch->entropy_u32);
 		batch->position = 0;
 	}
 	ret = batch->entropy_u32[batch->position++];
--- a/include/crypto/chacha20.h
+++ b/include/crypto/chacha20.h
@@ -11,13 +11,12 @@
 #define CHACHA20_IV_SIZE	16
 #define CHACHA20_KEY_SIZE	32
 #define CHACHA20_BLOCK_SIZE	64
-#define CHACHA20_BLOCK_WORDS	(CHACHA20_BLOCK_SIZE / sizeof(u32))
 
 struct chacha20_ctx {
 	u32 key[8];
 };
 
-void chacha20_block(u32 *state, u32 *stream);
+void chacha20_block(u32 *state, u8 *stream);
 void crypto_chacha20_init(u32 *state, struct chacha20_ctx *ctx, u8 *iv);
 int crypto_chacha20_setkey(struct crypto_tfm *tfm, const u8 *key,
 			   unsigned int keysize);
--- a/lib/chacha20.c
+++ b/lib/chacha20.c
@@ -21,9 +21,9 @@ static inline u32 rotl32(u32 v, u8 n)
 	return (v << n) | (v >> (sizeof(v) * 8 - n));
 }
 
-void chacha20_block(u32 *state, u32 *stream)
+void chacha20_block(u32 *state, u8 *stream)
 {
-	u32 x[16], *out = stream;
+	u32 x[16];
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(x); i++)
@@ -72,7 +72,7 @@ void chacha20_block(u32 *state, u32 *str
 	}
 
 	for (i = 0; i < ARRAY_SIZE(x); i++)
-		out[i] = cpu_to_le32(x[i] + state[i]);
+		put_unaligned_le32(x[i] + state[i], &stream[i * sizeof(u32)]);
 
 	state[12]++;
 }


