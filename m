Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 638456584C5
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 18:02:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233210AbiL1RCA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 12:02:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235328AbiL1RBW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 12:01:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CF901D67D
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:56:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A0F236157A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:56:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82A74C433EF;
        Wed, 28 Dec 2022 16:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672246568;
        bh=0ALA4XjENVFh0vRYay1ea/J5wV2ZI7SsrSuRnwxqjp4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C9jvXxcZZdjyXZecntoYczzF9BT2CwebFimcP3YPiDJ6v9f1TRTNB+ZQo7izGRtaf
         I44NzCaa1BjDmccmuwEQoWqtxnFJMwQRnlq0PbSQA1HvzHKo5lXbmKrp6MQCRW35Fn
         8uli4PCG5Upls7BZ3mQTdOzV5CaL7UIcExc9O7e4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, James Clark <james.clark@arm.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Ian Rogers <irogers@google.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1084/1146] perf tools: Make quiet mode consistent between tools
Date:   Wed, 28 Dec 2022 15:43:43 +0100
Message-Id: <20221228144359.647064000@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Clark <james.clark@arm.com>

[ Upstream commit a527c2c1e2d43e9f145f5d0c5d6ac0bdf5220e22 ]

Use the global quiet variable everywhere so that all tools hide warnings
in quiet mode and update the documentation to reflect this.

'perf probe' claimed that errors are not printed in quiet mode but I
don't see this so remove it from the docs.

Signed-off-by: James Clark <james.clark@arm.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20221018094137.783081-3-james.clark@arm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: 8b269b755512 ("perf probe: Check -v and -q options in the right place")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/Documentation/perf-annotate.txt | 2 +-
 tools/perf/Documentation/perf-diff.txt     | 2 +-
 tools/perf/Documentation/perf-lock.txt     | 2 +-
 tools/perf/Documentation/perf-probe.txt    | 2 +-
 tools/perf/Documentation/perf-record.txt   | 2 +-
 tools/perf/Documentation/perf-report.txt   | 2 +-
 tools/perf/Documentation/perf-stat.txt     | 4 ++--
 tools/perf/bench/numa.c                    | 9 +++++----
 tools/perf/builtin-annotate.c              | 2 +-
 tools/perf/builtin-diff.c                  | 2 +-
 tools/perf/builtin-lock.c                  | 2 +-
 tools/perf/builtin-probe.c                 | 7 +++----
 tools/perf/builtin-record.c                | 2 +-
 tools/perf/builtin-report.c                | 2 +-
 tools/perf/builtin-stat.c                  | 8 ++++----
 tools/perf/util/stat.h                     | 1 -
 16 files changed, 25 insertions(+), 26 deletions(-)

diff --git a/tools/perf/Documentation/perf-annotate.txt b/tools/perf/Documentation/perf-annotate.txt
index 18fcc52809fb..980fe2c29275 100644
--- a/tools/perf/Documentation/perf-annotate.txt
+++ b/tools/perf/Documentation/perf-annotate.txt
@@ -41,7 +41,7 @@ OPTIONS
 
 -q::
 --quiet::
-	Do not show any message.  (Suppress -v)
+	Do not show any warnings or messages.  (Suppress -v)
 
 -n::
 --show-nr-samples::
diff --git a/tools/perf/Documentation/perf-diff.txt b/tools/perf/Documentation/perf-diff.txt
index be65bd55ab2a..f3067a4af294 100644
--- a/tools/perf/Documentation/perf-diff.txt
+++ b/tools/perf/Documentation/perf-diff.txt
@@ -75,7 +75,7 @@ OPTIONS
 
 -q::
 --quiet::
-	Do not show any message.  (Suppress -v)
+	Do not show any warnings or messages.  (Suppress -v)
 
 -f::
 --force::
diff --git a/tools/perf/Documentation/perf-lock.txt b/tools/perf/Documentation/perf-lock.txt
index 3b1e16563b79..4958a1ffa1cc 100644
--- a/tools/perf/Documentation/perf-lock.txt
+++ b/tools/perf/Documentation/perf-lock.txt
@@ -42,7 +42,7 @@ COMMON OPTIONS
 
 -q::
 --quiet::
-	Do not show any message. (Suppress -v)
+	Do not show any warnings or messages. (Suppress -v)
 
 -D::
 --dump-raw-trace::
diff --git a/tools/perf/Documentation/perf-probe.txt b/tools/perf/Documentation/perf-probe.txt
index 080981d38d7b..7f8e8ba3a787 100644
--- a/tools/perf/Documentation/perf-probe.txt
+++ b/tools/perf/Documentation/perf-probe.txt
@@ -57,7 +57,7 @@ OPTIONS
 
 -q::
 --quiet::
-	Be quiet (do not show any messages including errors).
+	Do not show any warnings or messages.
 	Can not use with -v.
 
 -a::
diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index e41ae950fdc3..9ea6d44aca58 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -282,7 +282,7 @@ OPTIONS
 
 -q::
 --quiet::
