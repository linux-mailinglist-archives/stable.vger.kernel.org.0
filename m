Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B0546DB98
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730611AbfGSEKG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 00:10:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:44724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731546AbfGSEKF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 00:10:05 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A5EE3218BB;
        Fri, 19 Jul 2019 04:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563509404;
        bh=CBkSy7d+E674j8wY1H4Ek5ANstwowXqLvTKGUaCkgZU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rH7Lojd4Z00gjyX7jGAkDLqtw8zNNvzMcTXCcp6jQVOgpi1Vm3F2O8RYHH9ZQxutH
         ct6SzjIeeb2Y4eB3F7tSW7NaLu4ijHsynmWcckk2061Efr+AnHTjC7WAUzpAkWHoSz
         381BHRl11gR7ICTkWEiLsMqvBU88EzThlJwdRd+U=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Leo Yan <leo.yan@linaro.org>, Jiri Olsa <jolsa@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Alexey Budankov <alexey.budankov@linux.intel.com>,
        Alexios Zavras <alexios.zavras@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Changbin Du <changbin.du@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Eric Saint-Etienne <eric.saint.etienne@oracle.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Song Liu <songliubraving@fb.com>,
        Suzuki Poulouse <suzuki.poulose@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Thomas Richter <tmricht@linux.ibm.com>,
        linux-arm-kernel@lists.infradead.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 074/101] perf session: Fix potential NULL pointer dereference found by the smatch tool
Date:   Fri, 19 Jul 2019 00:07:05 -0400
Message-Id: <20190719040732.17285-74-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719040732.17285-1-sashal@kernel.org>
References: <20190719040732.17285-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leo Yan <leo.yan@linaro.org>

[ Upstream commit f3c8d90757724982e5f07cd77d315eb64ca145ac ]

Based on the following report from Smatch, fix the potential
NULL pointer dereference check.

  tools/perf/util/session.c:1252
  dump_read() error: we previously assumed 'evsel' could be null
  (see line 1249)

  tools/perf/util/session.c
  1240 static void dump_read(struct perf_evsel *evsel, union perf_event *event)
  1241 {
  1242         struct read_event *read_event = &event->read;
  1243         u64 read_format;
  1244
  1245         if (!dump_trace)
  1246                 return;
  1247
  1248         printf(": %d %d %s %" PRIu64 "\n", event->read.pid, event->read.tid,
  1249                evsel ? perf_evsel__name(evsel) : "FAIL",
  1250                event->read.value);
  1251
  1252         read_format = evsel->attr.read_format;
                             ^^^^^^^

'evsel' could be NULL pointer, for this case this patch directly bails
out without dumping read_event.

Signed-off-by: Leo Yan <leo.yan@linaro.org>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Alexey Budankov <alexey.budankov@linux.intel.com>
Cc: Alexios Zavras <alexios.zavras@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Changbin Du <changbin.du@intel.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Eric Saint-Etienne <eric.saint.etienne@oracle.com>
Cc: Jin Yao <yao.jin@linux.intel.com>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Song Liu <songliubraving@fb.com>
Cc: Suzuki Poulouse <suzuki.poulose@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Thomas Richter <tmricht@linux.ibm.com>
Cc: linux-arm-kernel@lists.infradead.org
Link: http://lkml.kernel.org/r/20190702103420.27540-9-leo.yan@linaro.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/session.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 11086097fc9f..f016d1b330e5 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1141,6 +1141,9 @@ static void dump_read(struct perf_evsel *evsel, union perf_event *event)
 	       evsel ? perf_evsel__name(evsel) : "FAIL",
 	       event->read.value);
 
+	if (!evsel)
+		return;
+
 	read_format = evsel->attr.read_format;
 
 	if (read_format & PERF_FORMAT_TOTAL_TIME_ENABLED)
-- 
2.20.1

