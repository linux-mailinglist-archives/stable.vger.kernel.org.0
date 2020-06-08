Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 322AD1F3146
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 03:08:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730538AbgFIBHl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 21:07:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:50306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727083AbgFHXGv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:06:51 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD9AA20899;
        Mon,  8 Jun 2020 23:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657611;
        bh=hqTYac1zqlyJDPaAEG6Fyc+y1JupKz26eb4ITX31SLM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qL9QQlEmfv3vOL6mvxYvJqjXNwS46nVaOleZoUjHY55hUI1gJjGELrOFs/UPHKglK
         B+uK3qIblBN0GBKVwegKjKI0DvKgtFUdj3L6vAg5Z6ksQeR+lx+sWdiCOvXY3VXepN
         Spq/Ze2tIPiRnOMGvrQDhtPBLVeNA0jZhLtkpLjo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ian Rogers <irogers@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>, Jiri Olsa <jolsa@redhat.com>,
        Leo Yan <leo.yan@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        clang-built-linux@googlegroups.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.7 034/274] libperf evlist: Fix a refcount leak
Date:   Mon,  8 Jun 2020 19:02:07 -0400
Message-Id: <20200608230607.3361041-34-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608230607.3361041-1-sashal@kernel.org>
References: <20200608230607.3361041-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ian Rogers <irogers@google.com>

[ Upstream commit 4599d292128d89e4cf866a0ea9a9b047a2de8418 ]

Memory leaks found by applying LLVM's libfuzzer on the tools/perf
parse_events function.

Signed-off-by: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Leo Yan <leo.yan@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: clang-built-linux@googlegroups.com
Link: http://lore.kernel.org/lkml/20200319023101.82458-2-irogers@google.com
[ Did a minor adjustment due to some other previous patch having already set evlist->all_cpus to NULL at perf_evlist__exit() ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/perf/evlist.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/lib/perf/evlist.c b/tools/lib/perf/evlist.c
index 5b9f2ca50591..62130d28652d 100644
--- a/tools/lib/perf/evlist.c
+++ b/tools/lib/perf/evlist.c
@@ -125,6 +125,7 @@ static void perf_evlist__purge(struct perf_evlist *evlist)
 void perf_evlist__exit(struct perf_evlist *evlist)
 {
 	perf_cpu_map__put(evlist->cpus);
+	perf_cpu_map__put(evlist->all_cpus);
 	perf_thread_map__put(evlist->threads);
 	evlist->cpus = NULL;
 	evlist->threads = NULL;
-- 
2.25.1

