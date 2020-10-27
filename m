Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7053C29B518
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:12:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1793750AbgJ0PIH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:08:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:40436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1793298AbgJ0PGV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:06:21 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95171206E5;
        Tue, 27 Oct 2020 15:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811180;
        bh=00bsGD1l+ZChTosyi4qonnXxWxEjKf1YLh0rxfx2akM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WEnRZZYwPtyD72tzajIf2p18Gkw1VcikMA+rEy+5usDI3c7J3cU8v/7HP8E4Px9so
         kP/KSP9mVIb0SgL+yBh6AaCErLKeKcV+0uIRLH4GSmJ5weRGjGWFUCwgB5N4vcjrQg
         bd/kVkRTbhy3vZ6RmRHZQxCl4+BE4eVXpYkohNtk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wei Li <liwei391@huawei.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Barry Song <song.bao.hua@hisilicon.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 401/633] perf stat: Fix out of bounds CPU map access when handling armv8_pmu events
Date:   Tue, 27 Oct 2020 14:52:24 +0100
Message-Id: <20201027135541.524121956@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit bef69bd7cfc363ab94b84ea29102f3e913ed3c6c ]

It was reported that 'perf stat' crashed when using with armv8_pmu (CPU)
events with the task mode.  As 'perf stat' uses an empty cpu map for
task mode but armv8_pmu has its own cpu mask, it has confused which map
it should use when accessing file descriptors and this causes segfaults:

  (gdb) bt
  #0  0x0000000000603fc8 in perf_evsel__close_fd_cpu (evsel=<optimized out>,
      cpu=<optimized out>) at evsel.c:122
  #1  perf_evsel__close_cpu (evsel=evsel@entry=0x716e950, cpu=7) at evsel.c:156
  #2  0x00000000004d4718 in evlist__close (evlist=0x70a7cb0) at util/evlist.c:1242
  #3  0x0000000000453404 in __run_perf_stat (argc=3, argc@entry=1, argv=0x30,
      argv@entry=0xfffffaea2f90, run_idx=119, run_idx@entry=1701998435)
      at builtin-stat.c:929
  #4  0x0000000000455058 in run_perf_stat (run_idx=1701998435, argv=0xfffffaea2f90,
      argc=1) at builtin-stat.c:947
  #5  cmd_stat (argc=1, argv=0xfffffaea2f90) at builtin-stat.c:2357
  #6  0x00000000004bb888 in run_builtin (p=p@entry=0x9764b8 <commands+288>,
      argc=argc@entry=4, argv=argv@entry=0xfffffaea2f90) at perf.c:312
  #7  0x00000000004bbb54 in handle_internal_command (argc=argc@entry=4,
      argv=argv@entry=0xfffffaea2f90) at perf.c:364
  #8  0x0000000000435378 in run_argv (argcp=<synthetic pointer>,
      argv=<synthetic pointer>) at perf.c:408
  #9  main (argc=4, argv=0xfffffaea2f90) at perf.c:538

To fix this, I simply used the given cpu map unless the evsel actually
is not a system-wide event (like uncore events).

Fixes: 7736627b865d ("perf stat: Use affinity for closing file descriptors")
Reported-by: Wei Li <liwei391@huawei.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Tested-by: Barry Song <song.bao.hua@hisilicon.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lore.kernel.org/lkml/20201007081311.1831003-1-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/perf/evlist.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/lib/perf/evlist.c b/tools/lib/perf/evlist.c
index 6a875a0f01bb0..233592c5a52c7 100644
--- a/tools/lib/perf/evlist.c
+++ b/tools/lib/perf/evlist.c
@@ -45,6 +45,9 @@ static void __perf_evlist__propagate_maps(struct perf_evlist *evlist,
 	if (!evsel->own_cpus || evlist->has_user_cpus) {
 		perf_cpu_map__put(evsel->cpus);
 		evsel->cpus = perf_cpu_map__get(evlist->cpus);
+	} else if (!evsel->system_wide && perf_cpu_map__empty(evlist->cpus)) {
+		perf_cpu_map__put(evsel->cpus);
+		evsel->cpus = perf_cpu_map__get(evlist->cpus);
 	} else if (evsel->cpus != evsel->own_cpus) {
 		perf_cpu_map__put(evsel->cpus);
 		evsel->cpus = perf_cpu_map__get(evsel->own_cpus);
-- 
2.25.1



