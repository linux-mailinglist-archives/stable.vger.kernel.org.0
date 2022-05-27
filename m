Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93D3A53607E
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 13:53:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352282AbiE0Lxg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 07:53:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352833AbiE0Luz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 07:50:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADFC912FEFA;
        Fri, 27 May 2022 04:45:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 37F2CB824CA;
        Fri, 27 May 2022 11:45:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93DABC385A9;
        Fri, 27 May 2022 11:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653651946;
        bh=UM/ee3qFUonfM6Cot0sZOaTo8Yren/MzTWeVlPA2Yxw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bce4r+LzhDJT4TBA6Zkh8kVuhZWtbN7Mkvzlx6PGs8ccuEpN0BTXaZCHxNerh8Ygx
         eEo6T5nsww4OTGudkVR/Df3x9L+LAHByUSWlNj6DQKD0jkkUS9n54O2mGbgsidh0Z1
         wot0mnC+r/2gLwfR3kSSLYUPTN9eI4mYOMaPoja4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Eric Biggers <ebiggers@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.15 060/145] random: remove unused tracepoints
Date:   Fri, 27 May 2022 10:49:21 +0200
Message-Id: <20220527084857.891856769@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220527084850.364560116@linuxfoundation.org>
References: <20220527084850.364560116@linuxfoundation.org>
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

commit 14c174633f349cb41ea90c2c0aaddac157012f74 upstream.

These explicit tracepoints aren't really used and show sign of aging.
It's work to keep these up to date, and before I attempted to keep them
up to date, they weren't up to date, which indicates that they're not
really used. These days there are better ways of introspecting anyway.

Cc: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Dominik Brodowski <linux@dominikbrodowski.net>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c         |   30 -----
 include/trace/events/random.h |  212 ------------------------------------------
 lib/random32.c                |    3 
 3 files changed, 4 insertions(+), 241 deletions(-)
 delete mode 100644 include/trace/events/random.h

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -237,9 +237,6 @@
 #include <asm/irq_regs.h>
 #include <asm/io.h>
 
