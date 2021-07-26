Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FCC63D6038
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:02:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236380AbhGZPV0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:21:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:35502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237178AbhGZPVV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:21:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 46F2D61037;
        Mon, 26 Jul 2021 16:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315310;
        bh=pWl8n2vIRJUpmu1xxlkutJC4RwJu6aIIgdtM3BB5MBw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wJqU7eD/HaQvbCDjCIdXNzYX33vHcc9URMPCmYRZNhP9i6uA3tyXA9MjW5A0xl0qV
         OOCJ4EGPLJ0BwOU/5SQNuiy+QCZua0n+lLvMXM9gKgHQcL8VNvY7sw88InAuLMxXv3
         eqUHrN5LJe6vjsP3Ek5lXMucCUNEH0feh9X/cs74=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Jihong <yangjihong1@huawei.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Yafang Shao <laoar.shao@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 047/167] perf sched: Fix record failure when CONFIG_SCHEDSTATS is not set
Date:   Mon, 26 Jul 2021 17:38:00 +0200
Message-Id: <20210726153840.972990128@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153839.371771838@linuxfoundation.org>
References: <20210726153839.371771838@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Jihong <yangjihong1@huawei.com>

[ Upstream commit b0f008551f0bf4d5f6db9b5f0e071b02790d6a2e ]

The tracepoints trace_sched_stat_{wait, sleep, iowait} are not exposed to user
if CONFIG_SCHEDSTATS is not set, "perf sched record" records the three events.
As a result, the command fails.

Before:

  #perf sched record sleep 1
  event syntax error: 'sched:sched_stat_wait'
                       \___ unknown tracepoint

  Error:  File /sys/kernel/tracing/events/sched/sched_stat_wait not found.
  Hint:   Perhaps this kernel misses some CONFIG_ setting to enable this feature?.

  Run 'perf list' for a list of valid events

   Usage: perf record [<options>] [<command>]
      or: perf record [<options>] -- <command> [<options>]

      -e, --event <event>   event selector. use 'perf list' to list available events

Solution:
  Check whether schedstat tracepoints are exposed. If no, these events are not recorded.

After:
  # perf sched record sleep 1
  [ perf record: Woken up 1 times to write data ]
  [ perf record: Captured and wrote 0.163 MB perf.data (1091 samples) ]
  # perf sched report
  run measurement overhead: 4736 nsecs
  sleep measurement overhead: 9059979 nsecs
  the run test took 999854 nsecs
  the sleep test took 8945271 nsecs
  nr_run_events:        716
  nr_sleep_events:      785
  nr_wakeup_events:     0
  ...
  ------------------------------------------------------------

Fixes: 2a09b5de235a6 ("sched/fair: do not expose some tracepoints to user if CONFIG_SCHEDSTATS is not set")
Signed-off-by: Yang Jihong <yangjihong1@huawei.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: Yafang Shao <laoar.shao@gmail.com>
Link: http://lore.kernel.org/lkml/20210713112358.194693-1-yangjihong1@huawei.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-sched.c | 33 +++++++++++++++++++++++++++++----
 1 file changed, 29 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 0e16f9d5a947..d3b5f5faf8c1 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -3337,6 +3337,16 @@ static void setup_sorting(struct perf_sched *sched, const struct option *options
 	sort_dimension__add("pid", &sched->cmp_pid);
 }
 
+static bool schedstat_events_exposed(void)
+{
+	/*
+	 * Select "sched:sched_stat_wait" event to check
+	 * whether schedstat tracepoints are exposed.
+	 */
+	return IS_ERR(trace_event__tp_format("sched", "sched_stat_wait")) ?
+		false : true;
+}
+
 static int __cmd_record(int argc, const char **argv)
 {
 	unsigned int rec_argc, i, j;
@@ -3348,21 +3358,33 @@ static int __cmd_record(int argc, const char **argv)
 		"-m", "1024",
 		"-c", "1",
 		"-e", "sched:sched_switch",
-		"-e", "sched:sched_stat_wait",
-		"-e", "sched:sched_stat_sleep",
-		"-e", "sched:sched_stat_iowait",
 		"-e", "sched:sched_stat_runtime",
 		"-e", "sched:sched_process_fork",
 		"-e", "sched:sched_wakeup_new",
 		"-e", "sched:sched_migrate_task",
 	};
+
+	/*
+	 * The tracepoints trace_sched_stat_{wait, sleep, iowait}
+	 * are not exposed to user if CONFIG_SCHEDSTATS is not set,
+	 * to prevent "perf sched record" execution failure, determine
+	 * whether to record schedstat events according to actual situation.
+	 */
+	const char * const schedstat_args[] = {
+		"-e", "sched:sched_stat_wait",
+		"-e", "sched:sched_stat_sleep",
+		"-e", "sched:sched_stat_iowait",
+	};
+	unsigned int schedstat_argc = schedstat_events_exposed() ?
+		ARRAY_SIZE(schedstat_args) : 0;
+
 	struct tep_event *waking_event;
 
 	/*
 	 * +2 for either "-e", "sched:sched_wakeup" or
 	 * "-e", "sched:sched_waking"
 	 */
-	rec_argc = ARRAY_SIZE(record_args) + 2 + argc - 1;
+	rec_argc = ARRAY_SIZE(record_args) + 2 + schedstat_argc + argc - 1;
 	rec_argv = calloc(rec_argc + 1, sizeof(char *));
 
 	if (rec_argv == NULL)
@@ -3378,6 +3400,9 @@ static int __cmd_record(int argc, const char **argv)
 	else
 		rec_argv[i++] = strdup("sched:sched_wakeup");
 
+	for (j = 0; j < schedstat_argc; j++)
+		rec_argv[i++] = strdup(schedstat_args[j]);
+
 	for (j = 1; j < (unsigned int)argc; j++, i++)
 		rec_argv[i] = argv[j];
 
-- 
2.30.2



