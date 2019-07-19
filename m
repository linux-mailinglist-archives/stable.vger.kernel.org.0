Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7F506DA4E
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:01:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729323AbfGSEBI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 00:01:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:32796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729317AbfGSEBH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 00:01:07 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA3AB218BA;
        Fri, 19 Jul 2019 04:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563508866;
        bh=DFafnbAHopfkugyR/u2EBGYtfhirSvbWGoa3dRt0uaQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gz6+rTugbr1rNkKcKRCTMm8M5FYcrGPBQY0x3zX7kHzpj796ssfuh96kvF4Z3lZsa
         L3j74SKhGFm49IS3l50DSjlEia7G3RaCi/iLmjP0PVlgxXpWgfA8kU/o+D3fhwZJfJ
         vjaxOf5Gjad/BdghK2z/6FRynE+dfwS5b6pRnvJ4=
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
Subject: [PATCH AUTOSEL 5.2 128/171] perf map: Fix potential NULL pointer dereference found by smatch tool
Date:   Thu, 18 Jul 2019 23:55:59 -0400
Message-Id: <20190719035643.14300-128-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719035643.14300-1-sashal@kernel.org>
References: <20190719035643.14300-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leo Yan <leo.yan@linaro.org>

[ Upstream commit 363bbaef63ffebcc745239fe80a953ebb5ac9ec9 ]

Based on the following report from Smatch, fix the potential NULL
pointer dereference check.

  tools/perf/util/map.c:479
  map__fprintf_srccode() error: we previously assumed 'state' could be
  null (see line 466)

  tools/perf/util/map.c
  465         /* Avoid redundant printing */
  466         if (state &&
  467             state->srcfile &&
  468             !strcmp(state->srcfile, srcfile) &&
  469             state->line == line) {
  470                 free(srcfile);
  471                 return 0;
  472         }
  473
  474         srccode = find_sourceline(srcfile, line, &len);
  475         if (!srccode)
  476                 goto out_free_line;
  477
  478         ret = fprintf(fp, "|%-8d %.*s", line, len, srccode);
  479         state->srcfile = srcfile;
              ^^^^^^^
  480         state->line = line;
              ^^^^^^^

This patch validates 'state' pointer before access its elements.

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
Fixes: dd2e18e9ac20 ("perf tools: Support 'srccode' output")
Link: http://lkml.kernel.org/r/20190702103420.27540-8-leo.yan@linaro.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/map.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index ee71efb9db62..9c81ee092784 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -470,8 +470,11 @@ int map__fprintf_srccode(struct map *map, u64 addr,
 		goto out_free_line;
 
 	ret = fprintf(fp, "|%-8d %.*s", line, len, srccode);
-	state->srcfile = srcfile;
-	state->line = line;
+
+	if (state) {
+		state->srcfile = srcfile;
+		state->line = line;
+	}
 	return ret;
 
 out_free_line:
-- 
2.20.1

