Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC4EE55851D
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:54:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235359AbiFWRyG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:54:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235437AbiFWRwf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:52:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ED505130D;
        Thu, 23 Jun 2022 10:13:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 25EB261DB5;
        Thu, 23 Jun 2022 17:13:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC972C3411B;
        Thu, 23 Jun 2022 17:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656004399;
        bh=m7kM120IMBkZl5yCSd3oumv/sBJzACOrpODAReiXe78=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z5w4uF3680Him/kZ2hnesw9p996vkAcgLsa4/xfGxVFVEsb6L89eNhQfdL1AS4EAX
         +GYeS3VLBbTTOKMtw8Divh/gIVm8AGHbYfdr6z/B7sX+EnDIH/ZkNUdEETmUOk3U2i
         gUlHyP1nB1fie8RjQcqCtABYpfZeG+SzMGqZOJgU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andy Lutomirski <luto@kernel.org>,
        Theodore Tso <tytso@mit.edu>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.19 025/234] random: remove the blocking pool
Date:   Thu, 23 Jun 2022 18:41:32 +0200
Message-Id: <20220623164343.776643642@linuxfoundation.org>
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
@@ -470,7 +470,6 @@ static const struct poolinfo {
 /*
  * Static global variables
  */
-static DECLARE_WAIT_QUEUE_HEAD(random_read_wait);
 static DECLARE_WAIT_QUEUE_HEAD(random_write_wait);
 static struct fasync_struct *fasync;
 
@@ -532,7 +531,6 @@ struct entropy_store {
 	__u32 *pool;
 	const char *name;
 	struct entropy_store *pull;
-	struct work_struct push_work;
 
 	/* read-write data: */
 	unsigned long last_pulled;
@@ -551,9 +549,7 @@ static ssize_t _extract_entropy(struct e
 				size_t nbytes, int fips);
 
 static void crng_reseed(struct crng_state *crng, struct entropy_store *r);
-static void push_to_pool(struct work_struct *work);
 static __u32 input_pool_data[INPUT_POOL_WORDS] __latent_entropy;
-static __u32 blocking_pool_data[OUTPUT_POOL_WORDS] __latent_entropy;
 
 static struct entropy_store input_pool = {
 	.poolinfo = &poolinfo_table[0],
@@ -562,16 +558,6 @@ static struct entropy_store input_pool =
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
@@ -767,15 +753,11 @@ retry:
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
 
@@ -784,7 +766,6 @@ retry:
 
 	if (r == &input_pool) {
 		int entropy_bits = entropy_count >> ENTROPY_SHIFT;
-		struct entropy_store *other = &blocking_pool;
 
 		if (crng_init < 2) {
 			if (entropy_bits < 128)
@@ -792,27 +773,6 @@ retry:
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
 
@@ -1442,22 +1402,6 @@ static void _xfer_secondary_pool(struct
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
@@ -1635,54 +1579,6 @@ static ssize_t extract_entropy(struct en
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
 
@@ -1973,7 +1869,6 @@ static void __init init_std_data(struct
 int __init rand_initialize(void)
 {
 	init_std_data(&input_pool);
-	init_std_data(&blocking_pool);
 	if (crng_need_final_init)
 		crng_finalize_init(&primary_crng);
 	crng_initialize(&primary_crng);
@@ -2144,7 +2039,6 @@ static long random_ioctl(struct file *f,
 		if (!capable(CAP_SYS_ADMIN))
 			return -EPERM;
 		input_pool.entropy_count = 0;
-		blocking_pool.entropy_count = 0;
 		return 0;
 	case RNDRESEEDCRNG:
 		if (!capable(CAP_SYS_ADMIN))


