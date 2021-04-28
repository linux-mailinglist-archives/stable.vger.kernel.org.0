Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3096936D631
	for <lists+stable@lfdr.de>; Wed, 28 Apr 2021 13:11:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239179AbhD1LMl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Apr 2021 07:12:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:44386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239657AbhD1LMe (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Apr 2021 07:12:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 000FD61430;
        Wed, 28 Apr 2021 11:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619608308;
        bh=6etONi36FQqglhp+rmX4XQZFYwrLi+rQGeMFsiS16n4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e0oUZSt9OdzgTZdJdgabWmOgsh9yFjy8ZUQKl0xw7KyeQoNuozV8ooW3jaY/l1SLY
         7q3Zobo6D1zl06AzAlHlxuHMG3XXT+0m5176YQKZNwCxB33KvL8lMo6W0YBhljXlvj
         4SmPelo2eUBGANugBQaqYXBh86HBJf7gcv32yHU8moHyPUf1G3nCzdVQO9Bcs/nLWb
         QuYqlXjsu5fe/NrRcd35L8m/2b3R5oUSmnwrX9e+q7kGhJnkXPo6KXcRmeeM7sr2wm
         yZh+Mh7CSPSD4rXaiEMM3NHf/d01+Dc4HB4wWkekvOj4UACty8od0Ea8UwFPI25Ih3
         B1Mihj6jKK3Pg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Richter <tmricht@linux.ibm.com>,
        Alexander Schmidt <alexschm@de.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sumanth Korikkar <sumanthk@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.10 3/4] perf ftrace: Fix access to pid in array when setting a pid filter
Date:   Wed, 28 Apr 2021 07:11:40 -0400
Message-Id: <20210428111141.1343299-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210428111141.1343299-1-sashal@kernel.org>
References: <20210428111141.1343299-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Richter <tmricht@linux.ibm.com>

[ Upstream commit 671b60cb6a897a5b3832fe57657152f2c3995e25 ]

Command 'perf ftrace -v -- ls' fails in s390 (at least 5.12.0rc6).

The root cause is a missing pointer dereference which causes an
array element address to be used as PID.

Fix this by extracting the PID.

Output before:
  # ./perf ftrace -v -- ls
  function_graph tracer is used
  write '-263732416' to tracing/set_ftrace_pid failed: Invalid argument
  failed to set ftrace pid
  #

Output after:
   ./perf ftrace -v -- ls
   function_graph tracer is used
   # tracer: function_graph
   #
   # CPU  DURATION                  FUNCTION CALLS
   # |     |   |                     |   |   |   |
   4)               |  rcu_read_lock_sched_held() {
   4)   0.552 us    |    rcu_lockdep_current_cpu_online();
   4)   6.124 us    |  }

Reported-by: Alexander Schmidt <alexschm@de.ibm.com>
Signed-off-by: Thomas Richter <tmricht@linux.ibm.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Sumanth Korikkar <sumanthk@linux.ibm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Link: http://lore.kernel.org/lkml/20210421120400.2126433-1-tmricht@linux.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-ftrace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-ftrace.c b/tools/perf/builtin-ftrace.c
index 9366fad591dc..eecc70fc3b19 100644
--- a/tools/perf/builtin-ftrace.c
+++ b/tools/perf/builtin-ftrace.c
@@ -289,7 +289,7 @@ static int set_tracing_pid(struct perf_ftrace *ftrace)
 
 	for (i = 0; i < perf_thread_map__nr(ftrace->evlist->core.threads); i++) {
 		scnprintf(buf, sizeof(buf), "%d",
-			  ftrace->evlist->core.threads->map[i]);
+			  perf_thread_map__pid(ftrace->evlist->core.threads, i));
 		if (append_tracing_file("set_ftrace_pid", buf) < 0)
 			return -1;
 	}
-- 
2.30.2

