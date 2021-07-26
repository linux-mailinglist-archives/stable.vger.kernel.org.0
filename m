Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52F863D5F71
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:00:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236954AbhGZPR5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:17:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:52856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235973AbhGZPLt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:11:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1765060F02;
        Mon, 26 Jul 2021 15:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314737;
        bh=YGiG1zbaN7s78JlYIjIGgKaE478aok+ueis9z47kSZc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=buHkBR0MxFJKtlveS6EbgBLs+cEmJpL+VndPp4nMgvJlrVy98STfhRSAQlZvKoXhf
         eRZCel+/E6ifi4oAjyN49MhGa0ssxzPsdvcJMJ4kn/SnaABZMD4/yXqW52Yirju3RA
         69k2G1Xbz6uq9qyif5M9t1lOVAUSohG9DnFIQUIA=
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
Subject: [PATCH 4.19 066/120] perf dso: Fix memory leak in dso__new_map()
Date:   Mon, 26 Jul 2021 17:38:38 +0200
Message-Id: <20210726153834.495395001@linuxfoundation.org>
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

[ Upstream commit 581e295a0f6b5c2931d280259fbbfff56959faa9 ]

ASan reports a memory leak when running:

  # perf test "65: maps__merge_in".

The causes of the leaks are two, this patch addresses only the first
one, which is related to dso__new_map().

The bug is that dso__new_map() creates a new dso but never decreases the
refcount it gets from creating it.

This patch adds the missing dso__put().

Signed-off-by: Riccardo Mancini <rickyman7@gmail.com>
Fixes: d3a7c489c7fd2463 ("perf tools: Reference count struct dso")
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lore.kernel.org/lkml/60bfe0cd06e89e2ca33646eb8468d7f5de2ee597.1626343282.git.rickyman7@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/dso.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index 56f86317694d..1231f3181041 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -1025,8 +1025,10 @@ struct map *dso__new_map(const char *name)
 	struct map *map = NULL;
 	struct dso *dso = dso__new(name);
 
-	if (dso)
+	if (dso) {
 		map = map__new2(0, dso);
+		dso__put(dso);
+	}
 
 	return map;
 }
-- 
2.30.2



