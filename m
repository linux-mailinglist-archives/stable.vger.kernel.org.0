Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB4EC558335
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:26:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233779AbiFWR0m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:26:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233721AbiFWR0E (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:26:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 015CA60E1D;
        Thu, 23 Jun 2022 10:02:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D8BACB82499;
        Thu, 23 Jun 2022 17:02:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29291C3411B;
        Thu, 23 Jun 2022 17:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656003732;
        bh=qXsYGoR1t0CL5JL5sr9cGk3RObDh3UTS4Upx2JnJ39M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dCgvIjVR2dWcXOxSN/8nAQ1dm5PwD/7DO3srW1CggIuBAXj3fmz2SgY68Ezi56Jpu
         G59cbCgzI8niEfG+SIHj9oBS1F7rCluQPc5sq9SO+FWB3CVekfbp3A09jxNjJ+f6he
         h5tPU9ozGCJbsQ1vBw3pqdN6s72E3wGs1WGVJk+w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        Ard Biesheuvel <ardb@kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.14 069/237] random: avoid superfluous call to RDRAND in CRNG extraction
Date:   Thu, 23 Jun 2022 18:41:43 +0200
Message-Id: <20220623164345.140271275@linuxfoundation.org>
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

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

commit 2ee25b6968b1b3c66ffa408de23d023c1bce81cf upstream.

RDRAND is not fast. RDRAND is actually quite slow. We've known this for
a while, which is why functions like get_random_u{32,64} were converted
to use batching of our ChaCha-based CRNG instead.

Yet CRNG extraction still includes a call to RDRAND, in the hot path of
every call to get_random_bytes(), /dev/urandom, and getrandom(2).

This call to RDRAND here seems quite superfluous. CRNG is already
extracting things based on a 256-bit key, based on good entropy, which
is then reseeded periodically, updated, backtrack-mutated, and so
forth. The CRNG extraction construction is something that we're already
relying on to be secure and solid. If it's not, that's a serious
problem, and it's unlikely that mixing in a measly 32 bits from RDRAND
is going to alleviate things.

And in the case where the CRNG doesn't have enough entropy yet, we're
already initializing the ChaCha key row with RDRAND in
crng_init_try_arch_early().

Removing the call to RDRAND improves performance on an i7-11850H by
370%. In other words, the vast majority of the work done by
extract_crng() prior to this commit was devoted to fetching 32 bits of
RDRAND.

Reviewed-by: Theodore Ts'o <tytso@mit.edu>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1022,7 +1022,7 @@ static void crng_reseed(struct crng_stat
 static void _extract_crng(struct crng_state *crng,
 			  __u32 out[CHACHA20_BLOCK_WORDS])
 {
-	unsigned long v, flags, init_time;
+	unsigned long flags, init_time;
 
 	if (crng_ready()) {
 		init_time = READ_ONCE(crng->init_time);
@@ -1032,8 +1032,6 @@ static void _extract_crng(struct crng_st
 				    &input_pool : NULL);
 	}
 	spin_lock_irqsave(&crng->lock, flags);
-	if (arch_get_random_long(&v))
-		crng->state[14] ^= v;
 	chacha20_block(&crng->state[0], out);
 	if (crng->state[12] == 0)
 		crng->state[13]++;


