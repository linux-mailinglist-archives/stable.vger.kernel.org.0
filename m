Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E84AF0BF7
	for <lists+stable@lfdr.de>; Wed,  6 Nov 2019 03:18:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730731AbfKFCSd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Nov 2019 21:18:33 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36322 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730724AbfKFCSd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Nov 2019 21:18:33 -0500
Received: from [213.220.153.21] (helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1iSAty-0006yE-Ua; Wed, 06 Nov 2019 02:18:31 +0000
Date:   Wed, 6 Nov 2019 03:18:30 +0100
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, Florian Weimer <fweimer@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Kees Cook <keescook@chromium.org>,
        Jann Horn <jannh@google.com>,
        David Howells <dhowells@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-api@vger.kernel.org,
        GNU C Library <libc-alpha@sourceware.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH] clone3: validate stack arguments
Message-ID: <20191106021829.zihexhy2vq4z3if3@wittgenstein>
References: <20191031113608.20713-1-christian.brauner@ubuntu.com>
 <20191031124037.E26AF20650@mail.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20191031124037.E26AF20650@mail.kernel.org>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 31, 2019 at 12:40:36PM +0000, Sasha Levin wrote:
> Hi,
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a "Fixes:" tag,
> fixing commit: 7f192e3cd316b fork: add clone3.
> 
> The bot has tested the following trees: v5.3.8.
> 
> v5.3.8: Failed to apply! Possible dependencies:
>     78f6face5af34 ("sched: add kernel-doc for struct clone_args")
> 
> 
> NOTE: The patch will not be queued to stable trees until it is upstream.
> 
> How should we proceed with this patch?

Hey Sasha,

This has now landed in mainline (cf. [2]).
I would suggest to backport [1] together with [2].
The patch in [1] only documents struct clone_args and has no functional
changes.
If you prefer to only backport a v5.3 specific version of [2] you can
find it inline (cf. [3]) including the base commit info for the 5.3 stable
tree.

Christian

[1]: 78f6face5af3 ("sched: add kernel-doc for struct clone_args")
[2]: fa729c4df558 ("clone3: validate stack arguments")
[3]:

From 5bc5279d0dfa90cc6af385b6e3f65958f223ccab Mon Sep 17 00:00:00 2001
From: Christian Brauner <christian.brauner@ubuntu.com>
Date: Thu, 31 Oct 2019 12:36:08 +0100
Subject: [PATCH] clone3: validate stack arguments

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
---
 kernel/fork.c | 33 ++++++++++++++++++++++++++++++++-
 1 file changed, 32 insertions(+), 1 deletion(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 3647097e6783..8bbd39585301 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2586,7 +2586,35 @@ noinline static int copy_clone_args_from_user(struct kernel_clone_args *kargs,
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
@@ -2606,6 +2634,9 @@ static bool clone3_args_valid(const struct kernel_clone_args *kargs)
 	    kargs->exit_signal)
 		return false;
 
+	if (!clone3_stack_valid(kargs))
+		return false;
+
 	return true;
 }
 

base-commit: db0655e705be645ad673b0a70160921e088517c0
-- 
2.23.0

