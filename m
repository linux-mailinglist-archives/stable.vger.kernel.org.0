Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0621426F26C
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:59:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727265AbgIRC6z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:58:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:55092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727699AbgIRCGE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:06:04 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5FA342389E;
        Fri, 18 Sep 2020 02:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394763;
        bh=dre4NXCynnFaoBq1haLtq3U9LcZuowiLHESGSCjxQXk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mCv2uBGODrMsOrcWg36Ea43Dr7j9VDQhScwQcEo/4ysaNN8vs9xUi4hGtUD9clMqf
         Fz2hlypy4gjIqynRkCb3zxUUrorHtS7oRDQowqKCcPThXiRI/e6EKS8OUNCIkcSb7H
         XY4Oqg4xz7tOb1qZ1IN5peUeMDWkIk5FzhIBli2k=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stephane Eranian <eranian@google.com>,
        Ian Rogers <irogers@google.com>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 239/330] perf stat: Force error in fallback on :k events
Date:   Thu, 17 Sep 2020 21:59:39 -0400
Message-Id: <20200918020110.2063155-239-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephane Eranian <eranian@google.com>

[ Upstream commit bec49a9e05db3dbdca696fa07c62c52638fb6371 ]

When it is not possible for a non-privilege perf command to monitor at
the kernel level (:k), the fallback code forces a :u. That works if the
event was previously monitoring both levels.  But if the event was
already constrained to kernel only, then it does not make sense to
restrict it to user only.

Given the code works by exclusion, a kernel only event would have:

  attr->exclude_user = 1

The fallback code would add:

  attr->exclude_kernel = 1

In the end the end would not monitor in either the user level or kernel
level. In other words, it would count nothing.

An event programmed to monitor kernel only cannot be switched to user
only without seriously warning the user.

This patch forces an error in this case to make it clear the request
cannot really be satisfied.

Behavior with paranoid 1:

  $ sudo bash -c "echo 1 > /proc/sys/kernel/perf_event_paranoid"
  $ perf stat -e cycles:k sleep 1

   Performance counter stats for 'sleep 1':

           1,520,413      cycles:k

         1.002361664 seconds time elapsed

         0.002480000 seconds user
         0.000000000 seconds sys

Old behavior with paranoid 2:

  $ sudo bash -c "echo 2 > /proc/sys/kernel/perf_event_paranoid"
  $ perf stat -e cycles:k sleep 1
   Performance counter stats for 'sleep 1':

                   0      cycles:ku

         1.002358127 seconds time elapsed

         0.002384000 seconds user
         0.000000000 seconds sys

New behavior with paranoid 2:

  $ sudo bash -c "echo 2 > /proc/sys/kernel/perf_event_paranoid"
  $ perf stat -e cycles:k sleep 1
  Error:
  You may not have permission to collect stats.

  Consider tweaking /proc/sys/kernel/perf_event_paranoid,
  which controls use of the performance events system by
  unprivileged users (without CAP_PERFMON or CAP_SYS_ADMIN).

  The current value is 2:

    -1: Allow use of (almost) all events by all users
        Ignore mlock limit after perf_event_mlock_kb without CAP_IPC_LOCK
  >= 0: Disallow ftrace function tracepoint by users without CAP_PERFMON or CAP_SYS_ADMIN
        Disallow raw tracepoint access by users without CAP_SYS_PERFMON or CAP_SYS_ADMIN
  >= 1: Disallow CPU event access by users without CAP_PERFMON or CAP_SYS_ADMIN
  >= 2: Disallow kernel profiling by users without CAP_PERFMON or CAP_SYS_ADMIN

  To make this setting permanent, edit /etc/sysctl.conf too, e.g.:

          kernel.perf_event_paranoid = -1

v2 of this patch addresses the review feedback from jolsa@redhat.com.

Signed-off-by: Stephane Eranian <eranian@google.com>
Reviewed-by: Ian Rogers <irogers@google.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lore.kernel.org/lkml/20200414161550.225588-1-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/evsel.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index dfc982baecab4..12b1755b136d3 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -2358,6 +2358,10 @@ bool perf_evsel__fallback(struct evsel *evsel, int err,
 		char *new_name;
 		const char *sep = ":";
 
+		/* If event has exclude user then don't exclude kernel. */
+		if (evsel->core.attr.exclude_user)
+			return false;
+
 		/* Is there already the separator in the name. */
 		if (strchr(name, '/') ||
 		    strchr(name, ':'))
-- 
2.25.1

