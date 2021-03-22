Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7473D344410
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:59:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231589AbhCVM46 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:56:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:47780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232398AbhCVMyw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:54:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A939361931;
        Mon, 22 Mar 2021 12:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616417277;
        bh=RoXAKdvmnQcMvt2m5yDhCag9lLJJdEBuiWmWySmg5p8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pgr1VYSnVzesxk5xED4XdJHeyb+vm50v2GjD5oSXA2b4WjTVucotsRXiQpdipRl/M
         ZB7LrcEvAkrxiAc3+zWkdSCcaum3rAGgL/olGLq92FJe/nOv8XqeMoj1cVg2ZS3Pcc
         qRnypOPC+tICVksfJsaHgROjGIs1RrgT7Rt5ilFQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Wang Nan <wangnan0@huawei.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.14 11/43] tools build feature: Check if get_current_dir_name() is available
Date:   Mon, 22 Mar 2021 13:28:52 +0100
Message-Id: <20210322121920.415109639@linuxfoundation.org>
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

commit 8feb8efef97a134933620071e0b6384cb3238b4e upstream.

As the namespace support code will use this, which is not available in
some non _GNU_SOURCE libraries such as Android's bionic used in my
container build tests (r12b and r15c at the moment).

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Wang Nan <wangnan0@huawei.com>
Link: https://lkml.kernel.org/n/tip-x56ypm940pwclwu45d7jfj47@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/build/Makefile.feature                    |    1 +
 tools/build/feature/Makefile                    |    4 ++++
 tools/build/feature/test-all.c                  |    5 +++++
 tools/build/feature/test-get_current_dir_name.c |   10 ++++++++++
 tools/perf/Makefile.config                      |    5 +++++
 tools/perf/util/Build                           |    1 +
 tools/perf/util/get_current_dir_name.c          |   18 ++++++++++++++++++
 tools/perf/util/util.h                          |    4 ++++
 8 files changed, 48 insertions(+)
 create mode 100644 tools/build/feature/test-get_current_dir_name.c
 create mode 100644 tools/perf/util/get_current_dir_name.c

--- a/tools/build/Makefile.feature
+++ b/tools/build/Makefile.feature
@@ -33,6 +33,7 @@ FEATURE_TESTS_BASIC :=
         dwarf_getlocations              \
         fortify-source                  \
         sync-compare-and-swap           \
+        get_current_dir_name            \
         glibc                           \
         gtk2                            \
         gtk2-infobar                    \
--- a/tools/build/feature/Makefile
+++ b/tools/build/feature/Makefile
@@ -7,6 +7,7 @@ FILES=
          test-dwarf_getlocations.bin            \
          test-fortify-source.bin                \
          test-sync-compare-and-swap.bin         \
+         test-get_current_dir_name.bin          \
          test-glibc.bin                         \
          test-gtk2.bin                          \
          test-gtk2-infobar.bin                  \
@@ -89,6 +90,9 @@ $(OUTPUT)test-bionic.bin:
 $(OUTPUT)test-libelf.bin:
 	$(BUILD) -lelf
 
+$(OUTPUT)test-get_current_dir_name.bin:
+	$(BUILD)
+
 $(OUTPUT)test-glibc.bin:
 	$(BUILD)
 
--- a/tools/build/feature/test-all.c
+++ b/tools/build/feature/test-all.c
@@ -34,6 +34,10 @@
 # include "test-libelf-mmap.c"
 #undef main
 
+#define main main_test_get_current_dir_name
+# include "test-get_current_dir_name.c"
+#undef main
+
 #define main main_test_glibc
 # include "test-glibc.c"
 #undef main
@@ -166,6 +170,7 @@ int main(int argc, char *argv[])
 	main_test_hello();
 	main_test_libelf();
 	main_test_libelf_mmap();
+	main_test_get_current_dir_name();
 	main_test_glibc();
 	main_test_dwarf();
 	main_test_dwarf_getlocations();
--- /dev/null
+++ b/tools/build/feature/test-get_current_dir_name.c
@@ -0,0 +1,10 @@
+// SPDX-License-Identifier: GPL-2.0
+#define _GNU_SOURCE
+#include <unistd.h>
+#include <stdlib.h>
+
+int main(void)
+{
+	free(get_current_dir_name());
+	return 0;
+}
--- a/tools/perf/Makefile.config
+++ b/tools/perf/Makefile.config
@@ -281,6 +281,11 @@ ifndef NO_BIONIC
   endif
 endif
 
+ifeq ($(feature-get_current_dir_name), 1)
+  CFLAGS += -DHAVE_GET_CURRENT_DIR_NAME
+endif
+
+
 ifdef NO_LIBELF
   NO_DWARF := 1
   NO_DEMANGLE := 1
--- a/tools/perf/util/Build
+++ b/tools/perf/util/Build
@@ -10,6 +10,7 @@ libperf-y += evlist.o
 libperf-y += evsel.o
 libperf-y += evsel_fprintf.o
 libperf-y += find_bit.o
+libperf-y += get_current_dir_name.o
 libperf-y += kallsyms.o
 libperf-y += levenshtein.o
 libperf-y += llvm-utils.o
--- /dev/null
+++ b/tools/perf/util/get_current_dir_name.c
@@ -0,0 +1,18 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (C) 2018, Red Hat Inc, Arnaldo Carvalho de Melo <acme@redhat.com>
+//
+#ifndef HAVE_GET_CURRENT_DIR_NAME
+#include "util.h"
+#include <unistd.h>
+#include <stdlib.h>
+#include <stdlib.h>
+
+/* Android's 'bionic' library, for one, doesn't have this */
+
+char *get_current_dir_name(void)
+{
+	char pwd[PATH_MAX];
+
+	return getcwd(pwd, sizeof(pwd)) == NULL ? NULL : strdup(pwd);
+}
+#endif // HAVE_GET_CURRENT_DIR_NAME
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -57,6 +57,10 @@ int fetch_kernel_version(unsigned int *p
 
 const char *perf_tip(const char *dirpath);
 
+#ifndef HAVE_GET_CURRENT_DIR_NAME
+char *get_current_dir_name(void);
+#endif
+
 #ifndef HAVE_SCHED_GETCPU_SUPPORT
 int sched_getcpu(void);
 #endif