-#define CREATE_TRACE_POINTS
-#include <trace/events/random.h>
-
 enum {
 	POOL_BITS = BLAKE2S_HASH_SIZE * 8,
 	POOL_MIN_BITS = POOL_BITS /* No point in settling for less. */
@@ -315,7 +312,6 @@ static void mix_pool_bytes(const void *i
 {
 	unsigned long flags;
 
-	trace_mix_pool_bytes(nbytes, _RET_IP_);
 	spin_lock_irqsave(&input_pool.lock, flags);
 	_mix_pool_bytes(in, nbytes);
 	spin_unlock_irqrestore(&input_pool.lock, flags);
@@ -389,8 +385,6 @@ static void credit_entropy_bits(size_t n
 		entropy_count = min_t(unsigned int, POOL_BITS, orig + add);
 	} while (cmpxchg(&input_pool.entropy_count, orig, entropy_count) != orig);
 
-	trace_credit_entropy_bits(nbits, entropy_count, _RET_IP_);
-
 	if (crng_init < 2 && entropy_count >= POOL_MIN_BITS)
 		crng_reseed();
 }
@@ -721,7 +715,6 @@ void add_device_randomness(const void *b
 	if (!crng_ready() && size)
 		crng_slow_load(buf, size);
 
-	trace_add_device_randomness(size, _RET_IP_);
 	spin_lock_irqsave(&input_pool.lock, flags);
 	_mix_pool_bytes(buf, size);
 	_mix_pool_bytes(&time, sizeof(time));
@@ -800,7 +793,6 @@ void add_input_randomness(unsigned int t
 	last_value = value;
 	add_timer_randomness(&input_timer_state,
 			     (type << 4) ^ code ^ (code >> 4) ^ value);
-	trace_add_input_randomness(input_pool.entropy_count);
 }
 EXPORT_SYMBOL_GPL(add_input_randomness);
 
@@ -880,7 +872,6 @@ void add_disk_randomness(struct gendisk
 		return;
 	/* first major is 1, so we get >= 0x200 here */
 	add_timer_randomness(disk->random, 0x100 + disk_devt(disk));
-	trace_add_disk_randomness(disk_devt(disk), input_pool.entropy_count);
 }
 EXPORT_SYMBOL_GPL(add_disk_randomness);
 #endif
@@ -905,8 +896,6 @@ static void extract_entropy(void *buf, s
 	} block;
 	size_t i;
 
-	trace_extract_entropy(nbytes, input_pool.entropy_count);
-
 	for (i = 0; i < ARRAY_SIZE(block.rdseed); ++i) {
 		if (!arch_get_random_seed_long(&block.rdseed[i]) &&
 		    !arch_get_random_long(&block.rdseed[i]))
@@ -978,8 +967,6 @@ static void _get_random_bytes(void *buf,
 	u8 tmp[CHACHA_BLOCK_SIZE];
 	size_t len;
 
-	trace_get_random_bytes(nbytes, _RET_IP_);
-
 	if (!nbytes)
 		return;
 
@@ -1176,7 +1163,6 @@ size_t __must_check get_random_bytes_arc
 	size_t left = nbytes;
 	u8 *p = buf;
 
-	trace_get_random_bytes_arch(left, _RET_IP_);
 	while (left) {
 		unsigned long v;
 		size_t chunk = min_t(size_t, left, sizeof(unsigned long));
@@ -1260,16 +1246,6 @@ void rand_initialize_disk(struct gendisk
 }
 #endif
 
-static ssize_t urandom_read_nowarn(struct file *file, char __user *buf,
-				   size_t nbytes, loff_t *ppos)
-{
-	ssize_t ret;
-
-	ret = get_random_bytes_user(buf, nbytes);
-	trace_urandom_read(nbytes, input_pool.entropy_count);
-	return ret;
-}
-
 static ssize_t urandom_read(struct file *file, char __user *buf, size_t nbytes,
 			    loff_t *ppos)
 {
@@ -1282,7 +1258,7 @@ static ssize_t urandom_read(struct file
 				  current->comm, nbytes);
 	}
 
-	return urandom_read_nowarn(file, buf, nbytes, ppos);
+	return get_random_bytes_user(buf, nbytes);
 }
 
 static ssize_t random_read(struct file *file, char __user *buf, size_t nbytes,
@@ -1293,7 +1269,7 @@ static ssize_t random_read(struct file *
 	ret = wait_for_random_bytes();
 	if (ret != 0)
 		return ret;
-	return urandom_read_nowarn(file, buf, nbytes, ppos);
+	return get_random_bytes_user(buf, nbytes);
 }
 
 static __poll_t random_poll(struct file *file, poll_table *wait)
@@ -1454,7 +1430,7 @@ SYSCALL_DEFINE3(getrandom, char __user *
 		if (unlikely(ret))
 			return ret;
 	}
-	return urandom_read_nowarn(NULL, buf, count, NULL);
+	return get_random_bytes_user(buf, count);
 }
 
 /********************************************************************
--- a/include/trace/events/random.h
+++ /dev/null
@@ -1,212 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#undef TRACE_SYSTEM
-#define TRACE_SYSTEM random
-
-#if !defined(_TRACE_RANDOM_H) || defined(TRACE_HEADER_MULTI_READ)
-#define _TRACE_RANDOM_H
-
-#include <linux/writeback.h>
-#include <linux/tracepoint.h>
-
-TRACE_EVENT(add_device_randomness,
-	TP_PROTO(size_t bytes, unsigned long IP),
-
-	TP_ARGS(bytes, IP),
-
-	TP_STRUCT__entry(
-		__field(size_t,		bytes	)
-		__field(unsigned long,	IP	)
-	),
-
-	TP_fast_assign(
-		__entry->bytes		= bytes;
-		__entry->IP		= IP;
-	),
-
-	TP_printk("bytes %zu caller %pS",
-		__entry->bytes, (void *)__entry->IP)
-);
-
-DECLARE_EVENT_CLASS(random__mix_pool_bytes,
-	TP_PROTO(size_t bytes, unsigned long IP),
-
-	TP_ARGS(bytes, IP),
-
-	TP_STRUCT__entry(
-		__field(size_t,		bytes	)
-		__field(unsigned long,	IP	)
-	),
-
-	TP_fast_assign(
-		__entry->bytes		= bytes;
-		__entry->IP		= IP;
-	),
-
-	TP_printk("input pool: bytes %zu caller %pS",
-		  __entry->bytes, (void *)__entry->IP)
-);
-
-DEFINE_EVENT(random__mix_pool_bytes, mix_pool_bytes,
-	TP_PROTO(size_t bytes, unsigned long IP),
-
-	TP_ARGS(bytes, IP)
-);
-
-DEFINE_EVENT(random__mix_pool_bytes, mix_pool_bytes_nolock,
-	TP_PROTO(int bytes, unsigned long IP),
-
-	TP_ARGS(bytes, IP)
-);
-
-TRACE_EVENT(credit_entropy_bits,
-	TP_PROTO(size_t bits, size_t entropy_count, unsigned long IP),
-
-	TP_ARGS(bits, entropy_count, IP),
-
-	TP_STRUCT__entry(
-		__field(size_t,		bits			)
-		__field(size_t,		entropy_count		)
-		__field(unsigned long,	IP			)
-	),
-
-	TP_fast_assign(
-		__entry->bits		= bits;
-		__entry->entropy_count	= entropy_count;
-		__entry->IP		= IP;
-	),
-
-	TP_printk("input pool: bits %zu entropy_count %zu caller %pS",
-		  __entry->bits, __entry->entropy_count, (void *)__entry->IP)
-);
-
-TRACE_EVENT(add_input_randomness,
-	TP_PROTO(size_t input_bits),
-
-	TP_ARGS(input_bits),
-
-	TP_STRUCT__entry(
-		__field(size_t,	input_bits		)
-	),
-
-	TP_fast_assign(
-		__entry->input_bits	= input_bits;
-	),
-
-	TP_printk("input_pool_bits %zu", __entry->input_bits)
-);
-
-TRACE_EVENT(add_disk_randomness,
-	TP_PROTO(dev_t dev, size_t input_bits),
-
-	TP_ARGS(dev, input_bits),
-
-	TP_STRUCT__entry(
-		__field(dev_t,		dev			)
-		__field(size_t,		input_bits		)
-	),
-
-	TP_fast_assign(
-		__entry->dev		= dev;
-		__entry->input_bits	= input_bits;
-	),
-
-	TP_printk("dev %d,%d input_pool_bits %zu", MAJOR(__entry->dev),
-		  MINOR(__entry->dev), __entry->input_bits)
-);
-
-DECLARE_EVENT_CLASS(random__get_random_bytes,
-	TP_PROTO(size_t nbytes, unsigned long IP),
-
-	TP_ARGS(nbytes, IP),
-
-	TP_STRUCT__entry(
-		__field(size_t,		nbytes			)
-		__field(unsigned long,	IP			)
-	),
-
-	TP_fast_assign(
-		__entry->nbytes		= nbytes;
-		__entry->IP		= IP;
-	),
-
-	TP_printk("nbytes %zu caller %pS", __entry->nbytes, (void *)__entry->IP)
-);
-
-DEFINE_EVENT(random__get_random_bytes, get_random_bytes,
-	TP_PROTO(size_t nbytes, unsigned long IP),
-
-	TP_ARGS(nbytes, IP)
-);
-
-DEFINE_EVENT(random__get_random_bytes, get_random_bytes_arch,
-	TP_PROTO(size_t nbytes, unsigned long IP),
-
-	TP_ARGS(nbytes, IP)
-);
-
-DECLARE_EVENT_CLASS(random__extract_entropy,
-	TP_PROTO(size_t nbytes, size_t entropy_count),
-
-	TP_ARGS(nbytes, entropy_count),
-
-	TP_STRUCT__entry(
-		__field(  size_t,	nbytes			)
-		__field(  size_t,	entropy_count		)
-	),
-
-	TP_fast_assign(
-		__entry->nbytes		= nbytes;
-		__entry->entropy_count	= entropy_count;
-	),
-
-	TP_printk("input pool: nbytes %zu entropy_count %zu",
-		  __entry->nbytes, __entry->entropy_count)
-);
-
-
-DEFINE_EVENT(random__extract_entropy, extract_entropy,
-	TP_PROTO(size_t nbytes, size_t entropy_count),
-
-	TP_ARGS(nbytes, entropy_count)
-);
-
-TRACE_EVENT(urandom_read,
-	TP_PROTO(size_t nbytes, size_t entropy_count),
-
-	TP_ARGS(nbytes, entropy_count),
-
-	TP_STRUCT__entry(
-		__field( size_t,	nbytes		)
-		__field( size_t,	entropy_count	)
-	),
-
-	TP_fast_assign(
-		__entry->nbytes		= nbytes;
-		__entry->entropy_count	= entropy_count;
-	),
-
-	TP_printk("reading: nbytes %zu entropy_count %zu",
-		  __entry->nbytes, __entry->entropy_count)
-);
-
-TRACE_EVENT(prandom_u32,
-
-	TP_PROTO(unsigned int ret),
-
-	TP_ARGS(ret),
-
-	TP_STRUCT__entry(
-		__field(   unsigned int, ret)
-	),
-
-	TP_fast_assign(
-		__entry->ret = ret;
-	),
-
-	TP_printk("ret=%u" , __entry->ret)
-);
-
-#endif /* _TRACE_RANDOM_H */
-
-/* This part must be outside protection */
-#include <trace/define_trace.h>
--- a/lib/random32.c
+++ b/lib/random32.c
@@ -39,8 +39,8 @@
 #include <linux/random.h>
 #include <linux/sched.h>
 #include <linux/bitops.h>
+#include <linux/slab.h>
 #include <asm/unaligned.h>
-#include <trace/events/random.h>
 
 /**
  *	prandom_u32_state - seeded pseudo-random number generator.
@@ -386,7 +386,6 @@ u32 prandom_u32(void)
 	struct siprand_state *state = get_cpu_ptr(&net_rand_state);
 	u32 res = siprand_u32(state);
 
-	trace_prandom_u32(res);
 	put_cpu_ptr(&net_rand_state);
 	return res;
 }


