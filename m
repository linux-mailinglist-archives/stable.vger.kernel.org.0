Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6F723D616B
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232597AbhGZPbO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:31:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:41074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237875AbhGZP31 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:29:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2B07A61077;
        Mon, 26 Jul 2021 16:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315751;
        bh=fYLzEZLwoXqP4vdGd7yopIB/wUOyaejLP5SSHXyjdH0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BGynEYW/HAyvhTEYhLHOjPwbN0TFOzl3ktqg84Y5tqCdLq1yW+IvG9yicLU3oGDJ2
         mRYuwDvuXlDrYBcucLocQ3W4jjGGgf6KXvyI3grO1vIag60uVpjJV+m+GHTHwoc61y
         KLoJsEtD5kDtPEFjxG5QbTeDpAaAkjeZHJXz24v4=
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
Subject: [PATCH 5.13 052/223] perf env: Fix sibling_dies memory leak
Date:   Mon, 26 Jul 2021 17:37:24 +0200
Message-Id: <20210726153847.965946631@linuxfoundation.org>
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

[ Upstream commit 42db3d9ded555f7148b5695109a7dc8d66f0dde4 ]

ASan reports a memory leak in perf_env while running:

  # perf test "41: Session topology"

Caused by sibling_dies not being freed.

This patch adds the required free.

Fixes: acae8b36cded0ee6 ("perf header: Add die information in CPU topology")
Signed-off-by: Riccardo Mancini <rickyman7@gmail.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lore.kernel.org/lkml/2140d0b57656e4eb9021ca9772250c24c032924b.1626343282.git.rickyman7@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/env.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/util/env.c b/tools/perf/util/env.c
index bc5e4f294e9e..f3b90412cc70 100644
--- a/tools/perf/util/env.c
+++ b/tools/perf/util/env.c
@@ -186,6 +186,7 @@ void perf_env__exit(struct perf_env *env)
 	zfree(&env->cpuid);
 	zfree(&env->cmdline);
 	zfree(&env->cmdline_argv);
+	zfree(&env->sibling_dies);
 	zfree(&env->sibling_cores);
 	zfree(&env->sibling_threads);
 	zfree(&env->pmu_mappings);
-- 
2.30.2



