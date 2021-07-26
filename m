Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5CB23D602F
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:02:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236956AbhGZPVN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:21:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:35226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237135AbhGZPVM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:21:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B6C5E60E09;
        Mon, 26 Jul 2021 16:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315300;
        bh=TvVsHlZq1ZRCpVFuf7yyidr2Jm3eg1B1/yVpqe41r7o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1qLsk2Imp22DAQ8hoMvt06OZ28pfS9ERQUyICk0gpwgFxdr/ERZArHjO0rDyDeASn
         50vuyTjS1TbT5PjYy3GAfBlBThJbR87ZE4gqRRIQ/zM/H3N2mH2hxv81RmVEnUwKs0
         f/UBZ1agLvhCGW7Z72/1j2yeroBYteBkvv0T907U=
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
Subject: [PATCH 5.10 043/167] perf script: Fix memory threads and cpus leaks on exit
Date:   Mon, 26 Jul 2021 17:37:56 +0200
Message-Id: <20210726153840.841353924@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153839.371771838@linuxfoundation.org>
References: <20210726153839.371771838@linuxfoundation.org>
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
index 48588ccf902e..2bb159c10503 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -2483,6 +2483,12 @@ static void perf_script__exit_per_event_dump_stats(struct perf_script *script)
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
@@ -3937,6 +3943,7 @@ out_delete:
 
 	perf_evlist__free_stats(session->evlist);
 	perf_session__delete(session);
+	perf_script__exit(&script);
 
 	if (script_started)
 		cleanup_scripting();
-- 
2.30.2



