Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC7393D5F63
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:00:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236897AbhGZPRs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:17:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:52856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236758AbhGZPPj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:15:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D394660F94;
        Mon, 26 Jul 2021 15:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314766;
        bh=UZcyCQADeyQPTAfJMrEHLYpFG+W57pzsddQXo1UT9hs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JiLuRV4ZIBxtdWO3dZy2lYWE48DrwK5DNJPkzIwH9Aii3bkrdIvnHy3mtaqyZdU1x
         GsKJgiinBLPAbLU6u36zh0G/2K3Vm2GHD6NMWAVF4icNBAHaL8liDZA29tuxsGMar0
         lzQQR1fPh1LBrjiv4EMfQtkXESGu8JwevQUg2OAc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Riccardo Mancini <rickyman7@gmail.com>,
        Ian Rogers <irogers@google.com>, Jiri Olsa <jolsa@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 067/120] perf script: Fix memory threads and cpus leaks on exit
Date:   Mon, 26 Jul 2021 17:38:39 +0200
Message-Id: <20210726153834.527622411@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153832.339431936@linuxfoundation.org>
References: <20210726153832.339431936@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Riccardo Mancini <rickyman7@gmail.com>

[ Upstream commit faf3ac305d61341c74e5cdd9e41daecce7f67bfe ]

ASan reports several memory leaks while running:

  # perf test "82: Use vfs_getname probe to get syscall args filenames"

Two of these are caused by some refcounts not being decreased on
perf-script exit, namely script.threads and script.cpus.

This patch adds the missing __put calls in a new perf_script__exit
function, which is called at the end of cmd_script.

This patch concludes the fixes of all remaining memory leaks in perf
test "82: Use vfs_getname probe to get syscall args filenames".

Signed-off-by: Riccardo Mancini <rickyman7@gmail.com>
Fixes: cfc8874a48599249 ("perf script: Process cpu/threads maps")
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lore.kernel.org/lkml/5ee73b19791c6fa9d24c4d57f4ac1a23609400d7.1626343282.git.rickyman7@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-script.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 1200973c77cb..5f369d4b08f7 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -2207,6 +2207,12 @@ static void perf_script__exit_per_event_dump_stats(struct perf_script *script)
 	}
 }
 
+static void perf_script__exit(struct perf_script *script)
+{
+	perf_thread_map__put(script->threads);
+	perf_cpu_map__put(script->cpus);
+}
+
 static int __cmd_script(struct perf_script *script)
 {
 	int ret;
@@ -3534,6 +3540,7 @@ out_delete:
 
 	perf_evlist__free_stats(session->evlist);
 	perf_session__delete(session);
+	perf_script__exit(&script);
 
 	if (script_started)
 		cleanup_scripting();
-- 
2.30.2