-	Don't print any message, useful for scripting.
+	Don't print any warnings or messages, useful for scripting.
 
 -v::
 --verbose::
diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index 4533db2ee56b..4fa509b15948 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -27,7 +27,7 @@ OPTIONS
 
 -q::
 --quiet::
-	Do not show any message.  (Suppress -v)
+	Do not show any warnings or messages.  (Suppress -v)
 
 -n::
 --show-nr-samples::
diff --git a/tools/perf/Documentation/perf-stat.txt b/tools/perf/Documentation/perf-stat.txt
index d7ff1867feda..18abdc1dce05 100644
--- a/tools/perf/Documentation/perf-stat.txt
+++ b/tools/perf/Documentation/perf-stat.txt
@@ -354,8 +354,8 @@ forbids the event merging logic from sharing events between groups and
 may be used to increase accuracy in this case.
 
 --quiet::
-Don't print output. This is useful with perf stat record below to only
-write data to the perf.data file.
+Don't print output, warnings or messages. This is useful with perf stat
+record below to only write data to the perf.data file.
 
 STAT RECORD
 -----------
diff --git a/tools/perf/bench/numa.c b/tools/perf/bench/numa.c
index e78dedf9e682..9717c6c17433 100644
--- a/tools/perf/bench/numa.c
+++ b/tools/perf/bench/numa.c
@@ -16,6 +16,7 @@
 #include <sched.h>
 #include <stdio.h>
 #include <assert.h>
+#include <debug.h>
 #include <malloc.h>
 #include <signal.h>
 #include <stdlib.h>
