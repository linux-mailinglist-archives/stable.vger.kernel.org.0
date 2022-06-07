Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89BAC541C93
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 00:03:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357602AbiFGWC1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 18:02:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382473AbiFGVva (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:51:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BF9023BC34;
        Tue,  7 Jun 2022 12:08:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 627C7618C9;
        Tue,  7 Jun 2022 19:08:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 482F1C385A2;
        Tue,  7 Jun 2022 19:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628931;
        bh=L6/7d3an9St0b/NgFIVefwNBWNQVxznP7DEJrhafcWc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CC1KVpWSPJlnPLj7zH8ldI8mjQ/Q7XH3NIZlkfQ7h+jjE6iaN/vXlJKC7pJ76g6g+
         OCkPbOygxFxzSURfW8J41yrdLNRy4r0TdxKW6DeNujn/n/xZAylqo/nhjwoj4wbDqU
         132pAifNo2JM3x1TLihIbI0A29RzpC7uvoB/bMMs=
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
Subject: [PATCH 5.18 509/879] perf parse-events: Support different format of the topdown event name
Date:   Tue,  7 Jun 2022 19:00:27 +0200
Message-Id: <20220607165017.648968928@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
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



