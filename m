Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCEA5658202
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:32:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234785AbiL1Qcs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:32:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232788AbiL1QcR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:32:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E939D15FD1
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:28:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 852A56157A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:28:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D732C433EF;
        Wed, 28 Dec 2022 16:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244938;
        bh=nTMhsZi4WVkvFZvGKC1VL11sThIXjHmXx5Po1IJS24c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NQgMNJIiJhAoP4xzMbMAt5gfrhffu4zjFg7qRT3Kxehp6J2bZWGiaO39Imbp8QssK
         NUVjSx1N7j8wr9GhejTHyb8LZNHtognbpbAg07xyuXEVcvm7sDxrhbGkb2NOaZlt3f
         +Tdx3PD3z7XQyg9iNIbfoPaAO+iq3WHe6dEu3r5s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ingo Molnar <mingo@kernel.org>,
        James Clark <james.clark@arm.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Xing Zhengjun <zhengjun.xing@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0765/1146] perf stat: Move common code in print_metric_headers()
Date:   Wed, 28 Dec 2022 15:38:24 +0100
Message-Id: <20221228144350.929663419@linuxfoundation.org>
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

[ Upstream commit f4e55f88da923f39f0b76edc3da3c52d0b72d429 ]

The struct perf_stat_output_ctx is set in a loop with the same values.
Move the code out of the loop and keep the loop minimal.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: James Clark <james.clark@arm.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Xing Zhengjun <zhengjun.xing@linux.intel.com>
Link: https://lore.kernel.org/r/20221107213314.3239159-5-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: fdc7d6082459 ("perf stat: Fix --metric-only --json output")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/stat-display.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/tools/perf/util/stat-display.c
+++ b/tools/perf/util/stat-display.c
@@ -1130,11 +1130,16 @@ static void print_metric_headers(struct
 				 struct evlist *evlist,
 				 const char *prefix, bool no_indent)
 {
-	struct perf_stat_output_ctx out;
 	struct evsel *counter;
 	struct outstate os = {
 		.fh = config->output
 	};
+	struct perf_stat_output_ctx out = {
+		.ctx = &os,
+		.print_metric = print_metric_header,
+		.new_line = new_line_metric,
+		.force_header = true,
+	};
 	bool first = true;
 
 		if (config->json_output && !config->interval)
@@ -1158,13 +1163,11 @@ static void print_metric_headers(struct
 	/* Print metrics headers only */
 	evlist__for_each_entry(evlist, counter) {
 		os.evsel = counter;
-		out.ctx = &os;
-		out.print_metric = print_metric_header;
+
 		if (!first && config->json_output)
 			fprintf(config->output, ", ");
 		first = false;
-		out.new_line = new_line_metric;
-		out.force_header = true;
+
 		perf_stat__print_shadow_stats(config, counter, 0,
 					      0,
 					      &out,


