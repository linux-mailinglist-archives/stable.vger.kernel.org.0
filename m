Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 418EA2BA85A
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 12:09:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727379AbgKTLGs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 06:06:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:54796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726554AbgKTLGr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Nov 2020 06:06:47 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 82051206E3;
        Fri, 20 Nov 2020 11:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1605870406;
        bh=VRFC3Z263WF54ev4IFR+mnTMhg4lUv1InV3OC2bceOw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bHiGCDF1HBdaM/R+6qjqlhVgCjfoIh2XfiKqYdS9q5mFIBOO+Z4dyGn3+1Qnu/Z7G
         /X2tm4wBSpWILX0O41P7ycgs4t3oA/Ds79/AWJNOUbdrOyky1ckPJ4w4FtocxaNGv3
         g/1QHJ9ddbTrKEyaP282Bbi51mgGqCaWTWKgD5iE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>, dja@axtens.net
Subject: [PATCH 5.4 05/17] selftests/powerpc: entry flush test
Date:   Fri, 20 Nov 2020 12:03:32 +0100
Message-Id: <20201120104541.338573089@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201120104541.058449969@linuxfoundation.org>
References: <20201120104541.058449969@linuxfoundation.org>
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
the upstream rfi_flush. This is cleaned up upstream, but we don't clean
it up here because it would involve bringing in even more commits.

Signed-off-by: Daniel Axtens <dja@axtens.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kernel/setup_64.c                         |    2 
 arch/powerpc/platforms/powernv/setup.c                 |    6 
 tools/testing/selftests/powerpc/security/.gitignore    |    1 
 tools/testing/selftests/powerpc/security/Makefile      |    2 
 tools/testing/selftests/powerpc/security/entry_flush.c |  163 +++++++++++++++++
 5 files changed, 170 insertions(+), 4 deletions(-)
 create mode 100644 tools/testing/selftests/powerpc/security/entry_flush.c

--- a/arch/powerpc/kernel/setup_64.c
+++ b/arch/powerpc/kernel/setup_64.c
@@ -1025,7 +1025,7 @@ void setup_uaccess_flush(bool enable)
 		return;
 
 	if (!no_uaccess_flush)
-		uaccess_flush_enable(true);
+		uaccess_flush_enable(enable);
 }
 
 #ifdef CONFIG_DEBUG_FS
--- a/arch/powerpc/platforms/powernv/setup.c
+++ b/arch/powerpc/platforms/powernv/setup.c
@@ -124,10 +124,12 @@ static void pnv_setup_rfi_flush(void)
 
 	/*
 	 * If we are non-Power9 bare metal, we don't need to flush on kernel
-	 * entry: it fixes a P9 specific vulnerability.
+	 * entry or after user access: they fix a P9 specific vulnerability.
 	 */
-	if (!pvr_version_is(PVR_POWER9))
+	if (!pvr_version_is(PVR_POWER9)) {
 		security_ftr_clear(SEC_FTR_L1D_FLUSH_ENTRY);
+		security_ftr_clear(SEC_FTR_L1D_FLUSH_UACCESS);
+	}
 
 	enable = security_ftr_enabled(SEC_FTR_FAVOUR_SECURITY) && \
 		 (security_ftr_enabled(SEC_FTR_L1D_FLUSH_PR)   || \
--- a/tools/testing/selftests/powerpc/security/.gitignore
+++ b/tools/testing/selftests/powerpc/security/.gitignore
@@ -1 +1,2 @@
 rfi_flush
+entry_flush
--- a/tools/testing/selftests/powerpc/security/Makefile
+++ b/tools/testing/selftests/powerpc/security/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0+
 
-TEST_GEN_PROGS := rfi_flush
+TEST_GEN_PROGS := rfi_flush entry_flush
 top_srcdir = ../../../../..
 
 CFLAGS += -I../../../../../usr/include
--- /dev/null
+++ b/tools/testing/selftests/powerpc/security/entry_flush.c
@@ -0,0 +1,163 @@
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
+		  unsigned long zero_size)
+{
+	for (unsigned long i = 0; i < iterations; i++) {
+		for (unsigned long j = 0; j < zero_size; j += CACHELINE_SIZE)
+			load(p + j);
+		getppid();
+	}
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
+	} else
+		printf("PASS (L1D misses with entry_flush=%d: %llu %c %lu) [%d/%d pass]\n",
+		       entry_flush, l1d_misses_total, entry_flush ? '>' : '<',
+		       entry_flush ? repetitions * l1d_misses_expected :
+		       repetitions * l1d_misses_expected / 2,
+		       passes, repetitions);
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


