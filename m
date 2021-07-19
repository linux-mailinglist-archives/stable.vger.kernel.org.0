Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCB973CE3CD
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:30:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236060AbhGSPki (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:40:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:34196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239614AbhGSPgn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:36:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4442261375;
        Mon, 19 Jul 2021 16:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711442;
        bh=oyYjuBgJn0jqwb20CVcGTEeizrxHr8leaE97P9GgIlA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jYqwOh3QTGOWPfnlapPsbI3SU7qsbBsw//kmItr+R4mkQJfqSki5skIEwbbxftXII
         L2glpA6cBudOsqYcAFVveUwvRr2bqo+1xSRhzRjdWIVT7XdXQaUllRLhqM0vCoo8HQ
         C/RrwxbL7ctserCKuVF5WFS80te0XJ7Qmbb4rIEY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jin Yao <yao.jin@linux.intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Agustin Vega-Frias <agustinv@codeaurora.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 348/351] perf tools: Fix pattern matching for same substring in different PMU type
Date:   Mon, 19 Jul 2021 16:54:54 +0200
Message-Id: <20210719144956.583464953@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jin Yao <yao.jin@linux.intel.com>

[ Upstream commit c47a5599eda324bacdacd125227a0925d6c50fbe ]

Some different PMU types may have the same substring. For example, on
Icelake server we have PMU types "uncore_imc" and
"uncore_imc_free_running". Both PMU types have the substring
"uncore_imc".  But the parser wrongly thinks they are the same PMU type.

We enable an imc event,
perf stat -e uncore_imc/event=0xe3/ -a -- sleep 1

Perf actually expands the event to:

  uncore_imc_0/event=0xe3/
  uncore_imc_1/event=0xe3/
  uncore_imc_2/event=0xe3/
  uncore_imc_3/event=0xe3/
  uncore_imc_4/event=0xe3/
  uncore_imc_5/event=0xe3/
  uncore_imc_6/event=0xe3/
  uncore_imc_7/event=0xe3/
  uncore_imc_free_running_0/event=0xe3/
  uncore_imc_free_running_1/event=0xe3/
  uncore_imc_free_running_3/event=0xe3/
  uncore_imc_free_running_4/event=0xe3/

That's because the "uncore_imc_free_running" matches the
pattern "uncore_imc*".

Now we check that the last characters of PMU name is '_<digit>'.

For example, for pattern "uncore_imc*", "uncore_imc_0" is parsed ok, but
"uncore_imc_free_running_0" fails.

Fixes: b2b9d3a3f0211c5d ("perf pmu: Support wildcards on pmu name in dynamic pmu events")
Signed-off-by: Jin Yao <yao.jin@linux.intel.com>
Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Agustin Vega-Frias <agustinv@codeaurora.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lore.kernel.org/lkml/20210701064253.1175-1-yao.jin@linux.intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/parse-events.y |  2 +-
 tools/perf/util/pmu.c          | 36 +++++++++++++++++++++++++++++++++-
 tools/perf/util/pmu.h          |  1 +
 3 files changed, 37 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/parse-events.y b/tools/perf/util/parse-events.y
index aba12a4d488e..9321bd0e2f76 100644
--- a/tools/perf/util/parse-events.y
+++ b/tools/perf/util/parse-events.y
@@ -316,7 +316,7 @@ event_pmu_name opt_pmu_config
 			if (!strncmp(name, "uncore_", 7) &&
 			    strncmp($1, "uncore_", 7))
 				name += 7;
-			if (!fnmatch(pattern, name, 0)) {
+			if (!perf_pmu__match(pattern, name, $1)) {
 				if (parse_events_copy_term_list(orig_terms, &terms))
 					CLEANUP_YYABORT;
 				if (!parse_events_add_pmu(_parse_state, list, pmu->name, terms, true, false))
diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index 88c8ecdc60b0..44b90d638ad5 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -3,6 +3,7 @@
 #include <linux/compiler.h>
 #include <linux/string.h>
 #include <linux/zalloc.h>
+#include <linux/ctype.h>
 #include <subcmd/pager.h>
 #include <sys/types.h>
 #include <errno.h>
@@ -17,6 +18,7 @@
 #include <locale.h>
 #include <regex.h>
 #include <perf/cpumap.h>
+#include <fnmatch.h>
 #include "debug.h"
 #include "evsel.h"
 #include "pmu.h"
@@ -740,6 +742,27 @@ struct pmu_events_map *__weak pmu_events_map__find(void)
 	return perf_pmu__find_map(NULL);
 }
 
+static bool perf_pmu__valid_suffix(char *pmu_name, char *tok)
+{
+	char *p;
+
+	if (strncmp(pmu_name, tok, strlen(tok)))
+		return false;
+
+	p = pmu_name + strlen(tok);
+	if (*p == 0)
+		return true;
+
+	if (*p != '_')
+		return false;
+
+	++p;
+	if (*p == 0 || !isdigit(*p))
+		return false;
+
+	return true;
+}
+
 bool pmu_uncore_alias_match(const char *pmu_name, const char *name)
 {
 	char *tmp = NULL, *tok, *str;
@@ -768,7 +791,7 @@ bool pmu_uncore_alias_match(const char *pmu_name, const char *name)
 	 */
 	for (; tok; name += strlen(tok), tok = strtok_r(NULL, ",", &tmp)) {
 		name = strstr(name, tok);
-		if (!name) {
+		if (!name || !perf_pmu__valid_suffix((char *)name, tok)) {
 			res = false;
 			goto out;
 		}
@@ -1872,3 +1895,14 @@ bool perf_pmu__has_hybrid(void)
 
 	return !list_empty(&perf_pmu__hybrid_pmus);
 }
+
+int perf_pmu__match(char *pattern, char *name, char *tok)
+{
+	if (fnmatch(pattern, name, 0))
+		return -1;
+
+	if (tok && !perf_pmu__valid_suffix(name, tok))
+		return -1;
+
+	return 0;
+}
diff --git a/tools/perf/util/pmu.h b/tools/perf/util/pmu.h
index a790ef758171..926da483a141 100644
--- a/tools/perf/util/pmu.h
+++ b/tools/perf/util/pmu.h
@@ -133,5 +133,6 @@ void perf_pmu__warn_invalid_config(struct perf_pmu *pmu, __u64 config,
 				   char *name);
 
 bool perf_pmu__has_hybrid(void);
+int perf_pmu__match(char *pattern, char *name, char *tok);
 
 #endif /* __PMU_H */
-- 
2.30.2



