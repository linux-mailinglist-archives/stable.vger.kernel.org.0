Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E6436DCA9
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:18:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388342AbfGSEOH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 00:14:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:50162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389539AbfGSEOH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 00:14:07 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A55321882;
        Fri, 19 Jul 2019 04:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563509646;
        bh=LyqcIpqQVtgDziALXcmUJUO8gefcTIwRNGEHPZNzCEU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SZ3CI6bHtmnFVWW4YwEYu5sFhDzSa14D6qV3aBY2pI0tULj1xHLIc9+JGneltb2w+
         S8S7HsvBA5oGM9NDusW6UmAoBSLV7gBFyDw3TcIaMKdnKaJF6BDRwYtW95W/Wlt6So
         8TJa+56f4l7ol3twbjHMW1yvAVILiuSYJLxqrYKM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Numfor Mbiziwo-Tiapo <nums@google.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Ian Rogers <irogers@google.com>, Jiri Olsa <jolsa@redhat.com>,
        Mark Drayton <mbd@fb.com>, Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Song Liu <songliubraving@fb.com>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 35/45] perf test mmap-thread-lookup: Initialize variable to suppress memory sanitizer warning
Date:   Fri, 19 Jul 2019 00:12:54 -0400
Message-Id: <20190719041304.18849-35-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719041304.18849-1-sashal@kernel.org>
References: <20190719041304.18849-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Numfor Mbiziwo-Tiapo <nums@google.com>

[ Upstream commit 4e4cf62b37da5ff45c904a3acf242ab29ed5881d ]

Running the 'perf test' command after building perf with a memory
sanitizer causes a warning that says:

  WARNING: MemorySanitizer: use-of-uninitialized-value... in mmap-thread-lookup.c

Initializing the go variable to 0 silences this harmless warning.

Committer warning:

This was harmless, just a simple test writing whatever was at that
sizeof(int) memory area just to signal another thread blocked reading
that file created with pipe(). Initialize it tho so that we don't get
this warning.

Signed-off-by: Numfor Mbiziwo-Tiapo <nums@google.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mark Drayton <mbd@fb.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Song Liu <songliubraving@fb.com>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/20190702173716.181223-1-nums@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/mmap-thread-lookup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/tests/mmap-thread-lookup.c b/tools/perf/tests/mmap-thread-lookup.c
index 0c5ce44f723f..e5d6e6584001 100644
--- a/tools/perf/tests/mmap-thread-lookup.c
+++ b/tools/perf/tests/mmap-thread-lookup.c
@@ -49,7 +49,7 @@ static void *thread_fn(void *arg)
 {
 	struct thread_data *td = arg;
 	ssize_t ret;
-	int go;
+	int go = 0;
 
 	if (thread_init(td))
 		return NULL;
-- 
2.20.1

