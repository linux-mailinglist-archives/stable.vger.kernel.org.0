Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3E026DB96
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387900AbfGSEKA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 00:10:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:44652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387887AbfGSEKA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 00:10:00 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4AC07218E0;
        Fri, 19 Jul 2019 04:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563509399;
        bh=bwyoA7IAqJ6r4UG32uaXr4RuYIra6u6ryBNwquHppIA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pq5iHSbF03OgU9yUA9yhRswLOYirOC9ufJ77LIo5CNHSEPG9tvIRZ5TDGzgJBfzAC
         VUNBlvroDKPMGTYs7+Y+Yf7kVSEbEmmuBuYD7iFkA3yB3Eu8C5ynCfJ9+b6DVxHnz6
         zwUfwahY7klutub13cp5LGvEYG6dHe9n6AC72Hoo=
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
Subject: [PATCH AUTOSEL 4.19 073/101] perf top: Fix potential NULL pointer dereference detected by the smatch tool
Date:   Fri, 19 Jul 2019 00:07:04 -0400
Message-Id: <20190719040732.17285-73-sashal@kernel.org>
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

[ Upstream commit 111442cfc8abdeaa7ec1407f07ef7b3e5f76654e ]

Based on the following report from Smatch, fix the potential NULL
pointer dereference check.

  tools/perf/builtin-top.c:109
  perf_top__parse_source() warn: variable dereferenced before check 'he'
  (see line 103)

  tools/perf/builtin-top.c:233
  perf_top__show_details() warn: variable dereferenced before check 'he'
  (see line 228)

  tools/perf/builtin-top.c
  101 static int perf_top__parse_source(struct perf_top *top, struct hist_entry *he)
  102 {
  103         struct perf_evsel *evsel = hists_to_evsel(he->hists);
                                                        ^^^^
  104         struct symbol *sym;
  105         struct annotation *notes;
  106         struct map *map;
  107         int err = -1;
  108
  109         if (!he || !he->ms.sym)
  110                 return -1;

This patch moves the values assignment after validating pointer 'he'.

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
Link: http://lkml.kernel.org/r/20190702103420.27540-4-leo.yan@linaro.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-top.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 33eefc33e0ea..d0733251a386 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -99,7 +99,7 @@ static void perf_top__resize(struct perf_top *top)
 
 static int perf_top__parse_source(struct perf_top *top, struct hist_entry *he)
 {
-	struct perf_evsel *evsel = hists_to_evsel(he->hists);
+	struct perf_evsel *evsel;
 	struct symbol *sym;
 	struct annotation *notes;
 	struct map *map;
@@ -108,6 +108,8 @@ static int perf_top__parse_source(struct perf_top *top, struct hist_entry *he)
 	if (!he || !he->ms.sym)
 		return -1;
 
+	evsel = hists_to_evsel(he->hists);
+
 	sym = he->ms.sym;
 	map = he->ms.map;
 
@@ -224,7 +226,7 @@ static void perf_top__record_precise_ip(struct perf_top *top,
 static void perf_top__show_details(struct perf_top *top)
 {
 	struct hist_entry *he = top->sym_filter_entry;
-	struct perf_evsel *evsel = hists_to_evsel(he->hists);
+	struct perf_evsel *evsel;
 	struct annotation *notes;
 	struct symbol *symbol;
 	int more;
@@ -232,6 +234,8 @@ static void perf_top__show_details(struct perf_top *top)
 	if (!he)
 		return;
 
+	evsel = hists_to_evsel(he->hists);
+
 	symbol = he->ms.sym;
 	notes = symbol__annotation(symbol);
 
-- 
2.20.1

