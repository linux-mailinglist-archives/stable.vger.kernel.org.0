Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3918D5585FE
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 20:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231945AbiFWSGv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 14:06:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236017AbiFWSGR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 14:06:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6AFD885A3;
        Thu, 23 Jun 2022 10:18:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6F1CBB82498;
        Thu, 23 Jun 2022 17:18:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7C52C3411B;
        Thu, 23 Jun 2022 17:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656004723;
        bh=c46pAXHq4U0E+vspwdos/oVmYZ8r+eZfjQNMySlGohs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vnw1HFHHuNZoW1T4RTZddl2WyvoNvFZXFwmGQckce59vtWiOdKIDbBP43Mo3ionVs
         gcVf8kFgOTcVglIkPIOBgqufk8jzsX+/bjSP9q7h+oZjf+fopHFjkVTyeY2BU7wzZD
         S6L9TpYZvla2Cf+V7ikrzAhWUlPr4wdJtHiujfkU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        Eric Biggers <ebiggers@kernel.org>,
        Eric Biggers <ebiggers@google.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.19 078/234] random: always wake up entropy writers after extraction
Date:   Thu, 23 Jun 2022 18:42:25 +0200
Message-Id: <20220623164345.266205691@linuxfoundation.org>
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
 Documentation/sysctl/kernel.txt |   44 ++++++++++++++++++++++++++++++++++++++--
 drivers/char/random.c           |   36 ++++++++++++--------------------
 2 files changed, 56 insertions(+), 24 deletions(-)

--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -821,9 +821,49 @@ The kernel command line parameter printk
 a one-time setting until next reboot: once set, it cannot be changed by
 this sysctl interface anymore.
 
-==============================================================
+pty
+===
 
-randomize_va_space:
+See Documentation/filesystems/devpts.rst.
+
+
+random
+======
+
+This is a directory, with the following entries:
+
+* ``boot_id``: a UUID generated the first time this is retrieved, and
+  unvarying after that;
+
+* ``entropy_avail``: the pool's entropy count, in bits;
+
+* ``poolsize``: the entropy pool size, in bits;
+
+* ``urandom_min_reseed_secs``: obsolete (used to determine the minimum
+  number of seconds between urandom pool reseeding). This file is
+  writable for compatibility purposes, but writing to it has no effect
+  on any RNG behavior.
+
+* ``uuid``: a UUID generated every time this is retrieved (this can
+  thus be used to generate UUIDs at will);
+
+* ``write_wakeup_threshold``: when the entropy count drops below this
+  (as a number of bits), processes waiting to write to ``/dev/random``
+  are woken up. This file is writable for compatibility purposes, but
+  writing to it has no effect on any RNG behavior.
+
+If ``drivers/char/random.c`` is built with ``ADD_INTERRUPT_BENCH``
+defined, these additional entries are present:
+
+* ``add_interrupt_avg_cycles``: the average number of cycles between
+  interrupts used to feed the pool;
+
+* ``add_interrupt_avg_deviation``: the standard deviation seen on the
+  number of cycles between interrupts used to feed the pool.
+
+
+randomize_va_space
+==================
 
 This option can be used to select the type of process address
 space randomization that is used in the system, for architectures
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
@@ -1556,7 +1548,10 @@ static long random_ioctl(struct file *f,
 		 */
 		if (!capable(CAP_SYS_ADMIN))
 			return -EPERM;
-		input_pool.entropy_count = 0;
+		if (xchg(&input_pool.entropy_count, 0)) {
+			wake_up_interruptible(&random_write_wait);
+			kill_fasync(&fasync, SIGIO, POLL_OUT);
+		}
 		return 0;
 	case RNDRESEEDCRNG:
 		if (!capable(CAP_SYS_ADMIN))
@@ -1631,9 +1626,9 @@ SYSCALL_DEFINE3(getrandom, char __user *
 
 #include <linux/sysctl.h>
 
-static int min_write_thresh;
-static int max_write_thresh = POOL_BITS;
 static int random_min_urandom_seed = 60;
+static int random_write_wakeup_bits = POOL_MIN_BITS;
+static int sysctl_poolsize = POOL_BITS;
 static char sysctl_bootid[16];
 
 /*
@@ -1672,7 +1667,6 @@ static int proc_do_uuid(struct ctl_table
 	return proc_dostring(&fake_table, write, buffer, lenp, ppos);
 }
 
-static int sysctl_poolsize = POOL_BITS;
 extern struct ctl_table random_table[];
 struct ctl_table random_table[] = {
 	{
@@ -1694,9 +1688,7 @@ struct ctl_table random_table[] = {
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
@@ -1877,13 +1869,13 @@ void add_hwgenerator_randomness(const ch
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


