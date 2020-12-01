Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1AD62C9C09
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:17:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390321AbgLAJOd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:14:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:52992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390239AbgLAJOb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:14:31 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ECB982223C;
        Tue,  1 Dec 2020 09:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606814024;
        bh=pA0m0jkbOCzU5bh5FAGnoqQXen6yNmWLvEAHfCOqdYA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VDMov7KTFIjoJwtBSXGIAfZz64QXYS2DsZimIupMdPfLqHjgn+z8fszbOBVQRpgsl
         OejTS/9W/0azjofTgk3yu0wYVmQ8uK7ONTngTUnj0T1IArBJNVBDLjIY9Hh54B5kjH
         cGfRr/1xGqRsVnl+CifoaaBajY2J1MMpYEk5k1zY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sam Xi <xyzsam@google.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Andi Kleen <ak@linux.intel.com>, Jiri Olsa <jolsa@redhat.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Ian Rogers <irogers@google.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 139/152] perf stat: Use proper cpu for shadow stats
Date:   Tue,  1 Dec 2020 09:54:14 +0100
Message-Id: <20201201084730.009168866@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084711.707195422@linuxfoundation.org>
References: <20201201084711.707195422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit c0ee1d5ae8c8650031badcfca6483a28c0f94f38 ]

Currently perf stat shows some metrics (like IPC) for defined events.
But when no aggregation mode is used (-A option), it shows incorrect
values since it used a value from a different cpu.

Before:

  $ perf stat -aA -e cycles,instructions sleep 1

   Performance counter stats for 'system wide':

  CPU0      116,057,380      cycles
  CPU1       86,084,722      cycles
  CPU2       99,423,125      cycles
  CPU3       98,272,994      cycles
  CPU0       53,369,217      instructions      #    0.46  insn per cycle
  CPU1       33,378,058      instructions      #    0.29  insn per cycle
  CPU2       58,150,086      instructions      #    0.50  insn per cycle
  CPU3       40,029,703      instructions      #    0.34  insn per cycle

       1.001816971 seconds time elapsed

So the IPC for CPU1 should be 0.38 (= 33,378,058 / 86,084,722)
but it was 0.29 (= 33,378,058 / 116,057,380) and so on.

After:

  $ perf stat -aA -e cycles,instructions sleep 1

   Performance counter stats for 'system wide':

  CPU0      109,621,384      cycles
  CPU1      159,026,454      cycles
  CPU2       99,460,366      cycles
  CPU3      124,144,142      cycles
  CPU0       44,396,706      instructions      #    0.41  insn per cycle
  CPU1      120,195,425      instructions      #    0.76  insn per cycle
  CPU2       44,763,978      instructions      #    0.45  insn per cycle
  CPU3       69,049,079      instructions      #    0.56  insn per cycle

       1.001910444 seconds time elapsed

Fixes: 44d49a600259 ("perf stat: Support metrics in --per-core/socket mode")
Reported-by: Sam Xi <xyzsam@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lore.kernel.org/lkml/20201127041404.390276-1-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/stat-display.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/tools/perf/util/stat-display.c b/tools/perf/util/stat-display.c
index 493ec372fdec4..f2709879bad96 100644
--- a/tools/perf/util/stat-display.c
+++ b/tools/perf/util/stat-display.c
@@ -324,13 +324,10 @@ static int first_shadow_cpu(struct perf_stat_config *config,
 	struct evlist *evlist = evsel->evlist;
 	int i;
 
-	if (!config->aggr_get_id)
-		return 0;
-
 	if (config->aggr_mode == AGGR_NONE)
 		return id;
 
-	if (config->aggr_mode == AGGR_GLOBAL)
+	if (!config->aggr_get_id)
 		return 0;
 
 	for (i = 0; i < evsel__nr_cpus(evsel); i++) {
-- 
2.27.0



