Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17C0D261635
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 19:06:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731886AbgIHRGJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 13:06:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:57574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731813AbgIHQTW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:19:22 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 125952412B;
        Tue,  8 Sep 2020 15:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579509;
        bh=NSZh+BXHoW3U12V93bsc8yJkP2OJ4cjQBQyfskKGvSc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lIeAV5hzJH8d/ctmCnagN+Eaq26Sw3L6FPytcfqMmHigwnMut1YleQSA7NL7gar2n
         VshmNMCAs0fb+py8645Es4KOZzqGSN6zTe1IgvO+QW7ftysXEZTWCdzydMA8G87OFU
         pwp5C1zIQeV90FMNDtMxv6j8+sU/b8fUhtUzRkB8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jin Yao <yao.jin@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 106/186] perf stat: Turn off summary for interval mode by default
Date:   Tue,  8 Sep 2020 17:24:08 +0200
Message-Id: <20200908152246.769333455@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152241.646390211@linuxfoundation.org>
References: <20200908152241.646390211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jin Yao <yao.jin@linux.intel.com>

[ Upstream commit ee6a961432e75393bd69bf70ba70bad90396fa82 ]

There's a risk that outputting interval mode summaries by default breaks
CSV consumers. It already broke pmu-tools/toplev.

So now we turn off the summary by default but we create a new option
'--summary' to enable the summary. This is active even when not using
CSV mode.

Before:

  root@kbl-ppc:~# perf stat -I1000 --interval-count 2
  #           time             counts unit events
       1.000265904           8,005.73 msec cpu-clock                 #    8.006 CPUs utilized
       1.000265904                601      context-switches          #    0.075 K/sec
       1.000265904                 10      cpu-migrations            #    0.001 K/sec
       1.000265904                  0      page-faults               #    0.000 K/sec
       1.000265904         66,746,521      cycles                    #    0.008 GHz
       1.000265904         71,874,398      instructions              #    1.08  insn per cycle
       1.000265904         13,356,781      branches                  #    1.668 M/sec
       1.000265904            298,756      branch-misses             #    2.24% of all branches
       2.001857667           8,012.52 msec cpu-clock                 #    8.013 CPUs utilized
       2.001857667                164      context-switches          #    0.020 K/sec
       2.001857667                 10      cpu-migrations            #    0.001 K/sec
       2.001857667                  2      page-faults               #    0.000 K/sec
       2.001857667          5,822,188      cycles                    #    0.001 GHz
       2.001857667          2,186,170      instructions              #    0.38  insn per cycle
       2.001857667            442,378      branches                  #    0.055 M/sec
       2.001857667             44,750      branch-misses             #   10.12% of all branches

   Performance counter stats for 'system wide':

           16,018.25 msec cpu-clock                 #    7.993 CPUs utilized
                 765      context-switches          #    0.048 K/sec
                  20      cpu-migrations            #    0.001 K/sec
                   2      page-faults               #    0.000 K/sec
          72,568,709      cycles                    #    0.005 GHz
          74,060,568      instructions              #    1.02  insn per cycle
          13,799,159      branches                  #    0.861 M/sec
             343,506      branch-misses             #    2.49% of all branches

         2.004118489 seconds time elapsed

