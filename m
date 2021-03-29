Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6248534CAE2
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:42:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234833AbhC2Ikk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:40:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:34862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234986AbhC2Ijx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:39:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 55F5A60234;
        Mon, 29 Mar 2021 08:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617007184;
        bh=Dk3r0ZdhFIWard0fq8Ye0DQWn4Wqw12Mv55RKxKgo10=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fujiaLyCVtz5Qhi+W3WVDSQWJBl359G9MdgAghFA5F/X/2MXPTHUZzpb0GNsEI1FT
         WdCxBHL4CA2W9snTn21qPDDZZZ8J4hGwwyOrbu2OfcC9TubRhd5FWSetvosOyBRfjz
         YFE/QYukhH7ZW7aZPq+e4YjgsSPhu8ndfSpKPqfk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ian Rogers <irogers@google.com>,
        Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 233/254] perf synthetic events: Avoid write of uninitialized memory when generating PERF_RECORD_MMAP* records
Date:   Mon, 29 Mar 2021 09:59:09 +0200
Message-Id: <20210329075640.747732797@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ian Rogers <irogers@google.com>

[ Upstream commit 2a76f6de07906f0bb5f2a13fb02845db1695cc29 ]

Account for alignment bytes in the zero-ing memset.

Fixes: 1a853e36871b533c ("perf record: Allow specifying a pid to record")
Signed-off-by: Ian Rogers <irogers@google.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lore.kernel.org/lkml/20210309234945.419254-1-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/synthetic-events.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/synthetic-events.c b/tools/perf/util/synthetic-events.c
index 2947e3f3c6d9..dda0a6a3173d 100644
--- a/tools/perf/util/synthetic-events.c
+++ b/tools/perf/util/synthetic-events.c
@@ -384,7 +384,7 @@ int perf_event__synthesize_mmap_events(struct perf_tool *tool,
 
 	while (!io.eof) {
 		static const char anonstr[] = "//anon";
-		size_t size;
+		size_t size, aligned_size;
 
 		/* ensure null termination since stack will be reused. */
 		event->mmap2.filename[0] = '\0';
@@ -444,11 +444,12 @@ int perf_event__synthesize_mmap_events(struct perf_tool *tool,
 		}
 
 		size = strlen(event->mmap2.filename) + 1;
-		size = PERF_ALIGN(size, sizeof(u64));
+		aligned_size = PERF_ALIGN(size, sizeof(u64));
 		event->mmap2.len -= event->mmap.start;
 		event->mmap2.header.size = (sizeof(event->mmap2) -
-					(sizeof(event->mmap2.filename) - size));
-		memset(event->mmap2.filename + size, 0, machine->id_hdr_size);
+					(sizeof(event->mmap2.filename) - aligned_size));
+		memset(event->mmap2.filename + size, 0, machine->id_hdr_size +
+			(aligned_size - size));
 		event->mmap2.header.size += machine->id_hdr_size;
 		event->mmap2.pid = tgid;
 		event->mmap2.tid = pid;
-- 
2.30.1



