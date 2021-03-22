Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03A60344430
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 14:00:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbhCVM7C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:59:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:47784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232415AbhCVMyx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:54:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 938C36199F;
        Mon, 22 Mar 2021 12:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616417282;
        bh=UKGsF5MysejOp8w8YsRRvEfMeJvrxISy/+1ZJQE80SA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EFwTrUaZMa5yb70Xq2jXfI8gCmCK4OYbiwolbeoiLK+AkpX7sedGj8+YqSWEVKN5D
         Lzr5Y9zGz47bAiHkgPEdmIdQE8AZGmmuz5irEvYbuOoHQyOwIKMLFbp67FwyZNcIg5
         zsmVeb3SHL/GbxGgDftDqTc8h6QlQhNSl08WRKsU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Laura Abbott <labbott@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Florian Weimer <fweimer@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 4.14 13/43] tools build: Check if gettid() is available before providing helper
Date:   Mon, 22 Mar 2021 13:28:54 +0100
Message-Id: <20210322121920.476814740@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121920.053255560@linuxfoundation.org>
References: <20210322121920.053255560@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

commit 4541a8bb13a86e504416a13360c8dc64d2fd612a upstream.

Laura reported that the perf build failed in fedora when we got a glibc
that provides gettid(), which I reproduced using fedora rawhide with the
glibc-devel-2.29.9000-26.fc31.x86_64 package.

Add a feature check to avoid providing a gettid() helper in such
systems.

On a fedora rawhide system with this patch applied we now get:

  [root@7a5f55352234 perf]# grep gettid /tmp/build/perf/FEATURE-DUMP
  feature-gettid=1
  [root@7a5f55352234 perf]# cat /tmp/build/perf/feature/test-gettid.make.output
  [root@7a5f55352234 perf]# ldd /tmp/build/perf/feature/test-gettid.bin
          linux-vdso.so.1 (0x00007ffc6b1f6000)
          libc.so.6 => /lib64/libc.so.6 (0x00007f04e0a74000)
          /lib64/ld-linux-x86-64.so.2 (0x00007f04e0c47000)
  [root@7a5f55352234 perf]# nm /tmp/build/perf/feature/test-gettid.bin | grep -w gettid
                   U gettid@@GLIBC_2.30
  [root@7a5f55352234 perf]#

While on a fedora:29 system:

  [acme@quaco perf]$ grep gettid /tmp/build/perf/FEATURE-DUMP
  feature-gettid=0
  [acme@quaco perf]$ cat /tmp/build/perf/feature/test-gettid.make.output
  test-gettid.c: In function ‘main’:
  test-gettid.c:8:9: error: implicit declaration of function ‘gettid’; did you mean ‘getgid’? [-Werror=implicit-function-declaration]
    return gettid();
           ^~~~~~
           getgid
  cc1: all warnings being treated as errors
  [acme@quaco perf]$

Reported-by: Laura Abbott <labbott@redhat.com>
Tested-by: Laura Abbott <labbott@redhat.com>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Florian Weimer <fweimer@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Stephane Eranian <eranian@google.com>
Link: https://lkml.kernel.org/n/tip-yfy3ch53agmklwu9o7rlgf9c@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/build/Makefile.feature      |    1 +
 tools/build/feature/Makefile      |    4 ++++
 tools/build/feature/test-all.c    |    5 +++++
 tools/build/feature/test-gettid.c |   11 +++++++++++
 tools/perf/Makefile.config        |    4 ++++
 tools/perf/jvmti/jvmti_agent.c    |    2 ++
 6 files changed, 27 insertions(+)
 create mode 100644 tools/build/feature/test-gettid.c

--- a/tools/build/Makefile.feature
+++ b/tools/build/Makefile.feature
@@ -35,6 +35,7 @@ FEATURE_TESTS_BASIC :=
         fortify-source                  \
         sync-compare-and-swap           \
         get_current_dir_name            \
+        gettid				\
         glibc                           \
         gtk2                            \
         gtk2-infobar                    \
--- a/tools/build/feature/Makefile
+++ b/tools/build/feature/Makefile
@@ -51,6 +51,7 @@ FILES=
          test-get_cpuid.bin                     \
          test-sdt.bin                           \
          test-cxx.bin                           \
+         test-gettid.bin			\
          test-jvmti.bin				\
          test-sched_getcpu.bin			\
          test-setns.bin
@@ -242,6 +243,9 @@ $(OUTPUT)test-sdt.bin:
 $(OUTPUT)test-cxx.bin:
 	$(BUILDXX) -std=gnu++11
 
+$(OUTPUT)test-gettid.bin:
+	$(BUILD)
+
 $(OUTPUT)test-jvmti.bin:
 	$(BUILD)
 
--- a/tools/build/feature/test-all.c
+++ b/tools/build/feature/test-all.c
@@ -38,6 +38,10 @@
 # include "test-get_current_dir_name.c"
 #undef main
 
+#define main main_test_gettid
+# include "test-gettid.c"
+#undef main
+
 #define main main_test_glibc
 # include "test-glibc.c"
 #undef main
@@ -175,6 +179,7 @@ int main(int argc, char *argv[])
 	main_test_libelf();
 	main_test_libelf_mmap();
 	main_test_get_current_dir_name();
+	main_test_gettid();
 	main_test_glibc();
 	main_test_dwarf();
 	main_test_dwarf_getlocations();
--- /dev/null
+++ b/tools/build/feature/test-gettid.c
@@ -0,0 +1,11 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (C) 2019, Red Hat Inc, Arnaldo Carvalho de Melo <acme@redhat.com>
+#define _GNU_SOURCE
+#include <unistd.h>
+
+int main(void)
+{
+	return gettid();
+}
+
+#undef _GNU_SOURCE
--- a/tools/perf/Makefile.config
+++ b/tools/perf/Makefile.config
@@ -289,6 +289,10 @@ ifeq ($(feature-get_current_dir_name), 1
   CFLAGS += -DHAVE_GET_CURRENT_DIR_NAME
 endif
 
+ifeq ($(feature-gettid), 1)
+  CFLAGS += -DHAVE_GETTID
+endif
+
 ifdef NO_LIBELF
   NO_DWARF := 1
   NO_DEMANGLE := 1
--- a/tools/perf/jvmti/jvmti_agent.c
+++ b/tools/perf/jvmti/jvmti_agent.c
@@ -45,10 +45,12 @@
 static char jit_path[PATH_MAX];
 static void *marker_addr;
 
+#ifndef HAVE_GETTID
 static inline pid_t gettid(void)
 {
 	return (pid_t)syscall(__NR_gettid);
 }
+#endif
 
 static int get_e_machine(struct jitheader *hdr)
 {


