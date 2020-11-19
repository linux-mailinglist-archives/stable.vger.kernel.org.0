Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74D492B9E69
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 00:37:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726381AbgKSXfm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Nov 2020 18:35:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726281AbgKSXfm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Nov 2020 18:35:42 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E826AC0613CF
        for <stable@vger.kernel.org>; Thu, 19 Nov 2020 15:35:40 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id j19so5666133pgg.5
        for <stable@vger.kernel.org>; Thu, 19 Nov 2020 15:35:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NzLmuaWBBSGqdynJ/WMcHo2n85ckhzIiZHy2AoiLkE8=;
        b=ISIAcg3eAW3SuRMhNh+IkPNlXkLmqto5Mokk3kXFZtpeAphKxrrVpkYsiWK12WZJ9m
         bbkgZcrSGXS90Rx5AobyhJ9gRy8YnhgYbhFCDCAlRLrhx1gJXevo1ujEchEZxuzSLYcb
         TaHqvHXgyoceDB59oE9s7Y6pDh9BRPm7tPQLc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NzLmuaWBBSGqdynJ/WMcHo2n85ckhzIiZHy2AoiLkE8=;
        b=bY4hNmm/bNl3UrnzGx9LBngP8EtVtF9x9xB7fQ/iUWzTO9u1RTLq7Z7i80hPo1UuCU
         jz3DG4GSA0WPRHKtYCr5zvMrETDPocqHtHsRv5DnPRCQ8O70szH6iqmkSXPwrkwcTFev
         spfJ4XNQ0vhxGPZBuCsKKuzQ5quG11imfcJCkWwYVOsmCkwoGNa60GJFiFL34bMVNk7l
         oEb8JGuM/0DqqZOJD/+i9/PMhf4N5ny64hPqkTmLuWy40kez9t5QnWeZOqwv4UozHHsP
         lcUf835ek99bEWR50ncVAArV5OgqLelVophpVs46t2m68tZ5F0/Ys38N+JaPDD7U/GDu
         aeyw==
X-Gm-Message-State: AOAM533LvTmO6C2hQFloYsyNaQAwB5YX47/GUg7NR+LrAP0r/CV7l2eK
        sdPe1cAiATU+dR7Fx8B7MMH5JXKM0XhaSQ==
X-Google-Smtp-Source: ABdhPJxyY28mxqXsnzcjJEf0VyfuPX9UuCfcC2CgOFNfI2SZzmBbyscHM3S0w3Ji6ZmIsu/2AoZv2A==
X-Received: by 2002:a17:90a:a891:: with SMTP id h17mr7196289pjq.149.1605828940174;
        Thu, 19 Nov 2020 15:35:40 -0800 (PST)
Received: from localhost (2001-44b8-1113-6700-4d44-522c-3789-8f33.static.ipv6.internode.on.net. [2001:44b8:1113:6700:4d44:522c:3789:8f33])
        by smtp.gmail.com with ESMTPSA id j19sm1054574pfd.189.2020.11.19.15.35.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2020 15:35:39 -0800 (PST)
From:   Daniel Axtens <dja@axtens.net>
To:     stable@vger.kernel.org
Cc:     dja@axtens.net
Subject: [PATCH 5.4 5/5] selftests/powerpc: entry flush test
Date:   Fri, 20 Nov 2020 10:35:16 +1100
Message-Id: <20201119233516.368194-6-dja@axtens.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201119233516.368194-1-dja@axtens.net>
References: <20201119233516.368194-1-dja@axtens.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 89a83a0c69c81a25ce91002b90ca27ed86132a0a upstream.

Add a test modelled on the RFI flush test which counts the number
of L1D misses doing a simple syscall with the entry flush on and off.

For simplicity of backporting, this test duplicates a lot of code from
the upstream rfi_flush. This is cleaned up upstream, but we don't clean
it up here because it would involve bringing in even more commits.

Signed-off-by: Daniel Axtens <dja@axtens.net>
---
 arch/powerpc/kernel/setup_64.c                |   2 +-
 arch/powerpc/platforms/powernv/setup.c        |   6 +-
 .../selftests/powerpc/security/.gitignore     |   1 +
 .../selftests/powerpc/security/Makefile       |   2 +-
 .../selftests/powerpc/security/entry_flush.c  | 163 ++++++++++++++++++
 5 files changed, 170 insertions(+), 4 deletions(-)
 create mode 100644 tools/testing/selftests/powerpc/security/entry_flush.c

diff --git a/arch/powerpc/kernel/setup_64.c b/arch/powerpc/kernel/setup_64.c
index a6b72dd431a4..480c236724da 100644
--- a/arch/powerpc/kernel/setup_64.c
+++ b/arch/powerpc/kernel/setup_64.c
@@ -1025,7 +1025,7 @@ void setup_uaccess_flush(bool enable)
 		return;
 
 	if (!no_uaccess_flush)
-		uaccess_flush_enable(true);
+		uaccess_flush_enable(enable);
 }
 
 #ifdef CONFIG_DEBUG_FS
diff --git a/arch/powerpc/platforms/powernv/setup.c b/arch/powerpc/platforms/powernv/setup.c
index ef7b4c09e7d6..3a9f79d18f6b 100644
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
diff --git a/tools/testing/selftests/powerpc/security/.gitignore b/tools/testing/selftests/powerpc/security/.gitignore
index 0b969fba3beb..b8afb4f2481e 100644
--- a/tools/testing/selftests/powerpc/security/.gitignore
+++ b/tools/testing/selftests/powerpc/security/.gitignore
@@ -1 +1,2 @@
 rfi_flush
+entry_flush
diff --git a/tools/testing/selftests/powerpc/security/Makefile b/tools/testing/selftests/powerpc/security/Makefile
index 85861c46b445..e550a287768f 100644
--- a/tools/testing/selftests/powerpc/security/Makefile
+++ b/tools/testing/selftests/powerpc/security/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0+
 
-TEST_GEN_PROGS := rfi_flush
+TEST_GEN_PROGS := rfi_flush entry_flush
 top_srcdir = ../../../../..
 
 CFLAGS += -I../../../../../usr/include
diff --git a/tools/testing/selftests/powerpc/security/entry_flush.c b/tools/testing/selftests/powerpc/security/entry_flush.c
new file mode 100644
index 000000000000..dae8c99a8ebc
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
-- 
2.25.1

