Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81D1C67E76E
	for <lists+stable@lfdr.de>; Fri, 27 Jan 2023 14:58:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234229AbjA0N6g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Jan 2023 08:58:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233858AbjA0N61 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Jan 2023 08:58:27 -0500
Received: from smtpout.efficios.com (smtpout.efficios.com [167.114.26.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A5F1BE;
        Fri, 27 Jan 2023 05:58:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=efficios.com;
        s=smtpout1; t=1674827885;
        bh=W1SNh9l0TTB1KBtqwgm3YAfF4yBh2kKc5Jd9s6u7Pq8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IkB8kiVCqVI+YwWj5pZqoy1+Z4gzF1KJ2e2rHjwkerBQWcq5fEosi742/rGPUImHX
         1dAuTpad1nej1fnX5w5HCinO3PO4hAYR0VGbUBwKHDEK6fIc/UBUvhk8VsV6qRsebi
         bHETpeJcM5kAYj7vSimd75R7p/b1cG2FHPwBfIaRFkmrzStZ05cUHhGSBvE1ygDCvX
         DQlDt4T/NrVIvupKeDHIzXH+jZ5vrflGHxJMXC6a8qCQ9adK9fj4wlJGprJKD+Plop
         /TRahV4z8roHAZZD1n4pzREhg3mnU5l82sfh9/4jf8Xok6hSaMWGI2I/7TC8BIsz7r
         RwU8Q+y2puuNQ==
Received: from localhost.localdomain (192-222-180-24.qc.cable.ebox.net [192.222.180.24])
        by smtpout.efficios.com (Postfix) with ESMTPSA id 4P3K0Y4Jt3zhWf;
        Fri, 27 Jan 2023 08:58:05 -0500 (EST)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>
Cc:     linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        stable@vger.kernel.org
Subject: [PATCH 21/34] selftests: powerpc: Fix incorrect kernel headers search path
Date:   Fri, 27 Jan 2023 08:57:42 -0500
Message-Id: <20230127135755.79929-22-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230127135755.79929-1-mathieu.desnoyers@efficios.com>
References: <20230127135755.79929-1-mathieu.desnoyers@efficios.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Use $(KHDR_INCLUDES) as lookup path for kernel headers. This prevents
building against kernel headers from the build environment in scenarios
where kernel headers are installed into a specific output directory
(O=...).

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: linux-kselftest@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>
Cc: <stable@vger.kernel.org>    [5.18+]
---
 tools/testing/selftests/powerpc/ptrace/Makefile   | 2 +-
 tools/testing/selftests/powerpc/security/Makefile | 2 +-
 tools/testing/selftests/powerpc/syscalls/Makefile | 2 +-
 tools/testing/selftests/powerpc/tm/Makefile       | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/powerpc/ptrace/Makefile b/tools/testing/selftests/powerpc/ptrace/Makefile
index 2f02cb54224d..cbeeaeae8837 100644
--- a/tools/testing/selftests/powerpc/ptrace/Makefile
+++ b/tools/testing/selftests/powerpc/ptrace/Makefile
@@ -33,7 +33,7 @@ TESTS_64 := $(patsubst %,$(OUTPUT)/%,$(TESTS_64))
 $(TESTS_64): CFLAGS += -m64
 $(TM_TESTS): CFLAGS += -I../tm -mhtm
 
-CFLAGS += -I../../../../../usr/include -fno-pie
+CFLAGS += $(KHDR_INCLUDES) -fno-pie
 
 $(OUTPUT)/ptrace-gpr: ptrace-gpr.S
 $(OUTPUT)/ptrace-pkey $(OUTPUT)/core-pkey: LDLIBS += -pthread
diff --git a/tools/testing/selftests/powerpc/security/Makefile b/tools/testing/selftests/powerpc/security/Makefile
index 7488315fd847..e0d979ab0204 100644
--- a/tools/testing/selftests/powerpc/security/Makefile
+++ b/tools/testing/selftests/powerpc/security/Makefile
@@ -5,7 +5,7 @@ TEST_PROGS := mitigation-patching.sh
 
 top_srcdir = ../../../../..
 
-CFLAGS += -I../../../../../usr/include
+CFLAGS += $(KHDR_INCLUDES)
 
 include ../../lib.mk
 
diff --git a/tools/testing/selftests/powerpc/syscalls/Makefile b/tools/testing/selftests/powerpc/syscalls/Makefile
index b63f8459c704..d1f2648b112b 100644
--- a/tools/testing/selftests/powerpc/syscalls/Makefile
+++ b/tools/testing/selftests/powerpc/syscalls/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 TEST_GEN_PROGS := ipc_unmuxed rtas_filter
 
-CFLAGS += -I../../../../../usr/include
+CFLAGS += $(KHDR_INCLUDES)
 
 top_srcdir = ../../../../..
 include ../../lib.mk
diff --git a/tools/testing/selftests/powerpc/tm/Makefile b/tools/testing/selftests/powerpc/tm/Makefile
index 5881e97c73c1..3876805c2f31 100644
--- a/tools/testing/selftests/powerpc/tm/Makefile
+++ b/tools/testing/selftests/powerpc/tm/Makefile
@@ -17,7 +17,7 @@ $(TEST_GEN_PROGS): ../harness.c ../utils.c
 CFLAGS += -mhtm
 
 $(OUTPUT)/tm-syscall: tm-syscall-asm.S
-$(OUTPUT)/tm-syscall: CFLAGS += -I../../../../../usr/include
+$(OUTPUT)/tm-syscall: CFLAGS += $(KHDR_INCLUDES)
 $(OUTPUT)/tm-tmspr: CFLAGS += -pthread
 $(OUTPUT)/tm-vmx-unavail: CFLAGS += -pthread -m64
 $(OUTPUT)/tm-resched-dscr: ../pmu/lib.c
-- 
2.25.1

