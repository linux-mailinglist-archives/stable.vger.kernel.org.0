Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA45F558106
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 18:55:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232225AbiFWQz2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 12:55:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233042AbiFWQuG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 12:50:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8426642EC1;
        Thu, 23 Jun 2022 09:48:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4747861F9A;
        Thu, 23 Jun 2022 16:48:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28E21C3411B;
        Thu, 23 Jun 2022 16:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656002888;
        bh=bnn4x3t9zzHo0gJCq3F1t6FVgVpfIONRXwGR9wWII8Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NuXspwkVXJclBoG2dbT/eRWXoJdqDlebDJ7Q1Gf/JEzhFjc0Rf2iN0D9eEL5u/wtp
         gBHEsijnFOJH+Pw5lo3KD0/+LfKVWR6Xs3WN9VPWLIq5bMjn7MF+6tmnwArhA795Ge
         1wUDxcLqHM6guZD7KndO6xx5edm1GJKFRHpJKXy8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andy Lutomirski <luto@kernel.org>,
        Theodore Tso <tytso@mit.edu>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.9 059/264] random: remove the blocking pool
Date:   Thu, 23 Jun 2022 18:40:52 +0200
Message-Id: <20220623164345.742712133@linuxfoundation.org>
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

From: Andy Lutomirski <luto@kernel.org>

commit 90ea1c6436d26e62496616fb5891e00819ff4849 upstream.

There is no longer any interface to read data from the blocking
pool, so remove it.

This enables quite a bit of code deletion, much of which will be
done in subsequent patches.

Signed-off-by: Andy Lutomirski <luto@kernel.org>
Link: https://lore.kernel.org/r/511225a224bf0a291149d3c0b8b45393cd03ab96.1577088521.git.luto@kernel.org
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |  106 --------------------------------------------------
 1 file changed, 106 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -471,7 +471,6 @@ static const struct poolinfo {
 /*
  * Static global variables
  */
-static DECLARE_WAIT_QUEUE_HEAD(random_read_wait);
 static DECLARE_WAIT_QUEUE_HEAD(random_write_wait);
 static struct fasync_struct *fasync;
 
@@ -533,7 +532,6 @@ struct entropy_store {
 	__u32 *pool;
 	const char *name;
 	struct entropy_store *pull;
-	struct work_struct push_work;
 
 	/* read-write data: */
 	unsigned long last_pulled;
@@ -552,9 +550,7 @@ static ssize_t _extract_entropy(struct e
 				size_t nbytes, int fips);
 
 static void crng_reseed(struct crng_state *crng, struct entropy_store *r);
-static void push_to_pool(struct work_struct *work);
 static __u32 input_pool_data[INPUT_POOL_WORDS] __latent_entropy;
-static __u32 blocking_pool_data[OUTPUT_POOL_WORDS] __latent_entropy;
 
 static struct entropy_store input_pool = {
 	.poolinfo = &poolinfo_table[0],
@@ -563,16 +559,6 @@ static struct entropy_store input_pool =
 	.pool = input_pool_data
 };
 
-static struct entropy_store blocking_pool = {
-	.poolinfo = &poolinfo_table[1],
-	.name = "blocking",
-	.pull = &input_pool,
-	.lock = __SPIN_LOCK_UNLOCKED(blocking_pool.lock),
-	.pool = blocking_pool_data,
-	.push_work = __WORK_INITIALIZER(blocking_pool.push_work,
-					push_to_pool),
-};
-
 static __u32 const twist_table[8] = {
 	0x00000000, 0x3b6e20c8, 0x76dc4190, 0x4db26158,
 	0xedb88320, 0xd6d6a3e8, 0x9b64c2b0, 0xa00ae278 };
@@ -768,15 +754,11 @@ retry:
 		entropy_count = 0;
 	} else if (entropy_count > pool_size)
 		entropy_count = pool_size;
-	if ((r == &blocking_pool) && !r->initialized &&
-	    (entropy_count >> ENTROPY_SHIFT) > 128)
-		has_initialized = 1;
 	if (cmpxchg(&r->entropy_count, orig, entropy_count) != orig)
 		goto retry;
 
 	if (has_initialized) {
 		r->initialized = 1;
-		wake_up_interruptible(&random_read_wait);
 		kill_fasync(&fasync, SIGIO, POLL_IN);
 	}
 
@@ -785,7 +767,6 @@ retry:
 
 	if (r == &input_pool) {
 		int entropy_bits = entropy_count >> ENTROPY_SHIFT;
-		struct entropy_store *other = &blocking_pool;
 
 		if (crng_init < 2) {
 			if (entropy_bits < 128)
@@ -793,27 +774,6 @@ retry:
 			crng_reseed(&primary_crng, r);
 			entropy_bits = r->entropy_count >> ENTROPY_SHIFT;
 		}
-
-		/* initialize the blocking pool if necessary */
-		if (entropy_bits >= random_read_wakeup_bits &&
-		    !other->initialized) {
-			schedule_work(&other->push_work);
-			return;
-		}
-
-		/* should we wake readers? */
-		if (entropy_bits >= random_read_wakeup_bits &&
-		    wq_has_sleeper(&random_read_wait)) {
-			wake_up_interruptible(&random_read_wait);
-		}
-		/* If the input pool is getting full, and the blocking
-		 * pool has room, send some entropy to the blocking
-		 * pool.
-		 */
-		if (!work_pending(&other->push_work) &&
-		    (ENTROPY_BITS(r) > 6 * r->poolinfo->poolbytes) &&
-		    (ENTROPY_BITS(other) <= 6 * other->poolinfo->poolbytes))
-			schedule_work(&other->push_work);
 	}
 }
 
