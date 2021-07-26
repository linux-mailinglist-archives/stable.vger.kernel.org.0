Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 120683D5F76
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:00:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236970AbhGZPR7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:17:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:55822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237708AbhGZPQU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:16:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 644F160F57;
        Mon, 26 Jul 2021 15:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315008;
        bh=LDVjFVNKxPvG52HZem17m9EAaJJT38vADrvYMk3+CtQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iuhZ+cCpe3kXwvobYMhTeOtbYsFDmQMwc/SzU1TBqxKAodynOSYhJwD/RXKE5/46x
         zcVxGjn6tfhB0ezOzgyRtcMw85Z2XbFfed4o/sA5i7LTdzGEZ6FieJsLEBR9DN0D8C
         9KRTfkKp65t8OGW2OyPAhGhxHMXyzIPzciAeuEWM=
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
Subject: [PATCH 5.4 024/108] perf test event_update: Fix memory leak of evlist
Date:   Mon, 26 Jul 2021 17:38:25 +0200
Message-Id: <20210726153832.479714266@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153831.696295003@linuxfoundation.org>
References: <20210726153831.696295003@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Riccardo Mancini <rickyman7@gmail.com>

[ Upstream commit fc56f54f6fcd5337634f4545af6459613129b432 ]

ASan reports a memory leak when running:

  # perf test "49: Synthesize attr update"

Caused by evlist not being deleted.

This patch adds the missing evlist__delete and removes the
perf_cpu_map__put since it's already being deleted by evlist__delete.

Signed-off-by: Riccardo Mancini <rickyman7@gmail.com>
Fixes: a6e5281780d1da65 ("perf tools: Add event_update event unit type")
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lore.kernel.org/lkml/f7994ad63d248f7645f901132d208fadf9f2b7e4.1626343282.git.rickyman7@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/event_update.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/tests/event_update.c b/tools/perf/tests/event_update.c
index c727379cf20e..195b29797acc 100644
--- a/tools/perf/tests/event_update.c
+++ b/tools/perf/tests/event_update.c
@@ -119,6 +119,6 @@ int test__event_update(struct test *test __maybe_unused, int subtest __maybe_unu
 	TEST_ASSERT_VAL("failed to synthesize attr update cpus",
 			!perf_event__synthesize_event_update_cpus(&tmp.tool, evsel, process_event_cpus));
 
-	perf_cpu_map__put(evsel->core.own_cpus);
+	evlist__delete(evlist);
 	return 0;
 }
-- 
2.30.2



