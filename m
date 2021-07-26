Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D1B93D61C8
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:14:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233983AbhGZPc7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:32:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:42680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237867AbhGZP30 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:29:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D021461075;
        Mon, 26 Jul 2021 16:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315744;
        bh=tgmAJeiuI8pkdqUXVgz5iXyd6waZz5MI0hKpsaEgK40=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ifeaZb34/h3BqzNaW4pS44RjbKzwvFEeZaP1ohxCwHRjQSlevnOfbd9RksmaJrIFI
         rrWrBPkhMbALxL3MYV8lJBGQ6f0m5WqyHjUOSjCU5/VvCSKVJzp5GjubUGM6Vv1D3Y
         Xp3yhWFr5+geBGasV/43M+IP8fQTp7N0mp7+S3XI=
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
Subject: [PATCH 5.13 049/223] perf inject: Fix dso->nsinfo refcounting
Date:   Mon, 26 Jul 2021 17:37:21 +0200
Message-Id: <20210726153847.872397585@linuxfoundation.org>
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
index ddccc0eb7390..614e428e4ac5 100644
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



