Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1EFB73894
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 21:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388444AbfGXTa7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:30:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:51360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388433AbfGXTa4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:30:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B856C21951;
        Wed, 24 Jul 2019 19:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563996655;
        bh=3rri1YZONZ3TOLxUQI7fXal6vOj9b7arHk6JSs0kj/8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mUSRIM09mi4A2M1vacUlZM6IKBLsVX8HMWAnz84kV0imMAwaGE8n8oWGBOxq88Wdd
         zyvfQZGj5MmzWRir2nML3vr+XVsmw6ZNzoJpLBIEOH+grGse/ye4kS9EaEk1xk3s79
         nfe8j8O3gCuRT9D5rHIRVC3JSc+s+oWzfbxC0ZkM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kyle Meyer <kyle.meyer@hpe.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 164/413] perf tools: Increase MAX_NR_CPUS and MAX_CACHES
Date:   Wed, 24 Jul 2019 21:17:35 +0200
Message-Id: <20190724191746.787421443@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index d59dee61b64d..a26555baf692 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -26,7 +26,7 @@ static inline unsigned long long rdclock(void)
 }
 
 #ifndef MAX_NR_CPUS
-#define MAX_NR_CPUS			1024
+#define MAX_NR_CPUS			2048
 #endif
 
 extern const char *input_name;
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index fb0aa661644b..b82d4577d969 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1100,7 +1100,7 @@ static int build_caches(struct cpu_cache_level caches[], u32 size, u32 *cntp)
 	return 0;
 }
 
-#define MAX_CACHES 2000
+#define MAX_CACHES (MAX_NR_CPUS * 4)
 
 static int write_cache(struct feat_fd *ff,
 		       struct perf_evlist *evlist __maybe_unused)
-- 
2.20.1



