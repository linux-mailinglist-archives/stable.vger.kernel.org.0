Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40B1726F017
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:40:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729328AbgIRCkV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:40:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:37358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728659AbgIRCLk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:11:40 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C00F235F7;
        Fri, 18 Sep 2020 02:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600395099;
        bh=bb/gUJq4RN6NwT7YJAE1nX2prHerpdXbmoq/K5uzqZI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kASrVEjiaACdd75pRFYRv/rf9v6t/+M9dui6LjaJUhqwZp0iOspRQUR6eCPMUN6w0
         Np06xyith+2HmYY2R+TWvvxF1sFVbNdaB0EM0Y2QR/G3iIblpuD3w4sxDLBwaLoKD/
         iY/mRoqAahv4+uHYn6SvnmbPYzgQ+row2XrXVXOA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ian Rogers <irogers@google.com>, Andi Kleen <ak@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 179/206] perf evsel: Fix 2 memory leaks
Date:   Thu, 17 Sep 2020 22:07:35 -0400
Message-Id: <20200918020802.2065198-179-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020802.2065198-1-sashal@kernel.org>
References: <20200918020802.2065198-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ian Rogers <irogers@google.com>

[ Upstream commit 3efc899d9afb3d03604f191a0be9669eabbfc4aa ]

If allocated, perf_pkg_mask and metric_events need freeing.

Signed-off-by: Ian Rogers <irogers@google.com>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lore.kernel.org/lkml/20200512235918.10732-1-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/evsel.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index e8586957562b3..1b7b6244c8cfe 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -1291,6 +1291,8 @@ void perf_evsel__exit(struct perf_evsel *evsel)
 	zfree(&evsel->group_name);
 	zfree(&evsel->name);
 	zfree(&evsel->pmu_name);
+	zfree(&evsel->per_pkg_mask);
+	zfree(&evsel->metric_events);
 	perf_evsel__object.fini(evsel);
 }
 
-- 
2.25.1

