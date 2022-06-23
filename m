Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38B14558156
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 18:59:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232922AbiFWQ6z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 12:58:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233674AbiFWQ6H (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 12:58:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64DA74EF49;
        Thu, 23 Jun 2022 09:53:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 53367B82491;
        Thu, 23 Jun 2022 16:53:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AADECC3411B;
        Thu, 23 Jun 2022 16:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656003214;
        bh=QoQwnZ21bn4rrh2FiWs98Uf5G6r93cAll2yBjM7S5iE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W57cYPpD//1eNI9GjNyiwJtTR1b71J3U5zir5oG6fbq5TnzJ393QI3HkzrI/xOII0
         CR1ELI4LCSBQKHKVYOKPNAuDDTWkJjSBoRn7udn4SJlco5jVCvlKq3UBHlDlUgdALf
         i7b/0B+Vo/e62rJ4jehmdZ/OhtkP6JEGSoLh/q2Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.9 130/264] random: deobfuscate irq u32/u64 contributions
Date:   Thu, 23 Jun 2022 18:42:03 +0200
Message-Id: <20220623164347.744437426@linuxfoundation.org>
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

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

commit b2f408fe403800c91a49f6589d95b6759ce1b30b upstream.

In the irq handler, we fill out 16 bytes differently on 32-bit and
64-bit platforms, and for 32-bit vs 64-bit cycle counters, which doesn't
always correspond with the bitness of the platform. Whether or not you
like this strangeness, it is a matter of fact.  But it might not be a
fact you well realized until now, because the code that loaded the irq
info into 4 32-bit words was quite confusing.  Instead, this commit
makes everything explicit by having separate (compile-time) branches for
32-bit and 64-bit types.

Cc: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |   49 ++++++++++++++++++++++++++++---------------------
 1 file changed, 28 insertions(+), 21 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -284,7 +284,10 @@ static void mix_pool_bytes(const void *i
 }
 
 struct fast_pool {
-	u32 pool[4];
+	union {
+		u32 pool32[4];
+		u64 pool64[2];
+	};
 	unsigned long last;
 	u16 reg_idx;
 	u8 count;
@@ -295,10 +298,10 @@ struct fast_pool {
  * collector.  It's hardcoded for an 128 bit pool and assumes that any
  * locks that might be needed are taken by the caller.
  */
-static void fast_mix(struct fast_pool *f)
+static void fast_mix(u32 pool[4])
 {
-	u32 a = f->pool[0],	b = f->pool[1];
-	u32 c = f->pool[2],	d = f->pool[3];
+	u32 a = pool[0],	b = pool[1];
+	u32 c = pool[2],	d = pool[3];
 
 	a += b;			c += d;
 	b = rol32(b, 6);	d = rol32(d, 27);
@@ -316,9 +319,8 @@ static void fast_mix(struct fast_pool *f
 	b = rol32(b, 16);	d = rol32(d, 14);
 	d ^= a;			b ^= c;
 
-	f->pool[0] = a;  f->pool[1] = b;
-	f->pool[2] = c;  f->pool[3] = d;
-	f->count++;
+	pool[0] = a;  pool[1] = b;
+	pool[2] = c;  pool[3] = d;
 }
 
 static void process_random_ready_list(void)
@@ -834,29 +836,34 @@ void add_interrupt_randomness(int irq)
 	struct pt_regs *regs = get_irq_regs();
 	unsigned long now = jiffies;
 	cycles_t cycles = random_get_entropy();
-	u32 c_high, j_high;
-	u64 ip;
 
 	if (cycles == 0)
 		cycles = get_reg(fast_pool, regs);
-	c_high = (sizeof(cycles) > 4) ? cycles >> 32 : 0;
-	j_high = (sizeof(now) > 4) ? now >> 32 : 0;
-	fast_pool->pool[0] ^= cycles ^ j_high ^ irq;
-	fast_pool->pool[1] ^= now ^ c_high;
-	ip = regs ? instruction_pointer(regs) : _RET_IP_;
-	fast_pool->pool[2] ^= ip;
-	fast_pool->pool[3] ^=
-		(sizeof(ip) > 4) ? ip >> 32 : get_reg(fast_pool, regs);
 
-	fast_mix(fast_pool);
+	if (sizeof(cycles) == 8)
+		fast_pool->pool64[0] ^= cycles ^ rol64(now, 32) ^ irq;
+	else {
+		fast_pool->pool32[0] ^= cycles ^ irq;
+		fast_pool->pool32[1] ^= now;
+	}
+
+	if (sizeof(unsigned long) == 8)
+		fast_pool->pool64[1] ^= regs ? instruction_pointer(regs) : _RET_IP_;
+	else {
+		fast_pool->pool32[2] ^= regs ? instruction_pointer(regs) : _RET_IP_;
+		fast_pool->pool32[3] ^= get_reg(fast_pool, regs);
+	}
+
+	fast_mix(fast_pool->pool32);
+	++fast_pool->count;
 
 	if (unlikely(crng_init == 0)) {
 		if (fast_pool->count >= 64 &&
-		    crng_fast_load(fast_pool->pool, sizeof(fast_pool->pool)) > 0) {
+		    crng_fast_load(fast_pool->pool32, sizeof(fast_pool->pool32)) > 0) {
 			fast_pool->count = 0;
 			fast_pool->last = now;
 			if (spin_trylock(&input_pool.lock)) {
-				_mix_pool_bytes(&fast_pool->pool, sizeof(fast_pool->pool));
+				_mix_pool_bytes(&fast_pool->pool32, sizeof(fast_pool->pool32));
 				spin_unlock(&input_pool.lock);
 			}
 		}
@@ -870,7 +877,7 @@ void add_interrupt_randomness(int irq)
 		return;
 
 	fast_pool->last = now;
-	_mix_pool_bytes(&fast_pool->pool, sizeof(fast_pool->pool));
+	_mix_pool_bytes(&fast_pool->pool32, sizeof(fast_pool->pool32));
 	spin_unlock(&input_pool.lock);
 
 	fast_pool->count = 0;


