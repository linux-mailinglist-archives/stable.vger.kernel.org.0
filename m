Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 780735F298A
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:21:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230369AbiJCHVQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:21:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230310AbiJCHU0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:20:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6177345055;
        Mon,  3 Oct 2022 00:15:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2BCCAB80E6F;
        Mon,  3 Oct 2022 07:15:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64550C433C1;
        Mon,  3 Oct 2022 07:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781302;
        bh=H8NSv4Yp6M0l5IM5gn6zFbLZ8bwMJjfE/e6JlieoE6U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vDSOkY9UKW2dF7xcgWUqldVwPVhMWTzgsPfy1WZ6OSYlwnISDR9uHZP8kHXhXO8NN
         3kBqEs6zwoSoIGyJWvB68TVtceJ7poI62NkBGPNDXP4TDsoBRJN5Yx3HxqM4+VBR48
         NXpsyNu4APlVeNQJGvGlnglLU/SQZOxmWTd8GItk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yi Ammy <ammy.yi@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Xing Zhengjun <zhengjun.xing@linux.intel.com>,
        Ian Rogers <irogers@google.com>,
        Alexander Shishkin <alexander.shishkin@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 071/101] perf print-events: Fix "perf list" can not display the PMU prefix for some hybrid cache events
Date:   Mon,  3 Oct 2022 09:11:07 +0200
Message-Id: <20221003070726.234620614@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070724.490989164@linuxfoundation.org>
References: <20221003070724.490989164@linuxfoundation.org>
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

From: Zhengjun Xing <zhengjun.xing@linux.intel.com>

[ Upstream commit e28c07871c3f2107e316c2590d4703496bd114f4 ]

Some hybrid hardware cache events are only available on one CPU PMU. For
example, 'L1-dcache-load-misses' is only available on cpu_core.

We have supported in the perf list clearly reporting this info, the
function works fine before but recently the argument "config" in API
is_event_supported() is changed from "u64" to "unsigned int" which
caused a regression, the "perf list" then can not display the PMU prefix
for some hybrid cache events.

For the hybrid systems, the PMU type ID is stored at config[63:32],
define config to "unsigned int" will miss the PMU type ID information,
then the regression happened, the config should be defined as "u64".

Before:
 # ./perf list |grep "Hardware cache event"
  L1-dcache-load-misses                              [Hardware cache event]
  L1-dcache-loads                                    [Hardware cache event]
  L1-dcache-stores                                   [Hardware cache event]
  L1-icache-load-misses                              [Hardware cache event]
  L1-icache-loads                                    [Hardware cache event]
  LLC-load-misses                                    [Hardware cache event]
  LLC-loads                                          [Hardware cache event]
  LLC-store-misses                                   [Hardware cache event]
  LLC-stores                                         [Hardware cache event]
  branch-load-misses                                 [Hardware cache event]
  branch-loads                                       [Hardware cache event]
  dTLB-load-misses                                   [Hardware cache event]
  dTLB-loads                                         [Hardware cache event]
  dTLB-store-misses                                  [Hardware cache event]
  dTLB-stores                                        [Hardware cache event]
  iTLB-load-misses                                   [Hardware cache event]
  node-load-misses                                   [Hardware cache event]
  node-loads                                         [Hardware cache event]

After:
 # ./perf list |grep "Hardware cache event"
  L1-dcache-loads                                    [Hardware cache event]
  L1-dcache-stores                                   [Hardware cache event]
  L1-icache-load-misses                              [Hardware cache event]
  LLC-load-misses                                    [Hardware cache event]
  LLC-loads                                          [Hardware cache event]
  LLC-store-misses                                   [Hardware cache event]
  LLC-stores                                         [Hardware cache event]
  branch-load-misses                                 [Hardware cache event]
  branch-loads                                       [Hardware cache event]
  cpu_atom/L1-icache-loads/                          [Hardware cache event]
  cpu_core/L1-dcache-load-misses/                    [Hardware cache event]
  cpu_core/node-load-misses/                         [Hardware cache event]
  cpu_core/node-loads/                               [Hardware cache event]
  dTLB-load-misses                                   [Hardware cache event]
  dTLB-loads                                         [Hardware cache event]
  dTLB-store-misses                                  [Hardware cache event]
  dTLB-stores                                        [Hardware cache event]
  iTLB-load-misses                                   [Hardware cache event]

Fixes: 9b7c7728f4e4ba8d ("perf parse-events: Break out tracepoint and printing")
Reported-by: Yi Ammy <ammy.yi@intel.com>
Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Xing Zhengjun <zhengjun.xing@linux.intel.com>
Acked-by: Ian Rogers <irogers@google.com>
Cc: Alexander Shishkin <alexander.shishkin@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20220923030013.3726410-1-zhengjun.xing@linux.intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: 71c86cda750b ("perf parse-events: Remove "not supported" hybrid cache events")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/print-events.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/print-events.c b/tools/perf/util/print-events.c
index ba1ab5134685..04050d4f6db8 100644
--- a/tools/perf/util/print-events.c
+++ b/tools/perf/util/print-events.c
@@ -239,7 +239,7 @@ void print_sdt_events(const char *subsys_glob, const char *event_glob,
 	strlist__delete(sdtlist);
 }
 
-static bool is_event_supported(u8 type, unsigned int config)
+static bool is_event_supported(u8 type, u64 config)
 {
 	bool ret = true;
 	int open_return;
-- 
2.35.1



