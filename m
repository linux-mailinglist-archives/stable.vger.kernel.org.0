Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90AC8551BC6
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:47:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348454AbiFTNpl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:45:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350348AbiFTNoz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:44:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE7FC2D1E7;
        Mon, 20 Jun 2022 06:16:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1D4E360A52;
        Mon, 20 Jun 2022 13:15:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D837CC3411B;
        Mon, 20 Jun 2022 13:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655730946;
        bh=+A60IEgZQhiSCyeaWDYzKTPIWYThC3l2l5FapeU37Jw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KI07+t4xSHZP0eghpuD2wxIjdqgW75w5moVh8crQEzt1bv00XvDI+gSKzBYifJ2cw
         FDU/yZS4eK0jiQZuyyY7NU9UmzBc/D7kPtY16YMNv0RG4kLJ/W+IwwoeEXfFoEuS+2
         zS1J/WgmQjJeoGzg9q7amD2qiYCwhDbVAEd2FwwY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        Eric Biggers <ebiggers@kernel.org>,
        Eric Biggers <ebiggers@google.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.4 068/240] random: always wake up entropy writers after extraction
Date:   Mon, 20 Jun 2022 14:49:29 +0200
Message-Id: <20220620124740.386040584@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124737.799371052@linuxfoundation.org>
References: <20220620124737.799371052@linuxfoundation.org>
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
 Documentation/admin-guide/sysctl/kernel.rst |   44 ++++++++++++++++++++++++++--
 drivers/char/random.c                       |   36 ++++++++--------------
 2 files changed, 56 insertions(+), 24 deletions(-)

--- a/Documentation/admin-guide/sysctl/kernel.rst
+++ b/Documentation/admin-guide/sysctl/kernel.rst
@@ -862,9 +862,49 @@ The kernel command line parameter printk
 a one-time setting until next reboot: once set, it cannot be changed by
 this sysctl interface anymore.
 
+pty
+===
 
-randomize_va_space:
-===================
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
@@ -1633,9 +1628,9 @@ SYSCALL_DEFINE3(getrandom, char __user *
 
 #include <linux/sysctl.h>
 
-static int min_write_thresh;
-static int max_write_thresh = POOL_BITS;
 static int random_min_urandom_seed = 60;
+static int random_write_wakeup_bits = POOL_MIN_BITS;
+static int sysctl_poolsize = POOL_BITS;
 static char sysctl_bootid[16];
 
 /*
@@ -1674,7 +1669,6 @@ static int proc_do_uuid(struct ctl_table
 	return proc_dostring(&fake_table, write, buffer, lenp, ppos);
 }
 
-static int sysctl_poolsize = POOL_BITS;
 extern struct ctl_table random_table[];
 struct ctl_table random_table[] = {
 	{
@@ -1696,9 +1690,7 @@ struct ctl_table random_table[] = {
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
@@ -1879,13 +1871,13 @@ void add_hwgenerator_randomness(const ch
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


