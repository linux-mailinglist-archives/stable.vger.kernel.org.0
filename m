Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AEA93D616D
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:13:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231689AbhGZPbP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:31:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:42990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237880AbhGZP31 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:29:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2AD52610A2;
        Mon, 26 Jul 2021 16:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315766;
        bh=Hedo5HKbQYAUkvBgWwx/NaD5v9toiTtqhbZniWwZsqg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EWGbsEbvCjTZEYe3OO6ma/pAzl2CN2dDI9hhgG9bh3nmalerxuQsoHEKIYgjlGU1b
         YKkHxgzBzysACDxBOuQEfmsjTd1tF68qZ9tIxkWFcTqiS/EtLNyJxmW2BP0bTZ8aco
         xgUhOBoaSn2kdhvOJ0GO4bEzjWwgDtKSOfFcrTIM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Riccardo Mancini <rickyman7@gmail.com>,
        Ian Rogers <irogers@google.com>, Jiri Olsa <jolsa@redhat.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 058/223] perf env: Fix memory leak of cpu_pmu_caps
Date:   Mon, 26 Jul 2021 17:37:30 +0200
Message-Id: <20210726153848.158926593@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Riccardo Mancini <rickyman7@gmail.com>

[ Upstream commit da6b7c6c0626901428245f65712385805e42eba6 ]

ASan reports memory leaks while running:

 # perf test "83: Zstd perf.data compression/decompression"

The first of the leaks is caused by env->cpu_pmu_caps not being freed.

This patch adds the missing (z)free inside perf_env__exit.

Signed-off-by: Riccardo Mancini <rickyman7@gmail.com>
Fixes: 6f91ea283a1ed23e ("perf header: Support CPU PMU capabilities")
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lore.kernel.org/lkml/6ba036a8220156ec1f3d6be3e5d25920f6145028.1626343282.git.rickyman7@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/env.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/util/env.c b/tools/perf/util/env.c
index f3b90412cc70..16a111b62cc3 100644
--- a/tools/perf/util/env.c
+++ b/tools/perf/util/env.c
@@ -191,6 +191,7 @@ void perf_env__exit(struct perf_env *env)
 	zfree(&env->sibling_threads);
 	zfree(&env->pmu_mappings);
 	zfree(&env->cpu);
+	zfree(&env->cpu_pmu_caps);
 	zfree(&env->numa_map);
 
 	for (i = 0; i < env->nr_numa_nodes; i++)
-- 
2.30.2