After:

  root@kbl-ppc:~# perf stat -I1000 --interval-count 2
  #           time             counts unit events
       1.001336393           8,013.28 msec cpu-clock                 #    8.013 CPUs utilized
       1.001336393                 82      context-switches          #    0.010 K/sec
       1.001336393                  8      cpu-migrations            #    0.001 K/sec
       1.001336393                  0      page-faults               #    0.000 K/sec
       1.001336393          4,199,121      cycles                    #    0.001 GHz
       1.001336393          1,373,991      instructions              #    0.33  insn per cycle
       1.001336393            270,681      branches                  #    0.034 M/sec
       1.001336393             31,659      branch-misses             #   11.70% of all branches
       2.003905006           8,020.52 msec cpu-clock                 #    8.021 CPUs utilized
       2.003905006                184      context-switches          #    0.023 K/sec
       2.003905006                  8      cpu-migrations            #    0.001 K/sec
       2.003905006                  2      page-faults               #    0.000 K/sec
       2.003905006          5,446,190      cycles                    #    0.001 GHz
       2.003905006          2,312,547      instructions              #    0.42  insn per cycle
       2.003905006            451,691      branches                  #    0.056 M/sec
       2.003905006             37,925      branch-misses             #    8.40% of all branches

  root@kbl-ppc:~# perf stat -I1000 --interval-count 2 --summary
  #           time             counts unit events
       1.001313128           8,013.20 msec cpu-clock                 #    8.013 CPUs utilized
       1.001313128                 83      context-switches          #    0.010 K/sec
       1.001313128                  8      cpu-migrations            #    0.001 K/sec
       1.001313128                  0      page-faults               #    0.000 K/sec
       1.001313128          4,470,950      cycles                    #    0.001 GHz
       1.001313128          1,440,045      instructions              #    0.32  insn per cycle
       1.001313128            283,222      branches                  #    0.035 M/sec
       1.001313128             33,576      branch-misses             #   11.86% of all branches
       2.003857385           8,020.34 msec cpu-clock                 #    8.020 CPUs utilized
       2.003857385                154      context-switches          #    0.019 K/sec
       2.003857385                  8      cpu-migrations            #    0.001 K/sec
       2.003857385                  2      page-faults               #    0.000 K/sec
       2.003857385          4,515,676      cycles                    #    0.001 GHz
       2.003857385          2,180,449      instructions              #    0.48  insn per cycle
       2.003857385            435,254      branches                  #    0.054 M/sec
       2.003857385             31,179      branch-misses             #    7.16% of all branches

   Performance counter stats for 'system wide':

           16,033.53 msec cpu-clock                 #    7.992 CPUs utilized
                 237      context-switches          #    0.015 K/sec
                  16      cpu-migrations            #    0.001 K/sec
                   2      page-faults               #    0.000 K/sec
           8,986,626      cycles                    #    0.001 GHz
           3,620,494      instructions              #    0.40  insn per cycle
             718,476      branches                  #    0.045 M/sec
              64,755      branch-misses             #    9.01% of all branches

         2.006124542 seconds time elapsed

Fixes: c7e5b328a8d4 ("perf stat: Report summary for interval mode")
Signed-off-by: Jin Yao <yao.jin@linux.intel.com>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lore.kernel.org/lkml/20200903010113.32232-1-yao.jin@linux.intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/Documentation/perf-stat.txt | 3 +++
 tools/perf/builtin-stat.c              | 8 +++++---
 tools/perf/util/stat.h                 | 1 +
 3 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/tools/perf/Documentation/perf-stat.txt b/tools/perf/Documentation/perf-stat.txt
index c8209467076b1..d8299b77f5c89 100644
--- a/tools/perf/Documentation/perf-stat.txt
+++ b/tools/perf/Documentation/perf-stat.txt
@@ -380,6 +380,9 @@ counts for all hardware threads in a core but show the sum counts per
 hardware thread. This is essentially a replacement for the any bit and
 convenient for post processing.
 
+--summary::
+Print summary for interval mode (-I).
+
 EXAMPLES
 --------
 
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 9be020e0098ad..6e2502de755a8 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -402,7 +402,7 @@ static void read_counters(struct timespec *rs)
 {
 	struct evsel *counter;
 
-	if (!stat_config.summary && (read_affinity_counters(rs) < 0))
+	if (!stat_config.stop_read_counter && (read_affinity_counters(rs) < 0))
 		return;
 
 	evlist__for_each_entry(evsel_list, counter) {
@@ -826,9 +826,9 @@ try_again_reset:
 	if (stat_config.walltime_run_table)
 		stat_config.walltime_run[run_idx] = t1 - t0;
 
-	if (interval) {
+	if (interval && stat_config.summary) {
 		stat_config.interval = 0;
-		stat_config.summary = true;
+		stat_config.stop_read_counter = true;
 		init_stats(&walltime_nsecs_stats);
 		update_stats(&walltime_nsecs_stats, t1 - t0);
 
@@ -1066,6 +1066,8 @@ static struct option stat_options[] = {
 		    "Use with 'percore' event qualifier to show the event "
 		    "counts of one hardware thread by sum up total hardware "
 		    "threads of same physical core"),
+	OPT_BOOLEAN(0, "summary", &stat_config.summary,
+		       "print summary for interval mode"),
 #ifdef HAVE_LIBPFM
 	OPT_CALLBACK(0, "pfm-events", &evsel_list, "event",
 		"libpfm4 event selector. use 'perf list' to list available events",
diff --git a/tools/perf/util/stat.h b/tools/perf/util/stat.h
index f75ae679eb281..d8a9dd786bf43 100644
--- a/tools/perf/util/stat.h
+++ b/tools/perf/util/stat.h
@@ -113,6 +113,7 @@ struct perf_stat_config {
 	bool			 summary;
 	bool			 metric_no_group;
 	bool			 metric_no_merge;
+	bool			 stop_read_counter;
 	FILE			*output;
 	unsigned int		 interval;
 	unsigned int		 timeout;
-- 
2.25.1



