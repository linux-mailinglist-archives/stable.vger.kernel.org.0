Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D5F81D8274
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 19:56:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731648AbgERR4h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:56:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:34526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731643AbgERR4d (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:56:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 30BF7207C4;
        Mon, 18 May 2020 17:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824592;
        bh=tOhJ7Y7k8Jo1/Yno477+qyRM5DCvsvpxc1mxNnflTwI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uHRRej780coL35tnhT3BOXsHinuSx4LqRX3h7JLgdFBa78Egvyjs+DsqqoWMi7ivY
         jDgbJJeg7ff9FS5jeLmryFU6XVsBCHuOv4nplFPLVI8MWUoBkCMfOoXQogw3DciXXT
         7Q9qAWRr4LZVr9QKMrcFnbYrCau3Y9Y/DQhVk7Uw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Stancek <jstancek@redhat.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "Dmitry V. Levin" <ldv@altlinux.org>,
        Andreas Schwab <schwab@linux-m68k.org>,
        Florian Weimer <fw@deneb.enyo.de>, libc-alpha@sourceware.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 072/147] fork: prevent accidental access to clone3 features
Date:   Mon, 18 May 2020 19:36:35 +0200
Message-Id: <20200518173522.933366374@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173513.009514388@linuxfoundation.org>
References: <20200518173513.009514388@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Brauner <christian.brauner@ubuntu.com>

[ Upstream commit 3f2c788a13143620c5471ac96ac4f033fc9ac3f3 ]

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

Fixes: 7f192e3cd316 ("fork: add clone3")
Fixes: ef2c41cf38a7 ("clone3: allow spawning processes into cgroups")
Reported-by: Jan Stancek <jstancek@redhat.com>
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dmitry V. Levin <ldv@altlinux.org>
Cc: Andreas Schwab <schwab@linux-m68k.org>
Cc: Florian Weimer <fw@deneb.enyo.de>
Cc: libc-alpha@sourceware.org
Cc: stable@vger.kernel.org # 5.3+
Link: https://sourceware.org/pipermail/libc-alpha/2020-May/113596.html
Link: https://lore.kernel.org/r/20200507103214.77218-1-christian.brauner@ubuntu.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/fork.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 27c0ef30002e2..9180f4416dbab 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2412,11 +2412,11 @@ long do_fork(unsigned long clone_flags,
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
@@ -2434,8 +2434,9 @@ long do_fork(unsigned long clone_flags,
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
@@ -2496,11 +2497,11 @@ SYSCALL_DEFINE5(clone, unsigned long, clone_flags, unsigned long, newsp,
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
-- 
2.20.1



