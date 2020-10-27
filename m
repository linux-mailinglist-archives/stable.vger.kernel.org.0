Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7829D29B4F0
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:12:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1793599AbgJ0PHW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:07:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:37776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1789883AbgJ0PDV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:03:21 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 225692225E;
        Tue, 27 Oct 2020 15:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811000;
        bh=8pHZC0dlnngOg1NRaN5KXQrJdtIA+PUtW76u4J7dN50=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mKVGjik0wAWxkuoEU/eVacMP4tID+/Eb7eyMMfuC+ajblLaNnrT9JEo9YRSiP2xtq
         qF2t0n23f/Xx7yOYDee8BZAKvkPdYsJrXUfC+oLvGp/Harq+qXuTT3Wt6OQ602XsyT
         jHSnF4+28kJOylrQQnc2P0EU0Z5g3eEuS1ohkoq0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Ian Rogers <irogers@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 338/633] perf tools: Make GTK2 support opt-in
Date:   Tue, 27 Oct 2020 14:51:21 +0100
Message-Id: <20201027135538.541555082@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 4751bddd3f983af2004ec470ca38b42d7a8a53bc ]

This is bitrotting, nobody is stepping up to work on it, and since we
treat warnings as errors, feature detection is failing in its main,
faster test (tools/build/feature/test-all.c) because of the GTK+2
infobar check.

So make this opt-in, at some point ditch this if nobody volunteers to
take care of this.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/build/Makefile.feature   |  5 ++---
 tools/build/feature/Makefile   |  2 +-
 tools/build/feature/test-all.c | 10 ----------
 tools/perf/Makefile.config     |  4 +++-
 tools/perf/Makefile.perf       |  6 +++---
 tools/perf/builtin-version.c   |  1 -
 6 files changed, 9 insertions(+), 19 deletions(-)

diff --git a/tools/build/Makefile.feature b/tools/build/Makefile.feature
index e7818b44b48ee..6e5c907680b1a 100644
--- a/tools/build/Makefile.feature
+++ b/tools/build/Makefile.feature
@@ -38,8 +38,6 @@ FEATURE_TESTS_BASIC :=                  \
         get_current_dir_name            \
         gettid				\
         glibc                           \
-        gtk2                            \
-        gtk2-infobar                    \
         libbfd                          \
         libcap                          \
         libelf                          \
@@ -81,6 +79,8 @@ FEATURE_TESTS_EXTRA :=                  \
          compile-32                     \
          compile-x32                    \
          cplus-demangle                 \
+         gtk2                           \
+         gtk2-infobar                   \
          hello                          \
          libbabeltrace                  \
          libbfd-liberty                 \
@@ -110,7 +110,6 @@ FEATURE_DISPLAY ?=              \
          dwarf                  \
          dwarf_getlocations     \
          glibc                  \
-         gtk2                   \
          libbfd                 \
          libcap                 \
          libelf                 \
