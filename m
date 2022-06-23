Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3880455836F
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233940AbiFWR34 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:29:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234053AbiFWR1l (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:27:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DBCC50E33;
        Thu, 23 Jun 2022 10:03:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C6F9AB82490;
        Thu, 23 Jun 2022 17:03:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24F15C3411B;
        Thu, 23 Jun 2022 17:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656003809;
        bh=qJdPth1RNSliaVcSdczyEdTfLg3I4/v2P+/87vBkOMA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1MWm/NWv0ubjs9AtosHJ0FDUB4p79CEZjFBz/JMzOGgOcsz9JizGApw+KxQ6pZF6O
         ICnRy5KAIAyzy9FneR+VDpjnY5gOQyXcnkyVpwgxYeSY8q3lgqnnRvukRh1qkDrFyp
         3oeOL9qTGJgnKqiDqCX+sOiHO11Eu4kuGHXtAD18=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        Andre Przywara <andre.przywara@arm.com>,
        Eric Biggers <ebiggers@google.com>,
        Marc Zyngier <maz@kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 4.14 054/237] random: avoid arch_get_random_seed_long() when collecting IRQ randomness
Date:   Thu, 23 Jun 2022 18:41:28 +0200
Message-Id: <20220623164344.707891226@linuxfoundation.org>
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

From: Ard Biesheuvel <ardb@kernel.org>

commit 390596c9959c2a4f5b456df339f0604df3d55fe0 upstream.

When reseeding the CRNG periodically, arch_get_random_seed_long() is
called to obtain entropy from an architecture specific source if one
is implemented. In most cases, these are special instructions, but in
some cases, such as on ARM, we may want to back this using firmware
calls, which are considerably more expensive.

Another call to arch_get_random_seed_long() exists in the CRNG driver,
in add_interrupt_randomness(), which collects entropy by capturing
inter-interrupt timing and relying on interrupt jitter to provide
random bits. This is done by keeping a per-CPU state, and mixing in
the IRQ number, the cycle counter and the return address every time an
interrupt is taken, and mixing this per-CPU state into the entropy pool
every 64 invocations, or at least once per second. The entropy that is
gathered this way is credited as 1 bit of entropy. Every time this
happens, arch_get_random_seed_long() is invoked, and the result is
mixed in as well, and also credited with 1 bit of entropy.

This means that arch_get_random_seed_long() is called at least once
per second on every CPU, which seems excessive, and doesn't really
scale, especially in a virtualization scenario where CPUs may be
oversubscribed: in cases where arch_get_random_seed_long() is backed
by an instruction that actually goes back to a shared hardware entropy
source (such as RNDRRS on ARM), we will end up hitting it hundreds of
times per second.

So let's drop the call to arch_get_random_seed_long() from
add_interrupt_randomness(), and instead, rely on crng_reseed() to call
the arch hook to get random seed material from the platform.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Tested-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Acked-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Jason A. Donenfeld <Jason@zx2c4.com>
Link: https://lore.kernel.org/r/20201105152944.16953-1-ardb@kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |   15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1279,8 +1279,6 @@ void add_interrupt_randomness(int irq, i
 	cycles_t		cycles = random_get_entropy();
 	__u32			c_high, j_high;
 	__u64			ip;
-	unsigned long		seed;
-	int			credit = 0;
 
 	if (cycles == 0)
 		cycles = get_reg(fast_pool, regs);
@@ -1316,23 +1314,12 @@ void add_interrupt_randomness(int irq, i
 
 	fast_pool->last = now;
 	__mix_pool_bytes(r, &fast_pool->pool, sizeof(fast_pool->pool));
-
-	/*
-	 * If we have architectural seed generator, produce a seed and
-	 * add it to the pool.  For the sake of paranoia don't let the
-	 * architectural seed generator dominate the input from the
-	 * interrupt noise.
-	 */
-	if (arch_get_random_seed_long(&seed)) {
-		__mix_pool_bytes(r, &seed, sizeof(seed));
-		credit = 1;
-	}
 	spin_unlock(&r->lock);
 
 	fast_pool->count = 0;
 
 	/* award one bit for the contents of the fast pool */
-	credit_entropy_bits(r, credit + 1);
+	credit_entropy_bits(r, 1);
 }
 EXPORT_SYMBOL_GPL(add_interrupt_randomness);
 


