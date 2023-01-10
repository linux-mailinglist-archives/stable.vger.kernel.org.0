Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C176664960
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:20:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239251AbjAJSUy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:20:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239302AbjAJSUL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:20:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30788D6C
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:18:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C10BB6182C
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:18:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4C24C433EF;
        Tue, 10 Jan 2023 18:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374687;
        bh=E6w9vkkCRK30bshLdsRm41Ouwuoy/fR5khqMNRjI+eo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k4+1DCc3SYwvLtp8Iealu0yvtYeBhEX1trrUxVH71efZnEoo1kqfoXrALZG/pqg+m
         yHPRZvMMw29GguOhf8Qqta5NK7J93TxnbhLahE70HupXZDONo1d3ZJ2SG4ygKjDxJN
         XkxnxIttvnfXjCZqfbsNxnqfsqaGWGGxlS/Wevg8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ian Rogers <irogers@google.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Song Liu <songliubraving@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 098/159] perf stat: Fix handling of unsupported cgroup events when using BPF counters
Date:   Tue, 10 Jan 2023 19:04:06 +0100
Message-Id: <20230110180021.407967863@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
References: <20230110180018.288460217@linuxfoundation.org>
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

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit 2d656b0f81b22101db0447f890e39fdd736b745e ]

When --for-each-cgroup option is used, it fails when any of events is
not supported and exits immediately.  This is not how 'perf stat'
handles unsupported events.

Let's ignore the failure and proceed with others so that the output is
similar to when BPF counters are not used:

Before:

  $ sudo ./perf stat -a --bpf-counters -e L1-icache-loads,L1-dcache-loads --for-each-cgroup system.slice,user.slice sleep 1
  Failed to open first cgroup events
  $

After it shows output similat to when --bpf-counters isn't specified:

  $ sudo ./perf stat -a --bpf-counters -e L1-icache-loads,L1-dcache-loads --for-each-cgroup system.slice,user.slice sleep 1

   Performance counter stats for 'system wide':

     <not supported>      L1-icache-loads                  system.slice
          29,892,418      L1-dcache-loads                  system.slice
     <not supported>      L1-icache-loads                  user.slice
          52,497,220      L1-dcache-loads                  user.slice
  $

Fixes: 944138f048f7d759 ("perf stat: Enable BPF counter with --for-each-cgroup")
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Song Liu <songliubraving@fb.com>
Link: https://lore.kernel.org/r/20230104064402.1551516-4-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/bpf_counter_cgroup.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/tools/perf/util/bpf_counter_cgroup.c b/tools/perf/util/bpf_counter_cgroup.c
index 3c2df7522f6f..1c82377ed78b 100644
--- a/tools/perf/util/bpf_counter_cgroup.c
+++ b/tools/perf/util/bpf_counter_cgroup.c
@@ -116,27 +116,19 @@ static int bperf_load_program(struct evlist *evlist)
 
 			/* open single copy of the events w/o cgroup */
 			err = evsel__open_per_cpu(evsel, evsel->core.cpus, -1);
-			if (err) {
-				pr_err("Failed to open first cgroup events\n");
-				goto out;
-			}
+			if (err == 0)
+				evsel->supported = true;
 
 			map_fd = bpf_map__fd(skel->maps.events);
 			perf_cpu_map__for_each_cpu(cpu, j, evsel->core.cpus) {
 				int fd = FD(evsel, j);
 				__u32 idx = evsel->core.idx * total_cpus + cpu.cpu;
 
-				err = bpf_map_update_elem(map_fd, &idx, &fd,
-							  BPF_ANY);
-				if (err < 0) {
-					pr_err("Failed to update perf_event fd\n");
-					goto out;
-				}
+				bpf_map_update_elem(map_fd, &idx, &fd, BPF_ANY);
 			}
 
 			evsel->cgrp = leader_cgrp;
 		}
-		evsel->supported = true;
 
 		if (evsel->cgrp == cgrp)
 			continue;
-- 
2.35.1