@@ -116,7 +117,6 @@ struct params {
 	long			bytes_thread;
 
 	int			nr_tasks;
-	bool			show_quiet;
 
 	bool			show_convergence;
 	bool			measure_convergence;
@@ -197,7 +197,8 @@ static const struct option options[] = {
 	OPT_BOOLEAN('c', "show_convergence", &p0.show_convergence, "show convergence details, "
 		    "convergence is reached when each process (all its threads) is running on a single NUMA node."),
 	OPT_BOOLEAN('m', "measure_convergence",	&p0.measure_convergence, "measure convergence latency"),
-	OPT_BOOLEAN('q', "quiet"	, &p0.show_quiet,	"quiet mode"),
+	OPT_BOOLEAN('q', "quiet"	, &quiet,
+		    "quiet mode (do not show any warnings or messages)"),
 	OPT_BOOLEAN('S', "serialize-startup", &p0.serialize_startup,"serialize thread startup"),
 
 	/* Special option string parsing callbacks: */
@@ -1474,7 +1475,7 @@ static int init(void)
 	/* char array in count_process_nodes(): */
 	BUG_ON(g->p.nr_nodes < 0);
 
-	if (g->p.show_quiet && !g->p.show_details)
+	if (quiet && !g->p.show_details)
 		g->p.show_details = -1;
 
 	/* Some memory should be specified: */
@@ -1553,7 +1554,7 @@ static void print_res(const char *name, double val,
 	if (!name)
 		name = "main,";
 
-	if (!g->p.show_quiet)
+	if (!quiet)
 		printf(" %-30s %15.3f, %-15s %s\n", name, val, txt_unit, txt_short);
 	else
 		printf(" %14.3f %s\n", val, txt_long);
diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index f839e69492e8..517d928c00e3 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -525,7 +525,7 @@ int cmd_annotate(int argc, const char **argv)
 	OPT_BOOLEAN('f', "force", &data.force, "don't complain, do it"),
 	OPT_INCR('v', "verbose", &verbose,
 		    "be more verbose (show symbol address, etc)"),
-	OPT_BOOLEAN('q', "quiet", &quiet, "do now show any message"),
+	OPT_BOOLEAN('q', "quiet", &quiet, "do now show any warnings or messages"),
 	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace,
 		    "dump raw trace in ASCII"),
 #ifdef HAVE_GTK2_SUPPORT
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index d925096dd7f0..ed07cc6cca56 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -1260,7 +1260,7 @@ static const char * const diff_usage[] = {
 static const struct option options[] = {
 	OPT_INCR('v', "verbose", &verbose,
 		    "be more verbose (show symbol address, etc)"),
-	OPT_BOOLEAN('q', "quiet", &quiet, "Do not show any message"),
+	OPT_BOOLEAN('q', "quiet", &quiet, "Do not show any warnings or messages"),
 	OPT_BOOLEAN('b', "baseline-only", &show_baseline_only,
 		    "Show only items with match in baseline"),
 	OPT_CALLBACK('c', "compute", &compute,
diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index 9722d4ab2e55..66520712a167 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -1869,7 +1869,7 @@ int cmd_lock(int argc, const char **argv)
 		   "file", "vmlinux pathname"),
 	OPT_STRING(0, "kallsyms", &symbol_conf.kallsyms_name,
 		   "file", "kallsyms pathname"),
-	OPT_BOOLEAN('q', "quiet", &quiet, "Do not show any message"),
+	OPT_BOOLEAN('q', "quiet", &quiet, "Do not show any warnings or messages"),
 	OPT_END()
 	};
 
diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index f62298f5db3b..2ae50fc9e597 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -40,7 +40,6 @@ static struct {
 	int command;	/* Command short_name */
 	bool list_events;
 	bool uprobes;
-	bool quiet;
 	bool target_used;
 	int nevents;
 	struct perf_probe_event events[MAX_PROBES];
@@ -514,8 +513,8 @@ __cmd_probe(int argc, const char **argv)
 	struct option options[] = {
 	OPT_INCR('v', "verbose", &verbose,
 		    "be more verbose (show parsed arguments, etc)"),
-	OPT_BOOLEAN('q', "quiet", &params.quiet,
-		    "be quiet (do not show any messages)"),
+	OPT_BOOLEAN('q', "quiet", &quiet,
+		    "be quiet (do not show any warnings or messages)"),
 	OPT_CALLBACK_DEFAULT('l', "list", NULL, "[GROUP:]EVENT",
 			     "list up probe events",
 			     opt_set_filter_with_command, DEFAULT_LIST_FILTER),
@@ -634,7 +633,7 @@ __cmd_probe(int argc, const char **argv)
 	if (ret)
 		return ret;
 
-	if (params.quiet) {
+	if (quiet) {
 		if (verbose != 0) {
 			pr_err("  Error: -v and -q are exclusive.\n");
 			return -EINVAL;
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index e128b855ddde..59f3d98a0196 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -3388,7 +3388,7 @@ static struct option __record_options[] = {
 		     &record_parse_callchain_opt),
 	OPT_INCR('v', "verbose", &verbose,
 		    "be more verbose (show counter open errors, etc)"),
-	OPT_BOOLEAN('q', "quiet", &quiet, "don't print any message"),
+	OPT_BOOLEAN('q', "quiet", &quiet, "don't print any warnings or messages"),
 	OPT_BOOLEAN('s', "stat", &record.opts.inherit_stat,
 		    "per thread counts"),
 	OPT_BOOLEAN('d', "data", &record.opts.sample_address, "Record the sample addresses"),
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 8361890176c2..b6d77d3da64f 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -1222,7 +1222,7 @@ int cmd_report(int argc, const char **argv)
 		    "input file name"),
 	OPT_INCR('v', "verbose", &verbose,
 		    "be more verbose (show symbol address, etc)"),
-	OPT_BOOLEAN('q', "quiet", &quiet, "Do not show any message"),
+	OPT_BOOLEAN('q', "quiet", &quiet, "Do not show any warnings or messages"),
 	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace,
 		    "dump raw trace in ASCII"),
 	OPT_BOOLEAN(0, "stats", &report.stats_mode, "Display event stats"),
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index d726c3d3d83c..978fdc60b4e8 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -1024,7 +1024,7 @@ static void print_counters(struct timespec *ts, int argc, const char **argv)
 	/* Do not print anything if we record to the pipe. */
 	if (STAT_RECORD && perf_stat.data.is_pipe)
 		return;
-	if (stat_config.quiet)
+	if (quiet)
 		return;
 
 	evlist__print_counters(evsel_list, &stat_config, &target, ts, argc, argv);
@@ -1274,8 +1274,8 @@ static struct option stat_options[] = {
 		       "print summary for interval mode"),
 	OPT_BOOLEAN(0, "no-csv-summary", &stat_config.no_csv_summary,
 		       "don't print 'summary' for CSV summary output"),
-	OPT_BOOLEAN(0, "quiet", &stat_config.quiet,
-			"don't print output (useful with record)"),
+	OPT_BOOLEAN(0, "quiet", &quiet,
+			"don't print any output, messages or warnings (useful with record)"),
 	OPT_CALLBACK(0, "cputype", &evsel_list, "hybrid cpu type",
 		     "Only enable events on applying cpu with this type "
 		     "for hybrid platform (e.g. core or atom)",
@@ -2278,7 +2278,7 @@ int cmd_stat(int argc, const char **argv)
 		goto out;
 	}
 
-	if (!output && !stat_config.quiet) {
+	if (!output && !quiet) {
 		struct timespec tm;
 		mode = append_file ? "a" : "w";
 
diff --git a/tools/perf/util/stat.h b/tools/perf/util/stat.h
index 141f1ba940cc..bcb1cd68fb52 100644
--- a/tools/perf/util/stat.h
+++ b/tools/perf/util/stat.h
@@ -139,7 +139,6 @@ struct perf_stat_config {
 	bool			 metric_no_group;
 	bool			 metric_no_merge;
 	bool			 stop_read_counter;
-	bool			 quiet;
 	bool			 iostat_run;
 	char			 *user_requested_cpu_list;
 	bool			 system_wide;
-- 
2.35.1



