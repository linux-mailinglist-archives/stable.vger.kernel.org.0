Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C12B336D638
	for <lists+stable@lfdr.de>; Wed, 28 Apr 2021 13:13:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239250AbhD1LMp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Apr 2021 07:12:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:45356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239678AbhD1LMk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Apr 2021 07:12:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D754161435;
        Wed, 28 Apr 2021 11:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619608315;
        bh=NU8pi9tWxbyoTgtDphp6v9veLbNPSyG4BwdgHUO8NeI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CajFFDBRy9oqUm8pTkyA7i8dwMOVLaeOjM/phM4YEZyX8q7i4Sxqu5yp7ED3PE0qO
         fIdW54/fc4Itm4ryM8NAN6o8LLkgs/wZMH+7w1cml65BdXQTTNZuQ6BXDKnuM6Y9QY
         H7R10i2WXqEnbMdgoTfuVAjAF5CQfCAYiMc9ru7Ezhnod7WV72tw9jejIKIdHtlsru
         1Qbt+PqZC9za6W4CBce2CcK7GSKQESEY7O1OGKlCAZge8Oq+pjU+r4geQlZ/Da64so
         7neHrEpsE+76i9EmT4nmaJiMmRC0+Q2c7vuNjoKTq3hnQ54B4jF55eWIs3ERobk0Lw
         8YwnBssrYYmhA==
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
Subject: [PATCH AUTOSEL 5.4 2/2] perf ftrace: Fix access to pid in array when setting a pid filter
Date:   Wed, 28 Apr 2021 07:11:50 -0400
Message-Id: <20210428111150.1343388-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210428111150.1343388-1-sashal@kernel.org>
References: <20210428111150.1343388-1-sashal@kernel.org>
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
index d5adc417a4ca..40b179f54428 100644
--- a/tools/perf/builtin-ftrace.c
+++ b/tools/perf/builtin-ftrace.c
@@ -161,7 +161,7 @@ static int set_tracing_pid(struct perf_ftrace *ftrace)
 
 	for (i = 0; i < perf_thread_map__nr(ftrace->evlist->core.threads); i++) {
 		scnprintf(buf, sizeof(buf), "%d",
-			  ftrace->evlist->core.threads->map[i]);
+			  perf_thread_map__pid(ftrace->evlist->core.threads, i));
 		if (append_tracing_file("set_ftrace_pid", buf) < 0)
 			return -1;
 	}
-- 
2.30.2

