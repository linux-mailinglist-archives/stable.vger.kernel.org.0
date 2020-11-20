Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E4522BA871
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 12:09:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727543AbgKTLHw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 06:07:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:55744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728432AbgKTLHv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Nov 2020 06:07:51 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B483206E3;
        Fri, 20 Nov 2020 11:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1605870470;
        bh=HElhHWD3NNO9omoBPlZg5mSoMAUJsp5xfB2CXHCBRTs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eSgiXQHWae3D3xeFS9upnRyraAxX2TNrUQZBs3oeDx/yAv/rDuKD21pky0kLMnOZ2
         JUpyQ9ahYUOKjYyGI+JBrPVFcuWVN0h1EqCko65ysQP38xxC/u9Er0d0fSgpm8Uf3Q
         9uJw2Or4zUq0LEOK/euL1QtfNuWUXDrIjyoHtD+k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>, dja@axtens.net
Subject: [PATCH 5.9 05/14] selftests/powerpc: entry flush test
Date:   Fri, 20 Nov 2020 12:03:43 +0100
Message-Id: <20201120104541.433708552@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201120104541.168007611@linuxfoundation.org>
References: <20201120104541.168007611@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Axtens <dja@axtens.net>

commit 89a83a0c69c81a25ce91002b90ca27ed86132a0a upstream.

Add a test modelled on the RFI flush test which counts the number
of L1D misses doing a simple syscall with the entry flush on and off.

For simplicity of backporting, this test duplicates a lot of code from
rfi_flush. We clean that up in the next patch.

Signed-off-by: Daniel Axtens <dja@axtens.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/powerpc/security/.gitignore    |    1 
 tools/testing/selftests/powerpc/security/Makefile      |    2 
 tools/testing/selftests/powerpc/security/entry_flush.c |  198 +++++++++++++++++
 3 files changed, 200 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/powerpc/security/entry_flush.c

--- a/tools/testing/selftests/powerpc/security/.gitignore
+++ b/tools/testing/selftests/powerpc/security/.gitignore
@@ -1,2 +1,3 @@
 # SPDX-License-Identifier: GPL-2.0-only
 rfi_flush
+entry_flush
--- a/tools/testing/selftests/powerpc/security/Makefile
+++ b/tools/testing/selftests/powerpc/security/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0+
 
-TEST_GEN_PROGS := rfi_flush spectre_v2
+TEST_GEN_PROGS := rfi_flush entry_flush spectre_v2
 top_srcdir = ../../../../..
 
 CFLAGS += -I../../../../../usr/include
