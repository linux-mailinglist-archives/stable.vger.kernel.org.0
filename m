Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C32BF7E06
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 20:01:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729898AbfKKSuu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:50:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:44694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728938AbfKKSut (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:50:49 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 11199222C1;
        Mon, 11 Nov 2019 18:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498247;
        bh=1HGeQd+i51xc2/LbpOvoli3yDDNk5PN3cNjdO+/G3zA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HaFLHoFnlHlZ7JjhKfaMLP/iK/D45hwY2yzYCOclLu/x7jfSEnIBmax9BITdQhUve
         k/t1DJnhCOP2S2qhbImm+Ent2lAOaXbHCt6xSORB/TULdPdVfc7UcFWml83ftGYGnQ
         mOVODQNWf/S9uG4EnSB8tgRZxWEyrVE3hW+oTN68=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Jann Horn <jannh@google.com>,
        David Howells <dhowells@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Florian Weimer <fweimer@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-api@vger.kernel.org,
        GNU C Library <libc-alpha@sourceware.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Arnd Bergmann <arnd@arndb.de>, Aleksa Sarai <cyphar@cyphar.com>
Subject: [PATCH 5.3 063/193] clone3: validate stack arguments
Date:   Mon, 11 Nov 2019 19:27:25 +0100
Message-Id: <20191111181505.649555239@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181459.850623879@linuxfoundation.org>
References: <20191111181459.850623879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Brauner <christian.brauner@ubuntu.com>

commit fa729c4df558936b4a1a7b3e2234011f44ede28b upstream.

Validate the stack arguments and setup the stack depening on whether or not
it is growing down or up.

Legacy clone() required userspace to know in which direction the stack is
growing and pass down the stack pointer appropriately. To make things more
confusing microblaze uses a variant of the clone() syscall selected by
CONFIG_CLONE_BACKWARDS3 that takes an additional stack_size argument.
IA64 has a separate clone2() syscall which also takes an additional
stack_size argument. Finally, parisc has a stack that is growing upwards.
Userspace therefore has a lot nasty code like the following:

 #define __STACK_SIZE (8 * 1024 * 1024)
 pid_t sys_clone(int (*fn)(void *), void *arg, int flags, int *pidfd)
 {
         pid_t ret;
         void *stack;

         stack = malloc(__STACK_SIZE);
         if (!stack)
                 return -ENOMEM;

 #ifdef __ia64__
         ret = __clone2(fn, stack, __STACK_SIZE, flags | SIGCHLD, arg, pidfd);
 #elif defined(__parisc__) /* stack grows up */
         ret = clone(fn, stack, flags | SIGCHLD, arg, pidfd);
 #else
         ret = clone(fn, stack + __STACK_SIZE, flags | SIGCHLD, arg, pidfd);
 #endif
         return ret;
 }

or even crazier variants such as [3].

With clone3() we have the ability to validate the stack. We can check that
when stack_size is passed, the stack pointer is valid and the other way
around. We can also check that the memory area userspace gave us is fine to
use via access_ok(). Furthermore, we probably should not require
userspace to know in which direction the stack is growing. It is easy
for us to do this in the kernel and I couldn't find the original
reasoning behind exposing this detail to userspace.

/* Intentional user visible API change */
clone3() was released with 5.3. Currently, it is not documented and very
unclear to userspace how the stack and stack_size argument have to be
passed. After talking to glibc folks we concluded that trying to change
clone3() to setup the stack instead of requiring userspace to do this is
the right course of action.
Note, that this is an explicit change in user visible behavior we introduce
with this patch. If it breaks someone's use-case we will revert! (And then
e.g. place the new behavior under an appropriate flag.)
Breaking someone's use-case is very unlikely though. First, neither glibc
nor musl currently expose a wrapper for clone3(). Second, there is no real
motivation for anyone to use clone3() directly since it does not provide
features that legacy clone doesn't. New features for clone3() will first
happen in v5.5 which is why v5.4 is still a good time to try and make that
change now and backport it to v5.3. Searches on [4] did not reveal any
packages calling clone3().

[1]: https://lore.kernel.org/r/CAG48ez3q=BeNcuVTKBN79kJui4vC6nw0Bfq6xc-i0neheT17TA@mail.gmail.com
[2]: https://lore.kernel.org/r/20191028172143.4vnnjpdljfnexaq5@wittgenstein
[3]: https://github.com/systemd/systemd/blob/5238e9575906297608ff802a27e2ff9effa3b338/src/basic/raw-clone.h#L31
[4]: https://codesearch.debian.net
Fixes: 7f192e3cd316 ("fork: add clone3")
Cc: Kees Cook <keescook@chromium.org>
Cc: Jann Horn <jannh@google.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Florian Weimer <fweimer@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: linux-api@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: <stable@vger.kernel.org> # 5.3
Cc: GNU C Library <libc-alpha@sourceware.org>
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Aleksa Sarai <cyphar@cyphar.com>
Link: https://lore.kernel.org/r/20191031113608.20713-1-christian.brauner@ubuntu.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/fork.c |   33 ++++++++++++++++++++++++++++++++-
 1 file changed, 32 insertions(+), 1 deletion(-)

--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2586,7 +2586,35 @@ noinline static int copy_clone_args_from
 	return 0;
 }
 
-static bool clone3_args_valid(const struct kernel_clone_args *kargs)
+/**
+ * clone3_stack_valid - check and prepare stack
+ * @kargs: kernel clone args
+ *
+ * Verify that the stack arguments userspace gave us are sane.
+ * In addition, set the stack direction for userspace since it's easy for us to
+ * determine.
+ */
+static inline bool clone3_stack_valid(struct kernel_clone_args *kargs)
+{
+	if (kargs->stack == 0) {
+		if (kargs->stack_size > 0)
+			return false;
+	} else {
+		if (kargs->stack_size == 0)
+			return false;
+
+		if (!access_ok((void __user *)kargs->stack, kargs->stack_size))
+			return false;
+
+#if !defined(CONFIG_STACK_GROWSUP) && !defined(CONFIG_IA64)
+		kargs->stack += kargs->stack_size;
+#endif
+	}
+
+	return true;
+}
+
+static bool clone3_args_valid(struct kernel_clone_args *kargs)
 {
 	/*
 	 * All lower bits of the flag word are taken.
@@ -2606,6 +2634,9 @@ static bool clone3_args_valid(const stru
 	    kargs->exit_signal)
 		return false;
 
+	if (!clone3_stack_valid(kargs))
+		return false;
+
 	return true;
 }
 


