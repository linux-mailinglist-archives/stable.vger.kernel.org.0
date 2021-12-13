Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A4AF472542
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:43:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232580AbhLMJnJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:43:09 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:35060 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235170AbhLMJk3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:40:29 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 41AC5CE0E95;
        Mon, 13 Dec 2021 09:40:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2949C00446;
        Mon, 13 Dec 2021 09:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388425;
        bh=W3WD8vaDZZ/P5MRvqkwL6oHKFOb+QA+NL51+V+9favY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mSFdZPQ5rIG65XID+YRn3krjtx3jy0QPwTGG65jGAwnrEHrVmfdAfl9J7Opj6t7Bv
         uNlaHWUf985zoMLu8i/cduku71wp3p2V4K9zvCoaxJ/EyxmREBTb9jJinOVyDpmg3x
         n3b+TIAsCnTOQ2n0JvDOzQOQ9i65t8FG+H6h+0jA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Clark <james.clark@arm.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ian Rogers <irogers@google.com>,
        =?UTF-8?q?Jaroslav=20=C5=A0karvada?= <jskarvad@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 4.19 45/74] tools build: Remove needless libpython-version feature check that breaks test-all fast path
Date:   Mon, 13 Dec 2021 10:30:16 +0100
Message-Id: <20211213092932.320515173@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092930.763200615@linuxfoundation.org>
References: <20211213092930.763200615@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

commit 3d1d57debee2d342a47615707588b96658fabb85 upstream.

Since 66dfdff03d196e51 ("perf tools: Add Python 3 support") we don't use
the tools/build/feature/test-libpython-version.c version in any Makefile
feature check:

  $ find tools/ -type f | xargs grep feature-libpython-version
  $

The only place where this was used was removed in 66dfdff03d196e51:

  -        ifneq ($(feature-libpython-version), 1)
  -          $(warning Python 3 is not yet supported; please set)
  -          $(warning PYTHON and/or PYTHON_CONFIG appropriately.)
  -          $(warning If you also have Python 2 installed, then)
  -          $(warning try something like:)
  -          $(warning $(and ,))
  -          $(warning $(and ,)  make PYTHON=python2)
  -          $(warning $(and ,))
  -          $(warning Otherwise, disable Python support entirely:)
  -          $(warning $(and ,))
  -          $(warning $(and ,)  make NO_LIBPYTHON=1)
  -          $(warning $(and ,))
  -          $(error   $(and ,))
  -        else
  -          LDFLAGS += $(PYTHON_EMBED_LDFLAGS)
  -          EXTLIBS += $(PYTHON_EMBED_LIBADD)
  -          LANG_BINDINGS += $(obj-perf)python/perf.so
  -          $(call detected,CONFIG_LIBPYTHON)
  -        endif

And nowadays we either build with PYTHON=python3 or just install the
python3 devel packages and perf will build against it.

But the leftover feature-libpython-version check made the fast path
feature detection to break in all cases except when python2 devel files
were installed:

  $ rpm -qa | grep python.*devel
  python3-devel-3.9.7-1.fc34.x86_64
  $ rm -rf /tmp/build/perf ; mkdir -p /tmp/build/perf ;
  $ make -C tools/perf O=/tmp/build/perf install-bin
  make: Entering directory '/var/home/acme/git/perf/tools/perf'
    BUILD:   Doing 'make -j32' parallel build
    HOSTCC  /tmp/build/perf/fixdep.o
  <SNIP>
  $ cat /tmp/build/perf/feature/test-all.make.output
  In file included from test-all.c:18:
  test-libpython-version.c:5:10: error: #error
      5 |         #error
        |          ^~~~~
  $ ldd ~/bin/perf | grep python
	libpython3.9.so.1.0 => /lib64/libpython3.9.so.1.0 (0x00007fda6dbcf000)
  $

As python3 is the norm these days, fix this by just removing the unused
feature-libpython-version feature check, making the test-all fast path
to work with the common case.

