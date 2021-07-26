Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AC093D61C5
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:14:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233945AbhGZPc5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:32:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:43048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237879AbhGZP31 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:29:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 98E0F6108D;
        Mon, 26 Jul 2021 16:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315762;
        bh=ohL/9vnVlqBMwG3sxamtHqqALrt+Kx3qPdVqqpGQtdU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=On7a+FPIW1EFTauFKjUTGffVY1B+tdqu7ZyEGS3KVt4lXbfXlD7YSvhfhd7KibrKO
         hBfGFvz8K934x57ExHZfaOm7F0zifTG1Z7yhoVIAbZ+0w7eVZH+/jgYSWoi7wXtFu5
         olHOd6lRrH+VdiwEkGBmgS2L/LI0pVkB7Ifadcfg=
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
Subject: [PATCH 5.13 056/223] perf dso: Fix memory leak in dso__new_map()
Date:   Mon, 26 Jul 2021 17:37:28 +0200
Message-Id: <20210726153848.094541267@linuxfoundation.org>
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
index d786cf6b0cfa..ee15db2be2f4 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -1154,8 +1154,10 @@ struct map *dso__new_map(const char *name)
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



