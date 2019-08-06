Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3993D83C03
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 23:39:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728435AbfHFVh3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 17:37:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:55212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728430AbfHFVh2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Aug 2019 17:37:28 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E00121881;
        Tue,  6 Aug 2019 21:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565127447;
        bh=a4djyiScQqeYcYWQDIRQUAM0biKXX3DU8s+BDCvoG2g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zkJXA5jjCuSpCGyK0J/pJL+rP7fZUFk3JOTtVgVKtfK70fqlgc0hA0+ZxIxe3T4qR
         yY2Q//jSkNW+yU6KQQvIjYdmBYI8cRalrPHGTa6J/nAccugfu8mHzJ6qW26jcE2+/i
         t9TsnBl+dRctplUF2b5Jm8JtYYMo71k45CscJ3no=
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
        Sasha Levin <sashal@kernel.org>,
        clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 4.9 05/17] perf header: Fix use of unitialized value warning
Date:   Tue,  6 Aug 2019 17:37:02 -0400
Message-Id: <20190806213715.20487-5-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190806213715.20487-1-sashal@kernel.org>
References: <20190806213715.20487-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Numfor Mbiziwo-Tiapo <nums@google.com>

[ Upstream commit 20f9781f491360e7459c589705a2e4b1f136bee9 ]

When building our local version of perf with MSAN (Memory Sanitizer) and
running the perf record command, MSAN throws a use of uninitialized
value warning in "tools/perf/util/util.c:333:6".

This warning stems from the "buf" variable being passed into "write".
It originated as the variable "ev" with the type union perf_event*
defined in the "perf_event__synthesize_attr" function in
"tools/perf/util/header.c".

In the "perf_event__synthesize_attr" function they allocate space with a malloc
call using ev, then go on to only assign some of the member variables before
passing "ev" on as a parameter to the "process" function therefore "ev"
contains uninitialized memory. Changing the malloc call to zalloc to initialize
all the members of "ev" which gets rid of the warning.

To reproduce this warning, build perf by running:
make -C tools/perf CLANG=1 CC=clang EXTRA_CFLAGS="-fsanitize=memory\
 -fsanitize-memory-track-origins"

(Additionally, llvm might have to be installed and clang might have to
be specified as the compiler - export CC=/usr/bin/clang)

then running:
tools/perf/perf record -o - ls / | tools/perf/perf --no-pager annotate\
 -i - --stdio

Please see the cover letter for why false positive warnings may be
generated.

Signed-off-by: Numfor Mbiziwo-Tiapo <nums@google.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mark Drayton <mbd@fb.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Song Liu <songliubraving@fb.com>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/20190724234500.253358-2-nums@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/header.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 693dcd4ea6a38..61e3c482935ad 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -2943,7 +2943,7 @@ int perf_event__synthesize_attr(struct perf_tool *tool,
 	size += sizeof(struct perf_event_header);
 	size += ids * sizeof(u64);
 
-	ev = malloc(size);
+	ev = zalloc(size);
 
 	if (ev == NULL)
 		return -ENOMEM;
-- 
2.20.1

