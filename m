Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCD9B3CDF0A
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:50:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344556AbhGSPH0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:07:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:60626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345761AbhGSPE6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:04:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1E7D560E0C;
        Mon, 19 Jul 2021 15:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709524;
        bh=c6ZEmDgMPi9mbY12iuB9mrg5SUwKIFt41vxJUeZTekw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zPHqM+HmVhJ45S6PPRWhirDwaGrRRz2ZDnQeq2VPjJnpQGIl+gEYAI/wqIp0CKV3G
         TkrHTDHuPrv97TeRhR2T3ihTHWnY8bIcPRBYe9/KWVvCP9kCfY5a3yAg+J0szndI1M
         MM3bTw4fT5OitOigv1X1XXVGi3gL7E1Jak/KAFcQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>,
        Ian Rogers <irogers@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 418/421] perf report: Fix --task and --stat with pipe input
Date:   Mon, 19 Jul 2021 16:53:49 +0200
Message-Id: <20210719145000.810771851@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit 892ba7f18621a02af4428c58d97451f64685dba4 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-report.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 05eae94d09cb..dea7ed3fb0a4 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -634,9 +634,14 @@ static void report__output_resort(struct report *rep)
 	ui_progress__finish();
 }
 
+static int process_attr(struct perf_tool *tool __maybe_unused,
+			union perf_event *event,
+			struct evlist **pevlist);
+
 static void stats_setup(struct report *rep)
 {
 	memset(&rep->tool, 0, sizeof(rep->tool));
+	rep->tool.attr = process_attr;
 	rep->tool.no_warn = true;
 }
 
@@ -656,6 +661,7 @@ static void tasks_setup(struct report *rep)
 		rep->tool.mmap = perf_event__process_mmap;
 		rep->tool.mmap2 = perf_event__process_mmap2;
 	}
+	rep->tool.attr = process_attr;
 	rep->tool.comm = perf_event__process_comm;
 	rep->tool.exit = perf_event__process_exit;
 	rep->tool.fork = perf_event__process_fork;
-- 
2.30.2



