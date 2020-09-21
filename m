Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0276B272E79
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:49:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729899AbgIUQtg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:49:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:57196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729892AbgIUQtR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:49:17 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C66C2223E;
        Mon, 21 Sep 2020 16:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706956;
        bh=56QQP9g+6O2XmMH66C/WWtUkr9AqharCEqwHphoMasg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SJPXyKSY3uz3LqBYZDHBI5EDN6aSt+Oex5lK0a8bEOuTUNXmsu5nc3+2x44cZyzun
         DlktdSo9j6GNyslGJfpdLMeMqnLJ6bQrvRUMlAMkC6o8x6dPNY88eRJCCPiblaa34J
         T7pbEZ9UGCUrUlMaPUSdObidkH/eixElmz1f4cJw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Ian Rogers <irogers@google.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 41/72] perf parse-event: Fix memory leak in evsel->unit
Date:   Mon, 21 Sep 2020 18:31:20 +0200
Message-Id: <20200921163123.822831412@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921163121.870386357@linuxfoundation.org>
References: <20200921163121.870386357@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit b12eea5ad8e77f8a380a141e3db67c07432dde16 ]

The evsel->unit borrows a pointer of pmu event or alias instead of
owns a string.  But tool event (duration_time) passes a result of
strdup() caused a leak.

It was found by ASAN during metric test:

  Direct leak of 210 byte(s) in 70 object(s) allocated from:
    #0 0x7fe366fca0b5 in strdup (/lib/x86_64-linux-gnu/libasan.so.5+0x920b5)
    #1 0x559fbbcc6ea3 in add_event_tool util/parse-events.c:414
    #2 0x559fbbcc6ea3 in parse_events_add_tool util/parse-events.c:1414
    #3 0x559fbbd8474d in parse_events_parse util/parse-events.y:439
    #4 0x559fbbcc95da in parse_events__scanner util/parse-events.c:2096
    #5 0x559fbbcc95da in __parse_events util/parse-events.c:2141
    #6 0x559fbbc28555 in check_parse_id tests/pmu-events.c:406
    #7 0x559fbbc28555 in check_parse_id tests/pmu-events.c:393
    #8 0x559fbbc28555 in check_parse_cpu tests/pmu-events.c:415
    #9 0x559fbbc28555 in test_parsing tests/pmu-events.c:498
    #10 0x559fbbc0109b in run_test tests/builtin-test.c:410
    #11 0x559fbbc0109b in test_and_print tests/builtin-test.c:440
    #12 0x559fbbc03e69 in __cmd_test tests/builtin-test.c:695
    #13 0x559fbbc03e69 in cmd_test tests/builtin-test.c:807
    #14 0x559fbbc691f4 in run_builtin /home/namhyung/project/linux/tools/perf/perf.c:312
    #15 0x559fbbb071a8 in handle_internal_command /home/namhyung/project/linux/tools/perf/perf.c:364
    #16 0x559fbbb071a8 in run_argv /home/namhyung/project/linux/tools/perf/perf.c:408
    #17 0x559fbbb071a8 in main /home/namhyung/project/linux/tools/perf/perf.c:538
    #18 0x7fe366b68cc9 in __libc_start_main ../csu/libc-start.c:308

Fixes: f0fbb114e3025 ("perf stat: Implement duration_time as a proper event")
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lore.kernel.org/lkml/20200915031819.386559-6-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/parse-events.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 422ad1888e74f..759a99f723fc3 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -370,7 +370,7 @@ static int add_event_tool(struct list_head *list, int *idx,
 		return -ENOMEM;
 	evsel->tool_event = tool_event;
 	if (tool_event == PERF_TOOL_DURATION_TIME)
-		evsel->unit = strdup("ns");
+		evsel->unit = "ns";
 	return 0;
 }
 
-- 
2.25.1



