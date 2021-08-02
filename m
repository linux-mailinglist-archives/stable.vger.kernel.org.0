Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C8AF3DDA14
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 16:06:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236399AbhHBOGH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 10:06:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:48988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237019AbhHBOE2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 10:04:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E767B6124D;
        Mon,  2 Aug 2021 13:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912679;
        bh=q1eFjOKrqN+tpgJBV14nxq5uL2vp6IrctvQiV2wGy54=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v+lNzKHMUr1TouNj89Uf7z47N3WK4f46+U2aT635XcUl0Lnnl/zKtuL7eFdTq7OpG
         ufzTUZynAMkjfpxzcNh5qHYZ/iOxwdkgiKT4dWHbmvj9lF5PcIS6rABQdGiOo+tGEq
         T5di2DjQ3J1wezXhZgDnMwhvD/1QM4ZpbyJpsENE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Garry <john.garry@huawei.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Ian Rogers <irogers@google.com>, Jiri Olsa <jolsa@redhat.com>,
        Kajol Jain <kjain@linux.ibm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.13 103/104] perf pmu: Fix alias matching
Date:   Mon,  2 Aug 2021 15:45:40 +0200
Message-Id: <20210802134347.387008080@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134344.028226640@linuxfoundation.org>
References: <20210802134344.028226640@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Garry <john.garry@huawei.com>

commit c07d5c9226980ca5ae21c6a2714baa95be2ce164 upstream.

Commit c47a5599eda324ba ("perf tools: Fix pattern matching for same
substring in different PMU type"), may have fixed some alias matching,
but has broken some others.

Firstly it cannot handle the simple scenario of PMU name in form
pmu_name{digits} - it can only handle pmu_name_{digits}.

Secondly it cannot handle more complex matching in the case where we
have multiple tokens. In this scenario, the code failed to realise that
we may examine multiple substrings in the PMU name.

Fix in two ways:

- Change perf_pmu__valid_suffix() to accept a PMU name without '_' in the
  suffix

- Only pay attention to perf_pmu__valid_suffix() for the final token

Also add const qualifiers as necessary to avoid casting.

Fixes: c47a5599eda324ba ("perf tools: Fix pattern matching for same substring in different PMU type")
Signed-off-by: John Garry <john.garry@huawei.com>
Tested-by: Jin Yao <yao.jin@linux.intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Kajol Jain <kjain@linux.ibm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lore.kernel.org/lkml/1626793819-79090-1-git-send-email-john.garry@huawei.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/util/pmu.c |   33 ++++++++++++++++++++++++---------
 1 file changed, 24 insertions(+), 9 deletions(-)

--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -742,9 +742,13 @@ struct pmu_events_map *__weak pmu_events
 	return perf_pmu__find_map(NULL);
 }
 
-static bool perf_pmu__valid_suffix(char *pmu_name, char *tok)
+/*
+ * Suffix must be in form tok_{digits}, or tok{digits}, or same as pmu_name
+ * to be valid.
+ */
+static bool perf_pmu__valid_suffix(const char *pmu_name, char *tok)
 {
-	char *p;
+	const char *p;
 
 	if (strncmp(pmu_name, tok, strlen(tok)))
 		return false;
@@ -753,12 +757,16 @@ static bool perf_pmu__valid_suffix(char
 	if (*p == 0)
 		return true;
 
-	if (*p != '_')
-		return false;
+	if (*p == '_')
+		++p;
 
-	++p;
-	if (*p == 0 || !isdigit(*p))
-		return false;
+	/* Ensure we end in a number */
+	while (1) {
+		if (!isdigit(*p))
+			return false;
+		if (*(++p) == 0)
+			break;
+	}
 
 	return true;
 }
@@ -789,12 +797,19 @@ bool pmu_uncore_alias_match(const char *
 	 *	    match "socket" in "socketX_pmunameY" and then "pmuname" in
 	 *	    "pmunameY".
 	 */
-	for (; tok; name += strlen(tok), tok = strtok_r(NULL, ",", &tmp)) {
+	while (1) {
+		char *next_tok = strtok_r(NULL, ",", &tmp);
+
 		name = strstr(name, tok);
-		if (!name || !perf_pmu__valid_suffix((char *)name, tok)) {
+		if (!name ||
+		    (!next_tok && !perf_pmu__valid_suffix(name, tok))) {
 			res = false;
 			goto out;
 		}
+		if (!next_tok)
+			break;
+		tok = next_tok;
+		name += strlen(tok);
 	}
 
 	res = true;


