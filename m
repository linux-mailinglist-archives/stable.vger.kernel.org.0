Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E0A25F2A4D
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:35:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231478AbiJCHfB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:35:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231476AbiJCHdV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:33:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E1994F640;
        Mon,  3 Oct 2022 00:21:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AD601B80E7D;
        Mon,  3 Oct 2022 07:19:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02249C433C1;
        Mon,  3 Oct 2022 07:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781580;
        bh=hcALJk6w4RJCnEaUh4SaKtByjsv5qo91nSSo7OY8+j8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zi2ApA0RrwAcEPGy+gAH4lvQt6elVKE5VLaAwc+qmzkCN9g6sutajCo4PSMCDoRmY
         oG2Lys7DcsB3oVjGWBjCR3JXuiMawkJLLFNyEx+MQCNrnDm5eiIFQP/zVffqlSR1sp
         g2Gyvcq6/ABzh+9byHPEPKrc8uVQSBdqt5r3N/Vc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ian Rogers <irogers@google.com>,
        Andi Kleen <ak@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexander Antonov <alexander.antonov@linux.intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andrew Kilroy <andrew.kilroy@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Changbin Du <changbin.du@intel.com>,
        Denys Zagorui <dzagorui@cisco.com>,
        Fabian Hemmer <copy@copy.sh>, Felix Fietkau <nbd@nbd.name>,
        Heiko Carstens <hca@linux.ibm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        John Garry <john.garry@huawei.com>,
        Kajol Jain <kjain@linux.ibm.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Kees Kook <keescook@chromium.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Nicholas Fraser <nfraser@codeweavers.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Paul Clarke <pc@us.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Riccardo Mancini <rickyman7@gmail.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        ShihCheng Tu <mrtoastcheng@gmail.com>,
        Song Liu <songliubraving@fb.com>,
        Stephane Eranian <eranian@google.com>,
        Sumanth Korikkar <sumanthk@linux.ibm.com>,
        Thomas Richter <tmricht@linux.ibm.com>,
        Wan Jiabing <wanjiabing@vivo.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 72/83] perf metric: Only add a referenced metric once
Date:   Mon,  3 Oct 2022 09:11:37 +0200
Message-Id: <20221003070723.796603884@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070721.971297651@linuxfoundation.org>
References: <20221003070721.971297651@linuxfoundation.org>
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

[ Upstream commit a3de76903dd0786a8661e9e6eb9054a7519e10e7 ]

If a metric references other metrics then the same other metrics may be
referenced more than once, but the events and metric ref are only needed
once.

An example of this is in tests/parse-metric.c where DCache_L2_Hits
references the metric DCache_L2_All_Hits twice, once directly and once
through DCache_L2_All.

Signed-off-by: Ian Rogers <irogers@google.com>
Acked-by: Andi Kleen <ak@linux.intel.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Antonov <alexander.antonov@linux.intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andrew Kilroy <andrew.kilroy@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Changbin Du <changbin.du@intel.com>
Cc: Denys Zagorui <dzagorui@cisco.com>
Cc: Fabian Hemmer <copy@copy.sh>
Cc: Felix Fietkau <nbd@nbd.name>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jacob Keller <jacob.e.keller@intel.com>
Cc: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc: Jin Yao <yao.jin@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Joakim Zhang <qiangqing.zhang@nxp.com>
Cc: John Garry <john.garry@huawei.com>
Cc: Kajol Jain <kjain@linux.ibm.com>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Kees Kook <keescook@chromium.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Nicholas Fraser <nfraser@codeweavers.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Paul Clarke <pc@us.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Riccardo Mancini <rickyman7@gmail.com>
Cc: Sami Tolvanen <samitolvanen@google.com>
Cc: ShihCheng Tu <mrtoastcheng@gmail.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: Sumanth Korikkar <sumanthk@linux.ibm.com>
Cc: Thomas Richter <tmricht@linux.ibm.com>
Cc: Wan Jiabing <wanjiabing@vivo.com>
Cc: Zhen Lei <thunder.leizhen@huawei.com>
Link: https://lore.kernel.org/r/20211015172132.1162559-9-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: 71c86cda750b ("perf parse-events: Remove "not supported" hybrid cache events")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/metricgroup.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/metricgroup.c b/tools/perf/util/metricgroup.c
index 2dc2a0dcf846..ec8195f1ab50 100644
--- a/tools/perf/util/metricgroup.c
+++ b/tools/perf/util/metricgroup.c
@@ -836,12 +836,18 @@ static int __add_metric(struct list_head *metric_list,
 		*mp = m;
 	} else {
 		/*
-		 * We got here for the referenced metric, via the
-		 * recursive metricgroup__add_metric call, add
-		 * it to the parent group.
+		 * This metric was referenced in a metric higher in the
+		 * tree. Check if the same metric is already resolved in the
+		 * metric_refs list.
 		 */
 		m = *mp;
 
+		list_for_each_entry(ref, &m->metric_refs, list) {
+			if (!strcmp(pe->metric_name, ref->metric_name))
+				return 0;
+		}
+
+		/*Add the new referenced metric to the pare the parent group. */
 		ref = malloc(sizeof(*ref));
 		if (!ref)
 			return -ENOMEM;
-- 
2.35.1



