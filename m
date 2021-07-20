Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FD433CF46B
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 08:21:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233384AbhGTFlD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Jul 2021 01:41:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:48820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236382AbhGTFk6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Jul 2021 01:40:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 045B361166;
        Tue, 20 Jul 2021 06:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626762097;
        bh=D1DiA/flibkBdagfjH6j4OC+Quu/P1hrcIKuVlD4jwo=;
        h=Subject:To:Cc:From:Date:From;
        b=OybXpPw1WW517PxQiOb64LyvkuH3EQcDsA6ezM1SxoFxNkWJJrVBw5VcowEUFzR4K
         zEhLmCR9FRyVUp/GLBw6gopYf5XIvMyaNk7JbgdSdhsHKBqana6x3xXD11NvtcLdHS
         xiMbfUJ2B5lkOC/q3L6Rwzqiny+WO07d07j2T0ek=
Subject: FAILED: patch "[PATCH] perf report: Fix --task and --stat with pipe input" failed to apply to 5.4-stable tree
To:     namhyung@kernel.org, acme@redhat.com, ak@linux.intel.com,
        irogers@google.com, jolsa@redhat.com, peterz@infradead.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 20 Jul 2021 08:21:19 +0200
Message-ID: <16267620794250@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 892ba7f18621a02af4428c58d97451f64685dba4 Mon Sep 17 00:00:00 2001
From: Namhyung Kim <namhyung@kernel.org>
Date: Tue, 29 Jun 2021 21:30:58 -0700
Subject: [PATCH] perf report: Fix --task and --stat with pipe input

Current 'perf report' fails to process a pipe input when --task or
--stat options are used.  This is because they reset all the tool
callbacks and fails to find a matching event for a sample.

When pipe input is used, the event info is passed via ATTR records so it
needs to handle that operation.  Otherwise the following error occurs.
Note, -14 (= -EFAULT) comes from evlist__parse_sample():

  # perf record -a -o- sleep 1 | perf report -i- --stat
  Can't parse sample, err = -14
  0x271044 [0x38]: failed to process type: 9
  Error:
  failed to process sample
  #

Committer testing:

Before:

  $ perf record -o- sleep 1 | perf report -i- --stat
  Can't parse sample, err = -14
  [ perf record: Woken up 1 times to write data ]
  0x1350 [0x30]: failed to process type: 9
  Error:
  failed to process sample
  [ perf record: Captured and wrote 0.000 MB - ]
  $

After:

  $ perf record -o- sleep 1 | perf report -i- --stat
  [ perf record: Woken up 1 times to write data ]
  [ perf record: Captured and wrote 0.000 MB - ]

  Aggregated stats:
             TOTAL events:         41
              COMM events:          2  ( 4.9%)
              EXIT events:          1  ( 2.4%)
            SAMPLE events:          9  (22.0%)
             MMAP2 events:          4  ( 9.8%)
              ATTR events:          1  ( 2.4%)
    FINISHED_ROUND events:          1  ( 2.4%)
        THREAD_MAP events:          1  ( 2.4%)
           CPU_MAP events:          1  ( 2.4%)
      EVENT_UPDATE events:          1  ( 2.4%)
         TIME_CONV events:          1  ( 2.4%)
           FEATURE events:         19  (46.3%)
  cycles:uhH stats:
            SAMPLE events:          9
  $

Fixes: a4a4d0a7a2b20f78 ("perf report: Add --stats option to display quick data statistics")
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lore.kernel.org/lkml/20210630043058.1131295-1-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index bc5c393021dc..8639bbe0969d 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -729,9 +729,14 @@ static int count_sample_event(struct perf_tool *tool __maybe_unused,
 	return 0;
 }
 
+static int process_attr(struct perf_tool *tool __maybe_unused,
+			union perf_event *event,
+			struct evlist **pevlist);
+
 static void stats_setup(struct report *rep)
 {
 	memset(&rep->tool, 0, sizeof(rep->tool));
+	rep->tool.attr = process_attr;
 	rep->tool.sample = count_sample_event;
 	rep->tool.no_warn = true;
 }
@@ -753,6 +758,7 @@ static void tasks_setup(struct report *rep)
 		rep->tool.mmap = perf_event__process_mmap;
 		rep->tool.mmap2 = perf_event__process_mmap2;
 	}
+	rep->tool.attr = process_attr;
 	rep->tool.comm = perf_event__process_comm;
 	rep->tool.exit = perf_event__process_exit;
 	rep->tool.fork = perf_event__process_fork;

