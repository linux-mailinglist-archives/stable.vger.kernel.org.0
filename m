Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A01779663
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390083AbfG2TvU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:51:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:42586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403846AbfG2TvT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:51:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E6BF21773;
        Mon, 29 Jul 2019 19:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429878;
        bh=WC/j/sIjThtlobfzS6nVKzO7mZHYA9bZW6rokSFNWWI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P0m1GikyM10M2aFm7plIQWVIjAqqWOestowzb4NVULm5EjLajk4EyznbR6/FW6Odr
         OuPcU0kFaYbZaQtWFRpPHhhUhBG6dMkFIWYZfKXxtW5RPv2z7Alr744rX5wflYJukz
         +xvbr/6S7KvxE5Z0392m/Jg8DiY4zU7FlK77wg7E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leo Yan <leo.yan@linaro.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Alexey Budankov <alexey.budankov@linux.intel.com>,
        Alexios Zavras <alexios.zavras@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Changbin Du <changbin.du@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
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
Subject: [PATCH 5.2 125/215] perf map: Fix potential NULL pointer dereference found by smatch tool
Date:   Mon, 29 Jul 2019 21:22:01 +0200
Message-Id: <20190729190800.952187231@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190739.971253303@linuxfoundation.org>
References: <20190729190739.971253303@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



