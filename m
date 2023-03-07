Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A08E46AEA8A
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:34:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231589AbjCGRep (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:34:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231682AbjCGReb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:34:31 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05F9C8C53D
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:30:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5FAF7CE1C3D
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:30:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31024C433EF;
        Tue,  7 Mar 2023 17:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678210220;
        bh=18jRIJLzDCr8zoPutiB+f5kL17Y6zy04u6aa2FpTZ5A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bvWDUWCniCzmzsIOizxMGUXBQ80z2W0BYkYqxCszOzTLRZAVFQttgtvLkJ6eNDXxk
         cV5P8UE3oQHr6ZXQ5rp9fP09n3FgXRKdkjnHKJQMsBBm/RU/TmAP4zi8ktT3nbgNL2
         HSURH2LeirQ2WeuJcpI3GWd8Y/kgkS8gPEVRz6f8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Perry Taylor <perry.taylor@intel.com>,
        Ian Rogers <irogers@google.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Eduard Zingerman <eddyz87@gmail.com>,
        Florian Fischer <florian.fischer@muhq.space>,
        Ingo Molnar <mingo@redhat.com>,
        James Clark <james.clark@arm.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Xing Zhengjun <zhengjun.xing@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0472/1001] perf stat: Avoid merging/aggregating metric counts twice
Date:   Tue,  7 Mar 2023 17:54:04 +0100
Message-Id: <20230307170041.888315263@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ian Rogers <irogers@google.com>

[ Upstream commit 37f322cd58d81a9d46456531281c908de9ef6e42 ]

The added perf_stat_merge_counters combines uncore counters. When
metrics are enabled, the counts are merged into a metric_leader via the
stat-shadow saved_value logic. As the leader now is passed an aggregated
count, it leads to all counters being added together twice and counts
appearing approximately doubled in metrics.

This change disables the saved_value merging of counts for evsels that
are merged. It is recommended that later changes remove the saved_value
entirely as the two layers of aggregation in the code is confusing.

Fixes: 942c5593393d9418 ("perf stat: Add perf_stat_merge_counters()")
Reported-by: Perry Taylor <perry.taylor@intel.com>
Signed-off-by: Ian Rogers <irogers@google.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Eduard Zingerman <eddyz87@gmail.com>
Cc: Florian Fischer <florian.fischer@muhq.space>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@arm.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Xing Zhengjun <zhengjun.xing@linux.intel.com>
Link: https://lore.kernel.org/r/20230209064447.83733-1-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/stat-shadow.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/stat-shadow.c b/tools/perf/util/stat-shadow.c
index cadb2df23c878..4cd05d9205e3b 100644
--- a/tools/perf/util/stat-shadow.c
+++ b/tools/perf/util/stat-shadow.c
@@ -311,7 +311,7 @@ void perf_stat__update_shadow_stats(struct evsel *counter, u64 count,
 		update_stats(&v->stats, count);
 		if (counter->metric_leader)
 			v->metric_total += count;
-	} else if (counter->metric_leader) {
+	} else if (counter->metric_leader && !counter->merged_stat) {
 		v = saved_value_lookup(counter->metric_leader,
 				       map_idx, true, STAT_NONE, 0, st, rsd.cgrp);
 		v->metric_total += count;
-- 
2.39.2



