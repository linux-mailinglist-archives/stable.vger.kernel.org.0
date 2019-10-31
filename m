Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42BA7EAEFD
	for <lists+stable@lfdr.de>; Thu, 31 Oct 2019 12:36:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbfJaLgW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Oct 2019 07:36:22 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50044 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726462AbfJaLgW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Oct 2019 07:36:22 -0400
Received: from [91.217.168.176] (helo=localhost.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1iQ8kU-0000Jq-Oo; Thu, 31 Oct 2019 11:36:18 +0000
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     linux-kernel@vger.kernel.org, Florian Weimer <fweimer@redhat.com>,
        GNU C Library <libc-alpha@sourceware.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, Kees Cook <keescook@chromium.org>,
        Jann Horn <jannh@google.com>,
        David Howells <dhowells@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-api@vger.kernel.org, stable@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH] clone3: validate stack arguments
Date:   Thu, 31 Oct 2019 12:36:08 +0100
Message-Id: <20191031113608.20713-1-christian.brauner@ubuntu.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Cc: Arnd Bergmann <arnd@arndb.de>
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
---
 include/uapi/linux/sched.h |  4 ++++
 kernel/fork.c              | 33 ++++++++++++++++++++++++++++++++-
 2 files changed, 36 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/sched.h b/include/uapi/linux/sched.h
index 99335e1f4a27..25b4fa00bad1 100644
--- a/include/uapi/linux/sched.h
+++ b/include/uapi/linux/sched.h
@@ -51,6 +51,10 @@
  *               sent when the child exits.
  * @stack:       Specify the location of the stack for the
  *               child process.
+ *               Note, @stack is expected to point to the
+ *               lowest address. The stack direction will be
+ *               determined by the kernel and set up
+ *               appropriately based on @stack_size.
  * @stack_size:  The size of the stack for the child process.
  * @tls:         If CLONE_SETTLS is set, the tls descriptor
  *               is set to tls.
diff --git a/kernel/fork.c b/kernel/fork.c
index bcdf53125210..55af6931c6ec 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2561,7 +2561,35 @@ noinline static int copy_clone_args_from_user(struct kernel_clone_args *kargs,
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
@@ -2581,6 +2609,9 @@ static bool clone3_args_valid(const struct kernel_clone_args *kargs)
 	    kargs->exit_signal)
 		return false;
 
+	if (!clone3_stack_valid(kargs))
+		return false;
+
 	return true;
 }
 
-- 
2.23.0

