Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0B18DD21A
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 00:08:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387927AbfJRWIe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 18:08:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:40998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387912AbfJRWIe (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 18:08:34 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 186ED222C2;
        Fri, 18 Oct 2019 22:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436513;
        bh=sn9PuHWrsSWJy+qnRz1rl2QGZbrjTOyXUksthEqa3vc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=peyvUCPT0r28w5MHLBJ2Ljvqa6KYdzgrPbi/VlZ9lNqhinBsWkBhSu145cohnnE9D
         X14HXzhUkwkaqBNnlftMfzzKF+suCtFmot+qmFqOe4MYJPFOYSKMvW32yFsZm1Se+l
         m7SO0CiSV09dp9bPL52a7I1K9XxFgrX/AAkV1kJE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ian Rogers <irogers@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Wang Nan <wangnan0@huawei.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 22/56] perf tests: Avoid raising SEGV using an obvious NULL dereference
Date:   Fri, 18 Oct 2019 18:07:19 -0400
Message-Id: <20191018220753.10002-22-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018220753.10002-1-sashal@kernel.org>
References: <20191018220753.10002-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ian Rogers <irogers@google.com>

[ Upstream commit e3e2cf3d5b1fe800b032e14c0fdcd9a6fb20cf3b ]

An optimized build such as:

  make -C tools/perf CLANG=1 CC=clang EXTRA_CFLAGS="-O3

will turn the dereference operation into a ud2 instruction, raising a
SIGILL rather than a SIGSEGV. Use raise(..) for correctness and clarity.

Similar issues were addressed in Numfor Mbiziwo-Tiapo's patch:

  https://lkml.org/lkml/2019/7/8/1234

Committer testing:

Before:

  [root@quaco ~]# perf test hooks
  55: perf hooks                                            : Ok
  [root@quaco ~]# perf test -v hooks
  55: perf hooks                                            :
  --- start ---
  test child forked, pid 17092
  SIGSEGV is observed as expected, try to recover.
  Fatal error (SEGFAULT) in perf hook 'test'
  test child finished with 0
  ---- end ----
  perf hooks: Ok
  [root@quaco ~]#

After:

  [root@quaco ~]# perf test hooks
  55: perf hooks                                            : Ok
  [root@quaco ~]# perf test -v hooks
  55: perf hooks                                            :
  --- start ---
  test child forked, pid 17909
  SIGSEGV is observed as expected, try to recover.
  Fatal error (SEGFAULT) in perf hook 'test'
  test child finished with 0
  ---- end ----
  perf hooks: Ok
  [root@quaco ~]#

Fixes: a074865e60ed ("perf tools: Introduce perf hooks")
Signed-off-by: Ian Rogers <irogers@google.com>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Wang Nan <wangnan0@huawei.com>
Link: http://lore.kernel.org/lkml/20190925195924.152834-2-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/perf-hooks.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/perf/tests/perf-hooks.c b/tools/perf/tests/perf-hooks.c
index a693bcf017ea2..44c16fd11bf6e 100644
--- a/tools/perf/tests/perf-hooks.c
+++ b/tools/perf/tests/perf-hooks.c
@@ -20,12 +20,11 @@ static void sigsegv_handler(int sig __maybe_unused)
 static void the_hook(void *_hook_flags)
 {
 	int *hook_flags = _hook_flags;
-	int *p = NULL;
 
 	*hook_flags = 1234;
 
 	/* Generate a segfault, test perf_hooks__recover */
-	*p = 0;
+	raise(SIGSEGV);
 }
 
 int test__perf_hooks(struct test *test __maybe_unused, int subtest __maybe_unused)
-- 
2.20.1

