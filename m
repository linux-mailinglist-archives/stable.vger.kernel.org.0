Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3208D5F2A04
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:29:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231217AbiJCH3c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:29:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231396AbiJCH3C (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:29:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5543140CC;
        Mon,  3 Oct 2022 00:19:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E343AB8058E;
        Mon,  3 Oct 2022 07:19:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F5F8C433D6;
        Mon,  3 Oct 2022 07:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781588;
        bh=Ziz5AkeJLzdodRtgDtJK0okB+h7CejTTfQ1EpE9S5sI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eLbi+8CfNX3hB4cUoXNu+vEv5VYfIyGdF5s89dr7kYjGaTW7MVQHgO67q5E86635u
         6+6N6rX91hW9ngWwzD4DduD6aKEgRVhPkurgKpbyYDOGrFqobVmQc0y3MpXAs6HKsE
         KiN2uLqXyKoEoIV0XH1TRXlH7wD1asYecS22pfd0=
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
Subject: [PATCH 5.15 75/83] perf parse-events: Identify broken modifiers
Date:   Mon,  3 Oct 2022 09:11:40 +0200
Message-Id: <20221003070723.875461580@linuxfoundation.org>
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

[ Upstream commit eabd4523395e4a8f2b049165642801f2ab8ff893 ]

Previously the broken modifier causes a usage message to printed but
nothing else.

After:

  $ perf stat -e 'cycles:kk' -a sleep 2
  event syntax error: 'cycles:kk'
                              \___ Bad modifier
  Run 'perf list' for a list of valid events

   Usage: perf stat [<options>] [<command>]

      -e, --event <event>   event selector. use 'perf list' to list available events

  $ perf stat -e '{instructions,cycles}:kk' -a sleep 2
  event syntax error: '..ns,cycles}:kk'
                                    \___ Bad modifier
  Run 'perf list' for a list of valid events

   Usage: perf stat [<options>] [<command>]

      -e, --event <event>   event selector. use 'perf list' to list available events

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
Link: https://lore.kernel.org/r/20211015172132.1162559-21-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: 71c86cda750b ("perf parse-events: Remove "not supported" hybrid cache events")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/parse-events.y | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/tools/perf/util/parse-events.y b/tools/perf/util/parse-events.y
index d94e48e1ff9b..467a426205a0 100644
--- a/tools/perf/util/parse-events.y
+++ b/tools/perf/util/parse-events.y
@@ -183,6 +183,11 @@ group_def ':' PE_MODIFIER_EVENT
 	err = parse_events__modifier_group(list, $3);
 	free($3);
 	if (err) {
+		struct parse_events_state *parse_state = _parse_state;
+		struct parse_events_error *error = parse_state->error;
+
+		parse_events__handle_error(error, @3.first_column,
+					   strdup("Bad modifier"), NULL);
 		free_list_evsel(list);
 		YYABORT;
 	}
@@ -240,6 +245,11 @@ event_name PE_MODIFIER_EVENT
 	err = parse_events__modifier_event(list, $2, false);
 	free($2);
 	if (err) {
+		struct parse_events_state *parse_state = _parse_state;
+		struct parse_events_error *error = parse_state->error;
+
+		parse_events__handle_error(error, @2.first_column,
+					   strdup("Bad modifier"), NULL);
 		free_list_evsel(list);
 		YYABORT;
 	}
-- 
2.35.1



