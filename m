Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA5A2535CF4
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 11:09:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239654AbiE0Ize (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 04:55:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350331AbiE0IzQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 04:55:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FD68FF5A7;
        Fri, 27 May 2022 01:53:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C485F61D52;
        Fri, 27 May 2022 08:53:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E10FC385A9;
        Fri, 27 May 2022 08:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653641616;
        bh=/VSZyAVjaetEfzPX1m1jLK2kGsRXWlfOtDgLaLcG9Cw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kY16p7aRh+MQHIOZ1kXsO6ihY667Ncp7zl3E6Xr4W4oYmiNSkPgz4RdppCmElzexO
         zZUSOB7M1lSJNjYJHAi8IYIoPNl+56TPV2+RJAwufZnCTdVwhyX9BTuTiFdUPAG6BP
         ZnsRA2bGx7HDGX5pBGCrwyYMCQbpXksqTY0DXbEI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.17 009/111] random: remove batched entropy locking
Date:   Fri, 27 May 2022 10:48:41 +0200
Message-Id: <20220527084820.419381242@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220527084819.133490171@linuxfoundation.org>
References: <20220527084819.133490171@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

commit 77760fd7f7ae3dfd03668204e708d1568d75447d upstream.

Rather than use spinlocks to protect batched entropy, we can instead
disable interrupts locally, since we're dealing with per-cpu data, and
manage resets with a basic generation counter. At the same time, we
can't quite do this on PREEMPT_RT, where we still want spinlocks-as-
mutexes semantics. So we use a local_lock_t, which provides the right
behavior for each. Because this is a per-cpu lock, that generation
counter is still doing the necessary CPU-to-CPU communication.

This should improve performance a bit. It will also fix the linked splat
that Jonathan received with a PROVE_RAW_LOCK_NESTING=y.

Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reviewed-by: Dominik Brodowski <linux@dominikbrodowski.net>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Suggested-by: Andy Lutomirski <luto@kernel.org>
Reported-by: Jonathan Neuschäfer <j.neuschaefer@gmx.net>
Tested-by: Jonathan Neuschäfer <j.neuschaefer@gmx.net>
Link: https://lore.kernel.org/lkml/YfMa0QgsjCVdRAvJ@latitude/
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |   55 +++++++++++++++++++++++++-------------------------
 1 file changed, 28 insertions(+), 27 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1731,13 +1731,16 @@ static int __init random_sysctls_init(vo
 device_initcall(random_sysctls_init);
 #endif	/* CONFIG_SYSCTL */
 
+static atomic_t batch_generation = ATOMIC_INIT(0);
+
 struct batched_entropy {
 	union {
 		u64 entropy_u64[CHACHA_BLOCK_SIZE / sizeof(u64)];
 		u32 entropy_u32[CHACHA_BLOCK_SIZE / sizeof(u32)];
 	};
+	local_lock_t lock;
 	unsigned int position;
-	spinlock_t batch_lock;
+	int generation;
 };
 
 /*
@@ -1749,7 +1752,7 @@ struct batched_entropy {
  * point prior.
  */
 static DEFINE_PER_CPU(struct batched_entropy, batched_entropy_u64) = {
-	.batch_lock = __SPIN_LOCK_UNLOCKED(batched_entropy_u64.lock),
+	.lock = INIT_LOCAL_LOCK(batched_entropy_u64.lock)
 };
 
 u64 get_random_u64(void)
@@ -1758,67 +1761,65 @@ u64 get_random_u64(void)
 	unsigned long flags;
 	struct batched_entropy *batch;
 	static void *previous;
+	int next_gen;
 
 	warn_unseeded_randomness(&previous);
 
+	local_lock_irqsave(&batched_entropy_u64.lock, flags);
 	batch = raw_cpu_ptr(&batched_entropy_u64);
-	spin_lock_irqsave(&batch->batch_lock, flags);
-	if (batch->position % ARRAY_SIZE(batch->entropy_u64) == 0) {
+
+	next_gen = atomic_read(&batch_generation);
+	if (batch->position % ARRAY_SIZE(batch->entropy_u64) == 0 ||
+	    next_gen != batch->generation) {
 		extract_crng((u8 *)batch->entropy_u64);
 		batch->position = 0;
+		batch->generation = next_gen;
 	}
+
 	ret = batch->entropy_u64[batch->position++];
-	spin_unlock_irqrestore(&batch->batch_lock, flags);
+	local_unlock_irqrestore(&batched_entropy_u64.lock, flags);
 	return ret;
 }
 EXPORT_SYMBOL(get_random_u64);
 
 static DEFINE_PER_CPU(struct batched_entropy, batched_entropy_u32) = {
-	.batch_lock = __SPIN_LOCK_UNLOCKED(batched_entropy_u32.lock),
+	.lock = INIT_LOCAL_LOCK(batched_entropy_u32.lock)
 };
+
 u32 get_random_u32(void)
 {
 	u32 ret;
 	unsigned long flags;
 	struct batched_entropy *batch;
 	static void *previous;
+	int next_gen;
 
 	warn_unseeded_randomness(&previous);
 
+	local_lock_irqsave(&batched_entropy_u32.lock, flags);
 	batch = raw_cpu_ptr(&batched_entropy_u32);
-	spin_lock_irqsave(&batch->batch_lock, flags);
-	if (batch->position % ARRAY_SIZE(batch->entropy_u32) == 0) {
+
+	next_gen = atomic_read(&batch_generation);
+	if (batch->position % ARRAY_SIZE(batch->entropy_u32) == 0 ||
+	    next_gen != batch->generation) {
 		extract_crng((u8 *)batch->entropy_u32);
 		batch->position = 0;
+		batch->generation = next_gen;
 	}
+
 	ret = batch->entropy_u32[batch->position++];
-	spin_unlock_irqrestore(&batch->batch_lock, flags);
+	local_unlock_irqrestore(&batched_entropy_u32.lock, flags);
 	return ret;
 }
 EXPORT_SYMBOL(get_random_u32);
 
 /* It's important to invalidate all potential batched entropy that might
  * be stored before the crng is initialized, which we can do lazily by
- * simply resetting the counter to zero so that it's re-extracted on the
- * next usage. */
+ * bumping the generation counter.
+ */
 static void invalidate_batched_entropy(void)
 {
-	int cpu;
-	unsigned long flags;
-
-	for_each_possible_cpu(cpu) {
-		struct batched_entropy *batched_entropy;
-
-		batched_entropy = per_cpu_ptr(&batched_entropy_u32, cpu);
-		spin_lock_irqsave(&batched_entropy->batch_lock, flags);
-		batched_entropy->position = 0;
-		spin_unlock(&batched_entropy->batch_lock);
-
-		batched_entropy = per_cpu_ptr(&batched_entropy_u64, cpu);
-		spin_lock(&batched_entropy->batch_lock);
-		batched_entropy->position = 0;
-		spin_unlock_irqrestore(&batched_entropy->batch_lock, flags);
-	}
+	atomic_inc(&batch_generation);
 }
 
 /**


