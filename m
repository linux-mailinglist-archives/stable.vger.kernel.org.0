Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 742E96DB09
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:06:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730074AbfGSEF6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 00:05:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:38652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729136AbfGSEFz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 00:05:55 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 74594218D1;
        Fri, 19 Jul 2019 04:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563509154;
        bh=DMiXV2Y3bxC3tjEsHuHMAMM5Zn2EY1lsfePC4T8uFNQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OW0nsqpFPUIlTYES4t+MLnvIzFOQHnxSGtkSsdaFhu1L3vehgRosiznK0HdIgB1fm
         sUsgF+kouIM9G6QWcRVRGi4ah8OpF+CGi+vWRP0bNsLWWeWsm9ADgJiKlEONX8NL29
         oQ+LfqsBwX7zYvySkMGs0lLP2p673vxXN/ChnY9E=
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
Subject: [PATCH AUTOSEL 5.1 099/141] perf trace: Fix potential NULL pointer dereference found by the smatch tool
Date:   Fri, 19 Jul 2019 00:02:04 -0400
Message-Id: <20190719040246.15945-99-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719040246.15945-1-sashal@kernel.org>
References: <20190719040246.15945-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leo Yan <leo.yan@linaro.org>

[ Upstream commit 7a6d49dc8cad8fa1f3d63994102af8f9ae9c859f ]

Based on the following report from Smatch, fix the potential NULL
pointer dereference check.

  tools/perf/builtin-trace.c:1044
  thread_trace__new() error: we previously assumed 'ttrace' could be
  null (see line 1041).

  tools/perf/builtin-trace.c
  1037 static struct thread_trace *thread_trace__new(void)
  1038 {
  1039         struct thread_trace *ttrace =  zalloc(sizeof(struct thread_trace));
  1040
  1041         if (ttrace)
  1042                 ttrace->files.max = -1;
  1043
  1044         ttrace->syscall_stats = intlist__new(NULL);
               ^^^^^^^^
  1045
  1046         return ttrace;
  1047 }

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
Link: http://lkml.kernel.org/r/20190702103420.27540-6-leo.yan@linaro.org
[ Just made it look like other tools/perf constructors, same end result ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-trace.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index f5b3a1e9c1dd..aca22e8f6947 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -998,10 +998,10 @@ static struct thread_trace *thread_trace__new(void)
 {
 	struct thread_trace *ttrace =  zalloc(sizeof(struct thread_trace));
 
-	if (ttrace)
+	if (ttrace) {
 		ttrace->files.max = -1;
-
-	ttrace->syscall_stats = intlist__new(NULL);
+		ttrace->syscall_stats = intlist__new(NULL);
+	}
 
 	return ttrace;
 }
-- 
2.20.1

