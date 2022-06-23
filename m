Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F803558270
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:14:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231585AbiFWROX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:14:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233795AbiFWRNW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:13:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 023904F1D1;
        Thu, 23 Jun 2022 09:59:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 87EAE60AE7;
        Thu, 23 Jun 2022 16:59:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C257C3411B;
        Thu, 23 Jun 2022 16:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656003546;
        bh=sySnz3P5M8+iE6nn71P7rAeB498H1szpACM3pBtmXCc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MvSyf5p+WyaOP3L9jS2ikgica2AgMDz2d+wrQPXdU/v6L6IznqOELNFWH7ZU9Gtdo
         xJ4uIyUGok381TmwJin5uBUfrMSbX3mrDzK7coYclyviVqEWIKMvsd1gkec5yo+Po4
         IAB4llHykCFESBqQo5pAO7tP/ZDeI1MIQ6I9GGTI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.14 002/237] crypto: chacha20 - Fix keystream alignment for chacha20_block()
Date:   Thu, 23 Jun 2022 18:40:36 +0200
Message-Id: <20220623164343.208539228@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164343.132308638@linuxfoundation.org>
References: <20220623164343.132308638@linuxfoundation.org>
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

commit 9f480faec58cd6197a007ea1dcac6b7c3daf1139 upstream.

When chacha20_block() outputs the keystream block, it uses 'u32' stores
directly.  However, the callers (crypto/chacha20_generic.c and
drivers/char/random.c) declare the keystream buffer as a 'u8' array,
which is not guaranteed to have the needed alignment.

Fix it by having both callers declare the keystream as a 'u32' array.
For now this is preferable to switching over to the unaligned access
macros because chacha20_block() is only being used in cases where we can
easily control the alignment (stack buffers).

Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/chacha20_generic.c |    6 +++---
 drivers/char/random.c     |   24 ++++++++++++------------
 include/crypto/chacha20.h |    3 ++-
 lib/chacha20.c            |    2 +-
 4 files changed, 18 insertions(+), 17 deletions(-)

--- a/crypto/chacha20_generic.c
+++ b/crypto/chacha20_generic.c
@@ -22,20 +22,20 @@ static inline u32 le32_to_cpuvp(const vo
 static void chacha20_docrypt(u32 *state, u8 *dst, const u8 *src,
 			     unsigned int bytes)
 {
-	u8 stream[CHACHA20_BLOCK_SIZE];
+	u32 stream[CHACHA20_BLOCK_WORDS];
 
 	if (dst != src)
 		memcpy(dst, src, bytes);
 
 	while (bytes >= CHACHA20_BLOCK_SIZE) {
 		chacha20_block(state, stream);
-		crypto_xor(dst, stream, CHACHA20_BLOCK_SIZE);
+		crypto_xor(dst, (const u8 *)stream, CHACHA20_BLOCK_SIZE);
 		bytes -= CHACHA20_BLOCK_SIZE;
 		dst += CHACHA20_BLOCK_SIZE;
 	}
 	if (bytes) {
 		chacha20_block(state, stream);
-		crypto_xor(dst, stream, bytes);
+		crypto_xor(dst, (const u8 *)stream, bytes);
 	}
 }
 
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -433,9 +433,9 @@ static int crng_init_cnt = 0;
 static unsigned long crng_global_init_time = 0;
 #define CRNG_INIT_CNT_THRESH (2*CHACHA20_KEY_SIZE)
 static void _extract_crng(struct crng_state *crng,
-			  __u8 out[CHACHA20_BLOCK_SIZE]);
+			  __u32 out[CHACHA20_BLOCK_WORDS]);
 static void _crng_backtrack_protect(struct crng_state *crng,
-				    __u8 tmp[CHACHA20_BLOCK_SIZE], int used);
+				    __u32 tmp[CHACHA20_BLOCK_WORDS], int used);
 static void process_random_ready_list(void);
 static void _get_random_bytes(void *buf, int nbytes);
 
