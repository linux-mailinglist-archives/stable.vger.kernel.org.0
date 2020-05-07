Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 782D81C86D4
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 12:35:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726555AbgEGKcX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 06:32:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46313 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725939AbgEGKcW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 May 2020 06:32:22 -0400
Received: from ip5f5af183.dynamic.kabel-deutschland.de ([95.90.241.131] helo=wittgenstein.fritz.box)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1jWdpC-0007oF-Oi; Thu, 07 May 2020 10:32:18 +0000
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     linux-kernel@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Eugene Syromiatnikov <esyr@redhat.com>,
        Christian Kellner <christian@kellner.me>,
        Aleksa Sarai <cyphar@cyphar.com>,
        "Dmitry V. Levin" <ldv@altlinux.org>,
        Arnd Bergmann <arnd@arndb.de>, Serge Hallyn <serge@hallyn.com>,
        Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Joe Perches <joe@perches.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Jan Stancek <jstancek@redhat.com>,
        Andreas Schwab <schwab@linux-m68k.org>,
        Florian Weimer <fw@deneb.enyo.de>, libc-alpha@sourceware.org,
        stable@vger.kernel.org
Subject: [PATCH v2] fork: prevent accidental access to clone3 features
Date:   Thu,  7 May 2020 12:32:14 +0200
Message-Id: <20200507103214.77218-1-christian.brauner@ubuntu.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Jan reported an issue where an interaction between sign-extending clone's
flag argument on ppc64le and the new CLONE_INTO_CGROUP feature causes
clone() to consistently fail with EBADF.

The whole story is a little longer. The legacy clone() syscall is odd in a
bunch of ways and here two things interact. First, legacy clone's flag
argument is word-size dependent, i.e. it's an unsigned long whereas most
system calls with flag arguments use int or unsigned int. Second, legacy
clone() ignores unknown and deprecated flags. The two of them taken
together means that users on 64bit systems can pass garbage for the upper
32bit of the clone() syscall since forever and things would just work fine.
Just try this on a 64bit kernel prior to v5.7-rc1 where this will succeed
and on v5.7-rc1 where this will fail with EBADF:

int main(int argc, char *argv[])
{
        pid_t pid;

        /* Note that legacy clone() has different argument ordering on
         * different architectures so this won't work everywhere.
         *
         * Only set the upper 32 bits.
         */
        pid = syscall(__NR_clone, 0xffffffff00000000 | SIGCHLD,
                      NULL, NULL, NULL, NULL);
        if (pid < 0)
                exit(EXIT_FAILURE);
        if (pid == 0)
                exit(EXIT_SUCCESS);
        if (wait(NULL) != pid)
                exit(EXIT_FAILURE);

        exit(EXIT_SUCCESS);
}

Since legacy clone() couldn't be extended this was not a problem so far and
nobody really noticed or cared since nothing in the kernel ever bothered to
look at the upper 32 bits.

But once we introduced clone3() and expanded the flag argument in struct
clone_args to 64 bit we opened this can of worms. With the first flag-based
extension to clone3() making use of the upper 32 bits of the flag argument
we've effectively made it possible for the legacy clone() syscall to reach
clone3() only flags. The sign extension scenario is just the odd
corner-case that we needed to figure this out.

The reason we just realized this now and not already when we introduced
CLONE_CLEAR_SIGHAND was that CLONE_INTO_CGROUP assumes that a valid cgroup
file descriptor has been given. So the sign extension (or the user
accidently passing garbage for the upper 32 bits) caused the
CLONE_INTO_CGROUP bit to be raised and the kernel to error out when it
didn't find a valid cgroup file descriptor.

Let's fix this by always capping the upper 32 bits for all codepaths that
are not aware of clone3() features. This ensures that we can't reach
clone3() only features by accident via legacy clone as with the sign
extension case and also that legacy clone() works exactly like before, i.e.
ignoring any unknown flags.  This solution risks no regressions and is also
pretty clean.

Reported-by: Jan Stancek <jstancek@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dmitry V. Levin <ldv@altlinux.org>
Cc: Andreas Schwab <schwab@linux-m68k.org>
Cc: Florian Weimer <fw@deneb.enyo.de>
Cc: libc-alpha@sourceware.org
Link: https://sourceware.org/pipermail/libc-alpha/2020-May/113596.html
Fixes: 7f192e3cd316 ("fork: add clone3")
Fixes: ef2c41cf38a7 ("clone3: allow spawning processes into cgroups")
Cc: stable@vger.kernel.org # 5.3+
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
---
/* v2 */
- Joe Perches <joe@perches.com>:
  - Use lower_32_bit() macro.
- Christian Brauner <christian.brauner@ubuntu.com>:
  - Cap flag argument to 32 bits in every place that is not clone3()
    feature aware.
  - Cc stable.
---
 kernel/fork.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 8c700f881d92..48ed22774efa 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2486,11 +2486,11 @@ long do_fork(unsigned long clone_flags,
 	      int __user *child_tidptr)
 {
 	struct kernel_clone_args args = {
-		.flags		= (clone_flags & ~CSIGNAL),
+		.flags		= (lower_32_bits(clone_flags) & ~CSIGNAL),
 		.pidfd		= parent_tidptr,
 		.child_tid	= child_tidptr,
 		.parent_tid	= parent_tidptr,
-		.exit_signal	= (clone_flags & CSIGNAL),
+		.exit_signal	= (lower_32_bits(clone_flags) & CSIGNAL),
 		.stack		= stack_start,
 		.stack_size	= stack_size,
 	};
@@ -2508,8 +2508,9 @@ long do_fork(unsigned long clone_flags,
 pid_t kernel_thread(int (*fn)(void *), void *arg, unsigned long flags)
 {
 	struct kernel_clone_args args = {
-		.flags		= ((flags | CLONE_VM | CLONE_UNTRACED) & ~CSIGNAL),
-		.exit_signal	= (flags & CSIGNAL),
+		.flags		= ((lower_32_bits(flags) | CLONE_VM |
+				    CLONE_UNTRACED) & ~CSIGNAL),
+		.exit_signal	= (lower_32_bits(flags) & CSIGNAL),
 		.stack		= (unsigned long)fn,
 		.stack_size	= (unsigned long)arg,
 	};
@@ -2570,11 +2571,11 @@ SYSCALL_DEFINE5(clone, unsigned long, clone_flags, unsigned long, newsp,
 #endif
 {
 	struct kernel_clone_args args = {
-		.flags		= (clone_flags & ~CSIGNAL),
+		.flags		= (lower_32_bits(clone_flags) & ~CSIGNAL),
 		.pidfd		= parent_tidptr,
 		.child_tid	= child_tidptr,
 		.parent_tid	= parent_tidptr,
-		.exit_signal	= (clone_flags & CSIGNAL),
+		.exit_signal	= (lower_32_bits(clone_flags) & CSIGNAL),
 		.stack		= newsp,
 		.tls		= tls,
 	};

base-commit: 0e698dfa282211e414076f9dc7e83c1c288314fd
-- 
2.26.2

