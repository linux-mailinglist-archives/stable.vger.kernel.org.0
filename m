Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8442E6581FE
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:32:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234765AbiL1Qco (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:32:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234770AbiL1QcP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:32:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1662BB4
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:28:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3EB5A61578
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:28:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C62EC433EF;
        Wed, 28 Dec 2022 16:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244932;
        bh=lT21PRTjsWz741DfPiTMwmSMZiWUQ8D3kj5MDe4SUtc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q1bslcuKMxDXNYLb4yGjCpZf4g2Cl4vv+Y2qsyZwdGOcazhk/UsZU3lLPFxreGnuV
         40uzhLFQnh1tYUZ3wwypfnfCy4xWP8YC7zLh8zQesQzdKaPC82h6WxQ4VUwznjpzk6
         Q2WeH9qztwJscWgvMp8q3vstDZ0siEMupIr5rhpk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Athira Jajeev <atrajeev@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        James Clark <james.clark@arm.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Leo Yan <leo.yan@linaro.org>,
        Michael Petlan <mpetlan@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Xing Zhengjun <zhengjun.xing@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0764/1146] perf stat: Use evsel__is_hybrid() more
Date:   Wed, 28 Dec 2022 15:38:23 +0100
Message-Id: <20221228144350.900752257@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

[ Upstream commit 93d5e700156e03e66eb1bf2158ba3b8a8b354c71 ]

In the stat-display code, it needs to check if the current evsel is
hybrid but it uses perf_pmu__has_hybrid() which can return true for
non-hybrid event too.  I think it's better to use evsel__is_hybrid().

Also remove a NULL check for the 'config' parameter in the
hybrid_merge() since it's called after config->no_merge check.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Athira Jajeev <atrajeev@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: James Clark <james.clark@arm.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Leo Yan <leo.yan@linaro.org>
Cc: Michael Petlan <mpetlan@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Xing Zhengjun <zhengjun.xing@linux.intel.com>
Link: https://lore.kernel.org/r/20221018020227.85905-4-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: fdc7d6082459 ("perf stat: Fix --metric-only --json output")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/stat-display.c | 20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

diff --git a/tools/perf/util/stat-display.c b/tools/perf/util/stat-display.c
index ba66bb7fc1ca..7780742e7f4b 100644
--- a/tools/perf/util/stat-display.c
+++ b/tools/perf/util/stat-display.c
@@ -704,7 +704,7 @@ static void uniquify_event_name(struct evsel *counter)
 			counter->name = new_name;
 		}
 	} else {
-		if (perf_pmu__has_hybrid()) {
+		if (evsel__is_hybrid(counter)) {
 			ret = asprintf(&new_name, "%s/%s/",
 				       counter->pmu_name, counter->name);
 		} else {
@@ -744,26 +744,14 @@ static void collect_all_aliases(struct perf_stat_config *config, struct evsel *c
 	}
 }
 
-static bool is_uncore(struct evsel *evsel)
-{
-	struct perf_pmu *pmu = evsel__find_pmu(evsel);
-
-	return pmu && pmu->is_uncore;
-}
-
-static bool hybrid_uniquify(struct evsel *evsel)
-{
-	return perf_pmu__has_hybrid() && !is_uncore(evsel);
-}
-
 static bool hybrid_merge(struct evsel *counter, struct perf_stat_config *config,
 			 bool check)
 {
-	if (hybrid_uniquify(counter)) {
+	if (evsel__is_hybrid(counter)) {
 		if (check)
-			return config && config->hybrid_merge;
+			return config->hybrid_merge;
 		else
-			return config && !config->hybrid_merge;
+			return !config->hybrid_merge;
 	}
 
 	return false;
-- 
2.35.1



