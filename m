Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D9085585DE
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 20:05:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235882AbiFWSFh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 14:05:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235905AbiFWSEx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 14:04:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 468B0B8F84;
        Thu, 23 Jun 2022 10:17:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A76E61DEE;
        Thu, 23 Jun 2022 17:17:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CC58C3411B;
        Thu, 23 Jun 2022 17:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656004644;
        bh=rM3kl0vv2bjgSwp+qxFhlAqocre7jchX693t5VQTPnQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=skKHpAZpinAdyfRbeDGPOMZAtsI5w/kGlhJyY85hcCnOPIAyUO/pRHySN/tLtLA7+
         ppTJtfoW6DACU/nJnxoF3DIqakXY+uEWCkgFwqTZ8xdHKtHfV9sLxJFBQDaLZ0vOo3
         6IFmL1iROU8dn0Mc1SUEOjxjbl1/Jw1Y10TkfLtQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        Eric Biggers <ebiggers@google.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.19 104/234] random: rewrite header introductory comment
Date:   Thu, 23 Jun 2022 18:42:51 +0200
Message-Id: <20220623164346.001926392@linuxfoundation.org>
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

commit 5f75d9f3babea8ae0a2d06724656874f41d317f5 upstream.

Now that we've re-documented the various sections, we can remove the
outdated text here and replace it with a high-level overview.

