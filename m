Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 646A412C929
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:17:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387747AbfL2SBP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 13:01:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:45900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733060AbfL2R4X (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:56:23 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B58EF206A4;
        Sun, 29 Dec 2019 17:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577642182;
        bh=TiLckMzAfNQuPETWuIcvowggYk5Cx2Zhj9fhQYXKe2E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I/FXCpe1IA4zD6nVHuik26p6ECwOPSqa/hfi4sX2aqOTP46lvVHUG4sdzlLjO8oBx
         I6GHy1UUjZtqxeo6+imUYdhgO92ABpAagvhYJu0OeA+wQz6BxrgxeyjUd6sYer0X33
         uHteaN6IWHfDLLsCUpKm9pXhV0tVvtRD5BC8KmZ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
        Alexey Budankov <alexey.budankov@linux.intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 333/434] perf session: Fix decompression of PERF_RECORD_COMPRESSED records
Date:   Sun, 29 Dec 2019 18:26:26 +0100
Message-Id: <20191229172724.088806796@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexey Budankov <alexey.budankov@linux.intel.com>

[ Upstream commit bb1835a3b86c73aa534ef6430ad40223728dfbc0 ]

Avoid termination of trace loading in case the last record in the
decompressed buffer partly resides in the following mmaped
PERF_RECORD_COMPRESSED record.

In this case NULL value returned by fetch_mmaped_event() means to
proceed to the next mmaped record then decompress it and load compressed
events.

The issue can be reproduced like this:

  $ perf record -z -- some_long_running_workload
  $ perf report --stdio -vv
  decomp (B): 44519 to 163000
  decomp (B): 48119 to 174800
  decomp (B): 65527 to 131072
  fetch_mmaped_event: head=0x1ffe0 event->header_size=0x28, mmap_size=0x20000: fuzzed perf.data?
  Error:
  failed to process sample
  ...

Testing:

  71: Zstd perf.data compression/decompression              : Ok

  $ tools/perf/perf report -vv --stdio
  decomp (B): 59593 to 262160
  decomp (B): 4438 to 16512
  decomp (B): 285 to 880
  Looking at the vmlinux_path (8 entries long)
  Using vmlinux for symbols
  decomp (B): 57474 to 261248
  prefetch_event: head=0x3fc78 event->header_size=0x28, mmap_size=0x3fc80: fuzzed or compressed perf.data?
  decomp (B): 25 to 32
  decomp (B): 52 to 120
  ...

Fixes: 57fc032ad643 ("perf session: Avoid infinite loop when seeing invalid header.size")
Link: https://marc.info/?l=linux-kernel&m=156580812427554&w=2
Co-developed-by: Jiri Olsa <jolsa@kernel.org>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Alexey Budankov <alexey.budankov@linux.intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lore.kernel.org/lkml/cf782c34-f3f8-2f9f-d6ab-145cee0d5322@linux.intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/session.c | 44 ++++++++++++++++++++++++---------------
 1 file changed, 27 insertions(+), 17 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 061bb4d6a3f5..5c172845fa5a 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1954,8 +1954,8 @@ out_err:
 }
 
 static union perf_event *
-fetch_mmaped_event(struct perf_session *session,
-		   u64 head, size_t mmap_size, char *buf)
+prefetch_event(char *buf, u64 head, size_t mmap_size,
+	       bool needs_swap, union perf_event *error)
 {
 	union perf_event *event;
 
@@ -1967,20 +1967,32 @@ fetch_mmaped_event(struct perf_session *session,
 		return NULL;
 
 	event = (union perf_event *)(buf + head);
+	if (needs_swap)
+		perf_event_header__bswap(&event->header);
 
-	if (session->header.needs_swap)
+	if (head + event->header.size <= mmap_size)
+		return event;
+
+	/* We're not fetching the event so swap back again */
+	if (needs_swap)
 		perf_event_header__bswap(&event->header);
 
-	if (head + event->header.size > mmap_size) {
-		/* We're not fetching the event so swap back again */
-		if (session->header.needs_swap)
-			perf_event_header__bswap(&event->header);
-		pr_debug("%s: head=%#" PRIx64 " event->header_size=%#x, mmap_size=%#zx: fuzzed perf.data?\n",
-			 __func__, head, event->header.size, mmap_size);
-		return ERR_PTR(-EINVAL);
-	}
+	pr_debug("%s: head=%#" PRIx64 " event->header_size=%#x, mmap_size=%#zx:"
+		 " fuzzed or compressed perf.data?\n",__func__, head, event->header.size, mmap_size);
 
-	return event;
+	return error;
+}
+
+static union perf_event *
+fetch_mmaped_event(u64 head, size_t mmap_size, char *buf, bool needs_swap)
+{
+	return prefetch_event(buf, head, mmap_size, needs_swap, ERR_PTR(-EINVAL));
+}
+
+static union perf_event *
+fetch_decomp_event(u64 head, size_t mmap_size, char *buf, bool needs_swap)
+{
+	return prefetch_event(buf, head, mmap_size, needs_swap, NULL);
 }
 
 static int __perf_session__process_decomp_events(struct perf_session *session)
@@ -1993,10 +2005,8 @@ static int __perf_session__process_decomp_events(struct perf_session *session)
 		return 0;
 
 	while (decomp->head < decomp->size && !session_done()) {
-		union perf_event *event = fetch_mmaped_event(session, decomp->head, decomp->size, decomp->data);
-
-		if (IS_ERR(event))
-			return PTR_ERR(event);
+		union perf_event *event = fetch_decomp_event(decomp->head, decomp->size, decomp->data,
+							     session->header.needs_swap);
 
 		if (!event)
 			break;
@@ -2096,7 +2106,7 @@ remap:
 	}
 
 more:
-	event = fetch_mmaped_event(session, head, mmap_size, buf);
+	event = fetch_mmaped_event(head, mmap_size, buf, session->header.needs_swap);
 	if (IS_ERR(event))
 		return PTR_ERR(event);
 
-- 
2.20.1



