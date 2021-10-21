Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29AB2435712
	for <lists+stable@lfdr.de>; Thu, 21 Oct 2021 02:22:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232046AbhJUAYU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Oct 2021 20:24:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:42742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231657AbhJUAYA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 Oct 2021 20:24:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 439676128E;
        Thu, 21 Oct 2021 00:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634775705;
        bh=m3sAFKsl04frEcNvAT8NnlptnPwULFmfs6QJVsGkHvo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l/BLO7zL4izIN50iJcnqRq9fZ6cFP+mCVVvRJGfSdfTFIBBFcCny7vVvlqOLG+MW5
         TEpXVLV402JCjlUn/rRKPleaqzZuVXl1gUA/psYijw8Gh5iS27ouL8I45io5lpnpfP
         tRM11Rf+KlZ/wVsdptxDrWO2deVjaFSg62Zmt6/HPZ/fueCPW1F8Qz9XOSvBGr7eeX
         nNbsW4GG142jXwBS2kCoIrnNypoYP3eR16yZtAwWSUlhApL8UXrh/dIVPdKTc8ym0x
         LLaPJd8iSo1sw9ANwAf9yD+dgn7xXDRkgiALT4SrzojNdHS9Vg+jfE3q4mGdN/Ca21
         ek6q1LL0cDa9A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shunsuke Nakamura <nakamura.shun@fujitsu.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>, mingo@redhat.com,
        acme@kernel.org, irogers@google.com, robh@kernel.org,
        linux-perf-users@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 23/26] libperf tests: Fix test_stat_cpu
Date:   Wed, 20 Oct 2021 20:20:20 -0400
Message-Id: <20211021002023.1128949-23-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211021002023.1128949-1-sashal@kernel.org>
References: <20211021002023.1128949-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shunsuke Nakamura <nakamura.shun@fujitsu.com>

[ Upstream commit 3ff6d64e68abc231955d216236615918797614ae ]

The `cpu` argument of perf_evsel__read() must specify the cpu index.

perf_cpu_map__for_each_cpu() is for iterating the cpu number (not index)
and is thus not appropriate for use with perf_evsel__read().

So, if there is an offline CPU, the cpu number specified in the argument
may point out of range because the cpu number and the cpu index are
different.

Fix test_stat_cpu().

Testing it:

  # make tests -C tools/lib/perf/
  make: Entering directory '/home/nakamura/kernel_src/linux-5.15-rc4_fix/tools/lib/perf'
  running static:
  - running tests/test-cpumap.c...OK
  - running tests/test-threadmap.c...OK
  - running tests/test-evlist.c...OK
  - running tests/test-evsel.c...OK
  running dynamic:
  - running tests/test-cpumap.c...OK
  - running tests/test-threadmap.c...OK
  - running tests/test-evlist.c...OK
  - running tests/test-evsel.c...OK
  make: Leaving directory '/home/nakamura/kernel_src/linux-5.15-rc4_fix/tools/lib/perf'

Signed-off-by: Shunsuke Nakamura <nakamura.shun@fujitsu.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lore.kernel.org/lkml/20211011083704.4108720-1-nakamura.shun@fujitsu.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/perf/tests/test-evlist.c | 6 +++---
 tools/lib/perf/tests/test-evsel.c  | 6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/lib/perf/tests/test-evlist.c b/tools/lib/perf/tests/test-evlist.c
index c67c83399170..ce91a582f0e4 100644
--- a/tools/lib/perf/tests/test-evlist.c
+++ b/tools/lib/perf/tests/test-evlist.c
@@ -40,7 +40,7 @@ static int test_stat_cpu(void)
 		.type	= PERF_TYPE_SOFTWARE,
 		.config	= PERF_COUNT_SW_TASK_CLOCK,
 	};
-	int err, cpu, tmp;
+	int err, idx;
 
 	cpus = perf_cpu_map__new(NULL);
 	__T("failed to create cpus", cpus);
@@ -70,10 +70,10 @@ static int test_stat_cpu(void)
 	perf_evlist__for_each_evsel(evlist, evsel) {
 		cpus = perf_evsel__cpus(evsel);
 
-		perf_cpu_map__for_each_cpu(cpu, tmp, cpus) {
+		for (idx = 0; idx < perf_cpu_map__nr(cpus); idx++) {
 			struct perf_counts_values counts = { .val = 0 };
 
-			perf_evsel__read(evsel, cpu, 0, &counts);
+			perf_evsel__read(evsel, idx, 0, &counts);
 			__T("failed to read value for evsel", counts.val != 0);
 		}
 	}
diff --git a/tools/lib/perf/tests/test-evsel.c b/tools/lib/perf/tests/test-evsel.c
index 9abd4c0bf6db..33ae9334861a 100644
--- a/tools/lib/perf/tests/test-evsel.c
+++ b/tools/lib/perf/tests/test-evsel.c
@@ -22,7 +22,7 @@ static int test_stat_cpu(void)
 		.type	= PERF_TYPE_SOFTWARE,
 		.config	= PERF_COUNT_SW_CPU_CLOCK,
 	};
-	int err, cpu, tmp;
+	int err, idx;
 
 	cpus = perf_cpu_map__new(NULL);
 	__T("failed to create cpus", cpus);
@@ -33,10 +33,10 @@ static int test_stat_cpu(void)
 	err = perf_evsel__open(evsel, cpus, NULL);
 	__T("failed to open evsel", err == 0);
 
-	perf_cpu_map__for_each_cpu(cpu, tmp, cpus) {
+	for (idx = 0; idx < perf_cpu_map__nr(cpus); idx++) {
 		struct perf_counts_values counts = { .val = 0 };
 
-		perf_evsel__read(evsel, cpu, 0, &counts);
+		perf_evsel__read(evsel, idx, 0, &counts);
 		__T("failed to read value for evsel", counts.val != 0);
 	}
 
-- 
2.33.0

