Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FE27D2454
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 11:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387749AbfJJInm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:43:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:48574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388770AbfJJInm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:43:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 838C62054F;
        Thu, 10 Oct 2019 08:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570697021;
        bh=YsxlhSyeXrt0RJSM4nYtreNGAXgVaewxWA3inoJoUTE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ViPFyQ5ePNyiloC169OrUjHg/E6qqdNnV6l58EUrANKIKK/xXJnm++hKdiX91mYmN
         UFiJu5iWJjrpkBgPDRRInwUKOmhN4O/fGubeeOUxcNfk8ET7lRi30Eqvj2Ch+iVVPo
         XdjNtX3uJtcMfWalPXBMEmNmzcDeavAx4P6mE6Kg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ravi Bangoria <ravi.bangoria@linux.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Stephane Eranian <eranian@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 139/148] perf stat: Reset previous counts on repeat with interval
Date:   Thu, 10 Oct 2019 10:36:40 +0200
Message-Id: <20191010083620.763187286@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083609.660878383@linuxfoundation.org>
References: <20191010083609.660878383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

[ Upstream commit b63fd11cced17fcb8e133def29001b0f6aaa5e06 ]

When using 'perf stat' with repeat and interval option, it shows wrong
values for events.

The wrong values will be shown for the first interval on the second and
subsequent repetitions.

Without the fix:

  # perf stat -r 3 -I 2000 -e faults -e sched:sched_switch -a sleep 5

     2.000282489                 53      faults
     2.000282489                513      sched:sched_switch
     4.005478208              3,721      faults
     4.005478208              2,666      sched:sched_switch
     5.025470933                395      faults
     5.025470933              1,307      sched:sched_switch
     2.009602825 1,84,46,74,40,73,70,95,47,520      faults 		<------
     2.009602825 1,84,46,74,40,73,70,95,49,568      sched:sched_switch  <------
     4.019612206              4,730      faults
     4.019612206              2,746      sched:sched_switch
     5.039615484              3,953      faults
     5.039615484              1,496      sched:sched_switch
     2.000274620 1,84,46,74,40,73,70,95,47,520      faults		<------
     2.000274620 1,84,46,74,40,73,70,95,47,520      sched:sched_switch	<------
     4.000480342              4,282      faults
     4.000480342              2,303      sched:sched_switch
     5.000916811              1,322      faults
     5.000916811              1,064      sched:sched_switch
  #

prev_raw_counts is allocated when using intervals. This is used when
calculating the difference in the counts of events when using interval.

The current counts are stored in prev_raw_counts to calculate the
differences in the next iteration.

On the first interval of the second and subsequent repetitions,
prev_raw_counts would be the values stored in the last interval of the
previous repetitions, while the current counts will only be for the
first interval of the current repetition.

Hence there is a possibility of events showing up as big number.

Fix this by resetting prev_raw_counts whenever perf stat repeats the
command.

With the fix:

  # perf stat -r 3 -I 2000 -e faults -e sched:sched_switch -a sleep 5

     2.019349347              2,597      faults
     2.019349347              2,753      sched:sched_switch
     4.019577372              3,098      faults
     4.019577372              2,532      sched:sched_switch
     5.019415481              1,879      faults
     5.019415481              1,356      sched:sched_switch
     2.000178813              8,468      faults
     2.000178813              2,254      sched:sched_switch
     4.000404621              7,440      faults
     4.000404621              1,266      sched:sched_switch
     5.040196079              2,458      faults
     5.040196079                556      sched:sched_switch
     2.000191939              6,870      faults
     2.000191939              1,170      sched:sched_switch
     4.000414103                541      faults
     4.000414103                902      sched:sched_switch
     5.000809863                450      faults
     5.000809863                364      sched:sched_switch
  #

Committer notes:

This was broken since the cset introducing the --interval feature, i.e.
--repeat + --interval wasn't tested at that point, add the Fixes tag so
that automatic scripts can pick this up.

Fixes: 13370a9b5bb8 ("perf stat: Add interval printing")
Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Tested-by: Ravi Bangoria <ravi.bangoria@linux.ibm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: stable@vger.kernel.org # v3.9+
Link: http://lore.kernel.org/lkml/20190904094738.9558-2-srikar@linux.vnet.ibm.com
[ Fixed up conflicts with libperf, i.e. some perf_{evsel,evlist} lost the 'perf' prefix ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-stat.c |  3 +++
 tools/perf/util/stat.c    | 17 +++++++++++++++++
 tools/perf/util/stat.h    |  1 +
 3 files changed, 21 insertions(+)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 3e13b231f2f56..8ec06bf3372c6 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -1961,6 +1961,9 @@ int cmd_stat(int argc, const char **argv)
 			fprintf(output, "[ perf stat: executing run #%d ... ]\n",
 				run_idx + 1);
 
+		if (run_idx != 0)
+			perf_evlist__reset_prev_raw_counts(evsel_list);
+
 		status = run_perf_stat(argc, argv, run_idx);
 		if (forever && status != -1 && !interval) {
 			print_counters(NULL, argc, argv);
diff --git a/tools/perf/util/stat.c b/tools/perf/util/stat.c
index db8a6cf336bed..6ce66c2727474 100644
--- a/tools/perf/util/stat.c
+++ b/tools/perf/util/stat.c
@@ -155,6 +155,15 @@ static void perf_evsel__free_prev_raw_counts(struct perf_evsel *evsel)
 	evsel->prev_raw_counts = NULL;
 }
 
+static void perf_evsel__reset_prev_raw_counts(struct perf_evsel *evsel)
+{
+	if (evsel->prev_raw_counts) {
+		evsel->prev_raw_counts->aggr.val = 0;
+		evsel->prev_raw_counts->aggr.ena = 0;
+		evsel->prev_raw_counts->aggr.run = 0;
+       }
+}
+
 static int perf_evsel__alloc_stats(struct perf_evsel *evsel, bool alloc_raw)
 {
 	int ncpus = perf_evsel__nr_cpus(evsel);
@@ -205,6 +214,14 @@ void perf_evlist__reset_stats(struct perf_evlist *evlist)
 	}
 }
 
+void perf_evlist__reset_prev_raw_counts(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel;
+
+	evlist__for_each_entry(evlist, evsel)
+		perf_evsel__reset_prev_raw_counts(evsel);
+}
+
 static void zero_per_pkg(struct perf_evsel *counter)
 {
 	if (counter->per_pkg_mask)
diff --git a/tools/perf/util/stat.h b/tools/perf/util/stat.h
index 7032dd1eeac2f..9cd0d9cff374a 100644
--- a/tools/perf/util/stat.h
+++ b/tools/perf/util/stat.h
@@ -194,6 +194,7 @@ void perf_stat__collect_metric_expr(struct perf_evlist *);
 int perf_evlist__alloc_stats(struct perf_evlist *evlist, bool alloc_raw);
 void perf_evlist__free_stats(struct perf_evlist *evlist);
 void perf_evlist__reset_stats(struct perf_evlist *evlist);
+void perf_evlist__reset_prev_raw_counts(struct perf_evlist *evlist);
 
 int perf_stat_process_counter(struct perf_stat_config *config,
 			      struct perf_evsel *counter);
-- 
2.20.1



