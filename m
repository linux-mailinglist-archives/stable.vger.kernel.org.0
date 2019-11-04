Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED90CEF056
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:28:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387516AbfKDVty (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 16:49:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:41520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387529AbfKDVtx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 16:49:53 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F04CA214D8;
        Mon,  4 Nov 2019 21:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904192;
        bh=6g6nWHd2PQSeh/ENgqqvcAt/oHPGu1a8fUntpIjXp8g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GuVHoPIr8o9brI5QY/PgDd1sigbHCq0YUg6A7QLXnJotDl4Z4mye8wD3VJs4H6jij
         QJ7gMWQQ5RVl24vVaZCOX3pq2rQe6b9yyBDU73+22YKcE3jQyK5NefEt8WL0BLzvvb
         UTxs/XCjujt1PA5Bt52wZU0lX9irISJMlkIAo03E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Steve MacLean <Steve.MacLean@Microsoft.com>,
        Brian Robbins <brianrob@microsoft.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Eric Saint-Etienne <eric.saint.etienne@oracle.com>,
        John Keeping <john@metanate.com>,
        John Salem <josalem@microsoft.com>,
        Leo Yan <leo.yan@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Song Liu <songliubraving@fb.com>,
        Stephane Eranian <eranian@google.com>,
        Tom McDonald <thomas.mcdonald@microsoft.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 14/62] perf map: Fix overlapped map handling
Date:   Mon,  4 Nov 2019 22:44:36 +0100
Message-Id: <20191104211915.653093596@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104211901.387893698@linuxfoundation.org>
References: <20191104211901.387893698@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steve MacLean <Steve.MacLean@microsoft.com>

[ Upstream commit ee212d6ea20887c0ef352be8563ca13dbf965906 ]

Whenever an mmap/mmap2 event occurs, the map tree must be updated to add a new
entry. If a new map overlaps a previous map, the overlapped section of the
previous map is effectively unmapped, but the non-overlapping sections are
still valid.

maps__fixup_overlappings() is responsible for creating any new map entries from
the previously overlapped map. It optionally creates a before and an after map.

When creating the after map the existing code failed to adjust the map.pgoff.
This meant the new after map would incorrectly calculate the file offset
for the ip. This results in incorrect symbol name resolution for any ip in the
after region.

Make maps__fixup_overlappings() correctly populate map.pgoff.

Add an assert that new mapping matches old mapping at the beginning of
the after map.

Committer-testing:

Validated correct parsing of libcoreclr.so symbols from .NET Core 3.0 preview9
(which didn't strip symbols).

Preparation:

  ~/dotnet3.0-preview9/dotnet new webapi -o perfSymbol
  cd perfSymbol
  ~/dotnet3.0-preview9/dotnet publish
  perf record ~/dotnet3.0-preview9/dotnet \
      bin/Debug/netcoreapp3.0/publish/perfSymbol.dll
  ^C

Before:

  perf script --show-mmap-events 2>&1 | grep -e MMAP -e unknown |\
     grep libcoreclr.so | head -n 4
        dotnet  1907 373352.698780: PERF_RECORD_MMAP2 1907/1907: \
            [0x7fe615726000(0x768000) @ 0 08:02 5510620 765057155]: \
            r-xp .../3.0.0-preview9-19423-09/libcoreclr.so
        dotnet  1907 373352.701091: PERF_RECORD_MMAP2 1907/1907: \
            [0x7fe615974000(0x1000) @ 0x24e000 08:02 5510620 765057155]: \
            rwxp .../3.0.0-preview9-19423-09/libcoreclr.so
        dotnet  1907 373352.701241: PERF_RECORD_MMAP2 1907/1907: \
            [0x7fe615c42000(0x1000) @ 0x51c000 08:02 5510620 765057155]: \
            rwxp .../3.0.0-preview9-19423-09/libcoreclr.so
        dotnet  1907 373352.705249:     250000 cpu-clock: \
             7fe6159a1f99 [unknown] \
             (.../3.0.0-preview9-19423-09/libcoreclr.so)

After:

  perf script --show-mmap-events 2>&1 | grep -e MMAP -e unknown |\
     grep libcoreclr.so | head -n 4
        dotnet  1907 373352.698780: PERF_RECORD_MMAP2 1907/1907: \
            [0x7fe615726000(0x768000) @ 0 08:02 5510620 765057155]: \
            r-xp .../3.0.0-preview9-19423-09/libcoreclr.so
        dotnet  1907 373352.701091: PERF_RECORD_MMAP2 1907/1907: \
            [0x7fe615974000(0x1000) @ 0x24e000 08:02 5510620 765057155]: \
            rwxp .../3.0.0-preview9-19423-09/libcoreclr.so
        dotnet  1907 373352.701241: PERF_RECORD_MMAP2 1907/1907: \
            [0x7fe615c42000(0x1000) @ 0x51c000 08:02 5510620 765057155]: \
            rwxp .../3.0.0-preview9-19423-09/libcoreclr.so

All the [unknown] symbols were resolved.

Signed-off-by: Steve MacLean <Steve.MacLean@Microsoft.com>
Tested-by: Brian Robbins <brianrob@microsoft.com>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Eric Saint-Etienne <eric.saint.etienne@oracle.com>
Cc: John Keeping <john@metanate.com>
Cc: John Salem <josalem@microsoft.com>
Cc: Leo Yan <leo.yan@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Song Liu <songliubraving@fb.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom McDonald <thomas.mcdonald@microsoft.com>
Link: http://lore.kernel.org/lkml/BN8PR21MB136270949F22A6A02335C238F7800@BN8PR21MB1362.namprd21.prod.outlook.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/map.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index c662fef95d144..df6892596dc27 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -1,4 +1,5 @@
 #include "symbol.h"
+#include <assert.h>
 #include <errno.h>
 #include <inttypes.h>
 #include <limits.h>
@@ -716,6 +717,8 @@ static int maps__fixup_overlappings(struct maps *maps, struct map *map, FILE *fp
 			}
 
 			after->start = map->end;
+			after->pgoff += map->end - pos->start;
+			assert(pos->map_ip(pos, map->end) == after->map_ip(after, map->end));
 			__map_groups__insert(pos->groups, after);
 			if (verbose >= 2)
 				map__fprintf(after, fp);
-- 
2.20.1



