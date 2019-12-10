Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A9851199E8
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:52:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728022AbfLJVJI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:09:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:57222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728055AbfLJVJI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:09:08 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A698C24696;
        Tue, 10 Dec 2019 21:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012147;
        bh=ol+EarreBhyZtxBr+VuPmi+iFX92Onp+b36KDhJ24Tg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dCjrWbufrrj9oNIjmk0g6d0934xDMglm0GzFKTyi0/utpQGFSjCb9pXYZRQ8bb1mz
         dlA581Ox20UOFTFND9VQCW7yP32CkuiKjoteV/l2EFAMX0+wH0YTvtkH4yK1N/tnSP
         7NK7sfxnbWG+NAW0lC1lNoDJVpE6iYpmLvSoxgRM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Leo Yan <leo.yan@linaro.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 111/350] perf test: Avoid infinite loop for task exit case
Date:   Tue, 10 Dec 2019 16:03:36 -0500
Message-Id: <20191210210735.9077-72-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index ca0a6ca43b132..d85c9f608564c 100644
--- a/tools/perf/tests/task-exit.c
+++ b/tools/perf/tests/task-exit.c
@@ -53,6 +53,7 @@ int test__task_exit(struct test *test __maybe_unused, int subtest __maybe_unused
 	struct perf_cpu_map *cpus;
 	struct perf_thread_map *threads;
 	struct mmap *md;
+	int retry_count = 0;
 
 	signal(SIGCHLD, sig_handler);
 
@@ -132,6 +133,13 @@ int test__task_exit(struct test *test __maybe_unused, int subtest __maybe_unused
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

