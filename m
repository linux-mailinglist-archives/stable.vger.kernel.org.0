Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EE36558246
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:13:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbiFWRNa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:13:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbiFWRLk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:11:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D78D220E2;
        Thu, 23 Jun 2022 09:51:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0F273B8248F;
        Thu, 23 Jun 2022 16:51:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6695AC3411B;
        Thu, 23 Jun 2022 16:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656003100;
        bh=ul0Tr7WeKZRZ2zms9/BEfRG9dytBHmQ8wW4LyYO8XdA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dD/CDDrmPhMEcjaCJnRGTHI5UNol/I2u/KVD6gbARWFdfBQDJBZ2uNCcODKpXJae7
         VhHJlfSDf2F76FTzbHQx4ZZNw5nAEPQFRCSLjCozqdk9Q6U0itXEJvXGcRDmLCCS/N
         8sb2JpVGzpZkwYlDyU7/WB+ObIrTze6gLQciti3Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, linux-crypto@vger.kernel.org,
        Andy Lutomirski <luto@kernel.org>,
        Jann Horn <jannh@google.com>, Theodore Tso <tytso@mit.edu>,
        Ard Biesheuvel <ardb@kernel.org>,
        Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.9 089/264] random: initialize ChaCha20 constants with correct endianness
Date:   Thu, 23 Jun 2022 18:41:22 +0200
Message-Id: <20220623164346.589601245@linuxfoundation.org>
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

commit a181e0fdb2164268274453b5b291589edbb9b22d upstream.

On big endian CPUs, the ChaCha20-based CRNG is using the wrong
endianness for the ChaCha20 constants.

This doesn't matter cryptographically, but technically it means it's not
ChaCha20 anymore.  Fix it to always use the standard constants.

Cc: linux-crypto@vger.kernel.org
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c     |    4 ++--
 include/crypto/chacha20.h |    8 ++++++++
 2 files changed, 10 insertions(+), 2 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -817,7 +817,7 @@ static bool __init crng_init_try_arch_ea
 
 static void crng_initialize_secondary(struct crng_state *crng)
 {
-	memcpy(&crng->state[0], "expand 32-byte k", 16);
+	chacha_init_consts(crng->state);
 	_get_random_bytes(&crng->state[4], sizeof(__u32) * 12);
 	crng_init_try_arch(crng);
 	crng->init_time = jiffies - CRNG_RESEED_INTERVAL - 1;
@@ -825,7 +825,7 @@ static void crng_initialize_secondary(st
 
 static void __init crng_initialize_primary(struct crng_state *crng)
 {
-	memcpy(&crng->state[0], "expand 32-byte k", 16);
+	chacha_init_consts(crng->state);
 	_extract_entropy(&input_pool, &crng->state[4], sizeof(__u32) * 12, 0);
 	if (crng_init_try_arch_early(crng) && trust_cpu && crng_init < 2) {
 		invalidate_batched_entropy();
--- a/include/crypto/chacha20.h
+++ b/include/crypto/chacha20.h
@@ -24,4 +24,12 @@ int crypto_chacha20_setkey(struct crypto
 int crypto_chacha20_crypt(struct blkcipher_desc *desc, struct scatterlist *dst,
 			  struct scatterlist *src, unsigned int nbytes);
 
+static inline void chacha_init_consts(u32 *state)
+{
+	state[0]  = 0x61707865; /* "expa" */
+	state[1]  = 0x3320646e; /* "nd 3" */
+	state[2]  = 0x79622d32; /* "2-by" */
+	state[3]  = 0x6b206574; /* "te k" */
+}
+
 #endif