With this:

  $ rm -rf /tmp/build/perf ; mkdir -p /tmp/build/perf ;
  $ make -C tools/perf O=/tmp/build/perf install-bin |& head
  make: Entering directory '/var/home/acme/git/perf/tools/perf'
    BUILD:   Doing 'make -j32' parallel build
    HOSTCC  /tmp/build/perf/fixdep.o
    HOSTLD  /tmp/build/perf/fixdep-in.o
    LINK    /tmp/build/perf/fixdep

  Auto-detecting system features:
  ...                         dwarf: [ on  ]
  ...            dwarf_getlocations: [ on  ]
  ...                         glibc: [ on  ]
  $ ldd ~/bin/perf | grep python
	libpython3.9.so.1.0 => /lib64/libpython3.9.so.1.0 (0x00007f58800b0000)
  $ cat /tmp/build/perf/feature/test-all.make.output
  $

Reviewed-by: James Clark <james.clark@arm.com>
Fixes: 66dfdff03d196e51 ("perf tools: Add Python 3 support")
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Jaroslav Škarvada <jskarvad@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: https://lore.kernel.org/lkml/YaYmeeC6CS2b8OSz@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/build/Makefile.feature                 |    1 -
 tools/build/feature/Makefile                 |    4 ----
 tools/build/feature/test-all.c               |    5 -----
 tools/build/feature/test-libpython-version.c |   11 -----------
 tools/perf/Makefile.config                   |    2 --
 5 files changed, 23 deletions(-)
 delete mode 100644 tools/build/feature/test-libpython-version.c

--- a/tools/build/Makefile.feature
+++ b/tools/build/Makefile.feature
@@ -50,7 +50,6 @@ FEATURE_TESTS_BASIC :=
         numa_num_possible_cpus          \
         libperl                         \
         libpython                       \
-        libpython-version               \
         libslang                        \
         libcrypto                       \
         libunwind                       \
--- a/tools/build/feature/Makefile
+++ b/tools/build/feature/Makefile
@@ -29,7 +29,6 @@ FILES=
          test-numa_num_possible_cpus.bin        \
          test-libperl.bin                       \
          test-libpython.bin                     \
-         test-libpython-version.bin             \
          test-libslang.bin                      \
          test-libcrypto.bin                     \
          test-libunwind.bin                     \
@@ -203,9 +202,6 @@ $(OUTPUT)test-libperl.bin:
 $(OUTPUT)test-libpython.bin:
 	$(BUILD) $(FLAGS_PYTHON_EMBED)
 
-$(OUTPUT)test-libpython-version.bin:
-	$(BUILD)
-
 $(OUTPUT)test-libbfd.bin:
 	$(BUILD) -DPACKAGE='"perf"' -lbfd -ldl
 
--- a/tools/build/feature/test-all.c
+++ b/tools/build/feature/test-all.c
@@ -14,10 +14,6 @@
 # include "test-libpython.c"
 #undef main
 
-#define main main_test_libpython_version
-# include "test-libpython-version.c"
-#undef main
-
 #define main main_test_libperl
 # include "test-libperl.c"
 #undef main
@@ -181,7 +177,6 @@
 int main(int argc, char *argv[])
 {
 	main_test_libpython();
-	main_test_libpython_version();
 	main_test_libperl();
 	main_test_hello();
 	main_test_libelf();
--- a/tools/build/feature/test-libpython-version.c
+++ /dev/null
@@ -1,11 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-#include <Python.h>
-
-#if PY_VERSION_HEX >= 0x03000000
-	#error
-#endif
-
-int main(void)
-{
-	return 0;
-}
--- a/tools/perf/Makefile.config
+++ b/tools/perf/Makefile.config
@@ -224,8 +224,6 @@ endif
 
 FEATURE_CHECK_CFLAGS-libpython := $(PYTHON_EMBED_CCOPTS)
 FEATURE_CHECK_LDFLAGS-libpython := $(PYTHON_EMBED_LDOPTS)
-FEATURE_CHECK_CFLAGS-libpython-version := $(PYTHON_EMBED_CCOPTS)
-FEATURE_CHECK_LDFLAGS-libpython-version := $(PYTHON_EMBED_LDOPTS)
 
 CFLAGS += -fno-omit-frame-pointer
 CFLAGS += -ggdb3