@@ -1491,22 +1451,6 @@ static void _xfer_secondary_pool(struct
 }
 
 /*
- * Used as a workqueue function so that when the input pool is getting
- * full, we can "spill over" some entropy to the output pools.  That
- * way the output pools can store some of the excess entropy instead
- * of letting it go to waste.
- */
-static void push_to_pool(struct work_struct *work)
-{
-	struct entropy_store *r = container_of(work, struct entropy_store,
-					      push_work);
-	BUG_ON(!r);
-	_xfer_secondary_pool(r, random_read_wakeup_bits/8);
-	trace_push_to_pool(r->name, r->entropy_count >> ENTROPY_SHIFT,
-			   r->pull->entropy_count >> ENTROPY_SHIFT);
-}
-
-/*
  * This function decides how many bytes to actually take from the
  * given pool, and also debits the entropy count accordingly.
  */
@@ -1684,54 +1628,6 @@ static ssize_t extract_entropy(struct en
 	return _extract_entropy(r, buf, nbytes, fips_enabled);
 }
 
-/*
- * This function extracts randomness from the "entropy pool", and
- * returns it in a userspace buffer.
- */
-static ssize_t extract_entropy_user(struct entropy_store *r, void __user *buf,
-				    size_t nbytes)
-{
-	ssize_t ret = 0, i;
-	__u8 tmp[EXTRACT_SIZE];
-	int large_request = (nbytes > 256);
-
-	trace_extract_entropy_user(r->name, nbytes, ENTROPY_BITS(r), _RET_IP_);
-	if (!r->initialized && r->pull) {
-		xfer_secondary_pool(r, ENTROPY_BITS(r->pull)/8);
-		if (!r->initialized)
-			return 0;
-	}
-	xfer_secondary_pool(r, nbytes);
-	nbytes = account(r, nbytes, 0, 0);
-
-	while (nbytes) {
-		if (large_request && need_resched()) {
-			if (signal_pending(current)) {
-				if (ret == 0)
-					ret = -ERESTARTSYS;
-				break;
-			}
-			schedule();
-		}
-
-		extract_buf(r, tmp);
-		i = min_t(int, nbytes, EXTRACT_SIZE);
-		if (copy_to_user(buf, tmp, i)) {
-			ret = -EFAULT;
-			break;
-		}
-
-		nbytes -= i;
-		buf += i;
-		ret += i;
-	}
-
-	/* Wipe data just returned from memory */
-	memzero_explicit(tmp, sizeof(tmp));
-
-	return ret;
-}
-
 #define warn_unseeded_randomness(previous) \
 	_warn_unseeded_randomness(__func__, (void *) _RET_IP_, (previous))
 
@@ -1961,7 +1857,6 @@ static void __init init_std_data(struct
 int __init rand_initialize(void)
 {
 	init_std_data(&input_pool);
-	init_std_data(&blocking_pool);
 	if (crng_need_final_init)
 		crng_finalize_init(&primary_crng);
 	crng_initialize(&primary_crng);
@@ -2132,7 +2027,6 @@ static long random_ioctl(struct file *f,
 		if (!capable(CAP_SYS_ADMIN))
 			return -EPERM;
 		input_pool.entropy_count = 0;
-		blocking_pool.entropy_count = 0;
 		return 0;
 	case RNDRESEEDCRNG:
 		if (!capable(CAP_SYS_ADMIN))