@@ -929,7 +929,7 @@ static void crng_reseed(struct crng_stat
 	unsigned long	flags;
 	int		i, num;
 	union {
-		__u8	block[CHACHA20_BLOCK_SIZE];
+		__u32	block[CHACHA20_BLOCK_WORDS];
 		__u32	key[8];
 	} buf;
 
@@ -976,7 +976,7 @@ static void crng_reseed(struct crng_stat
 }
 
 static void _extract_crng(struct crng_state *crng,
-			  __u8 out[CHACHA20_BLOCK_SIZE])
+			  __u32 out[CHACHA20_BLOCK_WORDS])
 {
 	unsigned long v, flags, init_time;
 
@@ -996,7 +996,7 @@ static void _extract_crng(struct crng_st
 	spin_unlock_irqrestore(&crng->lock, flags);
 }
 
-static void extract_crng(__u8 out[CHACHA20_BLOCK_SIZE])
+static void extract_crng(__u32 out[CHACHA20_BLOCK_WORDS])
 {
 	_extract_crng(select_crng(), out);
 }
@@ -1006,7 +1006,7 @@ static void extract_crng(__u8 out[CHACHA
  * enough) to mutate the CRNG key to provide backtracking protection.
  */
 static void _crng_backtrack_protect(struct crng_state *crng,
-				    __u8 tmp[CHACHA20_BLOCK_SIZE], int used)
+				    __u32 tmp[CHACHA20_BLOCK_WORDS], int used)
 {
 	unsigned long	flags;
 	__u32		*s, *d;
@@ -1018,14 +1018,14 @@ static void _crng_backtrack_protect(stru
 		used = 0;
 	}
 	spin_lock_irqsave(&crng->lock, flags);
-	s = (__u32 *) &tmp[used];
+	s = &tmp[used / sizeof(__u32)];
 	d = &crng->state[4];
 	for (i=0; i < 8; i++)
 		*d++ ^= *s++;
 	spin_unlock_irqrestore(&crng->lock, flags);
 }
 
-static void crng_backtrack_protect(__u8 tmp[CHACHA20_BLOCK_SIZE], int used)
+static void crng_backtrack_protect(__u32 tmp[CHACHA20_BLOCK_WORDS], int used)
 {
 	_crng_backtrack_protect(select_crng(), tmp, used);
 }
@@ -1033,7 +1033,7 @@ static void crng_backtrack_protect(__u8
 static ssize_t extract_crng_user(void __user *buf, size_t nbytes)
 {
 	ssize_t ret = 0, i = CHACHA20_BLOCK_SIZE;
-	__u8 tmp[CHACHA20_BLOCK_SIZE];
+	__u32 tmp[CHACHA20_BLOCK_WORDS];
 	int large_request = (nbytes > 256);
 
 	while (nbytes) {
@@ -1619,7 +1619,7 @@ static void _warn_unseeded_randomness(co
  */
 static void _get_random_bytes(void *buf, int nbytes)
 {
-	__u8 tmp[CHACHA20_BLOCK_SIZE];
+	__u32 tmp[CHACHA20_BLOCK_WORDS];
 
 	trace_get_random_bytes(nbytes, _RET_IP_);
 
@@ -2220,7 +2220,7 @@ u64 get_random_u64(void)
 	batch = raw_cpu_ptr(&batched_entropy_u64);
 	spin_lock_irqsave(&batch->batch_lock, flags);
 	if (batch->position % ARRAY_SIZE(batch->entropy_u64) == 0) {
-		extract_crng((u8 *)batch->entropy_u64);
+		extract_crng((__u32 *)batch->entropy_u64);
 		batch->position = 0;
 	}
 	ret = batch->entropy_u64[batch->position++];
@@ -2244,7 +2244,7 @@ u32 get_random_u32(void)
 	batch = raw_cpu_ptr(&batched_entropy_u32);
 	spin_lock_irqsave(&batch->batch_lock, flags);
 	if (batch->position % ARRAY_SIZE(batch->entropy_u32) == 0) {
-		extract_crng((u8 *)batch->entropy_u32);
+		extract_crng(batch->entropy_u32);
 		batch->position = 0;
 	}
 	ret = batch->entropy_u32[batch->position++];
--- a/include/crypto/chacha20.h
+++ b/include/crypto/chacha20.h
@@ -13,12 +13,13 @@
 #define CHACHA20_IV_SIZE	16
 #define CHACHA20_KEY_SIZE	32
 #define CHACHA20_BLOCK_SIZE	64
+#define CHACHA20_BLOCK_WORDS	(CHACHA20_BLOCK_SIZE / sizeof(u32))
 
 struct chacha20_ctx {
 	u32 key[8];
 };
 
-void chacha20_block(u32 *state, void *stream);
+void chacha20_block(u32 *state, u32 *stream);
 void crypto_chacha20_init(u32 *state, struct chacha20_ctx *ctx, u8 *iv);
 int crypto_chacha20_setkey(struct crypto_skcipher *tfm, const u8 *key,
 			   unsigned int keysize);
--- a/lib/chacha20.c
+++ b/lib/chacha20.c
@@ -21,7 +21,7 @@ static inline u32 rotl32(u32 v, u8 n)
 	return (v << n) | (v >> (sizeof(v) * 8 - n));
 }
 
-extern void chacha20_block(u32 *state, void *stream)
+void chacha20_block(u32 *state, u32 *stream)
 {
 	u32 x[16], *out = stream;
 	int i;


