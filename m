Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EC882B9E21
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 00:27:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726724AbgKSXXO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Nov 2020 18:23:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726690AbgKSXXO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Nov 2020 18:23:14 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6214C0613CF
        for <stable@vger.kernel.org>; Thu, 19 Nov 2020 15:23:13 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id w4so5626718pgg.13
        for <stable@vger.kernel.org>; Thu, 19 Nov 2020 15:23:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gN7Vr8wj161q5eAkjU2WyFBBhDv9VGYvr4tZNm9DoHQ=;
        b=Nw+csbyJmj22Zx4eSF67lnqbxVWDNK/U0ZeuDAtsiwtmQelVXE0G74M4LOyVCaGR36
         ogx6CH3WqS/+BAvdXzEbpQ1L6q3G0Ac+E34GAjCCWGG04lP/EtAN8IwwCCaqxO4x3N7H
         mY5A+sZyKb+Z9E/7WBBTsFnlgN7nyVK2ku2lg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gN7Vr8wj161q5eAkjU2WyFBBhDv9VGYvr4tZNm9DoHQ=;
        b=K9OFlfYGsBI4K9A480Je/MyqMRexsxY76axY4PThpQLVU2d57yXYgLiFyqyrtnybb0
         yGvePckyhrrdRg1pfpOMN2UvfzyoSPFeYMC7yyE6CgPl2+J5Wnb/NVuSkAOr/tds2v+Q
         W36fwR64FYWcjM3S2WCoNfQLh9ha0mkj9N4kN1uga+LElgFB2ktbrkj+uFLSTGVXBYxM
         KcnWc95ghbaPRmpLT6MRfuAWDKC0C2A/elkLM8QvEqYLPYIYuzjYN5ceKnAeB6iHcfcM
         zChW/szix9FiH9MUMdhRTaGofRq1vmrvblUl//eJkaMiMaKLbCx0crEVRhCnbNNYsxv1
         rccg==
X-Gm-Message-State: AOAM531Ewgt13zF+OQhAzMgUUGlqGBOjBEWWsINdoB8I9mFiSlWmUtYz
        wxwru0GHAH6u838ek4Ka5E4NjoSnX2jIUg==
X-Google-Smtp-Source: ABdhPJzgbk3k1K/xBgTVdinxPYQsiWgMxchE42LuzIiuXWwWowm2YcpSuEDybu0bflTfyVxyszRYwQ==
X-Received: by 2002:a17:90a:9604:: with SMTP id v4mr2343763pjo.104.1605828193081;
        Thu, 19 Nov 2020 15:23:13 -0800 (PST)
Received: from localhost (2001-44b8-1113-6700-4d44-522c-3789-8f33.static.ipv6.internode.on.net. [2001:44b8:1113:6700:4d44:522c:3789:8f33])
        by smtp.gmail.com with ESMTPSA id z17sm916722pjn.46.2020.11.19.15.23.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2020 15:23:12 -0800 (PST)
From:   Daniel Axtens <dja@axtens.net>
To:     stable@vger.kernel.org
Cc:     dja@axtens.net
Subject: [PATCH 5.9 5/5] selftests/powerpc: entry flush test
Date:   Fri, 20 Nov 2020 10:22:50 +1100
Message-Id: <20201119232250.365304-6-dja@axtens.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201119232250.365304-1-dja@axtens.net>
References: <20201119232250.365304-1-dja@axtens.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 89a83a0c69c81a25ce91002b90ca27ed86132a0a upstream.

Add a test modelled on the RFI flush test which counts the number
of L1D misses doing a simple syscall with the entry flush on and off.

For simplicity of backporting, this test duplicates a lot of code from
rfi_flush. We clean that up in the next patch.

Signed-off-by: Daniel Axtens <dja@axtens.net>
---
 .../selftests/powerpc/security/.gitignore     |   1 +
 .../selftests/powerpc/security/Makefile       |   2 +-
 .../selftests/powerpc/security/entry_flush.c  | 198 ++++++++++++++++++
 3 files changed, 200 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/powerpc/security/entry_flush.c

diff --git a/tools/testing/selftests/powerpc/security/.gitignore b/tools/testing/selftests/powerpc/security/.gitignore
index f795e06f5ae3..4257a1f156bb 100644
--- a/tools/testing/selftests/powerpc/security/.gitignore
+++ b/tools/testing/selftests/powerpc/security/.gitignore
@@ -1,2 +1,3 @@
 # SPDX-License-Identifier: GPL-2.0-only
 rfi_flush
+entry_flush
diff --git a/tools/testing/selftests/powerpc/security/Makefile b/tools/testing/selftests/powerpc/security/Makefile
index eadbbff50be6..921152caf1dc 100644
--- a/tools/testing/selftests/powerpc/security/Makefile
+++ b/tools/testing/selftests/powerpc/security/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0+
 
-TEST_GEN_PROGS := rfi_flush spectre_v2
+TEST_GEN_PROGS := rfi_flush entry_flush spectre_v2
 top_srcdir = ../../../../..
 
 CFLAGS += -I../../../../../usr/include
diff --git a/tools/testing/selftests/powerpc/security/entry_flush.c b/tools/testing/selftests/powerpc/security/entry_flush.c
new file mode 100644
index 000000000000..7ae7e37204c5
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
-- 
2.25.1

