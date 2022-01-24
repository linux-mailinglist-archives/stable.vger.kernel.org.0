Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EC7B49951F
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:08:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392230AbiAXUuu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:50:50 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:45552 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351668AbiAXUoN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:44:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4E159B80FA1;
        Mon, 24 Jan 2022 20:44:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A604C340E5;
        Mon, 24 Jan 2022 20:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057051;
        bh=fgpNcpGwTQOlUCWiGZGZm/cuplCzU4SORglq/H8Knog=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aCCrxsRxAa3MQmbypxm/EKdMOUGLv7mUGl26XfZWVYRFXgQcaAdqHFJYW7eClcq0E
         6FaabdPhKc96tHz9umAeQgmx4oFX2N0yf+O1dlbxnn0VAw4dWgPbS+AmEWRnamHAdC
         poatkeY0GcdBDlwHl2I3pkXmaRoAI+zKuGxjiwMw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 653/846] selftests/powerpc: Add a test of sigreturning to the kernel
Date:   Mon, 24 Jan 2022 19:42:50 +0100
Message-Id: <20220124184123.566012851@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit a8968521cfdc3e339fe69473d6632e0aa8d7202a ]

We have a general signal fuzzer, sigfuz, which can modify the MSR & NIP
before sigreturn. But the chance of it hitting a kernel address and also
clearing MSR_PR is fairly slim.

So add a specific test of sigreturn to a kernel address, both with and
without attempting to clear MSR_PR (which the kernel must block).

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20211209115944.4062384-1-mpe@ellerman.id.au
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/powerpc/signal/.gitignore       |   1 +
 .../testing/selftests/powerpc/signal/Makefile |   1 +
 .../powerpc/signal/sigreturn_kernel.c         | 132 ++++++++++++++++++
 3 files changed, 134 insertions(+)
 create mode 100644 tools/testing/selftests/powerpc/signal/sigreturn_kernel.c

diff --git a/tools/testing/selftests/powerpc/signal/.gitignore b/tools/testing/selftests/powerpc/signal/.gitignore
index ce3375cd8e73e..8f6c816099a48 100644
--- a/tools/testing/selftests/powerpc/signal/.gitignore
+++ b/tools/testing/selftests/powerpc/signal/.gitignore
@@ -4,3 +4,4 @@ signal_tm
 sigfuz
 sigreturn_vdso
 sig_sc_double_restart
+sigreturn_kernel
diff --git a/tools/testing/selftests/powerpc/signal/Makefile b/tools/testing/selftests/powerpc/signal/Makefile
index d6ae54663aed7..84e201572466d 100644
--- a/tools/testing/selftests/powerpc/signal/Makefile
+++ b/tools/testing/selftests/powerpc/signal/Makefile
@@ -1,5 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 TEST_GEN_PROGS := signal signal_tm sigfuz sigreturn_vdso sig_sc_double_restart
+TEST_GEN_PROGS += sigreturn_kernel
 
 CFLAGS += -maltivec
 $(OUTPUT)/signal_tm: CFLAGS += -mhtm
diff --git a/tools/testing/selftests/powerpc/signal/sigreturn_kernel.c b/tools/testing/selftests/powerpc/signal/sigreturn_kernel.c
new file mode 100644
index 0000000000000..0a1b6e591eeed
--- /dev/null
+++ b/tools/testing/selftests/powerpc/signal/sigreturn_kernel.c
@@ -0,0 +1,132 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Test that we can't sigreturn to kernel addresses, or to kernel mode.
+ */
+
+#define _GNU_SOURCE
+
+#include <stdio.h>
+#include <signal.h>
+#include <stdlib.h>
+#include <sys/types.h>
+#include <sys/wait.h>
+#include <unistd.h>
+
+#include "utils.h"
+
+#define MSR_PR (1ul << 14)
+
+static volatile unsigned long long sigreturn_addr;
+static volatile unsigned long long sigreturn_msr_mask;
+
+static void sigusr1_handler(int signo, siginfo_t *si, void *uc_ptr)
+{
+	ucontext_t *uc = (ucontext_t *)uc_ptr;
+
+	if (sigreturn_addr)
+		UCONTEXT_NIA(uc) = sigreturn_addr;
+
+	if (sigreturn_msr_mask)
+		UCONTEXT_MSR(uc) &= sigreturn_msr_mask;
+}
+
+static pid_t fork_child(void)
+{
+	pid_t pid;
+
+	pid = fork();
+	if (pid == 0) {
+		raise(SIGUSR1);
+		exit(0);
+	}
+
+	return pid;
+}
+
+static int expect_segv(pid_t pid)
+{
+	int child_ret;
+
+	waitpid(pid, &child_ret, 0);
+	FAIL_IF(WIFEXITED(child_ret));
+	FAIL_IF(!WIFSIGNALED(child_ret));
+	FAIL_IF(WTERMSIG(child_ret) != 11);
+
+	return 0;
+}
+
+int test_sigreturn_kernel(void)
+{
+	struct sigaction act;
+	int child_ret, i;
+	pid_t pid;
+
+	act.sa_sigaction = sigusr1_handler;
+	act.sa_flags = SA_SIGINFO;
+	sigemptyset(&act.sa_mask);
+
+	FAIL_IF(sigaction(SIGUSR1, &act, NULL));
+
+	for (i = 0; i < 2; i++) {
+		// Return to kernel
+		sigreturn_addr = 0xcull << 60;
+		pid = fork_child();
+		expect_segv(pid);
+
+		// Return to kernel virtual
+		sigreturn_addr = 0xc008ull << 48;
+		pid = fork_child();
+		expect_segv(pid);
+
+		// Return out of range
+		sigreturn_addr = 0xc010ull << 48;
+		pid = fork_child();
+		expect_segv(pid);
+
+		// Return to no-man's land, just below PAGE_OFFSET
+		sigreturn_addr = (0xcull << 60) - (64 * 1024);
+		pid = fork_child();
+		expect_segv(pid);
+
+		// Return to no-man's land, above TASK_SIZE_4PB
+		sigreturn_addr = 0x1ull << 52;
+		pid = fork_child();
+		expect_segv(pid);
+
+		// Return to 0xd space
+		sigreturn_addr = 0xdull << 60;
+		pid = fork_child();
+		expect_segv(pid);
+
+		// Return to 0xe space
+		sigreturn_addr = 0xeull << 60;
+		pid = fork_child();
+		expect_segv(pid);
+
+		// Return to 0xf space
+		sigreturn_addr = 0xfull << 60;
+		pid = fork_child();
+		expect_segv(pid);
+
+		// Attempt to set PR=0 for 2nd loop (should be blocked by kernel)
+		sigreturn_msr_mask = ~MSR_PR;
+	}
+
+	printf("All children killed as expected\n");
+
+	// Don't change address, just MSR, should return to user as normal
+	sigreturn_addr = 0;
+	sigreturn_msr_mask = ~MSR_PR;
+	pid = fork_child();
+	waitpid(pid, &child_ret, 0);
+	FAIL_IF(!WIFEXITED(child_ret));
+	FAIL_IF(WIFSIGNALED(child_ret));
+	FAIL_IF(WEXITSTATUS(child_ret) != 0);
+
+	return 0;
+}
+
+int main(void)
+{
+	return test_harness(test_sigreturn_kernel, "sigreturn_kernel");
+}
-- 
2.34.1



