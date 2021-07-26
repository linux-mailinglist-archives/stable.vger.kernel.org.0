Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B85A3D6175
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:13:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231879AbhGZPb7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:31:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:41244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237901AbhGZP32 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:29:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B9E9B6108E;
        Mon, 26 Jul 2021 16:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315774;
        bh=T/xLmZF0qggl84vt97QjkBJdRndg95IttEb09VIrXuI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TgySqUdu1tUoZs58BfA2xTgc95K+C5u8iLV0y6dby/RWtmHcG6yKVIWrjudAH3xRQ
         W5feH0JnlYXTIBLlLdowBTybR6b8g+ctknRx/zKJPvgnQaCKyZpvgJmrNVqsz9olSB
         587CMbdJmvA0DoP7OOek9m5k6izJtXZHJB/KNvnE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Riccardo Mancini <rickyman7@gmail.com>,
        Ian Rogers <irogers@google.com>, Jiri Olsa <jolsa@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Milian Wolff <milian.wolff@kdab.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 060/223] perf script: Release zstd data
Date:   Mon, 26 Jul 2021 17:37:32 +0200
Message-Id: <20210726153848.221183554@linuxfoundation.org>
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

[ Upstream commit 1b1f57cf9e4c8eb16c8f6b2ce12cc5dd3517fc61 ]

ASan reports several memory leak while running:

  # perf test "82: Use vfs_getname probe to get syscall args filenames"

One of the leaks is caused by zstd data not being released on exit in
perf-script.

This patch adds the missing zstd_fini().

Signed-off-by: Riccardo Mancini <rickyman7@gmail.com>
Fixes: b13b04d9382113f7 ("perf script: Initialize zstd_data")
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Milian Wolff <milian.wolff@kdab.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lore.kernel.org/lkml/39388e8cc2f85ca219ea18697a17b7bd8f74b693.1626343282.git.rickyman7@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-script.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 1280cbfad4db..8a6656ab835b 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -3991,6 +3991,7 @@ out_delete:
 		zfree(&script.ptime_range);
 	}
 
+	zstd_fini(&(session->zstd_data));
 	evlist__free_stats(session->evlist);
 	perf_session__delete(session);
 
-- 
2.30.2



