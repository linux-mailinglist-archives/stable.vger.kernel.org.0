Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 003513D605E
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:10:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236864AbhGZPV7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:21:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:36408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237249AbhGZPV6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:21:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E15D60240;
        Mon, 26 Jul 2021 16:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315346;
        bh=68cdLtV/VMPdbuQLhHDB61afRsRNxvLIy1SmyOgD5B4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L9S21XT8gWMZO38GfKSy3AfeJmFIEXAfJMVgVfYbBxRTgv18UATCsRQXM/36cL2z2
         48C5ND48OMG8jdIIoU/6Lxu7kZOHKkMeJDp1R2u7vVrz2DAzh5rOZwnZpqCCUUgI8D
         GqiLYphcEyjzjbAD/akOBkJNE2GpN1Lk8NWTvXhg=
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
Subject: [PATCH 5.10 033/167] perf inject: Fix dso->nsinfo refcounting
Date:   Mon, 26 Jul 2021 17:37:46 +0200
Message-Id: <20210726153840.501195475@linuxfoundation.org>
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

[ Upstream commit 0967ebffe098157180a0bbd180ac90348c6e07d7 ]

ASan reports a memory leak of nsinfo during the execution of:

  # perf test "31: Lookup mmap thread"

The leak is caused by a refcounted variable being replaced without
dropping the refcount.

This patch makes sure that the refcnt of nsinfo is decreased when a
refcounted variable is replaced with a new value.

Signed-off-by: Riccardo Mancini <rickyman7@gmail.com>
Fixes: 27c9c3424fc217da ("perf inject: Add --buildid-all option")
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lore.kernel.org/lkml/55223bc8821b34ccb01f92ef1401c02b6a32e61f.1626343282.git.rickyman7@gmail.com
[ Split from a larger patch ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-inject.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index 5320ac1b1285..ec7e46b63551 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -358,9 +358,10 @@ static struct dso *findnew_dso(int pid, int tid, const char *filename,
 		dso = machine__findnew_dso_id(machine, filename, id);
 	}
 
-	if (dso)
+	if (dso) {
+		nsinfo__put(dso->nsinfo);
 		dso->nsinfo = nsi;
-	else
+	} else
 		nsinfo__put(nsi);
 
 	thread__put(thread);
-- 
2.30.2



