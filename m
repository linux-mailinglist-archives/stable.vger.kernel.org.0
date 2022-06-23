Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66421558065
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 18:52:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232716AbiFWQsJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 12:48:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232514AbiFWQrW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 12:47:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C52749C9D;
        Thu, 23 Jun 2022 09:47:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F66561F90;
        Thu, 23 Jun 2022 16:47:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61767C341C4;
        Thu, 23 Jun 2022 16:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656002839;
        bh=idT+tSUSvzqHS5ZFq5fhSkpBKVkACMI4C7jZMHteHcY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jo2ggikEB92Ze9xKHh/keZO7ZvXNvNL6hKsNK9U7oK/L2gdyBBgKBLD315nJG2iBe
         LiSyTaBlPquufdutc7+FllDsJ0jleT7LpFC0qPtLXeKLBewCwq7HK8UPRPCUMtcU8K
         31S+9DhI2qrlQMggu4ybITd3jCsDGQZ8JX1fa6K4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 4.9 008/264] random: invalidate batched entropy after crng init
Date:   Thu, 23 Jun 2022 18:40:01 +0200
Message-Id: <20220623164344.295773616@linuxfoundation.org>
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

commit b169c13de473a85b3c859bb36216a4cb5f00a54a upstream.

It's possible that get_random_{u32,u64} is used before the crng has
initialized, in which case, its output might not be cryptographically
secure. For this problem, directly, this patch set is introducing the
*_wait variety of functions, but even with that, there's a subtle issue:
what happens to our batched entropy that was generated before
initialization. Prior to this commit, it'd stick around, supplying bad
numbers. After this commit, we force the entropy to be re-extracted
after each phase of the crng has initialized.

In order to avoid a race condition with the position counter, we
introduce a simple rwlock for this invalidation. Since it's only during
this awkward transition period, after things are all set up, we stop
using it, so that it doesn't have an impact on performance.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@vger.kernel.org  # v4.11+
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |   37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1,6 +1,9 @@
 /*
  * random.c -- A strong random number generator
  *
+ * Copyright (C) 2017 Jason A. Donenfeld <Jason@zx2c4.com>. All
+ * Rights Reserved.
+ *
  * Copyright Matt Mackall <mpm@selenic.com>, 2003, 2004, 2005
  *
  * Copyright Theodore Ts'o, 1994, 1995, 1996, 1997, 1998, 1999.  All
@@ -774,6 +777,8 @@ static DECLARE_WAIT_QUEUE_HEAD(crng_init
 static struct crng_state **crng_node_pool __read_mostly;
 #endif
 
+static void invalidate_batched_entropy(void);
+
 static void crng_initialize(struct crng_state *crng)
 {
 	int		i;
@@ -811,6 +816,7 @@ static int crng_fast_load(const char *cp
 		cp++; crng_init_cnt++; len--;
 	}
 	if (crng_init_cnt >= CRNG_INIT_CNT_THRESH) {
+		invalidate_batched_entropy();
 		crng_init = 1;
 		wake_up_interruptible(&crng_init_wait);
 		pr_notice("random: fast init done\n");
@@ -900,6 +906,7 @@ static void crng_reseed(struct crng_stat
 	WRITE_ONCE(crng->init_time, jiffies);
 	if (crng == &primary_crng && crng_init < 2) {
 		numa_crng_init();
+		invalidate_batched_entropy();
 		crng_init = 2;
 		process_random_ready_list();
 		wake_up_interruptible(&crng_init_wait);
@@ -2090,6 +2097,7 @@ struct batched_entropy {
 	};
 	unsigned int position;
 };
+static rwlock_t batched_entropy_reset_lock = __RW_LOCK_UNLOCKED(batched_entropy_reset_lock);
 
 /*
  * Get a random word for internal kernel use only. The quality of the random
@@ -2100,6 +2108,8 @@ static DEFINE_PER_CPU(struct batched_ent
 u64 get_random_u64(void)
 {
 	u64 ret;
+	bool use_lock = crng_init < 2;
+	unsigned long flags;
 	struct batched_entropy *batch;
 
 #if BITS_PER_LONG == 64
@@ -2112,11 +2122,15 @@ u64 get_random_u64(void)
 #endif
 
 	batch = &get_cpu_var(batched_entropy_u64);
+	if (use_lock)
+		read_lock_irqsave(&batched_entropy_reset_lock, flags);
 	if (batch->position % ARRAY_SIZE(batch->entropy_u64) == 0) {
 		extract_crng((u8 *)batch->entropy_u64);
 		batch->position = 0;
 	}
 	ret = batch->entropy_u64[batch->position++];
+	if (use_lock)
+		read_unlock_irqrestore(&batched_entropy_reset_lock, flags);
 	put_cpu_var(batched_entropy_u64);
 	return ret;
 }
@@ -2126,22 +2140,45 @@ static DEFINE_PER_CPU(struct batched_ent
 u32 get_random_u32(void)
 {
 	u32 ret;
+	bool use_lock = crng_init < 2;
+	unsigned long flags;
 	struct batched_entropy *batch;
 
 	if (arch_get_random_int(&ret))
 		return ret;
 
 	batch = &get_cpu_var(batched_entropy_u32);
+	if (use_lock)
+		read_lock_irqsave(&batched_entropy_reset_lock, flags);
 	if (batch->position % ARRAY_SIZE(batch->entropy_u32) == 0) {
 		extract_crng((u8 *)batch->entropy_u32);
 		batch->position = 0;
 	}
 	ret = batch->entropy_u32[batch->position++];
+	if (use_lock)
+		read_unlock_irqrestore(&batched_entropy_reset_lock, flags);
 	put_cpu_var(batched_entropy_u32);
 	return ret;
 }
 EXPORT_SYMBOL(get_random_u32);
 
+/* It's important to invalidate all potential batched entropy that might
+ * be stored before the crng is initialized, which we can do lazily by
+ * simply resetting the counter to zero so that it's re-extracted on the
+ * next usage. */
+static void invalidate_batched_entropy(void)
+{
+	int cpu;
+	unsigned long flags;
+
+	write_lock_irqsave(&batched_entropy_reset_lock, flags);
+	for_each_possible_cpu (cpu) {
+		per_cpu_ptr(&batched_entropy_u32, cpu)->position = 0;
+		per_cpu_ptr(&batched_entropy_u64, cpu)->position = 0;
+	}
+	write_unlock_irqrestore(&batched_entropy_reset_lock, flags);
+}
+
 /**
  * randomize_page - Generate a random, page aligned address
  * @start:	The smallest acceptable address the caller will take.


