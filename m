Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CED1F420F5C
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237170AbhJDNeA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:34:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:43756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237639AbhJDNc3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:32:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7F6D61BA0;
        Mon,  4 Oct 2021 13:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353279;
        bh=ap0g6NF3rpaBSS/SVuRhMs15u8lIqxKDNNUs00IC4uo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GLmUC2GWMsLyT5F+dzGWY11ryIWi/X8ww4RJhAGdXuBU6vMVkTT2ymVigOHZVThaA
         Cq2vGn1zy1Qc9nV0H5iJ1lxC0bAuyN7nKTtoEI98VWv4NzslKqWpGPHj7gdIeZXPdj
         R4QzM6cMXd0hEtqb+ROBmAE4lhMvYBuClec/5qN8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ian Rogers <irogers@google.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Miguel Ojeda <ojeda@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        clang-built-linux@googlegroups.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 023/172] perf test: Fix DWARF unwind for optimized builds.
Date:   Mon,  4 Oct 2021 14:51:13 +0200
Message-Id: <20211004125045.713703969@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ian Rogers <irogers@google.com>

[ Upstream commit 5c34aea341b16e29fde6e6c8d4b18866cd99754d ]

To ensure the stack frames are on the stack tail calls optimizations
need to be inhibited. If your compiler supports an attribute use it,
otherwise use an asm volatile barrier.

The barrier fix was suggested here:
https://lore.kernel.org/lkml/20201028081123.GT2628@hirez.programming.kicks-ass.net/
Tested with an optimized clang build and by forcing the asm barrier
route with an optimized clang build.

A GCC bug tracking a proper disable_tail_calls is:
https://gcc.gnu.org/bugzilla/show_bug.cgi?id=97831

Fixes: 9ae1e990f1ab ("perf tools: Remove broken __no_tail_call
       attribute")

v2. is a rebase. The original fix patch generated quite a lot of
    discussion over the right place for the fix:
    https://lore.kernel.org/lkml/20201114000803.909530-1-irogers@google.com/
    The patch reflects my preference of it being near the use, so that
    future code cleanups don't break this somewhat special usage.

Signed-off-by: Ian Rogers <irogers@google.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: clang-built-linux@googlegroups.com
Link: http://lore.kernel.org/lkml/20210922173812.456348-1-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/dwarf-unwind.c | 39 +++++++++++++++++++++++++++------
 1 file changed, 32 insertions(+), 7 deletions(-)

diff --git a/tools/perf/tests/dwarf-unwind.c b/tools/perf/tests/dwarf-unwind.c
index a288035eb362..c756284b3b13 100644
--- a/tools/perf/tests/dwarf-unwind.c
+++ b/tools/perf/tests/dwarf-unwind.c
@@ -20,6 +20,23 @@
 /* For bsearch. We try to unwind functions in shared object. */
 #include <stdlib.h>
 
+/*
+ * The test will assert frames are on the stack but tail call optimizations lose
+ * the frame of the caller. Clang can disable this optimization on a called
+ * function but GCC currently (11/2020) lacks this attribute. The barrier is
+ * used to inhibit tail calls in these cases.
+ */
+#ifdef __has_attribute
+#if __has_attribute(disable_tail_calls)
+#define NO_TAIL_CALL_ATTRIBUTE __attribute__((disable_tail_calls))
+#define NO_TAIL_CALL_BARRIER
+#endif
+#endif
+#ifndef NO_TAIL_CALL_ATTRIBUTE
+#define NO_TAIL_CALL_ATTRIBUTE
+#define NO_TAIL_CALL_BARRIER __asm__ __volatile__("" : : : "memory");
+#endif
+
 static int mmap_handler(struct perf_tool *tool __maybe_unused,
 			union perf_event *event,
 			struct perf_sample *sample,
@@ -91,7 +108,7 @@ static int unwind_entry(struct unwind_entry *entry, void *arg)
 	return strcmp((const char *) symbol, funcs[idx]);
 }
 
-noinline int test_dwarf_unwind__thread(struct thread *thread)
+NO_TAIL_CALL_ATTRIBUTE noinline int test_dwarf_unwind__thread(struct thread *thread)
 {
 	struct perf_sample sample;
 	unsigned long cnt = 0;
@@ -122,7 +139,7 @@ noinline int test_dwarf_unwind__thread(struct thread *thread)
 
 static int global_unwind_retval = -INT_MAX;
 
-noinline int test_dwarf_unwind__compare(void *p1, void *p2)
+NO_TAIL_CALL_ATTRIBUTE noinline int test_dwarf_unwind__compare(void *p1, void *p2)
 {
 	/* Any possible value should be 'thread' */
 	struct thread *thread = *(struct thread **)p1;
@@ -141,7 +158,7 @@ noinline int test_dwarf_unwind__compare(void *p1, void *p2)
 	return p1 - p2;
 }
 
-noinline int test_dwarf_unwind__krava_3(struct thread *thread)
+NO_TAIL_CALL_ATTRIBUTE noinline int test_dwarf_unwind__krava_3(struct thread *thread)
 {
 	struct thread *array[2] = {thread, thread};
 	void *fp = &bsearch;
@@ -160,14 +177,22 @@ noinline int test_dwarf_unwind__krava_3(struct thread *thread)
 	return global_unwind_retval;
 }
 
-noinline int test_dwarf_unwind__krava_2(struct thread *thread)
+NO_TAIL_CALL_ATTRIBUTE noinline int test_dwarf_unwind__krava_2(struct thread *thread)
 {
-	return test_dwarf_unwind__krava_3(thread);
+	int ret;
+
+	ret =  test_dwarf_unwind__krava_3(thread);
+	NO_TAIL_CALL_BARRIER;
+	return ret;
 }
 
-noinline int test_dwarf_unwind__krava_1(struct thread *thread)
+NO_TAIL_CALL_ATTRIBUTE noinline int test_dwarf_unwind__krava_1(struct thread *thread)
 {
-	return test_dwarf_unwind__krava_2(thread);
+	int ret;
+
+	ret =  test_dwarf_unwind__krava_2(thread);
+	NO_TAIL_CALL_BARRIER;
+	return ret;
 }
 
 int test__dwarf_unwind(struct test *test __maybe_unused, int subtest __maybe_unused)
-- 
2.33.0



