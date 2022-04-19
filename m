Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F29EA506976
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 13:10:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231939AbiDSLNP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Apr 2022 07:13:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230010AbiDSLNO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Apr 2022 07:13:14 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A6FF13FA5
        for <stable@vger.kernel.org>; Tue, 19 Apr 2022 04:10:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650366631; x=1681902631;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=QaPprAcb/AXAPVA24ES6clfleK9CHNyjSyapvX+dVU8=;
  b=ECKgdroPhH1Dlbx8HnmXJX5b3zjOVEjtk85KMggH3IFVASRKDV6FCmmT
   O7WIQ+tmC91EeWlAO2lxUp+5PQAaCz31eFmeiK0laFj8nyC4kkjjIyyC5
   PCe3IUjAtkKs2Dbzy6uA5S/G7y7W5l6N7hGjQuILapHRAFlqPLu6lXtY5
   o3gjKTEkJ8oRT5dEWkvNh/BS2LaacbBqXwqiR6Qa/z7c89ZFw/oTcpleG
   yxu4O8GIHxWHw+KT4Ok8l1qK4WDfSTlhXd8Z64LTmy2QpOByAMYMbN7E7
   gsjrcwo4thMTAsZuiPX9sOfuE8u3gKaouvDATvAhwq0ik7NCdUB8lsZig
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10321"; a="263913343"
X-IronPort-AV: E=Sophos;i="5.90,272,1643702400"; 
   d="scan'208";a="263913343"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2022 04:10:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,272,1643702400"; 
   d="scan'208";a="657604655"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.92])
  by fmsmga002.fm.intel.com with ESMTP; 19 Apr 2022 04:10:30 -0700
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     stable@vger.kernel.org
Subject: [PATCH 5.10 5.15 5.17] perf tools: Fix segfault accessing sample_id xyarray
Date:   Tue, 19 Apr 2022 14:10:29 +0300
Message-Id: <20220419111029.118039-1-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit a668cc07f990d2ed19424d5c1a529521a9d1cee1 upstream

perf_evsel::sample_id is an xyarray which can cause a segfault when
accessed beyond its size. e.g.

  # perf record -e intel_pt// -C 1 sleep 1
  Segmentation fault (core dumped)
  #

That is happening because a dummy event is opened to capture text poke
events across all CPUs, however the mmap logic is allocating according
to the number of user_requested_cpus.

In general, perf sometimes uses the evsel cpus to open events, and
sometimes the evlist user_requested_cpus. However, it is not necessary
to determine which case is which because the opened event file
descriptors are also in an xyarray, the size of whch can be used
to correctly allocate the size of the sample_id xyarray, because there
is one ID per file descriptor.

Note, in the affected code path, perf_evsel fd array is subsequently
used to get the file descriptor for the mmap, so it makes sense for the
xyarrays to be the same size there.

Fixes: d1a177595b3a824c ("libperf: Adopt perf_evlist__mmap()/munmap() from tools/perf")
Fixes: 246eba8e9041c477 ("perf tools: Add support for PERF_RECORD_TEXT_POKE")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Acked-by: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: stable@vger.kernel.org # 5.5+
Link: https://lore.kernel.org/r/20220413114232.26914-1-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
[backport by Adrian]
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/lib/perf/evlist.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/lib/perf/evlist.c b/tools/lib/perf/evlist.c
index 17465d454a0e..f76b1a9d5a6e 100644
--- a/tools/lib/perf/evlist.c
+++ b/tools/lib/perf/evlist.c
@@ -571,7 +571,6 @@ int perf_evlist__mmap_ops(struct perf_evlist *evlist,
 {
 	struct perf_evsel *evsel;
 	const struct perf_cpu_map *cpus = evlist->cpus;
-	const struct perf_thread_map *threads = evlist->threads;
 
 	if (!ops || !ops->get || !ops->mmap)
 		return -EINVAL;
@@ -583,7 +582,7 @@ int perf_evlist__mmap_ops(struct perf_evlist *evlist,
 	perf_evlist__for_each_entry(evlist, evsel) {
 		if ((evsel->attr.read_format & PERF_FORMAT_ID) &&
 		    evsel->sample_id == NULL &&
-		    perf_evsel__alloc_id(evsel, perf_cpu_map__nr(cpus), threads->nr) < 0)
+		    perf_evsel__alloc_id(evsel, evsel->fd->max_x, evsel->fd->max_y) < 0)
 			return -ENOMEM;
 	}
 
-- 
2.25.1

