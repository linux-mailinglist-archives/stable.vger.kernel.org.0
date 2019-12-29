Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44AF412C506
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:40:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728754AbfL2RdC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:33:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:34124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727452AbfL2RdA (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:33:00 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D7EC720409;
        Sun, 29 Dec 2019 17:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577640779;
        bh=1u3chDRibC6IUIfpSJQ4eqliyQuIjrD7HqX5Hcdi72M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KNFEQ92hjCedqTqm3uwnvEwrGCJfMfLfFHhohtvgLZxAZRqIvBEPmbqQsOeMKmfUD
         vOBbMDy/AzHcMseD6TLntRVUdB/8qZ3OVGw4saustjDOypzS+7IT3gKU9kmrIepOk2
         POa0lqk7YsmjFiOqTL9CRN9y78oZODBGfqDclA58=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leo Yan <leo.yan@linaro.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Brajeswar Ghosh <brajeswar.linux@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Michael Petlan <mpetlan@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Song Liu <songliubraving@fb.com>,
        Souptick Joarder <jrdr.linux@gmail.com>,
        Will Deacon <will@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 086/219] perf tests: Disable bp_signal testing for arm64
Date:   Sun, 29 Dec 2019 18:18:08 +0100
Message-Id: <20191229162518.590431950@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229162508.458551679@linuxfoundation.org>
References: <20191229162508.458551679@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leo Yan <leo.yan@linaro.org>

[ Upstream commit 6a5f3d94cb69a185b921cb92c39888dc31009acb ]

As there are several discussions for enabling perf breakpoint signal
testing on arm64 platform: arm64 needs to rely on single-step to execute
the breakpointed instruction and then reinstall the breakpoint exception
handler.  But if we hook the breakpoint with a signal, the signal
handler will do the stepping rather than the breakpointed instruction,
this causes infinite loops as below:

         Kernel space              |            Userspace
  ---------------------------------|--------------------------------
                                   |  __test_function() -> hit
				   |                       breakpoint
  breakpoint_handler()             |
    `-> user_enable_single_step()  |
  do_signal()                      |
                                   |  sig_handler() -> Step one
				   |                instruction and
				   |                trap to kernel
  single_step_handler()            |
    `-> reinstall_suspended_bps()  |
                                   |  __test_function() -> hit
				   |     breakpoint again and
				   |     repeat up flow infinitely

As Will Deacon mentioned [1]: "that we require the overflow handler to
do the stepping on arm/arm64, which is relied upon by GDB/ptrace. The
hw_breakpoint code is a complete disaster so my preference would be to
rip out the perf part and just implement something directly in ptrace,
but it's a pretty horrible job".  Though Will commented this on arm
architecture, but the comment also can apply on arm64 architecture.

For complete information, I searched online and found a few years back,
Wang Nan sent one patch 'arm64: Store breakpoint single step state into
pstate' [2]; the patch tried to resolve this issue by avoiding single
stepping in signal handler and defer to enable the signal stepping when
return to __test_function().  The fixing was not merged due to the
concern for missing to handle different usage cases.

Based on the info, the most feasible way is to skip Perf breakpoint
signal testing for arm64 and this could avoid the duplicate
investigation efforts when people see the failure.  This patch skips
this case on arm64 platform, which is same with arm architecture.

[1] https://lkml.org/lkml/2018/11/15/205
[2] https://lkml.org/lkml/2015/12/23/477

Signed-off-by: Leo Yan <leo.yan@linaro.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Brajeswar Ghosh <brajeswar.linux@gmail.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Michael Petlan <mpetlan@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Song Liu <songliubraving@fb.com>
Cc: Souptick Joarder <jrdr.linux@gmail.com>
Cc: Will Deacon <will@kernel.org>
Link: http://lore.kernel.org/lkml/20191018085531.6348-3-leo.yan@linaro.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/bp_signal.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/tools/perf/tests/bp_signal.c b/tools/perf/tests/bp_signal.c
index 910e25e64188..6cf00650602e 100644
--- a/tools/perf/tests/bp_signal.c
+++ b/tools/perf/tests/bp_signal.c
@@ -48,14 +48,6 @@ asm (
 	"__test_function:\n"
 	"incq (%rdi)\n"
 	"ret\n");
-#elif defined (__aarch64__)
-extern void __test_function(volatile long *ptr);
-asm (
-	".globl __test_function\n"
-	"__test_function:\n"
-	"str x30, [x0]\n"
-	"ret\n");
-
 #else
 static void __test_function(volatile long *ptr)
 {
@@ -301,10 +293,15 @@ bool test__bp_signal_is_supported(void)
 	 * stepping into the SIGIO handler and getting stuck on the
 	 * breakpointed instruction.
 	 *
+	 * Since arm64 has the same issue with arm for the single-step
+	 * handling, this case also gets suck on the breakpointed
+	 * instruction.
+	 *
 	 * Just disable the test for these architectures until these
 	 * issues are resolved.
 	 */
-#if defined(__powerpc__) || defined(__s390x__) || defined(__arm__)
+#if defined(__powerpc__) || defined(__s390x__) || defined(__arm__) || \
+    defined(__aarch64__)
 	return false;
 #else
 	return true;
-- 
2.20.1



