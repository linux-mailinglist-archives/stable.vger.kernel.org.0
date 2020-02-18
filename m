Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35656163170
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 21:01:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727721AbgBRUA0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 15:00:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:39626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728582AbgBRUAZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Feb 2020 15:00:25 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95ACF24670;
        Tue, 18 Feb 2020 20:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582056025;
        bh=BzMa2qGO8g16s/WmhDUrJw7bWLJLX8rlwouMNxuw3rc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jy5kMjCEWJsKEHKg26RGOgR9ft5bewEGIzgyRXG8p1swMR/s1MHoWVDPwln4DZbaK
         3OFnMeNv7Je9IbALVIQTuE/ZSHZzyZi0ew94jgYs0a+zjPWvqBUgfVMz2b7Iy8qPk1
         +LVjil66MFOYBIPvdjGlaFZ4SEqK5/DRK81a2n4c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kim Phillips <kim.phillips@amd.com>,
        Andi Kleen <ak@linux.intel.com>, Jiri Olsa <jolsa@redhat.com>,
        Song Liu <songliubraving@fb.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Jin Yao <yao.jin@linux.intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.4 58/66] perf stat: Dont report a null stalled cycles per insn metric
Date:   Tue, 18 Feb 2020 20:55:25 +0100
Message-Id: <20200218190433.435351946@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200218190428.035153861@linuxfoundation.org>
References: <20200218190428.035153861@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kim Phillips <kim.phillips@amd.com>

commit 80cc7bb6c104d733bff60ddda09f19139c61507c upstream.

For data collected on machines with front end stalled cycles supported,
such as found on modern AMD CPU families, commit 146540fb545b ("perf
stat: Always separate stalled cycles per insn") introduces a new line in
CSV output with a leading comma that upsets some automated scripts.
Scripts have to use "-e ex_ret_instr" to work around this issue, after
upgrading to a version of perf with that commit.

We could add "if (have_frontend_stalled && !config->csv_sep)" to the not
(total && avg) else clause, to emphasize that CSV users are usually
scripts, and are written to do only what is needed, i.e., they wouldn't
typically invoke "perf stat" without specifying an explicit event list.

But - let alone CSV output - why should users now tolerate a constant
0-reporting extra line in regular terminal output?:

BEFORE:

$ sudo perf stat --all-cpus -einstructions,cycles -- sleep 1

 Performance counter stats for 'system wide':

       181,110,981      instructions              #    0.58  insn per cycle
                                                  #    0.00  stalled cycles per insn
       309,876,469      cycles

       1.002202582 seconds time elapsed

The user would not like to see the now permanent:

  "0.00  stalled cycles per insn"

line fixture, as it gives no useful information.

So this patch removes the printing of the zeroed stalled cycles line
altogether, almost reverting the very original commit fb4605ba47e7
("perf stat: Check for frontend stalled for metrics"), which seems like
it was written to normalize --metric-only column output of common Intel
machines at the time: modern Intel machines have ceased to support the
genericised frontend stalled metrics AFAICT.

AFTER:

$ sudo perf stat --all-cpus -einstructions,cycles -- sleep 1

 Performance counter stats for 'system wide':

       244,071,432      instructions              #    0.69  insn per cycle
       355,353,490      cycles

       1.001862516 seconds time elapsed

Output behaviour when stalled cycles is indeed measured is not affected
(BEFORE == AFTER):

$ sudo perf stat --all-cpus -einstructions,cycles,stalled-cycles-frontend -- sleep 1

 Performance counter stats for 'system wide':

       247,227,799      instructions              #    0.63  insn per cycle
                                                  #    0.26  stalled cycles per insn
       394,745,636      cycles
        63,194,485      stalled-cycles-frontend   #   16.01% frontend cycles idle

       1.002079770 seconds time elapsed

Fixes: 146540fb545b ("perf stat: Always separate stalled cycles per insn")
Signed-off-by: Kim Phillips <kim.phillips@amd.com>
Acked-by: Andi Kleen <ak@linux.intel.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Acked-by: Song Liu <songliubraving@fb.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Jin Yao <yao.jin@linux.intel.com>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lore.kernel.org/lkml/20200207230613.26709-1-kim.phillips@amd.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/perf/util/stat-shadow.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/tools/perf/util/stat-shadow.c
+++ b/tools/perf/util/stat-shadow.c
@@ -18,7 +18,6 @@
  * AGGR_NONE: Use matching CPU
  * AGGR_THREAD: Not supported?
  */
-static bool have_frontend_stalled;
 
 struct runtime_stat rt_stat;
 struct stats walltime_nsecs_stats;
@@ -144,7 +143,6 @@ void runtime_stat__exit(struct runtime_s
 
 void perf_stat__init_shadow_stats(void)
 {
-	have_frontend_stalled = pmu_have_event("cpu", "stalled-cycles-frontend");
 	runtime_stat__init(&rt_stat);
 }
 
@@ -853,10 +851,6 @@ void perf_stat__print_shadow_stats(struc
 			print_metric(config, ctxp, NULL, "%7.2f ",
 					"stalled cycles per insn",
 					ratio);
-		} else if (have_frontend_stalled) {
-			out->new_line(config, ctxp);
-			print_metric(config, ctxp, NULL, "%7.2f ",
-				     "stalled cycles per insn", 0);
 		}
 	} else if (perf_evsel__match(evsel, HARDWARE, HW_BRANCH_MISSES)) {
 		if (runtime_stat_n(st, STAT_BRANCHES, ctx, cpu) != 0)


