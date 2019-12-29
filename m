Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B392212C699
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:54:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730832AbfL2Rso (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:48:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:60210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729297AbfL2Rsn (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:48:43 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C6B3207FD;
        Sun, 29 Dec 2019 17:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641723;
        bh=r9HNGkrrcvcIgewxqzftcT+iHS7Y814AmtaQcyc85as=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qmenAAszLEMlAjlLR2W+LYlnBMoLwIu9eE0uwUa3vhvp6UUtMAik5r+9vjcMmzMjy
         WMpxRmgDoAZemHVy7LTyiV+gURbzAdj7BhJn7ZFNv9d7ulHTEhAjicLyPKsqRZhDDh
         fwoSm1vWTYN6xdUNEI9rlXYg73hvjf6IG3hSry/Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leo Yan <leo.yan@linaro.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 147/434] perf test: Avoid infinite loop for task exit case
Date:   Sun, 29 Dec 2019 18:23:20 +0100
Message-Id: <20191229172711.515478736@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leo Yan <leo.yan@linaro.org>

[ Upstream commit 791ce9c48c79210d2ffcdbe69421e7783b32921f ]

When executing the task exit testing case, perf gets stuck in an endless
loop this case and doesn't return back on Arm64 Juno board.

After digging into this issue, since Juno board has Arm's big.LITTLE
CPUs, thus the PMUs are not compatible between the big CPUs and little
CPUs.  This leads to a PMU event that cannot be enabled properly when
the traced task is migrated from one variant's CPU to another variant.
Finally, the test case runs into infinite loop for cannot read out any
event data after return from polling.

Eventually, we need to work out formal solution to allow PMU events can
be freely migrated from one CPU variant to another, but this is a
difficult task and a different topic.  This patch tries to fix the Perf
test case to avoid infinite loop, when the testing detects 1000 times
retrying for reading empty events, it will directly bail out and return
failure.  This allows the Perf tool can continue its other test cases.

Signed-off-by: Leo Yan <leo.yan@linaro.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lore.kernel.org/lkml/20191011091942.29841-2-leo.yan@linaro.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/task-exit.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tools/perf/tests/task-exit.c b/tools/perf/tests/task-exit.c
index ca0a6ca43b13..d85c9f608564 100644
--- a/tools/perf/tests/task-exit.c
+++ b/tools/perf/tests/task-exit.c
@@ -53,6 +53,7 @@ int test__task_exit(struct test *test __maybe_unused, int subtest __maybe_unused
 	struct perf_cpu_map *cpus;
 	struct perf_thread_map *threads;
 	struct mmap *md;
+	int retry_count = 0;
 
 	signal(SIGCHLD, sig_handler);
 
@@ -132,6 +133,13 @@ retry:
 out_init:
 	if (!exited || !nr_exit) {
 		evlist__poll(evlist, -1);
+
+		if (retry_count++ > 1000) {
+			pr_debug("Failed after retrying 1000 times\n");
+			err = -1;
+			goto out_free_maps;
+		}
+
 		goto retry;
 	}
 
-- 
2.20.1



