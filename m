Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D4D5535CB1
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 11:09:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234475AbiE0I6q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 04:58:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350188AbiE0I47 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 04:56:59 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B140A5D67F;
        Fri, 27 May 2022 01:54:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5959FCE238F;
        Fri, 27 May 2022 08:54:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F538C385A9;
        Fri, 27 May 2022 08:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653641674;
        bh=WPmKZxR6+87A9ebPxq6085kpMuJiIzfTjd0GcDaqNKM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mc6LbID4irsK4sjorVpa+L/y5+EzRY2y4Wjuv5ukrk8uFV5GRKz9Jaz5WfaIvsW5s
         JhPMIlPsiU9svb7HKq3dRUJyHJhnvk4EenSH4urCqd3G0i3Tu1ljZbeqYn+nyDgjZ4
         nqRSrKQNGsOzgMgMakCKnCh3Qs2IIFBkKmatpa3E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        Eric Biggers <ebiggers@kernel.org>,
        Eric Biggers <ebiggers@google.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.17 006/111] random: always wake up entropy writers after extraction
Date:   Fri, 27 May 2022 10:48:38 +0200
Message-Id: <20220527084820.012764833@linuxfoundation.org>
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

commit 489c7fc44b5740d377e8cfdbf0851036e493af00 upstream.

Now that POOL_BITS == POOL_MIN_BITS, we must unconditionally wake up
entropy writers after every extraction. Therefore there's no point of
write_wakeup_threshold, so we can move it to the dustbin of unused
compatibility sysctls. While we're at it, we can fix a small comparison
where we were waking up after <= min rather than < min.

Cc: Theodore Ts'o <tytso@mit.edu>
Suggested-by: Eric Biggers <ebiggers@kernel.org>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Reviewed-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/admin-guide/sysctl/kernel.rst |    7 ++++-
 drivers/char/random.c                       |   33 +++++++++-------------------
 2 files changed, 16 insertions(+), 24 deletions(-)

--- a/Documentation/admin-guide/sysctl/kernel.rst
+++ b/Documentation/admin-guide/sysctl/kernel.rst
@@ -1030,14 +1030,17 @@ This is a directory, with the following
 * ``poolsize``: the entropy pool size, in bits;
 
 * ``urandom_min_reseed_secs``: obsolete (used to determine the minimum
-  number of seconds between urandom pool reseeding).
+  number of seconds between urandom pool reseeding). This file is
+  writable for compatibility purposes, but writing to it has no effect
+  on any RNG behavior.
 
 * ``uuid``: a UUID generated every time this is retrieved (this can
   thus be used to generate UUIDs at will);
 
 * ``write_wakeup_threshold``: when the entropy count drops below this
   (as a number of bits), processes waiting to write to ``/dev/random``
-  are woken up.
+  are woken up. This file is writable for compatibility purposes, but
+  writing to it has no effect on any RNG behavior.
 
 If ``drivers/char/random.c`` is built with ``ADD_INTERRUPT_BENCH``
 defined, these additional entries are present:
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -296,12 +296,6 @@ enum {
  */
 static DECLARE_WAIT_QUEUE_HEAD(random_write_wait);
 static struct fasync_struct *fasync;
-/*
- * If the entropy count falls under this number of bits, then we
- * should wake up processes which are selecting or polling on write
- * access to /dev/random.
- */
-static int random_write_wakeup_bits = POOL_MIN_BITS;
 
 static DEFINE_SPINLOCK(random_ready_list_lock);
 static LIST_HEAD(random_ready_list);
@@ -739,10 +733,8 @@ static void crng_reseed(struct crng_stat
 				return;
 		} while (cmpxchg(&input_pool.entropy_count, entropy_count, 0) != entropy_count);
 		extract_entropy(buf.key, sizeof(buf.key));
-		if (random_write_wakeup_bits) {
-			wake_up_interruptible(&random_write_wait);
-			kill_fasync(&fasync, SIGIO, POLL_OUT);
-		}
+		wake_up_interruptible(&random_write_wait);
+		kill_fasync(&fasync, SIGIO, POLL_OUT);
 	} else {
 		_extract_crng(&primary_crng, buf.block);
 		_crng_backtrack_protect(&primary_crng, buf.block,
@@ -1471,7 +1463,7 @@ static __poll_t random_poll(struct file
 	mask = 0;
 	if (crng_ready())
 		mask |= EPOLLIN | EPOLLRDNORM;
-	if (input_pool.entropy_count < random_write_wakeup_bits)
+	if (input_pool.entropy_count < POOL_MIN_BITS)
 		mask |= EPOLLOUT | EPOLLWRNORM;
 	return mask;
 }
@@ -1556,7 +1548,7 @@ static long random_ioctl(struct file *f,
 		 */
 		if (!capable(CAP_SYS_ADMIN))
 			return -EPERM;
-		if (xchg(&input_pool.entropy_count, 0) && random_write_wakeup_bits) {
+		if (xchg(&input_pool.entropy_count, 0)) {
 			wake_up_interruptible(&random_write_wait);
 			kill_fasync(&fasync, SIGIO, POLL_OUT);
 		}
@@ -1636,9 +1628,9 @@ SYSCALL_DEFINE3(getrandom, char __user *
 
 #include <linux/sysctl.h>
 
-static int min_write_thresh;
-static int max_write_thresh = POOL_BITS;
 static int random_min_urandom_seed = 60;
+static int random_write_wakeup_bits = POOL_MIN_BITS;
+static int sysctl_poolsize = POOL_BITS;
 static char sysctl_bootid[16];
 
 /*
@@ -1677,7 +1669,6 @@ static int proc_do_uuid(struct ctl_table
 	return proc_dostring(&fake_table, write, buffer, lenp, ppos);
 }
 
-static int sysctl_poolsize = POOL_BITS;
 static struct ctl_table random_table[] = {
 	{
 		.procname	= "poolsize",
@@ -1698,9 +1689,7 @@ static struct ctl_table random_table[] =
 		.data		= &random_write_wakeup_bits,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &min_write_thresh,
-		.extra2		= &max_write_thresh,
+		.proc_handler	= proc_dointvec,
 	},
 	{
 		.procname	= "urandom_min_reseed_secs",
@@ -1892,13 +1881,13 @@ void add_hwgenerator_randomness(const ch
 	}
 
 	/* Throttle writing if we're above the trickle threshold.
-	 * We'll be woken up again once below random_write_wakeup_thresh,
-	 * when the calling thread is about to terminate, or once
-	 * CRNG_RESEED_INTERVAL has lapsed.
+	 * We'll be woken up again once below POOL_MIN_BITS, when
+	 * the calling thread is about to terminate, or once
+	 * CRNG_RESEED_INTERVAL has elapsed.
 	 */
 	wait_event_interruptible_timeout(random_write_wait,
 			!system_wq || kthread_should_stop() ||
-			input_pool.entropy_count <= random_write_wakeup_bits,
+			input_pool.entropy_count < POOL_MIN_BITS,
 			CRNG_RESEED_INTERVAL);
 	mix_pool_bytes(buffer, count);
 	credit_entropy_bits(entropy);


