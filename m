Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED08034442E
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 14:00:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233617AbhCVM67 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:58:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:47782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232400AbhCVMyw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:54:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E52C461992;
        Mon, 22 Mar 2021 12:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616417279;
        bh=2aWOVPY3pgua/t8lko9tvsnfJRISgZ3flOjQKT0/UkQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rJH3yfJbnNL0aAYK6EBp5qCcXXWvuEMZ6Fy5uEZb504h9+BaGIG55h+0JoTULVB2U
         u773uJX2hhpLhJr0zgqN3U87oPonzS/dalXvhYt6fPdZBnQfyo2WfE/X2/hq9PkUTN
         /7DeHgSZL7Az2siMBOMUn5v0bHDoQ4uyxQPR3rpU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Ahern <dsahern@gmail.com>,
        Davidlohr Bueso <dbueso@suse.de>,
        Jason Baron <jbaron@akamai.com>, Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Wang Nan <wangnan0@huawei.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.14 12/43] tools build feature: Check if eventfd() is available
Date:   Mon, 22 Mar 2021 13:28:53 +0100
Message-Id: <20210322121920.444376328@linuxfoundation.org>
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

commit 11c6cbe706f218a8dc7e1f962f12b3a52ddd33a9 upstream.

A new 'perf bench epoll' will use this, and to disable it for older
systems, add a feature test for this API.

This is just a simple program that if successfully compiled, means that
the feature is present, at least at the library level, in a build that
sets the output directory to /tmp/build/perf (using O=/tmp/build/perf),
we end up with:

  $ ls -la /tmp/build/perf/feature/test-eventfd*
  -rwxrwxr-x. 1 acme acme 8176 Nov 21 15:58 /tmp/build/perf/feature/test-eventfd.bin
  -rw-rw-r--. 1 acme acme  588 Nov 21 15:58 /tmp/build/perf/feature/test-eventfd.d
  -rw-rw-r--. 1 acme acme    0 Nov 21 15:58 /tmp/build/perf/feature/test-eventfd.make.output
  $ ldd /tmp/build/perf/feature/test-eventfd.bin
	  linux-vdso.so.1 (0x00007fff3bf3f000)
	  libc.so.6 => /lib64/libc.so.6 (0x00007fa984061000)
	  /lib64/ld-linux-x86-64.so.2 (0x00007fa984417000)
  $ grep eventfd -A 2 -B 2 /tmp/build/perf/FEATURE-DUMP
  feature-dwarf=1
  feature-dwarf_getlocations=1
  feature-eventfd=1
  feature-fortify-source=1
  feature-sync-compare-and-swap=1
  $

The main thing here is that in the end we'll have -DHAVE_EVENTFD in
CFLAGS, and then the 'perf bench' entry needing that API can be
selectively pruned.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Davidlohr Bueso <dbueso@suse.de>
Cc: Jason Baron <jbaron@akamai.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Wang Nan <wangnan0@huawei.com>
Link: https://lkml.kernel.org/n/tip-wkeldwob7dpx6jvtuzl8164k@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/build/Makefile.feature       |    1 +
 tools/build/feature/Makefile       |    4 ++++
 tools/build/feature/test-all.c     |    5 +++++
 tools/build/feature/test-eventfd.c |    9 +++++++++
 tools/perf/Makefile.config         |    5 ++++-
 5 files changed, 23 insertions(+), 1 deletion(-)
 create mode 100644 tools/build/feature/test-eventfd.c

--- a/tools/build/Makefile.feature
+++ b/tools/build/Makefile.feature
@@ -31,6 +31,7 @@ FEATURE_TESTS_BASIC :=
         backtrace                       \
         dwarf                           \
         dwarf_getlocations              \
+        eventfd                         \
         fortify-source                  \
         sync-compare-and-swap           \
         get_current_dir_name            \
--- a/tools/build/feature/Makefile
+++ b/tools/build/feature/Makefile
@@ -5,6 +5,7 @@ FILES=
          test-bionic.bin                        \
          test-dwarf.bin                         \
          test-dwarf_getlocations.bin            \
+         test-eventfd.bin                       \
          test-fortify-source.bin                \
          test-sync-compare-and-swap.bin         \
          test-get_current_dir_name.bin          \
@@ -90,6 +91,9 @@ $(OUTPUT)test-bionic.bin:
 $(OUTPUT)test-libelf.bin:
 	$(BUILD) -lelf
 
+$(OUTPUT)test-eventfd.bin:
+	$(BUILD)
+
 $(OUTPUT)test-get_current_dir_name.bin:
 	$(BUILD)
 
--- a/tools/build/feature/test-all.c
+++ b/tools/build/feature/test-all.c
@@ -50,6 +50,10 @@
 # include "test-dwarf_getlocations.c"
 #undef main
 
+#define main main_test_eventfd
+# include "test-eventfd.c"
+#undef main
+
 #define main main_test_libelf_getphdrnum
 # include "test-libelf-getphdrnum.c"
 #undef main
@@ -174,6 +178,7 @@ int main(int argc, char *argv[])
 	main_test_glibc();
 	main_test_dwarf();
 	main_test_dwarf_getlocations();
+	main_test_eventfd();
 	main_test_libelf_getphdrnum();
 	main_test_libelf_gelf_getnote();
 	main_test_libelf_getshdrstrndx();
--- /dev/null
+++ b/tools/build/feature/test-eventfd.c
@@ -0,0 +1,9 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (C) 2018, Red Hat Inc, Arnaldo Carvalho de Melo <acme@redhat.com>
+
+#include <sys/eventfd.h>
+
+int main(void)
+{
+	return eventfd(0, EFD_NONBLOCK);
+}
--- a/tools/perf/Makefile.config
+++ b/tools/perf/Makefile.config
@@ -281,11 +281,14 @@ ifndef NO_BIONIC
   endif
 endif
 
+ifeq ($(feature-eventfd), 1)
+  CFLAGS += -DHAVE_EVENTFD
+endif
+
 ifeq ($(feature-get_current_dir_name), 1)
   CFLAGS += -DHAVE_GET_CURRENT_DIR_NAME
 endif
 
-
 ifdef NO_LIBELF
   NO_DWARF := 1
   NO_DEMANGLE := 1


