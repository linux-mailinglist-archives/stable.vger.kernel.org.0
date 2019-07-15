Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADD9069201
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 16:34:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404086AbfGOOd1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 10:33:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:49526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403855AbfGOOd1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 10:33:27 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C046920C01;
        Mon, 15 Jul 2019 14:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563201206;
        bh=f82ynvCW0lw8nat7MlQZFCyVSYis2iY0s7PHaE79Suw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JqPzFiWTVWMV0Hkl5edPI17kppiflzoI01tdvzkt7zsZKKsnfs4WIL9GQiexLofxl
         xrRUonL50jgLcyNHOzLhUGLNsUtxWETX00HEfQXpoEGygIVszcOfJf327LuyugEg2H
         TmF8MuHNBta3uF+3/jco174OaCr9kQgRpw+A8WYY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kyle Meyer <kyle.meyer@hpe.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 078/105] perf tools: Increase MAX_NR_CPUS and MAX_CACHES
Date:   Mon, 15 Jul 2019 10:28:12 -0400
Message-Id: <20190715142839.9896-78-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715142839.9896-1-sashal@kernel.org>
References: <20190715142839.9896-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kyle Meyer <kyle.meyer@hpe.com>

[ Upstream commit 9f94c7f947e919c343b30f080285af53d0fa9902 ]

Attempting to profile 1024 or more CPUs with perf causes two errors:

  perf record -a
  [ perf record: Woken up X times to write data ]
  way too many cpu caches..
  [ perf record: Captured and wrote X MB perf.data (X samples) ]

  perf report -C 1024
  Error: failed to set  cpu bitmap
  Requested CPU 1024 too large. Consider raising MAX_NR_CPUS

  Increasing MAX_NR_CPUS from 1024 to 2048 and redefining MAX_CACHES as
  MAX_NR_CPUS * 4 returns normal functionality to perf:

  perf record -a
  [ perf record: Woken up X times to write data ]
  [ perf record: Captured and wrote X MB perf.data (X samples) ]

  perf report -C 1024
  ...

Signed-off-by: Kyle Meyer <kyle.meyer@hpe.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20190620193630.154025-1-meyerk@stormcage.eag.rdlabs.hpecorp.net
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/perf.h        | 2 +-
 tools/perf/util/header.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 96f62dd7e3ed..d4ebd0956114 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -25,7 +25,7 @@ static inline unsigned long long rdclock(void)
 }
 
 #ifndef MAX_NR_CPUS
-#define MAX_NR_CPUS			1024
+#define MAX_NR_CPUS			2048
 #endif
 
 extern const char *input_name;
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index f11cead6a151..26437143c940 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1122,7 +1122,7 @@ static int build_caches(struct cpu_cache_level caches[], u32 size, u32 *cntp)
 	return 0;
 }
 
-#define MAX_CACHES 2000
+#define MAX_CACHES (MAX_NR_CPUS * 4)
 
 static int write_cache(struct feat_fd *ff,
 		       struct perf_evlist *evlist __maybe_unused)
-- 
2.20.1

