Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0699A582E32
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:10:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237122AbiG0RJ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:09:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241487AbiG0RIy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:08:54 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D127D4D153;
        Wed, 27 Jul 2022 09:40:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CC100CE22F9;
        Wed, 27 Jul 2022 16:40:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8996EC433C1;
        Wed, 27 Jul 2022 16:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940040;
        bh=9YoCgJ40rzOqNOclYBRcgD4FzYAA8Mvm+m3wKZjwpPE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hdnNKzkDXsiZ06lgdBBzwIcZ+EcK+3mitbxol4e0C46SAnXPmXX7rYiZQEqYlDfJm
         HIqkwir5qJLTfRJJu5AZ8Zk/Pfq6g8HqFGRVHdbrCWd1PBC1Q55VRfg67uwfV6kEnM
         78xJMylC+wfVxh57zGhzW6Hmf2joLIxqyiaNynqs=
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
Subject: [PATCH 5.15 084/201] perf tests: Fix Convert perf time to TSC test for hybrid
Date:   Wed, 27 Jul 2022 18:09:48 +0200
Message-Id: <20220727161031.227950259@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161026.977588183@linuxfoundation.org>
References: <20220727161026.977588183@linuxfoundation.org>
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
index 7c56bc1f4cff..89d25befb171 100644
--- a/tools/perf/tests/perf-time-to-tsc.c
+++ b/tools/perf/tests/perf-time-to-tsc.c
@@ -20,8 +20,6 @@
 #include "tsc.h"
 #include "mmap.h"
 #include "tests.h"
-#include "pmu.h"
-#include "pmu-hybrid.h"
 
 #define CHECK__(x) {				\
 	while ((x) < 0) {			\
@@ -84,18 +82,8 @@ int test__perf_time_to_tsc(struct test *test __maybe_unused, int subtest __maybe
 
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
@@ -141,10 +129,12 @@ int test__perf_time_to_tsc(struct test *test __maybe_unused, int subtest __maybe
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