diff --git a/tools/build/feature/Makefile b/tools/build/feature/Makefile
index 93b590d81209c..1796a09365f5d 100644
--- a/tools/build/feature/Makefile
+++ b/tools/build/feature/Makefile
@@ -89,7 +89,7 @@ __BUILDXX = $(CXX) $(CXXFLAGS) -MD -Wall -Werror -o $@ $(patsubst %.bin,%.cpp,$(
 ###############################
 
 $(OUTPUT)test-all.bin:
-	$(BUILD) -fstack-protector-all -O2 -D_FORTIFY_SOURCE=2 -ldw -lelf -lnuma -lelf -I/usr/include/slang -lslang $(shell $(PKG_CONFIG) --libs --cflags gtk+-2.0 2>/dev/null) $(FLAGS_PERL_EMBED) $(FLAGS_PYTHON_EMBED) -DPACKAGE='"perf"' -lbfd -ldl -lz -llzma
+	$(BUILD) -fstack-protector-all -O2 -D_FORTIFY_SOURCE=2 -ldw -lelf -lnuma -lelf -I/usr/include/slang -lslang $(FLAGS_PERL_EMBED) $(FLAGS_PYTHON_EMBED) -DPACKAGE='"perf"' -lbfd -ldl -lz -llzma
 
 $(OUTPUT)test-hello.bin:
 	$(BUILD)
diff --git a/tools/build/feature/test-all.c b/tools/build/feature/test-all.c
index 5479e543b1947..d2623992ccd61 100644
--- a/tools/build/feature/test-all.c
+++ b/tools/build/feature/test-all.c
@@ -78,14 +78,6 @@
 # include "test-libslang.c"
 #undef main
 
-#define main main_test_gtk2
-# include "test-gtk2.c"
-#undef main
-
-#define main main_test_gtk2_infobar
-# include "test-gtk2-infobar.c"
-#undef main
-
 #define main main_test_libbfd
 # include "test-libbfd.c"
 #undef main
@@ -205,8 +197,6 @@ int main(int argc, char *argv[])
 	main_test_libelf_getshdrstrndx();
 	main_test_libunwind();
 	main_test_libslang();
-	main_test_gtk2(argc, argv);
-	main_test_gtk2_infobar(argc, argv);
 	main_test_libbfd();
 	main_test_backtrace();
 	main_test_libnuma();
diff --git a/tools/perf/Makefile.config b/tools/perf/Makefile.config
index 513633809c81e..ab6dbd8ef6cf6 100644
--- a/tools/perf/Makefile.config
+++ b/tools/perf/Makefile.config
@@ -716,12 +716,14 @@ ifndef NO_SLANG
   endif
 endif
 
-ifndef NO_GTK2
+ifdef GTK2
   FLAGS_GTK2=$(CFLAGS) $(LDFLAGS) $(EXTLIBS) $(shell $(PKG_CONFIG) --libs --cflags gtk+-2.0 2>/dev/null)
+  $(call feature_check,gtk2)
   ifneq ($(feature-gtk2), 1)
     msg := $(warning GTK2 not found, disables GTK2 support. Please install gtk2-devel or libgtk2.0-dev);
     NO_GTK2 := 1
   else
+    $(call feature_check,gtk2-infobar)
     ifeq ($(feature-gtk2-infobar), 1)
       GTK_CFLAGS := -DHAVE_GTK_INFO_BAR_SUPPORT
     endif
diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 86dbb51bb2723..bc45b1a61d3a3 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -48,7 +48,7 @@ include ../scripts/utilities.mak
 #
 # Define NO_SLANG if you do not want TUI support.
 #
-# Define NO_GTK2 if you do not want GTK+ GUI support.
+# Define GTK2 if you want GTK+ GUI support.
 #
 # Define NO_DEMANGLE if you do not want C++ symbol demangling.
 #
@@ -384,7 +384,7 @@ ifneq ($(OUTPUT),)
   CFLAGS += -I$(OUTPUT)
 endif
 
-ifndef NO_GTK2
+ifdef GTK2
   ALL_PROGRAMS += $(OUTPUT)libperf-gtk.so
   GTK_IN := $(OUTPUT)gtk-in.o
 endif
@@ -876,7 +876,7 @@ check: $(OUTPUT)common-cmds.h
 
 ### Installation rules
 
-ifndef NO_GTK2
+ifdef GTK2
 install-gtk: $(OUTPUT)libperf-gtk.so
 	$(call QUIET_INSTALL, 'GTK UI') \
 		$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(libdir_SQ)'; \
diff --git a/tools/perf/builtin-version.c b/tools/perf/builtin-version.c
index 05cf2af9e2c27..d09ec2f030719 100644
--- a/tools/perf/builtin-version.c
+++ b/tools/perf/builtin-version.c
@@ -60,7 +60,6 @@ static void library_status(void)
 	STATUS(HAVE_DWARF_SUPPORT, dwarf);
 	STATUS(HAVE_DWARF_GETLOCATIONS_SUPPORT, dwarf_getlocations);
 	STATUS(HAVE_GLIBC_SUPPORT, glibc);
-	STATUS(HAVE_GTK2_SUPPORT, gtk2);
 #ifndef HAVE_SYSCALL_TABLE_SUPPORT
 	STATUS(HAVE_LIBAUDIT_SUPPORT, libaudit);
 #endif
-- 
2.25.1



