Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D030A5EA4EB
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238655AbiIZL4U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:56:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239129AbiIZLyj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:54:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B5CD4D835;
        Mon, 26 Sep 2022 03:50:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 451D9B802C7;
        Mon, 26 Sep 2022 10:48:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77956C433D6;
        Mon, 26 Sep 2022 10:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664189315;
        bh=iaB1KodNW2681CtVUDHZXZv/QS5f3KAqBTUzxLWxXwM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j/aKFhIurr/fX+Wx7+hNjUI9E/YHDx9qyCXkO2KdSdVYJgCQrrybWkOidPNZzZpbU
         eiwuHYgJTnsSp4xgQXmcxNLVNBik+mk6/2xudsV+oe9YOqE5AJKCxOqECuki7aHovl
         cAqqhOmhLJ+5aUbjD+n88NxiX7f+GTzI6UdD9UHA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>, bpf@vger.kernel.org,
        Ian Rogers <irogers@google.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Song Liu <songliubraving@fb.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 146/207] perf stat: Fix cpu map index in bperf cgroup code
Date:   Mon, 26 Sep 2022 12:12:15 +0200
Message-Id: <20220926100813.049490680@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit 3da35231d9e4949c4ae40e3ce653e7c468455d55 ]

The previous cpu map introduced a bug in the bperf cgroup counter.  This
results in a failure when user gives a partial cpu map starting from
non-zero.

  $ sudo ./perf stat -C 1-2 --bpf-counters --for-each-cgroup ^. sleep 1
  libbpf: prog 'on_cgrp_switch': failed to create BPF link for perf_event FD 0:
                                 -9 (Bad file descriptor)
  Failed to attach cgroup program

To get the FD of an evsel, it should use a map index not the CPU number.

Fixes: 0255571a16059c8e ("perf cpumap: Switch to using perf_cpu_map API")
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: bpf@vger.kernel.org
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Song Liu <songliubraving@fb.com>
Link: https://lore.kernel.org/r/20220916184132.1161506-3-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/bpf_counter_cgroup.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/bpf_counter_cgroup.c b/tools/perf/util/bpf_counter_cgroup.c
index 63b9db657442..97c69a249c6e 100644
--- a/tools/perf/util/bpf_counter_cgroup.c
+++ b/tools/perf/util/bpf_counter_cgroup.c
@@ -95,7 +95,7 @@ static int bperf_load_program(struct evlist *evlist)
 
 	perf_cpu_map__for_each_cpu(cpu, i, evlist->core.all_cpus) {
 		link = bpf_program__attach_perf_event(skel->progs.on_cgrp_switch,
-						      FD(cgrp_switch, cpu.cpu));
+						      FD(cgrp_switch, i));
 		if (IS_ERR(link)) {
 			pr_err("Failed to attach cgroup program\n");
 			err = PTR_ERR(link);
@@ -123,7 +123,7 @@ static int bperf_load_program(struct evlist *evlist)
 
 			map_fd = bpf_map__fd(skel->maps.events);
 			perf_cpu_map__for_each_cpu(cpu, j, evlist->core.all_cpus) {
-				int fd = FD(evsel, cpu.cpu);
+				int fd = FD(evsel, j);
 				__u32 idx = evsel->core.idx * total_cpus + cpu.cpu;
 
 				err = bpf_map_update_elem(map_fd, &idx, &fd,
-- 
2.35.1



