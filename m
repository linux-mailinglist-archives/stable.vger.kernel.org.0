Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67AAF558659
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 20:11:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236236AbiFWSLa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 14:11:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233959AbiFWSJa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 14:09:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB842BC994;
        Thu, 23 Jun 2022 10:20:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 67670B824BC;
        Thu, 23 Jun 2022 17:20:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A64E3C3411B;
        Thu, 23 Jun 2022 17:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656004801;
        bh=XukfhUeaSBlKo4FEEy3YU1OO94nacXamuPax/3rpOeA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vxYtEQFWxy1uOKWWDAQjMN99th/PNheUb5gc1Xw4pT6JLWUV3QiIgDT6Fm6vY24Sj
         x+WTGHkzkeclzcGEXQ8LIDfGc8nVTt/QyQbb0D038rcTYYijyk+AqAiWIM51clJCEL
         ixPtWZXtzpuRrMg/BcW++zhJsIf2cO2KAnPT4Qoo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Filipe Manana <fdmanana@suse.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bp@alien8.de>, Theodore Tso <tytso@mit.edu>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.19 153/234] random: do not use input pool from hard IRQs
Date:   Thu, 23 Jun 2022 18:43:40 +0200
Message-Id: <20220623164347.384529393@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164343.042598055@linuxfoundation.org>
References: <20220623164343.042598055@linuxfoundation.org>
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

commit e3e33fc2ea7fcefd0d761db9d6219f83b4248f5c upstream.

Years ago, a separate fast pool was added for interrupts, so that the
cost associated with taking the input pool spinlocks and mixing into it
would be avoided in places where latency is critical. However, one
oversight was that add_input_randomness() and add_disk_randomness()
still sometimes are called directly from the interrupt handler, rather
than being deferred to a thread. This means that some unlucky interrupts
will be caught doing a blake2s_compress() call and potentially spinning
on input_pool.lock, which can also be taken by unprivileged users by
writing into /dev/urandom.

In order to fix this, add_timer_randomness() now checks whether it is
being called from a hard IRQ and if so, just mixes into the per-cpu IRQ
fast pool using fast_mix(), which is much faster and can be done
lock-free. A nice consequence of this, as well, is that it means hard
IRQ context FPU support is likely no longer useful.

The entropy estimation algorithm used by add_timer_randomness() is also
somewhat different than the one used for add_interrupt_randomness(). The
former looks at deltas of deltas of deltas, while the latter just waits
for 64 interrupts for one bit or for one second since the last bit. In
order to bridge these, and since add_interrupt_randomness() runs after
an add_timer_randomness() that's called from hard IRQ, we add to the
fast pool credit the related amount, and then subtract one to account
for add_interrupt_randomness()'s contribution.

A downside of this, however, is that the num argument is potentially
attacker controlled, which puts a bit more pressure on the fast_mix()
sponge to do more than it's really intended to do. As a mitigating
factor, the first 96 bits of input aren't attacker controlled (a cycle
counter followed by zeros), which means it's essentially two rounds of
siphash rather than one, which is somewhat better. It's also not that
much different from add_interrupt_randomness()'s use of the irq stack
instruction pointer register.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Filipe Manana <fdmanana@suse.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |   51 +++++++++++++++++++++++++++++++++++---------------
 1 file changed, 36 insertions(+), 15 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1081,6 +1081,7 @@ static void mix_interrupt_randomness(str
 	 * we don't wind up "losing" some.
 	 */
 	unsigned long pool[2];
+	unsigned int count;
 
 	/* Check to see if we're running on the wrong CPU due to hotplug. */
 	local_irq_disable();
@@ -1094,12 +1095,13 @@ static void mix_interrupt_randomness(str
 	 * consistent view, before we reenable irqs again.
 	 */
 	memcpy(pool, fast_pool->pool, sizeof(pool));
+	count = fast_pool->count;
 	fast_pool->count = 0;
 	fast_pool->last = jiffies;
 	local_irq_enable();
 
 	mix_pool_bytes(pool, sizeof(pool));
-	credit_init_bits(1);
+	credit_init_bits(max(1u, (count & U16_MAX) / 64));
 
 	memzero_explicit(pool, sizeof(pool));
 }
@@ -1139,22 +1141,30 @@ struct timer_rand_state {
 
 /*
  * This function adds entropy to the entropy "pool" by using timing
- * delays.  It uses the timer_rand_state structure to make an estimate
- * of how many bits of entropy this call has added to the pool.
- *
- * The number "num" is also added to the pool - it should somehow describe
- * the type of event which just happened.  This is currently 0-255 for
- * keyboard scan codes, and 256 upwards for interrupts.
+ * delays. It uses the timer_rand_state structure to make an estimate
+ * of how many bits of entropy this call has added to the pool. The
+ * value "num" is also added to the pool; it should somehow describe
+ * the type of event that just happened.
  */
 static void add_timer_randomness(struct timer_rand_state *state, unsigned int num)
 {
 	unsigned long entropy = random_get_entropy(), now = jiffies, flags;
 	long delta, delta2, delta3;
+	unsigned int bits;
 
-	spin_lock_irqsave(&input_pool.lock, flags);
-	_mix_pool_bytes(&entropy, sizeof(entropy));
-	_mix_pool_bytes(&num, sizeof(num));
-	spin_unlock_irqrestore(&input_pool.lock, flags);
+	/*
+	 * If we're in a hard IRQ, add_interrupt_randomness() will be called
+	 * sometime after, so mix into the fast pool.
+	 */
+	if (in_irq()) {
+		fast_mix(this_cpu_ptr(&irq_randomness)->pool,
+			 (unsigned long[2]){ entropy, num });
+	} else {
+		spin_lock_irqsave(&input_pool.lock, flags);
+		_mix_pool_bytes(&entropy, sizeof(entropy));
+		_mix_pool_bytes(&num, sizeof(num));
+		spin_unlock_irqrestore(&input_pool.lock, flags);
+	}
 
 	if (crng_ready())
 		return;
@@ -1185,11 +1195,22 @@ static void add_timer_randomness(struct
 		delta = delta3;
 
 	/*
-	 * delta is now minimum absolute delta.
-	 * Round down by 1 bit on general principles,
-	 * and limit entropy estimate to 12 bits.
+	 * delta is now minimum absolute delta. Round down by 1 bit
+	 * on general principles, and limit entropy estimate to 11 bits.
+	 */
+	bits = min(fls(delta >> 1), 11);
+
+	/*
+	 * As mentioned above, if we're in a hard IRQ, add_interrupt_randomness()
+	 * will run after this, which uses a different crediting scheme of 1 bit
+	 * per every 64 interrupts. In order to let that function do accounting
+	 * close to the one in this function, we credit a full 64/64 bit per bit,
+	 * and then subtract one to account for the extra one added.
 	 */
-	credit_init_bits(min_t(unsigned int, fls(delta >> 1), 11));
+	if (in_irq())
+		this_cpu_ptr(&irq_randomness)->count += max(1u, bits * 64) - 1;
+	else
+		credit_init_bits(bits);
 }
 
 void add_input_randomness(unsigned int type, unsigned int code,


