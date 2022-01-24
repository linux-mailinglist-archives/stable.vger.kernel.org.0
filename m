Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BB9F49A485
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:09:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2369526AbiAYACB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:02:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383546AbiAXX2E (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:28:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 078F0C01D7F4;
        Mon, 24 Jan 2022 13:31:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B7411B8123A;
        Mon, 24 Jan 2022 21:31:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D92EDC340E4;
        Mon, 24 Jan 2022 21:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059889;
        bh=fgpNcpGwTQOlUCWiGZGZm/cuplCzU4SORglq/H8Knog=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DOEPQTnoQ4QCsWO3YTxIGx5181+xQOzM0bMSKw/6O6vlvShj6yg1haeA5P+HslsY1
         3VGf7kYQYvH9RHCAJau7g5o+wmXPtJkGxO/NJLhuB9m4DvYgcCOPbRhn3ywkZF/VJY
         5nb0q+xixIcuL4X9oB6iEJCm9tu6tDTktM3d6Hrw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0769/1039] selftests/powerpc: Add a test of sigreturning to the kernel
Date:   Mon, 24 Jan 2022 19:42:38 +0100
Message-Id: <20220124184151.159121523@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
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



