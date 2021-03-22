Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EF35344433
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 14:00:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231322AbhCVM7D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:59:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:47980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232435AbhCVMy4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:54:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4BE05619A0;
        Mon, 22 Mar 2021 12:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616417286;
        bh=BEEcaXs/jrg8b0rWGYhylpKKIrk9aUj45Ekfj4Y7sLk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kOeAYoq0Gct8aVS5LG6kQWa7es8sRHSyf6eMfy97oEfiM2Tra2EbYzD8Vxb8sDiKh
         ViOb/b2oLMnIgZUar3xQEnlOah+lsV/R9/HLjD9tFKi7OWIr9UvNnQARu7X73EhFOo
         C50ru2Zt/GQEGgQxwj0lvVr/1B+xOhXX/IJAj5rA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Jiri Olsa <jolsa@kernel.org>,
        Kim Phillips <kim.phillips@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Wang Nan <wangnan0@huawei.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.14 15/43] tools build feature: Check if pthread_barrier_t is available
Date:   Mon, 22 Mar 2021 13:28:56 +0100
Message-Id: <20210322121920.539265324@linuxfoundation.org>
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

commit 25ab5abf5b141d7fd13eed506c7458aa04749c29 upstream.

As 'perf bench futex wake-parallel" will use this, which is not
available in older systems such as versions of the android NDK used in
my container build tests (r12b and r15c at the moment).

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: James Yang <james.yang@arm.com
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kim Phillips <kim.phillips@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Wang Nan <wangnan0@huawei.com>
Link: https://lkml.kernel.org/n/tip-1i7iv54in4wj08lwo55b0pzv@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/build/Makefile.feature               |    1 +
 tools/build/feature/Makefile               |    4 ++++
 tools/build/feature/test-all.c             |    5 +++++
 tools/build/feature/test-pthread-barrier.c |   12 ++++++++++++
 tools/perf/Makefile.config                 |    4 ++++
 5 files changed, 26 insertions(+)
 create mode 100644 tools/build/feature/test-pthread-barrier.c

--- a/tools/build/Makefile.feature
+++ b/tools/build/Makefile.feature
@@ -59,6 +59,7 @@ FEATURE_TESTS_BASIC :=
         libunwind-arm                   \
         libunwind-aarch64               \
         pthread-attr-setaffinity-np     \
+        pthread-barrier     		\
         stackprotector-all              \
         timerfd                         \
         libdw-dwarf-unwind              \
--- a/tools/build/feature/Makefile
+++ b/tools/build/feature/Makefile
@@ -39,6 +39,7 @@ FILES=
          test-libunwind-debug-frame-arm.bin     \
          test-libunwind-debug-frame-aarch64.bin \
          test-pthread-attr-setaffinity-np.bin   \
+         test-pthread-barrier.bin		\
          test-stackprotector-all.bin            \
          test-timerfd.bin                       \
          test-libdw-dwarf-unwind.bin            \
@@ -80,6 +81,9 @@ $(OUTPUT)test-hello.bin:
 $(OUTPUT)test-pthread-attr-setaffinity-np.bin:
 	$(BUILD) -D_GNU_SOURCE -lpthread
 
+$(OUTPUT)test-pthread-barrier.bin:
+	$(BUILD) -lpthread
+
 $(OUTPUT)test-stackprotector-all.bin:
 	$(BUILD) -fstack-protector-all
 
--- a/tools/build/feature/test-all.c
+++ b/tools/build/feature/test-all.c
@@ -130,6 +130,10 @@
 # include "test-pthread-attr-setaffinity-np.c"
 #undef main
 
+#define main main_test_pthread_barrier
+# include "test-pthread-barrier.c"
+#undef main
+
 #define main main_test_sched_getcpu
 # include "test-sched_getcpu.c"
 #undef main
@@ -202,6 +206,7 @@ int main(int argc, char *argv[])
 	main_test_sync_compare_and_swap(argc, argv);
 	main_test_zlib();
 	main_test_pthread_attr_setaffinity_np();
+	main_test_pthread_barrier();
 	main_test_lzma();
 	main_test_get_cpuid();
 	main_test_bpf();
--- /dev/null
+++ b/tools/build/feature/test-pthread-barrier.c
@@ -0,0 +1,12 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <stdint.h>
+#include <pthread.h>
+
+int main(void)
+{
+	pthread_barrier_t barrier;
+
+	pthread_barrier_init(&barrier, NULL, 1);
+	pthread_barrier_wait(&barrier);
+	return pthread_barrier_destroy(&barrier);
+}
--- a/tools/perf/Makefile.config
+++ b/tools/perf/Makefile.config
@@ -272,6 +272,10 @@ ifeq ($(feature-pthread-attr-setaffinity
   CFLAGS += -DHAVE_PTHREAD_ATTR_SETAFFINITY_NP
 endif
 
+ifeq ($(feature-pthread-barrier), 1)
+  CFLAGS += -DHAVE_PTHREAD_BARRIER
+endif
+
 ifndef NO_BIONIC
   $(call feature_check,bionic)
   ifeq ($(feature-bionic), 1)


