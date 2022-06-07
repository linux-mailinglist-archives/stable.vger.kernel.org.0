Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5AF55414D9
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:23:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359313AbiFGUW5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:22:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359256AbiFGUWO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:22:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08CE31451CA;
        Tue,  7 Jun 2022 11:31:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 80A05612EC;
        Tue,  7 Jun 2022 18:31:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5934FC385A2;
        Tue,  7 Jun 2022 18:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626695;
        bh=L6/7d3an9St0b/NgFIVefwNBWNQVxznP7DEJrhafcWc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DaInAJeWGIdCYXzvl6ZUNwCjU0nFtxXgWSsnbnIHc1t7ak0CL2YvH6TkA61qMee5c
         r9AZTl7w6efsf3epISH6qfQR0aw5NZ8c/bICzkaqaIT6ocT35FykVl9v8A5nKPKqwm
         kmbZdtA4gbKK+s2EsikVF3CyI7+lOHQ7Us3NmNCM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ian Rogers <irogers@google.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Xing Zhengjun <zhengjun.xing@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 431/772] perf parse-events: Support different format of the topdown event name
Date:   Tue,  7 Jun 2022 19:00:23 +0200
Message-Id: <20220607165001.702676452@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kan Liang <kan.liang@linux.intel.com>

[ Upstream commit e7d1374ed5cb346efd9b3df03814dbc0767adb4e ]

The evsel->name may have a different format for a topdown event, a pure
topdown name (e.g., topdown-fe-bound), or a PMU name + a topdown name
(e.g., cpu/topdown-fe-bound/). The cpu/topdown-fe-bound/ kind format
isn't supported by the arch_evlist__leader(). This format is a very
common format for a hybrid platform, which requires specifying the PMU
name for each event.

Without the patch,

  $ perf stat -e '{instructions,slots,cpu/topdown-fe-bound/}' -a sleep 1

   Performance counter stats for 'system wide':

       <not counted>      instructions
       <not counted>      slots
     <not supported>      cpu/topdown-fe-bound/

         1.003482041 seconds time elapsed

  Some events weren't counted. Try disabling the NMI watchdog:
          echo 0 > /proc/sys/kernel/nmi_watchdog
          perf stat ...
          echo 1 > /proc/sys/kernel/nmi_watchdog
  The events in group usually have to be from the same PMU. Try reorganizing the group.

With the patch,

  $ perf stat -e '{instructions,slots,cpu/topdown-fe-bound/}' -a sleep 1

  Performance counter stats for 'system wide':

         157,383,996      slots
          25,011,711      instructions
          27,441,686      cpu/topdown-fe-bound/

         1.003530890 seconds time elapsed

Fixes: bc355822f0d9623b ("perf parse-events: Move slots only with topdown")
Reviewed-by: Ian Rogers <irogers@google.com>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Xing Zhengjun <zhengjun.xing@linux.intel.com>
Link: https://lore.kernel.org/r/20220518143900.1493980-4-kan.liang@linux.intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/arch/x86/util/evlist.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/arch/x86/util/evlist.c b/tools/perf/arch/x86/util/evlist.c
index cfc208d71f00..75564a7df15b 100644
--- a/tools/perf/arch/x86/util/evlist.c
+++ b/tools/perf/arch/x86/util/evlist.c
@@ -36,7 +36,7 @@ struct evsel *arch_evlist__leader(struct list_head *list)
 				if (slots == first)
 					return first;
 			}
-			if (!strncasecmp(evsel->name, "topdown", 7))
+			if (strcasestr(evsel->name, "topdown"))
 				has_topdown = true;
 			if (slots && has_topdown)
 				return slots;
-- 
2.35.1



