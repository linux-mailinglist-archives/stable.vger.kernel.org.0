Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C513520C08
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 18:02:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727446AbfEPQBO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 12:01:14 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42788 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726652AbfEPP6q (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 May 2019 11:58:46 -0400
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImD-0006zE-W8; Thu, 16 May 2019 16:58:38 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImD-0001OK-6o; Thu, 16 May 2019 16:58:37 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Ingo Molnar" <mingo@kernel.org>,
        "Dmitry Vyukov" <dvyukov@google.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Paolo Bonzini" <pbonzini@redhat.com>
Date:   Thu, 16 May 2019 16:55:33 +0100
Message-ID: <lsq.1558022133.672728982@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 25/86] locking/static_key: Fix concurrent
 static_key_slow_inc()
In-Reply-To: <lsq.1558022132.52852998@decadent.org.uk>
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.68-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Bonzini <pbonzini@redhat.com>

commit 4c5ea0a9cd02d6aa8adc86e100b2a4cff8d614ff upstream.

The following scenario is possible:

    CPU 1                                   CPU 2
    static_key_slow_inc()
     atomic_inc_not_zero()
      -> key.enabled == 0, no increment
     jump_label_lock()
     atomic_inc_return()
      -> key.enabled == 1 now
                                            static_key_slow_inc()
                                             atomic_inc_not_zero()
                                              -> key.enabled == 1, inc to 2
                                             return
                                            ** static key is wrong!
     jump_label_update()
     jump_label_unlock()

Testing the static key at the point marked by (**) will follow the
wrong path for jumps that have not been patched yet.  This can
actually happen when creating many KVM virtual machines with userspace
LAPIC emulation; just run several copies of the following program:

    #include <fcntl.h>
    #include <unistd.h>
    #include <sys/ioctl.h>
    #include <linux/kvm.h>

    int main(void)
    {
        for (;;) {
            int kvmfd = open("/dev/kvm", O_RDONLY);
            int vmfd = ioctl(kvmfd, KVM_CREATE_VM, 0);
            close(ioctl(vmfd, KVM_CREATE_VCPU, 1));
            close(vmfd);
            close(kvmfd);
        }
        return 0;
    }

Every KVM_CREATE_VCPU ioctl will attempt a static_key_slow_inc() call.
The static key's purpose is to skip NULL pointer checks and indeed one
of the processes eventually dereferences NULL.

As explained in the commit that introduced the bug:

  706249c222f6 ("locking/static_keys: Rework update logic")

jump_label_update() needs key.enabled to be true.  The solution adopted
here is to temporarily make key.enabled == -1, and use go down the
slow path when key.enabled <= 0.

Reported-by: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Fixes: 706249c222f6 ("locking/static_keys: Rework update logic")
Link: http://lkml.kernel.org/r/1466527937-69798-1-git-send-email-pbonzini@redhat.com
[ Small stylistic edits to the changelog and the code. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/linux/jump_label.h | 16 +++++++++++++---
 kernel/jump_label.c        | 36 +++++++++++++++++++++++++++++++++---
 2 files changed, 46 insertions(+), 6 deletions(-)

--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -117,13 +117,18 @@ struct module;
 
 #include <linux/atomic.h>
 
+#ifdef HAVE_JUMP_LABEL
+
 static inline int static_key_count(struct static_key *key)
 {
-	return atomic_read(&key->enabled);
+	/*
+	 * -1 means the first static_key_slow_inc() is in progress.
+	 *  static_key_enabled() must return true, so return 1 here.
+	 */
+	int n = atomic_read(&key->enabled);
+	return n >= 0 ? n : 1;
 }
 
-#ifdef HAVE_JUMP_LABEL
-
 #define JUMP_TYPE_FALSE	0UL
 #define JUMP_TYPE_TRUE	1UL
 #define JUMP_TYPE_MASK	1UL
@@ -162,6 +167,11 @@ extern void jump_label_apply_nops(struct
 
 #else  /* !HAVE_JUMP_LABEL */
 
+static inline int static_key_count(struct static_key *key)
+{
+	return atomic_read(&key->enabled);
+}
+
 static __always_inline void jump_label_init(void)
 {
 	static_key_initialized = true;
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -58,13 +58,36 @@ static void jump_label_update(struct sta
 
 void static_key_slow_inc(struct static_key *key)
 {
+	int v, v1;
+
 	STATIC_KEY_CHECK_USE();
-	if (atomic_inc_not_zero(&key->enabled))
-		return;
+
+	/*
+	 * Careful if we get concurrent static_key_slow_inc() calls;
+	 * later calls must wait for the first one to _finish_ the
+	 * jump_label_update() process.  At the same time, however,
+	 * the jump_label_update() call below wants to see
+	 * static_key_enabled(&key) for jumps to be updated properly.
+	 *
+	 * So give a special meaning to negative key->enabled: it sends
+	 * static_key_slow_inc() down the slow path, and it is non-zero
+	 * so it counts as "enabled" in jump_label_update().  Note that
+	 * atomic_inc_unless_negative() checks >= 0, so roll our own.
+	 */
+	for (v = atomic_read(&key->enabled); v > 0; v = v1) {
+		v1 = atomic_cmpxchg(&key->enabled, v, v + 1);
+		if (likely(v1 == v))
+			return;
+	}
 
 	jump_label_lock();
-	if (atomic_inc_return(&key->enabled) == 1)
+	if (atomic_read(&key->enabled) == 0) {
+		atomic_set(&key->enabled, -1);
 		jump_label_update(key);
+		atomic_set(&key->enabled, 1);
+	} else {
+		atomic_inc(&key->enabled);
+	}
 	jump_label_unlock();
 }
 EXPORT_SYMBOL_GPL(static_key_slow_inc);
@@ -72,6 +95,13 @@ EXPORT_SYMBOL_GPL(static_key_slow_inc);
 static void __static_key_slow_dec(struct static_key *key,
 		unsigned long rate_limit, struct delayed_work *work)
 {
+	/*
+	 * The negative count check is valid even when a negative
+	 * key->enabled is in use by static_key_slow_inc(); a
+	 * __static_key_slow_dec() before the first static_key_slow_inc()
+	 * returns is unbalanced, because all other static_key_slow_inc()
+	 * instances block while the update is in progress.
+	 */
 	if (!atomic_dec_and_mutex_lock(&key->enabled, &jump_label_mutex)) {
 		WARN(atomic_read(&key->enabled) < 0,
 		     "jump label: negative count!\n");

