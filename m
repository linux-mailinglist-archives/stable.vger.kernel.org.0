Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1791149FCE4
	for <lists+stable@lfdr.de>; Fri, 28 Jan 2022 16:34:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232953AbiA1PeH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jan 2022 10:34:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231994AbiA1PeG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Jan 2022 10:34:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19952C061714;
        Fri, 28 Jan 2022 07:34:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F19E60E8F;
        Fri, 28 Jan 2022 15:34:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E641CC340E0;
        Fri, 28 Jan 2022 15:34:03 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="U+xGncFL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1643384042;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IBgxaJ234RRhgamcxoz10cjZa5dO5prp7qRYV/OJ5l8=;
        b=U+xGncFLG1zJmv8Fo69LWO0ZwhMgS1a/xDJPE5tYRLo62GHSWcmWcZhf+VMmaEXc+ZK2Tr
        8OuBHWAFkqvIiU32CWfBxfTbmyAaknGihbgXv2Hkd3Qh2xwysAV3WQDChmcRRQRYo9WuO2
        cubJZvxY/b1prz220lven7RlQuCgSI4=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 8972d08d (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Fri, 28 Jan 2022 15:34:01 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Andy Lutomirski <luto@amacapital.net>,
        =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>,
        "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Waiman Long <longman@redhat.com>,
        Boqun Feng <boqun.feng@gmail.com>
Cc:     Andy Lutomirski <luto@kernel.org>, stable@vger.kernel.org,
        "Jason A . Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH] random: remove batched entropy locking
Date:   Fri, 28 Jan 2022 16:33:44 +0100
Message-Id: <20220128153344.34211-1-Jason@zx2c4.com>
In-Reply-To: <CAHmME9pb9A4SN6TTjNvvxKqw1L3gXVOX7KKihfEH4AgKGNGZ2A@mail.gmail.com>
References: <CAHmME9pb9A4SN6TTjNvvxKqw1L3gXVOX7KKihfEH4AgKGNGZ2A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Lutomirski <luto@kernel.org>

We don't need spinlocks to protect batched entropy -- all we need
is a little bit of care. This should fix up the following splat that
Jonathan received with a PROVE_LOCKING=y/PROVE_RAW_LOCK_NESTING=y
kernel:

[    2.500000] [ BUG: Invalid wait context ]
[    2.500000] 5.17.0-rc1 #563 Not tainted
[    2.500000] -----------------------------
[    2.500000] swapper/1 is trying to lock:
[    2.500000] c0b0e9cc (batched_entropy_u32.lock){....}-{3:3}, at: invalidate_batched_entropy+0x18/0x4c
[    2.500000] other info that might help us debug this:
[    2.500000] context-{2:2}
[    2.500000] 3 locks held by swapper/1:
[    2.500000]  #0: c0ae86ac (event_mutex){+.+.}-{4:4}, at: event_trace_init+0x4c/0xd8
[    2.500000]  #1: c0ae81b8 (trace_event_sem){+.+.}-{4:4}, at: event_trace_init+0x68/0xd8
[    2.500000]  #2: c19b05cc (&sb->s_type->i_mutex_key#2){+.+.}-{4:4}, at: start_creating+0x40/0xc4
[    2.500000] stack backtrace:
[    2.500000] CPU: 0 PID: 1 Comm: swapper Not tainted 5.17.0-rc1 #563
[    2.500000] Hardware name: WPCM450 chip
[    2.500000] [<c00100a8>] (unwind_backtrace) from [<c000db2c>] (show_stack+0x10/0x14)
[    2.500000] [<c000db2c>] (show_stack) from [<c0054eec>] (__lock_acquire+0x3f0/0x189c)
[    2.500000] [<c0054eec>] (__lock_acquire) from [<c0054478>] (lock_acquire+0x2b8/0x354)
[    2.500000] [<c0054478>] (lock_acquire) from [<c0568028>] (_raw_spin_lock_irqsave+0x60/0x74)
[    2.500000] [<c0568028>] (_raw_spin_lock_irqsave) from [<c030b6f4>] (invalidate_batched_entropy+0x18/0x4c)
[    2.500000] [<c030b6f4>] (invalidate_batched_entropy) from [<c030e7fc>] (crng_fast_load+0xf0/0x110)
[    2.500000] [<c030e7fc>] (crng_fast_load) from [<c030e954>] (add_interrupt_randomness+0x138/0x200)
[    2.500000] [<c030e954>] (add_interrupt_randomness) from [<c0061b34>] (handle_irq_event_percpu+0x18/0x38)
[    2.500000] [<c0061b34>] (handle_irq_event_percpu) from [<c0061b8c>] (handle_irq_event+0x38/0x5c)
[    2.500000] [<c0061b8c>] (handle_irq_event) from [<c0065b28>] (handle_fasteoi_irq+0x9c/0x114)
[    2.500000] [<c0065b28>] (handle_fasteoi_irq) from [<c0061178>] (handle_irq_desc+0x24/0x34)
[    2.500000] [<c0061178>] (handle_irq_desc) from [<c056214c>] (generic_handle_arch_irq+0x28/0x3c)
[    2.500000] [<c056214c>] (generic_handle_arch_irq) from [<c0008eb4>] (__irq_svc+0x54/0x80)
[    2.500000] Exception stack(0xc1485d48 to 0xc1485d90)
[    2.500000] 5d40:                   9780e804 00000001 c09413d4 200000d3 60000053 c016af54
[    2.500000] 5d60: 00000000 c0afa5b8 c14194e0 c19a1d48 c0789ce0 00000000 c1490480 c1485d98
[    2.500000] 5d80: c0168970 c0168984 20000053 ffffffff
[    2.500000] [<c0008eb4>] (__irq_svc) from [<c0168984>] (read_seqbegin.constprop.0+0x6c/0x90)
[    2.500000] [<c0168984>] (read_seqbegin.constprop.0) from [<c016af54>] (d_lookup+0x14/0x40)
[    2.500000] [<c016af54>] (d_lookup) from [<c015cecc>] (lookup_dcache+0x18/0x50)
[    2.500000] [<c015cecc>] (lookup_dcache) from [<c015d868>] (lookup_one_len+0x90/0xe0)
[    2.500000] [<c015d868>] (lookup_one_len) from [<c01e33e4>] (start_creating+0x68/0xc4)
[    2.500000] [<c01e33e4>] (start_creating) from [<c01e398c>] (tracefs_create_file+0x30/0x11c)
[    2.500000] [<c01e398c>] (tracefs_create_file) from [<c00c42f8>] (trace_create_file+0x14/0x38)
[    2.500000] [<c00c42f8>] (trace_create_file) from [<c00cc854>] (event_create_dir+0x310/0x420)
[    2.500000] [<c00cc854>] (event_create_dir) from [<c00cc9d8>] (__trace_early_add_event_dirs+0x28/0x50)
[    2.500000] [<c00cc9d8>] (__trace_early_add_event_dirs) from [<c07c8d64>] (event_trace_init+0x70/0xd8)
[    2.500000] [<c07c8d64>] (event_trace_init) from [<c07c8560>] (tracer_init_tracefs+0x14/0x284)
[    2.500000] [<c07c8560>] (tracer_init_tracefs) from [<c000a330>] (do_one_initcall+0xdc/0x288)
[    2.500000] [<c000a330>] (do_one_initcall) from [<c07bd1e8>] (kernel_init_freeable+0x1c4/0x20c)
[    2.500000] [<c07bd1e8>] (kernel_init_freeable) from [<c05629c0>] (kernel_init+0x10/0x110)
[    2.500000] [<c05629c0>] (kernel_init) from [<c00084f8>] (ret_from_fork+0x14/0x3c)
[    2.500000] Exception stack(0xc1485fb0 to 0xc1485ff8)
[    2.500000] 5fa0:                                     00000000 00000000 00000000 00000000
[    2.500000] 5fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[    2.500000] 5fe0: 00000000 00000000 00000000 00000000 00000013 00000000

Signed-off-by: Andy Lutomirski <luto@kernel.org>
[Jason: I extracted this from a larger in-progress series of Andy's that
 also unifies the two batches into one and does other performance
 things. Since that's still under development, but because we need this
 part to fix the CONFIG_PROVE_RAW_LOCK_NESTING issue, I've extracted it
 out and applied it to the current setup. This will also make it easier
 to backport to old kernels that also need the fix. I've also amended
 Andy's original commit message.]
Reported-by: Jonathan Neuschäfer <j.neuschaefer@gmx.net>
Link: https://lore.kernel.org/lkml/YfMa0QgsjCVdRAvJ@latitude/
Fixes: b7d5dc21072c ("random: add a spinlock_t to struct batched_entropy")
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: stable@vger.kernel.org
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
Andy - could you take a look at this and let me know if it's still
correct after I've ported it out of your series and into a standalone
thing here? I'd prefer to hold off on moving forward on this until I
receive our green light. I'm also still a bit uncertain about your NB:
comment regarding the acceptable race. If you could elaborate on that
argument, it might save me a few cycles with my thinking cap on.

 drivers/char/random.c | 57 ++++++++++++++++++++++++-------------------
 1 file changed, 32 insertions(+), 25 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index b411182df6f6..22c190aecbe8 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -2063,7 +2063,6 @@ struct batched_entropy {
 		u32 entropy_u32[CHACHA_BLOCK_SIZE / sizeof(u32)];
 	};
 	unsigned int position;
-	spinlock_t batch_lock;
 };
 
 /*
@@ -2075,7 +2074,7 @@ struct batched_entropy {
  * point prior.
  */
 static DEFINE_PER_CPU(struct batched_entropy, batched_entropy_u64) = {
-	.batch_lock = __SPIN_LOCK_UNLOCKED(batched_entropy_u64.lock),
+	.position = ARRAY_SIZE(((struct batched_entropy *)0)->entropy_u64)
 };
 
 u64 get_random_u64(void)
@@ -2083,42 +2082,55 @@ u64 get_random_u64(void)
 	u64 ret;
 	unsigned long flags;
 	struct batched_entropy *batch;
+	size_t position;
 	static void *previous;
 
 	warn_unseeded_randomness(&previous);
 
-	batch = raw_cpu_ptr(&batched_entropy_u64);
-	spin_lock_irqsave(&batch->batch_lock, flags);
-	if (batch->position % ARRAY_SIZE(batch->entropy_u64) == 0) {
+	local_irq_save(flags);
+	batch = this_cpu_ptr(&batched_entropy_u64);
+	position = READ_ONCE(batch->position);
+	/* NB: position can change to ARRAY_SIZE(batch->entropy_u64) out
+	 * from under us -- see invalidate_batched_entropy().  If this,
+	 * happens it's okay if we still return the data in the batch. */
+	if (unlikely(position + 1 > ARRAY_SIZE(batch->entropy_u64))) {
 		extract_crng((u8 *)batch->entropy_u64);
-		batch->position = 0;
+		position = 0;
 	}
-	ret = batch->entropy_u64[batch->position++];
-	spin_unlock_irqrestore(&batch->batch_lock, flags);
+	ret = batch->entropy_u64[position++];
+	WRITE_ONCE(batch->position, position);
+	local_irq_restore(flags);
 	return ret;
 }
 EXPORT_SYMBOL(get_random_u64);
 
 static DEFINE_PER_CPU(struct batched_entropy, batched_entropy_u32) = {
-	.batch_lock = __SPIN_LOCK_UNLOCKED(batched_entropy_u32.lock),
+	.position = ARRAY_SIZE(((struct batched_entropy *)0)->entropy_u32)
 };
+
 u32 get_random_u32(void)
 {
 	u32 ret;
 	unsigned long flags;
 	struct batched_entropy *batch;
+	size_t position;
 	static void *previous;
 
 	warn_unseeded_randomness(&previous);
 
-	batch = raw_cpu_ptr(&batched_entropy_u32);
-	spin_lock_irqsave(&batch->batch_lock, flags);
-	if (batch->position % ARRAY_SIZE(batch->entropy_u32) == 0) {
+	local_irq_save(flags);
+	batch = this_cpu_ptr(&batched_entropy_u32);
+	position = READ_ONCE(batch->position);
+	/* NB: position can change to ARRAY_SIZE(batch->entropy_u32) out
+	 * from under us -- see invalidate_batched_entropy().  If this,
+	 * happens it's okay if we still return the data in the batch. */
+	if (unlikely(position + 1 > ARRAY_SIZE(batch->entropy_u32))) {
 		extract_crng((u8 *)batch->entropy_u32);
-		batch->position = 0;
+		position = 0;
 	}
-	ret = batch->entropy_u32[batch->position++];
-	spin_unlock_irqrestore(&batch->batch_lock, flags);
+	ret = batch->entropy_u64[position++];
+	WRITE_ONCE(batch->position, position);
+	local_irq_restore(flags);
 	return ret;
 }
 EXPORT_SYMBOL(get_random_u32);
@@ -2130,20 +2142,15 @@ EXPORT_SYMBOL(get_random_u32);
 static void invalidate_batched_entropy(void)
 {
 	int cpu;
-	unsigned long flags;
 
 	for_each_possible_cpu(cpu) {
-		struct batched_entropy *batched_entropy;
+		struct batched_entropy *batch;
 
-		batched_entropy = per_cpu_ptr(&batched_entropy_u32, cpu);
-		spin_lock_irqsave(&batched_entropy->batch_lock, flags);
-		batched_entropy->position = 0;
-		spin_unlock(&batched_entropy->batch_lock);
+		batch = per_cpu_ptr(&batched_entropy_u32, cpu);
+		WRITE_ONCE(batch->position, ARRAY_SIZE(batch->entropy_u32));
 
-		batched_entropy = per_cpu_ptr(&batched_entropy_u64, cpu);
-		spin_lock(&batched_entropy->batch_lock);
-		batched_entropy->position = 0;
-		spin_unlock_irqrestore(&batched_entropy->batch_lock, flags);
+		batch = per_cpu_ptr(&batched_entropy_u64, cpu);
+		WRITE_ONCE(batch->position, ARRAY_SIZE(batch->entropy_u64));
 	}
 }
 
-- 
2.35.0

