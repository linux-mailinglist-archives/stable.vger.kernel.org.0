Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5ED017F8C0
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 15:22:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730524AbfHBNWR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 09:22:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:60838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393693AbfHBNWQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 09:22:16 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 42A5E20644;
        Fri,  2 Aug 2019 13:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564752136;
        bh=0sQNgAbA3k40cYUsm78R8zzZxIyE2gGXZudo8B3EjzY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n4AiHgIAl99xlwQMNwRxMVr0LVbRTCp4w4d6NyPM9avvD6vnXLuTIGrLaqlBJvjp/
         oUyjRo9u0dUJ0wHjB9r8KU10OgqerN6kwAu5dYdRPbdfdcj+Y2WcaQiKTTbF0l6GVT
         FTqNmdafTWwsYgO6r/Ri40vRsg7y+0b0wBlAxr/8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexey Budankov <alexey.budankov@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.2 55/76] perf session: Fix loading of compressed data split across adjacent records
Date:   Fri,  2 Aug 2019 09:19:29 -0400
Message-Id: <20190802131951.11600-55-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190802131951.11600-1-sashal@kernel.org>
References: <20190802131951.11600-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexey Budankov <alexey.budankov@linux.intel.com>

[ Upstream commit 872c8ee8f0f47222f7b10da96eea84d0486540a3 ]

Fix decompression failure found during the loading of compressed trace
collected on larger scale systems (>48 cores).

The error happened due to lack of decompression space for a mmaped
buffer data chunk split across adjacent PERF_RECORD_COMPRESSED records.

  $ perf report -i bt.16384.data --stats
  failed to decompress (B): 63869 -> 0 : Destination buffer is too small
  user stack dump failure
  Can't parse sample, err = -14
  0x2637e436 [0x4080]: failed to process type: 9
  Error:
  failed to process sample

  $ perf test 71
  71: Zstd perf.data compression/decompression              : Ok

Signed-off-by: Alexey Budankov <alexey.budankov@linux.intel.com>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/4d839e1b-9c48-89c4-9702-a12217420611@linux.intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/session.c | 22 ++++++++++++++--------
 tools/perf/util/session.h |  1 +
 tools/perf/util/zstd.c    |  4 ++--
 3 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 2e61dd6a3574e..d789840960444 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -36,10 +36,16 @@ static int perf_session__process_compressed_event(struct perf_session *session,
 	void *src;
 	size_t decomp_size, src_size;
 	u64 decomp_last_rem = 0;
-	size_t decomp_len = session->header.env.comp_mmap_len;
+	size_t mmap_len, decomp_len = session->header.env.comp_mmap_len;
 	struct decomp *decomp, *decomp_last = session->decomp_last;
 
-	decomp = mmap(NULL, sizeof(struct decomp) + decomp_len, PROT_READ|PROT_WRITE,
+	if (decomp_last) {
+		decomp_last_rem = decomp_last->size - decomp_last->head;
+		decomp_len += decomp_last_rem;
+	}
+
+	mmap_len = sizeof(struct decomp) + decomp_len;
+	decomp = mmap(NULL, mmap_len, PROT_READ|PROT_WRITE,
 		      MAP_ANONYMOUS|MAP_PRIVATE, -1, 0);
 	if (decomp == MAP_FAILED) {
 		pr_err("Couldn't allocate memory for decompression\n");
@@ -47,10 +53,10 @@ static int perf_session__process_compressed_event(struct perf_session *session,
 	}
 
 	decomp->file_pos = file_offset;
+	decomp->mmap_len = mmap_len;
 	decomp->head = 0;
 
-	if (decomp_last) {
-		decomp_last_rem = decomp_last->size - decomp_last->head;
+	if (decomp_last_rem) {
 		memcpy(decomp->data, &(decomp_last->data[decomp_last->head]), decomp_last_rem);
 		decomp->size = decomp_last_rem;
 	}
@@ -61,7 +67,7 @@ static int perf_session__process_compressed_event(struct perf_session *session,
 	decomp_size = zstd_decompress_stream(&(session->zstd_data), src, src_size,
 				&(decomp->data[decomp_last_rem]), decomp_len - decomp_last_rem);
 	if (!decomp_size) {
-		munmap(decomp, sizeof(struct decomp) + decomp_len);
+		munmap(decomp, mmap_len);
 		pr_err("Couldn't decompress data\n");
 		return -1;
 	}
@@ -255,15 +261,15 @@ static void perf_session__delete_threads(struct perf_session *session)
 static void perf_session__release_decomp_events(struct perf_session *session)
 {
 	struct decomp *next, *decomp;
-	size_t decomp_len;
+	size_t mmap_len;
 	next = session->decomp;
-	decomp_len = session->header.env.comp_mmap_len;
 	do {
 		decomp = next;
 		if (decomp == NULL)
 			break;
 		next = decomp->next;
-		munmap(decomp, decomp_len + sizeof(struct decomp));
+		mmap_len = decomp->mmap_len;
+		munmap(decomp, mmap_len);
 	} while (1);
 }
 
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index dd8920b745bce..863dbad878496 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -46,6 +46,7 @@ struct perf_session {
 struct decomp {
 	struct decomp *next;
 	u64 file_pos;
+	size_t mmap_len;
 	u64 head;
 	size_t size;
 	char data[];
diff --git a/tools/perf/util/zstd.c b/tools/perf/util/zstd.c
index 23bdb98845760..d2202392ffdbb 100644
--- a/tools/perf/util/zstd.c
+++ b/tools/perf/util/zstd.c
@@ -99,8 +99,8 @@ size_t zstd_decompress_stream(struct zstd_data *data, void *src, size_t src_size
 	while (input.pos < input.size) {
 		ret = ZSTD_decompressStream(data->dstream, &output, &input);
 		if (ZSTD_isError(ret)) {
-			pr_err("failed to decompress (B): %ld -> %ld : %s\n",
-			       src_size, output.size, ZSTD_getErrorName(ret));
+			pr_err("failed to decompress (B): %ld -> %ld, dst_size %ld : %s\n",
+			       src_size, output.size, dst_size, ZSTD_getErrorName(ret));
 			break;
 		}
 		output.dst  = dst + output.pos;
-- 
2.20.1

