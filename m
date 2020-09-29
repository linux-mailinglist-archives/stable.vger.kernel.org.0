Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8461A27CACB
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730766AbgI2MWJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:22:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:49122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728599AbgI2LfT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:35:19 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 988D023D38;
        Tue, 29 Sep 2020 11:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378977;
        bh=bb/gUJq4RN6NwT7YJAE1nX2prHerpdXbmoq/K5uzqZI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fovfD0dkzpBQqttRbxyEz7Yhwg3ex5cBrnXa4wf6CTbswwu3IyJVkYnA1lY2SLdLC
         sunMFY2FIwwUKR9z3/b0rMd+AWnI0+1vyRx3MCIB0ma0rd13eDliW5y9JdyP3EYqU3
         day8MG1/ybHggp4j7o3u5KSyKpdCc/v0H/iq2/YM=
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
Subject: [PATCH 4.19 178/245] perf evsel: Fix 2 memory leaks
Date:   Tue, 29 Sep 2020 13:00:29 +0200
Message-Id: <20200929105955.638854636@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105946.978650816@linuxfoundation.org>
References: <20200929105946.978650816@linuxfoundation.org>
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



