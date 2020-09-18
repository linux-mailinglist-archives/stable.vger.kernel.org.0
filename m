Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F15226EEC1
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727450AbgIRCal (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:30:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:42776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729105AbgIRCOe (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:14:34 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3E3A235F9;
        Fri, 18 Sep 2020 02:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600395274;
        bh=/G49LB43JSt49hW9SPXAELq6kzohbtmxMKQDZYyFeI4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=owRycwncwgsLSi3NSkLwmkMSUYwsz2sC9WCVyp7klk6A1ZzHaH/yxTfkvWWC+6ijv
         w7JL3Y0ObX1yVycHhZK/32xCNt5r3Yab6BiwqE4u0QlTkPToTbGoMA4Kq6skN5uUxd
         XA4afJ5dYHxLbQITxSQmtCMjSlDygnDmvPx2c8Lc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ian Rogers <irogers@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        clang-built-linux@googlegroups.com, Jiri Olsa <jolsa@kernel.org>,
        Leo Yan <leo.yan@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 112/127] perf parse-events: Fix incorrect conversion of 'if () free()' to 'zfree()'
Date:   Thu, 17 Sep 2020 22:12:05 -0400
Message-Id: <20200918021220.2066485-112-sashal@kernel.org>
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

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 7fcdccd4237724931d9773d1e3039bfe053a6f52 ]

When applying a patch by Ian I incorrectly converted to zfree() an
expression that involved testing some other struct member, not the one
being freed, which lead to bugs reproduceable by:

  $ perf stat -e i/bs,tsc,L2/o sleep 1
  WARNING: multiple event parsing errors
  Segmentation fault (core dumped)
  $

Fix it by restoring the test for pos->free_str before freeing
pos->val.str, but continue using zfree(&pos->val.str) to set that member
to NULL after freeing it.

Reported-by: Ian Rogers <irogers@google.com>
Fixes: e8dfb81838b1 ("perf parse-events: Fix memory leaks found on parse_events")
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: clang-built-linux@googlegroups.com
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Leo Yan <leo.yan@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/parse-events.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 2733cdfdf04c6..ba973bdfaa657 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -1258,7 +1258,8 @@ static int __parse_events_add_pmu(struct parse_events_state *parse_state,
 
 		list_for_each_entry_safe(pos, tmp, &config_terms, list) {
 			list_del_init(&pos->list);
-			zfree(&pos->val.str);
+			if (pos->free_str)
+				zfree(&pos->val.str);
 			free(pos);
 		}
 		return -EINVAL;
-- 
2.25.1

