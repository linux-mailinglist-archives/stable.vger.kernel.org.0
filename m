Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BCA71014CF
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:38:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727780AbfKSFhl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:37:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:59516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729521AbfKSFhk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:37:40 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E0CCA206EC;
        Tue, 19 Nov 2019 05:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141859;
        bh=sJpkFUrgohK/C7vqVYjIlffCWI2Cx3yz6dcd7eNIJfg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SUMGuLouNJAQKpR+OpxI/b9H6ew+7bk8U8vyiZoasJ43Tt3LQCuRiUtYnkq7LPoyL
         1kVDeFJJkrIphpDbXrxroXo1sY0QuYZ+/DgAfFS+iebFCJOghPe9PJdg2ZpJxP7M/d
         DLrYGmd1EnuMJV1Ke1oePj2q660zR81Tb/t/A0Mo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Stephan=20M=C3=BCller?= <smueller@chronox.de>,
        Theodore Tso <tytso@mit.edu>,
        Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 304/422] crypto: chacha20 - Fix chacha20_block() keystream alignment (again)
Date:   Tue, 19 Nov 2019 06:18:21 +0100
Message-Id: <20191119051418.700027527@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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
---
 crypto/chacha20_generic.c |  7 ++++---
 drivers/char/random.c     | 24 ++++++++++++------------
 include/crypto/chacha20.h |  3 +--
 lib/chacha20.c            |  6 +++---
 4 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/crypto/chacha20_generic.c b/crypto/chacha20_generic.c
index e451c3cb6a56e..3ae96587caf9a 100644
--- a/crypto/chacha20_generic.c
+++ b/crypto/chacha20_generic.c
@@ -18,20 +18,21 @@
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
 
diff --git a/drivers/char/random.c b/drivers/char/random.c
index 0a84b7f468ad0..86fe1df902393 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -433,9 +433,9 @@ static int crng_init_cnt = 0;
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
 
@@ -929,7 +929,7 @@ static void crng_reseed(struct crng_state *crng, struct entropy_store *r)
 	unsigned long	flags;
 	int		i, num;
 	union {
-		__u32	block[CHACHA20_BLOCK_WORDS];
+		__u8	block[CHACHA20_BLOCK_SIZE];
 		__u32	key[8];
 	} buf;
 
@@ -976,7 +976,7 @@ static void crng_reseed(struct crng_state *crng, struct entropy_store *r)
 }
 
 static void _extract_crng(struct crng_state *crng,
-			  __u32 out[CHACHA20_BLOCK_WORDS])
+			  __u8 out[CHACHA20_BLOCK_SIZE])
 {
 	unsigned long v, flags;
 
@@ -993,7 +993,7 @@ static void _extract_crng(struct crng_state *crng,
 	spin_unlock_irqrestore(&crng->lock, flags);
 }
 
-static void extract_crng(__u32 out[CHACHA20_BLOCK_WORDS])
+static void extract_crng(__u8 out[CHACHA20_BLOCK_SIZE])
 {
 	struct crng_state *crng = NULL;
 
@@ -1011,7 +1011,7 @@ static void extract_crng(__u32 out[CHACHA20_BLOCK_WORDS])
  * enough) to mutate the CRNG key to provide backtracking protection.
  */
 static void _crng_backtrack_protect(struct crng_state *crng,
-				    __u32 tmp[CHACHA20_BLOCK_WORDS], int used)
+				    __u8 tmp[CHACHA20_BLOCK_SIZE], int used)
 {
 	unsigned long	flags;
 	__u32		*s, *d;
@@ -1023,14 +1023,14 @@ static void _crng_backtrack_protect(struct crng_state *crng,
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
 	struct crng_state *crng = NULL;
 
@@ -1046,7 +1046,7 @@ static void crng_backtrack_protect(__u32 tmp[CHACHA20_BLOCK_WORDS], int used)
 static ssize_t extract_crng_user(void __user *buf, size_t nbytes)
 {
 	ssize_t ret = 0, i = CHACHA20_BLOCK_SIZE;
-	__u32 tmp[CHACHA20_BLOCK_WORDS];
+	__u8 tmp[CHACHA20_BLOCK_SIZE] __aligned(4);
 	int large_request = (nbytes > 256);
 
 	while (nbytes) {
@@ -1625,7 +1625,7 @@ static void _warn_unseeded_randomness(const char *func_name, void *caller,
  */
 static void _get_random_bytes(void *buf, int nbytes)
 {
-	__u32 tmp[CHACHA20_BLOCK_WORDS];
+	__u8 tmp[CHACHA20_BLOCK_SIZE] __aligned(4);
 
 	trace_get_random_bytes(nbytes, _RET_IP_);
 
@@ -2251,7 +2251,7 @@ u64 get_random_u64(void)
 	batch = raw_cpu_ptr(&batched_entropy_u64);
 	spin_lock_irqsave(&batch->batch_lock, flags);
 	if (batch->position % ARRAY_SIZE(batch->entropy_u64) == 0) {
-		extract_crng((__u32 *)batch->entropy_u64);
+		extract_crng((u8 *)batch->entropy_u64);
 		batch->position = 0;
 	}
 	ret = batch->entropy_u64[batch->position++];
@@ -2278,7 +2278,7 @@ u32 get_random_u32(void)
 	batch = raw_cpu_ptr(&batched_entropy_u32);
 	spin_lock_irqsave(&batch->batch_lock, flags);
 	if (batch->position % ARRAY_SIZE(batch->entropy_u32) == 0) {
-		extract_crng(batch->entropy_u32);
+		extract_crng((u8 *)batch->entropy_u32);
 		batch->position = 0;
 	}
 	ret = batch->entropy_u32[batch->position++];
diff --git a/include/crypto/chacha20.h b/include/crypto/chacha20.h
index b83d66073db03..f76302d99e2be 100644
--- a/include/crypto/chacha20.h
+++ b/include/crypto/chacha20.h
@@ -13,13 +13,12 @@
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
 int crypto_chacha20_setkey(struct crypto_skcipher *tfm, const u8 *key,
 			   unsigned int keysize);
diff --git a/lib/chacha20.c b/lib/chacha20.c
index c1cc50fb68c9f..d907fec6a9ed1 100644
--- a/lib/chacha20.c
+++ b/lib/chacha20.c
@@ -16,9 +16,9 @@
 #include <asm/unaligned.h>
 #include <crypto/chacha20.h>
 
-void chacha20_block(u32 *state, u32 *stream)
+void chacha20_block(u32 *state, u8 *stream)
 {
-	u32 x[16], *out = stream;
+	u32 x[16];
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(x); i++)
@@ -67,7 +67,7 @@ void chacha20_block(u32 *state, u32 *stream)
 	}
 
 	for (i = 0; i < ARRAY_SIZE(x); i++)
-		out[i] = cpu_to_le32(x[i] + state[i]);
+		put_unaligned_le32(x[i] + state[i], &stream[i * sizeof(u32)]);
 
 	state[12]++;
 }
-- 
2.20.1



