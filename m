Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0333362805C
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:05:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237784AbiKNNFQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:05:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237782AbiKNNFP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:05:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54F4B2A427
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:05:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 05246B80EB9
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:05:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28A98C433B5;
        Mon, 14 Nov 2022 13:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668431111;
        bh=NE0GsTUBOaim1VYlZMbh1dnAce0VRbxhgvYhs+EPrOA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BI4S1ZAQBauQY86TSgc1MkW6SDpTXRtQ2g4EKyHHuft5cNIXDUpr4AxbPmtzmmBmU
         UKUdsDcd6Z0X1iSEbCj4Eg0FpYUSUAFwIkYkIyZA/mAqTkCDpyUL3sQWh43foKTZ2A
         Bx7Z1vQArSqT/0bQeyS6hhiadUdgIQL5aC9a2OO4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Namhyung Kim <namhyung@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ian Rogers <irogers@google.com>,
        James Clark <james.clark@arm.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Xing Zhengjun <zhengjun.xing@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 075/190] perf stat: Fix crash with --per-node --metric-only in CSV mode
Date:   Mon, 14 Nov 2022 13:44:59 +0100
Message-Id: <20221114124501.957299414@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
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

[ Upstream commit 84d1b2013272947ad9b13025df89226d8fa31cc5 ]

The following command will get segfault due to missing aggr_header_csv
for AGGR_NODE:

  $ sudo perf stat -a --per-node -x, --metric-only true

Committer testing:

Before this patch:

  # perf stat -a --per-node -x, --metric-only true
  Segmentation fault (core dumped)
  #

After:

  # gdb perf
  -bash: gdb: command not found
  # perf stat -a --per-node -x, --metric-only true
  node,Ghz,frontend cycles idle,backend cycles idle,insn per cycle,branch-misses of all branches,
  N0,32,0.335,2.10,0.65,0.69,0.03,1.92,
  #

Fixes: 86895b480a2f10c7 ("perf stat: Add --per-node agregation support")
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: James Clark <james.clark@arm.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Xing Zhengjun <zhengjun.xing@linux.intel.com>
Link: http://lore.kernel.org/lkml/20221107213314.3239159-2-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/stat-display.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/stat-display.c b/tools/perf/util/stat-display.c
index b82844cb0ce7..aa9d9d2936e7 100644
--- a/tools/perf/util/stat-display.c
+++ b/tools/perf/util/stat-display.c
@@ -556,7 +556,7 @@ static void printout(struct perf_stat_config *config, struct aggr_cpu_id id, int
 			[AGGR_CORE] = 2,
 			[AGGR_THREAD] = 1,
 			[AGGR_UNSET] = 0,
-			[AGGR_NODE] = 0,
+			[AGGR_NODE] = 1,
 		};
 
 		pm = config->metric_only ? print_metric_only_csv : print_metric_csv;
@@ -1126,6 +1126,7 @@ static int aggr_header_lens[] = {
 	[AGGR_SOCKET] = 12,
 	[AGGR_NONE] = 6,
 	[AGGR_THREAD] = 24,
+	[AGGR_NODE] = 6,
 	[AGGR_GLOBAL] = 0,
 };
 
@@ -1135,6 +1136,7 @@ static const char *aggr_header_csv[] = {
 	[AGGR_SOCKET] 	= 	"socket,cpus",
 	[AGGR_NONE] 	= 	"cpu,",
 	[AGGR_THREAD] 	= 	"comm-pid,",
+	[AGGR_NODE] 	= 	"node,",
 	[AGGR_GLOBAL] 	=	""
 };
 
-- 
2.35.1



