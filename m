Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB6C266C515
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:01:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231882AbjAPQBl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:01:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231958AbjAPQBS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:01:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5429A222D8
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:01:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 015F2B81060
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:01:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A747C433D2;
        Mon, 16 Jan 2023 16:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884874;
        bh=EXJXN2Xsxu1uilrvCdBrPZtWG02Ak5SJeVBAyKiudeU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UfQA/CaVznFUa/BOKXq+OCzPyx4lC814+llSJaKS21rCR5IPpKCvmZM+/ENgjFwpv
         xa1rvPRoKU8V9V1n7KICEje65q0jXJ2hZqOkXnHp/PIUy4wNJMYx4MRQ3IrkK+ZcCB
         1nJNY2yiITOXRa9X4LLo3YnrNlOJiTn3tDG9AWh4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Mike Leach <mike.leach@linaro.org>,
        Ian Rogers <irogers@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 165/183] perf build: Properly guard libbpf includes
Date:   Mon, 16 Jan 2023 16:51:28 +0100
Message-Id: <20230116154810.267038258@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
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

From: Ian Rogers <irogers@google.com>

[ Upstream commit d891f2b724b39a2a41e3ad7b57110193993242ff ]

Including libbpf header files should be guarded by HAVE_LIBBPF_SUPPORT.
In bpf_counter.h, move the skeleton utilities under HAVE_BPF_SKEL.

Fixes: d6a735ef3277c45f ("perf bpf_counter: Move common functions to bpf_counter.h")
Reported-by: Mike Leach <mike.leach@linaro.org>
Signed-off-by: Ian Rogers <irogers@google.com>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Tested-by: Jiri Olsa <jolsa@kernel.org>
Tested-by: Mike Leach <mike.leach@linaro.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lore.kernel.org/lkml/20230105172243.7238-1-mike.leach@linaro.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-trace.c    | 2 ++
 tools/perf/util/bpf_counter.h | 6 ++++++
 2 files changed, 8 insertions(+)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 3dcf6aed1ef7..97b17f8941dc 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -17,7 +17,9 @@
 #include "util/record.h"
 #include <traceevent/event-parse.h>
 #include <api/fs/tracing_path.h>
+#ifdef HAVE_LIBBPF_SUPPORT
 #include <bpf/bpf.h>
+#endif
 #include "util/bpf_map.h"
 #include "util/rlimit.h"
 #include "builtin.h"
diff --git a/tools/perf/util/bpf_counter.h b/tools/perf/util/bpf_counter.h
index 4dbf26408b69..c6d21c07b14c 100644
--- a/tools/perf/util/bpf_counter.h
+++ b/tools/perf/util/bpf_counter.h
@@ -4,9 +4,12 @@
 
 #include <linux/list.h>
 #include <sys/resource.h>
+
+#ifdef HAVE_LIBBPF_SUPPORT
 #include <bpf/bpf.h>
 #include <bpf/btf.h>
 #include <bpf/libbpf.h>
+#endif
 
 struct evsel;
 struct target;
@@ -87,6 +90,8 @@ static inline void set_max_rlimit(void)
 	setrlimit(RLIMIT_MEMLOCK, &rinf);
 }
 
+#ifdef HAVE_BPF_SKEL
+
 static inline __u32 bpf_link_get_id(int fd)
 {
 	struct bpf_link_info link_info = { .id = 0, };
@@ -127,5 +132,6 @@ static inline int bperf_trigger_reading(int prog_fd, int cpu)
 
 	return bpf_prog_test_run_opts(prog_fd, &opts);
 }
+#endif /* HAVE_BPF_SKEL */
 
 #endif /* __PERF_BPF_COUNTER_H */
-- 
2.35.1



