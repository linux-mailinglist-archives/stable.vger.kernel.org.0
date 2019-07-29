Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9786D7968E
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:53:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390707AbfG2Tw6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:52:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:44904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403809AbfG2Tw6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:52:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BBB4B21773;
        Mon, 29 Jul 2019 19:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429977;
        bh=AdRfg07wYRZs/1CXoKUxgRtQxKpsPAOTu12g9s8NZcA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m8k5+i4FkLIxI66kTEQiLfhb7w0c/wWu/ytGdDHDt71rhwG6Xo8npTdOeuUNm9ejb
         RnSS2mVoNw56pLHvoiZ/euWgl/49LTWQ3kitGpXkdE5NsPlb4SNnc/6PDpSXxk+mEo
         QG36imUx619/1aKEGT4NuxLy3MUXwc1YDTLBEVF4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Numfor Mbiziwo-Tiapo <nums@google.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Ian Rogers <irogers@google.com>, Jiri Olsa <jolsa@redhat.com>,
        Mark Drayton <mbd@fb.com>, Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Song Liu <songliubraving@fb.com>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 119/215] perf test mmap-thread-lookup: Initialize variable to suppress memory sanitizer warning
Date:   Mon, 29 Jul 2019 21:21:55 +0200
Message-Id: <20190729190759.712792229@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190739.971253303@linuxfoundation.org>
References: <20190729190739.971253303@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index ba87e6e8d18c..0a4301a5155c 100644
--- a/tools/perf/tests/mmap-thread-lookup.c
+++ b/tools/perf/tests/mmap-thread-lookup.c
@@ -53,7 +53,7 @@ static void *thread_fn(void *arg)
 {
 	struct thread_data *td = arg;
 	ssize_t ret;
-	int go;
+	int go = 0;
 
 	if (thread_init(td))
 		return NULL;
-- 
2.20.1



