Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04FC614E205
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 19:50:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731635AbgA3Ss5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 13:48:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:60070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731603AbgA3Ssw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 13:48:52 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C2F6205F4;
        Thu, 30 Jan 2020 18:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580410131;
        bh=GxV6/wY7RDwG93sqU4ChZ6H7RM0RrA9IBv0IyeHT6/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oN8USJhT8bds5aXcgzsaG+0NylYfWDInLy0sNnU7Hr+K7SyH0hf2673zW6T2c8GDb
         Iw+mGuM+bzh0wlvkF3NKMKfl0FqciYaiZyImAGKwzUijVoVA8kWQE+koPlN3Dh4WzG
         E9jG5Ki/CsFglKquB9UM389IG6ivOhThBK4raY5M=
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
Subject: [PATCH 4.19 52/55] random: try to actively add entropy rather than passively wait for it
Date:   Thu, 30 Jan 2020 19:39:33 +0100
Message-Id: <20200130183617.871941331@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200130183608.563083888@linuxfoundation.org>
References: <20200130183608.563083888@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

---
 drivers/char/random.c |   62 +++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 61 insertions(+), 1 deletion(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1653,6 +1653,56 @@ void get_random_bytes(void *buf, int nby
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
+static void entropy_timer(struct timer_list *t)
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
+	timer_setup_on_stack(&stack.timer, entropy_timer, 0);
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
@@ -1667,7 +1717,17 @@ int wait_for_random_bytes(void)
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
 