Cc: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Reviewed-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |  179 +++++---------------------------------------------
 1 file changed, 19 insertions(+), 160 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -2,168 +2,27 @@
 /*
  * Copyright (C) 2017-2022 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
  * Copyright Matt Mackall <mpm@selenic.com>, 2003, 2004, 2005
- * Copyright Theodore Ts'o, 1994, 1995, 1996, 1997, 1998, 1999.  All
- * rights reserved.
- */
-
-/*
- * Exported interfaces ---- output
- * ===============================
- *
- * There are four exported interfaces; two for use within the kernel,
- * and two for use from userspace.
- *
- * Exported interfaces ---- userspace output
- * -----------------------------------------
- *
- * The userspace interfaces are two character devices /dev/random and
- * /dev/urandom.  /dev/random is suitable for use when very high
- * quality randomness is desired (for example, for key generation or
- * one-time pads), as it will only return a maximum of the number of
- * bits of randomness (as estimated by the random number generator)
- * contained in the entropy pool.
- *
- * The /dev/urandom device does not have this limit, and will return
- * as many bytes as are requested.  As more and more random bytes are
- * requested without giving time for the entropy pool to recharge,
- * this will result in random numbers that are merely cryptographically
- * strong.  For many applications, however, this is acceptable.
- *
- * Exported interfaces ---- kernel output
- * --------------------------------------
- *
- * The primary kernel interfaces are:
- *
- *	void get_random_bytes(void *buf, size_t nbytes);
- *	u32 get_random_u32()
- *	u64 get_random_u64()
- *	unsigned int get_random_int()
- *	unsigned long get_random_long()
- *
- * These interfaces will return the requested number of random bytes
- * into the given buffer or as a return value. This is equivalent to a
- * read from /dev/urandom. The get_random_{u32,u64,int,long}() family
- * of functions may be higher performance for one-off random integers,
- * because they do a bit of buffering.
- *
- * prandom_u32()
- * -------------
- *
- * For even weaker applications, see the pseudorandom generator
- * prandom_u32(), prandom_max(), and prandom_bytes().  If the random
- * numbers aren't security-critical at all, these are *far* cheaper.
- * Useful for self-tests, random error simulation, randomized backoffs,
- * and any other application where you trust that nobody is trying to
- * maliciously mess with you by guessing the "random" numbers.
- *
- * Exported interfaces ---- input
- * ==============================
- *
- * The current exported interfaces for gathering environmental noise
- * from the devices are:
- *
- *	void add_device_randomness(const void *buf, size_t size);
- *	void add_input_randomness(unsigned int type, unsigned int code,
- *                                unsigned int value);
- *	void add_interrupt_randomness(int irq);
- *	void add_disk_randomness(struct gendisk *disk);
- *	void add_hwgenerator_randomness(const void *buffer, size_t count,
- *					size_t entropy);
- *	void add_bootloader_randomness(const void *buf, size_t size);
- *
- * add_device_randomness() is for adding data to the random pool that
- * is likely to differ between two devices (or possibly even per boot).
- * This would be things like MAC addresses or serial numbers, or the
- * read-out of the RTC. This does *not* add any actual entropy to the
- * pool, but it initializes the pool to different values for devices
- * that might otherwise be identical and have very little entropy
- * available to them (particularly common in the embedded world).
- *
- * add_input_randomness() uses the input layer interrupt timing, as well as
- * the event type information from the hardware.
- *
- * add_interrupt_randomness() uses the interrupt timing as random
- * inputs to the entropy pool. Using the cycle counters and the irq source
- * as inputs, it feeds the randomness roughly once a second.
- *
- * add_disk_randomness() uses what amounts to the seek time of block
- * layer request events, on a per-disk_devt basis, as input to the
- * entropy pool. Note that high-speed solid state drives with very low
- * seek times do not make for good sources of entropy, as their seek
- * times are usually fairly consistent.
- *
- * All of these routines try to estimate how many bits of randomness a
- * particular randomness source.  They do this by keeping track of the
- * first and second order deltas of the event timings.
- *
- * add_hwgenerator_randomness() is for true hardware RNGs, and will credit
- * entropy as specified by the caller. If the entropy pool is full it will
- * block until more entropy is needed.
- *
- * add_bootloader_randomness() is the same as add_hwgenerator_randomness() or
- * add_device_randomness(), depending on whether or not the configuration
- * option CONFIG_RANDOM_TRUST_BOOTLOADER is set.
- *
- * Ensuring unpredictability at system startup
- * ============================================
- *
- * When any operating system starts up, it will go through a sequence
- * of actions that are fairly predictable by an adversary, especially
- * if the start-up does not involve interaction with a human operator.
- * This reduces the actual number of bits of unpredictability in the
- * entropy pool below the value in entropy_count.  In order to
- * counteract this effect, it helps to carry information in the
- * entropy pool across shut-downs and start-ups.  To do this, put the
- * following lines an appropriate script which is run during the boot
- * sequence:
- *
- *	echo "Initializing random number generator..."
- *	random_seed=/var/run/random-seed
- *	# Carry a random seed from start-up to start-up
- *	# Load and then save the whole entropy pool
- *	if [ -f $random_seed ]; then
- *		cat $random_seed >/dev/urandom
- *	else
- *		touch $random_seed
- *	fi
- *	chmod 600 $random_seed
- *	dd if=/dev/urandom of=$random_seed count=1 bs=512
- *
- * and the following lines in an appropriate script which is run as
- * the system is shutdown:
- *
- *	# Carry a random seed from shut-down to start-up
- *	# Save the whole entropy pool
- *	echo "Saving random seed..."
- *	random_seed=/var/run/random-seed
- *	touch $random_seed
- *	chmod 600 $random_seed
- *	dd if=/dev/urandom of=$random_seed count=1 bs=512
- *
- * For example, on most modern systems using the System V init
- * scripts, such code fragments would be found in
- * /etc/rc.d/init.d/random.  On older Linux systems, the correct script
- * location might be in /etc/rcb.d/rc.local or /etc/rc.d/rc.0.
- *
- * Effectively, these commands cause the contents of the entropy pool
- * to be saved at shut-down time and reloaded into the entropy pool at
- * start-up.  (The 'dd' in the addition to the bootup script is to
- * make sure that /etc/random-seed is different for every start-up,
- * even if the system crashes without executing rc.0.)  Even with
- * complete knowledge of the start-up activities, predicting the state
- * of the entropy pool requires knowledge of the previous history of
- * the system.
- *
- * Configuring the /dev/random driver under Linux
- * ==============================================
+ * Copyright Theodore Ts'o, 1994, 1995, 1996, 1997, 1998, 1999. All rights reserved.
  *
- * The /dev/random driver under Linux uses minor numbers 8 and 9 of
- * the /dev/mem major number (#1).  So if your system does not have
- * /dev/random and /dev/urandom created already, they can be created
- * by using the commands:
+ * This driver produces cryptographically secure pseudorandom data. It is divided
+ * into roughly six sections, each with a section header:
  *
- *	mknod /dev/random c 1 8
- *	mknod /dev/urandom c 1 9
+ *   - Initialization and readiness waiting.
+ *   - Fast key erasure RNG, the "crng".
+ *   - Entropy accumulation and extraction routines.
+ *   - Entropy collection routines.
+ *   - Userspace reader/writer interfaces.
+ *   - Sysctl interface.
+ *
+ * The high level overview is that there is one input pool, into which
+ * various pieces of data are hashed. Some of that data is then "credited" as
+ * having a certain number of bits of entropy. When enough bits of entropy are
+ * available, the hash is finalized and handed as a key to a stream cipher that
+ * expands it indefinitely for various consumers. This key is periodically
+ * refreshed as the various entropy collectors, described below, add data to the
+ * input pool and credit it. There is currently no Fortuna-like scheduler
+ * involved, which can lead to malicious entropy sources causing a premature
+ * reseed, and the entropy estimates are, at best, conservative guesses.
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt


