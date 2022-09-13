Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF8BB5B704C
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233508AbiIMOYj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:24:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233745AbiIMOYK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:24:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17F7166A65;
        Tue, 13 Sep 2022 07:16:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7D8C7614CB;
        Tue, 13 Sep 2022 14:14:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F52AC433D7;
        Tue, 13 Sep 2022 14:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078471;
        bh=sQhboYEXUV6NaHCi0b8UA+XJONRWpkquPv65uDiSKwQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=072L4vkNsd2mLgdq7mux4PqUenz7ETxtd4wahYxgu8IGcMC6AXmsQR04NXDUD1c4h
         ZeWkj2Yx/8xnQenkBcLFHXOa7OaiBcimxTZRIAYooPAVhUOTujKH/XGUS2N6EGRCQh
         wTCJ4eXk6G0hmMTKKy71NKJA09Gf1CUgtjFf57u8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Tom=C3=A1=C5=A1=20Trnka?= <trnka@scm.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 152/192] libperf evlist: Fix per-thread mmaps for multi-threaded targets
Date:   Tue, 13 Sep 2022 16:04:18 +0200
Message-Id: <20220913140417.598141711@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
References: <20220913140410.043243217@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit 7864d8f7c088aad988c44c631f1ceed9179cf2cf ]

The offending commit removed mmap_per_thread(), which did not consider
the different set-output rules for per-thread mmaps i.e. in the per-thread
case set-output is used for file descriptors of the same thread not the
same cpu.

This was not immediately noticed because it only happens with
multi-threaded targets and we do not have a test for that yet.

Reinstate mmap_per_thread() expanding it to cover also system-wide per-cpu
events i.e. to continue to allow the mixing of per-thread and per-cpu
mmaps.

Debug messages (with -vv) show the file descriptors that are opened with
sys_perf_event_open. New debug messages are added (needs -vvv) that show
also which file descriptors are mmapped and which are redirected with
set-output.

In the per-cpu case (cpu != -1) file descriptors for the same CPU are
set-output to the first file descriptor for that CPU.

In the per-thread case (cpu == -1) file descriptors for the same thread are
set-output to the first file descriptor for that thread.

Example (process 17489 has 2 threads):

 Before (but with new debug prints):

   $ perf record --no-bpf-event -vvv --per-thread -p 17489
   <SNIP>
   sys_perf_event_open: pid 17489  cpu -1  group_fd -1  flags 0x8 = 5
   sys_perf_event_open: pid 17490  cpu -1  group_fd -1  flags 0x8 = 6
   <SNIP>
   libperf: idx 0: mmapping fd 5
   libperf: idx 0: set output fd 6 -> 5
   failed to mmap with 22 (Invalid argument)

 After:

   $ perf record --no-bpf-event -vvv --per-thread -p 17489
   <SNIP>
   sys_perf_event_open: pid 17489  cpu -1  group_fd -1  flags 0x8 = 5
   sys_perf_event_open: pid 17490  cpu -1  group_fd -1  flags 0x8 = 6
   <SNIP>
   libperf: mmap_per_thread: nr cpu values (may include -1) 1 nr threads 2
   libperf: idx 0: mmapping fd 5
   libperf: idx 1: mmapping fd 6
   <SNIP>
   [ perf record: Woken up 2 times to write data ]
   [ perf record: Captured and wrote 0.018 MB perf.data (15 samples) ]

Per-cpu example (process 20341 has 2 threads, same as above):

   $ perf record --no-bpf-event -vvv -p 20341
   <SNIP>
   sys_perf_event_open: pid 20341  cpu 0  group_fd -1  flags 0x8 = 5
   sys_perf_event_open: pid 20342  cpu 0  group_fd -1  flags 0x8 = 6
   sys_perf_event_open: pid 20341  cpu 1  group_fd -1  flags 0x8 = 7
   sys_perf_event_open: pid 20342  cpu 1  group_fd -1  flags 0x8 = 8
   sys_perf_event_open: pid 20341  cpu 2  group_fd -1  flags 0x8 = 9
   sys_perf_event_open: pid 20342  cpu 2  group_fd -1  flags 0x8 = 10
   sys_perf_event_open: pid 20341  cpu 3  group_fd -1  flags 0x8 = 11
   sys_perf_event_open: pid 20342  cpu 3  group_fd -1  flags 0x8 = 12
   sys_perf_event_open: pid 20341  cpu 4  group_fd -1  flags 0x8 = 13
   sys_perf_event_open: pid 20342  cpu 4  group_fd -1  flags 0x8 = 14
   sys_perf_event_open: pid 20341  cpu 5  group_fd -1  flags 0x8 = 15
   sys_perf_event_open: pid 20342  cpu 5  group_fd -1  flags 0x8 = 16
   sys_perf_event_open: pid 20341  cpu 6  group_fd -1  flags 0x8 = 17
   sys_perf_event_open: pid 20342  cpu 6  group_fd -1  flags 0x8 = 18
   sys_perf_event_open: pid 20341  cpu 7  group_fd -1  flags 0x8 = 19
   sys_perf_event_open: pid 20342  cpu 7  group_fd -1  flags 0x8 = 20
   <SNIP>
   libperf: mmap_per_cpu: nr cpu values 8 nr threads 2
   libperf: idx 0: mmapping fd 5
   libperf: idx 0: set output fd 6 -> 5
   libperf: idx 1: mmapping fd 7
   libperf: idx 1: set output fd 8 -> 7
   libperf: idx 2: mmapping fd 9
   libperf: idx 2: set output fd 10 -> 9
   libperf: idx 3: mmapping fd 11
   libperf: idx 3: set output fd 12 -> 11
   libperf: idx 4: mmapping fd 13
   libperf: idx 4: set output fd 14 -> 13
   libperf: idx 5: mmapping fd 15
   libperf: idx 5: set output fd 16 -> 15
   libperf: idx 6: mmapping fd 17
   libperf: idx 6: set output fd 18 -> 17
   libperf: idx 7: mmapping fd 19
   libperf: idx 7: set output fd 20 -> 19
   <SNIP>
   [ perf record: Woken up 7 times to write data ]
   [ perf record: Captured and wrote 0.020 MB perf.data (17 samples) ]

Fixes: ae4f8ae16a078964 ("libperf evlist: Allow mixing per-thread and per-cpu mmaps")
Reported-by: Tomáš Trnka <trnka@scm.com>
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=216441
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20220905114209.8389-1-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/perf/evlist.c | 50 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/tools/lib/perf/evlist.c b/tools/lib/perf/evlist.c
index e6c98a6e3908e..6b1bafe267a42 100644
--- a/tools/lib/perf/evlist.c
+++ b/tools/lib/perf/evlist.c
@@ -486,6 +486,7 @@ mmap_per_evsel(struct perf_evlist *evlist, struct perf_evlist_mmap_ops *ops,
 			if (ops->idx)
 				ops->idx(evlist, evsel, mp, idx);
 
+			pr_debug("idx %d: mmapping fd %d\n", idx, *output);
 			if (ops->mmap(map, mp, *output, evlist_cpu) < 0)
 				return -1;
 
@@ -494,6 +495,7 @@ mmap_per_evsel(struct perf_evlist *evlist, struct perf_evlist_mmap_ops *ops,
 			if (!idx)
 				perf_evlist__set_mmap_first(evlist, map, overwrite);
 		} else {
+			pr_debug("idx %d: set output fd %d -> %d\n", idx, fd, *output);
 			if (ioctl(fd, PERF_EVENT_IOC_SET_OUTPUT, *output) != 0)
 				return -1;
 
@@ -519,6 +521,48 @@ mmap_per_evsel(struct perf_evlist *evlist, struct perf_evlist_mmap_ops *ops,
 	return 0;
 }
 
+static int
+mmap_per_thread(struct perf_evlist *evlist, struct perf_evlist_mmap_ops *ops,
+		struct perf_mmap_param *mp)
+{
+	int nr_threads = perf_thread_map__nr(evlist->threads);
+	int nr_cpus    = perf_cpu_map__nr(evlist->all_cpus);
+	int cpu, thread, idx = 0;
+	int nr_mmaps = 0;
+
+	pr_debug("%s: nr cpu values (may include -1) %d nr threads %d\n",
+		 __func__, nr_cpus, nr_threads);
+
+	/* per-thread mmaps */
+	for (thread = 0; thread < nr_threads; thread++, idx++) {
+		int output = -1;
+		int output_overwrite = -1;
+
+		if (mmap_per_evsel(evlist, ops, idx, mp, 0, thread, &output,
+				   &output_overwrite, &nr_mmaps))
+			goto out_unmap;
+	}
+
+	/* system-wide mmaps i.e. per-cpu */
+	for (cpu = 1; cpu < nr_cpus; cpu++, idx++) {
+		int output = -1;
+		int output_overwrite = -1;
+
+		if (mmap_per_evsel(evlist, ops, idx, mp, cpu, 0, &output,
+				   &output_overwrite, &nr_mmaps))
+			goto out_unmap;
+	}
+
+	if (nr_mmaps != evlist->nr_mmaps)
+		pr_err("Miscounted nr_mmaps %d vs %d\n", nr_mmaps, evlist->nr_mmaps);
+
+	return 0;
+
+out_unmap:
+	perf_evlist__munmap(evlist);
+	return -1;
+}
+
 static int
 mmap_per_cpu(struct perf_evlist *evlist, struct perf_evlist_mmap_ops *ops,
 	     struct perf_mmap_param *mp)
@@ -528,6 +572,8 @@ mmap_per_cpu(struct perf_evlist *evlist, struct perf_evlist_mmap_ops *ops,
 	int nr_mmaps = 0;
 	int cpu, thread;
 
+	pr_debug("%s: nr cpu values %d nr threads %d\n", __func__, nr_cpus, nr_threads);
+
 	for (cpu = 0; cpu < nr_cpus; cpu++) {
 		int output = -1;
 		int output_overwrite = -1;
@@ -569,6 +615,7 @@ int perf_evlist__mmap_ops(struct perf_evlist *evlist,
 			  struct perf_evlist_mmap_ops *ops,
 			  struct perf_mmap_param *mp)
 {
+	const struct perf_cpu_map *cpus = evlist->all_cpus;
 	struct perf_evsel *evsel;
 
 	if (!ops || !ops->get || !ops->mmap)
@@ -588,6 +635,9 @@ int perf_evlist__mmap_ops(struct perf_evlist *evlist,
 	if (evlist->pollfd.entries == NULL && perf_evlist__alloc_pollfd(evlist) < 0)
 		return -ENOMEM;
 
+	if (perf_cpu_map__empty(cpus))
+		return mmap_per_thread(evlist, ops, mp);
+
 	return mmap_per_cpu(evlist, ops, mp);
 }
 
-- 
2.35.1