--- /dev/null
+++ b/tools/testing/selftests/powerpc/security/entry_flush.c
@@ -0,0 +1,198 @@
+// SPDX-License-Identifier: GPL-2.0+
+
+/*
+ * Copyright 2018 IBM Corporation.
+ */
+
+#define __SANE_USERSPACE_TYPES__
+
+#include <sys/types.h>
+#include <stdint.h>
+#include <malloc.h>
+#include <unistd.h>
+#include <signal.h>
+#include <stdlib.h>
+#include <string.h>
+#include <stdio.h>
+#include "utils.h"
+
+#define CACHELINE_SIZE 128
+
+struct perf_event_read {
+	__u64 nr;
+	__u64 l1d_misses;
+};
+
+static inline __u64 load(void *addr)
+{
+	__u64 tmp;
+
+	asm volatile("ld %0,0(%1)" : "=r"(tmp) : "b"(addr));
+
+	return tmp;
+}
+
+static void syscall_loop(char *p, unsigned long iterations,
+			 unsigned long zero_size)
+{
+	for (unsigned long i = 0; i < iterations; i++) {
+		for (unsigned long j = 0; j < zero_size; j += CACHELINE_SIZE)
+			load(p + j);
+		getppid();
+	}
+}
+
+static void sigill_handler(int signr, siginfo_t *info, void *unused)
+{
+	static int warned;
+	ucontext_t *ctx = (ucontext_t *)unused;
+	unsigned long *pc = &UCONTEXT_NIA(ctx);
+
+	/* mtspr 3,RS to check for move to DSCR below */
+	if ((*((unsigned int *)*pc) & 0xfc1fffff) == 0x7c0303a6) {
+		if (!warned++)
+			printf("WARNING: Skipping over dscr setup. Consider running 'ppc64_cpu --dscr=1' manually.\n");
+		*pc += 4;
+	} else {
+		printf("SIGILL at %p\n", pc);
+		abort();
+	}
+}
+
+static void set_dscr(unsigned long val)
+{
+	static int init;
+	struct sigaction sa;
+
+	if (!init) {
+		memset(&sa, 0, sizeof(sa));
+		sa.sa_sigaction = sigill_handler;
+		sa.sa_flags = SA_SIGINFO;
+		if (sigaction(SIGILL, &sa, NULL))
+			perror("sigill_handler");
+		init = 1;
+	}
+
+	asm volatile("mtspr %1,%0" : : "r" (val), "i" (SPRN_DSCR));
+}
+
+int entry_flush_test(void)
+{
+	char *p;
+	int repetitions = 10;
+	int fd, passes = 0, iter, rc = 0;
+	struct perf_event_read v;
+	__u64 l1d_misses_total = 0;
+	unsigned long iterations = 100000, zero_size = 24 * 1024;
+	unsigned long l1d_misses_expected;
+	int rfi_flush_orig;
+	int entry_flush, entry_flush_orig;
+
+	SKIP_IF(geteuid() != 0);
+
+	// The PMU event we use only works on Power7 or later
+	SKIP_IF(!have_hwcap(PPC_FEATURE_ARCH_2_06));
+
+	if (read_debugfs_file("powerpc/rfi_flush", &rfi_flush_orig) < 0) {
+		perror("Unable to read powerpc/rfi_flush debugfs file");
+		SKIP_IF(1);
+	}
+
+	if (read_debugfs_file("powerpc/entry_flush", &entry_flush_orig) < 0) {
+		perror("Unable to read powerpc/entry_flush debugfs file");
+		SKIP_IF(1);
+	}
+
+	if (rfi_flush_orig != 0) {
+		if (write_debugfs_file("powerpc/rfi_flush", 0) < 0) {
+			perror("error writing to powerpc/rfi_flush debugfs file");
+			FAIL_IF(1);
+		}
+	}
+
+	entry_flush = entry_flush_orig;
+
+	fd = perf_event_open_counter(PERF_TYPE_RAW, /* L1d miss */ 0x400f0, -1);
+	FAIL_IF(fd < 0);
+
+	p = (char *)memalign(zero_size, CACHELINE_SIZE);
+
+	FAIL_IF(perf_event_enable(fd));
+
+	// disable L1 prefetching
+	set_dscr(1);
+
+	iter = repetitions;
+
+	/*
+	 * We expect to see l1d miss for each cacheline access when entry_flush
+	 * is set. Allow a small variation on this.
+	 */
+	l1d_misses_expected = iterations * (zero_size / CACHELINE_SIZE - 2);
+
+again:
+	FAIL_IF(perf_event_reset(fd));
+
+	syscall_loop(p, iterations, zero_size);
+
+	FAIL_IF(read(fd, &v, sizeof(v)) != sizeof(v));
+
+	if (entry_flush && v.l1d_misses >= l1d_misses_expected)
+		passes++;
+	else if (!entry_flush && v.l1d_misses < (l1d_misses_expected / 2))
+		passes++;
+
+	l1d_misses_total += v.l1d_misses;
+
+	while (--iter)
+		goto again;
+
+	if (passes < repetitions) {
+		printf("FAIL (L1D misses with entry_flush=%d: %llu %c %lu) [%d/%d failures]\n",
+		       entry_flush, l1d_misses_total, entry_flush ? '<' : '>',
+		       entry_flush ? repetitions * l1d_misses_expected :
+		       repetitions * l1d_misses_expected / 2,
+		       repetitions - passes, repetitions);
+		rc = 1;
+	} else {
+		printf("PASS (L1D misses with entry_flush=%d: %llu %c %lu) [%d/%d pass]\n",
+		       entry_flush, l1d_misses_total, entry_flush ? '>' : '<',
+		       entry_flush ? repetitions * l1d_misses_expected :
+		       repetitions * l1d_misses_expected / 2,
+		       passes, repetitions);
+	}
+
+	if (entry_flush == entry_flush_orig) {
+		entry_flush = !entry_flush_orig;
+		if (write_debugfs_file("powerpc/entry_flush", entry_flush) < 0) {
+			perror("error writing to powerpc/entry_flush debugfs file");
+			return 1;
+		}
+		iter = repetitions;
+		l1d_misses_total = 0;
+		passes = 0;
+		goto again;
+	}
+
+	perf_event_disable(fd);
+	close(fd);
+
+	set_dscr(0);
+
+	if (write_debugfs_file("powerpc/rfi_flush", rfi_flush_orig) < 0) {
+		perror("unable to restore original value of powerpc/rfi_flush debugfs file");
+		return 1;
+	}
+
+	if (write_debugfs_file("powerpc/entry_flush", entry_flush_orig) < 0) {
+		perror("unable to restore original value of powerpc/entry_flush debugfs file");
+		return 1;
+	}
+
+	return rc;
+}
+
+int main(int argc, char *argv[])
+{
+	return test_harness(entry_flush_test, "entry_flush_test");
+}


