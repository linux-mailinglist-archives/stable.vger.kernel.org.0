Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 294DF3D61C4
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:14:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233754AbhGZPc4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:32:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:41424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237889AbhGZP32 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:29:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD4BD6108B;
        Mon, 26 Jul 2021 16:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315759;
        bh=t5MaalEEDiyRQpeumLbYQ0LeJcE8JWiAg4nqGyxTB0M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K113LDGPsmYvyoP6WEtIxoPB3DAoQoD0aAZCsz6hH7U0+h8SAnR1Tlu55mYlhV8Y2
         7BWfIrvVp9Pr7hfg6MNnaAI1L03F5CWaGhS0SW4NQ1wtRyDmI+Ts0TcNjHQZ8ezpC1
         NLo360/hRacSHYORhua4+pClWxwMW823Kv7ppHBg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Riccardo Mancini <rickyman7@gmail.com>,
        Ian Rogers <irogers@google.com>, Jiri Olsa <jolsa@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 055/223] perf test event_update: Fix memory leak of unit
Date:   Mon, 26 Jul 2021 17:37:27 +0200
Message-Id: <20210726153848.063006572@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Riccardo Mancini <rickyman7@gmail.com>

[ Upstream commit dccfca926c351ba0893af4c8b481477bdb2881a4 ]

ASan reports a memory leak while running:

  # perf test "49: Synthesize attr update"

Caused by a string being duplicated but never freed.

This patch adds the missing free().

Note that evsel->unit is not deallocated together with evsel since it is
supposed to be a constant string.

Signed-off-by: Riccardo Mancini <rickyman7@gmail.com>
Fixes: a6e5281780d1da65 ("perf tools: Add event_update event unit type")
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lore.kernel.org/lkml/1fbc8158663fb0d4d5392e36bae564f6ad60be3c.1626343282.git.rickyman7@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/event_update.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/perf/tests/event_update.c b/tools/perf/tests/event_update.c
index 932ab0740d11..44a50527f9d9 100644
--- a/tools/perf/tests/event_update.c
+++ b/tools/perf/tests/event_update.c
@@ -88,6 +88,7 @@ int test__event_update(struct test *test __maybe_unused, int subtest __maybe_unu
 	struct evsel *evsel;
 	struct event_name tmp;
 	struct evlist *evlist = evlist__new_default();
+	char *unit = strdup("KRAVA");
 
 	TEST_ASSERT_VAL("failed to get evlist", evlist);
 
@@ -98,7 +99,7 @@ int test__event_update(struct test *test __maybe_unused, int subtest __maybe_unu
 
 	perf_evlist__id_add(&evlist->core, &evsel->core, 0, 0, 123);
 
-	evsel->unit = strdup("KRAVA");
+	evsel->unit = unit;
 
 	TEST_ASSERT_VAL("failed to synthesize attr update unit",
 			!perf_event__synthesize_event_update_unit(NULL, evsel, process_event_unit));
@@ -118,6 +119,7 @@ int test__event_update(struct test *test __maybe_unused, int subtest __maybe_unu
 	TEST_ASSERT_VAL("failed to synthesize attr update cpus",
 			!perf_event__synthesize_event_update_cpus(&tmp.tool, evsel, process_event_cpus));
 
+	free(unit);
 	evlist__delete(evlist);
 	return 0;
 }
-- 
2.30.2



