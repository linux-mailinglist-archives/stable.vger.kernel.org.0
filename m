Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 892615EA582
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 14:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239094AbiIZMGd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 08:06:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239904AbiIZMFr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 08:05:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9188B5A161;
        Mon, 26 Sep 2022 03:55:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7D9EEB80936;
        Mon, 26 Sep 2022 10:48:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3E71C433D6;
        Mon, 26 Sep 2022 10:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664189312;
        bh=ZdPKxg5UW1HEw759TXM5ScOiD9P0Pfppjo6F7MnLu3Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zIMyGLnBQKq28E89vOpFVZJwFpvRYtoMxEfIuonu3A45KPpO/P2Jm3OKk1VHTwyRV
         M/ZkfU+DlMCDHTuSAlCqsk90gZwdUmjy+IoUowmBD6C9ug7mgnoheuJePsZUs79o5y
         HlEOnnGpLiE4gERTZtY9uFDJrqrKTf+tJw4XC2x0=
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
Subject: [PATCH 5.19 145/207] perf stat: Fix BPF program section name
Date:   Mon, 26 Sep 2022 12:12:14 +0200
Message-Id: <20220926100813.001464711@linuxfoundation.org>
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

[ Upstream commit 0d77326c3369e255715ed2440a78894ccc98dd69 ]

It seems the recent libbpf got more strict about the section name.
I'm seeing a failure like this:

  $ sudo ./perf stat -a --bpf-counters --for-each-cgroup ^. sleep 1
  libbpf: prog 'on_cgrp_switch': missing BPF prog type, check ELF section name 'perf_events'
  libbpf: prog 'on_cgrp_switch': failed to load: -22
  libbpf: failed to load object 'bperf_cgroup_bpf'
  libbpf: failed to load BPF skeleton 'bperf_cgroup_bpf': -22
  Failed to load cgroup skeleton

The section name should be 'perf_event' (without the trailing 's').
Although it's related to the libbpf change, it'd be better fix the
section name in the first place.

Fixes: 944138f048f7d759 ("perf stat: Enable BPF counter with --for-each-cgroup")
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: bpf@vger.kernel.org
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Song Liu <songliubraving@fb.com>
Link: https://lore.kernel.org/r/20220916184132.1161506-2-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/bpf_skel/bperf_cgroup.bpf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/bpf_skel/bperf_cgroup.bpf.c b/tools/perf/util/bpf_skel/bperf_cgroup.bpf.c
index 292c430768b5..c72f8ad96f75 100644
--- a/tools/perf/util/bpf_skel/bperf_cgroup.bpf.c
+++ b/tools/perf/util/bpf_skel/bperf_cgroup.bpf.c
@@ -176,7 +176,7 @@ static int bperf_cgroup_count(void)
 }
 
 // This will be attached to cgroup-switches event for each cpu
-SEC("perf_events")
+SEC("perf_event")
 int BPF_PROG(on_cgrp_switch)
 {
 	return bperf_cgroup_count();
-- 
2.35.1



