Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC7DA373A1A
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 14:07:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233471AbhEEMHa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 08:07:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:47264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233473AbhEEMHM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 08:07:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B73F861176;
        Wed,  5 May 2021 12:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620216376;
        bh=6etONi36FQqglhp+rmX4XQZFYwrLi+rQGeMFsiS16n4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yp6qYrlso5tf7RO1xtCc6PFahxjVjEeZtq3B/+d6y2IqHu0UHBCCvP3083bgCSCSK
         aEbAcBQ9gl1Mmr1AYRugCPR7c5eDYImSdHllbPic/kaR445c/rg8LBdrvFn62B/xcf
         1CvxYan3whiGVbnSbDviOzR6kGVaFlzDUY68/GyM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Schmidt <alexschm@de.ibm.com>,
        Thomas Richter <tmricht@linux.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sumanth Korikkar <sumanthk@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 10/29] perf ftrace: Fix access to pid in array when setting a pid filter
Date:   Wed,  5 May 2021 14:05:13 +0200
Message-Id: <20210505112326.539842162@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210505112326.195493232@linuxfoundation.org>
References: <20210505112326.195493232@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



