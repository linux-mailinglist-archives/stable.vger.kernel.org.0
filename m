Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED1AF5580AD
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 18:53:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbiFWQw7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 12:52:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233828AbiFWQvm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 12:51:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E608286;
        Thu, 23 Jun 2022 09:50:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 22B7C61FBF;
        Thu, 23 Jun 2022 16:50:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B975EC3411B;
        Thu, 23 Jun 2022 16:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656003006;
        bh=veAEAwIenDtLv4KEbl6EfcTrELtYPqBLwzi1IGMjgUY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iZGVzrDW3hiMMgpWyICZPlcs1x8smykACDjFcTHm6NuCDAU1KMVAbKHqD8mgg3YBa
         de8JEKzmx0zeO9U4Ocy5OSiLP3oAE3QMq5+lUBwe6VjvkQmEiP20+QJtO2gj8bwJZr
         cHXMT+MMIXjNjMuCwq95HRp2jnlBTQWBxjoeWIIg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ahmed Darwish <darwish.07@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Theodore Tso <tytso@mit.edu>,
        Nicholas Mc Guire <hofrat@opentech.at>,
        Andy Lutomirski <luto@kernel.org>,
        Kees Cook <keescook@chromium.org>, Willy Tarreau <w@1wt.eu>,
        "Alexander E. Patrakov" <patrakov@gmail.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Noah Meyerhans <noahm@debian.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.9 099/264] random: try to actively add entropy rather than passively wait for it
Date:   Thu, 23 Jun 2022 18:41:32 +0200
Message-Id: <20220623164346.872243127@linuxfoundation.org>
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

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 50ee7529ec4500c88f8664560770a7a1b65db72b upstream.

For 5.3 we had to revert a nice ext4 IO pattern improvement, because it
caused a bootup regression due to lack of entropy at bootup together
with arguably broken user space that was asking for secure random
numbers when it really didn't need to.

See commit 72dbcf721566 (Revert "ext4: make __ext4_get_inode_loc plug").

This aims to solve the issue by actively generating entropy noise using
the CPU cycle counter when waiting for the random number generator to
initialize.  This only works when you have a high-frequency time stamp
counter available, but that's the case on all modern x86 CPU's, and on
most other modern CPU's too.

What we do is to generate jitter entropy from the CPU cycle counter
under a somewhat complex load: calling the scheduler while also
guaranteeing a certain amount of timing noise by also triggering a
timer.

I'm sure we can tweak this, and that people will want to look at other
alternatives, but there's been a number of papers written on jitter
entropy, and this should really be fairly conservative by crediting one
bit of entropy for every timer-induced jump in the cycle counter.  Not
because the timer itself would be all that unpredictable, but because
the interaction between the timer and the loop is going to be.

Even if (and perhaps particularly if) the timer actually happens on
another CPU, the cacheline interaction between the loop that reads the
cycle counter and the timer itself firing is going to add perturbations
to the cycle counter values that get mixed into the entropy pool.

As Thomas pointed out, with a modern out-of-order CPU, even quite simple
loops show a fair amount of hard-to-predict timing variability even in
the absense of external interrupts.  But this tries to take that further
by actually having a fairly complex interaction.

This is not going to solve the entropy issue for architectures that have
no CPU cycle counter, but it's not clear how (and if) that is solvable,
and the hardware in question is largely starting to be irrelevant.  And
by doing this we can at least avoid some of the even more contentious
approaches (like making the entropy waiting time out in order to avoid
the possibly unbounded waiting).

Cc: Ahmed Darwish <darwish.07@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Nicholas Mc Guire <hofrat@opentech.at>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Willy Tarreau <w@1wt.eu>
Cc: Alexander E. Patrakov <patrakov@gmail.com>
Cc: Lennart Poettering <mzxreary@0pointer.de>
Cc: Noah Meyerhans <noahm@debian.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |   62 +++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 61 insertions(+), 1 deletion(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1573,6 +1573,56 @@ void get_random_bytes(void *buf, int nby
 }
 EXPORT_SYMBOL(get_random_bytes);
 
+
+/*
+ * Each time the timer fires, we expect that we got an unpredictable
+ * jump in the cycle counter. Even if the timer is running on another
+ * CPU, the timer activity will be touching the stack of the CPU that is
+ * generating entropy..
+ *
+ * Note that we don't re-arm the timer in the timer itself - we are
+ * happy to be scheduled away, since that just makes the load more
+ * complex, but we do not want the timer to keep ticking unless the
+ * entropy loop is running.
+ *
+ * So the re-arming always happens in the entropy loop itself.
+ */
+static void entropy_timer(unsigned long data)
+{
+	credit_entropy_bits(&input_pool, 1);
+}
+
+/*
+ * If we have an actual cycle counter, see if we can
+ * generate enough entropy with timing noise
+ */
+static void try_to_generate_entropy(void)
+{
+	struct {
+		unsigned long now;
+		struct timer_list timer;
+	} stack;
+
+	stack.now = random_get_entropy();
+
+	/* Slow counter - or none. Don't even bother */
+	if (stack.now == random_get_entropy())
+		return;
+
+	__setup_timer_on_stack(&stack.timer, entropy_timer, 0, 0);
+	while (!crng_ready()) {
+		if (!timer_pending(&stack.timer))
+			mod_timer(&stack.timer, jiffies+1);
+		mix_pool_bytes(&input_pool, &stack.now, sizeof(stack.now));
+		schedule();
+		stack.now = random_get_entropy();
+	}
+
+	del_timer_sync(&stack.timer);
+	destroy_timer_on_stack(&stack.timer);
+	mix_pool_bytes(&input_pool, &stack.now, sizeof(stack.now));
+}
+
 /*
  * Wait for the urandom pool to be seeded and thus guaranteed to supply
  * cryptographically secure random numbers. This applies to: the /dev/urandom
@@ -1587,7 +1637,17 @@ int wait_for_random_bytes(void)
 {
 	if (likely(crng_ready()))
 		return 0;
-	return wait_event_interruptible(crng_init_wait, crng_ready());
+
+	do {
+		int ret;
+		ret = wait_event_interruptible_timeout(crng_init_wait, crng_ready(), HZ);
+		if (ret)
+			return ret > 0 ? 0 : ret;
+
+		try_to_generate_entropy();
+	} while (!crng_ready());
+
+	return 0;
 }
 EXPORT_SYMBOL(wait_for_random_bytes);
 


