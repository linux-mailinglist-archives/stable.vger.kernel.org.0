Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18D7A3D5FA3
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:01:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236046AbhGZPSj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:18:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:56584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236421AbhGZPQq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:16:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EDFDA6056C;
        Mon, 26 Jul 2021 15:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315033;
        bh=eRUNZYO70NbrzZ0scGXxW1b2KNydt1l9KIMLaLws9Rw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=heB3/Ccx3xnOhz/HSr5RFHgy2F1rXibv5I0Zg7CJQ/HGJRF84dCIg85p7ApmJU2I/
         O1NF8LmZYOYdO+1v1VWfVdOaUAIBSpdHKZ/+wtHJku/sqt100+xTQhiZZY20r76uo+
         UbZH/huQDx5n82tnC/H/Ug3GiSfKyx2HLzTe7yME=
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
Subject: [PATCH 5.4 025/108] perf dso: Fix memory leak in dso__new_map()
Date:   Mon, 26 Jul 2021 17:38:26 +0200
Message-Id: <20210726153832.511817937@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153831.696295003@linuxfoundation.org>
References: <20210726153831.696295003@linuxfoundation.org>
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
index ab2e130dc07a..7f07a5dc555f 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -1086,8 +1086,10 @@ struct map *dso__new_map(const char *name)
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



