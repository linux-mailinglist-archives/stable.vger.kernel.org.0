Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35E047F428
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 12:05:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391528AbfHBJmZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:42:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:44722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390542AbfHBJmY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:42:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2EE4D20679;
        Fri,  2 Aug 2019 09:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564738943;
        bh=WPH78JG2hGWgUDAQrnFeQz4Vyc83sY9/KeL3HcRRCDY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OVlhB6LI7wRICUEZ3v1wee9jqiQEBPu6JEHKpSJSl0pRJY9b+Ui2OKdxagPPa9I8I
         3C95LF9839ksjTqwenR/1QOZTgPHT0mF6RpN0ZEm9r1aJc8s8Z1s1kD34qoVJ7GXUD
         U2desgCRw8No7wQqVHEngHv/AbUeOd98fnohg7to=
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
Subject: [PATCH 4.9 056/223] perf tools: Increase MAX_NR_CPUS and MAX_CACHES
Date:   Fri,  2 Aug 2019 11:34:41 +0200
Message-Id: <20190802092242.512388192@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092238.692035242@linuxfoundation.org>
References: <20190802092238.692035242@linuxfoundation.org>
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
index 8f8d895d5b74..3b9d56125ee2 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -23,7 +23,7 @@ static inline unsigned long long rdclock(void)
 }
 
 #ifndef MAX_NR_CPUS
-#define MAX_NR_CPUS			1024
+#define MAX_NR_CPUS			2048
 #endif
 
 extern const char *input_name;
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index de9b369d2d2e..283148104ffb 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1008,7 +1008,7 @@ static int build_caches(struct cpu_cache_level caches[], u32 size, u32 *cntp)
 	return 0;
 }
 
-#define MAX_CACHES 2000
+#define MAX_CACHES (MAX_NR_CPUS * 4)
 
 static int write_cache(int fd, struct perf_header *h __maybe_unused,
 			  struct perf_evlist *evlist __maybe_unused)
-- 
2.20.1



