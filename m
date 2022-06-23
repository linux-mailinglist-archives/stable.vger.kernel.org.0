Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8857355809F
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 18:53:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232161AbiFWQwq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 12:52:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233908AbiFWQvv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 12:51:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C8E622528;
        Thu, 23 Jun 2022 09:51:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D7CCC61F99;
        Thu, 23 Jun 2022 16:51:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 911BCC3411B;
        Thu, 23 Jun 2022 16:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656003104;
        bh=YeNRPLQirCRMpKZCkSJM58Mq2rDxBOANPUcuKe7qKZ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UwaI/4wtUMb0iaPV1r7DsDpGm4KH1n26Wx3xxW07lAYPHbWMeoxxYT6hI4VAYnd4q
         YPGjXOezcue0OKDGSkbKSEY5+/oNgKVQwlEm+Qnmg6wJFq3RkZuP5n9CrD5Tr+5hM+
         4GZbAiVMsc+RTgdo9XiM/r0J/BfQaUMRwaokbVX8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.9 090/264] random: early initialization of ChaCha constants
Date:   Thu, 23 Jun 2022 18:41:23 +0200
Message-Id: <20220623164346.617837400@linuxfoundation.org>
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

From: Dominik Brodowski <linux@dominikbrodowski.net>

commit 96562f286884e2db89c74215b199a1084b5fb7f7 upstream.

Previously, the ChaCha constants for the primary pool were only
initialized in crng_initialize_primary(), called by rand_initialize().
However, some randomness is actually extracted from the primary pool
beforehand, e.g. by kmem_cache_create(). Therefore, statically
initialize the ChaCha constants for the primary pool.

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: <linux-crypto@vger.kernel.org>
Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c     |    5 ++++-
 include/crypto/chacha20.h |   15 +++++++++++----
 2 files changed, 15 insertions(+), 5 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -459,6 +459,10 @@ struct crng_state {
 
 static struct crng_state primary_crng = {
 	.lock = __SPIN_LOCK_UNLOCKED(primary_crng.lock),
+	.state[0] = CHACHA_CONSTANT_EXPA,
+	.state[1] = CHACHA_CONSTANT_ND_3,
+	.state[2] = CHACHA_CONSTANT_2_BY,
+	.state[3] = CHACHA_CONSTANT_TE_K,
 };
 
 /*
@@ -825,7 +829,6 @@ static void crng_initialize_secondary(st
 
 static void __init crng_initialize_primary(struct crng_state *crng)
 {
-	chacha_init_consts(crng->state);
 	_extract_entropy(&input_pool, &crng->state[4], sizeof(__u32) * 12, 0);
 	if (crng_init_try_arch_early(crng) && trust_cpu && crng_init < 2) {
 		invalidate_batched_entropy();
--- a/include/crypto/chacha20.h
+++ b/include/crypto/chacha20.h
@@ -24,12 +24,19 @@ int crypto_chacha20_setkey(struct crypto
 int crypto_chacha20_crypt(struct blkcipher_desc *desc, struct scatterlist *dst,
 			  struct scatterlist *src, unsigned int nbytes);
 
+enum chacha_constants { /* expand 32-byte k */
+	CHACHA_CONSTANT_EXPA = 0x61707865U,
+	CHACHA_CONSTANT_ND_3 = 0x3320646eU,
+	CHACHA_CONSTANT_2_BY = 0x79622d32U,
+	CHACHA_CONSTANT_TE_K = 0x6b206574U
+};
+
 static inline void chacha_init_consts(u32 *state)
 {
-	state[0]  = 0x61707865; /* "expa" */
-	state[1]  = 0x3320646e; /* "nd 3" */
-	state[2]  = 0x79622d32; /* "2-by" */
-	state[3]  = 0x6b206574; /* "te k" */
+	state[0]  = CHACHA_CONSTANT_EXPA;
+	state[1]  = CHACHA_CONSTANT_ND_3;
+	state[2]  = CHACHA_CONSTANT_2_BY;
+	state[3]  = CHACHA_CONSTANT_TE_K;
 }
 
 #endif


