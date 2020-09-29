Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F11C27C7ED
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:58:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730470AbgI2Lmv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:42:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:39990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729009AbgI2Lm3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:42:29 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D4C22065C;
        Tue, 29 Sep 2020 11:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379748;
        bh=6XU8vPkSLEwOa1GUgEOWTxPjC+wNJ5n4jec0uDYGkig=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ArA+8sDzXGm2xQKdo5C6IsNpGgzaf+tuYA7Vyiv8aW0tJHwwNmebWp4Pt11OnXKbr
         WGNp9BzCsMl/qg0GLlsEORYl+xepsDsqLSSRQ8lPDVkx6inWUnA2taeoMTrpIYn4Yg
         rxVIoCJE4qMIkQXOKY21Y5dbbb4NvE9QbtCEO2B4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ian Rogers <irogers@google.com>,
        Andi Kleen <ak@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 283/388] perf evsel: Fix 2 memory leaks
Date:   Tue, 29 Sep 2020 13:00:14 +0200
Message-Id: <20200929110024.155885413@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 12b1755b136d3..9dd9e3f4ef591 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -1255,6 +1255,8 @@ void perf_evsel__exit(struct evsel *evsel)
 	zfree(&evsel->group_name);
 	zfree(&evsel->name);
 	zfree(&evsel->pmu_name);
+	zfree(&evsel->per_pkg_mask);
+	zfree(&evsel->metric_events);
 	perf_evsel__object.fini(evsel);
 }
 
-- 
2.25.1



