Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B66B627CB06
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:24:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730234AbgI2MYE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:24:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:48450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729763AbgI2LfJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:35:09 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D131B23BEF;
        Tue, 29 Sep 2020 11:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378890;
        bh=PlbMTgELfMRDsocIUTTiiLZI4p00Hr9pXfwZwKyCaNA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AhmpCqJZXF+2hyNIIAqf9r1x5Hcj2S/KHpaFfvMahaYGLdx8YH/reoyjN4XSQByf+
         RaVSJ2Gq01UQ+kh7fY+IcprAbJQk78V8y1uTv9Vlzxc9cUdsq46cDASrVRssK6mOYc
         jPnupdYXxmOti5TqDbqrobWvl62mwY8p2kwG+S6g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephane Eranian <eranian@google.com>,
        Ian Rogers <irogers@google.com>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 146/245] perf stat: Force error in fallback on :k events
Date:   Tue, 29 Sep 2020 12:59:57 +0200
Message-Id: <20200929105954.090876288@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105946.978650816@linuxfoundation.org>
References: <20200929105946.978650816@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 68c5ab0e1800b..e8586957562b3 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -2796,6 +2796,10 @@ bool perf_evsel__fallback(struct perf_evsel *evsel, int err,
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



