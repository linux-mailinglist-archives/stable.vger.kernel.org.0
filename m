Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D82CD4B7327
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 17:43:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240033AbiBOPba (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 10:31:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240234AbiBOPap (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 10:30:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5415C12D5;
        Tue, 15 Feb 2022 07:29:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3ED2C615CE;
        Tue, 15 Feb 2022 15:29:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCE0CC36AE3;
        Tue, 15 Feb 2022 15:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644938939;
        bh=fPzhcJUNc782pRynNz+kxubVhm6EiTsyUtZufSvYyDg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Se4y0jkdVaqUfAvH9BvnBZUfweoVkZEpJk2Pxb8ln/uTTY+nrdRY4Niw3kaELo3hF
         Y98ZLKuhwnzTWou9PZXXz0Vd2dG0e5IBKOEXBEBmd3PkvNvd+m+LAy+ivYkaqYvfMv
         tLTc8YSPt+QfmiMPa1ITdoRRJNf61nKXcP0ezpcFTiWiC7AAvhM2dRvuPzjU9WPfnS
         sUuxhFof/1nkK6DcKSZ4EEIYlHCO/w0C+A/mwD63ZP4L+1wAL8Fxnz8JMC/2qtzEXp
         6weLqma+FI5+feHfTODzUdRlpCRVBIY7Lf+ROcjiDtJfn3L6El8GFgRTAakP9MXU11
         55olLhZ/bbhLQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Axel Rasmussen <axelrasmussen@google.com>,
        Christian Brauner <brauner@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, shuah@kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 15/33] pidfd: fix test failure due to stack overflow on some arches
Date:   Tue, 15 Feb 2022 10:28:13 -0500
Message-Id: <20220215152831.580780-15-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220215152831.580780-1-sashal@kernel.org>
References: <20220215152831.580780-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Axel Rasmussen <axelrasmussen@google.com>

[ Upstream commit 4cbd93c3c110447adc66cb67c08af21f939ae2d7 ]

When running the pidfd_fdinfo_test on arm64, it fails for me. After some
digging, the reason is that the child exits due to SIGBUS, because it
overflows the 1024 byte stack we've reserved for it.

To fix the issue, increase the stack size to 8192 bytes (this number is
somewhat arbitrary, and was arrived at through experimentation -- I kept
doubling until the failure no longer occurred).

Also, let's make the issue easier to debug. wait_for_pid() returns an
ambiguous value: it may return -1 in all of these cases:

1. waitpid() itself returned -1
2. waitpid() returned success, but we found !WIFEXITED(status).
3. The child process exited, but it did so with a -1 exit code.

There's no way for the caller to tell the difference. So, at least log
which occurred, so the test runner can debug things.

While debugging this, I found that we had !WIFEXITED(), because the
child exited due to a signal. This seems like a reasonably common case,
so also print out whether or not we have WIFSIGNALED(), and the
associated WTERMSIG() (if any). This lets us see the SIGBUS I'm fixing
clearly when it occurs.

Finally, I'm suspicious of allocating the child's stack on our stack.
man clone(2) suggests that the correct way to do this is with mmap(),
and in particular by setting MAP_STACK. So, switch to doing it that way
instead.

Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
Acked-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/pidfd/pidfd.h         | 13 ++++++++---
 .../selftests/pidfd/pidfd_fdinfo_test.c       | 22 +++++++++++++++----
 2 files changed, 28 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/pidfd/pidfd.h b/tools/testing/selftests/pidfd/pidfd.h
index 01f8d3c0cf2cb..6922d6417e1cf 100644
--- a/tools/testing/selftests/pidfd/pidfd.h
+++ b/tools/testing/selftests/pidfd/pidfd.h
@@ -68,7 +68,7 @@
 #define PIDFD_SKIP 3
 #define PIDFD_XFAIL 4
 
-int wait_for_pid(pid_t pid)
+static inline int wait_for_pid(pid_t pid)
 {
 	int status, ret;
 
@@ -78,13 +78,20 @@ int wait_for_pid(pid_t pid)
 		if (errno == EINTR)
 			goto again;
 
+		ksft_print_msg("waitpid returned -1, errno=%d\n", errno);
 		return -1;
 	}
 
-	if (!WIFEXITED(status))
+	if (!WIFEXITED(status)) {
+		ksft_print_msg(
+		       "waitpid !WIFEXITED, WIFSIGNALED=%d, WTERMSIG=%d\n",
+		       WIFSIGNALED(status), WTERMSIG(status));
 		return -1;
+	}
 
-	return WEXITSTATUS(status);
+	ret = WEXITSTATUS(status);
+	ksft_print_msg("waitpid WEXITSTATUS=%d\n", ret);
+	return ret;
 }
 
 static inline int sys_pidfd_open(pid_t pid, unsigned int flags)
diff --git a/tools/testing/selftests/pidfd/pidfd_fdinfo_test.c b/tools/testing/selftests/pidfd/pidfd_fdinfo_test.c
index 22558524f71c3..3fd8e903118f5 100644
--- a/tools/testing/selftests/pidfd/pidfd_fdinfo_test.c
+++ b/tools/testing/selftests/pidfd/pidfd_fdinfo_test.c
@@ -12,6 +12,7 @@
 #include <string.h>
 #include <syscall.h>
 #include <sys/wait.h>
+#include <sys/mman.h>
 
 #include "pidfd.h"
 #include "../kselftest.h"
@@ -80,7 +81,10 @@ static inline int error_check(struct error *err, const char *test_name)
 	return err->code;
 }
 
+#define CHILD_STACK_SIZE 8192
+
 struct child {
+	char *stack;
 	pid_t pid;
 	int   fd;
 };
@@ -89,17 +93,22 @@ static struct child clone_newns(int (*fn)(void *), void *args,
 				struct error *err)
 {
 	static int flags = CLONE_PIDFD | CLONE_NEWPID | CLONE_NEWNS | SIGCHLD;
-	size_t stack_size = 1024;
-	char *stack[1024] = { 0 };
 	struct child ret;
 
 	if (!(flags & CLONE_NEWUSER) && geteuid() != 0)
 		flags |= CLONE_NEWUSER;
 
+	ret.stack = mmap(NULL, CHILD_STACK_SIZE, PROT_READ | PROT_WRITE,
+			 MAP_PRIVATE | MAP_ANONYMOUS | MAP_STACK, -1, 0);
+	if (ret.stack == MAP_FAILED) {
+		error_set(err, -1, "mmap of stack failed (errno %d)", errno);
+		return ret;
+	}
+
 #ifdef __ia64__
-	ret.pid = __clone2(fn, stack, stack_size, flags, args, &ret.fd);
+	ret.pid = __clone2(fn, ret.stack, CHILD_STACK_SIZE, flags, args, &ret.fd);
 #else
-	ret.pid = clone(fn, stack + stack_size, flags, args, &ret.fd);
+	ret.pid = clone(fn, ret.stack + CHILD_STACK_SIZE, flags, args, &ret.fd);
 #endif
 
 	if (ret.pid < 0) {
@@ -129,6 +138,11 @@ static inline int child_join(struct child *child, struct error *err)
 	else if (r > 0)
 		error_set(err, r, "child %d reported: %d", child->pid, r);
 
+	if (munmap(child->stack, CHILD_STACK_SIZE)) {
+		error_set(err, -1, "munmap of child stack failed (errno %d)", errno);
+		r = -1;
+	}
+
 	return r;
 }
 
-- 
2.34.1

