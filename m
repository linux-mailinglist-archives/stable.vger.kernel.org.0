Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80F7658302F
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:35:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242081AbiG0RfO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:35:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242563AbiG0ReY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:34:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B2D561705;
        Wed, 27 Jul 2022 09:49:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 78140B821BA;
        Wed, 27 Jul 2022 16:48:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACE1BC433D7;
        Wed, 27 Jul 2022 16:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940532;
        bh=YaFXX1Mfc+RUED/z5iG3G6u7AHYIefa00/zPTIXtQsQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y6BpHXozZ90fgrrH+N3m9EKeEk5OUlVxZ087+niMAB4z4gjQuFrde1ZzeDtHGuC5m
         Il6i5srtPK75E1u/q/YumJ1mYNKenFCtu85Oej8os6Mp9jCdQIMwFOgAcasVys0frc
         ozCMieQ8DtBdiThkkrQKy86KMkoWOKgfOwaBdRog=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kan Liang <kan.liang@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ian Rogers <irogers@google.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Thomas Richter <tmricht@linux.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 056/158] perf tests: Fix Convert perf time to TSC test for hybrid
Date:   Wed, 27 Jul 2022 18:12:00 +0200
Message-Id: <20220727161023.756075674@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161021.428340041@linuxfoundation.org>
References: <20220727161021.428340041@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit deb44a6249f696106645c63c0603eab08a6122af ]

The test does not always correctly determine the number of events for
hybrids, nor allow for more than 1 evsel when parsing.

Fix by iterating the events actually created and getting the correct
evsel for the events processed.

Fixes: d9da6f70eb235110 ("perf tests: Support 'Convert perf time to TSC' test for hybrid")
Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Jin Yao <yao.jin@linux.intel.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Thomas Richter <tmricht@linux.ibm.com>
Link: https://lore.kernel.org/r/20220713123459.24145-3-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/perf-time-to-tsc.c | 18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff --git a/tools/perf/tests/perf-time-to-tsc.c b/tools/perf/tests/perf-time-to-tsc.c
index 8d6d60173693..7c7d20fc503a 100644
--- a/tools/perf/tests/perf-time-to-tsc.c
+++ b/tools/perf/tests/perf-time-to-tsc.c
@@ -20,8 +20,6 @@
 #include "tsc.h"
 #include "mmap.h"
 #include "tests.h"
-#include "pmu.h"
-#include "pmu-hybrid.h"
 
 /*
  * Except x86_64/i386 and Arm64, other archs don't support TSC in perf.  Just
@@ -106,18 +104,8 @@ static int test__perf_time_to_tsc(struct test_suite *test __maybe_unused, int su
 
 	evlist__config(evlist, &opts, NULL);
 
-	evsel = evlist__first(evlist);
-
-	evsel->core.attr.comm = 1;
-	evsel->core.attr.disabled = 1;
-	evsel->core.attr.enable_on_exec = 0;
-
-	/*
-	 * For hybrid "cycles:u", it creates two events.
-	 * Init the second evsel here.
-	 */
-	if (perf_pmu__has_hybrid() && perf_pmu__hybrid_mounted("cpu_atom")) {
-		evsel = evsel__next(evsel);
+	/* For hybrid "cycles:u", it creates two events */
+	evlist__for_each_entry(evlist, evsel) {
 		evsel->core.attr.comm = 1;
 		evsel->core.attr.disabled = 1;
 		evsel->core.attr.enable_on_exec = 0;
@@ -170,10 +158,12 @@ static int test__perf_time_to_tsc(struct test_suite *test __maybe_unused, int su
 				goto next_event;
 
 			if (strcmp(event->comm.comm, comm1) == 0) {
+				CHECK_NOT_NULL__(evsel = evlist__event2evsel(evlist, event));
 				CHECK__(evsel__parse_sample(evsel, event, &sample));
 				comm1_time = sample.time;
 			}
 			if (strcmp(event->comm.comm, comm2) == 0) {
+				CHECK_NOT_NULL__(evsel = evlist__event2evsel(evlist, event));
 				CHECK__(evsel__parse_sample(evsel, event, &sample));
 				comm2_time = sample.time;
 			}
-- 
2.35.1



