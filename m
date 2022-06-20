Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85D18551C1D
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:48:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347172AbiFTNkQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:40:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348933AbiFTNj3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:39:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C642029C9F;
        Mon, 20 Jun 2022 06:14:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4696FB811A6;
        Mon, 20 Jun 2022 13:14:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89B95C3411B;
        Mon, 20 Jun 2022 13:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655730886;
        bh=fKgfR6flzF5DJIV2YmCbSUGpxsRRFCaze5qDxLnICJQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fb3K6b1uY9JT8YbQOfmHyllDEdtGmHY7l9V21sdZgmNmrcQx3FWydp0bHv4Vtnt9X
         WwkT67lKSHIKPZ+obu7mEShaVMoQn3nKBXWZwcO9+cLFEzl88O8veHX21n6HqD0Q/B
         DqqqMNuPprPfW5gFHfGeyqEpNJaFHGb0bf84zytI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        Eric Biggers <ebiggers@google.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.4 086/240] random: remove ifdefd out interrupt bench
Date:   Mon, 20 Jun 2022 14:49:47 +0200
Message-Id: <20220620124741.473473701@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124737.799371052@linuxfoundation.org>
References: <20220620124737.799371052@linuxfoundation.org>
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

commit 95e6060c20a7f5db60163274c5222a725ac118f9 upstream.

With tools like kbench9000 giving more finegrained responses, and this
basically never having been used ever since it was initially added,
let's just get rid of this. There *is* still work to be done on the
interrupt handler, but this really isn't the way it's being developed.

Cc: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Reviewed-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/admin-guide/sysctl/kernel.rst |    9 ------
 drivers/char/random.c                       |   40 ----------------------------
 2 files changed, 49 deletions(-)

--- a/Documentation/admin-guide/sysctl/kernel.rst
+++ b/Documentation/admin-guide/sysctl/kernel.rst
@@ -893,15 +893,6 @@ This is a directory, with the following
   are woken up. This file is writable for compatibility purposes, but
   writing to it has no effect on any RNG behavior.
 
-If ``drivers/char/random.c`` is built with ``ADD_INTERRUPT_BENCH``
-defined, these additional entries are present:
-
-* ``add_interrupt_avg_cycles``: the average number of cycles between
-  interrupts used to feed the pool;
-
-* ``add_interrupt_avg_deviation``: the standard deviation seen on the
-  number of cycles between interrupts used to feed the pool.
-
 
 randomize_va_space
 ==================
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -240,8 +240,6 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/random.h>
 
-/* #define ADD_INTERRUPT_BENCH */
-
 enum {
 	POOL_BITS = BLAKE2S_HASH_SIZE * 8,
 	POOL_MIN_BITS = POOL_BITS /* No point in settling for less. */
@@ -806,27 +804,6 @@ EXPORT_SYMBOL_GPL(add_input_randomness);
 
 static DEFINE_PER_CPU(struct fast_pool, irq_randomness);
 
-#ifdef ADD_INTERRUPT_BENCH
-static unsigned long avg_cycles, avg_deviation;
-
-#define AVG_SHIFT 8 /* Exponential average factor k=1/256 */
-#define FIXED_1_2 (1 << (AVG_SHIFT - 1))
-
-static void add_interrupt_bench(cycles_t start)
-{
-	long delta = random_get_entropy() - start;
-
-	/* Use a weighted moving average */
-	delta = delta - ((avg_cycles + FIXED_1_2) >> AVG_SHIFT);
-	avg_cycles += delta;
-	/* And average deviation */
-	delta = abs(delta) - ((avg_deviation + FIXED_1_2) >> AVG_SHIFT);
-	avg_deviation += delta;
-}
-#else
-#define add_interrupt_bench(x)
-#endif
-
 static u32 get_reg(struct fast_pool *f, struct pt_regs *regs)
 {
 	u32 *ptr = (u32 *)regs;
@@ -863,7 +840,6 @@ void add_interrupt_randomness(int irq)
 		(sizeof(ip) > 4) ? ip >> 32 : get_reg(fast_pool, regs);
 
 	fast_mix(fast_pool);
-	add_interrupt_bench(cycles);
 
 	if (unlikely(crng_init == 0)) {
 		if (fast_pool->count >= 64 &&
@@ -1573,22 +1549,6 @@ struct ctl_table random_table[] = {
 		.mode		= 0444,
 		.proc_handler	= proc_do_uuid,
 	},
-#ifdef ADD_INTERRUPT_BENCH
-	{
-		.procname	= "add_interrupt_avg_cycles",
-		.data		= &avg_cycles,
-		.maxlen		= sizeof(avg_cycles),
-		.mode		= 0444,
-		.proc_handler	= proc_doulongvec_minmax,
-	},
-	{
-		.procname	= "add_interrupt_avg_deviation",
-		.data		= &avg_deviation,
-		.maxlen		= sizeof(avg_deviation),
-		.mode		= 0444,
-		.proc_handler	= proc_doulongvec_minmax,
-	},
-#endif
 	{ }
 };
 #endif	/* CONFIG_SYSCTL */


