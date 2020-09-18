Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8431426ECBD
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:16:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729076AbgIRCO0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:14:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:42140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728190AbgIRCOP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:14:15 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AACF8239E5;
        Fri, 18 Sep 2020 02:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600395254;
        bh=/XHGCzAB/FTa+gGNhK2elMfk4FIE+JYjTVaK8RQbqr0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DGsUuKeWLuBTrV5Ij1bU71e76rfVBJ15RwNAMVFBzGaT/0+eh1O/nn57zQBjj56+V
         ztLEOo3AI7iRmFg1F772yuL3FWicao0CVX5rT/vI4H+zWR3cozFnTGFR9zNSF3zKs7
         SYOlkR3Csv2K+dAjQ6YYj3G20AZ4oggcRuYW3WUY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ian Rogers <irogers@google.com>, Jiri Olsa <jolsa@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>, Leo Yan <leo.yan@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        clang-built-linux@googlegroups.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 095/127] perf parse-events: Fix memory leaks found on parse_events
Date:   Thu, 17 Sep 2020 22:11:48 -0400
Message-Id: <20200918021220.2066485-95-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918021220.2066485-1-sashal@kernel.org>
References: <20200918021220.2066485-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ian Rogers <irogers@google.com>

[ Upstream commit e8dfb81838b14f82521968343884665b996646ef ]

Fix a memory leak found by applying LLVM's libfuzzer on parse_events().

Signed-off-by: Ian Rogers <irogers@google.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Leo Yan <leo.yan@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: clang-built-linux@googlegroups.com
Link: http://lore.kernel.org/lkml/20200319023101.82458-1-irogers@google.com
[ split from a larger patch, use zfree() ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/parse-events.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 096c52f296d77..2733cdfdf04c6 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -1258,6 +1258,7 @@ static int __parse_events_add_pmu(struct parse_events_state *parse_state,
 
 		list_for_each_entry_safe(pos, tmp, &config_terms, list) {
 			list_del_init(&pos->list);
+			zfree(&pos->val.str);
 			free(pos);
 		}
 		return -EINVAL;
-- 
2.25.1

